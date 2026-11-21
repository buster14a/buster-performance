# Feed structural parsing during token conversion

The parser classifies converted preprocessor tokens in groups of 1,024, carrying its open-delimiter stack between groups. The final group includes the padded sentinels. The complete graph and checked native object are built in each timed process.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `ebb0efb57037ca229448adbf27981cf02cf6f26e`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −0.6219 [−5.5845, +3.7757] | +114,253.0 | +0.1135 [−0.5390, +1.0985] | 3/7 |
| [Buster](main/paired-summary.tsv) | +1.6601 [−14.3149, +9.8724] | +393,537.0 | −0.6920 [−2.8060, +2.1715] | 4/7 |
| [Lua](lua/paired-summary.tsv) | +0.9889 [−0.9708, +2.2942] | +89,690.5 | −0.0290 [−0.2110, +0.3410] | 4/7 |
| [musl](musl/paired-summary.tsv) | −2.2018 [−3.8637, +0.3159] | +809,264.0 | −1.3065 [−4.4645, −0.7045] | 7/7 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
