# availuse

After building the required availability contexts, skip the diagnostic walk when every attributed declaration is a named object, enumerator or function and its only marked identifier occurrences are self declarations.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `f4f8dd9a1663adbdcd1c222e7375f3517d9e47ae`. The candidate applied patch SHA-256 `31eb1024185c3d7b15e80c1db0026a1bc6d439ce2f70ccf26abf9e85788ebf5d` to the same parent. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −1.0722 [−3.9913, +4.2781] | -3,339,506.5 | −0.0535 [−0.8515, +0.5315] | 4/7 |
| [Buster](main/paired-summary.tsv) | +3.5500 [−5.1108, +13.0019] | +50,467.5 | +2.0900 [−1.5290, +6.4645] | 2/7 |
| [Lua](lua/paired-summary.tsv) | −0.1227 [−2.6331, +10.4023] | -361,180.0 | −0.0445 [−0.2740, +0.4490] | 5/7 |
| [musl](musl/paired-summary.tsv) | −1.0035 [−3.3776, +1.7473] | -77,954.5 | +0.0360 [−2.0435, +2.5215] | 3/7 |

Each of 7 independent rounds per series used a symmetric four-position ABBA or BAAB order, alternating which compiler started. The paired difference uses the mean from its two positions per compiler in each round. Each workload used 28 PMU processes, 28 additional timed wall processes, 28 untimed warm-up processes for wall timing and six independent qualification processes. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.

All 848,399 registered assertions passed. Objects, exit status and diagnostics matched for all 4,116 frozen file/policy comparisons. [Checker logs and comparison manifests](checker-and-oracles.tar.xz)
