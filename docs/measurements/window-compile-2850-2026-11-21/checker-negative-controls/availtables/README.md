# availtables

Use the same named-use test, initialize only live chain links and defer constructing tag and enum tables until the full diagnostic walk is needed.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `f4f8dd9a1663adbdcd1c222e7375f3517d9e47ae`. The candidate applied patch SHA-256 `fa047b91c5d8f74c7cd9538ad32e444ae4ea8d804aa9b90e2d32b1f349aaedb1` to the same parent. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −3.6427 [−5.9113, −3.2084] | -3,705,444.0 | −0.3675 [−0.4710, −0.2645] | 3/3 |
| [Buster](main/paired-summary.tsv) | +6.4380 [−4.5261, +8.2678] | +281,181.5 | +5.8585 [−0.9310, +7.1315] | 1/3 |
| [Lua](lua/paired-summary.tsv) | −2.9198 [−2.9529, −0.7682] | -401,147.0 | −0.0800 [−0.2480, +0.1885] | 2/3 |
| [musl](musl/paired-summary.tsv) | −0.3769 [−1.6705, +0.0411] | -198,906.0 | −0.4350 [−2.6785, +1.8045] | 2/3 |

Each of 3 independent rounds per series used a symmetric four-position ABBA or BAAB order, alternating which compiler started. The paired difference uses the mean from its two positions per compiler in each round. Each workload used 12 PMU processes, 12 additional timed wall processes, 12 untimed warm-up processes for wall timing and six independent qualification processes. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.

All 848,399 registered assertions passed. Objects, exit status and diagnostics matched for all 4,116 frozen file/policy comparisons. [Checker logs and comparison manifests](checker-and-oracles.tar.xz)
