# Dataflow's deletion (#2924, C3): main `aa09d1a04` against head2 `f0f50131f`

Head2 is #2951's head (`b9400e212`: the sweep search, the #2950 fixes) plus the deletion of the scalar twins. Built
from a bundle, Release, on the 9700X; every run under the lock, pinned to CPU 2 ([`run.sh`](run.sh),
[`objects.sh`](objects.sh)). Main's executable is [`../c-dataflow-pr-2951/`](../c-dataflow-pr-2951/)'s.

## The objects: byte-identical

`-c` of sqlite3.c, Lua 5.4.8's 34 units and musl's 1,336 units, by main and head2, compared byte by byte
(`logs/objects-compare-*.txt`):

| Mode | Objects | Differ |
| --- | --- | --- |
| default | 1,371 | 0 |
| `--scalar` | 1,371 | 0 |

`--scalar` mode runs Tier 1's scalar twins, which on main called the scalar solver and now call the AVX-512 one.

## Whole compiles: no change

Median of 9 runs (`logs/time.log`):

| List | Wall: head2 | Wall: main-again | User cycles: head2 | User cycles: main-again |
| --- | --- | --- | --- | --- |
| `-c` sqlite3.c | −0.04% | −0.11% | +0.20% | −0.02% |
| `-fsyntax-only` sqlite3.c | +0.04% | −0.10% | +0.54% | +0.55% |
| `-c` Lua | −0.21% | −0.11% | −0.09% | −0.12% |
| `-c` musl | +0.23% | +0.29% | +0.39% | +0.28% |

## `benchmark-dataflow` and IR dataflow

- **Frozen checks:** with seed 1 the benchmark checks every workload's rows digest and sweep count against the values
  frozen from the twin-checked runs, and all pass. Seed 2 runs on the equations alone (`logs/bench-head2-seed2.log`).
- **AVX-512, ns per solve, main → head2 (each process's median):**
  - small-diamond: 49.2 / 49.4 / 49.1 → 35.6 / 35.4 / 35.6;
  - the rows-loop workloads: within 0.4%.
- **IR dataflow on sqlite3.c's 7,806 forms, the vector path's cycles summed:**

  | Operation | #2951's head | head2 | Change |
  | --- | --- | --- | --- |
  | prepare + solve | 77.26 M | 73.58 M | −4.8% |
  | solve | 3.38 M | 3.26 M | −3.7% |

## The executables

`logs/compare.txt` compares by function name:
- **Removed:** 6 functions, among them the scalar solver and `ir_dataflow_solve_scalar`.
- **Renamed:** 3 (`dataflow_test_solve`, `ir_dataflow_prepare`, `dataflow_benchmark_solve`).
- **Changed code, 19 functions:**
  - the dataflow functions;
  - the callers whose solver call lost its scalar arm (Tier 1's `tier1_cfg_prepare`, `tier1_liveness_build`, `tier1_emit_*`), and the inlining around them;
  - the IR dataflow test and benchmark.
- **Different but not changed:**
  - 181 others differ at the same length: rip-relative offsets of 4 hex digits or fewer, which the comparison doesn't normalize.
  - `check_program_target_clones` and `check_program_target_parse` read as different lengths only because the comparison keys functions by name and each unity unit has its own static copy. `objdump --disassemble` of the name prints the same code in both executables.

No function moved into or out of `.text.buster_start` (`logs/head2-sections.txt`, `logs/head2-functions.txt`).
