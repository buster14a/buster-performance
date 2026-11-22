# Build syntax parents between depth-zero terminators

The parser records a boundary after about 4,096 grammar tokens when it finds a terminator or a function-body closer at depth zero. Both roles have strict left and right thresholds and the smallest nonzero precedence. The parser verifies that every real token has at least that precedence. A search from inside an interval then reaches a qualifying token by the bordering terminator, or its threshold excludes every token outside. Including the boundary in both neighboring intervals preserves both directions of the parent search.

Each interval reuses the same K4 block preparations, predecessor indices and predecessor keys. The parser rebases local parents to full-source indices before checking statements. When every depth fits in six bits, K6 reads the finalized depth bytes as absolute frame indices. Wide nesting and unproven intervals retain the ordinary full-unit path.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `3543ba2b82d1ebe5e44319bb13551c78a67b37ac`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | +0.7332 [−0.4109, +3.8261] | +408,312.5 | −0.1905 [−0.8635, +1.3255] | 2/3 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.

## Parser stage and complete compilation

In the exploratory stage screen, the SQLite parser took 6.829 ms in the baseline and 6.537 ms in the candidate. The median paired change was -0.267 ms, with a shorter candidate time in 7 of 7 rounds. Each round used four fresh compiler processes and verified the complete emitted object. The [stage samples](parser-stages/samples.tsv) retain each process.

In the independent wall series, ordinary SQLite compilation took 112.404 ms and 112.318 ms respectively. Its paired change was -0.191 ms over 3 rounds, with 2 shorter. Paired total cycles per token changed by +0.733. The [complete compilation measurements](sqlite/paired-summary.tsv) include the range and fault counters.

Against the preceding implementation at `464ed050e`, the per-invocation [incremental stage comparison](parser-stages-direct/summary.tsv) measured -0.074 ms for parsing, with 6 shorter rounds out of seven.
