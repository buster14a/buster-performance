# Produce the availability filter while recording marked declarations

The declaration walk adds each first marked key to the existing two-word-set filter. The SIMD identifier pass produces the marked bitmap and tells the diagnostic walker whether it contains a use bound to a different token. Redeclarations, availability contexts, tag and member cases retain their original owners. The comparison includes the delayed tag and enum indexes and measures the complete patch against its public parent.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `fbef2d68dfc952c269d7a2fd008220341428e727`. The candidate used `1dd599ff0164c6c60254d6500ba43e82ed2c11a9`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −3.4929 [−5.0468, +14.2141] | -4,763,394.5 | −0.3625 [−0.9930, +1.0430] | 5/7 |
| [Buster](main/paired-summary.tsv) | +4.8983 [+2.4208, +15.7263] | -3,397,788.0 | +1.9205 [−1.8190, +16.7085] | 3/7 |
| [Lua](lua/paired-summary.tsv) | +1.0429 [−2.7421, +5.6186] | -551,609.0 | +0.1140 [−0.1600, +0.4370] | 3/7 |
| [musl](musl/paired-summary.tsv) | +2.5131 [+1.8178, +6.6752] | -37,903.0 | −0.9190 [−2.2490, +2.5440] | 4/7 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.

Creating the keys during declaration scanning reduced SQLite instructions in all seven pairs. The SQLite elapsed change was −0.3625 ms in five faster pairs, whereas the Buster self-compile added 1.9205 ms at the paired median. A Clang 23 MemorySanitizer O3 run of the repository translation-unit check reported a stack overflow in the common warning scan. This candidate remains outside the default compiler. [Local source qualification](qualification/README.md)
