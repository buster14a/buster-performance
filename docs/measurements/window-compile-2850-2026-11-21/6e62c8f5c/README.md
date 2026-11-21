# First live binding on demand

The candidate stores the first declaration only when a later declaration requests an internal-linkage diagnostic. The direct parent is merged #3251. The exact source includes the sibling-scope regression and the checker-state inventory entry from #3258.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `5bf2b3af9ad68fae14364659bcda23fc645fa71f`. The candidate used `6e62c8f5c2ddcf4377034f20204dfa163c010f1d`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −3.2404 [−3.4436, +4.0503] | -1,601,121.0 | −0.9120 [−1.2215, −0.0325] | 3/3 |
| [Lua](lua/paired-summary.tsv) | +0.6256 [−1.1092, +2.5488] | -551,333.5 | −0.0325 [−0.4030, +0.3975] | 2/3 |
| [musl](musl/paired-summary.tsv) | +0.2544 [−1.4684, +1.0757] | -4,680,891.5 | +0.7820 [−1.6830, +1.8920] | 1/3 |
| [Buster](main/paired-summary.tsv) | −6.4599 [−8.6995, −5.3952] | +1,784,016.5 | −0.5795 [−1.3240, +4.1440] | 2/3 |

Each of 3 independent rounds per series used a symmetric four-position ABBA or BAAB order, alternating which compiler started. The paired difference uses the mean from its two positions per compiler in each round. Each workload used 12 PMU processes, 12 additional timed wall processes, 12 untimed warm-up processes for wall timing and six independent qualification processes. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
