# Ordinary Buster compiler compilation with reduced warning traversals

After parent and uniqueness checks establish a tree, the roots candidate selects the cleared warning roots while initializing that block’s evaluation bytes. The excluded-subtree candidate also avoids two complete warning scans for suppressed literal warnings. Both compile the original input through the real artifact driver, relative to pristine main 9be958d5c.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 1,539.9798 | 10,558,204,850.5 | 678.0610 |
| roots | 1,542.3514 | 10,541,865,281.5 | 675.9730 |
| excluded | 1,533.8774 | 10,492,070,363.5 | 671.5605 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| roots minus baseline | +3.1176 [−9.7006, +4.9551] | −16,338,900.0 | −1.6290 [−2.5965, +0.4080] |
| excluded minus roots | +1.1967 [−14.9383, +3.6043] | −49,794,918.0 | −5.5410 [−6.9085, −1.6675] |
| excluded minus baseline | −8.5039 [−11.8206, +8.5594] | −66,133,818.0 | −6.5005 [−8.1375, −3.2965] |

PMU fault counts ranged from 16,493 to 16,508. The independent wall series recorded 16,847 to 16,868 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen Buster compiler denominator of 2,433,922 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 42 successful compiles yielded a 11,272,080-byte object with SHA-256 `f6da2c15662c96c6d222714244bd3aff34d964c360b0871da6f0036dee74309c`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 2,357 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `9be958d5c61538562177a788a76c8c23dead9694` | `2f8142feef1edf518c6e9b14ca561769c647be98b0cbe7ebcab538990c73cc50` |
| roots | `d2e78d10e4d37f8d3c57e637b6a00c1eae697aca` | `59956a8895d693999241110bf4821ca28d4c97d1c9a420a1ed77db3d684ee49e` |
| excluded | `f40a398f2c916655e2791df548bdd129033cb128` | `4f56e9470174bfd44a1b6034f53be0248623b0cddc363b60083880e4e9016f08` |

The [frozen driver method](../../paired-driver/README.md), [mode selectors](warning-roots-config.sh), [command and object checks](warning-roots-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.

The [scheduler receipt](scheduling.tsv) records the completion time of each process output and whether the hardware lease was busy before that process. The largest interval between adjacent positions within one round was 2.216 s (pmu), 1.380 s (wall). These intervals also include other jobs that obtained the hardware lease between compiler invocations. All measured commands themselves ran with exclusive access.
