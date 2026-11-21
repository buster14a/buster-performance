# Removing the carried-comment change from the bounded-writer lexer

Rotated ordinary SQLite compiles use the unmodified b86eadcbd parent, the full lookahead/comment/writer aggregate a1609b1e9, and the 20332af51 lookahead/writer source. The third build retains the original handling of a carried block comment. All modes use the ordinary compiler without feature flags.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 902.5217 | 1,307,142,345.5 | 116.7005 |
| aggregate | 900.7125 | 1,304,383,926.0 | 116.7955 |
| lean | 900.5862 | 1,304,444,559.5 | 116.8590 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| aggregate minus baseline | +0.4251 [−1.8781, +102.2841] | −2,758,417.0 | +0.0000 [−0.9745, +0.6195] |
| lean minus baseline | +1.1383 [−2.2328, +12.9993] | −2,697,784.5 | +0.0405 [−0.3385, +0.6830] |
| lean minus aggregate | −0.1410 [−89.2847, +8.8743] | +59,929.0 | +0.0635 [−0.3385, +1.0150] |

PMU fault counts ranged from 5,648 to 57,465. The independent wall series recorded 5,757 to 5,764 minor faults and zero major faults.

Excluding rounds with a process above 20,000 faults in the pmu series removes rounds 4. The retained paired differences are

| Paired difference | cycles/token, median [min, max] |
| --- | ---: |
| aggregate minus baseline | −0.3173 [−1.8781, +2.5402] |
| lean minus baseline | +0.9870 [−2.2328, +7.6602] |
| lean minus aggregate | −0.1337 [−1.7044, +8.8743] |

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 90 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 5,846 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `b86eadcbd3d6c5cdf687f6b67b0281df2ac34034` | `06e22d737854b1308c2d2ac408b01574348e08ca07823114b993aaf271b563d3` |
| aggregate | `a1609b1e923184f18c30ff98275f54f99339312e` | `78dfcbf8379f5ad35cf24aeb8b125072cbef327f8b0311c6e48d87df0ffd12f1` |
| lean | `20332af513764ae677248bdd32d348120141f81f` | `52984f3b6af9ce54c9a6bd1695fdb6ab6093ed4e07964d0a4c5b775a8edab244` |

The [frozen driver method](../paired-driver/README.md), [mode selectors](lexer-lean-config.sh), [command and object checks](lexer-lean-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.

The lean executable used +1.1383 total cycles/token and +0.0405 ms elapsed time against the pristine compiler at the paired medians. Its total cycles were lower in 2/7 rounds and its elapsed time was lower in 3/7. The [first three rounds](https://github.com/buster14a/buster-performance/tree/7c4bd5821a9c38cd8e6c9cfa5cc862ff9fc7fa0d/docs/measurements/window-compile-2850-2026-11-21/20332af51) are retained verbatim. The [extension](lexer-lean-extend.sh) ran four further rounds with the same binaries.

The [built-in lexer](lexer/README.md) and [fresh preprocessor](pp/README.md) were faster on the lean source in all three pairs against either the baseline or full aggregate. The [complete source](implementation.patch), [correctness data](correctness/) and [seven-round full aggregate control](../a1609b1e9/README.md) retain the independent checks. Public [PR #3249](https://github.com/buster14a/buster/pull/3249) head 1a2f97e72 and measured source 20332af51 have identical full Git tree f82b740185e7083d2bebb5d1abe1b0d9cf0a83e2.
