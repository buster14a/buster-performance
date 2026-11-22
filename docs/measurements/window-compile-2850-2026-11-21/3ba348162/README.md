# Source-owned scalar field locations with the source window enabled

Both executables run SQLite with the explicit `--node-window -c` option. The difference measures source-owned field locations and pointer reads relative to the existing source windows. The candidate holds the address and builtin evidence in the ordinary graph and supplies sequencing diagnostics with the original pointer read. [Native checked values, atomic effects, diagnostics and objects](../root-splice/member-operands/location-reads/README.md)

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `3ba3481628a275a7f4b980c7621fc62e58ad0b27`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | +4.0496 [+0.0244, +6.4356] | -13,195,734.5 | +0.5935 [−3.5120, +1.2060] | 1/3 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used `--node-window -c` on CPU 2 for both executables, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
