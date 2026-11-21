# Skip empty warning-token groups

The common warning scanner appends selected positions from nonempty groups of sixteen tokens. The candidate also keeps the instrumented vector store in a separate frame in MemorySanitizer builds. These Release measurements exercise the sparse group walk.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `fbef2d68dfc952c269d7a2fd008220341428e727`. The candidate used `3469c8cf3221b7ac9e4f951bbe1d9b87eb501a6a`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | +5.3280 [+4.2505, +16.0696] | -1,324,994.5 | +0.4225 [+0.3535, +0.5305] | 0/3 |
| [Buster](main/paired-summary.tsv) | +1.6257 [−0.1682, +9.4203] | -6,493,913.0 | +0.1345 [−7.5220, +1.2580] | 1/3 |
| [Lua](lua/paired-summary.tsv) | +3.3076 [+1.9690, +5.7197] | -753,215.5 | +0.2795 [−0.0575, +0.6265] | 1/3 |
| [musl](musl/paired-summary.tsv) | +3.8484 [+1.0853, +7.1125] | -6,503,708.0 | +0.5360 [+0.4855, +3.3460] | 0/3 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
