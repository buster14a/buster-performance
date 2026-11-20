# Clean parallel project builds

Fresh Ninja builds compiled all 43 shared Buster release sources or 33 Lua sources, linked each result, and exercised the resulting executable. Each compiler used one internal lane per file, with one physical core per Ninja job. Six post-warm-up pairs are summarized from [126 complete builds](builds.tsv.gz). The table gives the paired median change in compile wall time on the local Ryzen 9 7940HS. The [per-project link measurements and full ranges](summary.tsv) include total build time.

| Project | 1 job | 2 jobs | 4 jobs |
|---|---:|---:|---:|
| buster-release | -0.41% | -1.12% | -1.09% |
| lua-release | -1.38% | -2.28% | -3.11% |
| lua-debug | -4.82% | -5.75% | -5.48% |
