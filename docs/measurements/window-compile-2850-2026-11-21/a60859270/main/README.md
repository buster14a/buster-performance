# Ordinary compilation with source-certified constant operands on Buster main.c

The pristine public main b86eadcbd and two modes of source a60859270 compile frozen Buster main.c with one lane. Only the constants mode sets `--node-window-constants`. Every observation uses one fresh Release process. All three use the normal artifact driver without a diagnostic environment variable.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 1,542.6051 | 10,562,267,018.5 | 675.7885 |
| plain | 1,540.3324 | 10,559,959,294.5 | 676.5480 |
| constants | 1,527.2113 | 10,454,539,733.5 | 671.3220 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| plain minus baseline | −3.1467 [−7.9287, +7.0657] | −2,298,943.5 | +0.1540 [−0.5675, +5.5755] |
| constants minus plain | −14.5147 [−18.4891, −4.8181] | −105,426,628.0 | −4.8095 [−9.4180, −4.3100] |
| constants minus baseline | −16.2179 [−19.3386, −11.0359] | −107,725,041.5 | −4.5145 [−7.3860, −3.8425] |

PMU fault counts ranged from 16,481 to 16,505. The independent wall series recorded 16,835 to 16,855 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the 2,433,922 preprocessed tokens in this translation unit. All PMU events ran at 100% enabled time.

Each of the 90 successful compiles yielded a 11,272,080-byte object with SHA-256 `f6da2c15662c96c6d222714244bd3aff34d964c360b0871da6f0036dee74309c`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 2,357 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `b86eadcbd3d6c5cdf687f6b67b0281df2ac34034` | `06e22d737854b1308c2d2ac408b01574348e08ca07823114b993aaf271b563d3` |
| plain, constants | `a60859270d960707df809d310ae895b0672d4fef` | `929be671d1a01cc3ade60b3f671a87a300665e046c2cb42097d1e900fbd7b16e` |

The [frozen driver method](../../paired-driver/README.md), [mode selectors](fixed-constant-config.sh), [command and object checks](fixed-constant-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.

The separate [admission observation](confirmed-admissions.txt) recorded 27,201 accepted constant roots and 67,186 physically removed ordinary graph nodes, leaving 1,340,216. Every same-image/plain and parent comparison used the actual object described in the qualification receipts. [Individual paired metrics](paired.tsv) include the user and kernel contributions.
