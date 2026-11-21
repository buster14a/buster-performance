# Which program preparation changes reduce ordinary SQLite compilation work?

The same ordinary driver compiled frozen SQLite with three separately built Ryzen 7 9700X Release binaries. The pristine 232da75f9 parent is compared with its 97c91321a sparse-opening and lazy initializer changes, then with a4e5b1935, which also includes direct control roots. No runtime option or environment override enables these changes.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 903.0279 | 1,307,159,745.5 | 117.1990 |
| openings | 903.4254 | 1,305,848,276.5 | 117.2285 |
| combined | 900.4656 | 1,304,304,710.0 | 116.9485 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| openings minus baseline | −0.9718 [−4.8434, +4.9968] | −1,311,454.0 | −0.3090 [−0.8150, +0.3190] |
| combined minus baseline | −1.6077 [−6.4303, +86.3318] | −2,855,020.5 | −0.0185 [−2.1075, +0.6380] |
| combined minus openings | −1.5869 [−5.8007, +90.8712] | −1,543,554.0 | −0.0600 [−1.2925, +1.2930] |

PMU fault counts ranged from 5,651 to 57,481. The independent wall series recorded 5,759 to 5,765 minor faults and zero major faults.

Excluding rounds with a process above 20,000 faults in the PMU series removes round 4. The combined compiler recorded 57,481 faults at position 2. The other two arms remained in the lower fault band. After excluding that complete round, the paired results were

| Paired difference | cycles/token, median [min, max] |
| --- | ---: |
| openings minus baseline | −0.8060 [−4.8434, +4.9968] |
| combined minus baseline | −3.0787 [−6.4303, +1.8551] |
| combined minus openings | −2.3643 [−5.8007, −0.5048] |

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 90 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 5,846 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `232da75f980c7ff9f01ffa3d849d655970bbed78` | `60d2bb6f131538a8845d1bfe56dc37aac0332c2caf70d53cdae9a935741ce1ec` |
| openings | `97c91321a563a06b75dda5eaf022b9f0d2e9bfe7` | `e8141d485e3b855afa512643cca6e024833560ab74521785932bca9d160f3f29` |
| combined | `a4e5b1935526e0af6ca66daafb12b775f1427055` | `3c73edc66c2f4e54b749e591e428153f1966f42d518a0b9b1b41d00aac6c2e0f` |

The [frozen driver method](../paired-driver/README.md), [mode selectors](openings-attrib-config.sh), [command and object checks](openings-attrib-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.

The [opening and initializer source](openings.patch) applies to the pristine parent. The [combined source and seven-round performance record](../a4e5b1935/README.md) include the additional control-root changes. Both previously timed executables were reused in this new symmetric three-way comparison. [Every per-round difference](paired.tsv) retains the corresponding measurements of both arms.

The same-base 97c91321a Develop build passed all 212 independent artifact-producing comparisons, including the [54 targeted commands](correctness/direct.json) and [158 additional source files](correctness/broad.json). Exit, complete ELF and both diagnostic streams matched its unmodified parent throughout.

The [Lua parser](lua/README.md) and [musl vfprintf](musl/README.md) sensitivity runs independently compiled one frozen unit in each of the three modes. The smaller openings change retired fewer user instructions on both. Their three-round wall and cycle intervals each included both directions. The independent [correctness record](correctness/method.md) includes all 848,405 checker and 211,028 driver assertions, self-host output equality and the 212 pristine/native comparisons.

The [original three-way screen](https://github.com/buster14a/buster-performance/tree/87796a2c3d1ca3c4b28cc0c45fea9f797163277c/docs/measurements/window-compile-2850-2026-11-21/97c91321a) led to an [extension](openings-attrib-extend.sh) with four more independently paired PMU and wall rounds. The first three rounds retain their original sampling positions and values.
