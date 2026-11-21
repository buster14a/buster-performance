# Carry discarded expressions in a packed node bitmap

In units of at least 8,192 preprocessed tokens a bitmap marks ordinary store, call, arithmetic and explicit void expression roots. The graph retains the original operand. Control grouping recovers its semicolon from the expression end and closing parentheses. The graph and native output of every translation unit are constructed during the timed process.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `49bb4d89dc48c7877eeee5724283caf16de871fb`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −6.4904 [−42.0632, −3.5612] | -23,877,809.0 | −0.7655 [−1.2475, −0.1735] | 7/7 |
| [Buster](main/paired-summary.tsv) | −1.7179 [−8.9523, +4.5793] | -31,506,117.5 | −0.0060 [−4.4445, +2.5460] | 4/7 |
| [Lua](lua/paired-summary.tsv) | +0.2135 [−2.0676, +3.5302] | +275,554.0 | +0.0095 [−1.4435, +0.3550] | 3/7 |
| [musl](musl/paired-summary.tsv) | +0.9809 [−0.0241, +3.2756] | +2,060,279.5 | +0.3815 [−1.0860, +1.0440] | 1/7 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
