# __float128 constants' binary128 bits, error-free units, base vs head on the 9700X (#1250, PR #1889)

Raw evidence for [buster14a/buster#1889](https://github.com/buster14a/buster/pull/1889), "Checker: __float128
constants keep their binary128 bits" ([#1250](https://github.com/buster14a/buster/issues/1250)). Its head changes
paths that error-free units run with any floating constant: `check_action_convert_plain` (a `__float128` test before
the floating-to-integer branch), `check_action_fold_floating` (a `__float128` test before the per-format folds),
`check_action_convert_nan` (a NaN's payload truncated to the target's fraction) and the literal-conversion warning.
This checks that error-free `-fsyntax-only` doesn't pay for them.

## Identity

- **Date:** 2026-11-09, by an agent session (Claude Code), each command under `~/buster-fast-bench/exclusive.sh`.
- **Base:** buster main `cb608c1f616f8fe26234bcaaa869caccc571de63`.
- **Head:** `b0eae9330a9de92542bd30a4d27c77274a2bbf7f`, branch `checker/1250-quad-constants` (the PR's first commit).
  The PR's second commit, `7410ff9`, changes only `_Complex __float128` conversions and the `__float128`
  comparison builtins, which neither input reaches.
- **Host:** `benchpress`, AMD Ryzen 7 9700X.
- **Builds:** `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh` in each tree.
- **Inputs:**
  - SQLite's `sqlite3.c` from `~/buster-fast-bench/1296-codex-20261105/corpus/sqlite`, with
    `-w -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0`;
  - the base tree's `src/buster/compiler/main.c` with `-march=native -Isrc -fwrapv -funsigned-char
    -fno-strict-aliasing -Wall -Werror`, run in the base tree for both builds.

## Commands

`run.sh` here clones and builds both trees, then runs the head build's `time-runs` once under the lock, pinned to CPU 2
(`taskset -c 2`): 3 warm-ups and 30 runs of each build and input, in a Williams design's order. `results.txt` holds
its whole output: every run's wall time, rusage, peak resident set, faults, user cycles and instructions, and the
medians.

## Results

Medians of 30 runs:

| `-fsyntax-only` | base | head | head vs base |
|---|---|---|---|
| sqlite3.c, wall | 82.629 ms | 82.719 ms | +0.11% |
| sqlite3.c, user cycles | 375.507 M | 375.206 M | -0.08% |
| sqlite3.c, instructions | 861,507,897 | 861,526,313 | +0.002% |
| main.c, wall | 2159.466 ms | 2153.375 ms | -0.28% |
| main.c, user cycles | 11001.284 M | 10985.963 M | -0.14% |
| main.c, instructions | 27,678,644,010 | 27,684,070,697 | +0.02% |

The peak resident sets are equal to within 132 KiB. The differences are within the runs' spread (sqlite3.c's wall
times run from 81.8 ms to 92.1 ms for base and 81.9 ms to 83.9 ms for head): the change is neutral for error-free
units.
