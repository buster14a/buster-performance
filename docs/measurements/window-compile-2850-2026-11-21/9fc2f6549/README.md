The vector selector resolves compound and leaf fusions in one traversal of each 64-entry block. It carries the preceding block’s raw and fused variants separately so branches spanning two blocks produce the same output.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `9fc2f6549c0996d7d25dc5143469a4e335c14354`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −0.7379 [−98.0174, +0.5654] | -425,878.0 | −0.5160 [−0.5335, +0.2735] | 2/3 |
| [Buster](main/paired-summary.tsv) | +6.7491 [+0.7729, +7.2743] | -503,347.0 | −2.5605 [−9.8765, +0.9660] | 2/3 |
| [Lua](lua/paired-summary.tsv) | +0.7794 [−3.4966, +0.9892] | -122,901.0 | −0.2670 [−0.3765, +0.0050] | 2/3 |
| [musl](musl/paired-summary.tsv) | −4.5101 [−5.0769, +1.0915] | -333,501.0 | −4.6220 [−9.8085, −1.2945] | 3/3 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.

[Local correctness receipts](qa/README.md) cover 4,116 matched compiler invocations and 19,103,566 Tier 0 checks. In the separately instrumented SQLite baseline run, Tier 0 accounted for 4.910 ms of 112.683 ms. Removing that stage's entire measured duration leaves 107.773 ms. Subtracting all 8.541 ms from Tier 0 through object writing leaves 104.142 ms. These [stage-clock bounds](sqlite/stage-ceilings.tsv) use one audited invocation per compiler. The fresh-process elapsed series above determines the measured performance result.

In the SQLite PMU series, baseline round 3 position 4 recorded 56,562 page faults. The other baseline observations recorded about 5,468. This sample drove the third paired difference to −98.017 cycles per token. The separate true-elapsed series had no comparable fault count. All observations are retained in [individual samples](sqlite/samples.tsv).
