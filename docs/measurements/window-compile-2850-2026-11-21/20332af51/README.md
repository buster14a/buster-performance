# Removing the carried-comment change from the bounded-writer lexer

Rotated ordinary SQLite compiles use the unmodified b86eadcbd parent, the full lookahead/comment/writer aggregate a1609b1e9, and the 20332af51 lookahead/writer source. The third build retains the original handling of a carried block comment. All modes use the ordinary compiler without feature flags.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 897.7382 | 1,307,142,332.0 | 116.6070 |
| aggregate | 898.5001 | 1,304,383,926.0 | 116.7955 |
| lean | 899.4881 | 1,304,444,553.0 | 116.7095 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| aggregate minus baseline | +0.4251 [−1.2141, +2.5402] | −2,758,311.5 | +0.2060 [+0.0000, +0.6195] |
| lean minus baseline | +1.4130 [+0.8358, +7.6602] | −2,697,779.0 | +0.1025 [−0.3385, +0.6830] |
| lean minus aggregate | +0.9879 [−1.7044, +8.8743] | +59,816.5 | −0.1035 [−0.3385, +0.0635] |

PMU fault counts ranged from 5,650 to 5,656. The independent wall series recorded 5,757 to 5,763 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 42 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 5,846 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `b86eadcbd3d6c5cdf687f6b67b0281df2ac34034` | `06e22d737854b1308c2d2ac408b01574348e08ca07823114b993aaf271b563d3` |
| aggregate | `a1609b1e923184f18c30ff98275f54f99339312e` | `78dfcbf8379f5ad35cf24aeb8b125072cbef327f8b0311c6e48d87df0ffd12f1` |
| lean | `20332af513764ae677248bdd32d348120141f81f` | `52984f3b6af9ce54c9a6bd1695fdb6ab6093ed4e07964d0a4c5b775a8edab244` |

The [frozen driver method](../paired-driver/README.md), [mode selectors](lexer-lean-config.sh), [command and object checks](lexer-lean-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.

The [built-in lexer](lexer/README.md) and the [fresh preprocessor](pp/README.md) use separate three-way schedules. Both were faster on the lean source in all three pairs against either the baseline or the full aggregate. The ordinary compiler’s whole-program wall intervals crossed zero for lean against both controls, and the lean compiler used more total cycles/token than pristine in every ordinary compilation round. The [complete source](implementation.patch), [exact current-source qualification](correctness/) and [seven-round full aggregate control](../a1609b1e9/README.md) identify the distinct evidence.
