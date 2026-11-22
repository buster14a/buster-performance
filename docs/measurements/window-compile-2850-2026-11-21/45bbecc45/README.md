# Compute syntax parents in fixed 4,096-token intervals

Each full interval runs the existing binary precedence search in a fixed working area and writes provisional source parents. The parser identifies tokens that can still see a candidate across the interval boundary and records each strict prefix and suffix minimum. A forward and a reverse pass resolve the outstanding queries with a monotonic stack over these summaries. Each query compares the incoming candidate with its locally available candidate under the unchanged precedence, associativity and opener rules.

The source pass proves that every actual key is at least the depth-zero terminator precedence before using that value to stop a boundary search. Compact depth, directly indexed syntax-check frames, and the full-unit fallback for deep and unproven inputs carry over from the preceding candidate. Production code retains complete public source parent IDs.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `45bbecc45f10e2ba4251763314fd2c1c606e7d72`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

Each native PMU observation ran one compiler under the hardware lock. Each elapsed observation held the lock for one `time-runs --runs 1 --warmups 1` command, which launched a warm-up compiler followed by the timed compiler. [Elapsed and PMU commands](ordinary-compare-one.sh)

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −0.0821 [−9.7578, +2.1977] | +3,494,478.5 | +0.0595 [−0.1660, +0.2170] | 1/3 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.

## Parser stage and complete compilation

In the exploratory stage screen, the SQLite parser took 6.822 ms in the baseline and 6.971 ms in the candidate. The median paired change was +0.149 ms, with a shorter candidate time in 0 of 7 rounds. Each round used four fresh compiler processes and verified the complete emitted object. The [stage samples](parser-stages/samples.tsv) retain each process.

In the independent wall series, ordinary SQLite compilation took 112.475 ms and 112.565 ms respectively. Its paired change was +0.059 ms over 3 rounds, with 1 shorter. Paired total cycles per token changed by -0.082. The [complete compilation measurements](sqlite/paired-summary.tsv) include the range and fault counters.
