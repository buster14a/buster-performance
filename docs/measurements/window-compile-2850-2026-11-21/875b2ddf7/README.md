# Declaration list heads on the merged empty-value tables

The [#3260](https://github.com/buster14a/buster/pull/3260) integration preserves the demand-initialized value tables from #3250 and uses existing activation and finish bits to distinguish initialized declaration and initializer list heads. The earlier benchmark of this change ran before #3250 merged. These pairs price the actual combined source against its current integration parent.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `de5eae79e0ee943d05c18ed2aca60757a619a9c6`. The candidate used `875b2ddf7c8cc3b791d5f6140ca315d11a61de44`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −1.9173 [−21.4468, +2.1212] | -74,456.0 | −0.2265 [−0.9750, −0.1270] | 7/7 |
| [Buster](main/paired-summary.tsv) | −5.3000 [−8.6250, +1.2797] | -303,251.5 | −1.1345 [−5.4240, −0.4805] | 7/7 |
| [Lua](lua/paired-summary.tsv) | +0.6046 [−3.3069, +2.9538] | -29,127.5 | −0.0595 [−0.2095, +0.4140] | 5/7 |
| [musl](musl/paired-summary.tsv) | −0.7959 [−2.4824, +0.6026] | -175,387.0 | +0.5370 [−0.8160, +2.7560] | 1/7 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
