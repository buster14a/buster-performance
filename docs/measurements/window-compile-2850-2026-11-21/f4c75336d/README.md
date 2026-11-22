A fresh reader recognizes bounded lists of unnamed scalar and pointer parameters in file-scope function prototypes. SQLite admitted 956 complete declarations spanning 10,686 tokens, including 6,775 parameter-list tokens. The parser saw 716,136 tokens in this translation unit.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `f4c75336d7fe1792d053f2385289ca1ce2ade222`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | +2.2361 [−5.1960, +8.9206] | -2,708,859.5 | +0.2230 [−0.2620, +2.5520] | 2/7 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.

The [source and local qualification archive](local-source-oracle.tar.xz) includes the directed oracle, complete frozen-source differential manifests, accepted and refused source controls, and the eight checker shard reports.

The [supported warning replay](supported-warning-oracle.tar.xz) checked all 82 directed sources using `-Wall -Wextra`. The original suite’s `-Wconversion` entries recorded command-line rejections. The replacement runs matched the reference compiler’s diagnostics and full native objects.
