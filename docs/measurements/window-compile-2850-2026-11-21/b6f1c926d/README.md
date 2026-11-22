The vector selector classifies immediate widths directly in each 64-entry block. Pointer-scale products and local comparisons are evaluated on the candidate lanes that use them. This revision includes the single-pass compound and leaf selector.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `b6f1c926dd34f26c5b82d371180b3ecebeb1ca8d`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | +3.4920 [−0.3371, +5.0750] | -2,648,736.0 | +0.4650 [+0.3005, +0.8390] | 0/3 |
| [Buster](main/paired-summary.tsv) | −1.1023 [−5.6006, +3.3273] | -3,950,504.5 | +0.0830 [−0.5645, +3.4280] | 1/3 |
| [Lua](lua/paired-summary.tsv) | +2.3313 [+0.1002, +4.6073] | -681,512.0 | +0.0880 [−0.1230, +1.7980] | 1/3 |
| [musl](musl/paired-summary.tsv) | −1.7325 [−4.8978, +1.7072] | -1,678,547.5 | +0.4100 [−0.6675, +5.0840] | 1/3 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.

[Local correctness receipts](qa/README.md) cover 4,116 matched compiler invocations and 19,103,566 Tier 0 checks. In the separately instrumented SQLite baseline run, Tier 0 accounted for 4.892 ms of 112.532 ms. Removing that stage's entire measured duration leaves 107.640 ms. Subtracting all 8.592 ms from Tier 0 through object writing leaves 103.940 ms. These [stage-clock bounds](sqlite/stage-ceilings.tsv) use one audited invocation per compiler. The fresh-process elapsed series above determines the measured performance result.
