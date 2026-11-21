# Local declaration ownership during ordinary lowering

This candidate finds the original selected body through a cursor over source-ordered openings. It records ownership by declaration ordinal. This replaces two token-sized scratch tables. The mainline and modified compilers ran the same ordinary artifact-producing commands.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `325883abf9607ac726966a0af2097377832d53ac`. The candidate used `b6b1e4d95f22934d116305c445c684872b629200`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −7.5000 [−8.5682, −5.7903] | +160,591.5 | −0.9830 [−1.3030, −0.0795] | 3/3 |
| [Buster](main/paired-summary.tsv) | −1.0963 [−5.3384, +3.7875] | +736,667.0 | +0.1975 [−17.0125, +1.9425] | 1/3 |

Each of 3 independent rounds per series used a symmetric four-position ABBA or BAAB order, alternating which compiler started. The paired difference uses the mean from its two positions per compiler in each round. Each workload used 12 PMU processes, 12 additional timed wall processes, 12 untimed warm-up processes for wall timing and six independent qualification processes. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.

The [native checker](checker.log) passed all 210,630 assertions in its fifth shard, including the new original-body ownership test. The [debugger probe](cursor-fixture.gdb) read the live test group ordinal to [identify its owning shard](checker-shard.txt).
