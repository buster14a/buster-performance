# Schedule wrapper operands from the checked control

During ordinary lowering, an evaluate or branch control can schedule its checked transparent wrapper immediately. The candidate uses the existing checked operand, truth and conversion rules and retains the original node counts. Its ordinary and warning-enabled commands include the complete reader, checker, lowering, backend and ELF output.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `2da593d9abd6922fa69dd981d4be36e6ff3929c5`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | +2.4605 [+1.6296, +2.4827] | -3,352,706.5 | +0.2535 [+0.1335, +0.5080] | 0/3 |
| [Buster](main/paired-summary.tsv) | −0.2961 [−5.6082, +6.6736] | -1,219,724.5 | +2.9080 [+2.7375, +6.4190] | 0/3 |
| [Lua](lua/paired-summary.tsv) | +0.3498 [−0.6665, +0.4105] | -650,193.0 | +0.0090 [−0.0550, +2.2565] | 1/3 |
| [musl](musl/paired-summary.tsv) | +0.4211 [−1.2609, +2.6167] | -1,404,283.5 | −0.2055 [−1.2825, +1.7445] | 2/3 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
