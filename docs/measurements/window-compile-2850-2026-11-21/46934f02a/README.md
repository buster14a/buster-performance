# Lazily resolve ordinary binding linkage

The candidate removes the eager per-binding root propagation from the normal compiler. It resolves the linkage chain for the diagnostic that needs its root. Both compilers run ordinary artifact output using the same frozen sources.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `325883abf9607ac726966a0af2097377832d53ac`. The candidate used `46934f02a45ec58adb24be9e90da94a37344f131`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −7.7530 [−10.9847, −6.4438] | -1,601,255.5 | −1.0530 [−1.0930, −0.1685] | 3/3 |
| [Buster](main/paired-summary.tsv) | −9.5869 [−14.2173, −0.3440] | +1,769,397.5 | −3.5475 [−5.2845, −3.4205] | 3/3 |
| [Lua](lua/paired-summary.tsv) | −4.3360 [−6.8696, −2.6670] | -542,867.5 | −0.2155 [−0.3685, +0.1830] | 2/3 |
| [musl](musl/paired-summary.tsv) | −2.3439 [−3.8899, +0.9116] | -4,506,821.5 | −1.6280 [−3.3580, −1.5460] | 3/3 |

Each of 3 independent rounds per series used a symmetric four-position ABBA or BAAB order, alternating which compiler started. The paired difference uses the mean from its two positions per compiler in each round. Each workload used 12 PMU processes, 12 additional timed wall processes, 12 untimed warm-up processes for wall timing and six independent qualification processes. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
