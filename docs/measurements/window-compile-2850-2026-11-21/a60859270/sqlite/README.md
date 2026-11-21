# Ordinary compilation with source-certified constant operands on SQLite

The pristine public main b86eadcbd and two modes of source a60859270 compile frozen SQLite with one lane. Only the constants mode sets `--node-window-constants`. Every observation uses one fresh Release process. All three use the normal artifact driver without a diagnostic environment variable.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 897.9784 | 1,307,144,291.5 | 116.5535 |
| plain | 900.2465 | 1,306,570,041.0 | 116.8615 |
| constants | 899.4901 | 1,301,373,833.5 | 116.9070 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| plain minus baseline | +2.6865 [−4.7923, +4.1003] | −574,230.5 | +0.3170 [−0.6470, +0.6595] |
| constants minus plain | +0.9491 [−2.1959, +7.3360] | −5,196,189.5 | +0.1045 [−0.4630, +0.8720] |
| constants minus baseline | +1.1755 [−0.9948, +10.4509] | −5,770,461.5 | +0.2340 [−0.5425, +1.5315] |

PMU fault counts ranged from 5,649 to 5,663. The independent wall series recorded 5,757 to 5,770 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the 716,136 preprocessed tokens in this translation unit. All PMU events ran at 100% enabled time.

Each of the 90 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 5,846 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `b86eadcbd3d6c5cdf687f6b67b0281df2ac34034` | `06e22d737854b1308c2d2ac408b01574348e08ca07823114b993aaf271b563d3` |
| plain, constants | `a60859270d960707df809d310ae895b0672d4fef` | `929be671d1a01cc3ade60b3f671a87a300665e046c2cb42097d1e900fbd7b16e` |

The [frozen driver method](../../paired-driver/README.md), [mode selectors](fixed-constant-config.sh), [command and object checks](fixed-constant-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.

The separate [admission observation](confirmed-admissions.txt) recorded 2,356 accepted constant roots and 4,759 physically removed ordinary graph nodes, leaving 318,864. Every same-image/plain and parent comparison used the actual object described in the qualification receipts. [Individual paired metrics](paired.tsv) include the user and kernel contributions.
