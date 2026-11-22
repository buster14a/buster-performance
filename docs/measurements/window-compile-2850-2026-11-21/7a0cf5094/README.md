# Reuse the traversal's storage through the checker reader

The candidate uses the same three token columns for traversal construction, declaration resolution and the expression argument lists. The 9700X comparison measures ordinary source-to-object compilations against the unmodified base.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `7a0cf50944342c9d50bb7625f627e503536bf998`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | +2.0199 [−0.1471, +2.9697] | +79,652.5 | −0.0435 [−0.7105, +0.3050] | 2/3 |
| [Buster](main/paired-summary.tsv) | +2.3387 [+1.2925, +4.6197] | +3,044,955.5 | +2.4055 [−0.5390, +6.4020] | 1/3 |
| [Lua](lua/paired-summary.tsv) | −2.3715 [−3.0430, −1.3033] | +784,724.0 | −0.1490 [−0.1665, +8.2175] | 2/3 |
| [musl](musl/paired-summary.tsv) | +1.4455 [−1.0891, +5.9006] | +5,884,553.0 | +0.6995 [−1.8470, +3.1370] | 1/3 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
