# #2995's quadratic shapes and #2720's scalar floating folds, 2026-11-20

Evidence for [buster14a/buster#3189](https://github.com/buster14a/buster/pull/3189) (#2995: runs of attribute groups and
case labels, typeof and `_Generic` chains in linear time) and
[buster14a/buster#3188](https://github.com/buster14a/buster/pull/3188) (#2720: Tier 1 SCCP folds exact scalar floating
operations and conversions). One 9700X session measured both.

## 9700X (`9700x/`)

`run.sh` is the script that ran it, from `~/buster-fast-bench/2995-2720-claude/` as `run.sh BASE BRANCH_2995 BRANCH_2720`.
It built three trees, each under the lock in a hold of its own (`env BUSTER_DEBUG_INFO=0 ./build.sh --config Release`). It
then ran `time-runs` three times, each in a hold of its own, on CPU 2 (`taskset -c 2`). `COMMITS` has the trees:
main `8a1b1a03`, #3189's `053eaf71` and #3188's `4cfe6f0f`. #3189's later commit `74f1c97` adds a driver test unit alone.
The `exclusive.sh: waiting` lines at the top of a file are its wait for another session's hold, not part of the run.

- `shapes.txt`: #2995's four fixed shapes at 10,000 and 40,000, `-c -w`, 5 runs and 1 warm-up a build. The generator is
  in `run.sh`, the issue's own.
- `sqlite-2995.txt`: `-c sqlite3.c` (the frozen corpus's, with its pinned predefines), 11 runs, main against #3189.
- `sqlite-2720.txt`: `--tier1 -c sqlite3.c`, 11 runs, main against #3188.

| `-c -w` (median wall, ms) | main | #3189 | main's user cycles | #3189's |
| --- | ---: | ---: | ---: | ---: |
| 10,000 attribute groups on a declaration | 152.735 | 6.849 | 839.0 M | 30.2 M |
| 40,000 | 2,358.415 | 26.227 | 13,044.4 M | 119.9 M |
| 10,000 case labels on one statement | 50.219 | 4.291 | 266.2 M | 15.0 M |
| 40,000 | 745.727 | 15.726 | 4,106.9 M | 58.7 M |
| 10,000 nested `_Generic` | 10.250 | 6.339 | 42.7 M | 21.7 M |
| 40,000 | 81.056 | 21.250 | 411.7 M | 85.0 M |
| 10,000 nested `typeof` | 53.608 | 2.455 | 290.0 M | 6.8 M |
| 40,000 | 828.982 | 6.576 | 4,581.2 M | 23.4 M |

| ordinary compiles (median of 11) | main | head | wall | user cycles | instructions |
| --- | ---: | ---: | ---: | ---: | ---: |
| `-c sqlite3.c`, #3189 | 119.236 ms | 119.306 ms | +0.06% | -0.23% | 1,331.16 M to 1,331.36 M |
| `--tier1 -c sqlite3.c`, #3188 | 611.038 ms | 611.098 ms | +0.01% | +0.02% | 8,083.20 M to 8,087.47 M |

## Cloud container (`cloud/`)

An Intel Xeon with full AVX-512, no PMU. These are not timings.

- `corpus-compare.sh OLD NEW OUT`: `-c -Wall -Wextra` of sqlite3.c, the compiler's own `main.c` and musl's 1,355 units by
  two builds, objects and stderr compared. For main `ab94be4` against #3189's final code it printed `units=1357 diffs=0`.
- `count2720.sh OUT`: `--tier1 -c` of sqlite3.c, speedtest1.c, Lua 5.4.8's 34 sources and musl's 1,355 units by main and #3188.
  Per object it prints scalar floating instructions (objdump), `.text` bytes and whether the objects are identical:
  `tier1-float-counts-2720.tsv` (name, main's, #3188's, main's `.text`, #3188's, same).
  - All 1,391 objects: 27 differ, all musl math or complex units. Scalar floating instructions go from 3,093 to 3,050
    and `.text` from 2,497,353 to 2,497,240 bytes.
  - sqlite3.c, speedtest1.c and Lua are identical, so their run times can't move.
