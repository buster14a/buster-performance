# Cache checked record fields by their actual pointee type

The ordinary checker memoizes successful arrow accesses only for pointers whose pointee is a structure or union. A previous version rejected the whole translation unit whenever a field spelling could also denote a vector swizzle. Distinguishing the pointee types admits ordinary fields in those files. Vector accesses still run their complete semantic action.

On a local 7940HS Develop build, the actual lookup returned 20,094 SQLite and 16,271 Buster self field results. Lua lvm.c used 1,081 entries and musl vfprintf.c used 28. All five native captures matched every valued checker output. The local paired screen saved 13.36 million SQLite user instructions per compile and added 1.47 million on Buster self. [Lookup and value observations](qualification/native-columns/coverage.tsv) and [local instruction counts](qualification/local-instructions/paired.tsv) record these measurements.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `74290c227720ba57179dc903edd38fda3701fc04`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −0.0834 [−1.1185, +2.1142] | -14,412,460.0 | −0.4795 [−0.6200, +0.1765] | 2/3 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
