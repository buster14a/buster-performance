# Initialize each graph action operand once

The graph reader writes each present operand from its checked stream and gives every missing operand an empty value. All optional fields are initialized explicitly. An action prefilled with nonzero bytes exercises the empty-input case. The benchmark includes the existing checking, diagnostics, lowering, and object emission.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `fbef2d68dfc952c269d7a2fd008220341428e727`. The candidate used `808785688dd6d82a19ffd2aa82b22e2d0a310110`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | +3.2716 [+1.7517, +3.6003] | -34,227.0 | +0.3305 [+0.2445, +0.7265] | 0/3 |
| [Buster](main/paired-summary.tsv) | −2.4136 [−3.5659, +3.5485] | +1,198,172.0 | −1.2235 [−4.5530, +4.1920] | 2/3 |
| [Lua](lua/paired-summary.tsv) | +0.4446 [−1.4536, +1.1021] | -13,466.5 | +0.0320 [−0.0410, +0.1205] | 1/3 |
| [musl](musl/paired-summary.tsv) | −1.0898 [−2.4418, −0.0118] | +550,144.0 | −1.1255 [−2.2065, +0.5515] | 2/3 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.

Initializing live operands directly increased SQLite elapsed time and total cycles in every round. The self-compile retired 1.20 million more user instructions. The candidate remains experimental. [Local source qualification](qualification/README.md)
