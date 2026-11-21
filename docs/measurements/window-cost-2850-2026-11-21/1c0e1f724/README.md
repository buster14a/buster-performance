# Test-window counters and front input distances at 1c0e1f724

The front-input pass now takes 2.30 to 2.46 fewer TSC ticks per input record on all three corpora. O3's in-place kernel meets its +0.20 target on each. The H4 tests loop meets the +0.15 target on SQLite. Its Lua median is +0.18302, 0.03302 over the target and below the +0.40 refutation threshold.

| Median paired difference in TSC ticks per record | SQLite | Lua | musl |
| --- | ---: | ---: | ---: |
| Tests loop, per swept record (H4) | +0.01365 | +0.18302 | +0.19515 |
| Tests-loop paired range | −0.05 to +0.10 | +0.08 to +0.29 | −0.31 to +0.67 |
| Front inputs made again, per input record (O3) | −2.42173 | −2.46388 | −2.29971 |
| Kernel in place, per record made (O3) | −0.03265 | +0.11668 | −0.04048 |

This build adds to the [first cost experiment](../93c9753f4/README.md) by counting the completed mask words in a separate loop and validating the front operand distances against one bound. All 84 invocations completed successfully with zero window-row differences and unchanged counts for accepted expressions.

The included source patch on 0647d69ba8af4e466c89df2519dea0b382524d37 matches commit 1c0e1f724590a8cc9020a83d462a7032b1ba6c1d. The Release executable SHA-256 was b1eef1a8cb5cb8f97742ccd06e9d011310dd3e7344205d9e2245cf896c9b6132. The same [9700X baseline](../../tests-holes-2850-2026-11-21/9700x/observed/README.md), CPU 2, per-run exclusive lock, fresh executable copies and seven A–B–B–A rounds per corpus were used. No other job from the takeover ran concurrently with a timed invocation.

The contiguous static 64-lane loop spans contain 189 instructions with summaries at 0x1f80930–0x1f80df4 and 176 without at 0x1f81020–0x1f81498. The corresponding baseline counts were 190 and 178. The disassembly is in `node_facts_window_run.asm.xz`. Read the address spans as code layout, since conditional branches can bypass instructions.

To reproduce the summary, extract the reports and run the original table generator.

```sh
tar -xJf runs.tar.xz
python3 ../../tests-holes-2850-2026-11-21/9700x/xh-table.py refcost2 costv2 -costv2 7 reproduced.json
cmp summary.json reproduced.json
```
