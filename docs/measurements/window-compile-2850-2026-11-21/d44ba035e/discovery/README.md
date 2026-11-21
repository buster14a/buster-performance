# Three ways to find conditional comparison rows

Plain token discovery saved 1.9 million instructions and 1.86 cycles per token over the original discovery method. Compared with leaving conditions disabled, it still took 3.51 more cycles per token. All three paired cycle differences had the same sign for each comparison. The [source patches and differential qualification](correctness/README.md) include all 381,191 native rows, their source tokens, complete checked values for each accepted condition and the 15 grouped expressions omitted by plain token discovery.

The four modes use a single Release executable with assignment processing enabled. The conditional option was absent in `off`. For `original`, `control` and `plain` it was present, with `BUSTER_CONDITION_DISCOVERY` selecting the source of the predicate candidates. The original and control-marker modes take the same 1,367 additional comparisons. The plain token classification takes 1,352. This three-round screen measures the combined discovery and processing cost for each mode. The earlier [eight-stage source experiment](../controls/README.md) measured which stages accounted for the larger original cost.

| Mode | Expressions taken | Ordinary nodes replaced | Final graph nodes | Median cycles/token | Median user instructions |
| --- | ---: | ---: | ---: | ---: | ---: |
| off | 2,977 | 7,534 | 319,066 | 932.6707 | 1,339,142,125.0 |
| original | 4,344 | 11,635 | 316,332 | 939.4271 | 1,339,937,092.5 |
| control | 4,344 | 11,635 | 316,332 | 942.5105 | 1,339,184,576.0 |
| plain | 4,329 | 11,590 | 316,362 | 935.8339 | 1,338,037,160.0 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median |
| --- | ---: | ---: |
| original minus off | +7.1062 [+3.9809, +7.2323] | +794,998.0 |
| control minus off | +9.8397 [+9.7508, +11.3600] | +42,454.5 |
| plain minus off | +3.5130 [+2.1238, +5.7111] | −1,104,978.0 |
| control minus original | +2.6446 [+2.6074, +7.3791] | −752,504.5 |
| plain minus original | −1.8571 [−3.5932, −1.5212] | −1,899,932.5 |

PMU fault counts ranged from 5,668 to 5,815.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 32 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 3,701 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| off, original, control, plain | `543e46c4f9ee68801dceafc644d3ad7016348797` | `e3907c1f46aa669d5561abf5c9f4bb3c6018f5f0bb0467f5726b649c88952630` |

The [frozen driver method](../../paired-driver/README.md), [mode selectors](cond-refine-config.sh), [command and object checks](cond-refine-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.
