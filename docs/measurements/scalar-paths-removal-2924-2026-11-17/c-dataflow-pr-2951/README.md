# #2951 on the 9700X: main `aa09d1a04` against head `b9400e212`

[`run.sh`](run.sh) ran on the 9700X: Release builds of both, every run under the lock, pinned to CPU 2.

- **`benchmark-dataflow`:** three alternating processes each (`logs/bench-*.log`).
- **On the head:**
  - `test-dataflow`, `test-ir-source --dataflow-self-test`;
  - IR dataflow's benchmark on sqlite3.c (`logs/ir-sqlite-head.log.xz`), whose scalar twin is the comparison.
- **Whole compiles:** `-c` and `-fsyntax-only` of sqlite3.c, `-c` of Lua 5.4.8 and musl's 1,336 units, with `ab` around
  `time-runs` (main, head, main-again; `logs/time.log`).
- **The executables:**
  - disassembly compared function by function (`logs/compare.txt`; `disassembly/` has the scripts; the 150 MB JSON files are not kept);
  - the head's sections and functions (`logs/head-*.txt`).

## `benchmark-dataflow`, AVX-512, ns per solve (each process's median)

| Workload | Main | Head | Main's scalar twin |
| --- | --- | --- | --- |
| small-diamond | 49.0 / 48.9 / 49.0 | 36.5 / 35.5 / 35.7 | 77.4 |
| mid-sparse-nested | (not in main) | 135.4 / 136.5 / 136.3 | |
| mid-sparse-diamond | (not in main) | 278.6 / 279.6 / 277.6 | |
| medium-nested | 3,762 / 3,668 / 3,680 | 3,681 / 3,686 / 3,772 | 10,521 |
| large-local | 440,459 / 440,034 / 441,181 | 441,921 / 441,671 / 443,453 | 1,314,813 |
| large-dispatch | 256,457 / 256,439 / 256,956 | 257,132 / 257,516 / 260,325 | 773,884 |

The last three take the loop for rows wider than one vector, which #2951 doesn't change; their medians are within 0.4%.

## IR dataflow on sqlite3.c (the head; vector against its scalar twin)

Solve 0.584, prepare + solve 0.601, summed over 7,806 forms, as run 6 of [`../dataflow-2950/`](../dataflow-2950/) found.

## Whole compiles, median of 9 runs, head and main-again against main

| List | Wall: head | Wall: main-again | User cycles: head | User cycles: main-again |
| --- | --- | --- | --- | --- |
| `-c` sqlite3.c | −0.04% | +0.20% | −0.36% | −0.05% |
| `-fsyntax-only` sqlite3.c | +0.05% | −0.40% | +0.32% | +0.07% |
| `-c` Lua | −0.02% | −0.04% | +0.20% | +0.34% |
| `-c` musl | −0.12% | −0.31% | −0.16% | −0.27% |

Every head figure is within main-again's distance from main: no change in whole compiles.

## The executables

9,934 functions each. 24 differ:
- the dataflow and IR dataflow functions themselves, and their tests and benchmarks;
- the callers that inline the solver's dispatcher (`ir_optimize_gvn`, `dominators_analyze`, `ssa_construct_vector`, Tier 1's `tier1_cfg_prepare`, `tier1_liveness_build`, `tier1_emit_*`), which gained its early return for empty matrices;
- `dominators_scalar`, `tier1_select_need_values`, `ir_verified_test_case` and `ir_source_tests_command`, from inlining around the same calls.

No function moved into or out of `.text.buster_start`. The dataflow functions are outside it on main too.
