# SQLite's cast mask before the placement test

On #3213 at 0647d69ba8af4e466c89df2519dea0b382524d37, the report counts one cast mask lane in SQLite under either warning policy. Removing that term leaves the number of eligible expressions unchanged. Its counter counted the mask before intersecting it with the mask of placed records. A record the kernel did not place could contribute to the statistic and could never exclude an expression.

The probe on the original build reports token 430130 at record 776 of the current window, with placement bit zero, on each of the two sweeps. Neither pass found a placed expression associated with that token. The trace changes no admission decisions. This observation accounts for the mismatch between the pre-fix counter and the number of additional tapes.

The local trace used a Develop build on Ryzen 9 7940HS and the same frozen SQLite source and defines as the Ryzen 7 9700X. Its C counts were 50,109 decided expressions and its X count was 49,839 tapes, matching the uninstrumented 9700X baseline. `trace.patch` adds the two diagnostic probes to the original source. Apply it in a checkout of the specified revision, run `./build.sh`, then invoke `measure-node-machine --shadow --passes 0 --window-rows` with the SQLite flags from [the shared corpus definition](../../tests-holes-2850-2026-11-21/9700x/corpora.sh).
