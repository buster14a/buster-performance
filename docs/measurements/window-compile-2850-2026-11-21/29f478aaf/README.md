# Collecting expression profiling data only for measured compilation

Both versions compiled ordinary translation units. Candidate 29f478aaf skips profile-only action counting and timestamp accounting when the driver has not requested measurements. Separate `--time-stages` runs retain timing instrumentation. The whole-driver PMU and elapsed measurements used the normal executable with its uninstrumented compile options.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `b86eadcbd3d6c5cdf687f6b67b0281df2ac34034`. The candidate used `29f478aafc3dc6218654f7007fb68da28d13cc72`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | +0.5224 [−5.0694, +4.2420] | -2,510,935.0 | −0.1325 [−0.3185, +0.0935] | 4/7 |
| [Buster](main/paired-summary.tsv) | +2.2580 [−9.6461, +9.9950] | -10,509,549.5 | −0.8725 [−11.4765, +2.3105] | 6/7 |
| [Lua](lua/paired-summary.tsv) | −3.1004 [−7.6932, −0.4562] | -955,454.0 | −0.0930 [−0.3530, +1.0610] | 4/7 |
| [musl](musl/paired-summary.tsv) | −2.1641 [−4.8505, +1.9808] | -12,096,165.5 | −0.4795 [−3.7000, +4.2285] | 5/7 |

Each of 7 independent rounds per series used a symmetric four-position ABBA or BAAB order, alternating which compiler started. The paired difference uses the mean from its two positions per compiler in each round. Each workload used 28 PMU processes, 28 additional timed wall processes, 28 untimed warm-up processes for wall timing and six independent qualification processes. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.

[PR #3252](https://github.com/buster14a/buster/pull/3252) reduced user instructions in all 28 paired workload-rounds. Lua also used fewer total cycles/token in all seven pairs. Combined cycle ranges on SQLite, musl and the compiler itself crossed zero. The paired elapsed medians were lower on all four workloads, and each elapsed range crossed zero. The [first three rounds](https://github.com/buster14a/buster-performance/tree/802cfbeab00a61781aa98aef863b59aaa3686542/docs/measurements/window-compile-2850-2026-11-21/29f478aaf) are retained in the extended series.
