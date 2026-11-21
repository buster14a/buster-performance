# Ordinary compilation with source-certified constant operands on Buster main.c

The pristine public main b86eadcbd and two modes of source 5882f7c2a compile frozen Buster main.c with one lane. Only the constants mode sets `--node-window-constants`. Every observation uses one fresh Release process. All three use the normal artifact driver without a diagnostic environment variable.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 1,545.1792 | 10,562,256,515.5 | 677.8850 |
| plain | 1,545.5047 | 10,559,917,882.5 | 677.8160 |
| constants | 1,531.2429 | 10,454,183,777.0 | 673.1805 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| plain minus baseline | +6.6075 [−3.0809, +20.8749] | −2,338,633.0 | −0.0690 [−1.0870, +10.7170] |
| constants minus plain | −16.7035 [−34.8112, −6.8045] | −105,728,042.5 | −6.9110 [−14.9750, −0.2840] |
| constants minus baseline | −10.0960 [−13.9363, −9.8855] | −108,085,320.5 | −4.2580 [−6.9800, −1.3710] |

PMU fault counts ranged from 16,483 to 16,493. The independent wall series recorded 16,836 to 16,856 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the 2,433,922 preprocessed tokens in this translation unit. All PMU events ran at 100% enabled time.

Each of the 42 successful compiles yielded a 11,272,080-byte object with SHA-256 `f6da2c15662c96c6d222714244bd3aff34d964c360b0871da6f0036dee74309c`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 2,357 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `b86eadcbd3d6c5cdf687f6b67b0281df2ac34034` | `06e22d737854b1308c2d2ac408b01574348e08ca07823114b993aaf271b563d3` |
| plain, constants | `5882f7c2a4ae574396469fe57ba6534e1dccac71` | `aad565b3f02d829ad64f759fee4ce0e28e0e7c2ba79e1e14845c76f60c0db77f` |

The [frozen driver method](../../paired-driver/README.md), [mode selectors](pure-constant-config.sh), [command and object checks](pure-constant-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.

The separate [admission observation](confirmed-admissions.txt) recorded 27,225 accepted constant roots and 67,264 physically removed ordinary graph nodes, leaving 1,340,138. Every same-image/plain and parent comparison used the actual object described in the qualification receipts. [Individual paired metrics](paired.tsv) include the user and kernel contributions.
