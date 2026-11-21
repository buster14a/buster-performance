# Encode parser edges at block boundaries

For each 64-token parse block, sixteen preceding openers and the existing local edge lanes supply the full enclosing positions. A block with a deep external dependency uses the original dense representation. The reference and candidate build the complete parse and native object in every timed command.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `883266ccccaf0ad56aec76fda15d7fa7567b5daa`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −0.2862 [−1.0138, +1.5459] | +537,805.5 | −0.0210 [−0.2265, +0.2525] | 2/3 |
| [Buster](main/paired-summary.tsv) | −0.3558 [−0.7968, +24.0113] | +1,661,257.5 | −0.7170 [−2.1315, +1.9220] | 2/3 |
| [Lua](lua/paired-summary.tsv) | +0.5115 [−0.3481, +5.1089] | +665,020.0 | +0.0845 [+0.0230, +0.1525] | 0/3 |
| [musl](musl/paired-summary.tsv) | −0.5563 [−1.0022, +0.6061] | +5,359,385.5 | −0.4865 [−1.9825, +0.7145] | 2/3 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
