# Collecting expression profiling data only for measured compilation

Both versions compiled ordinary translation units. Candidate 29f478aaf skips profile-only action counting and timestamp accounting when the driver has not requested measurements. Separate `--time-stages` runs retain timing instrumentation. The whole-driver PMU and elapsed measurements used the normal executable with its uninstrumented compile options.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `b86eadcbd3d6c5cdf687f6b67b0281df2ac34034`. The candidate used `29f478aafc3dc6218654f7007fb68da28d13cc72`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | +0.5224 [−5.0694, +4.2420] | -2,510,923.5 | −0.1325 [−0.2155, +0.0935] | 2/3 |
| [Buster](main/paired-summary.tsv) | +1.1932 [+0.9667, +5.9593] | -10,531,551.5 | −0.2520 [−0.6070, +2.3105] | 2/3 |
| [Lua](lua/paired-summary.tsv) | −3.1004 [−6.6306, −1.4502] | -954,802.0 | −0.2205 [−0.3530, +1.0610] | 2/3 |
| [musl](musl/paired-summary.tsv) | −2.1641 [−4.5527, −0.2213] | -12,074,734.5 | −2.7090 [−3.7000, −1.5120] | 3/3 |

Each of 3 independent rounds per series used a symmetric four-position ABBA or BAAB order, alternating which compiler started. The paired difference uses the mean from its two positions per compiler in each round. Each workload used 12 PMU processes, 12 additional timed wall processes, 12 untimed warm-up processes for wall timing and six independent qualification processes. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
