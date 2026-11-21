# Carry child operands through the reader postorder

The reader queues nonempty child lists until their parent acts. Only a scalar visit restores its direct children to token-indexed columns. An unusually deep or wide expression can materialize the open values and resume the ordinary walk. The compiler still builds and checks its complete graph.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `80b96ee4cc8e036f196f23c98ecbe4f9a33475bc`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | +4.1555 [+1.2401, +6.6042] | +16,543,524.0 | +0.4950 [+0.2595, +0.8820] | 0/3 |
| [Buster](main/paired-summary.tsv) | +9.8911 [−1.0889, +10.3353] | +85,355,720.0 | +5.8030 [+4.0355, +6.7190] | 0/3 |
| [Lua](lua/paired-summary.tsv) | +2.0430 [−0.2709, +2.3117] | +5,890,269.5 | +0.0335 [+0.0090, +0.3655] | 0/3 |
| [musl](musl/paired-summary.tsv) | +1.5545 [+0.4106, +3.5086] | +58,182,472.5 | −1.1245 [−2.2130, +2.0405] | 2/3 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
