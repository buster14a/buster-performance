# Source-produced checked integer expressions

Buster `083273e7cc6e70c44fe7aad406fcb139c04836fa` runs a postorder integer semantic producer inside the pending source-expression batch on the function-local object compiler `b352534f202b8a739923cd8b5c8953f773f6a9e1`. A parameter or literal supplies a checked operand word. The source append computes each supported nonleaf’s result type, both promoted operand types and their exact lvalue, promotion and arithmetic-conversion flags. Later source expressions consume earlier arithmetic results before the graph columns are populated. The normal checker consumes a matching proof directly. Rewritten edges, constant evaluation, FP access, overloads, uncertain operand shapes and folds retain their ordinary actions. [Patch](implementation.patch) and [compiler identities](builds.tsv).

| Input | Native trials | Source-local nodes | Arithmetic proofs produced | Proofs using an earlier arithmetic result | Proofs consumed |
| --- | ---: | ---: | ---: | ---: | ---: |
| sqlite | 2,674 | 319,280 | 10,420 | 3,738 | 10,420 |
| main | 8,654 | 581,511 | 12,560 | 3,901 | 12,560 |

Native status, diagnostic text, typed or static output, ELF hashes and checked-graph comparisons recorded 0 candidate-versus-control differences. 28 comparisons also record differences already present between ordinary compilation and the parent’s source-local route. The two frozen objects for each real workload matched in 4 of 4 checks. [Native outputs](oracle/native.tsv), [checked scopes](oracle/checked.tsv), [differences](oracle/failures.json), [baseline scope differences](oracle/previous.json), [saved object identities](oracle/historical-elf.json), [body-level proof coverage](oracle/coverage.tsv), [totals](oracle/totals.tsv) and [source, statuses and full raw streams](oracle/raw.tar.gz).

| Input | Scope | Paired wall | Faster wall rounds | Paired user instructions | Paired user cycles |
| --- | --- | ---: | ---: | ---: | ---: |
| sqlite | native | +10.650 ms | 1/5 | +19,475,002 | -4,370,566 |
| sqlite | local-stage | +0.079 ms | 2/5 | +19,143,082 | +12,730,036 |
| main | native | +60.640 ms | 2/5 | +43,456,964 | +59,615,269 |
| main | local-stage | +8.651 ms | 2/5 | +43,420,250 | +26,204,058 |

All stage measurements used one local Ryzen 9 7940HS core and the same optimized binary. The native comparisons enable the existing source-owned function path on both arms and emit a full ordinary ELF for each process. The stage-only arms admit all complete functions and stop at the same checker boundary. Five alternating ABBA/BAAB rounds measured wall time. Three additional rounds measured user cycles and instructions. [Paired results](stage/paired.tsv), [per-process samples with ELF hashes](stage/samples.tsv) and [raw output and counters](stage/raw.tar.gz).

The [standalone replay](reproduce.py) accepts both compiler paths and the frozen source paths, and extracts the directed cases from the archived oracle.
