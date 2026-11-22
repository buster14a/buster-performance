A fresh ordinary reader resolves the specifier, name and pointer shape of bounded named C declarations using source-position bindings. The canonical checker retains declaration and function-body ownership.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `1a41a7e4e42db74e28c10b4104527ab4a087b439`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −2.6859 [−8.6626, −0.8487] | -17,010,352.5 | −0.1275 [−1.6420, +11.6550] | 4/7 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.

These exploratory time and PMU observations shared one exclusive lease for the SQLite schedule. Current shared-host qualification releases the lock after each process. A prior schedule had completed two preflight checks and zero timed observations before it was replaced.

The [source and local qualification archive](local-source-oracle.tar.xz) includes 3,096 directed comparisons, 296 independently linked Clang runtime controls, 4,116 frozen-source comparisons and all eight checker shard reports.

The [supported warning replay](supported-warning-oracle.tar.xz) checked all 387 directed sources using `-Wall -Wextra`. The original suite’s `-Wconversion` entries recorded command-line rejections. The replacement runs matched the reference compiler’s diagnostics and full native objects.
