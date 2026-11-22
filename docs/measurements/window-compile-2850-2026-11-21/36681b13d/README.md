# Encode two graph operands in one byte

For an ordinary large native translation unit the graph can represent its second and third operands together in one byte. Seven bits encode the distance to the second child (zero means absent), and one bit represents a third child immediately before its parent. The reader reconstructs the absolute columns in source order at the first exceptional edge and continues with the ordinary representation. The first operand retains its full index. In a previously captured SQLite graph of 323,623 nodes, every nonempty second operand was at most 26 nodes back and all 672 third operands immediately preceded their parent.

This initial revision fails ordinary compilation of the frozen Buster compiler. A mis-sized SIMD tail mask discarded absolute operands while widening graphs longer than 255 nodes. The SQLite timings are from a working output on that input alone. The source fix is dbd605d8dcb14cf9aba53e6c1ceee654fa8d2946.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `36681b13dde9be02f3001d5d89fd621dfa4f7760`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −4.9465 [−6.9477, +3.4055] | +7,945,646.5 | −0.9120 [−1.1565, −0.2245] | 3/3 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
