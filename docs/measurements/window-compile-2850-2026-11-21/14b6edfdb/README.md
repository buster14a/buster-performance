# Count allocation requirements on the completed graph

The source reader publishes allocation counts by scanning the finished operator and argument-count columns. The ordinary source-order checker does not consume scheduling purity. Schedules that reorder nodes reconstruct purity with the independent validator, which also checks the counts.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `14b6edfdb71fb95aba6ff3b511d1b342353b4e6d`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −5.7789 [−7.7433, +9.4417] | -6,870,071.0 | +0.0165 [−1.0340, +4.3970] | 3/7 |
| [Buster](main/paired-summary.tsv) | −3.1526 [−12.5732, +4.3001] | -51,334,075.5 | −0.5655 [−3.9250, +3.7480] | 4/7 |
| [Lua](lua/paired-summary.tsv) | +0.7523 [−0.4406, +3.0089] | +45,182.5 | +0.1080 [−0.1480, +0.4830] | 1/7 |
| [musl](musl/paired-summary.tsv) | −0.2319 [−1.8720, +3.5856] | +818,192.5 | −1.1335 [−4.8140, +2.2215] | 5/7 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
