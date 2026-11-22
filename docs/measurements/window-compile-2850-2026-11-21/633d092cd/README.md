# Preserve the resolver's token mask from its producer

The token-count pass already forms a 64-bit mask of source-order resolver visits. A single large translation unit retains one word per 64 tokens, extending it when declaration processing schedules a new visit. The reader uses these words to select its next token. Detailed reasons remain in the byte column for handlers that need them. Small, deferred, scalar and attested units continue to use their existing walk.

At this revision the attested reader ownership inventory test failed in checker shard 6. A subsequent revision adds the two ownership declarations and an independent mask test. The measurements here apply to the original revision.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `633d092cdb7064570d93cf539f69df3ab2aee31b`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | +3.6004 [+2.9806, +5.6233] | +1,178,035.5 | −0.7815 [−0.9650, −0.6395] | 3/3 |
| [Buster](main/paired-summary.tsv) | +5.7558 [+4.4422, +11.0474] | +3,353,206.5 | +2.0905 [−16.0370, +4.9550] | 1/3 |
| [Lua](lua/paired-summary.tsv) | +0.5102 [−0.6111, +3.5118] | +1,458,797.5 | +0.0325 [−0.1090, +0.1275] | 1/3 |
| [musl](musl/paired-summary.tsv) | +1.9557 [+0.9663, +2.7043] | +10,365,806.0 | −4.5345 [−4.6430, +0.3045] | 2/3 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
