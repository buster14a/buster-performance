The current-main candidate consumes packed parser records for named function, parameter and local object declarations in an ordinary source-order compilation. The table compares the rebase with the public merge that made discarded statement roots ordinary.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `40ae34f9d77afc42face58eff3338b7b1d1ba469`. The candidate used `a137ff13cb1a4184a0059710c2ef93bbd0fc173c`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −2.9409 [−6.6540, +1.2981] | -18,564,279.5 | −0.3845 [−1.5400, +1.1995] | 6/7 |
| [Buster](main/paired-summary.tsv) | +0.2594 [−8.5819, +130.3925] | -24,609,650.5 | −3.3400 [−7.1325, −0.1750] | 7/7 |
| [Lua](lua/paired-summary.tsv) | −1.2884 [−2.3082, +1.0876] | +701,158.0 | −0.2070 [−0.6925, −0.1270] | 7/7 |
| [musl](musl/paired-summary.tsv) | −0.8378 [−2.3167, +0.5311] | +5,414,966.5 | −0.6620 [−3.4475, −0.0605] | 7/7 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler contributed two PMU samples and two elapsed-time samples to each round. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.

The [source and current-main qualification archive](local-source-oracle.tar.xz) contains the implementation patch, 3,608 source-policy controls, independent Clang results, 4,116 frozen single-source comparisons, all eight checker shards, the guarded prefix producer oracle and 16 whole-workload policy comparisons. Grouped ordinary Lua and musl compilation enables header attestation, which bypasses this fresh-source reader on those commands. The grouped controls with explicit `--attested=off` record its admission and exact output on those sources.

GDB independently captured the [canonical scoped binding tables](canonical-binding-events.tar.xz) from the unmodified upstream and candidate executables. Their complete SQLite (4,666,856 bytes) and Buster (10,281,578 bytes) event streams, active heads and visit counts were byte-identical.

The [directed warning replay](supported-warning-oracle.tar.xz) checked all 451 directed source files with supported `-Wall -Wextra`. The original suite’s `-Wconversion` entries recorded command-line rejections. The replacement runs matched the reference compiler's diagnostics and complete outputs, including 412 successful objects and 295 sources with warnings.

Each PMU command and each elapsed-time wrapper acquired a separate 9700X lease. Each elapsed-time wrapper ran one warm-up compiler process and one timed compiler process under that lease. Only the timed child contributes to elapsed time.
