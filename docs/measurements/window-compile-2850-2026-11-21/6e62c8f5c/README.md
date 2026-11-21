# First live binding on demand

The candidate stores the first declaration only when a later declaration requests an internal-linkage diagnostic. The direct parent is merged #3251. The exact source includes the sibling-scope regression and the checker-state inventory entry from #3258.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `5bf2b3af9ad68fae14364659bcda23fc645fa71f`. The candidate used `6e62c8f5c2ddcf4377034f20204dfa163c010f1d`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −3.2404 [−5.7029, +4.0503] | -1,601,117.0 | −0.2260 [−1.2215, +0.3270] | 6/7 |
| [Lua](lua/paired-summary.tsv) | +0.8439 [−1.1092, +2.5488] | -550,582.0 | −0.1625 [−0.5430, +0.3975] | 6/7 |
| [musl](musl/paired-summary.tsv) | −0.0274 [−1.4684, +2.0798] | -4,680,891.5 | −0.7080 [−2.3145, +2.0840] | 4/7 |
| [Buster](main/paired-summary.tsv) | −5.3952 [−8.6995, +0.3479] | +1,776,527.0 | −1.1685 [−2.4610, +4.1440] | 5/7 |

Each of 7 independent rounds per series used a symmetric four-position ABBA or BAAB order, alternating which compiler started. The paired difference uses the mean from its two positions per compiler in each round. Each workload used 28 PMU processes, 28 additional timed wall processes, 28 untimed warm-up processes for wall timing and six independent qualification processes. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
