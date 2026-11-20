# Bound the DWARF machine spans visited for each inline instance

[Buster PR #3125](https://github.com/buster14a/buster/pull/3125) follows #3123. Each body records its instances’ first and last candidate machine spans, including descendants. The original range writer scans that window, checking exact membership and preserving gaps and ordering. The optional index occupies eight bytes per instance of the largest function.

| Workload | Parent instructions | Candidate instructions | Median within-pair change |
| --- | ---: | ---: | ---: |
| SQLite Tier 1, -O2 -g | 17,142,880,608 | 15,843,411,838 | −7.580% |
| SQLite Tier 1, -O0 -g | 17,141,215,078 | 15,841,746,495 | −7.581% |
| Lua parser, -O2 -g | 312,083,679 | 309,691,810 | −0.766% |
| Lua VM, -O2 -g | 572,786,178 | 554,584,794 | −3.178% |

The parent’s inline writer accounted for 3.52% of sampled cycles across nine SQLite debug compiles. All eight paired -O2 SQLite builds used fewer user cycles on the local Ryzen 9 7940HS. The median paired change was −3.365%, ranging from −5.02% to −1.04%. Each build ran with one lane. The no-debug SQLite control appears in the full counter table. Locked Zen 5 timing is pending.

All 1,336 frozen musl debug objects matched byte for byte, along with 70 SQLite/Lua objects across -O2/-O0, both linked Lua executables and the five application outputs per executable. Debug/GDB validation passed 4,061 checks. Composing with #3118 at `e00b28f6cf0d3a1ab93bb4b0329eb1f49fe1c155` passed the same 4,061 checks. That control and candidate produced the same 8,014,992-byte SQLite debug object, SHA-256 `0dbc531f11e0acb80d3c50d14bb03258ec57e8c41ce4ead78f1b3bc59b9e5a87`. The extra focused checks cover descendant-only ranges, intervening gaps, a zero-width span and an empty instance.

Both compilers were built with the repository-pinned Clang 23.1.4, `BUSTER_HOST_ARCH=znver5 ./build.sh --config Release`. The counter table includes warmup round zero and eight alternating measured rounds. The summaries report medians of paired ratios and their full ranges. To reproduce the local acquisition, run `python local-compiler-pair.py debug PARENT HEAD RESULTS spanidx --inputs INPUT_ROOT`, with `inputs/sqlite3.c` and `inputs/lua/` under INPUT_ROOT. Raw per-process samples, SHA-256 digests, output sizes and before/after load readings are included.

## Spans actually inspected

Instrumenting the range writer on the same three translation units counted the exact number of machine spans a full-body walk would visit and the number its new bounds admitted. Both counts cover the same queries with the same output. SQLite made 28,202 queries and reduced 41,298,324 span visits to 448,810. Lua’s VM reduced 579,450 to 4,532 and its parser reduced 89,346 to 9,732. SQLite’s largest function had 690 inline instances, requiring 5,520 bytes for its two bounds per instance. The instrumented compiler produced the same three objects as the ordinary candidate. The counts exclude construction of the bounds. The whole-compile counters above include that work. The counter patch, per-unit results and before/after local sampled profiles are included.
