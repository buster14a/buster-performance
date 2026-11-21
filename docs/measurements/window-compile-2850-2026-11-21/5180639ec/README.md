# Carry discarded stores and explicit void expressions as statement roots

## Subsequent source qualification

This experimental revision changes the native object for an explicit-void exception return and changes typed dumps for discarded expressions. The timing below records the experimental compiler. [Minimal sources, objects and per-mode results](../discard-source-regressions/README.md)

A completed assignment, update or explicit void expression in a block uses its own node as the control operand. Its semicolon is carried in a compact list, preserving the expression token and the point of evaluation. Every paired process constructs the checked native object.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `5180639ec036edae74c075f83f1ee1c0f4ac8c21`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −5.2999 [−9.2474, −4.3736] | -20,439,025.0 | −0.8350 [−3.1105, −0.4550] | 7/7 |
| [Buster](main/paired-summary.tsv) | −0.3796 [−9.6100, +9.9334] | -25,068,679.5 | +0.9835 [−6.8690, +1.6225] | 2/7 |
| [Lua](lua/paired-summary.tsv) | +1.1663 [−1.9891, +3.5182] | -238,032.5 | +0.2000 [−0.2705, +0.6710] | 1/7 |
| [musl](musl/paired-summary.tsv) | −1.7618 [−8.5608, +2.7005] | -2,787,429.5 | −0.3270 [−7.0660, +1.7500] | 4/7 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
