# The parser's group stacks below depth 0, written by each parse (buster#2086), 2026-11-11

The evidence behind buster branch `claude/parser-k5-scratch-2086` (commit f95c53c78, from main 28653e0f5), which
fixes buster#2086.

## The cause

K2 (`parse_roles_avx512`) reads its group stacks below depth 0: a top-level token's group is the entry at depth -1,
and a block reads the 128 entries below its starting depth. `parse_vector_buffers_reserve` meant to write those
entries (`PARSE_ROLE_NONE`, 0, `PARSE_KIND_END`), but `parse_depth_stack_reserve` returns pointers that already start
at depth 0, so its loop wrote depths 0 to 127 and left the 128 entries below unwritten. (K1's `open_stack` was right:
the loop wrote it through the unoffset pointer.) A fresh scratch reads them as zero, `PARSE_ROLE_NONE`. K2 on a unit
whose brackets don't balance puts openers there (down to depth -64), and a borrowed scratch holds its owner's bytes.
A later unit's top-level tokens then took that group, which changed their roles and statement contexts: on the
issue's units (`results/first.c`, then `results/second.c`), K5 settled the second's statements and K6 flagged 77
tokens.

The fix writes depths -128 to -1 instead, as many entries as before.

## Results

Builds (`results/9700x/results-sha256.txt`; `scripts/*.patch` on main 28653e0f5):

- **base:** main 28653e0f5.
- **repro:** base with the new test, `scripts/repro.patch`, which also carries the temporary sweep (with
  `BUSTER_SWEEP_2086` set, test-parser's units aren't cleared, and each unit is parsed again by four parsers cleared
  before it, which must match) and an experiment: the borrowed-scratch test's dirt as bytes that vary.
- **head-sweep:** the fix, the new test and the sweep (`scripts/head-sweep.patch`).
- **reuse:** the branch (`scripts/final.patch`; the commit differs from it in one comment's wording and the docs).
  **reuse2** is a copy of it, the A/A floor. **clear** is reuse with #2087's per-unit clearing put back
  (`scripts/clear-variant.diff`).

### Reproduction and sweep

| Build | Reused scratch check (2 + 2,000 units) | Sweep without clearing: 37,338 generated units | Repository's 33 units |
|---|---|---|---|
| repro, 9700X | unit 1 (`second.c`) and unit 1487 (stream 1485) differ: fallback 6 items, 101 tokens, 77 flagged, against a fresh parser's 1, 101, 0 | stream 1485 alone, on the vector parser and the vector tree-only parser | |
| repro, local Xeon | the same two units, the same numbers | | |
| head-sweep, 9700X | 0 differ | 0 differences on all four parsers | 0 differences |

Logs: `results/9700x/repro-*.log`, `head-*.log`, `results/local/repro-test-parser.log`.

The varied-dirt experiment didn't catch the bug: the borrowed-scratch test passed on repro with bytes that vary.
A byte at depth -1 changes the outcome only when it names an opener's role whose group rules differ from
`PARSE_ROLE_NONE`'s. It isn't in the branch.

### Correctness on the branch

- **Local Xeon** (AVX-512, vector host; `results/local/summary.txt`): test-parser, `--scalar`, `--clang` (clang
  23.1.6), test-files, `test-files --flat src`, test-lexer and `test-checker-driver --part 1/4 --in-process` passed.
- **9700X:** head-sweep's test-parser and `test-parser --clang` passed.
- `scripts/more.sh` queues on the 9700X the driver test's four parts and `./build.sh check-call-graph` on the
  branch, then a baseline `BUSTER_HOST_ARCH=x86-64` build's test-parser and test-lexer. Its log is
  `~/buster-fast-bench/2086-claude/more.log` there; it hadn't run when this record was written.

### The cost of test-parser's clearing (`results/9700x/results/`, `scripts/measure.sh`, `measure2.sh`)

test-parser without files, one hold of the lock per run, pinned to CPU 2 (time-runs: one warm-up, one timed run):

| Build | Wall | User | System | Peak RSS (wait4) |
|---|---:|---:|---:|---:|
| clear | 5.797 s | 2.516 s | 3.185 s | 346,552 KiB |
| reuse | 5.636 s | 2.545 s | 2.992 s | 421,996 KiB |
| reuse2 (A/A) | 5.684 s | 2.392 s | 3.187 s | 421,220 KiB |

Only round 1 of plain had run when this was written: the lock's queue was long. Dropping the clearing is within the
A/A spread of these runs (5.64–5.68 s against 5.80 s), and keeps about 75 MB more resident (the nesting units'
scratch, which the clearing gave back past 1 MB). The rest of the campaign (rounds 2 and 3, the repository's units,
and base against clear) writes to `~/buster-fast-bench/2086-claude/results/` on the 9700X.

## Machines

- **9700X:** benchpress, AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, CMake 4.4.4, Ninja 1.13.2,
  transparent huge pages always. Release builds by `./build.sh` under the lock (`results/9700x/build-*.log`).
- **Local:** a cloud container, Intel Xeon @ 2.10GHz with AVX-512, 4 CPUs shared with three other sessions'
  builds, Ubuntu clang 23.1.6. Its times aren't measurements.

## Scripts

`ex.sh` runs a command under the lock; `files.sh` runs test-parser on the build's units as
`tools/ci/correctness.tests` does; `measure.sh`, `measure2.sh`, `after-clear.sh` and `more.sh` are the campaigns.
