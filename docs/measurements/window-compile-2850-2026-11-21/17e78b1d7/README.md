# Publish complete integer expressions from the pending reader batch

The terminator or return action recognizes a closed local assignment or an integer return directly from already bound leaves and their pending operators. The producer reclaims the unflushed graph slots and publishes one checked summary with native rows and any warning events. The compile reads the original complete source and emits ordinary ELF relocatable objects.

The source dump oracle rejected this revision. With the same padded input and matching artifact SHA-256, the unmodified compiler printed 11 typed graph rows and the candidate printed six. The corrected revision preserves the public dump and audit driver paths. The [padded input](dump-edge.c.gz) and [complete typed change](typed-dump.diff) reproduce the original failure.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `17e78b1d7646d0e94593cb01695f5c42c6621125`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | +6.9525 [+6.7299, +11.0577] | -2,486,572.5 | +0.8970 [+0.5035, +0.9590] | 0/3 |
| [Buster](main/paired-summary.tsv) | +9.6223 [+5.7089, +11.3549] | +513,117.0 | +3.9710 [+0.7415, +4.1135] | 0/3 |
| [Lua](lua/paired-summary.tsv) | +0.6924 [+0.6555, +0.9662] | -64,059.5 | +0.1985 [−0.0435, +0.4135] | 1/3 |
| [musl](musl/paired-summary.tsv) | +1.2246 [+1.0455, +1.5976] | -1,136,130.5 | +0.6400 [−0.2675, +3.1175] | 1/3 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
