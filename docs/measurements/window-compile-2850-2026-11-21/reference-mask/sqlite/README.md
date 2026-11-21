# Masking neutral operands while collecting program references

The two candidate modes run the same Release image with the reference mask unset or NODE_REF_WINDOW=1. The historical arm runs the genuine unmodified 325883abf compiler from the same source parent. Additional untimed runs record the entire published body/reference/region witness and compare it between the two candidate modes. Every timed process has the witness, counts, and fault-injection controls disabled.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 902.6674 | 1,305,909,889.0 | 117.5485 |
| off | 900.6277 | 1,306,886,324.5 | 116.4665 |
| on | 899.7439 | 1,299,581,058.5 | 117.1845 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| off minus baseline | −2.9396 [−3.6891, −1.4912] | +976,444.0 | −0.9725 [−1.4365, −0.6365] |
| on minus off | +0.2415 [−0.8838, +0.4476] | −7,305,282.5 | +0.4295 [+0.2160, +1.0725] |
| on minus baseline | −3.2415 [−3.8234, −1.2498] | −6,328,828.0 | −0.4205 [−0.5430, −0.3640] |

PMU fault counts ranged from 5,635 to 5,641. The independent wall series recorded 5,744 to 5,750 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 44 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 5,846 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `325883abf9607ac726966a0af2097377832d53ac` | `a7c7e6773fd27da50d7063f9addd684ef608ea92273349132cf08d3207e2ed41` |
| off, on | `tree 231fdc57feae590b8364e169338e842b35c79297` | `cd316afd0d9b4ec62d87a2d6e0364730903a0ef2ebe02786ecef23c4e88fd2c5` |

The [frozen driver method](../../paired-driver/README.md), [mode selectors](reference-mask-config.sh), [command and object checks](reference-mask-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.

The [scheduler receipt](scheduling.tsv) records the completion time of each process output and whether the hardware lease was busy before that process. The largest interval between adjacent positions within one round was 0.135 s (pmu), 0.250 s (wall). These intervals also include other jobs that obtained the hardware lease between compiler invocations. All measured commands themselves ran with exclusive access.
