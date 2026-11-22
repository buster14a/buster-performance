# Store graph operators in one byte

The ordinary reader writes one opcode byte per physical graph node. Check actions retain their enum and load only live bytes for vector widening. The common-warning classifier takes one 64-byte vector for 64 nodes. Indexed vector consumers bound their four-byte gathers to the actual allocation, including graphs shorter than four nodes.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `8f1fdc6dcb0319943d322091cadaab1ca0af69c6`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −1.3764 [−2.1267, −1.1283] | +1,046,010.0 | −0.2575 [−0.3725, +0.6135] | 2/3 |
| [Buster](main/paired-summary.tsv) | +3.4554 [−6.4710, +6.6244] | -6,897,429.0 | −0.8025 [−2.0605, −0.1165] | 3/3 |
| [Lua](lua/paired-summary.tsv) | +0.7627 [−2.1240, +2.2773] | +203,022.0 | +0.2525 [−0.1340, +0.3320] | 1/3 |
| [musl](musl/paired-summary.tsv) | +4.6827 [−1.8439, +4.7347] | +2,245,652.5 | +1.2515 [+0.3835, +1.7750] | 0/3 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
