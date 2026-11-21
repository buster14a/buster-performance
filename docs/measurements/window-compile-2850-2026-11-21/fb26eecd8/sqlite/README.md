# Ordinary SQLite compilation with sparse program-control markers

Both executables use ordinary compilation with the default warning policy for timing. The production source makes the body-demanded loop target and sparse source-label changes without any experimental environment option, on direct public main 325883abf.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 901.7269 | 1,305,909,917.0 | 117.3535 |
| production | 898.0090 | 1,298,997,338.5 | 116.7740 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| production minus baseline | −3.1413 [−13.4066, −1.9337] | −6,912,593.5 | −0.7810 [−1.3965, +0.2425] |

PMU fault counts ranged from 5,638 to 5,643. The independent wall series recorded 5,748 to 5,752 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 64 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 5,846 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `325883abf9607ac726966a0af2097377832d53ac` | `a7c7e6773fd27da50d7063f9addd684ef608ea92273349132cf08d3207e2ed41` |
| production | `fb26eecd849872d6b0ce42bcb52b4d58b37fc448` | `e9a760904eb22af25e7b087f9ad86b2b931a78bc094ddfe2b5d33746308803b1` |

The [frozen driver method](../../paired-driver/README.md), [mode selectors](production-markers-config.sh), [command and object checks](production-markers-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.
