# Zero-backed initializer owners

An initializer stores its owner's declaration token plus one. A zero-filled slot decodes to the existing no-declaration sentinel. The reader places this column in its existing sparse mapping and omits the unit-wide sentinel fill. The patched build and its independent public parent compile the same inputs.

The one-based owner removed a 2,864,548-byte SQLite fill. It raised elapsed time by a paired median of 0.4820 ms on SQLite and 2.4985 ms across the full musl build. All three musl rounds regressed on elapsed time and total cycles. This variant stays experimental. The 4,116 frozen source and warning-policy comparisons and 360 directed initializer comparisons matched the public parent. Eight checker shards passed 850,925 assertions. [Qualification](qualification/)

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `fbef2d68dfc952c269d7a2fd008220341428e727`. The candidate used `a1f9874c8c77900480f4aea4ca715d456398bd08`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | +0.5532 [−3.1306, +2.5775] | -81,338.0 | +0.4820 [−0.2290, +0.6545] | 1/3 |
| [Buster](main/paired-summary.tsv) | −0.4221 [−1.1099, +6.7626] | -1,475,948.5 | +1.3675 [−0.1580, +1.5190] | 1/3 |
| [Lua](lua/paired-summary.tsv) | −0.7081 [−2.2435, +4.4620] | -47,161.0 | +0.0215 [−0.2415, +0.4800] | 1/3 |
| [musl](musl/paired-summary.tsv) | +5.3703 [+5.2955, +5.7518] | +153,173.0 | +2.4985 [+2.1285, +5.5320] | 0/3 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
