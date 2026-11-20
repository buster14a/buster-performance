# Whole-project compilation with one, two and four physical cores

The [twelve-change snapshot](../README.md) and its parent compiled the same 43-unit Buster release source and 33-unit Lua application. The local Ryzen 9 7940HS ran 108 clean builds. One warm-up and five measured pairs per project and job count rotated variant order. Each build verified the linked result, including five known Lua script outputs or the self-hosted compiler's Tier 1 selection suite.

| Project | Physical cores | Parent compile ms | Candidate compile ms | Paired wall change | Retired instructions |
| --- | ---: | ---: | ---: | ---: | ---: |
| Buster release | 1 | 54,023.8 | 53,175.2 | -2.62% | -0.87% |
| Buster release | 2 | 30,059.8 | 29,217.4 | -0.79% | -0.87% |
| Buster release | 4 | 17,248.8 | 16,993.4 | -1.45% | -0.87% |
| Lua debug | 1 | 1,238.5 | 1,189.9 | -2.83% | -8.30% |
| Lua debug | 2 | 717.9 | 637.6 | -10.15% | -8.30% |
| Lua debug | 4 | 391.6 | 355.8 | -12.89% | -8.30% |
| Lua release | 1 | 915.8 | 933.0 | +3.75% | -1.19% |
| Lua release | 2 | 555.5 | 504.6 | +0.06% | -1.19% |
| Lua release | 4 | 291.9 | 309.2 | -0.02% | -1.19% |

Local release Buster compilation retired 0.87% fewer instructions at each job count. The one- and four-core wall measurements improved in all five pairs. Lua debug compilation retired 8.30% fewer instructions and all 15 wall comparisons improved. Lua release retired 1.19% fewer instructions. Its one-core wall median increased 3.75%, and its two- and four-core wall comparisons crossed zero.

The [per-build timings and identities](builds.tsv), [per-unit counters](per-unit-counters.tsv.gz) and [paired summaries](summary.tsv) accompany six per-project and variant object ledgers. Each translation unit launched a single-lane compiler under taskset and perf stat on one physical core. Separate worker processes ran concurrently at the requested job count. Compilation wall time includes starting the counter process for each unit. Linking used the same pinned Clang 23.1.4 and was timed separately. The compile inputs are listed in [source order](buster-source-order.txt) with the [Buster flags](buster-flags.txt).

A full debug build of Buster itself cannot be timed on this snapshot. In a separate sweep of all 43 units, both compiler versions accepted 29 and rejected the same 14 with identical diagnostics. The [per-unit diagnostic ledger](debug-selfhost-units.tsv) includes the exact failures. The release self-hosts and both complete Lua configurations built and ran successfully.
