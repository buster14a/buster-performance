# Masking neutral operands while collecting program references

The two candidate modes run the same Release image with the reference mask unset or NODE_REF_WINDOW=1. The historical arm runs the genuine unmodified 325883abf compiler from the same source parent. Additional untimed runs record the entire published body/reference/region witness and compare it between the two candidate modes. Every timed process has the witness, counts, and fault-injection controls disabled.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 1,542.8150 | 10,563,307,033.5 | 676.4300 |
| off | 1,539.9494 | 10,565,066,305.0 | 675.8865 |
| on | 1,540.6892 | 10,565,049,567.0 | 676.6750 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| off minus baseline | −2.8656 [−6.3839, −0.9739] | +1,769,159.5 | −2.0965 [−3.4860, −0.5435] |
| on minus off | +0.7399 [+0.5015, +0.7665] | −16,886.0 | +0.7885 [−1.5955, +4.5895] |
| on minus baseline | −2.1257 [−5.6174, −0.4723] | +1,746,410.5 | +0.2450 [−5.0815, +2.4930] |

PMU fault counts ranged from 16,499 to 16,503. The independent wall series recorded 16,853 to 16,865 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen Buster compiler denominator of 2,433,922 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 44 successful compiles yielded a 11,272,080-byte object with SHA-256 `f6da2c15662c96c6d222714244bd3aff34d964c360b0871da6f0036dee74309c`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 2,357 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `325883abf9607ac726966a0af2097377832d53ac` | `a7c7e6773fd27da50d7063f9addd684ef608ea92273349132cf08d3207e2ed41` |
| off, on | `tree 231fdc57feae590b8364e169338e842b35c79297` | `cd316afd0d9b4ec62d87a2d6e0364730903a0ef2ebe02786ecef23c4e88fd2c5` |

The [frozen driver method](../../paired-driver/README.md), [mode selectors](reference-mask-config.sh), [command and object checks](reference-mask-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.

The [scheduler receipt](scheduling.tsv) records the completion time of each process output and whether the hardware lease was busy before that process. The largest interval between adjacent positions within one round was 0.707 s (pmu), 1.383 s (wall). These intervals also include other jobs that obtained the hardware lease between compiler invocations. All measured commands themselves ran with exclusive access.
