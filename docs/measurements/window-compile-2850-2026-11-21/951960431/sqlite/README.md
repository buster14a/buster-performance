# Ordinary compiler with a sole outer modification in unsequenced warning checks

The unmodified reference is the previously qualified f40a398f2 compiler. The candidate adds the sole-outer-modification check atop that exact source. These two native Release images compile the ordinary frozen input with identical options.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 903.0769 | 1,300,710,406.0 | 116.9075 |
| unsequenced | 891.1710 | 1,287,397,259.5 | 115.8685 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| unsequenced minus baseline | −10.1419 [−12.6013, −8.7555] | −13,313,146.5 | −1.1210 [−1.3855, −0.6065] |

PMU fault counts ranged from 5,639 to 5,673. The independent wall series recorded 5,748 to 5,781 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 28 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 5,846 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `f40a398f2c916655e2791df548bdd129033cb128` | `4f56e9470174bfd44a1b6034f53be0248623b0cddc363b60083880e4e9016f08` |
| unsequenced | `95196043168b63700aaca3366829715621629997` | `2accb5901119f603e50e2000d984ddb3a43a873afb10638106b061d1a2df5062` |

The [frozen driver method](../../paired-driver/README.md), [mode selectors](warning-unseq-config.sh), [command and object checks](warning-unseq-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.

The [scheduler receipt](scheduling.tsv) records the completion time of each process output and whether the hardware lease was busy before that process. The largest interval between adjacent positions within one round was 0.136 s (pmu), 0.247 s (wall). These intervals also include other jobs that obtained the hardware lease between compiler invocations. All measured commands themselves ran with exclusive access.
