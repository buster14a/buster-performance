# Tier 1 verifier share on the Ryzen 7 9700X

The November 23 capture of November 22 main puts the six verifier symbols at **10.24%** of sampled user cycles compiling SQLite and **6.96%** compiling Lua's `lvm.c`. SQLite exceeds the few-percent target in [buster#1379](https://github.com/buster14a/buster/issues/1379). Row checking accounts for 6.22 percentage points on SQLite.

| Input | Compiler | Rows | Dominance | CFG construction | Graph | Liveness plan | Shape | Sum | Median compile (ms) |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|
| SQLite | #2665 first parent | 4.62% | 1.07% | 1.36% | 0.23% | 0.87% | 0.39% | 8.54% | 442.453 |
| SQLite | #2665 merge | 5.12% | 1.33% | 1.14% | 0.25% | 0.83% | 0.23% | 8.90% | 442.481 |
| SQLite | November 22 main | 6.22% | 1.38% | 1.28% | 0.20% | 0.84% | 0.32% | 10.24% | 587.171 |
| Lua | #2665 first parent | 4.89% | 0.67% | 0.25% | 0.67% | — | — | 6.48% | 23.090 |
| Lua | #2665 merge | 2.83% | 0.70% | 0.92% | 0.41% | 0.40% | — | 5.26% | 22.986 |
| Lua | November 22 main | 4.15% | 1.01% | 0.90% | 0.24% | 0.56% | 0.10% | 6.96% | 25.106 |

The sums use the issue's exact accounting convention. The six columns are the rounded self shares of `ir_check_rows`, `ir_check_dominance`, `ir_cfg_validated`, `ir_check_graph`, `tier1_liveness_validate_plan` and `ir_check_shape`, including the compiler's `.buster_split` symbol suffix. A dash marks a symbol absent from that report. CFG construction includes work other consumers need. Each input and revision has one profile. The five unprofiled wall times ran in revision order, with no paired layout or A/A controls. They establish workload scale only. Intervening changes affect November 22 main.

## Provenance and reproduction

The session that claimed the measurement on November 22 produced these files in `/tmp/c1341/w/s1379` on benchpress. This record recovers its original profiles, reports, timings and build logs. Its [issue claim](https://github.com/buster14a/buster/issues/1379#issuecomment-7087790829) identifies the producer. The executable labels in the files are:

| Label | Compiler revision |
|---|---|
| b2665 | `8023523211d8dafa780e9aefd74f719ffd222a5a` |
| m2665 | `27ff32f2702eba5015f55de93b3734c3199ceca3` |
| main | `4704727a179ef530eb9a7b61a4276c8b06508166` |

The producer used Release, Clang 23.1.4 and CPU 2 on benchpress under the shared lock. The build logs identify the native variant. Its recorded build command used the host default. The earlier issue explicitly selected `BUSTER_HOST_ARCH=znver5`. The original [profile script](profile.sh) records `cycles:u` over three `-c -w --tier1 --lanes=1` SQLite compiles and ten compiles of Lua 5.4.8's `lvm.c`. It also records the five separate timings. [The report command](report.sh) uses self samples. The [raw directory](raw/) contains the six perf captures and their symbolized reports. The stored scripts preserve the producer's absolute input and output paths.

| Input | Source SHA-256 | First parent and merge object SHA-256 | November 22 object SHA-256 |
|---|---|---|---|
| sqlite3.c | `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d` | `1b129b4d4c137ccc85a64f8ca70dd90f59a24e27404e468ba0790cc1d9a478da` | `a0346c8e2a3ff3730ffd4c22a0d6ef706fe9d9aeb4d94298909dfdca1383dd05` |
| lvm.c | `88b10a2f1f539cdfbefac818c64ceee59ac1b5f55038643637109a98834bb926` | `4a9e9d8c3554a1aec155458ae0c18bc6910d6a583e0fb97d15cbcbe0c30ea708` | `a994a7984a2bee5500690e6c30678498f7c53f7f3f4d7574e97381aa65f98234` |

Both workloads emitted byte-identical objects across #2665. The input and object digests were read back from the benchmark host on November 24.
