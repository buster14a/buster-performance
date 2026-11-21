# Main after merging #3247, #3258 and #3250

This comparison measures the cumulative public-main interval from f4f8dd9a1 to de5eae79e. It includes the opt-in constants window, deferred declaration binding heads, empty last-value tables and other intervening main changes. The paired numbers reflect their combined effect.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `f4f8dd9a1663adbdcd1c222e7375f3517d9e47ae`. The candidate used `de5eae79e0ee943d05c18ed2aca60757a619a9c6`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −8.2469 [−10.2101, −7.2269] | -12,036,047.5 | −0.9120 [−1.5825, −0.5235] | 7/7 |
| [Buster](main/paired-summary.tsv) | +5.9186 [+2.5030, +7.7136] | -4,931,349.0 | +0.5425 [−2.3860, +4.4540] | 1/3 |
| [Lua](lua/paired-summary.tsv) | −6.5648 [−7.0251, −5.4224] | -4,912,804.0 | −0.7755 [−1.9385, −0.7025] | 3/3 |
| [musl](musl/paired-summary.tsv) | −1.2926 [−1.7936, −0.1717] | -4,538,084.5 | −1.5835 [−2.9440, −0.8315] | 3/3 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
