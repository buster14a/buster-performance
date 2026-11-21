# Ordinary Lua lparser.c compilation with sparse program-control markers

Both executables use ordinary compilation with the default warning policy for timing. The production source makes the body-demanded loop target and sparse source-label changes without any experimental environment option, on direct public main 325883abf.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 1,237.0239 | 45,044,906.0 | 5.0190 |
| production | 1,227.2817 | 44,907,721.5 | 5.0210 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| production minus baseline | −5.0145 [−23.8656, +415.3518] | −137,146.5 | +0.0475 [−0.1085, +0.1315] |

PMU fault counts ranged from 958 to 2,953. The independent wall series recorded 980 to 985 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen Lua lparser.c denominator of 24,078 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 60 successful compiles yielded a 51,568-byte object with SHA-256 `66995b0d9a26977b07b3a83cb1cdd08ea9f9057a6f416b3493e7813599dabd8a`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 0 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `325883abf9607ac726966a0af2097377832d53ac` | `a7c7e6773fd27da50d7063f9addd684ef608ea92273349132cf08d3207e2ed41` |
| production | `fb26eecd849872d6b0ce42bcb52b4d58b37fc448` | `e9a760904eb22af25e7b087f9ad86b2b931a78bc094ddfe2b5d33746308803b1` |

The [frozen driver method](../../paired-driver/README.md), [mode selectors](production-markers-config.sh), [command and object checks](production-markers-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.

The [first three Lua rounds](https://github.com/buster14a/buster-performance/tree/87ff749714d4d6770e48df43969301f63c8c9efb/docs/measurements/window-compile-2850-2026-11-21/fb26eecd8/lua) were retained. The [extension](production-markers-extend.sh) added four rounds in each series on the same two binaries after elapsed time had increased in each of the first three pairs.

The [scheduler receipt](scheduling.tsv) records the completion time of each process output and whether the hardware lease was busy before that process. The largest interval between adjacent positions within one round was 258.937 s (pmu), 5.877 s (wall). These intervals also include other jobs that obtained the hardware lease between compiler invocations. All measured commands themselves ran with exclusive access.
