# Complete unknown integer conditions from their checked operands

The candidate handles the common integer condition from its checked operand columns and retains its inherited floating-point state. Both native Release executables use ordinary compilation on the same frozen inputs.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `9be958d5c61538562177a788a76c8c23dead9694`. The candidate used `a884290a63ab5aac84fd9e29f0501737ddabfb40`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −3.2335 [−4.1420, −2.3129] | -4,740,636.0 | −0.4350 [−1.7295, +0.0480] | 2/3 |
| [Buster](main/paired-summary.tsv) | −0.6152 [−5.2551, +148.4474] | -5,246,009.5 | −3.0475 [−3.1355, −2.9810] | 3/3 |
| [Lua](lua/paired-summary.tsv) | −2.2637 [−4.6595, +1.1230] | -208,824.0 | −0.0420 [−0.0460, −0.0095] | 3/3 |

Each of 3 independent rounds per series used a symmetric four-position ABBA or BAAB order, alternating which compiler started. The paired difference uses the mean from its two positions per compiler in each round. Each workload used 12 PMU processes, 12 additional timed wall processes, 12 untimed warm-up processes for wall timing and six independent qualification processes. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.

The [source and native correctness checks](correctness/README.md) compare the full checked state across the independent true-parent and production compiler images.
