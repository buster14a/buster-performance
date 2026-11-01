# Tier 1's plan without its redundant verification (buster#141), 2026-11-01

Evidence for the buster pull request "Tier 1: plan the optimizer's verified result without verifying it again"
(buster#141, item 1 of [the claim](https://github.com/buster14a/buster/issues/141#issuecomment-6555203581)).
`tier1_select_plan` ran `ir_verify` on its input, though `ir_optimize` verifies its result before it returns. The new
`tier1_select_plan_verified` gives the same plan without that verification, and the C driver's `--tier1` and
`benchmark-tier1-select-source` call it.

## Revisions and setup

- main: buster `adc1499` (main after buster#998).
- head: buster `4f96651`, one commit on `adc1499`.
- Each tree is `git archive` of its commit, built by `BUSTER_DEBUG_INFO=0 ./build.sh` (`logs-build/`).
- Host: the Ryzen 7 9700X (benchpress). Every build, test and measurement held `~/buster-fast-bench/exclusive.sh` once,
  with owner `claude-141-remaining`, and every timed run was pinned to CPU 2.
- Scripts are in `9700x/`: `common.sh` has the paths, options and lock metadata; `queue-1.log` is the queue's output,
  run as `build.sh`, `tests.sh`, `identity.sh`, `select-compare.sh`, `perf-stat.sh`, then `placements.sh`.
- Inputs:
  - the frozen `sqlite3.c` (`~/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite/sqlite3.c`), with
    `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`;
  - c-testsuite at `5c72756`.

## Correctness on the 9700X (head, `9700x/head-4f96651-tests/`)

| Check | Result |
| --- | --- |
| `test-tier1-select` | 582,260 checks, 0 failures |
| `test-tier1-pipeline --cross-check` | 6,535 checks, 0 failures (1,920 native runs, 960 clang comparisons) |
| `test-tier1-emit` | 223,236 checks, 0 failures |
| `test-tier1-cfg` | 30,338 checks, 0 failures |
| `test-c-testsuite --tier1` on the subset | 220 of 220 pass; Tier 1 compiles 350 of 430 functions |
| `./build.sh check-call-graph` | exit 0 |

`--tier1 -fno-asynchronous-unwind-tables -c` of `sqlite3.c` gives main's object byte for byte at head, by both paths
(`identity.sh`, in `queue-1.log`): 2,030,168 bytes by the vector path, 2,032,008 by `--scalar`.

## Selection's cycles per IR instruction

`benchmark-tier1-select-source --only select|select-scalar` on `sqlite3.c` (`select-compare.sh`). It covers the 2,181
functions both paths select, of 2,668, which are 244,036 IR instructions. Each process reports the medians of 21
passes. There are 3 processes per tree and path, in turn (`9700x/select-compare-head-4f96651/`). Main's command times
`tier1_select_plan`, its verification included. Head's times `tier1_select_plan_verified`. At each revision, that is
what the driver runs.

| Path | Tree | Core cycles per IR instruction, 3 processes | Instructions per IR instruction | ns per IR instruction |
| --- | --- | --- | ---: | --- |
| vector | main | 338.12, 340.29, 340.05 | 821.43 | 61.01, 61.37, 61.33 |
| vector | head | 261.50, 243.44, 241.75 | 575.08 | 47.18, 43.91, 43.60 |
| scalar | main | 340.42, 339.16, 341.76 | 918.26 | 61.43, 61.16, 61.64 |
| scalar | head | 252.59, 249.35, 253.20 | 619.07 | 45.56, 44.97, 45.67 |

By the median process, the vector path goes from 340.05 to 243.44 cycles (−28.4%) and the scalar twin from 340.42 to
252.59 (−25.8%). Head's first vector process (261.50) ran with a throttle of 9.11 per IR instruction, against 7.4 to
7.6 for the others.

## `--tier1 -c sqlite3.c`

**`perf stat`** (`perf-stat.sh`: 11 runs per hold, 3 holds per tree, `9700x/perf-stat-head-4f96651/`):

| Tree | Instructions (user) | Cycles (user) |
| --- | ---: | --- |
| main | 5,015,099,612 to 5,015,099,686 | 1,968.3 M to 1,970.2 M |
| head | 4,897,889,199 to 4,897,889,290 | 1,941.9 M to 1,946.1 M |

Head runs 117.2 M fewer instructions (−2.34%). That is more than the benchmark's functions account for (about 60 M),
because the driver also verified every function that selection then refused. There are 487 of them, `sqlite3VdbeExec`'s
22,900 IR instructions among them.

**Over placements** (`placements.sh`). The checker unit, `main_unit_checker.c`, holds the driver that runs `--tier1`.
Each tree was built at six placements of that unit (0, 640, 1344, 2048, 2752 and 3456 bytes), with three fresh copies of
each. Main ran against itself as the floor. The comparison is `ab` of `time-runs --runs 3 --copies 3`, in 3 rounds
(`9700x/placements-head-4f96651-main_unit_checker/tier1.log`):

| Round | Wall: head against main | Over placements and copies | Main again | User cycles: head against main | Over placements and copies | Main again |
| --- | ---: | --- | --- | ---: | --- | --- |
| 1 | −1.17% | −1.92% to −0.53% | +0.01% (−0.88% to +0.54%) | −1.25% | −2.02% to −0.44% | +0.03% (−0.90% to +0.63%) |
| 2 | −1.18% | −2.07% to −0.53% | +0.02% (−0.92% to +0.58%) | −1.21% | −2.26% to −0.67% | +0.05% (−0.94% to +0.60%) |
| 3 | −1.27% | −1.80% to −0.33% | −0.08% (−0.70% to +0.57%) | −1.36% | −1.99% to −0.35% | −0.04% (−0.76% to +0.53%) |

The median wall time is 377.3 ms to 377.6 ms for main and 372.8 ms to 372.9 ms for head.

## Local checks

These ran in the session's container, an AVX-512 Xeon (`local/`). On head, `test-tier1-select` ran 582,260 checks and
`test-tier1-pipeline --cross-check` ran 6,535, each with 0 failures. `identity-and-c-testsuite.txt` compares main's and
head's `--tier1` objects of `sqlite3.c` (both paths) and of Lua 5.4.8's 34 sources, all identical, and has c-testsuite's
subset by `--tier1` (220 of 220).

## Limitations

- Compile time was measured on one input, `sqlite3.c`. The change only removes work, and its outputs are byte-identical
  to main's, so other inputs gain in proportion to the IR that reaches selection.
- The benchmark's rows time different entry points at main and head on purpose: at each revision, what the driver runs.
- The rest of the pipeline verifies IR more than once too (`ir_optimize` verifies its input and its result, once
  without dominance and once with it). Those verifications are the IR's and the optimizer's, not selection's, and this
  change leaves them alone.
