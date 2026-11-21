# Ordinary compilation after the selected-function, warning and integer-condition changes

Two independently built, unmodified releases compare public main after #3252 and public main after #3257. Seven paired rounds cover ordinary SQLite compilation and three cover each other workload. Changes between these revisions include #3251, #3253, #3255, #3256 and #3257.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `faff3cc89e87489229c7b0eb43fd49106dc950a1`. The candidate used `f4f8dd9a1663adbdcd1c222e7375f3517d9e47ae`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

Frozen SQLite used a median **115.4035 ms** on the later revision, equivalent to **82.38 MB/s** and **887.77 user-plus-kernel cycles per preprocessed token**. The paired reference measured 116.4750 ms. The 1 GB/s target would require 9.5070 ms. Buster self-compilation measured 611.5230 ms on the later revision and 674.4165 ms on the earlier one. [Absolute SQLite measurements](sqlite/paired-summary.tsv) · [Absolute Buster measurements](main/paired-summary.tsv)

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −7.4628 [−9.7791, −4.5265] | -13,995,031.5 | −1.0475 [−5.0465, −0.7770] | 7/7 |
| [Lua](lua/paired-summary.tsv) | −0.8847 [−3.0785, +1.2991] | -3,205,775.5 | −0.0095 [−0.0470, +0.2605] | 2/3 |
| [musl](musl/paired-summary.tsv) | −1.2048 [−1.9720, +0.6674] | -24,750,943.5 | +0.9580 [−7.1320, +2.0245] | 1/3 |
| [Buster](main/paired-summary.tsv) | −141.1536 [−157.2453, −136.3048] | -1,116,631,090.5 | −61.9515 [−64.8375, −59.9415] | 3/3 |

Each of 3 independent rounds per series used a symmetric four-position ABBA or BAAB order, alternating which compiler started. The paired difference uses the mean from its two positions per compiler in each round. Each workload used 12 PMU processes, 12 additional timed wall processes, 12 untimed warm-up processes for wall timing and six independent qualification processes. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
