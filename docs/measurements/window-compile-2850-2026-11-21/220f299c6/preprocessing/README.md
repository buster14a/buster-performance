# SQLite preprocessing after moving the lexer lookahead into the next chunk

The unmodified 232da75f9 parent and 220f299c6 candidate ran the same frozen SQLite preprocessor `-E -P` command. Each process was pinned to CPU 2 with the host exclusively leased.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 91.7805 | 151,300,867.5 | 11.6990 |
| candidate | 91.6289 | 150,653,261.5 | 11.5375 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| candidate minus baseline | −0.3234 [−1.2928, +0.8809] | −647,606.0 | −0.1670 [−0.3115, +0.1255] |

PMU fault counts ranged from 1,195 to 1,198. The independent wall series recorded 1,304 to 1,306 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 28 successful preprocessing commands yielded a 2,358,073-byte text output with SHA-256 `ffede5fcb477a7204a9a4e98dfe4b0ce41c955088a4ca3b83df606ca8285cfa9`. Default preprocessing diagnostics were empty. All `-Wall -Wextra` preprocessing commands had identical output, with 0 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `232da75f980c7ff9f01ffa3d849d655970bbed78` | `60d2bb6f131538a8845d1bfe56dc37aac0332c2caf70d53cdae9a935741ce1ec` |
| candidate | `220f299c60d0ee048fc36cf502f38bfbef314ecb` | `f9cad69b4264168b4892000d2f7f1feed6d75598b639958597496b2c70dd7a27` |

The [frozen driver method](../../paired-driver/README.md), [mode selectors](lex-lookahead-config.sh), [command and output checks](lex-lookahead-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [preprocessed text receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.
