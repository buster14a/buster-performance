# plaintruth

Extend the checked nonconstant scalar truth path to unqualified builtin integers and pointers, including their simple lvalue and logical-negation consumers.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `f4f8dd9a1663adbdcd1c222e7375f3517d9e47ae`. The candidate applied patch SHA-256 `9373a5c9fce24096c8fe7d4446db8be31b2b9d9602d02c3c020b27b58175e59c` to the same parent. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −2.6155 [−3.0989, −0.4442] | +870,253.0 | +0.0510 [−0.2785, +0.2565] | 1/3 |
| [Buster](main/paired-summary.tsv) | −2.6170 [−3.2690, +3.1170] | +5,734,886.0 | −0.1650 [−1.3100, +1.0525] | 2/3 |
| [Lua](lua/paired-summary.tsv) | +0.7354 [−0.0920, +1.5316] | +719,816.5 | +0.0970 [−0.2775, +0.1885] | 1/3 |
| [musl](musl/paired-summary.tsv) | +0.1081 [−1.3419, +2.6236] | +7,030,587.5 | +1.0690 [+0.7265, +2.8905] | 0/3 |

Each of 3 independent rounds per series used a symmetric four-position ABBA or BAAB order, alternating which compiler started. The paired difference uses the mean from its two positions per compiler in each round. Each workload used 12 PMU processes, 12 additional timed wall processes, 12 untimed warm-up processes for wall timing and six independent qualification processes. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.

All 848,399 registered assertions passed. Objects, exit status and diagnostics matched for all 4,116 frozen file/policy comparisons. [Checker logs and comparison manifests](checker-and-oracles.tar.xz)
