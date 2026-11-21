# Ordinary SQLite compilation with reduced warning traversals

After parent and uniqueness checks establish a tree, the roots candidate selects the cleared warning roots while initializing that block’s evaluation bytes. The excluded-subtree candidate also avoids two complete warning scans for suppressed literal warnings. Both compile the original input through the real artifact driver, relative to pristine main 9be958d5c.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 899.2603 | 1,303,212,098.0 | 116.8185 |
| roots | 900.2337 | 1,300,691,803.5 | 117.0760 |
| excluded | 899.2612 | 1,300,710,375.0 | 116.9905 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| roots minus baseline | −0.4308 [−1.0851, +0.9734] | −2,520,294.5 | +0.5080 [−0.2390, +0.7200] |
| excluded minus roots | −1.6786 [−1.8846, +2.4765] | +18,550.5 | −0.0855 [−0.9825, +0.0240] |
| excluded minus baseline | −0.9112 [−2.1094, +1.3914] | −2,501,749.5 | −0.2150 [−0.4745, +0.6345] |

PMU fault counts ranged from 5,637 to 5,642. The independent wall series recorded 5,747 to 5,750 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 42 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 5,846 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `9be958d5c61538562177a788a76c8c23dead9694` | `2f8142feef1edf518c6e9b14ca561769c647be98b0cbe7ebcab538990c73cc50` |
| roots | `d2e78d10e4d37f8d3c57e637b6a00c1eae697aca` | `59956a8895d693999241110bf4821ca28d4c97d1c9a420a1ed77db3d684ee49e` |
| excluded | `f40a398f2c916655e2791df548bdd129033cb128` | `4f56e9470174bfd44a1b6034f53be0248623b0cddc363b60083880e4e9016f08` |

The [frozen driver method](../../paired-driver/README.md), [mode selectors](warning-roots-config.sh), [command and object checks](warning-roots-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.

The [scheduler receipt](scheduling.tsv) records the completion time of each process output and whether the hardware lease was busy before that process. The largest interval between adjacent positions within one round was 0.969 s (pmu), 0.250 s (wall). These intervals also include other jobs that obtained the hardware lease between compiler invocations. All measured commands themselves ran with exclusive access.
