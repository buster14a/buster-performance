# Select cleared warning roots during evaluation initialization

After parent and uniqueness checks establish that the graph is a tree, the candidate selects the roots whose evaluation bit it cleared while initializing each block. The reference visits all roots again after initialization. Both executables compile the frozen inputs through the ordinary artifact-producing driver.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `9be958d5c61538562177a788a76c8c23dead9694`. The candidate used `d2e78d10e4d37f8d3c57e637b6a00c1eae697aca`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −6.7623 [−7.9236, −0.2604] | -2,520,324.5 | −0.2735 [−0.6315, −0.0035] | 3/3 |
| [Buster](main/paired-summary.tsv) | −0.6997 [−1.6520, +4.3381] | -16,361,357.0 | −2.0605 [−2.8810, −0.4415] | 3/3 |

Each of 3 independent rounds per series used a symmetric four-position ABBA or BAAB order, alternating which compiler started. The paired difference uses the mean from its two positions per compiler in each round. Each workload used 12 PMU processes, 12 additional timed wall processes, 12 untimed warm-up processes for wall timing and six independent qualification processes. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.

The [source qualification](correctness/README.md) compares every final evaluation byte, complete object, and diagnostic stream for the two native images run on the validation host.
