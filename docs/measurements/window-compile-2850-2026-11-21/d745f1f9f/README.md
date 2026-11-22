Tier 0 allocates its entry columns together. The vector selector omits the scalar template and length columns, saving six bytes per padded entry.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `d745f1f9f62439f41d64d180f112cf19468ec024`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −0.1947 [−4.6381, +2.7665] | -1,013,071.0 | −0.3875 [−0.8220, −0.2105] | 3/3 |
| [Buster](main/paired-summary.tsv) | +0.2147 [−141.2554, +9.1509] | -637,279.5 | +3.7550 [+1.1040, +4.6795] | 0/3 |
| [Lua](lua/paired-summary.tsv) | +0.3370 [−2.3511, +2.2203] | -407,141.0 | +0.0680 [−0.0560, +0.1320] | 1/3 |
| [musl](musl/paired-summary.tsv) | +1.0941 [+0.3484, +2.8114] | -1,021,063.0 | −1.6805 [−4.5045, +3.1730] | 2/3 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.

[Local correctness receipts](qa/README.md) cover 4,116 matched compiler invocations and 19,103,566 Tier 0 checks. In the separately instrumented SQLite baseline run, Tier 0 accounted for 4.928 ms of 112.849 ms. Removing that stage's entire measured duration leaves 107.921 ms. Subtracting all 8.588 ms from Tier 0 through object writing leaves 104.261 ms. These [stage-clock bounds](sqlite/stage-ceilings.tsv) use one audited invocation per compiler. The fresh-process elapsed series above determines the measured performance result.

The local source census of the same frozen SQLite input counted 2,668 functions, 381,191 typed entries and 303,329 records before final emission. Across that corpus the new allocator removes 29,348 scratch-arena allocation calls and 3,311,658 requested scratch bytes. The latter counts allocations summed across bodies, whose scratch storage is reused. The [QA archive](qa/local-checks.tar.xz) includes the raw census and command.
