# Rank source leaves within groups of sixteen nodes

The graph stores a leaf mask and base index for each group of sixteen nodes. Readers derive the packed leaf slot by counting earlier bits. A source test exercises every offset in consecutive groups with exceptional payloads.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `63a709e0d4a67e71e86ffb15fb8382124fac3570`. The candidate used `de48f0b862cb26097dac0a60ffdf705960bdadef`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | +1.1733 [−10.5547, +1.3424] | +3,913,725.5 | −0.2605 [−0.3065, +0.2515] | 2/3 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
