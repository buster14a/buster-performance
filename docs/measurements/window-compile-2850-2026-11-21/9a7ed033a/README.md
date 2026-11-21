# Publish rowless checked values in the expression reader

When the reader resolves a leaf with valid type and no additional payload, it populates the checked columns and records readiness in a bitmap. The ordinary checker takes those columns and walks the remaining nodes in dependency order. Both compilers emit complete native objects during every observation.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `9a7ed033a60d1711e92ec062a0117227b32de68e`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | +9.3214 [+9.0625, +9.6244] | -9,927,715.0 | +1.3290 [+1.0685, +1.6565] | 0/3 |
| [Buster](main/paired-summary.tsv) | +6.5785 [−2.3392, +7.8300] | -35,033,168.5 | +2.4590 [−0.6285, +3.8440] | 1/3 |
| [Lua](lua/paired-summary.tsv) | +1.0269 [−0.3058, +2.1877] | -230,492.5 | −0.0025 [−0.1505, +0.0590] | 2/3 |
| [musl](musl/paired-summary.tsv) | −1.4838 [−2.0081, +0.8827] | -2,217,408.0 | −0.8745 [−1.1000, +0.1185] | 2/3 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
