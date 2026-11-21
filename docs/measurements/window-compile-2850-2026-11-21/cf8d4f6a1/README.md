# Reusing initialization bits with scratch storage

The production compiler and pristine b86eadcbd compiled frozen SQLite with their ordinary artifact-generating commands. Candidate cf8d4f6a1 retains both temporary initializer payload arrays in the reader scratch, adds a written-slot bit for declaration owners and tests the existing visit bit before reading the finish head. The [two earlier arrangements](../initializer-storage/README.md) were measured separately on the same pristine compiler.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `b86eadcbd3d6c5cdf687f6b67b0281df2ac34034`. The candidate used `cf8d4f6a127a6e68d2b9c8ed5d57d9fc66332f94`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | +0.1483 [−1.3518, +1.8020] | +17,636.5 | −0.0175 [−0.0680, +0.1340] | 2/3 |

Each of 3 independent rounds per series used a symmetric four-position ABBA or BAAB order, alternating which compiler started. The paired difference uses the mean from its two positions per compiler in each round. Each workload used 12 PMU processes, 12 additional timed wall processes, 12 untimed warm-up processes for wall timing and six independent qualification processes. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.

The [source and verification package](correctness/README.md) records 3,400 matched compiler command pairs, 848,405 successful checker assertions, independently run multi-lane controls and seven workstation measurement rounds.
