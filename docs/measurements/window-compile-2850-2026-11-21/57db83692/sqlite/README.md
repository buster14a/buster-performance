# Sparse inherited declaration origins in ordinary SQLite compilation

The pristine compiler at public main b86eadcbd is compared with its direct child 57db83692. Both compile the same frozen SQLite using the ordinary artifact driver. The candidate encodes absent, self and inherited origins in a one-byte column and reserves sparse pages for the inherited origin indices.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 898.6749 | 1,307,142,229.5 | 116.3430 |
| candidate | 899.1902 | 1,307,445,777.5 | 116.9900 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| candidate minus baseline | +0.5153 [−0.0494, +0.8100] | +303,526.5 | +0.2875 [+0.1975, +0.7115] |

PMU fault counts ranged from 5,637 to 5,653. The independent wall series recorded 5,743 to 5,761 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the 716,136 preprocessed tokens in this translation unit. All PMU events ran at 100% enabled time.

Each of the 28 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 5,846 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `b86eadcbd3d6c5cdf687f6b67b0281df2ac34034` | `06e22d737854b1308c2d2ac408b01574348e08ca07823114b993aaf271b563d3` |
| candidate | `57db8369284094ee8e3c68a98969905075b0fae2` | `6e656117ae17fb56ce715ccef5e61a0cf6a187b05ba0d3cb9285087e38b3a100` |

The [frozen driver method](../../paired-driver/README.md), [mode selectors](source-origins-config.sh), [command and object checks](source-origins-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.
