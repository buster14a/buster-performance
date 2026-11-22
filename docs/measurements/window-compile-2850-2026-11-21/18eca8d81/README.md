# Carry precedence candidates through fixed source windows

The forward SIMD precedence pass carries its complete stack to each successive 4,096-token interval. A backward preparation records the future candidates visible from each boundary. Within an interval the reverse SIMD pass starts from that snapshot, and both passes use full-source token indices. Each selected parent is final when emitted.

Each snapshot admits up to 32 candidate tokens. If a boundary needs more candidates, the compiler takes its original whole-unit precedence path before writing any parents. An independent source fixture observes the fallback with 80 nested parentheses at the first boundary. The kernel reuses the three K4 working columns inside the current interval.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `18eca8d81cd7d4653a1acbdcd5027bf02655bcb3`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

Each native PMU observation ran one compiler under the hardware lock. Each elapsed observation held the lock for one `time-runs --runs 1 --warmups 1` command, which launched a warm-up compiler followed by the timed compiler. [Elapsed and PMU commands](ordinary-compare-one.sh)

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | +0.3153 [−1.2894, +0.3452] | +574,445.0 | +0.1800 [−1.0875, +0.1980] | 1/3 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.

## Parser stage and complete compilation

In the exploratory stage screen, the SQLite parser took 6.803 ms in the baseline and 6.630 ms in the candidate. The median paired change was -0.198 ms, with a shorter candidate time in 7 of 7 rounds. Each round used four fresh compiler processes and verified the complete emitted object. The [stage samples](parser-stages/samples.tsv) retain each process.

In the independent wall series, ordinary SQLite compilation took 113.041 ms and 113.169 ms respectively. Its paired change was +0.180 ms over 3 rounds, with 1 shorter. Paired total cycles per token changed by +0.315. The [complete compilation measurements](sqlite/paired-summary.tsv) include the range and fault counters.

Against the preceding implementation at `3543ba2b8`, the per-invocation [incremental stage comparison](parser-stages-direct/summary.tsv) measured +0.050 ms for parsing, with 2 shorter rounds out of seven.
