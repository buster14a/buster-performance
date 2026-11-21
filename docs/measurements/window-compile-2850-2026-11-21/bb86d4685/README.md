# Actual source-proof and compacted ordinary compilation costs

The private experimental parent and candidate each compiled frozen SQLite on one lane. Parent and plain use ordinary `-c`. Both dry and source enable `--node-window-source`. Dry additionally sets `NODE_SOURCE_COMPACT_DRY=1` to calculate the source proof without compacting the ordinary graph. The production-shaped source mode has no diagnostic environment setting.

| Mode | Source roots | Graph nodes removed | Final graph nodes | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| parent | 0 | 0 | 323,623 | 933.7566 | 1,348,443,780.0 | 121.3285 |
| plain | 0 | 0 | 323,623 | 937.5229 | 1,347,543,506.0 | 121.7965 |
| dry | 0 | 0 | 323,623 | 971.8234 | 1,394,233,058.0 | 126.7130 |
| source | 4,215 | 6,218 | 317,405 | 979.8041 | 1,383,259,392.0 | 126.8150 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| plain minus parent | +3.7207 [−95.3908, +3.7663] | −900,274.0 | +0.4680 [+0.1475, +0.5480] |
| dry minus plain | +34.9135 [+33.7995, +45.1227] | +46,690,488.0 | +5.2485 [+4.1405, +5.4875] |
| source minus dry | +8.4816 [−6.4803, +10.3398] | −10,978,920.5 | −0.1875 [−0.4690, +1.5960] |
| source minus plain | +42.2812 [+38.6424, +45.2533] | +35,715,886.0 | +5.0610 [+5.0185, +5.7365] |
| source minus parent | +46.0475 [−56.7484, +48.9740] | +34,815,612.0 | +5.4865 [+5.2085, +6.2845] |

PMU fault counts ranged from 5,656 to 59,937. The independent wall series recorded 5,764 to 5,942 minor faults and zero major faults.

Excluding rounds with a process above 20,000 faults in the pmu series removes rounds 3. The retained paired differences are

| Paired difference | cycles/token, median [min, max] |
| --- | ---: |
| plain minus parent | +3.7435 [+3.7207, +3.7663] |
| dry minus plain | +34.3565 [+33.7995, +34.9135] |
| source minus dry | +9.4107 [+8.4816, +10.3398] |
| source minus plain | +43.7672 [+42.2812, +45.2533] |
| source minus parent | +47.5108 [+46.0475, +48.9740] |

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 56 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 3,701 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| parent | `7ef9900685609381d183a482a01cdb9bf481bff6` | `f5a0ee4a423fb2fe8a72d65f6d9ea119af48e305fa8b121f8a6bdae4fc2e6581` |
| plain, dry, source | `bb86d4685abf8c8956438f88cd5b5c6d19ad2f8a` | `029a59e237e62b9314b392d4202ff9a1df97087002faf8a285905608dfe07241` |

The [frozen driver method](../paired-driver/README.md), [mode selectors](source-physical-config.sh), [command and object checks](source-physical-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.

Both private Release sources were reconstructed from separate exact patches on public Buster 84a7d3d76. The [parent source patch](parent.patch), [candidate source patch](candidate.patch) and [difference between the two](incremental.patch) reconstruct all paths. The [full semantic qualification, actual graph and native verification and local reduced-stage experiments](../root-splice/source-root-lean/README.md) identify the source selection, removed nodes and actually consumed native rows. [Per-round user and kernel counters and wall timing](paired.tsv).

On this source, computing and applying the independent proof added 5.0610 ms at the median to the same binary’s normal compile. All three wall deltas exceeded 5 ms. Dry proof alone added 5.2485 ms. Compaction subsequently removed 6,218 graph nodes and retired 10.979 million fewer user instructions than the dry proof, while the incremental wall range covered changes in both directions.
