# Sparse inherited declaration origins in ordinary Buster main.c compilation

The pristine compiler at public main b86eadcbd is compared with its direct child 57db83692. Both compile the same frozen Buster main.c using the ordinary artifact driver. The candidate encodes absent, self and inherited origins in a one-byte column and reserves sparse pages for the inherited origin indices.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 1,541.0518 | 10,562,257,063.0 | 678.6420 |
| candidate | 1,544.2963 | 10,563,053,996.5 | 681.3120 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| candidate minus baseline | +6.1218 [+2.1057, +6.7802] | +792,590.5 | +1.9635 [−1.4325, +2.6700] |

PMU fault counts ranged from 16,490 to 16,502. The independent wall series recorded 16,845 to 16,860 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the 2,433,922 preprocessed tokens in this translation unit. All PMU events ran at 100% enabled time.

Each of the 28 successful compiles yielded a 11,272,080-byte object with SHA-256 `f6da2c15662c96c6d222714244bd3aff34d964c360b0871da6f0036dee74309c`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 2,357 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `b86eadcbd3d6c5cdf687f6b67b0281df2ac34034` | `06e22d737854b1308c2d2ac408b01574348e08ca07823114b993aaf271b563d3` |
| candidate | `57db8369284094ee8e3c68a98969905075b0fae2` | `6e656117ae17fb56ce715ccef5e61a0cf6a187b05ba0d3cb9285087e38b3a100` |

The [frozen driver method](../../paired-driver/README.md), [mode selectors](source-origins-config.sh), [command and object checks](source-origins-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.
