# Dominators' deletion (#2924, C4): base `295417ae7` against head `c6eb0abe7`

Head is the deletion commit on its base, main after #2951: SEMI-NCA and the scalar loop bodies are dominators' one
implementation; the AVX-512 bit-matrix solver, the vector loop sweep and the path option are gone. The gate is
[`../c-dominators-gate/`](../c-dominators-gate/). Both built from a bundle, Release, on the 9700X; every run under the
lock, timings on CPU 2 ([`run.sh`](run.sh), [`objects.sh`](objects.sh)).

## Correctness on the 9700X

- `test-dominators` passes (`logs/test-dominators.log`).
- `test-ir-source --dominators-cfg` on sqlite3.c: head analyzes each of the 7,806 CFG forms twice and checks the first
  result against the whole definition, loop bodies included, up to `sqlite3VdbeExec`'s 1,577 blocks: all pass
  (`logs/export.log`).

## The objects: byte-identical

`-c` of sqlite3.c, Lua 5.4.8's 34 units and musl's 1,336 units, by base and head, compared byte by byte
(`logs/objects-compare-*.txt`):

| Mode | Objects | Differ |
| --- | --- | --- |
| default | 1,371 | 0 |
| `--scalar` | 1,371 | 0 |

Base's default took the vector loop sweep where its matrices fit, and `--scalar` the scalar path; head takes the
scalar loop bodies in both.

## Whole compiles: no change

`ab` around `time-runs`, three rounds of 9 runs each (`logs/time.log`); user cycles against base:

| List | Head, by round | Base-again, by round |
| --- | --- | --- |
| `-c` sqlite3.c | +0.14%, +0.00%, +0.03% | +0.11%, +0.25%, +0.23% |
| `-fsyntax-only` sqlite3.c | +0.21%, −0.33%, −0.04% | +0.03%, −0.52%, +0.22% |
| `-c` Lua | −0.13%, +0.28%, +0.16% | +0.19%, +0.41%, +0.15% |
| `-c` musl | +0.20%, −0.07%, +0.04% | +0.02%, +0.33%, +0.03% |

Instructions are equal to within a few hundred per compile: the analysis is a small part of a compile.

## `benchmark-dominators --cfg` on sqlite3.c's export

Median of three processes, ns per block (`logs/cfg-*.log`). `base-scalar` is base's `--only scalar`, `base-auto` its
default; head has the one path.

| Set | Outputs | Base-scalar | Base-auto | Head | Head / base-auto |
| --- | --- | --- | --- | --- | --- |
| all 7,806 | tree | 27.60 | 27.89 | 27.55 | 0.988 |
| all 7,806 | all | 46.45 | 48.71 | 46.09 | 0.946 |
| 512–1,024 blocks | all | 26.39 | 30.58 | 25.34 | 0.829 |
| 1,024–2,048 blocks | all | 24.83 | 29.16 | 24.82 | 0.851 |

Every bucket's tree is within ±2.5% of base's. With every output, head is 4–17% faster than base's default in every
bucket, and within ±4% of base's scalar path.

## Synthetic shapes

Base's `--only scalar` against head, three processes each (`logs/synthetic-*.log`). Head is faster or equal on most
rows (0.89–1.00). Two read slower:
- `nested`, analysis, tree: 15.9 → 17.9 ns per block. Head's three processes read 15.4, 17.9 and 18.0; the pipeline
  phase of the same shape reads 0.98.
- `dispatch`, pipeline, loops: 46.9 → 52.3, in all three processes; analysis loops +1.2%, pipeline tree ±0,
  pipeline all −1.4%.

**Experiment ([`experiment/`](experiment/)):** main's harness left a second analysis (its vector oracle) in the output
arena before timing; head's leaves one. One executable, head plus [`pad.patch`](experiment/pad.patch) (experiment
only: `BUSTER_DOMINATOR_BENCHMARK_PAD` leaves a second analysis there), three processes each way:
- The pad moves no row by more than its spread (padded / unpadded, 0.975 to 1.051).
- The same executable reads `dispatch` pipeline loops at 48.3, 51.2 and 47.8 ns unpadded, and 55.1, 50.8 and 46.8
  padded: that row's spread from process to process covers both base's 46.9 and head's 52.3.
- `nested` analysis tree reads 18.0, 15.6 and 15.5 unpadded, bimodal again.

Neither row is the deletion's: the code they time is the same SEMI-NCA and loop walk as base's scalar path.

## The executables

