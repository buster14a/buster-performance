# SQLite ordinary after moving the lexer lookahead into the next chunk

The unmodified 232da75f9 parent and 220f299c6 candidate ran the same frozen SQLite ordinary `-c` command. Each process was pinned to CPU 2 with the host exclusively leased.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 904.4405 | 1,307,158,933.0 | 117.2350 |
| candidate | 901.0754 | 1,306,511,951.5 | 117.1420 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| candidate minus baseline | −0.9380 [−13.6198, +0.3241] | −646,992.5 | −0.0130 [−0.4100, +0.1425] |

PMU fault counts ranged from 5,653 to 5,658. The independent wall series recorded 5,762 to 5,766 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 28 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 5,846 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `232da75f980c7ff9f01ffa3d849d655970bbed78` | `60d2bb6f131538a8845d1bfe56dc37aac0332c2caf70d53cdae9a935741ce1ec` |
| candidate | `220f299c60d0ee048fc36cf502f38bfbef314ecb` | `f9cad69b4264168b4892000d2f7f1feed6d75598b639958597496b2c70dd7a27` |

The [frozen driver method](../../paired-driver/README.md), [mode selectors](lex-lookahead-config.sh), [command and object checks](lex-lookahead-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.
