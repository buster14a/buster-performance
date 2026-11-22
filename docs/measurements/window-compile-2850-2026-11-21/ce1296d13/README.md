# Publish successful arrow member checks in source order

For a pointer lvalue checked outside constant evaluation, the checker records a successful lookup by pointer type, member name and source flags. A later source position with the same inputs can use that checked member type, flags, lvalue conversion and bit offset directly. The 256 entries occupy ordering scratch that the ordinary postorder schedule has already reserved.

A native debugger observed 1,081 uses of the cache in Lua’s lvm.c and 28 in musl’s vfprintf.c. SQLite and Buster self recorded zero hits. Both contain ordinary structure fields whose spelling also names a vector lane, and the original admission test rejected any translation unit with such a spelling. All five captured checked graphs and typed streams matched their controls. [Native admission and hit counts](qualification/native-columns/coverage.tsv)

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `ce1296d1392260b67f9a8a42ccaf1d0207854bc2`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | +2.6842 [−1.5757, +4.2472] | +2,558,635.0 | +0.3080 [−0.4365, +0.6900] | 1/3 |
| [Buster](main/paired-summary.tsv) | +5.7950 [+1.5804, +6.8499] | +11,509,659.5 | +2.9315 [+1.7355, +4.9595] | 0/3 |
| [Lua](lua/paired-summary.tsv) | +3.4349 [+0.3229, +8.0751] | -54,832.0 | +0.2460 [−0.0510, +2.5910] | 1/3 |
| [musl](musl/paired-summary.tsv) | −0.1106 [−1.4501, +1.1666] | +5,945,350.0 | −3.0085 [−6.8850, −1.4910] | 3/3 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
