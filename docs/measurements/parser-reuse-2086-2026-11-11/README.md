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
- **9700X, `scripts/more.sh` on the branch (`results/9700x/more.log`):** `test-checker-driver` parts 1, 2 and 4
  (`--in-process`), `./build.sh check-call-graph`, and a baseline `BUSTER_HOST_ARCH=x86-64` (scalar host) build with
  its test-parser and test-lexer passed. Part 3 reported 6 failures (`final-checker-driver-3.log`). The two shown in
  full are clang's objects, not the parser's: the host's clang is 23.1.1 where the reference expects 23.1.4, and its
  objects for the file-scope assembly CFI case carry `__stack_chk_fail`, which the expected clang's don't. Main wasn't
  run against it there. Hosted CI, with the pinned clang, passed on the branch merged with main (7d26db5c1).
- **9700X, the 256-stream trim (`scripts/trim-256.patch`, commit 1d2f21c4c; `scripts/v2.sh`):** the build,
  test-parser and `test-parser --clang` passed, each with "reused scratch: 258 units on one parser, against a fresh
  parser's scratch, 0 differ". `test-parser --scalar` reported the same 0 differences but failed in the driver's
  address-space check: "an invalid file: a run in a child gave status 1 and [the expected message] (peak
  1013965189120)", the status and text equal to the in-process run's, so the child wasn't counted clean or `VmSize`
  read 0. The trim doesn't touch that check. Its rerun on the same build passed (`v2-test-parser-scalar-2.log`, status 0),
  so that failure didn't reproduce.

### The cost of test-parser's clearing and of the new check (`results/9700x/results/`, `scripts/measure.sh`, `measure2.sh`)

One hold of the lock per run, pinned to CPU 2 (time-runs: one warm-up, one timed run), three rounds, the order
rotating from round to round. **base** is main 28653e0f5, which clears (#2087) and lacks the new check.

test-parser without files:

| Build | Wall, per round | Instructions | Peak RSS (wait4) |
|---|---|---:|---:|
| base | 5.435, 5.459, 5.422 / 5.457 s | 44.475 G | 346,620 KiB |
| clear | 5.797, 5.726, 5.702; 5.708, 5.702, 5.772 / 5.728 s | 45.843 G | 346,552 KiB |
| reuse | 5.636, 5.615, 5.624 s | 45.686 G | 421,996 KiB |
| reuse2 (A/A) | 5.684, 5.641, 5.680 s | 45.686 G | 421,220 KiB |

test-parser `--files-only` on the repository's 33 translation units (`results/units.txt`, the host flags):

| Build | Wall, per round | User | System | Peak RSS (wait4) |
|---|---|---:|---:|---:|
| clear | 6.402, 6.409, 6.414 s | 5.52–5.61 s | 0.80–0.88 s | 1,426,396–1,434,880 KiB |
| reuse | 6.213, 6.201, 6.213 s | 5.55–5.67 s | 0.54–0.64 s | 1,800,908–1,808,448 KiB |
| reuse2 (A/A) | 6.207, 6.205, 6.186 s | 5.59–5.61 s | 0.57–0.61 s | 1,796,248–1,805,388 KiB |

`measure2.sh`'s round 3 holds two runs for each build (the figures after the slash): a stale copy of the script
and its relaunch both ran it. Every run is its own hold of the lock.

What they settle:

- **The new check's cost.** clear against base is the reused scratch check over 2 + 2,000 streams: about 270 ms of
  5.44 s (+1.37 G instructions, 3%; 5% of the wall time). Nearly all of it is the 2,000 streams, each parsed twice;
  the issue's two units alone catch #2086. The branch now checks 2 + 256 (`scripts/trim-256.patch`), about an eighth
  of that.
- **#2087's clearing, release included.** Without it, the 33 units ran 200 ms (3%) faster, the difference all
  system time (refaulting the pages the release gave back), at a 1.80 GB peak against 1.43 GB; without files, 80 ms
  faster at 422 MB against 347 MB. The branch keeps it out, release too: the released pages came back zero, as a
  fresh parser's scratch, which is what hid #2086, and the peak is the test harness's, not the compiler's.

## Limits

- One timed run per build per round, three rounds; the A/A pair (reuse, reuse2) spreads by up to 60 ms without files
  and 20 ms on the units.
- The 256-stream count's cost wasn't measured; it is scaled from the 2,000-stream run.
- The release-only variant (#2087's `MADV_DONTNEED` for scratch over 1 MB, without the clearing) wasn't built; the
  clearing's memset is user time, which barely differs, so it would cost about what clear does.
- The driver test's part 3 failures weren't run against main on the 9700X, nor was the `--scalar` driver failure,
  which passed on a rerun.

## Machines

- **9700X:** benchpress, AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, CMake 4.4.4, Ninja 1.13.2,
  transparent huge pages always. Release builds by `./build.sh` under the lock (`results/9700x/build-*.log`).
- **Local:** a cloud container, Intel Xeon @ 2.10GHz with AVX-512, 4 CPUs shared with three other sessions'
  builds, Ubuntu clang 23.1.6. Its times aren't measurements.

## Scripts

`ex.sh` runs a command under the lock; `files.sh` runs test-parser on the build's units as
`tools/ci/correctness.tests` does; `measure.sh`, `measure2.sh`, `after-clear.sh` and `more.sh` are the campaigns.
`m2wait.sh` started `measure2.sh` once `more.sh` was done; `v2.sh` built and tested the 256-stream trim.
