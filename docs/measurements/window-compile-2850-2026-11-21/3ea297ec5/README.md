# Read shallow syntax depths directly from their byte representation

The ordinary object driver, vector precedence parser, syntax validation, diagnostics and native program reader share one byte per token for shallow tree depths. A depth above 255 expands the prior prefix in place and resumes full-width storage. Flagged declarations use the scalar parser and publish their corrected depths back to the same tree.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `3ea297ec5655ba40389e3a708bf5260cd2d18557`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

Each native PMU observation ran one compiler under the hardware lock. Each elapsed observation held the lock for one `time-runs --runs 1 --warmups 1` command, which launched a warm-up compiler followed by the timed compiler. [Elapsed and PMU commands](ordinary-compare-one.sh)

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | +1.5253 [−0.4099, +97.5502] | +193,850.5 | +0.3200 [−0.4100, +12.6290] | 1/3 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.

## Parser stage and complete compilation

In the exploratory stage screen, the SQLite parser took 6.847 ms in the baseline and 6.688 ms in the candidate. The median paired change was -0.159 ms, with a shorter candidate time in 7 of 7 rounds. Each round used four fresh compiler processes and verified the complete emitted object. The [stage samples](parser-stages/samples.tsv) retain each process.

In the independent wall series, ordinary SQLite compilation took 113.279 ms and 113.599 ms respectively. Its paired change was +0.320 ms over 3 rounds, with 1 shorter. Paired total cycles per token changed by +1.525. The [complete compilation measurements](sqlite/paired-summary.tsv) include the range and fault counters.
