# Preserve checked integer values in static initializer lists

The native driver drops discarded void casts only at static braced lists whose elements already have pure integer constant values. Ordinary typed views retain every cast. Real local graph counts fell from 323,623 to 322,108 on SQLite and from 1,407,416 to 1,210,486 on Buster.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `de4448d51fe188f692213bf785539e4edba48ba0`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | +1.5728 [+0.2755, +1.8889] | -1,681,950.5 | +0.2610 [+0.1690, +0.7785] | 0/3 |
| [Buster](main/paired-summary.tsv) | −15.2016 [−17.5622, −2.5235] | -250,617,933.0 | −8.7135 [−9.2535, −5.3600] | 3/3 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
