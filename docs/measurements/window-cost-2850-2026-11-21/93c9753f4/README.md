# Precomputed test-window classes at 93c9753f4

This candidate packs the ordered-comparison eligibility into the test window's existing operator classes. Relative to the frozen baseline, it meets H4's +0.15 tests-loop target on SQLite. Lua misses the target by 0.053 ticks per swept record. O3's in-place kernel meets the +0.20 target on all three inputs. The front-input repeat exceeds O3's +0.40 refutation threshold on each input.

| Median paired difference in TSC ticks per record | SQLite | Lua | musl |
| --- | ---: | ---: | ---: |
| H4 tests loop, per swept record | +0.08943 | +0.20280 | +0.47245 |
| H4 paired range | −0.03 to +0.18 | −0.00 to +0.25 | −0.71 to +1.52 |
| O3 front inputs made again, per input record | +0.45316 | +0.56513 | +0.75518 |
| O3 kernel in place, per record made | −0.01272 | +0.05623 | +0.08870 |

The baseline is the same xh0 executable used in the [frozen PR measurement](../../tests-holes-2850-2026-11-21/9700x/observed/README.md). The candidate was built from 0647d69ba8af4e466c89df2519dea0b382524d37 plus the included source.patch. This is the source at 93c9753f4ee10eb3cd355ee95599b7c2e8f3a4c4. The executable SHA-256 is 9f5ce4e5f84b0b85e0701d9c1052fb27ba018a541c40117aa30f0cfadb124e0b.

Release builds used Clang 23.1.4. All 84 shadow invocations ran under the shared lock on CPU 2 of the Ryzen 7 9700X, in seven paired A–B–B–A readings per corpus. Each reading used a fresh file copy of both compilers. Another build used the host lock between invocations near the end. No invocation overlapped it. Each report recorded status zero, identical accepted counts and zero window-row differences. The loop deltas are medians of the seven within-round differences. The machine takes 76 ordered pointer comparisons off the tests list on SQLite, 36 on Lua and 47 on musl, matching the frozen PR.

The two static backedge spans in node_facts_window_run enclose 207 instructions with summaries and 194 without, at 0x1f809d0–0x1f80eff and 0x1f81130–0x1f81602. Their baseline spans enclose 190 and 178 instructions. The addresses delimit the contiguous disassembly. Branches can skip instructions within them. `loops.tar.xz` also contains the candidate and both earlier builds' disassemblies of the front-input function and its caller.

The local shadow campaign checked 8,009 probes, 90,000 generated programs, 15,108 fixture files under three warning policies, and 92 triggered warnings. It reported zero shadow disagreements. A follow-up source with an unknown platform in an availability attribute exercised warning 93 under each policy and also had zero unsound takes. Its three reports are in `availability.log`. The 6,790 ordered-operator diagnostic comparisons against the frozen PR also matched. The campaign inputs, commands and logs are in `operators.py`, `campaign.sh` and `shadow-logs.tar.xz`.

From this directory the seven-reading table can be reproduced with these commands.

```sh
tar -xJf runs.tar.xz
python3 ../../tests-holes-2850-2026-11-21/9700x/xh-table.py refcost1 costv1 -costv1 7 reproduced.json
cmp summary.json reproduced.json
```
