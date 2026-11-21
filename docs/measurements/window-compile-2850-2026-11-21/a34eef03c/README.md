# Exact SIMD membership for marked declarations

The declaration walk inserts each marked declaration number and its canonical object aliases into two 16-lane tables. The lookup compares each bound declaration with both possible slots. A bucket with three or more distinct keys switches the unit to the complete filter and object lookup. The tables are made from actual declarations. The experiment includes their construction, alias scanning, fallback, context construction, and ordinary native object emission.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `fbef2d68dfc952c269d7a2fd008220341428e727`. The candidate used `a34eef03cf3471705b76d8f681edc184d30057c4`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −0.9636 [−4.6933, +2.4689] | -4,829,494.5 | −0.4430 [−1.3715, +0.1705] | 6/7 |
| [Buster](main/paired-summary.tsv) | −3.1910 [−7.9616, +4.7539] | -2,951,645.5 | −1.3890 [−3.1635, +8.3595] | 5/7 |
| [Lua](lua/paired-summary.tsv) | +2.0955 [−0.3242, +4.8098] | -557,459.0 | +0.1545 [−0.3855, +0.3820] | 1/7 |
| [musl](musl/paired-summary.tsv) | +1.4710 [−0.9130, +6.7975] | -3,382.0 | +0.3330 [−6.7530, +2.0400] | 3/7 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
