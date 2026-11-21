# Demand-allocated selected operands on the original parent

This measures the initial revision of [PR #3262](https://github.com/buster14a/buster/pull/3262). Units whose preprocessed input contains no generic selection or compile-time choose expression omit the selection table. Its readers return the ordinary empty sentinel.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `5d880269932b70962e31bbcdaf71330fa263c423`. The candidate used `3d541ebe6ede78febe23c1f907c08b534752191b`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −0.2407 [−3.6542, +2.9234] | -1,938.5 | +0.2175 [−1.2820, +0.4015] | 3/7 |
| [Buster](main/paired-summary.tsv) | −1.0115 [−7.0615, +4.1273] | -1,651,528.0 | +1.4185 [−4.4130, +5.3355] | 2/7 |
| [Lua](lua/paired-summary.tsv) | +1.3526 [−0.8813, +8.7248] | -28,909.5 | −0.1760 [−0.7375, +0.0845] | 5/7 |
| [musl](musl/paired-summary.tsv) | −2.0443 [−3.9709, +0.6743] | -148,931.5 | −2.4710 [−8.6760, +1.1510] | 6/7 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
