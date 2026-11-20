# Complete projects built with 25 compiler PRs

The Ryzen 9 7940HS built and linked Buster and Lua from empty output directories. One physical core was available for each Ninja job and each file used one Buster lane. Within each round the two compilers used the same core allocation and alternated order. One warm-up and six measured pairs produced 126 complete builds. Checks after linking verified the resulting compiler or ran five Lua programs against the reference outputs. Objects and linked hashes stayed identical within each variant and project across all seven rounds and three job counts.

| Project | Parallel jobs | Baseline median (s) | Candidate median (s) | Paired median | Pair range |
| --- | ---: | ---: | ---: | ---: | --- |
| buster-release | 1 | 56.967 | 55.280 | -1.30% | -5.65% to +16.67% |
| buster-release | 2 | 29.901 | 29.384 | -0.02% | -6.29% to +3.96% |
| buster-release | 4 | 17.911 | 17.840 | -1.05% | -10.67% to +1.52% |
| lua-release | 1 | 0.455 | 0.431 | -4.11% | -10.03% to +1.69% |
| lua-release | 2 | 0.286 | 0.279 | -1.94% | -8.92% to +33.56% |
| lua-release | 4 | 0.157 | 0.145 | -3.02% | -9.57% to +6.40% |
| lua-debug | 1 | 0.665 | 0.637 | -5.83% | -11.55% to -4.05% |
| lua-debug | 2 | 0.384 | 0.362 | -7.45% | -17.24% to +0.93% |
| lua-debug | 4 | 0.241 | 0.221 | -13.54% | -30.80% to -5.66% |

Each percentage is a median of the within-pair percentage differences. The range includes every measured pair. The observations also report separate link time and total time. These wall times are sensitive to concurrent activity elsewhere on the shared local workstation. [All 126 builds](builds.tsv.gz) · [timings including link time and ranges](summary.tsv) · [harness](measure.py).
