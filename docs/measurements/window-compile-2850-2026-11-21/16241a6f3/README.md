A fresh ordinary reader resolves the specifier, name and pointer shape of bounded named C declarations using source-position bindings. The canonical checker retains declaration and function-body ownership.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `16241a6f3f9b952ef863298d146fe3ebea6f3528`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −0.2005 [−2.3497, +81.6917] | -18,481,815.5 | −0.2805 [−0.3700, −0.0695] | 7/7 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.

The [source and local qualification archive](local-source-oracle.tar.xz) includes 3,608 directed comparisons, 360 independent Clang runtime checks, 4,116 frozen-source comparisons, all checker shard reports, and the independent scalar and guard-page parser-prefix oracle.

The [supported warning replay](supported-warning-oracle.tar.xz) checked all 451 directed sources using `-Wall -Wextra`. The original suite’s `-Wconversion` entries recorded command-line rejections. The replacement runs matched the reference compiler’s diagnostics and full native objects.
