# Publish source binding answers in groups of sixteen uses

After validating the ordinary source binding stream, the reader gathers the declarations and types for sixteen identifier uses. It directly publishes a group whose destinations are distinct and uncaptured and whose sources all name resolved ordinary, non-typedef declarations. An incomplete array, a diagnostic case or an ordering dependency returns the group to its event-ordered path.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `0e621afec030265a886f636d40a0f822b44d0dd6`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | +0.7494 [−1.9671, +2.8288] | -9,694,521.0 | +0.2000 [−0.1170, +0.2060] | 1/3 |
| [Buster](main/paired-summary.tsv) | +1.9640 [+1.2007, +6.2905] | -9,433,023.0 | +5.5315 [+1.2595, +9.3125] | 0/3 |
| [Lua](lua/paired-summary.tsv) | +0.2857 [+0.1317, +1.6681] | -1,756,739.0 | +0.1590 [−0.0370, +0.1885] | 1/3 |
| [musl](musl/paired-summary.tsv) | −4.3635 [−5.1208, −2.5760] | -613,076.0 | +0.7280 [−3.1320, +2.1880] | 1/3 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
