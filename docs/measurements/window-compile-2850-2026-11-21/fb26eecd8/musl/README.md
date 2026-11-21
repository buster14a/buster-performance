# Ordinary musl vfprintf.c compilation with sparse program-control markers

Both executables use ordinary compilation with the default warning policy for timing. The production source makes the body-demanded loop target and sparse source-label changes without any experimental environment option, on direct public main 325883abf.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 1,572.9587 | 37,950,725.5 | 4.1860 |
| production | 1,551.2382 | 37,848,011.5 | 4.1650 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| production minus baseline | −21.7205 [−51.8951, +6.5734] | −102,746.5 | −0.0370 [−0.1760, +0.1055] |

PMU fault counts ranged from 968 to 2,364. The independent wall series recorded 985 to 987 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen musl vfprintf.c denominator of 16,184 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 28 successful compiles yielded a 24,072-byte object with SHA-256 `a19e50ed30f084a39ee48ef0be9a3f82e9be1f4524d1803c38f224eb61dda651`. Each ordinary compile rendered the same 36,572 default diagnostic bytes. An original default warning stream is included in the raw reports archive. All `-Wall -Wextra` compilations had identical output, with 41,020 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `325883abf9607ac726966a0af2097377832d53ac` | `a7c7e6773fd27da50d7063f9addd684ef608ea92273349132cf08d3207e2ed41` |
| production | `fb26eecd849872d6b0ce42bcb52b4d58b37fc448` | `e9a760904eb22af25e7b087f9ad86b2b931a78bc094ddfe2b5d33746308803b1` |

The [frozen driver method](../../paired-driver/README.md), [mode selectors](production-markers-config.sh), [command and object checks](production-markers-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.
