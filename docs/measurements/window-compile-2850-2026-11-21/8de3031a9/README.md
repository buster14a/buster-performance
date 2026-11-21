# Finish a bare declaration name in the reader

The reader recognizes a one-token named declarator after it has established the full declarator boundary. For a plain name it records the inherited type and declaration state directly and skips the transient frame, parts and parameter allocations. The ordinary reader still processes its declaration, scope, initializer and attributes.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `fbef2d68dfc952c269d7a2fd008220341428e727`. The candidate used `8de3031a9075d695fc8035201488d875309fe656`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −1.7332 [−2.0390, −0.5297] | -2,619,715.5 | +0.0640 [−0.2285, +0.1355] | 1/3 |
| [Buster](main/paired-summary.tsv) | −1.6308 [−1.9901, +6.3061] | -9,614,551.0 | +1.3525 [+0.2785, +1.7340] | 0/3 |
| [Lua](lua/paired-summary.tsv) | −1.1979 [−2.9006, +0.5621] | -2,553,213.5 | −0.2480 [−0.4825, +0.2740] | 2/3 |
| [musl](musl/paired-summary.tsv) | −4.1336 [−5.9838, −1.6395] | -10,971,378.0 | −3.5005 [−3.6200, −1.2945] | 3/3 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
