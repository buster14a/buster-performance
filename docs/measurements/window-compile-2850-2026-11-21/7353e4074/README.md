# Demand-driven program control markers in ordinary SQLite compilation

All three modes compile the frozen SQLite translation unit with ordinary artifact generation. The baseline is the pristine public main at 232da75f9. The same candidate compiler runs once with its ordinary implementation and once with its experimental sparse control marker mode active. A separate audit compile counts the body and token domains and checks the output against baseline.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 903.6643 | 1,307,159,748.0 | 117.5800 |
| off | 902.6994 | 1,307,734,161.5 | 117.7215 |
| on | 897.6270 | 1,300,087,551.0 | 117.1845 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| off minus baseline | −0.0381 [−0.9649, +1.8658] | +574,413.5 | +0.1415 [−0.2445, +1.0445] |
| on minus off | −5.0724 [−8.0608, −4.8826] | −7,646,787.0 | −0.5370 [−0.7490, +1.6700] |
| on minus baseline | −6.0373 [−6.1949, −4.9207] | −7,072,243.5 | −0.3955 [−0.9935, +2.7145] |

PMU fault counts ranged from 5,649 to 5,695. The independent wall series recorded 5,758 to 5,804 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 43 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 5,846 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `232da75f980c7ff9f01ffa3d849d655970bbed78` | `60d2bb6f131538a8845d1bfe56dc37aac0332c2caf70d53cdae9a935741ce1ec` |
| off, on | `7353e4074ff04dfcb71c2a55ea365f3628fc55bd` | `9c62f8732b64dad4327825299c54c1ef0b13aca888f2d0f9ba20d116eb8cabf5` |

The [frozen driver method](../paired-driver/README.md), [mode selectors](body-markers-config.sh), [command and object checks](body-markers-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.

The [complete diagnostic source patch](markers735.patch) applies to pristine 232da75f9. The independent audited compile reports 2,674 bodies, zero targets, 568,641 tokens and zero target tokens.
