# Tier 1 soft ABI preferences: pinned SQLite result, 2026-11-08

This record concerns [buster PR #1752](https://github.com/buster14a/buster/pull/1752) and [issue #1216](https://github.com/buster14a/buster/issues/1216). The measured pair is baseline `77fb91284f105cfc925324f09a7efbc9ee515aba` and candidate `b20f0cc19be240cde735c226c9028c0b63dd8c03`. This is **not a current-main integration qualification**. The candidate is draft, Lua dynamic comparisons and matched-layout runtimes remain unmeasured, and the issue remains open.

## Result

On the Ryzen 7 9700X, one Callgrind 3.25.1 capture per side of speedtest1's `mix1` workload gave:

| Dynamic edge instructions | Baseline | Candidate | Change |
| --- | ---: | ---: | ---: |
| Stores (T) | 151,079,195 | 183,495,833 | +21.5% |
| Reloads (U) | 163,581,242 | 220,064,152 | +34.5% |
| Register moves (e) | 154,448,801 | 200,647,138 | +29.9% |
| T + U + e | 469,109,238 | 604,207,123 | +28.8% |

For `sqlite3VdbeExec`, T/U/e were 100,545,878 / 103,616,326 / 49,705,922 versus 147,881,144 / 168,143,490 / 39,295,050: 253,868,126 versus 355,319,684 (+40.0%). This pinned pair does not meet the issue's at-least-halved edge-traffic requirement on speedtest1. Instruction counts are not elapsed-time results; no performance or runtime conclusion is made for other workloads or current main.

## Controls and mapping

Both compilers used the same frozen SQLite and Lua source inputs, generated program options and staged Clang 23.1.4 toolchain. The toolchain executable, patch, inputs, compiler binaries and generated programs are identified in the archive. Generated program target used the original default baseline target; compiler host build used `znver5`. Each build, compile, verification and capture had its own Benchpress lock. Invocation arguments, output and tool logs are retained in the archive. One in-progress baseline build was interrupted before completion; the successful ordinary rebuild and subsequent runs are the evidence.

The baseline and candidate ordinary/tagged SQLite ELFs matched byte-for-byte within each pair (SHA-256 `bbe5a7e987bed4f2fd80f434daa1c362d765484e9a18ee7fd574d7e7496119df` and `ca7f7231508bf04457f4b8d48769c4107bddef826eda7468720115706aa74c8a`). Both retained `sqlite3VdbeExec` in Tier 1, with no fallback. Full tag streams fit their respective disassemblies, without duplicate tagged symbol names or ambiguous symbol matches. All emitted T/U/e rows in the measured SQLite and Lua programs were inspected mechanically for instruction shape: T rows are stack stores, U rows stack loads, and e rows register copies, with zero shape exceptions. GPR and x87 edge tags and vector-register copies were also checked in fixture disassemblies on both revisions. Fixture output matched independent reference results; ordinary/tagged fixture ELFs matched and export-to-`/dev/full` failed closed. The fixture does not exercise vector stack spills, mask-register copies, or rematerialization-to-slot.

The actual SQLite capture runs produced byte-identical final databases (SHA-256 `9803668aa9fcf728162aa22cec555134588385cb07c2836210d69bdc068499a7`) and identical stdout after removing elapsed times and six OS I/O counters. The unmodified outputs and normalized copies are retained. Separate `--verify` executions both produced `1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739`. Both sides' five Lua scripts matched a freshly built Clang -O0 reference, but this is correctness verification only, not Lua dynamic measurement.

Callgrind reported the generated executable within `ob=???`, along with some unrelated code. The historical `0x108000` base produced 100% unmatched and was rejected. Independent block-by-block comparisons established a `0x4000000` bias for **each** measured SQLite ELF. The direct costs in that object total 3,358,274,421 baseline and 3,642,608,195 candidate. Each capture has 1,990 costs at 36 PCs outside its executable's PT_LOAD executable interval; they are excluded. Every in-range PC matched. Do not treat the object total as an entirely program-only count.

The instrumentation patch is SHA-256 `141776fef464c4555a5e04387681109bd85f766ec480f1c95a8d1edcb22e58e7` and the corrected `gap.c` source is SHA-256 `81856ce15d9eb8a0466a827e8dd80780170504e8e53e720b6ee3212af3c15e35`. After extracting the archive, count using the captured ordinary executable's trace and its byte-identical tagged executable's disassembly and tags:

```sh
gap count out/base-tagged-sqlite/disassembly callgrind/base-sqlite/callgrind.out '???' 0x4000000 out/base-tagged-sqlite/kinds
gap count out/head-tagged-sqlite/disassembly callgrind/head-sqlite/callgrind.out '???' 0x4000000 out/head-tagged-sqlite/kinds
```

The separately retained `head-sqlite-count.tsv` is the candidate join performed offline on the copied, hash-verified input files. The earlier 0x108000 failed join and static `/dev/null` fits are controls, not dynamic evidence. The single baseline Lua `calls` capture was stopped after the SQLite regression was established; it has no candidate pair and is retained without an interpretation.

The archive excludes compiled SQLite/Lua executables and generated databases; it retains their hashes. SQLite and Lua remain external inputs; the archive includes project-original measurement fixtures and patch, not their source distributions. `logs/inputs.sha256` identifies the staged source files and their original notices remain with the external input trees.

At main `77fd0f225ab83f479bf60234a750205df5683dd7`, the Tier 1 allocator, CFG/emitter, IR optimizer, x86 backend and `tier1_programs_measure.c` were unchanged from the pinned baseline; checker/input/initializer, preprocessor and CI setup did change. No equivalence or current-main performance result follows from this source comparison.
