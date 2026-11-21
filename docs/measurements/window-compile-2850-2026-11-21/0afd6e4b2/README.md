# Delaying availability tables until a named use needs them

This source builds the existing availability contexts first, checks the resolved named uses, and fills the tag and enum indexes when the diagnostic walk needs them. The real checker keeps its original inlining policy. The true parent is public main with #3260 merged.

SQLite saved 4.130 million user instructions and 0.5965 ms at the paired medians, with a shorter elapsed time in every round. Whole Lua and musl took 0.1375 and 1.7175 ms longer by paired median. The self-compile difference was +0.0385 ms. All 4,116 frozen and 378 directed comparison results matched, and the eight checker shards passed 850,925 assertions. [Correctness records](qualification/)

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `fbef2d68dfc952c269d7a2fd008220341428e727`. The candidate used `0afd6e4b2e5ac5b325cc8e9eb8dd3ee4733637cb`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −2.1585 [−6.0955, +1.8429] | -4,130,265.5 | −0.5965 [−0.8175, −0.1250] | 7/7 |
| [Buster](main/paired-summary.tsv) | −2.3733 [−6.9702, +6.2231] | -1,476,008.0 | +0.0385 [−0.9465, +2.1725] | 3/7 |
| [Lua](lua/paired-summary.tsv) | +2.6462 [+0.3491, +3.3290] | -486,584.5 | +0.1375 [−0.1805, +0.3660] | 2/7 |
| [musl](musl/paired-summary.tsv) | +1.4055 [−1.3509, +4.5063] | -31,190.5 | +1.7175 [−1.1570, +2.8095] | 1/7 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
