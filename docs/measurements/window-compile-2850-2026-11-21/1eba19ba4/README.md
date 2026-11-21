# Lazy enum spelling in switch diagnostics on the Ryzen 7 9700X

Both compilers used the ordinary `-c` command. The candidate computes an enum type name only when a switch diagnostic needs it. Lua lvm.c exercises enum selectors. SQLite provides a large control workload. The two builds had no diagnostic environment settings and each compilation ran on CPU 2 under the shared host lock. The comparison used a separate dedicated wall-time series and collected cycles and instructions in both user and kernel mode.

| Source | Bytes | Preprocessed tokens | Pairs per series | Median baseline cycles/token | Median production cycles/token | Paired total cycles/token, median [min, max] | Paired user instructions, median | Paired wall ms, median [min, max] |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| [lua-vm](lua-vm/README.md) | 59,115 | 73,465 | 7 | 1110.7329 | 855.1976 | −259.0895 [−276.8394, −178.8383] | −50,116,150.5 | −3.8380 [−3.8790, −3.7670] |
| [sqlite](sqlite/README.md) | 9,507,037 | 716,136 | 3 | 930.5777 | 934.3892 | +3.4020 [+2.3927, +99.2058] | +719.5 | +0.0590 [−0.0120, +0.2735] |

lua-vm pmu contained process fault counts over 4,000 in round(s) 4. The paired cycles/token result after excluding those rounds was −264.9695 [−276.8394, −203.1201].

sqlite pmu contained process fault counts over 20,000 in round(s) 2. The paired cycles/token result after excluding those rounds was +2.8973 [+2.3927, +3.4020].

The unmodified source revision was `6e9c51b9d238734468dccc03ab1b6c715449804e` with Release executable SHA-256 `4e5c9d27a80a151bbf0d9cf4f9b6be43a56ac42a5a1b36811170c26d78b93f1c`. The signed production revision was `1eba19ba4c93bf937116f708b026972e7db974ec` with executable SHA-256 `eb8507a3d737cdaa535936ad4e1bf055eea24c9b2bdb05a6e36dc5eb4a4ef4d8`. The [production patch](production.patch) has SHA-256 `a120401733cc447369c7d600978337039fcef69ef564a441695b2d87549f5c75`.

Each round placed both executables in two symmetric slots and alternated the outer executable. The table gives differences within rounds before taking the median. [Exact flags](enum-probe-one.sh), [scheduler](enum-probe.sh), [mode and round selectors](enum-probe-config.sh), the [four additional Lua rounds](enum-extend.sh) and the [frozen driver method](../paired-driver/README.md) define the sampling. The [correctness campaign](correctness/README.md) records 90 CLI pairs and all eight driver shards.
