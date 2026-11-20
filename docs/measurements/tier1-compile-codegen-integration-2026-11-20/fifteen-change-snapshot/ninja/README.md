# Whole clean builds

A clean Ninja process compiled every project object for each run. Both compilers used the same source, filenames, flags, archive/link configuration and local Ryzen 9 7940HS. The harness reserved one logical CPU per physical core, set each compiler to one internal lane, and varied the number of concurrent compiler processes with Ninja's jobs option. It measured the compile and link commands separately by elapsed wall time. After linking, both executables passed the same five Lua reference scripts or the compiler's instruction-selection self-test. Each compiler reproduced the same linked and aggregate object hashes throughout all rounds and job counts for a given project.

Each comparison contains one warm-up and six alternated-order pairs. These are the median within-pair changes in compile wall time.

| Clean project | 1 core | 2 cores | 4 cores |
|---|---:|---:|---:|
| lua-debug | -5.36% | -5.45% | -6.96% |
| lua-release | -1.18% | -1.09% | +7.10% |
| buster-release | +2.57% | -1.63% | -1.12% |

All [126 observations](builds.tsv) include CPU placement, elapsed times, linked size and digests. The [paired summary](summary.tsv) retains link and total time and the range of the six observations. [Measurement harness](measure.py).
