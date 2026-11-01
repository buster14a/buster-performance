# The checker's store-to-load round trips (buster#873, buster#1037)

Evidence for [buster#1037](https://github.com/buster14a/buster/pull/1037), which takes the two patterns that
[#873's hand-off](https://github.com/buster14a/buster/issues/873#issuecomment-6556359685) placed with
`ls_bad_status2.stli_other` samples, and the review's third:

- `check_const_append` (`c_check_const_values.c`): each trie node is built as a 64-bit word, not a stack copy written
  4 bytes at a time and reread 8; the object and the buffer are copied out without wide loads over narrower stores;
- `check_initializer_live_writes` (`c_check_init_live.c`) and `check_initializer_live` (`c_check_initializer.c`):
  their radix sorts run a pass only over a digit in which some offset differs from the first one's, and none when the
  offsets are in order already.

Sources: buster main `0d79975f` (the pull request's fork point) against `0d28da0e` (the first two changes),
`4d5a43d4` (the address candidates' sort and wording) and `210cd580` (a docs word; the same code). The input is the
frozen `sqlite3.c` of corpus `preprocessor-391e729af658` (sha256 `0a409f16…`), with the pinned predefines and headers
(`--predefines provenance/gnu17-pinned-predefines.txt --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc`
and the corpus's three `-isystem` directories), `SOURCE_DATE_EPOCH=1792454400`.

## On the 9700X (`logs/9700x`)

Run [41323628283](https://github.com/buster14a/buster/actions/runs/41323628283) of the self-hosted runner
`buster-zen5-9700x`, 2026-11-01 16:54–16:57 UTC, dispatched from the short-lived branch `claude/873-zen5-ab` (`b1178004`), whose workflow was
`scripts/9700x-ab.yml` alone. The runner's job hooks held the shared host lock for the job. AMD Ryzen 7 9700X, kernel
6.18.50-2-lts, perf 7.2.9, the official clang 23.1.4 that `setup-benchpress.sh` stages. Main (`0d79975f`) and the head
(`210cd580`) built with `BUSTER_DEBUG_INFO=0 ./build.sh shifts DIR main_unit_checker.c 0 704 1408 2048 2752 3456`
(wild; the checker's unit's `.text` is aligned to 64 here). Executables (sha256): main `afb6fba6…`, the head
`06c04d53…`; the shifted copies in `logs/9700x/job.log`. Every timed process ran on CPU 2. The raw output is
`logs/9700x/job.log`, and `counters.txt` its counter lines. The first dispatch (run 41320497450) stopped at the build:
its shifts of 688 and 2,064 bytes aren't multiples of 64.

- **Objects.** Main's and the head's `-c` objects are identical (`d9c563be…`; the local ones, `e8a0ccd1…`, name the
  source by the container's path to the corpus).
- **Counters** (`perf stat`, 10 rounds, the builds' order alternating by round, one process each; medians, with each
  build's range):

  | `sqlite3.c` | main | head | change |
  | --- | ---: | ---: | ---: |
  | `-c` user cycles | 616.0M (614.6–625.9) | 602.8M (599.2–607.5) | −2.15% |
  | `-c` user instructions | 1,379.79M | 1,347.54M | −2.34% |
  | `-c` `ls_bad_status2.stli_other` | 6.374M (6.01–6.69) | 5.221M (5.06–5.42) | **−18.1%** |
  | `-c` `ls_stlf` | 79.55M | 77.60M | −2.44% |
  | `-c` task-clock | 130.6 ms | 128.2 ms | −1.85% |
  | `-fsyntax-only` user cycles | 486.5M (482.5–489.7) | 475.1M (472.4–478.7) | −2.35% |
  | `-fsyntax-only` user instructions | 1,076.75M | 1,045.47M | −2.90% |
  | `-fsyntax-only` `stli_other` | 5.641M (5.52–6.13) | 4.594M (4.38–4.72) | **−18.6%** |
  | `-fsyntax-only` `ls_stlf` | 64.09M | 62.02M | −3.22% |
  | `-fsyntax-only` task-clock | 105.9 ms | 103.7 ms | −2.11% |

  No range overlaps the other build's. A build's instructions differ by at most 71 between its processes.
- **Where the conflicts were** (`perf record -e ls_bad_status2.stli_other:u -c 1009`, three `-c` compiles per build):
  in main, `check_initializer_live_writes` took 8.70% of the samples and `check_const_append` 6.44%, 15.1% together;
  in the head, neither is among the 45 functions listed (down to 0.41%). Three functions appear in the head's list and
  not main's: `check_initializer_plan_warnings` 0.98%, `check_init_append` 0.67% and `check_init_walk` 0.54%, about
  0.34M of the head's 15.66M events over three compiles against the 2.9M main's two functions had. Samples land some
  instructions past their event, so these shares are approximate.
- **Stages** (`--time-stages`, 11 rounds of `-c`, alternating; medians in ms): `check-declarations`, where the
  initializers are checked, 3.673 → 1.896 (−1.777, −48%); `check-input` 57.135 → 56.897 (−0.24); `static-data`
  0.465 → 0.426; `publish-data` 0.426 → 0.387; every other stage within its spread; the total 130.744 (130.35–131.49)
  → 128.370 (127.89–129.08), −2.37 ms (−1.82%).
- **Whole drivers over placements and copies** (#509's method: `ab --rounds 2` of `time-runs --runs 3 --copies 2`,
  six placements per build and main's again as the floor):

  | Against main | `-fsyntax-only` user cycles | wall | `-c` user cycles | wall |
  | --- | ---: | ---: | ---: | ---: |
  | head, round 1 | −2.29% (placements −3.14 to −1.21) | −1.95% | −1.82% (−2.48 to −1.54) | −1.59% |
  | head, round 2 | −2.56% (−3.44 to −1.79) | −1.92% | −2.11% (−2.51 to −1.43) | −1.75% |
  | main again, round 1 | +0.19% (−0.73 to +1.00) | −0.04% | +0.25% (−0.56 to +0.50) | +0.11% |
  | main again, round 2 | +0.12% (−0.71 to +0.65) | +0.18% | −0.27% (−0.76 to +0.43) | −0.11% |

  The head's ranges over placements exclude 0 in both rounds, both lists and both measures; main's against itself
  include it.

Against #1037's prediction, made before any of this: instructions −2.6% to −2.9% (measured −2.34% for `-c`, −2.90%
for `-fsyntax-only`), `stli_other` −10% to −13% (measured −18%), cycles −1% to −2% (measured −1.8% to −2.6%),
`ls_stlf` slightly lower (−2.4% to −3.2%).

## Local evidence (`logs/local`): an Intel Xeon cloud container, no hardware counters

A cloud container (an Intel Xeon with AVX-512, 4 CPUs, no PMU events), Ubuntu clang 23.1.5, builds with
`BUSTER_DEBUG_INFO=0 ./build.sh`. None of it is a timing or a Zen 5 counter.

- **Exactness** (`scripts/compare.sh`, `logs/local/compare-main-head.log`): main's and `4d5a43d4`'s native executables
  give the same bytes, standard output, standard error and exit status for 1,564 compiles: `sqlite3.c` with `-c`,
  `--scalar -c`, `-g -c`, `--lower-all -c` and `-Wall -fsyntax-only`; `sqlite3.c` with the 9700X's `measure-compile`
  options (the container's headers) and `shell.c`; the frozen musl's 1,337 `src/*/*.c` files with the correctness
  list's musl options; and c-testsuite's 220 programs at `5c72756`. Every compile succeeded.
- **Passes** (`logs/local/passes.txt`, `scripts/passes-*.gdb`): gdb breakpoint hit counts on `sqlite3.c`'s `-c`.
  `check_initializer_live_writes`' 4,231 sorts ran all 33,848 passes in main, 4,370 with the digit skip alone and 158
  with it and the order check; 4,023 of them sort a single write's two ends. `check_initializer_live`'s 104 sorts of
  two or more address candidates ran 832 passes in main and none at `4d5a43d4`. `check_const_append` runs 2,006
  times.
- **Instructions** (`logs/local/callgrind-*`): callgrind on baseline builds (`BUSTER_HOST_ARCH=x86-64`, whose
  totals include the scalar emulation of the vector paths), `--lanes 1`, under `ulimit -v` of 120 GiB so that the
  arenas take their bounded shapes (valgrind can't map the default 64 GiB reservations). Main (`9a25cdec…`)
  5,964,442,607; `4d5a43d4`'s code (`adba18bf…`) 5,924,789,960, −39.65M (−0.66%). Inclusive:
  `check_initializer_live_writes` 43,942,970 → 5,326,598; `check_initializer_live` 3,703,824 → 2,376,964;
  `check_const_append` 4,006,727 → 4,292,519 (about 4.5 more instructions per depth without BMI2, for no stack
  round trip). Both objects are the native build's bytes (`e8a0ccd1…`).

## Limitations

- The 9700X's whole-driver comparison is two rounds of six placements and two copies; its floor is main against
  itself in the same rounds. Cycles on the 7940HS were too noisy to read (the review's).
- `stli_other` samples land some instructions past the event, so a function's share is approximate; the counts per
  process are exact.
- The local container's numbers are a different machine and build (baseline host ISA for callgrind); they show what
  work was removed, not what it costs on Zen 5.
