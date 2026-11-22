# Resolve labels and publish final parser depths in one pass

The parser resolves each statement label or ternary colon and immediately corrects a following block-opening brace. The same 64-token pass publishes the final depths for the parent parser and reader. This removes two source-wide walks over roles and token kinds.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `5d2cba36c5b67be56e83d2258fb75289342dcc3f`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | +0.0196 [−5.0319, +4.4192] | -185,142.5 | −0.1120 [−0.3610, +0.2955] | 6/7 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.

## Parser stage and complete compilation

In the exploratory stage screen, the SQLite parser took 6.803 ms in the baseline and 6.790 ms in the candidate. The median paired change was -0.025 ms, with a shorter candidate time in 5 of 7 rounds. Each round used four fresh compiler processes and verified the complete emitted object. The [stage samples](parser-stages/samples.tsv) retain each process.

In the independent wall series, ordinary SQLite compilation took 113.305 ms and 113.338 ms respectively. Its paired change was -0.112 ms over 7 rounds, with 6 shorter. Paired total cycles per token changed by +0.020. The [complete compilation measurements](sqlite/paired-summary.tsv) include the range and fault counters.
