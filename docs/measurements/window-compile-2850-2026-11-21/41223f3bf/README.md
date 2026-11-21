# Store four ordinary graph leaves in one cache line

On fresh units with at least 8,192 preprocessed tokens, each source leaf has a 16-byte record carrying its type, flags, object, value category, constant kind and a 15-bit unsigned integer. Other values keep a full record in an indexed exception table. Rewriting a value retains its exceptional record once allocated. This compiler also counts graph allocation requirements on completed columns.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `41223f3bf9e7885ee2710b946b8c152ee9d618e0`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −4.4050 [−7.3639, +0.9180] | +581,874.0 | −0.6340 [−0.8150, +2.2820] | 6/7 |
| [Buster](main/paired-summary.tsv) | −3.3919 [−8.8791, −1.1210] | -17,778,516.5 | −0.2140 [−60.0510, +1.0800] | 4/7 |
| [Lua](lua/paired-summary.tsv) | +1.3385 [−2.2384, +2.6067] | +615,551.5 | +0.0270 [−0.3380, +0.2160] | 3/7 |
| [musl](musl/paired-summary.tsv) | −0.6934 [−1.7659, +0.8268] | +8,077,192.5 | −2.6130 [−3.6385, −0.5325] | 7/7 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
