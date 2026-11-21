# Publish converted assignment values in their output record

Assignment, initialization and return conversion update the result’s 96-byte value directly. A rejected conversion restores the empty value while preserving its diagnostics and operand conversions. Each comparison includes the full compiler process and its ordinary output.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `fbef2d68dfc952c269d7a2fd008220341428e727`. The candidate used `34689f956b84442844b2b210b31cbb4d42975023`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | +1.5456 [+0.2177, +3.7865] | -106,973.0 | +0.1860 [−0.2180, +0.4295] | 1/3 |
| [Buster](main/paired-summary.tsv) | −2.8681 [−5.5768, −2.5659] | -126,945.5 | +1.7050 [−1.0285, +2.9660] | 1/3 |
| [Lua](lua/paired-summary.tsv) | −0.0539 [−2.6534, +2.7480] | -28,643.5 | −0.1455 [−0.1850, −0.0840] | 3/3 |
| [musl](musl/paired-summary.tsv) | +1.0558 [−2.2418, +1.5265] | -55,570.0 | −1.6860 [−2.7870, −0.0050] | 3/3 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.

The SQLite paired elapsed change was +0.186 ms, with one faster round out of three. Lua and musl improved in each round. The checked-in evidence retains the candidate as an experiment. [Local source qualification](qualification/README.md)
