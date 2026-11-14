# Tier 1 CFG validation from the position column (#1399), 2026-11-13

This is the evidence for [buster#1399](https://github.com/buster14a/buster/issues/1399) and the pull request that follows its comment of 13 November. By Claude, in David's directed session ([the session](https://claude.ai/code/session_01EgbxnedrW1NDHYwyWXdAHP)).

[buster#1509](https://github.com/buster14a/buster/pull/1509) replaced the binary searches #1399 found in Tier 1's edge moves and in emission. This record measures what was left on main, and the change that removes the largest remaining search:
- `tier1_cfg_input_valid` searched `block_starts` once for each value's definition and once for each of its uses.
- Validation now fills the position-to-block column that `tier1_cfg_prepare` already retained, and reads each definition's block from it.
- It checks each use with one compare against its definition's block start: a use at p is in the block [s, t) holding the definition d only if s <= p < t, and d < t, so "elsewhere, or at or after d" is p < s or p >= d.
- The verifier keeps the searches as the oracle.
- Emission's remaining `block_of` calls read the column (`tier1_cfg_block_at`).

## Revisions

| Role | Commit | What |
| --- | --- | --- |
| main | `b7a95eedbe16fbd8434654f192f8f7aab76c56e5` | buster's main when the work began; the base of every measurement |
| head | `beb5de5d9258fec38d584a3bc6e2f8bff9f3c526` | the branch's first commit: validation from the column |
| head2 | `b27b69d8b80cf258eae8a320e44d776fcf7ff01b` | the second: the fill reads each block's bounds before its stores |
| main, later | `437ccbbc3b578d724d86139cc3ffa09e61fef390` | main when buster#2689 merged it |
| merged | `fec9f8d2103614ac7ab62924716f8bf7354a207e` | buster#2689's merge of that main |

## Workload

The frozen corpus's `sqlite3.c` (sha256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`, the file `tools/ci/fetch-corpus.sh` gives), compiled as #1399 did:

```sh
compiler -c -w --tier1 --lanes=1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -I$SQ $SQ/sqlite3.c -o /dev/null
```

On the 9700X, `$SQ` was a copy of that file in another session's directory, which the scripts name. Every compile runs on CPU 2.

## 9700X

**Host** (`9700x/host.txt`): Ryzen 7 9700X, Linux 6.18.50, CPU 2 with governor and EPP `performance`, clang 23.1.1, perf 7.2.9. Compilers were built there by `BUSTER_HOST_ARCH=znver5 ./build.sh` (Release); their hashes are in `9700x/host.txt` and `9700x/raw/ab2.txt`. Each build, test, timed round and profile ran under the host's lock, one `exclusive.sh` call each.

**Scripts** (`scripts/`):
- `setup.sh` clones and builds main, times five compiles and records one profile at 4,999 Hz (`9700x/raw/profile.txt`).
- `prof2.sh` records ten compiles at a fixed period of 200,003 cycles (`9700x/raw/profile2.txt`, and `9700x/raw/srclines.txt` by function and line).
- `ab.sh` builds head and compares its object with main's. It runs six interleaved rounds of `perf stat -r 5` of each binary, order alternating (`9700x/raw/ab.txt`), and records head's profile as `prof2.sh` does (`9700x/raw/srclines-head.txt`). It then runs the tests on head (`9700x/raw/t_*.log`).
- `instr.sh` samples retired instructions every 20,011 of both binaries (`9700x/raw/instr.txt`, `9700x/raw/*.isyms.txt`).
- `ab2.sh` builds head2 and compares its object with main's. It runs six rounds of all three binaries, order rotating (`9700x/raw/ab2.txt`), then two tests on head2 (`9700x/raw/t2_*.log`).
- `ab4.sh` does the same for main `437ccbbc` and the merged head (see "After merging main").

The logs keep only the lines those scripts and the tests print. `exclusive.sh`'s lock messages, which name other sessions' commands and links, were dropped by an allowlist of those line shapes (`scripts/keep_own_lines.py`).

### What was left on main

Ten compiles at 200,003 cycles a sample: 377 ms a compile. The searches' share of all cycles, by the lines of each function (`9700x/raw/srclines.txt`):

| Search | Where | Share |
| --- | --- | ---: |
| `tier1_cfg_block_of` | validation, inlined into `tier1_cfg_prepare` | 0.64% |
| the cursors' forward sweep (#1509) | `tier1_cfg_finish` | 0.35% |
| the block column's walk (`tier1_cfg_interval_at`) | `tier1_emit_cfg_records` | 0.26% |
| a fragment within an interval (`tier1_cfg_interval_fragment`) | `tier1_cfg_finish`, `tier1_emit_cfg_records` | 0.27% |
| a fragment's location (`tier1_cfg_interval_location`) | `tier1_cfg_finish` | 0.18% |
| `tier1_cfg_interval_oracle`, values without a column | `tier1_emit_cfg_records` | 0.19% |
| `tier1_cfg_block_of` | `tier1_emit_cfg_records` | 0.09% |

#1399's report had 14.1% in `tier1_cfg_allocate_impl` and 4.9% in `tier1_emit_cfg_records` on a 466 ms compile. Main's `tier1_cfg_prepare`, `tier1_cfg_finish` and `tier1_emit_cfg_records` were 4.95%, 2.59% and 5.55% (`9700x/raw/profile2.txt`).

### The first commit

The objects were identical. Six rounds (`9700x/raw/ab.txt`):

| | instructions | cycles | task-clock |
| --- | ---: | ---: | ---: |
| base, median | 4,457.88 M | 1,986.16 M | 375.72 ms |
| head, median | 4,458.74 M | 1,966.23 M | 372.04 ms |
| head − base, median of rounds | +0.86 M (+0.019%) | -19.28 M (-0.97%) | -3.56 ms (-0.95%) |
| head − base, each round's cycles | -17.4, -19.1, -8.8, -19.5, -20.1, -26.9 M | | |

Each row is the mean of `perf stat -r 5`; the medians are over the six rounds (`scripts/summarize.py`).

Retired instructions rose by 0.86 M in every round. The sampled instruction profile (`9700x/raw/instr.txt`) is too coarse to place 0.86 M: its per-function differences are within a few M on functions the change doesn't touch. head's cycle profile has no samples left on `tier1_cfg_block_of`'s lines; `tier1_cfg_prepare` went from 4.16% to 3.83% of all cycles by line attribution.

### Callgrind, and the second commit

valgrind can't run the AVX-512 compiler, so `scripts/cg.sh` counted the three trees' baseline builds (`BUSTER_HOST_ARCH=x86-64`, Release) in a cloud container: an Intel Xeon with clang 23.1.6 and valgrind 3.22.0 (`callgrind/totals.txt`). A 64 GiB `ulimit -v` gives the arenas a finite share, which valgrind needs. The three objects are identical.

| | instructions | against main |
| --- | ---: | ---: |
| main | 12,462.83 M | |
| head | 12,461.75 M | −1.08 M |
| head2 | 12,455.90 M | −6.93 M |

By function (`callgrind/delta-base-head1.tsv`, `callgrind/delta-base-head2.tsv`, self cost; the `0x…` rows are unnamed stubs that moved, net zero):
- head: `tier1_cfg_prepare` −0.04 M, `tier1_emit_cfg_records` −0.76 M.
- head2: `tier1_cfg_prepare` −5.89 M, `tier1_emit_cfg_records` −0.76 M.

The first commit's fill compared each position with `block_starts[b + 1]` in its loop's condition. A store to the column may alias `block_starts` as far as clang knows, so it reloaded that bound at every position, which cost what the searches saved. The second commit reads both bounds first, as `tier1_cfg_prepare`'s fill had.

### The second commit on the 9700X

The objects were identical. Six rounds of all three binaries, order rotating (`9700x/raw/ab2.txt`):

| | instructions | cycles | task-clock |
| --- | ---: | ---: | ---: |
| base, median | 4,457.88 M | 1,985.03 M | 375.15 ms |
| head, median | 4,458.74 M | 1,972.48 M | 372.65 ms |
| head2, median | 4,453.73 M | 1,968.83 M | 372.50 ms |
| head − base, median of rounds | +0.86 M (+0.019%) | -13.62 M (-0.69%) | -2.41 ms (-0.64%) |
| head − base, each round's cycles | +6.0, -14.1, -19.7, -13.1, -14.8, -2.6 M | | |
| head2 − base, median of rounds | -4.15 M (-0.093%) | -16.40 M (-0.83%) | -2.62 ms (-0.70%) |
| head2 − base, each round's cycles | -19.2, -12.0, -27.2, -13.6, -26.3, -8.8 M | | |

head2 retires 4.15 M fewer instructions than main, where head retired 0.86 M more. Both save cycles in this run; head2 does in every round. The gap between head and head2's cycles (3.7 M by the medians) is within the rounds' spread.

### After merging main

buster#2689 merged main `437ccbbc3b578d724d86139cc3ffa09e61fef390` as `fec9f8d2103614ac7ab62924716f8bf7354a207e`. Main's 3e92c492 had changed `tier1_cfg_prepare` beside this change. `scripts/ab4.sh` built both in fresh trees named for their commits, with `--config Release`: `build.sh` now defaults to Develop and stages CI's toolchain, clang 23.1.4. It then ran six rounds of the two, order alternating (`9700x/raw/ab4.txt`), and `test-tier1-cfg` on the merged head (`9700x/raw/t4_tier1-cfg.log`: 111,798 checks, 0 failures). The objects were identical.

| | instructions | cycles | task-clock |
| --- | ---: | ---: | ---: |
| main `437ccbbc`, median | 5,319.66 M | 2,353.70 M | 441.36 ms |
| merged `fec9f8d2`, median | 5,312.49 M | 2,324.33 M | 435.99 ms |
| difference, median of rounds | −7.17 M (−0.135%) | −30.11 M (−1.28%) | −5.59 ms (−1.27%) |
| each round's cycles | −25.8, −30.1, −33.5, −30.1, −39.1, −27.2 M | | |

`scripts/summarize.py` computed this table from `ab4.txt`, with `main-437ccbbc` renamed `base` and `merged-fec9f8d2` renamed `head2`. Main's own compile is slower here than `b7a95eed`'s (441 ms against 375 ms): this run differs in the toolchain and in main's 77 later commits. Neither is measured apart.

## Tests

On the 9700X, on head (`9700x/raw/ab.txt`, `9700x/raw/t_*.log`), each passed with 0 failures:
- the self-check (`-fsyntax-only -Wall -Werror` of `main.c`);
- `test-tier1-cfg`: 109,522 checks;
- `test-tier1-emit`: 299,080 checks;
- `test-tier1-pipeline --cross-check`: 9,510 checks;
- `test-tier1-cfg-source --simd` on CI's five SIMD files: 24 functions;
- `test-tier1-cfg-source` on the frozen sqlite3.c with CI's options: 2,602 functions, 0 disagreements between the paths;
- `test-check-lanes`: 7,628 checks;
- `test-tier1-select`: 1,061,542 checks;
- `test-tier1-allocation`: 78,171 allocations' certificates.

On head2 (`9700x/raw/t2_*.log`): `test-tier1-cfg`, 109,522 checks, and `test-tier1-emit`, 299,080 checks, 0 failures.

In the container (Develop and baseline builds): `test-tier1-cfg`, `test-tier1-emit`, and `test-tier1-cfg-source` on c-testsuite's 220-file subset, 0 failures.

Three mutants of the change, in the container. Each was killed:
- the column's rule without `p < s`: `test-tier1-cfg`'s new comparison fails;
- `p <= s`: the same;
- a column whose labels are off by one at blocks' starts: the test crashes.

## Limitations

- Single-lane compiles only, as #1399's report measured. The change runs on the function lanes, as the rest of Tier 1's per-function work does.
- The lock was contended: rounds waited minutes for each hold, and the load average was 2 to 5 from other sessions' work outside the lock (each round's `ps` and `/proc/loadavg` lines).
- Callgrind's counts are of baseline builds, whose scalar paths differ from the 9700X's vector paths elsewhere in the compiler; the validation code is the same scalar code in both.
