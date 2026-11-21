# Materializing an identifier's graph leaf from its declaration

The ordinary graph builder uses a per-walk table of 512 previously materialized declarations and exact use types. For a reusable address it copies the complete compact graph record directly to the new node. Token-specific register, enum, overload and weak semantics remain on the existing path. Initialization, misses, collisions and expansion into the private graph rows are included in the measurements.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `6f02f9549508fd3c99f5b6ff27bb794d4c9a3aed`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | +5.2539 [+3.0162, +8.7634] | +777,528.0 | +0.4885 [+0.4590, +1.1030] | 0/3 |
| [Buster](main/paired-summary.tsv) | +8.5666 [+4.2923, +9.2131] | -2,799,894.0 | +1.9995 [−0.5045, +4.2505] | 1/3 |
| [Lua](lua/paired-summary.tsv) | +1.4724 [−0.0066, +3.9574] | +791,345.0 | +0.2310 [+0.1380, +0.3430] | 0/3 |
| [musl](musl/paired-summary.tsv) | +1.2034 [−0.1910, +11.3519] | +3,379,453.0 | +0.6180 [+0.1305, +1.5365] | 0/3 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
