# Additional test-window table packing at 9aa44e305

This candidate also packs the tree-list tests and first-operand marks into the existing operator bytes. Against the frozen baseline, H4 passes on SQLite and misses Lua's +0.15 gate. All six O3 medians meet their +0.20 limit. The packed byte rules matched the previous mapping for all 65,536 input byte pairs, and the Develop checker shard passed all 210,477 assertions.

| Median paired difference in TSC ticks per record | SQLite | Lua | musl |
| --- | ---: | ---: | ---: |
| Tests loop, per swept record (H4) | +0.04351 | +0.20301 | +0.65762 |
| Tests-loop paired range | −0.09 to +0.14 | +0.19 to +0.36 | −0.05 to +1.96 |
| Front inputs made again, per input record (O3) | −2.69480 | −2.33180 | −1.69048 |
| Kernel in place, per record made (O3) | +0.04668 | +0.10792 | +0.04802 |

The seven A–B–B–A rounds per input used the [same historical baseline, Ryzen 7 9700X, CPU 2, fresh executable copies and per-command lock](../../tests-holes-2850-2026-11-21/9700x/observed/README.md) as the preceding comparisons. All 84 invocations exited zero. The shadow accepted identical counts and found zero window-row differences. The candidate is 9aa44e30598f323ed59ddbf13ee8e20cd705a6e4, reproduced by the included source.patch on 0647d69ba8af4e466c89df2519dea0b382524d37. Its executable hashes to 4eb662d55f82cb34b27b4074787eb10fb603e1fdc9a908e5aa2374bb7899d72b.

The contiguous full-block loop spans in `node_facts_window_run.asm.xz` contain 187 instructions with summaries (0x1f80980–0x1f80e21) and 174 without (0x1f81050–0x1f814a8). Both are smaller than [the preceding candidate's](../1c0e1f724/README.md) 189 and 176. Lua's seven-pair timing range still falls entirely above +0.15. The developer tested the seven warning policies across 970 operator cases and separately verified the availability trigger. The full v3 shadow generator campaign was stopped after the cost miss.

To reproduce the full table, use the original generator.

```sh
tar -xJf runs.tar.xz
python3 ../../tests-holes-2850-2026-11-21/9700x/xh-table.py refcost3 costv3 -costv3 7 reproduced.json
cmp summary.json reproduced.json
```
