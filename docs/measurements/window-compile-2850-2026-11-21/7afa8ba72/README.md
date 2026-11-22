# Publish native statement heads and preserve observable discard conversions

The ordinary native driver represents a completed discarded rvalue at its own source node and publishes a direct statement head. Output that exposes typed entries retains its full conversion rows. Exception-return lowering accounts for the implicit statement cast when determining whether the call is the entire statement. The scalar path provides a full-graph control.

Buster wall round 5 included one major fault in its first baseline process. The raw timing, paired results and major-fault counts retain that observation. The SQLite series was unaffected.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `0e1d5b825801135bf50e79da9d546bc95209ab30`. The candidate used `7afa8ba723efe888c41cfef3005d194f9c202afc`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −9.4992 [−15.3133, −6.8342] | -26,910,046.0 | −1.3730 [−1.7235, −0.8420] | 7/7 |
| [Buster](main/paired-summary.tsv) | −4.5835 [−133.5750, +4.6004] | -42,868,054.5 | −0.1530 [−63.2040, +2.3405] | 5/7 |
| [Lua](lua/paired-summary.tsv) | +2.2299 [−7.4906, +8.1953] | +574,165.5 | +0.1900 [−0.1240, +0.3590] | 2/7 |
| [musl](musl/paired-summary.tsv) | +1.3514 [−7.4078, +6.1639] | +4,268,865.5 | +1.0390 [−2.5490, +5.4155] | 3/7 |

Each independent round used a symmetric ABBA or BAAB order, alternating which compiler started. Each compiler ran twice per round in the PMU series and twice in a separate elapsed-time series with fresh processes. The table's denominator gives the number of rounds for each input. Six additional qualification processes checked each workload. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.
