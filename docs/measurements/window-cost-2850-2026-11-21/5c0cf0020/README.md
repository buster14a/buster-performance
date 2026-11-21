# Window-test cost with the shared operand-conversion bit

The frozen candidate 5c0cf002054be4fadcfece529a12959073b76039 meets the specified H4 and O3 targets on the Ryzen 7 9700X. Across seven paired rounds, the H4 loop changed by −0.10403 ticks per swept record on SQLite and +0.12243 on Lua, both within the +0.15 limit. Musl's tests-loop median was +0.42228. The H4 specification names SQLite and Lua. O3's repeated front-input pass and in-place kernel met the +0.20 limit on all three corpora. [H4 definition](https://github.com/buster14a/buster/issues/3201#issuecomment-7058791784) · [O3 definition](https://github.com/buster14a/buster/issues/3203#issuecomment-7059489314)

| Candidate minus pre-#3213 baseline, TSC ticks/record | SQLite | Lua | musl |
| --- | ---: | ---: | ---: |
| Tests loop (H4) | −0.10403 | +0.12243 | +0.42228 |
| Range | −0.26972 to +0.10078 | +0.03519 to +0.80017 | −0.63500 to +2.56292 |
| Repeated front inputs (O3) | −2.63026 | −2.13058 | −0.57860 |
| Range | −2.95804 to −2.29091 | −2.52328 to +4.38659 | −0.77876 to +1.20188 |
| In-place kernel (O3) | +0.02146 | +0.04716 | +0.05437 |
| Range | −0.04093 to +0.16364 | −0.12061 to +0.29926 | −0.33327 to +0.20409 |

The baseline is the frozen pre-#3213 source e77b3eba47520294f3648c22a83a965c13865e33. The candidate includes the accepted #3213 changes and the subsequent window-cost work. Its cumulative source patch applies to 0647d69ba8af4e466c89df2519dea0b382524d37 and has SHA-256 9757da435f6137a88c8c5c8effdf058d5a90c7925b124912fa3323e0e22fd402. The candidate Release executable hashes to d4810fd4f5084f17e2e275bd097f0d745fe950db074a1c24185f2d7f8070ec02. [Baseline build and original results](../../tests-holes-2850-2026-11-21/9700x/observed/README.md)

The first three rounds used fresh executable copies, CPU 2, A-B-B-A order per corpus and the standard exclusive host lock per process. They met the specified targets and four further rounds continued using the same binaries and protocol. Every process exited zero, the counts taken matched and the row comparisons recorded zero differences. Each comparison uses a per-round mean on each side. The table shows the median and range of the seven paired differences. This is a measurement of the shadow's inner sweeps. The [all-sweeps table](table.md) also includes the bytes pass, names pass and same-build variation.

The contiguous 64-lane loop-body instruction spans have 183 instructions with summaries (0x1f808f0–0x1f80d47) and 168 without (0x1f80f90–0x1f8138d). The baseline has 190 and 178, respectively. Branches can bypass instructions inside each span. [Native disassembly](node_facts_window_run.asm.xz)

## Correctness evidence

The 45,324 fixture-and-warning combinations, 8,009 one-statement probes and 90,000 generated programs had zero observed shadow differences. The existing trigger sweep covered 92 warnings. A supplemental `-Wavailability` probe recorded event 72 under all three policies, bringing coverage to all 93. The 970-case operator matrix ran under seven policies. The converted-operand law check covered 9,437,184 cases and caught all five one-term mutations. [Campaign summaries](acceptance/results.txt) · [Conversion-law results](acceptance/order-laws.txt) · [Raw campaign logs](acceptance/shadow-logs.tar.xz)

Reproduce the table and compare its machine-readable results.

```sh
tar -xJf runs.tar.xz
python3 ../../tests-holes-2850-2026-11-21/9700x/xh-table.py refbit costbit -costbit 7 reproduced.json
cmp summary.json reproduced.json
```