`logs/compare.txt` compares by function name:
- **Removed:** `dominators_vector`; `dominators_scalar`, now `dominators_semi_nca` inlined into `dominators_analyze`;
  `run_dominator_tests`, now inlined into its unit's `main_command`, a test-command dispatcher outside the start
  section.
- **Added:** `dominator_benchmark_set_sample` out of line.
- **Changed length:** `dominators_analyze`, the callers that stopped choosing a path (the optimizer's passes, the IR
  lowering, SSA's preparation, the IR validator, Tier 1's CFG preparation) and the inlining around them, and the
  dominator tests and benchmark.
- **Different but not changed:** the rest differ at the same length, by rip-relative offsets the comparison doesn't
  normalize. `check_input_count_tokens.specialized.2` and `dataflow_generate` read as different lengths only because
  the comparison keys functions by name: their symbols are the same sizes in both executables.

`.text.buster_start` holds the same 597 functions in both, with the same bytes (`logs/*-sections.txt`,
`logs/*-functions.txt`).

## Mutation check

[`mutation/`](mutation/): [`mutants.py`](mutation/mutants.py) and [`run.py`](mutation/run.py); each mutant built
from an archived copy of the tree and run against `test-dominators` (the default seed, and seed 7 with 40 random
graphs) and `test-ir-source --dominators` on `dominators.c` and 80 of c-testsuite's subset.
- **Round 1** (`pr.results`) ran on the deletion commit `c6eb0abe7`. Its `ir-source` verdicts for s2, s3 and o1 don't
  count: the c-testsuite checkout the copy linked to had been deleted (by me, freeing disk), and those runs read
  "it couldn't be preprocessed". s1's crash came before any file; round 3 reruns it.
- **Round 2** (`pr2.results`) ran on the commit with the columns' check, the first SEMI-NCA fixture, the cross-edge
  fixture and the frontier-only budget check, and **round 3** (`pr3.results`) on the final tests commit `a0573e9e0`
  with the second SEMI-NCA fixture. s4 and l5 replaced s3 and l3, which are equivalent.

The final verdicts:

| Mutant | Killed by, on the final tests |
| --- | --- |
| s1, the path evaluation stops one vertex short | all three, after the first SEMI-NCA fixture (before it, `test-ir-source` alone) |
| s2, each immediate dominator is the semidominator | `test-dominators`, both seeds |
| s3, a link's initial least is its DFS parent | equivalent (below) |
| s4, path compression doesn't carry the least semidominator | `test-dominators`, both seeds, after the second SEMI-NCA fixture (before it, nothing) |
| o1, `rpo_index` reversed | all three, after the columns' check (before it, the default seed's digests alone) |
| o2, the RPO half reversed | `test-dominators`, both seeds |
| t1, each block's children in reverse order | all three, after the columns' check (before it, the default seed's digests alone) |
| t2, a subtree's interval one short | all three |
| f1, entry's frontier walk stops at its own idom | `test-dominators`, both seeds |
| f2, half the frontier rows cleared (past 512 blocks) | `test-dominators`, both seeds |
| c1, the SCC pass's ancestor interval includes its end | all three, after the cross-edge fixture (before it, `test-ir-source` alone) |
| c2, unreachable blocks flagged irreducible | all three |
| l1, unreachable predecessors join loop bodies | `test-dominators`, both seeds |
| l2, loop sizes counted in the first vector only (past 512 blocks) | `test-dominators`, both seeds |
| l3, a loop's flag taken from its header alone | equivalent (below) |
| l4, self-loops dropped | all three |
| l5, the first loop never flagged | `test-dominators`, both seeds |
| a1, the frontier budget refuses its exact size | `test-dominators`, both seeds, after the frontier-only budget check (before it, nothing) |
| a2, the loop budget refuses its exact size | `test-dominators`, both seeds |
| a3, the matrix peak understated | `test-dominators`, both seeds |
| v1, the CSR multiset check skipped | `test-dominators`, both seeds |

The equivalent mutants:
- **s3:** SEMI-NCA writes each vertex's semidominator into its link before any evaluation can reach it, since vertices are processed in decreasing number and only processed ones are on a path. Vertex 0 is never on one.
- **l3:** a natural loop's body lies in its header's SCC: the header reaches each body block, which it dominates, and each reaches the header through a latch. The flag is set per SCC, so the body's flags equal the header's.

The two SEMI-NCA fixtures were found by reasoning (s1) and by a search of random graphs with a Python
transcription of the analyzer's DFS and SEMI-NCA, checked against the dominance definition on 20,000 random graphs
([`mutation/semi_nca_search.py`](mutation/semi_nca_search.py)).
