# Late-definition register convention: final v2 measurement

This record covers the production candidate for [buster#2553](https://github.com/buster14a/buster/issues/2553), proposed in [draft PR #3631](https://github.com/buster14a/buster/pull/3631). It compares baseline `8e4d32879e17b7d9548cad54257a2f8461328366` with one allocator change: an otherwise unhinted late non-phi, non-recipe definition follows its own earlier body range's opening register. Existing call-argument preferences are established first and retain priority.

**Both measured workloads execute fewer edge instructions, with no function gaining spill, reload, call-save or call-restore instructions.** This is a Linux/Callgrind instruction-count result for the pinned programs and inputs below. It is not a native-time result or the issue's required 9700X code-placement qualification. The session excludes benchpress/9700X access and queueing; the production PR remains draft.

## Source and build identity

- Patch: [definition-hints.patch](definition-hints.patch), SHA-256 `8d87718046ee258b1a8705873547ba0f3dbad9a333bef9f82330e2010e06dbc3`.
- Allocator source SHA-256: `f87810acea8273edb0ae97ee3f0419eaaf9e4e7ef527a393a6dabde28de59c64`.
- Integrated tests SHA-256: `b258d20a4a310bd653cb411e817b8df20d543c95e686ca583016a85d1b5535fe`.
- Measurement patches were pinned before compilation at performance commit `0bd0c6a02633502e213150a50de0b15c0e28c9e4`.
- Candidate hosted build: [run 45806263638](https://github.com/buster14a/buster/actions/runs/45806263638), attempt 1, artifact 15109223101, ZIP SHA-256 `6d044793f7e12ec68f0a514331d926e3f40aa7a0d8a9db2a5f259a2990d693c3`.
- Candidate compiler SHA-256: `1bcae4b21e1464cbe088fee12b45cd9674cfe668f98cef3682bbb2ace485af99`.
- Baseline instrumented compiler: [run 45791795852](https://github.com/buster14a/buster/actions/runs/45791795852), SHA-256 `4c281f7892e112744b7a4f433db63b8cbba2ca379e5511025087684701f0fefa`.
- Both measurement compilers use Release, the vector host target, debug info off, baking off, no PGO, and the same origin-tag/snapshot instrumentation. The diagnostic workflow runs only on a hosted Ubuntu runner and produces no native qualification context.

The source patch contains neither the rejected majority-latch proposal nor the rejected corridor proposal. It changes no register pool, call-save mask or allocator eviction policy.

## Dynamic results

Counts below sum instructions attributed to named functions of the generated executable. They exclude anonymous/system-object instructions. The origin join accounts for every instruction inside the generated executable's load ranges.

| Whole workload | Baseline | Definition v2 | Change |
| --- | ---: | ---: | ---: |
| SQLite total instructions | 2,250,813,933 | 2,249,834,689 | -979,244 |
| SQLite edge register moves | 37,068,474 | 36,199,040 | -869,434 |
| SQLite edge spill stores | 30,206,285 | 30,205,544 | -741 |
| SQLite edge reloads | 53,535,497 | 53,534,756 | -741 |
| SQLite all three edge groups | 120,810,256 | 119,939,340 | -870,916 |
| Lua total instructions | 3,994,122,886 | 3,981,380,282 | -12,742,604 |
| Lua edge register moves | 82,467,924 | 69,725,320 | -12,742,604 |
| Lua edge spill stores | 5,541,088 | 5,541,088 | 0 |
| Lua edge reloads | 21,581,948 | 21,581,948 | 0 |
| Lua all three edge groups | 109,590,960 | 96,848,356 | -12,742,604 |

SQLite edge register moves fall 2.35%; Lua's fall 15.45%. Together, edge moves/stores/reloads fall approximately 0.72% and 11.63%. Total generated-program instructions fall approximately 0.044% and 0.319%. These percentages are instruction counts, not execution-time speedups.

For **every named function**, the combined edge-store group `T/t`, edge-load group `U/u`, ordinary spill stores `S`, ordinary spill loads `L`, call saves `C`, and call restores `R` do not increase. The ordinary spill and call-save/restore groups are unchanged overall in each workload. The per-function increase tables are header-only. Full tables, not just aggregate totals, are retained in the archive and [canonical family comparison](canonical-family-category-comparison.tsv).

The Lua program and its complete origin sidecar are byte-identical to v1. Its five controlled captures are reused only after verifying both identities and the frozen capture/join evidence against the identical v2 program and sidecar. Both baseline and candidate were previously run through the same absolute `argv[0]` path, with the same source/scripts/arguments/environment and native-output checks. This matters: different executable path strings perturb Lua startup allocation. Earlier uncontrolled-path counts are not used for this comparison.

### Concrete benefit and remaining tradeoffs

In `luaV_execute`, the late `startfunc` load of `k` can retain the register used in the already-laid-out body despite an unused frame-address recipe occupying that register at the definition. Edge 1078→1256 changes from two three-move swaps to one four-move cycle. Across 6,371,026 executions it removes 12,742,052 instructions. The remaining 552 Lua instructions are also removed edge moves in three compiler/parser functions. Every other Lua origin group is unchanged.

The first definition experiment interrupted call-register propagation through a two-address tie. In `sqlite3BtreeIndexMoveto`, it required a three-move RSI/RDX swap instead of two call-setup moves, adding 1,037,030 instructions. V2 runs after argument avoidance and preserves its final physical-register hints. Btree returns exactly to the baseline allocation and dynamic result: 61,946,442 instructions, including 5,709,798 call-setup instructions. The regression fixture checks the propagated hint, avoided mask, and actual root/result allocation.

The final candidate still has local instruction tradeoffs: `sqlite3GenerateColumnNames` gains 54,757 call-setup instructions and 32,581 total instructions; `sqlite3GetToken` gains 28 ordinary instructions. Those gains are included in the whole-workload totals above. SQLite also changes rematerialization and branch counts; [analysis.txt](analysis.txt) and the raw per-function tables retain the complete accounting.

SQLite's main dispatch latch is unchanged, and `sqlite3VdbeExec` has unchanged dynamic origin counts on this workload. Some statically improved Vdbe edges do not execute here. This patch should not be described as establishing a new convention for that latch.

## Correctness and actual-input parity

The integrated production source passes:

| Check | Result |
| --- | --- |
| Full O3 CFG suite, seed 140, count 2000, oracle every 16 | 107,778 checks; 0 failures |
| Allocation certificates in the full suite | 1,882 proved |
| Slow-oracle checks in the full suite | 169 passed |
| Expected constraint refusals | 188 |
| Combined focused ASan + UBSan | 269 checks; 0 failures; no diagnostics |
| Fresh emitted CFG snapshots replayed with `--require-match` | 5 of 5 pass |
| Native output checks | SQLite mix1 and all five Lua scripts pass |

The focused cases cover recipe yielding, final call-register precedence propagated through ties, existing value/operand/interval hints, partial vectors through 33 values, exact byte columns of length 0–3 and final-byte gathers at protected pages, and hard masks in all three register classes. The preceding v1 fails exactly three assertions in the tied-call fixture while remaining semantically valid. The positive body fixture also has a baseline negative control in the prior definition record.

Every fresh v2 snapshot is byte-identical to baseline except bytes 48–55, the recorded allocation hash. Thus the actual CFG inputs, allowed masks, clobbers, preferred registers and dominators are unchanged. The five allocation fingerprints match pre-build replay predictions exactly. All emitter dumps retain `preference=3`. A sixth replay of the Btree input produces the baseline allocation fingerprint and complete dump.

The helper operates over 16 value rows, performs masked bounded searches, and gathers physical-register bytes only through in-bounds four-byte windows or a masked load for shorter columns. It adds no scratch column. The existing allocator still enforces legal registers and required uses. The large CFG replay audit finds no added register-to-spill transitions; additional fragments concern constant recipes being evicted or recomputed.

## Reproduce and inspect

[receipt.tsv](receipt.tsv) pins programs, tools, inputs, hashes and run identity; [canonical workload totals](canonical-workload-totals.tsv) and [analysis.txt](analysis.txt) retain the generated-program count accounting. The parent record's pinned scripts build SQLite 3.53.2 speedtest1 and Lua 5.4.8, and run SQLite mix1 at size 5 plus the same five Lua scripts. The SQLite verification hash is `1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739`.

[definition-v2-raw.tar.xz](definition-v2-raw.tar.xz) contains raw compressed Callgrind captures, disassembly, origin sidecars, all grouped/per-function tables, native outputs, join diagnostics, program hashes, build provenance, actual CFG snapshots, replay inputs and C readers, and the complete integrated test/guard evidence. It excludes compiler/program executables and regenerable per-instruction tables. Its `ARCHIVE-SHA256SUMS` verifies every retained member; the manifest published beside it identifies the archive itself. Baseline SQLite raw traces are preserved in the parent record's [initial counts archive](../../counts-initial/README.md); the final archive retains the canonical baseline comparison tables and controlled Lua captures.

Sources are pinned before use; original tests and helper code use Apache-2.0 WITH LLVM-exception with retained notices. SQLite sources are public domain and Lua sources retain their MIT terms; source inputs and notices are identified by the parent record rather than relabeled as original code. Temporary measurement instrumentation is outside the production PR.

No native hardware has been accessed or queued. Code-placement sweeps and native compiler/runtime timing remain unmeasured, so #2553 stays open.

---
Agent session: 6b07eefe-ecbc-83eb-8e50-5060ad2a8075 (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6 Astra Pro
