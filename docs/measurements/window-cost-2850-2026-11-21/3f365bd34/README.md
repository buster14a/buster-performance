# Aligned test tables and checked input distances at 3f365bd34

Aligning the existing lookup tables, together with the simplified front distance check, meets H4's +0.15 tests-loop target on both SQLite and Lua. O3's repeated front-input pass improves on all three inputs. The in-place kernel misses O3 on all three and crosses the +0.40 refutation threshold on SQLite.

| Median paired difference in TSC ticks per record | SQLite | Lua | musl |
| --- | ---: | ---: | ---: |
| Tests loop, per swept record (H4) | −0.05267 | +0.08703 | +1.04947 |
| Tests-loop paired range | −0.17 to +0.13 | −0.05 to +0.25 | −0.51 to +1.71 |
| Front inputs made again, per input record (O3) | −2.53931 | −2.34404 | −1.90973 |
| Kernel in place, per record made (O3) | **+0.46441** | +0.38964 | +0.23951 |
| Kernel paired range | +0.36 to +0.60 | −4.25 to +4.04 | −0.56 to +0.99 |

The Release executable hashes to ad53e477cda126affacb329ca69ade7c36767608b0fac53400e4a11a940a4da6. The included patch reproduces 3f365bd34ed12bf5529cf164226da265e7eb798d on 0647d69ba8af4e466c89df2519dea0b382524d37. Seven A–B–B–A rounds per corpus used the [same active Ryzen 7 9700X core, frozen baseline, per-process lock and fresh executable copies](../../tests-holes-2850-2026-11-21/9700x/observed/README.md) as the preceding comparisons. All 84 processes exited zero, kept identical counts and reported zero window-row differences.

Across xh0, xh4, the [second candidate](../1c0e1f724/README.md) and this build, the `node_facts_window` function has the same sequence of 736 instruction mnemonics and starts on a 64-byte boundary. Their start addresses are 0x1f7ae80, 0x1f7be00, 0x1f7bd00 and 0x1f7bdc0. The archive contains the native disassemblies of that function and `node_facts_leaves_lean` for all four builds, plus this build's inlined tests loop. The timing differences alone do not identify an instruction or cache event responsible for the kernel result.

To reproduce the full seven-pair table, extract the reports and run the original generator.

```sh
tar -xJf runs.tar.xz
python3 ../../tests-holes-2850-2026-11-21/9700x/xh-table.py refalign costalign -costalign 7 reproduced.json
cmp summary.json reproduced.json
```
