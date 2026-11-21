# Scalar fresh-leaf completion and the adjacent-block version

Direct copies each fresh simple leaf into the destination through the ordinary scalar node order. Blocks completes simple leaves over adjacent 16-node blocks and retains exceptional leaf/payload order. Both changes apply independently to main 325883abf. All three images compile frozen SQLite using the same normal artifact driver.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 905.1923 | 1,305,909,925.0 | 117.0625 |
| direct | 900.0172 | 1,305,278,530.0 | 116.6045 |
| blocks | 898.0275 | 1,295,642,076.0 | 116.9835 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| direct minus baseline | −2.3038 [−6.2328, −2.1010] | −631,262.5 | −0.4760 [−0.6730, −0.2695] |
| blocks minus direct | −3.9531 [−4.6858, −0.9319] | −9,636,450.0 | +0.3970 [−0.4155, +2.7630] |
| blocks minus baseline | −6.9896 [−7.1648, −6.0541] | −10,267,854.0 | −0.0790 [−0.6850, +2.0900] |

PMU fault counts ranged from 5,636 to 5,643. The independent wall series recorded 5,745 to 5,752 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 42 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 5,846 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `325883abf9607ac726966a0af2097377832d53ac` | `a7c7e6773fd27da50d7063f9addd684ef608ea92273349132cf08d3207e2ed41` |
| direct | `dc311b1e0508b508b1ec621a085c11369321af88` | `2eb435de2abd3c320800d6beae152d3d4fd2d3100c725d89311eab18b93d1c1d` |
| blocks | `e39bc958801e42ee3977cb233a73cd19481c9b4f` | `e9e36298a635ae3cf7b457b6487b3becb832b2c852c9aada14c931867525e825` |

The [frozen driver method](../../paired-driver/README.md), [mode selectors](leaf-direct-config.sh), [command and object checks](leaf-direct-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.

The [scalar direct](leafdc3.patch) and [block](nodes39b.patch) source patches each apply independently to main 325883abf.

The [independent hidden-column and direct-source checks](correctness/README.md) verify the entire checked-state comparison on the clean scalar control.

The [scheduler receipt](scheduling.tsv) records the completion time of each process output and whether the hardware lease was busy before that process. The largest interval between adjacent positions within one round was 0.135 s (pmu), 0.290 s (wall). These intervals also include other jobs that obtained the hardware lease between compiler invocations. All measured commands themselves ran with exclusive access.
