# Publish native statement heads and preserve observable discard conversions

The ordinary native driver represents a completed discarded rvalue at its own source node and publishes a direct statement head. Output that exposes typed entries retains its full conversion rows. Exception-return lowering accounts for the implicit statement cast when determining whether the call is the entire statement. The scalar path provides a full-graph control.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `63a709e0d4a67e71e86ffb15fb8382124fac3570`. The candidate used `a984e44fad2a993acace8b1fa1265cd6bf60b529`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −8.0912 [−12.0262, −2.5953] | -26,909,992.5 | −1.2630 [−1.7070, −1.0590] | 7/7 |
| [Buster](main/paired-summary.tsv) | −3.7279 [−16.1276, −0.2951] | -42,861,747.0 | −2.9800 [−5.1510, +0.3765] | 6/7 |
| [Lua](lua/paired-summary.tsv) | +1.9343 [−2.0589, +39.6753] | +568,032.5 | +0.3030 [+0.0365, +0.3810] | 0/7 |
| [musl](musl/paired-summary.tsv) | +0.0657 [−14.0542, +1.7932] | +4,265,941.5 | +2.4010 [−0.1125, +4.3760] | 2/7 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
