# Develop's units by the previous stage (BUSTER_SELF_BUILT), #2630 step 2, 2026-11-23

[buster#2630](https://github.com/buster14a/buster/issues/2630)'s step 2, the stage 1 design's lever 6 as a build
setting: `BUSTER_SELF_BUILT=tests` has Develop compile its eleven test and tool units with the tree's Release
executable at `--tier1`. The PR is [buster#3456](https://github.com/buster14a/buster/pull/3456). The setting found a
Tier 1 miscompile, [buster#3424](https://github.com/buster14a/buster/issues/3424), fixed by
[buster#3432](https://github.com/buster14a/buster/pull/3432), whose fix every executable here carries.

## The trees

- **9700X** (`~/buster-fast-bench/2630-claude/src`): main `9e1eb52f`, #3432's fix and the setting (the PR's code;
  its later commits change `tools/ci/build_regression.c` and the docs). `native`, CI's clang 23.1.4 (build.sh's staged
  toolchain), eight jobs. `tools/ci/build_regression.c` was replaced by the PR's, with the ownership fix, before the
  inventory's blocks ran.
- **Cloud** (a 4-CPU Intel Xeon container): the same code, for the whole correctness inventory.

## Build times (9700X, each build its own hold of the lock)

`results/9700x/builds/results.tsv` (`scripts/step.sh`), medians; "off" is Develop without the setting, "tests" with
`BUSTER_SELF_BUILT=tests`. The previous stage (Release) was built once before, in its own hold.

| Build | off | tests |
| --- | ---: | ---: |
| Clean Develop (3 each) | 31.9 s (32.5, 31.9, 31.7) | 27.7 s (27.7, 27.7, 26.9) |
| Nothing changed | 0.04 s | 0.03 s |
| A function appended to `differential.c` (the backend's unit alone; 2 each) | 6.55 s | 2.86 s |
| ... to `x86_64_encoder.c` (12 units) | 14.75 s | 14.17 s |
| ... to `tier0.c` (the checker's and the backend's units) | 14.17 s | 13.84 s |
| ... to `c_check_input.c` (the checker's unit alone, clang's either way) | 15.65 s | 15.33 s |

Each edit was put back (a copy with a new time) and rebuilt, untimed, before the next. The `--lanes 1` variant
(`lanes1`, in `builds.sh`) was left out for the lock's contention: its runs never started.

## Run times (9700X)

`results/9700x/tests/` (`scripts/tests.sh`, two rounds a list, each its own hold): the stage 1 design's 21 test
commands and seven more whose code is in the `tests` units, by copies of the off and tests Develop executables
(`results/9700x/copies.log.out`). Every run passed (status 0).

- The 16 commands whose code the previous stage compiled: 18.0 s off, 19.05 s tests (+5.8%). Among them `test-tier0`
  3.74 → 4.65 s, `test-branch-sizing` 1.08 → 1.47 s, `test-x86-encoder` 2.38 → 2.58 s, `test-assembler` 0.36 →
  0.44 s; and `test-ssa` 2.70 → 2.10 s and `test-ir` 0.048 → 0.031 s faster: Develop compiles the tests' own functions
  optnone with clang, and Tier 1 optimizes them.
- The other 12: 49.5 s both.

The compile path (`time-runs`, 11 runs a list, CPU 2, `results/9700x/runtime.log.out`):

| | off | tests |
| --- | ---: | ---: |
| `-c sqlite3.c` (frozen corpus): user cycles | 556.9 M | 555.8 M (-0.19%) |
| ... instructions | 1,310,280,722 | 1,310,280,677 |
| `-fsyntax-only` of `main_unit_checker.c`: user cycles | 9,709 M | 9,706 M (-0.04%) |

## The correctness inventory by the hybrid

- **Cloud** (`results/inventory-cloud/`, `scripts/inventory-cloud.sh`): 165 blocks in 3 shards, the hybrid as the
  runner. All pass but those `summary.txt` judges: the ownership check (fixed in #3456; it read every unit's record
  from its clang compile), and the container's own tools (binutils 2.42's GNU as relaxation in `test-assembler` and
  `test-branch-sizing`, which the clang-built Release fails there too; no perf; no Tcl; the disassembler against GNU
  tools).
- **9700X** (`results/9700x/inventory/`, `scripts/inventory2.sh`): those six blocks, by the hybrid in its tree with
  the fixed ownership check, in one hold: all pass.

## Why `tests` (`results/cross-unit-references.txt`)

`nm` of the Release objects: the compile path's units (the driver's, the front end's, the dynamic PIEs' and the
checker's) reference from the `tests` units only their command entries (`main_unit_x86` and the others),
`run_floors_*`, `run_emission_metadata_tests` and `cc_compat_target_feature_emission`, which the checker's driver
compatibility test calls.

## Also here

- `results/build-regression-self-built-cloud.log`: `build-regression --self-built-only` on the PR's branch.
- `scripts/`: every script; `run.sh` and `builds.sh` were the first campaign, stopped while they waited for the lock
  and replaced by `run2.sh`/`builds2.sh` (fewer holds), then `run3.sh` (the rest, without `lanes1`).
