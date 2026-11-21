# Retaining measured expression profiles after integrating the debug window

The [original profile change](../29f478aaf/README.md) completed seven full-driver pairs on b86eadcbd. [PR #3252](https://github.com/buster14a/buster/pull/3252) subsequently resolved the neighboring driver assignments with merged #3219. These new runs compare the actual rebased candidate and its own direct mainline parent.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `325883abf9607ac726966a0af2097377832d53ac`. The candidate used `74f29bd50bd75f519e053c3edd148381a300147d`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −3.5852 [−6.5651, +2.0888] | -2,510,594.5 | −1.0315 [−1.4200, −0.5555] | 3/3 |
| [Buster](main/paired-summary.tsv) | −5.4048 [−14.5923, −2.8791] | -10,499,685.0 | −1.1475 [−5.2385, +16.0710] | 2/3 |
| [Lua](lua/paired-summary.tsv) | −2.9056 [−5.0733, −2.1408] | -949,443.5 | −0.2390 [−0.3220, +0.0790] | 2/3 |
| [musl](musl/paired-summary.tsv) | −5.7433 [−9.0166, −5.1991] | -11,915,935.5 | −4.5215 [−4.5440, −3.3800] | 3/3 |

Each of 3 independent rounds per series used a symmetric four-position ABBA or BAAB order, alternating which compiler started. The paired difference uses the mean from its two positions per compiler in each round. Each workload used 12 PMU processes, 12 additional timed wall processes, 12 untimed warm-up processes for wall timing and six independent qualification processes. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.

The resolved source reduced retired user instructions in every paired round of all four workloads. SQLite and musl also reduced elapsed time in each round. The Buster compiler and Lua elapsed ranges crossed zero. Three rounds per input provide a shorter check on this integration than the seven rounds on the [original source](../29f478aaf/README.md).
