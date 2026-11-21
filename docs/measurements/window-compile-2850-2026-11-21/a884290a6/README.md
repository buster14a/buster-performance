# Complete unknown integer conditions from their checked operands

The candidate handles the common integer condition from its checked operand columns and retains its inherited floating-point state. Both native Release executables use ordinary compilation on the same frozen inputs.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `9be958d5c61538562177a788a76c8c23dead9694`. The candidate used `a884290a63ab5aac84fd9e29f0501737ddabfb40`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −4.1420 [−6.2404, +0.6037] | -4,740,632.0 | −0.3335 [−1.7295, +0.1315] | 4/7 |
| [Buster](main/paired-summary.tsv) | −0.6152 [−5.2551, +148.4474] | -5,246,009.5 | −3.0475 [−3.1355, −2.9810] | 3/3 |
| [Lua](lua/paired-summary.tsv) | −2.2637 [−4.6595, +1.1230] | -208,824.0 | −0.0420 [−0.0460, −0.0095] | 3/3 |

Each independent round per series used a symmetric four-position ABBA or BAAB order, alternating which compiler started. The paired difference uses the mean from its two positions per compiler in each round. SQLite used seven rounds per series (28 PMU, 28 timed wall and 28 additional warm-up processes). Lua and Buster each used three rounds per series (12 PMU, 12 timed wall and 12 additional warm-up processes). Each corpus also received six independent qualification processes. The Lua command compiled all 34 source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.

The [source and native correctness checks](correctness/README.md) compare the full checked state across the independent true-parent and production compiler images.

The [initial three-round result](https://github.com/buster14a/buster-performance/tree/c4fee74794ba3cb138cc95540c5f1d833c627ce6/docs/measurements/window-compile-2850-2026-11-21/a884290a6) preserves each original observation. After the first three SQLite PMU pairs lowered cycles and the first three true-wall pairs spanned zero, four additional unchanged paired rounds were scheduled.

One Buster self PMU pair had 147,307 additional process faults in the candidate paired means and +148.447 total cycles per token. The other two PMU cycle differences favored the candidate. The independent wall positions recorded a maximum difference of three minor faults in a paired process mean and lower elapsed time in each of their three rounds.
