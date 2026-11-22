# Source-produced checked integer expressions

Buster `5c1c8f9e7523d5d79815c13924712790ca99dd76` runs a postorder integer semantic producer inside the pending source-expression batch on the function-local object compiler `b352534f202b8a739923cd8b5c8953f773f6a9e1`. A parameter or literal supplies a checked operand word. The source append computes each supported nonleaf’s result type, both promoted operand types and their exact lvalue, promotion and arithmetic-conversion flags. Later source expressions consume earlier arithmetic results before the graph columns are populated. The normal checker consumes a matching proof directly. Rewritten edges, constant evaluation, FP access, overloads, uncertain operand shapes and folds retain their ordinary actions. [Patch](implementation.patch) and [compiler identities](builds.tsv).

| Input | Native trials | Source-local nodes | Arithmetic proofs produced | Proofs using an earlier arithmetic result | Proofs consumed |
| --- | ---: | ---: | ---: | ---: | ---: |
| sqlite | 2,674 | 319,280 | 10,420 | 3,738 | 10,420 |
| main | 8,654 | 581,511 | 12,560 | 3,901 | 12,560 |

Native status, diagnostic text, typed or static output, ELF hashes and checked-graph comparisons recorded 0 candidate-versus-control differences. 28 comparisons also record differences already present between ordinary compilation and the parent’s source-local route. The two frozen objects for each real workload matched in 4 of 4 checks. [Native outputs](oracle/native.tsv), [checked scopes](oracle/checked.tsv), [differences](oracle/failures.json), [baseline scope differences](oracle/previous.json), [saved object identities](oracle/historical-elf.json), [body-level proof coverage](oracle/coverage.tsv), [totals](oracle/totals.tsv) and [source, statuses and full raw streams](oracle/raw.tar.gz).

| Input | Scope | Paired wall | Faster wall rounds | Paired user instructions | Paired user cycles |
| --- | --- | ---: | ---: | ---: | ---: |
| sqlite | native | -3.008 ms | 4/5 | +9,162,785 | -5,606,074 |
| sqlite | local-stage | -4.943 ms | 3/5 | +8,872,030 | +29,379,682 |
| main | native | -93.437 ms | 4/5 | +25,835,944 | +253,992,911 |
| main | local-stage | +1.726 ms | 2/5 | +25,669,238 | -76,059,566 |

All stage measurements used one local Ryzen 9 7940HS core and the same optimized binary. The native comparisons enable the existing source-owned function path on both arms and emit a full ordinary ELF for each process. The stage-only arms admit all complete functions and stop at the same checker boundary. Five alternating ABBA/BAAB rounds measured wall time. Three additional rounds measured user cycles and instructions. [Paired results](stage/paired.tsv), [per-process samples with ELF hashes](stage/samples.tsv) and [raw output and counters](stage/raw.tar.gz).

Fingerprints were also taken inside the actual source-native trials. The producer and the source-native control differed at 0 function endings. The table separately identifies differences between the unchanged local trials and a whole-unit ordinary check. [Native trial fingerprints](live/comparisons.tsv) and [raw per-function records](live/raw.tar.gz).

The debugger selected the first signed comparison proof at the checker input. The untouched source-native function returned `0 1`. Replacing the source-produced signed operand types with unsigned types returned `0 0`. The ordinary and observed controls retain their ELF hashes and runtime output. [Guarded outcomes](mutation/results.tsv) and [source and raw debugger transcripts](mutation/raw.tar.gz).

The [standalone replay](reproduce.py) accepts both compiler paths and the frozen source paths, and extracts the directed cases from the archived oracle.
