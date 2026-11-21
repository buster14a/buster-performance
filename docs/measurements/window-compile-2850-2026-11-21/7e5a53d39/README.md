# Packing the expression reader’s comma contexts

The candidate packs the inherited comma context of 64 consecutive source tokens into a single word. The parser still resolves inherited separator contexts in dependency order, with a scalar fallback when a parent points in the other direction. Three symmetric rounds compared the original public parent and the experimental branch.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `5d880269932b70962e31bbcdaf71330fa263c423`. The candidate used `7e5a53d39dd9cb1e3228dc8988e4698c845d3cdb`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −0.9539 [−12.0781, −0.1771] | +233,909.5 | +0.0600 [−0.1995, +0.5185] | 1/3 |
| [Buster](main/paired-summary.tsv) | +1.9923 [+1.1983, +13.2399] | +2,250,883.5 | +1.2865 [−0.8100, +4.3320] | 1/3 |
| [Lua](lua/paired-summary.tsv) | −0.8285 [−2.2383, −0.2602] | +89,267.5 | +0.1170 [−0.1055, +0.2475] | 1/3 |
| [musl](musl/paired-summary.tsv) | −1.3674 [−2.2716, +0.2177] | +1,261,144.0 | −1.7000 [−5.4845, −0.6910] | 3/3 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
