# Tier 1's emit areas: the twins deleted (#2924, C7, third slice)

Branch `c7b2`: base `8229500bd` (#2965's head, the selection's slice), head `a3b71ac3e` (tests `774df4e73`, deletion
`b5cd396d7`, docs). The gate is in [`../c-tier1-gate/`](../c-tier1-gate/): each of the emit options' areas read at or
above its vector path's ticks with the scalar twin (liveness 1.04, the straight line's allocation 1.003, the
rematerialization marks 1.05, the records 1.00, the CFG problem 1.04, its allocation 1.0002 alone and 1.02 with the
preference, its records 1.01), with byte-identical objects.

## The 9700X, base against head ([`run.sh`](run.sh), [`logs/`](logs/))

Release, every run under the lock, timings on CPU 2, every benchmark process from a fresh copy of its executable.

- **Tests by head:** `test-tier1-allocation`, `-cfg`, `-emit`, `-liveness` and `test-tier1-pipeline --cross-check`
  pass.
- **Objects**, every compile in one directory: `--tier1 -c` of sqlite3.c, Lua and musl, 1,371 of 1,371 identical;
  `--tier1 -g -c`, 1,362 of 1,362 identical (both refuse the same units, #2870 and #2963).
- **`benchmark-tier1-cfg-source` on sqlite3.c**, each variant alone (`--only`), three processes each, cycles and
  instructions an IR instruction:

  | Variant | Base | Head | Instructions, base → head |
  | --- | --- | --- | --- |
  | `cfg` (the CFG allocation) | 771.0 to 773.1 | 765.5 to 768.8 (−0.6%) | 2,553.9 → 2,551.8 |
  | `intervals` (the interval allocator) | 289.8 to 292.0 | 289.7 to 290.9 | 1,101.1 → 1,099.5 |

- **`benchmark-tier1-allocation`**, ns an interval, three processes each (base's vector row):

  | Workload | Base | Head |
  | --- | --- | --- |
  | tiny-fit | 16.73 to 16.91 | 16.14 to 16.77 |
  | small-fit | 12.34 to 12.59 | 12.00 to 12.33 |
  | large-fit | 10.64 to 10.77 | 10.65 to 10.75 |
  | large-pressure | 25.39 to 25.44 | 24.33 to 24.76 |

- **`benchmark-tier1-select --only vector`**, the `complete` phase (selection, liveness, allocation, frame, fragments,
  branch sizing, encoding), ns an IR instruction, three processes each: `chain` 116.8 to 117.2 against 118.5 to 119.2,
  `wide` 98.3 to 99.9 against 98.9 to 101.6, `pressure` 162.3 to 163.1 against 161.5 to 162.1.
- **Whole compiles** ([`logs/time.log`](logs/time.log)): `ab`, three rounds, around `time-runs` (3 runs, 3 copies)
  of base, head and base again, `--tier1 --lanes 1`. User cycles against base, round by round:

  | Compile | Head | Base again | User instructions, head against base |
  | --- | --- | --- | --- |
  | sqlite3.c | +0.08%, −0.05%, +0.04% | +0.09%, −0.02%, +0.08% | −3.14 M (−0.04%) |
  | Lua's units | −0.19%, −0.29%, −0.19% | +0.12%, −0.06%, −0.00% | −0.93 M (−0.04%) |

  Head reads at or below base-again in every round on both, and retires fewer instructions.

## Locally (AVX-512 Xeon)

- `test-tier1-allocation`, `-cfg`, `-emit`, `-liveness`, `-select`, `-masks`, `-wide`, `-frame`, `-model`,
  `-schedule`, `-pipeline`, `test-check-debug`, and `test-tier1-cfg-source` on c-testsuite's 220 programs, pass.
- The tier1-problem harness (`tests/tier1-problem/test.c` with `-DBUSTER_TP_INTEGRATION`, and `report.c` on the seeds
  with drawn.yml's two greps) passes.
- All 220 of c-testsuite's single-exec programs give byte-identical objects, base against head, under `--tier1`,
  `--tier1 -g` and `--tier1 --tier1-schedule=post`.
- The complete driver's parse and its `-Wall -Werror` self-check of `main.c` pass; the unity ownership check passes;
  the Release build compiles the benchmarks.

## Mutants ([`mutation/`](mutation/))

[`mutants.py`](mutation/mutants.py) breaks the vector code that stays: the fixed-range filter's cross product and
sweep, the liveness adapter's dense compaction and row builder, the rematerialization marks' table, the call-save rows'
helpers, the calls before each position, the CFG column's set check, the move resolver's scratch check and the select
requests' batch. [`run.py`](mutation/run.py) runs `test-tier1-allocation`, `-cfg`, `-liveness`, `-select`, `-emit` and
`-masks` on an archive of the tree.

Two rounds:

- **Round `final`**, on the deletion's tree (head `a3b71ac3e`): 9 of 11 killed. Two survived, each a refusal no case
  reached:
  - `m1`, lane 7 of the indexed move resolver's scratch check: no test gave the resolver a move from or to the scratch
    register.
  - `v1`, lane 15 of `tier1_cfg_column`'s check that each bound definition lies in its value's set:
    `tier1_cfg_input_valid`'s condition, which the column's callers never break (`tier1_cfg_preferred` puts a bound
    definition's registers in its set).

  Commit `67b656ded` adds their cases: the scratch in each move's source and then its destination, of 6 moves and of
  24; and, in each case of two problems, its first 48 values one at a time with a register outside its class's or a
  definition bound outside its set, against the preferred problem's own column, which stands.
- **Round `pr2`**, the two survivors on the deletion's tree with those cases ([`mutation/pr2.results`](mutation/pr2.results)):
  `m1` killed by `test-tier1-allocation`, `v1` by `test-tier1-cfg`.
