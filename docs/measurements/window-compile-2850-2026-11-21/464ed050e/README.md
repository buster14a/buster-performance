# Read shallow syntax depths directly from their byte representation

The ordinary object driver, vector precedence parser, syntax validation, diagnostics and native program reader share one byte per token for shallow tree depths. A depth above 255 expands the prior prefix in place and resumes full-width storage. Flagged declarations use the scalar parser and publish their corrected depths back to the same tree.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `464ed050e9b04d1df962685eedb2899ccbb698ef`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | +2.0125 [+1.8737, +96.8745] | -362,607.5 | +0.4530 [+0.1290, +0.4720] | 0/3 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.

## Parser stage and complete compilation

The SQLite parser took 6.845 ms in the baseline and 6.598 ms in the candidate. The median paired change was -0.232 ms, with a shorter candidate time in 7 of 7 rounds. Each round used four fresh compiler processes and verified the complete emitted object. The [stage samples](parser-stages/samples.tsv) retain each process.

In the independent wall series, ordinary SQLite compilation took 113.114 ms and 113.587 ms respectively. Its paired change was +0.453 ms over 3 rounds, with 0 shorter. Paired total cycles per token changed by +2.012. The [complete compilation measurements](sqlite/paired-summary.tsv) include the range and fault counters.
