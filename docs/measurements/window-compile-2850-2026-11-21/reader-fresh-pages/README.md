# Fresh base pages for six reader columns

Moving six zero-default reader columns from reusable scratch to an anonymous base-page arena removed 8,593,644 bytes of explicit clearing on frozen SQLite. It added 2,112 minor faults and 4.53 million total cycles in the median pair. All three PMU pairs regressed. Wall time increased by 0.709 ms in the median SQLite pair. Self-compilation, Lua and musl also took longer in all three wall pairs. The timings below use the same ordinary parent as the list-head experiment.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `f4f8dd9a1663adbdcd1c222e7375f3517d9e47ae`. The candidate applied patch SHA-256 `26f14f7a5833f4173d3afd95e532e69c172555bcb680ce8ab505c1daf65ab5ec` to the same parent. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | +6.3289 [+5.9111, +7.2057] | -218,363.5 | +0.7090 [−0.7645, +0.8725] | 1/3 |
| [Buster](main/paired-summary.tsv) | +5.6480 [+3.5047, +7.8648] | -1,485,221.5 | +2.4615 [+1.6985, +3.9705] | 0/3 |
| [Lua](lua/paired-summary.tsv) | +2.0293 [−0.5913, +12.3956] | +161,309.0 | +0.1510 [+0.0595, +0.1535] | 0/3 |
| [musl](musl/paired-summary.tsv) | +5.2369 [+3.4790, +5.3066] | +1,248,708.0 | +3.0800 [+2.3335, +4.2880] | 0/3 |

Each of 3 independent rounds per series used a symmetric four-position ABBA or BAAB order, alternating which compiler started. The paired difference uses the mean from its two positions per compiler in each round. Each workload used 12 PMU processes, 12 additional timed wall processes, 12 untimed warm-up processes for wall timing and six independent qualification processes. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
