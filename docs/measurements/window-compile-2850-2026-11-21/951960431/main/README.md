# Ordinary compiler with a sole outer modification in unsequenced warning checks

The unmodified reference is the previously qualified f40a398f2 compiler. The candidate adds the sole-outer-modification check atop that exact source. These two native Release images compile the ordinary frozen input with identical options.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 1,529.1840 | 10,492,091,214.5 | 672.3560 |
| unsequenced | 1,526.2327 | 10,463,784,318.0 | 671.0810 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| unsequenced minus baseline | −4.1535 [−4.2784, −2.1894] | −28,306,896.5 | −1.0375 [−2.8480, −0.6740] |

PMU fault counts ranged from 16,508 to 16,529. The independent wall series recorded 16,866 to 16,888 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen Buster compiler denominator of 2,433,922 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 28 successful compiles yielded a 11,272,080-byte object with SHA-256 `f6da2c15662c96c6d222714244bd3aff34d964c360b0871da6f0036dee74309c`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 2,357 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `f40a398f2c916655e2791df548bdd129033cb128` | `4f56e9470174bfd44a1b6034f53be0248623b0cddc363b60083880e4e9016f08` |
| unsequenced | `95196043168b63700aaca3366829715621629997` | `2accb5901119f603e50e2000d984ddb3a43a873afb10638106b061d1a2df5062` |

The [frozen driver method](../../paired-driver/README.md), [mode selectors](warning-unseq-config.sh), [command and object checks](warning-unseq-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.

The [scheduler receipt](scheduling.tsv) records the completion time of each process output and whether the hardware lease was busy before that process. The largest interval between adjacent positions within one round was 2.268 s (pmu), 1.370 s (wall). These intervals also include other jobs that obtained the hardware lease between compiler invocations. All measured commands themselves ran with exclusive access.
