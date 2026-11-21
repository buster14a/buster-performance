# Current-main lexer lookahead and output ranges in ordinary SQLite compilation

These actual ordinary SQLite commands compare public main b86eadcbd directly against source a1609b1e9. The latter replays the lookahead, carried-comment and bounded lexer output changes on that same base.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 900.4195 | 1,307,142,343.5 | 116.7870 |
| candidate | 899.0261 | 1,304,383,916.5 | 116.5295 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| candidate minus baseline | −1.3933 [−3.3968, +2.5745] | −2,758,430.5 | −0.4185 [−0.4570, +0.0270] |

PMU fault counts ranged from 5,651 to 5,656. The independent wall series recorded 5,758 to 5,763 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 28 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 5,846 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `b86eadcbd3d6c5cdf687f6b67b0281df2ac34034` | `06e22d737854b1308c2d2ac408b01574348e08ca07823114b993aaf271b563d3` |
| candidate | `a1609b1e923184f18c30ff98275f54f99339312e` | `78dfcbf8379f5ad35cf24aeb8b125072cbef327f8b0311c6e48d87df0ffd12f1` |

The [frozen driver method](../paired-driver/README.md), [mode selectors](lexer-replay-config.sh), [command and object checks](lexer-replay-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.

The separately measured [full fresh preprocessor](fresh-preprocessor/README.md) performed include lookup, lexing, refinement and directives without the text printer. The [current-main correctness campaign](correctness/) and [exact source](implementation.patch) identify the replay. The [prior source on a different baseline](../adf1a5714/README.md) includes raw-lexer, multi-corpus and incremental controls.
