# Carry discarded calls and stores as statement roots

## Subsequent source qualification

This experimental revision changes the native object for an explicit-void exception return and changes typed dumps for discarded expressions. The timing below records the experimental compiler. [Minimal sources, objects and per-mode results](../discard-source-regressions/README.md)

This variant also carries calls as physical statement roots. An ignored-result warning looks up the root in the ordered statement events. Every timed process runs the complete compiler and builds the native object.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `642dd7c7fed795cb5d73a87acb654e3b3559de70`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −3.9775 [−8.9421, +72.8498] | -24,326,636.5 | −0.7875 [−1.1860, −0.1485] | 7/7 |
| [Buster](main/paired-summary.tsv) | +0.5331 [−6.2761, +10.4249] | -30,364,219.0 | +0.8025 [−4.2120, +4.4850] | 3/7 |
| [Lua](lua/paired-summary.tsv) | +3.2239 [−0.2205, +4.8797] | -71,551.0 | −0.0895 [−0.3240, +0.1200] | 5/7 |
| [musl](musl/paired-summary.tsv) | +2.5738 [−0.3935, +3.2225] | -873,523.5 | +1.1910 [−1.6460, +2.2590] | 2/7 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
