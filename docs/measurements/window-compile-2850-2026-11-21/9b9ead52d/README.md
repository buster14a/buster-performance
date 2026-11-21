# Declaration and initializer list heads

An ordinary checker reader uses the existing activation and finish bits to distinguish initialized list heads in reusable scratch. It avoids 5,729,096 bytes of explicit sentinel writes per SQLite compile. Deferred readers retain the eager initialization. In seven paired rounds SQLite retired fewer user instructions in all seven and finished sooner in five. The median wall change was negative on all four frozen workloads. Lua's median total-cycle change was positive.

Ryzen 7 9700X CPU 2 compiled each workload in a fresh process on each observation. The earlier compiler used public main `f4f8dd9a1663adbdcd1c222e7375f3517d9e47ae`. The candidate used `9b9ead52dd50a8d22e0d3829934065bb41b49c8b`. The [build receipts](builds.tsv) and [source patch](implementation.patch) identify both native Release executables.

| Input | Total cycles/token, median [min, max] | User instructions, median | True elapsed ms, median [min, max] | Faster elapsed pairs |
| --- | ---: | ---: | ---: | ---: |
| [SQLite](sqlite/paired-summary.tsv) | −1.9467 [−5.9124, +5.8885] | -90,879.0 | −0.3875 [−0.8305, +0.2390] | 5/7 |
| [Buster](main/paired-summary.tsv) | −0.0299 [−7.0685, +11.1937] | -344,752.5 | −2.0415 [−5.8205, +1.5835] | 6/7 |
| [Lua](lua/paired-summary.tsv) | +0.5534 [−3.0431, +78.6906] | -35,340.5 | −0.1385 [−0.3775, +0.4285] | 6/7 |
| [musl](musl/paired-summary.tsv) | −0.6355 [−10.2261, +7.4002] | -312,411.0 | −1.3455 [−3.8350, +0.4755] | 4/7 |

Each of 7 independent rounds per series used a symmetric four-position ABBA or BAAB order, alternating which compiler started. The paired difference uses the mean from its two positions per compiler in each round. Each workload used 28 PMU processes, 28 additional timed wall processes, 28 untimed warm-up processes for wall timing and six independent qualification processes. Full Lua and musl in each of these processes compile all source files together. SQLite used ordinary `-c` on CPU 2, and the other corpora used `--lanes 1 -c`. PMU cycles include user and kernel and use the independently established preprocessed tokens for the frozen inputs. Every counter ran 100% of enabled time. Each whole-workload output manifest checked default policy, `-Wall -Wextra`, the `--time-stages` audit and each timed observation. Default and warning-enabled diagnostics were byte-identical between the two compilers for each workload.

The [experiment command](ordinary-compare-one.sh), [schedule](ordinary-compare.sh), [frozen inputs](corpora.sh) and [object manifest verification](full-chain-manifest.py) reproduce this experiment.

The registered checker passed 848,399 assertions. A separate differential ran 4,116 frozen file/policy pairs and 216 declaration, initializer, mixed-scope and diagnostic controls, including one and four lanes. [Checker and file-by-file correctness receipts](correctness.tar.gz)
