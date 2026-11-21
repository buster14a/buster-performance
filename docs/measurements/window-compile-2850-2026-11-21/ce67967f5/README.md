# Demand-allocated selected operands after the declaration-head merge

These pairs measure the integrated source of [PR #3262](https://github.com/buster14a/buster/pull/3262) against its second parent, the merge of #3260. The source patch is the complete difference from that parent.

The integrated candidate regressed on musl elapsed in all seven rounds and the self-compile in six. SQLite elapsed improved in two rounds. Public main at the measured parent took 113.044 ms on SQLite, or 84.10 MB/s and 870.34 total cycles per preprocessed token. The candidate took 113.431 ms. The draft is held out of the merge queue.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `fbef2d68dfc952c269d7a2fd008220341428e727`. The candidate used `ce67967f501653fae98ef30b9fec5f856fcca9ed`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | +0.5535 [−2.0990, +4.3129] | -1,936.0 | +0.2600 [−1.1715, +0.8185] | 2/7 |
| [Buster](main/paired-summary.tsv) | +7.9070 [+3.6271, +11.8595] | -1,645,962.0 | +3.1110 [−9.3555, +5.3105] | 1/7 |
| [Lua](lua/paired-summary.tsv) | +1.3473 [−1.1109, +4.3664] | -36,713.0 | +0.0060 [−0.2650, +0.2150] | 3/7 |
| [musl](musl/paired-summary.tsv) | +1.8066 [+0.1643, +5.9097] | -105,029.5 | +3.0280 [+0.7410, +4.2335] | 0/7 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
