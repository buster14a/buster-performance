# Reuse reader scratch for the checker's dense value stream

The candidate places the checker's long-lived value records, conversions and offsets in reader scratch, extending that arena's ownership through lowering.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `ac6bdeea4482e5f0406b7029e578911582818022`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | +0.0232 [−3.7776, +4.6701] | +1,225,703.0 | +0.2055 [−0.5215, +0.2625] | 1/3 |
| [Buster](main/paired-summary.tsv) | +0.1087 [−4.9786, +7.9880] | +4,186,793.5 | −3.6415 [−63.0790, +5.4340] | 2/3 |
| [Lua](lua/paired-summary.tsv) | +0.1388 [−2.0004, +1.6613] | +367,671.0 | −0.3125 [−0.4945, −0.2840] | 3/3 |
| [musl](musl/paired-summary.tsv) | −3.6457 [−4.6946, +4.9890] | +2,655,952.0 | −3.4430 [−3.9145, −0.5785] | 3/3 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
