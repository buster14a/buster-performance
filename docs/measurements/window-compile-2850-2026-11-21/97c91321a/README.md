# Which program preparation changes reduce ordinary SQLite compilation work?

The same ordinary driver compiled frozen SQLite with three separately built Ryzen 7 9700X Release binaries. The pristine 232da75f9 parent is compared with its 97c91321a sparse-opening and lazy initializer changes, then with a4e5b1935, which also includes direct control roots. No runtime option or environment override enables these changes.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 904.3973 | 1,307,159,703.5 | 117.1990 |
| openings | 902.0524 | 1,305,848,271.5 | 117.2285 |
| combined | 900.4656 | 1,304,304,710.0 | 117.8370 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| openings minus baseline | −0.9718 [−4.8434, −0.6401] | −1,311,427.0 | −0.5155 [−0.6550, +0.3190] |
| combined minus baseline | −1.6077 [−6.4303, −1.4767] | −2,854,996.0 | +0.0390 [−0.0315, +0.6380] |
| combined minus openings | −0.9675 [−1.5869, −0.5048] | −1,543,549.5 | +0.4840 [−0.2800, +1.2930] |

PMU fault counts ranged from 5,651 to 5,656. The independent wall series recorded 5,759 to 5,765 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 42 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 5,846 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `232da75f980c7ff9f01ffa3d849d655970bbed78` | `60d2bb6f131538a8845d1bfe56dc37aac0332c2caf70d53cdae9a935741ce1ec` |
| openings | `97c91321a563a06b75dda5eaf022b9f0d2e9bfe7` | `e8141d485e3b855afa512643cca6e024833560ab74521785932bca9d160f3f29` |
| combined | `a4e5b1935526e0af6ca66daafb12b775f1427055` | `3c73edc66c2f4e54b749e591e428153f1966f42d518a0b9b1b41d00aac6c2e0f` |

The [frozen driver method](../paired-driver/README.md), [mode selectors](openings-attrib-config.sh), [command and object checks](openings-attrib-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.

The [opening and initializer source](openings.patch) applies to the pristine parent. The [combined source and seven-round performance record](../a4e5b1935/README.md) include the additional control-root changes. Both previously timed executables were reused in this new symmetric three-way comparison. [Every per-round difference](paired.tsv) retains the corresponding measurements of both arms.

The same-base 97c91321a Develop build passed all 212 independent artifact-producing comparisons, including the [54 targeted commands](correctness/direct.json) and [158 additional source files](correctness/broad.json). Exit, complete ELF and both diagnostic streams matched its unmodified parent throughout.
