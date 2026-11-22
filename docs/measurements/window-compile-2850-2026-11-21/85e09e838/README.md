# Emit reader parameter roles from completed syntax-check blocks

The syntax checker publishes function-declarator parentheses as it completes each 64-token group. A mask identifies the lanes that open or close a parameter list. The scalar path supplies the same mask and the carry preserves the last two unrefined classes across a block boundary.

The rare attribute check examines classes that the current block has already computed. It takes the incoming frame when an attribute crosses the start of the block. Together these changes avoid writing whole-unit class and group bytes for compact ordinary parses. The other parser output and its deep fallback continue to use the complete syntax column representation.

An earlier parser experiment at `70371b499` used the same block-local attribute classes and omitted the same two dense columns. It wrote parameter and declaration-end masks to each 64-token record and refined function roles later during fallback. This variant refines the roles in K6 before advancing to the next block and runs on the seeded precedence parser. The direct stage and native controls compare it with that exact predecessor. [Earlier K6 experiment and measurements](https://github.com/buster14a/buster-performance/blob/19716d7d3ab704a6f830b08b2d8dd6bd6b5eea62/docs/measurements/parser-handoff-windows-2850-2026-11-21/README.md#k6-produces-two-masks-for-fallback)

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `85e09e83822e093f2ed12fd309f3093990b1e904`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

Each native PMU observation ran one compiler under the hardware lock. Each elapsed observation held the lock for one `time-runs --runs 1 --warmups 1` command, which launched a warm-up compiler followed by the timed compiler. [Elapsed and PMU commands](ordinary-compare-one.sh)

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −2.8025 [−6.7319, +0.2366] | +377,854.5 | −0.1910 [−0.4855, +11.3360] | 5/7 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.

## Parser stage and complete compilation

The SQLite parser took 6.758 ms in the baseline and 6.561 ms in the candidate. The median paired change was -0.234 ms, with a shorter candidate time in 7 of 7 rounds. Each round used four fresh compiler processes and verified the complete emitted object. The [stage samples](parser-stages/samples.tsv) retain each process.

In the independent wall series, ordinary SQLite compilation took 112.654 ms and 112.453 ms respectively. Its paired change was -0.191 ms over 7 rounds, with 5 shorter. Paired total cycles per token changed by -2.803. The [complete compilation measurements](sqlite/paired-summary.tsv) include the range and fault counters.

One candidate invocation in round six took 135.219 ms and reported 55,451 minor faults. Its paired round was 11.336 ms slower. The seven-round result retains that sample. The median candidate time of 112.4525 ms corresponds to 84.54 MB/s for the 9,507,037-byte source. [Individual native samples](sqlite/samples.tsv)

Against the preceding implementation at `18eca8d81`, the per-invocation [incremental stage comparison](parser-stages-direct/summary.tsv) measured -0.104 ms for parsing, with 7 shorter rounds out of seven.

Against the seeded precedence executable, the [complete native comparison](native-vs-seeded/paired-summary.tsv) changed elapsed time by +0.004 ms and total cycles per token by +0.324 across three paired rounds.
