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
