# Lexer lookahead and carried block-comment selection in ordinary SQLite compilation

These three true compiler builds compare the pristine 232da75f9 source, its 220f299c6 change to lookahead mask rows and the cumulative 8b3cde244 change that also selects a carried block comment’s first closing lane. Every mode runs the same ordinary SQLite compilation with no runtime option.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 903.1042 | 1,307,159,741.5 | 118.0345 |
| lookahead | 900.8449 | 1,306,511,957.0 | 117.2520 |
| combined | 900.8411 | 1,306,387,174.5 | 117.3570 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| lookahead minus baseline | −2.2079 [−3.2355, −1.0674] | −647,760.0 | −0.1825 [−0.7825, +0.0140] |
| combined minus baseline | −2.3959 [−6.8380, +4.5116] | −772,567.0 | −0.8950 [−1.0800, +0.1445] |
| combined minus lookahead | −1.3285 [−4.6301, +7.7471] | −124,807.0 | −0.2975 [−0.7125, +0.1305] |

PMU fault counts ranged from 5,652 to 5,658. The independent wall series recorded 5,761 to 57,465 minor faults and zero major faults.

Excluding rounds with a process above 20,000 faults in the wall series removes rounds 3. The retained paired differences are

| Paired difference | wall-ms, median [min, max] |
| --- | ---: |
| lookahead minus baseline | −0.3843 [−0.7825, +0.0140] |
| combined minus baseline | −0.4678 [−1.0800, +0.1445] |
| combined minus lookahead | −0.0835 [−0.2975, +0.1305] |

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 42 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 5,846 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `232da75f980c7ff9f01ffa3d849d655970bbed78` | `60d2bb6f131538a8845d1bfe56dc37aac0332c2caf70d53cdae9a935741ce1ec` |
| lookahead | `220f299c60d0ee048fc36cf502f38bfbef314ecb` | `f9cad69b4264168b4892000d2f7f1feed6d75598b639958597496b2c70dd7a27` |
| combined | `8b3cde244cb59295d9ce6f2d15a1c6a53e5557da` | `3a907e3d6479792cc4c7d8ff9f731bdd3ab5cde9cc5f1dccbd8e745e008080ae` |

The [frozen driver method](../paired-driver/README.md), [mode selectors](lexer-combined-config.sh), [command and object checks](lexer-combined-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.
