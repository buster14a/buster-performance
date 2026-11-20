# Cost of compiling the 43 Buster release sources

Each of the two snapshots was compared with its own exact main control. The [1,204 process observations](observations.tsv.gz) cover 43 shared source files, two compilers, two snapshots, and seven rounds. In each round the file order and which compiler ran first were alternated. The first round is a warm-up. The six reported pairs sum the corresponding 43 observations before calculating a percentage. The [object hashes](hashes.tsv) matched the corresponding prior self-host qualification across all repetitions.

| Snapshot | Retired instructions | User cycles | Sum of per-command wall times |
|---|---:|---:|---:|
| fifteen | -0.879% (-0.879 to -0.879) | -0.628% (-0.690 to -0.366) | -0.554% (-1.440 to +0.125) |
| eighteen | -0.954% (-0.955 to -0.954) | -0.461% (-1.164 to +0.334) | -0.763% (-2.466 to +1.092) |

Fifteen changed the total retired instruction count by −0.879%, and eighteen by −0.954%. The separate [fifteen-change clean Ninja experiment](../../fifteen-change-snapshot/ninja/) had a 2.57% increase in one-job Buster compile wall time. It timed a complete build process. The single-file counter experiment paired each compiler command on identical input and summed the measurements. Their wall-time results differ. The [per-unit medians](paired.tsv) preserve both the reductions and increases.
