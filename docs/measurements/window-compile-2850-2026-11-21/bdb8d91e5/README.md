# Publish complete integer expressions from the pending reader batch

The terminator or return action recognizes a closed local assignment or an integer return directly from already bound leaves and their pending operators. The producer reclaims the unflushed graph slots and publishes one checked summary with native rows and any warning events. The compile reads the original complete source and emits ordinary ELF relocatable objects.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `bdb8d91e5e6638ed51fd965a4cd28f70af9fdcb3`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

Each native PMU observation ran one compiler under the hardware lock. Each elapsed observation held the lock for one `time-runs --runs 1 --warmups 1` command, which launched a warm-up compiler followed by the timed compiler. [Elapsed and PMU commands](ordinary-compare-one.sh)

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | +3.0524 [−0.3032, +8.8595] | -2,481,687.0 | +1.4725 [+1.2370, +1.7385] | 0/3 |
| [Buster](main/paired-summary.tsv) | +16.6403 [+9.5968, +16.7499] | +512,108.0 | +3.5100 [+3.0265, +3.5255] | 0/3 |
| [Lua](lua/paired-summary.tsv) | +3.9754 [+1.8130, +5.2417] | -55,544.0 | +0.4335 [+0.1755, +0.6775] | 0/3 |
| [musl](musl/paired-summary.tsv) | +1.9628 [−3.5995, +2.1234] | -1,139,812.0 | −2.4235 [−10.1325, +3.2700] | 2/3 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
