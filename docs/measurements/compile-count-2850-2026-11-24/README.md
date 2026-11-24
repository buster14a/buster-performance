# #2850 on 2026-11-24: main read on the 9700X, and its instructions against the baseline

Records of the session that claimed the pre-merge instructions check of
[buster14a/buster#2850](https://github.com/buster14a/buster/issues/2850)
([claim](https://github.com/buster14a/buster/issues/2850#issuecomment-7130772588)). Everything under `9700x/` is the
9700X (`benchpress`) under the lock, one lane on CPU 2, the frozen `sqlite3.c` with the 9700X job's options
(`-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`). `scripts/` has
what ran, each one hold of the lock.

## Main's instructions against the stated baseline (`9700x/main-ef3d4475f/`)

`tools/ci/compile-instructions.txt` stated 1,279,713,338 user instructions (main `90bb2d83`, 2026-11-23, #3471), and
the 9700X job's last step fails a run whose count is more than 0.5% from it.

| build | revision | user instructions, median | against 1,279,713,338 |
| --- | --- | ---: | ---: |
| the job's own, on its 9700X run 45381090551 | `fd12fac5` (a branch whose base is 91 commits behind main) | 1,273,235,371 | -0.506%, **the step failed** |
| `scripts/main-count.sh`: built on the 9700X as the job builds it (`BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0`) | main `ef3d4475f` | 1,274,733,397 | -0.389% |
| built in a cloud container with the same settings and shipped (`main-16ccdccd/`) | main `16ccdccd` | 1,271,150,776 | -0.669% |

- Main's own count is inside the band with 0.11% left below it. Main's merges since the baseline moved it there; no
  single one is identified here.
- The third row isn't the job's count: the executable is linked statically, so a build made on another machine carries
  that machine's C library. The two rows are also 35 commits apart, and the 0.28% between them isn't divided between
  the two causes here. Only a build made on the 9700X can be held to the file.
- buster14a/buster's baseline moves to 1,274,733,397 with this record (the pull request names it).

`measure.txt` is `measure-compile --runs 3 --instructions-baseline`; `build.log` the build (70.3 s for 43 units).

## Main at `16ccdccd`, with and without `--node-bodies` (`9700x/main-16ccdccd/`)

`scripts/main-state.sh`: one warm-up, `measure-compile --runs 7`, then five `--time-stages` runs of each setting,
alternating. The executable is the container's build (above), so its instructions aren't the job's; its times are the
9700X's.

- The default compile: **112.73 ms** (112.06 to 113.29), 545.9 M user cycles, 244 MB peak.
- The object is the same with `--node-bodies` (`cmp.txt`), which takes 1,752 of 2,674 bodies and 174,408 tokens.

| `--time-stages`, ms, medians of 5 | plain | `--node-bodies` | |
| --- | ---: | ---: | ---: |
| preprocess | 9.447 | 9.518 | +0.071 |
| parse | 4.834 | 4.779 | -0.055 |
| check-input | 41.799 | 69.861 | +28.062 |
| check-expressions | 11.246 | 8.058 | -3.188 |
| check-declarations | 2.124 | 1.727 | -0.397 |
| check-program | 23.075 | 17.884 | -5.191 |
| select | 0.991 | 0.928 | -0.063 |
| lower | 11.559 | 10.670 | -0.889 |
| tier0 | 3.585 | 3.613 | +0.028 |
| total | 112.337 | 130.576 | +18.239 |

The option still costs 18 ms more than it saves: the producer adds 28 ms to the reader and the pipeline's later
stages give back 9.8.

## The count before a merge (`count/`, `mutants/`)

Hosted runners count no instructions, so the pre-merge check
([specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7116632319)) counts another way: the sum
of the region counters that the compiler built with clang's `-fprofile-instr-generate` writes after one `-c` of the
frozen `sqlite3.c`. Everything here ran in a cloud container (4 CPUs, Intel Xeon at 2.10 GHz) with CI's clang 23.1.4,
the corpus's headers and predefines, on one lane. `count/sums.txt` has every count below.

| what was asked | answer |
| --- | --- |
| Is it the same from run to run? | Of 32 runs, 27 repeat their executable's count to within 3 and 5 are lower by 315 to 1,105 of 315 million; one more, whose profile wasn't kept, read 1,476 lower (0.0005%). |
| Does it depend on the build's optimization? | No: `-O0` and `-O1` builds of main `16ccdccd` both count 315,115,704. The `-O0` build takes 27 s (87 s of CPU), the `-O1` build 211 s. |
| On the host target? | No: a `native` build of main `ef3d4475f` counts 315,170,857 and the explicit vector target's 315,170,858. |
| On the directory, the environment, address randomization? | By 2 counts. |
| On the lanes? | Yes: without `--lanes 1` on 4 CPUs it counts 309,004,327 (-1.9%), so the check pins one lane. |
| What does the process's start cost? | An empty unit counts 413,762 and a one-function unit 5,387,397 (1.7%): the tables a real executable has baked, which the instrumented one builds. |
| Does it see #3381, the regression the check was asked for? | Yes: its merge `94ec1ca8c` counts 344,377,491 against its parent's 321,096,842, **+7.25%** (the instructions rose 7.0%), and the one-function unit's count is 5,352,606 on both. |

The specification's third prediction (more than 5% at #3381) holds. Its first (runs within 0.01%, refuted past 0.05%)
holds here at 0.0005% and is still to be read on hosted runners; its second (under 12 hosted minutes) is the hosted
step's to show: here the two builds take 28 s each and the six compiles 1 s each.

- `count/build-count.sh` and `count/sum.py` are the first builds' script and reader, before buster's
  `tools/ci/compile-count.sh` and `tools/ci/compile-count.c` existed; the later rows are those tools'.
- `count/small.c` and `count/small.profraw` are the 17-line program and the 368-byte raw profile its clang 23.1.4
  build wrote, which the reader's self-test holds as its real file: 15 counts.
- `mutants/run.py` changes the reader, the verdict and the script one place at a time and runs
  `tests/ci/compile-count.sh` on each copy; `mutants/result.txt` is its last run, 77 of 77 killed. Its first run left
  10 alive, each a test the fixtures lacked (two bounds, the spread's boundary, a low run, a statement as long as its
  base's, the lane option, a stale profile, a stale object, a counter that wraps the sum) or a branch the code didn't
  need, which is gone.

## What the default warnings cost (`9700x/warnings-ef3d4475f/`, `warnings/`)

The count's raw profile also says where the compile's work goes, function by function (`count/by-function.txt`, read
by `count/byfunc.py`): it is flat, the largest function `type_kind` at 3.6% (11.3 million calls, 16 a token). Taken
again with `-w`, it says what the warnings that are on by default add, on a unit that prints none
(buster14a/buster#1340):

| the frozen `sqlite3.c`, main `ef3d4475f` | default | `-w` | the default warnings |
| --- | ---: | ---: | ---: |
| wall on the 9700X, medians of 4 x 5 runs in ABBA order | 112.58 ms | 101.01 ms | **11.6 ms, 10.3%** |
| user cycles | 546.4 M | 483.5 M | 62.9 M |
| user instructions | 1,274.7 M | 1,135.8 M | 138.9 M, 10.9% |
| region counts (the container's `-O0` build) | 315,170,780 | 273,827,975 | 41,342,805, 13.1% |

- The object is the same with and without `-w` (`cmp.txt`), and neither compile prints a diagnostic. The 9700X rows
  are `scripts/main-w.sh`, one hold, with the job's own build of `ef3d4475f`.
- `warnings/by-function.txt` is the difference by function, all 603 of them: the first is 6.4% of it, the first 45
  hold 75%. `check_common_edge_slot`, `check_common_edges_reach`, `check_common_candidate_bits`,
  `check_common_root_frames` and `check_common_own_reach` lead.
- By how often the code runs for the warnings, 16% of the counts are in regions that run 200,000 times or more (loops
  over every node or token), 46% in regions that run 50,000 to 200,000 times (a root, a statement or a candidate at a
  time, 238 regions) and 37% below that. So what is left is mostly work a candidate at a time, not whole-unit scans.
- A compile with `-Wno-return-type` was to give that group's share. It failed: the option makes the compiler reject
  every array's decay to a pointer (buster14a/buster#3559).
