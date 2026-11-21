# Select cleared warning roots during evaluation initialization

After parent and uniqueness checks establish that the graph is a tree, the candidate selects the roots whose evaluation bit it cleared while initializing each block. The reference visits all roots again after initialization. Both executables compile the frozen inputs through the ordinary artifact-producing driver.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `9be958d5c61538562177a788a76c8c23dead9694`. The candidate used `d2e78d10e4d37f8d3c57e637b6a00c1eae697aca`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −0.5017 [−17.8835, +2.9753] | -2,520,323.0 | −0.1720 [−0.7000, +0.2760] | 5/7 |
| [Buster](main/paired-summary.tsv) | −1.6520 [−39.5892, +4.3619] | -16,360,971.0 | −2.0605 [−3.6685, −0.4415] | 7/7 |

Each of 7 independent rounds per series used a symmetric four-position ABBA or BAAB order, alternating which compiler started. The paired difference uses the mean from its two positions per compiler in each round. Each workload used 28 PMU processes, 28 additional timed wall processes, 28 untimed warm-up processes for wall timing and six independent qualification processes. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.

The [source qualification](correctness/README.md) compares every final evaluation byte, complete object, and diagnostic stream for the two native images run on the validation host.

The [initial three rounds](https://github.com/buster14a/buster-performance/tree/b0ba4fe87a488868c261096cabb672524ba069fa/docs/measurements/window-compile-2850-2026-11-21/d2e78d10e) remain in the seven-round series. The extension preserves each original process measurement and every first-three paired difference.
