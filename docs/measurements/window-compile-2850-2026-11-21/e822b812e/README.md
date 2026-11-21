# Publish the first executable root of a statement in the reader

## Subsequent source qualification

This experimental revision changes the native object for an explicit-void exception return and changes typed dumps for discarded expressions. The timing below records the experimental compiler. [Minimal sources, objects and per-mode results](../discard-source-regressions/README.md)

A complete statement carries its own first control node. For fresh source units with at least 8,192 preprocessed tokens, the program writer reads these heads on demand and walks consecutive wrappers for statements with several expressions. Variable-length arrays, recovered errors and the optional selection census use the full inverse node list. The candidate also carries the discarded-expression context on the producing node.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `e822b812e4d96bf387326a677dcf3e11c7294a33`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −10.3101 [−13.8856, −5.2538] | -26,844,215.5 | −1.3965 [−1.7645, −0.6430] | 7/7 |
| [Buster](main/paired-summary.tsv) | −5.7156 [−13.8810, +4.9105] | -43,511,702.5 | −1.6640 [−12.6145, +0.5740] | 5/7 |
| [Lua](lua/paired-summary.tsv) | +1.1366 [−0.2711, +2.6514] | +414,144.0 | +0.2750 [−0.1500, +0.4620] | 2/7 |
| [musl](musl/paired-summary.tsv) | +1.2295 [−0.7678, +3.2821] | +2,313,279.0 | +0.2595 [−3.6100, +3.2660] | 3/7 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
