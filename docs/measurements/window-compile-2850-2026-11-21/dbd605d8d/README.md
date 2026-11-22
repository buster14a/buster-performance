# Restore wide graph operands across the full prefix

The source reader uses postorder distances for the second and third graph operands. At the first out-of-range edge, it restores absolute operands for all previous nodes using a SIMD tail count clamped to sixteen lanes. A permanent regression checks exceptions after 259 and 519 rows and a partial final vector. The original prefix conversion failed the Buster self-compilation. [Original three-policy failure](../36681b13d/self-regression/)

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `dbd605d8dcb14cf9aba53e6c1ceee654fa8d2946`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −5.5848 [−5.7576, −3.8682] | +7,945,642.5 | −0.3560 [−0.8900, −0.2215] | 3/3 |
| [Buster](main/paired-summary.tsv) | +9.1886 [+7.0559, +12.4099] | +16,379,399.5 | +0.7095 [−3.0950, +63.7600] | 1/3 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
