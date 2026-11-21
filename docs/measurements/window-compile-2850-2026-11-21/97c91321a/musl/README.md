# musl vfprintf.c ordinary compilation with program preparation changes

This musl vfprintf.c sensitivity measurement runs three ordinary compilers, 232da75f9 pristine, 97c91321a with lazy initializer and opening preparation, and a4e5b1935 with both that change and direct control roots. Each independent fresh process compiles one representative translation unit.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 1,557.1290 | 37,968,130.0 | 4.2340 |
| openings | 1,548.8624 | 37,942,241.5 | 4.1185 |
| combined | 1,545.5636 | 37,893,081.5 | 4.2250 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| openings minus baseline | −5.6363 [−8.2666, +11.7401] | −25,871.0 | −0.0900 [−0.1370, +0.0345] |
| combined minus baseline | +4.3154 [−15.8671, +10.2888] | −75,130.0 | +0.0165 [−0.1500, +0.2210] |
| combined minus openings | +9.9517 [−27.6071, +18.5554] | −49,139.5 | +0.1065 [−0.0130, +0.1865] |

PMU fault counts ranged from 976 to 979. The independent wall series recorded 994 to 996 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the 16,184 preprocessed tokens in musl vfprintf. All PMU events ran at 100% enabled time.

Each of the 42 successful compiles yielded a 24,072-byte object with SHA-256 `a19e50ed30f084a39ee48ef0be9a3f82e9be1f4524d1803c38f224eb61dda651`. All direct process PMU samples produced the same 36,572-byte default diagnostic stream, and the true-wall commands had matching diagnostics across all modes. All `-Wall -Wextra` compilations had identical output, with 41,020 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `232da75f980c7ff9f01ffa3d849d655970bbed78` | `60d2bb6f131538a8845d1bfe56dc37aac0332c2caf70d53cdae9a935741ce1ec` |
| openings | `97c91321a563a06b75dda5eaf022b9f0d2e9bfe7` | `e8141d485e3b855afa512643cca6e024833560ab74521785932bca9d160f3f29` |
| combined | `a4e5b1935526e0af6ca66daafb12b775f1427055` | `3c73edc66c2f4e54b749e591e428153f1966f42d518a0b9b1b41d00aac6c2e0f` |

The [paired-driver method](../../paired-driver/README.md), [mode selectors](openings-sample-config.sh), [command and object checks](openings-sample-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.
