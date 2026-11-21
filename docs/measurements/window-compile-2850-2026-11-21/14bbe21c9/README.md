# Sparse zero-backed pages for ordinary definition origins

Candidate 14bbe21c9 stores the existing 32-bit definition origins in the reader’s sparse zero-backed allocation. The compiler retains the original origin values. The [tagged sparse representation](../57db83692/README.md) was an earlier separate experiment on the same parent. These paired measurements compare the direct sparse implementation with the unmodified parent.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `b86eadcbd3d6c5cdf687f6b67b0281df2ac34034`. The candidate used `14bbe21c94a18158111c347bd399d918f44e7ee9`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | +1.4366 [+0.0979, +2.7196] | -73,449.5 | +0.8710 [+0.1055, +1.7725] | 0/3 |
| [Buster](main/paired-summary.tsv) | +7.5324 [+3.7815, +151.0517] | -1,002,209.5 | +1.7845 [+0.7550, +3.1845] | 0/3 |

Each of 3 independent rounds per series used a symmetric four-position ABBA or BAAB order, alternating which compiler started. The paired difference uses the mean from its two positions per compiler in each round. Each workload used 12 PMU processes, 12 additional timed wall processes, 12 untimed warm-up processes for wall timing and six independent qualification processes. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.

Ordinary SQLite and compiler-self elapsed times and combined cycles increased in all three paired rounds. One candidate compiler-self PMU process incurred 310,442 faults. The other candidate observations had about 17,870 and the parent about 16,502. The two compiler-self PMU rounds without that observation still increased total cycles/token by 3.7815 and 7.5324. In the independently measured wall series the candidate added 1,370 compiler-self minor faults and 663.5 SQLite minor faults at the paired medians.
