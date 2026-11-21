# Ordinary compilation with source-certified constant operands on SQLite

The pristine public main b86eadcbd and two modes of source 5882f7c2a compile frozen SQLite with one lane. Only the constants mode sets `--node-window-constants`. Every observation uses one fresh Release process. All three use the normal artifact driver without a diagnostic environment variable.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 899.5259 | 1,307,144,317.5 | 116.9585 |
| plain | 901.8764 | 1,306,539,001.5 | 117.4805 |
| constants | 900.5303 | 1,301,325,998.5 | 116.7255 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| plain minus baseline | +2.2804 [+0.4286, +2.3505] | −605,320.5 | +0.5220 [−0.1535, +4.3455] |
| constants minus plain | −2.9950 [−3.5990, −1.3461] | −5,213,003.0 | −0.7550 [−3.0750, −0.5255] |
| constants minus baseline | −0.7146 [−3.1704, +1.0044] | −5,818,323.5 | −0.2330 [−0.6790, +1.2705] |

PMU fault counts ranged from 5,651 to 5,661. The independent wall series recorded 5,757 to 5,770 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the 716,136 preprocessed tokens in this translation unit. All PMU events ran at 100% enabled time.

Each of the 42 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 5,846 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `b86eadcbd3d6c5cdf687f6b67b0281df2ac34034` | `06e22d737854b1308c2d2ac408b01574348e08ca07823114b993aaf271b563d3` |
| plain, constants | `5882f7c2a4ae574396469fe57ba6534e1dccac71` | `aad565b3f02d829ad64f759fee4ce0e28e0e7c2ba79e1e14845c76f60c0db77f` |

The [frozen driver method](../../paired-driver/README.md), [mode selectors](pure-constant-config.sh), [command and object checks](pure-constant-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.

The separate [admission observation](confirmed-admissions.txt) recorded 2,356 accepted constant roots and 4,759 physically removed ordinary graph nodes, leaving 318,864. Every same-image/plain and parent comparison used the actual object described in the qualification receipts. [Individual paired metrics](paired.tsv) include the user and kernel contributions.
