# PR #3213 on the Ryzen 7 9700X

The ordered-comparison change added a median 0.17225 ticks per swept record on SQLite and 0.28338 on Lua. Both exceed H4's +0.15 target and fall below its +0.40 refutation threshold. O3's kernel medians also exceed its +0.20 target on all three corpora. The unrounded SQLite kernel result is +0.3994900882.

| Median paired change | SQLite | Lua | musl |
| --- | ---: | ---: | ---: |
| Tests loop, ticks per swept record (H4) | +0.17225 | +0.28338 | +0.99240 |
| Tests loop, paired range | −0.08281 to +0.22202 | +0.17844 to +0.88075 | −1.19207 to +1.70699 |
| Front inputs made again, ticks per input record (O3) | +0.17913 | −0.18167 | +0.33013 |
| Kernel in place, ticks per record made (O3) | +0.39949 | +0.30833 | +0.28366 |

H4 gates SQLite and Lua. O3 gates all three inputs at +0.20 with +0.40 as the refutation threshold. The repeated front-input pass meets the target on SQLite and Lua and exceeds it on musl. These readings use the compiler's shadow command. The production compiler still takes its ordinary path. [H4 specification](https://github.com/buster14a/buster/issues/3201#issuecomment-7058791784) · [O3 specification](https://github.com/buster14a/buster/issues/3203#issuecomment-7059489314)

## Method and provenance

On November 21, 2026, from 09:35:45 to 09:37:08 UTC, the original job made seven A–B–B–A readings for each of three frozen corpora. Every invocation held the shared benchmark lock and used CPU 2 on an AMD Ryzen 7 9700X with the performance governor. The builds used Release and Clang 23.1.4. Each reading used fresh copies of both executables. Counts and timing denominators come directly from the compiler output. The summary takes the median of the seven within-reading differences of the two B and two A means. All 84 invocations exited zero, took the same expressions and had zero window-row differences. The predecessor's mutation campaign resumed after this timing batch.

| Build | Source | SHA-256 of the executable |
| --- | --- | --- |
| A, xh0 | e77b3eba47520294f3648c22a83a965c13865e33 | 01a8bfe1de954fdf6ef7e2899038b6c2873b90897812146a06a2ae9fa6e13ba5 |
| B, xh4 | A plus the archived final.patch, SHA-256 02a91a18fbb496fe8232e254f2aef7457eb61e74d469ba49b4bc4502fffb9fde | 52ca540f809a625561b992dbdd6adb31c1a9393bb0161e9e4be3921f09e21ceb |

The patched source and tests match commit 17a63b0557b14a2c1a2d7fa258ff2822ea341095. Its successor 0647d69ba8af4e466c89df2519dea0b382524d37 changes documentation only. The frozen inputs and command lines are defined in [corpora.sh](../corpora.sh). The full hypothesis table, denominator counts and ranges can be regenerated as follows.

```sh
tar -xJf runs.tar.xz
python3 ../xh-table.py xh0 xh4 '' 7 reproduced.json
cmp summary.json reproduced.json
```

The archive contains compiler reports, lock timestamps, exit statuses and the disassembled functions. Two static backedges for a full 64-lane block enclose these numbers of instructions, including the branch itself. The counts describe the contiguous address ranges. Conditional jumps can take other paths and skip instructions.

| Inlined tests loop | xh0 addresses | Count | xh4 addresses | Count |
| --- | --- | ---: | --- | ---: |
| With summaries | 0x1f7f970–0x1f7fe09 | 190 | 0x1f80a70–0x1f80f8f | 201 |
| Without summaries | 0x1f80070–0x1f804c0 | 178 | 0x1f81240–0x1f8171f | 191 |

Each listed range includes two vector compress stores to the tests list. For another implementation, repeat the disassembly with `objdump -d --no-show-raw-insn --disassemble=node_facts_window_run COMPILER` and locate the loops afresh.
