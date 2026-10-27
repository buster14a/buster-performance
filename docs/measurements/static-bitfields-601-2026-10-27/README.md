# Static bit-field serialization (#601), 2026-10-27

This record compares Buster's existing per-bit static-data serializer with bounded byte insertion and clearing. It concerns #601 only; initializer/member lookup and full-payload staging are unchanged.

## Sources and qualification

- Baseline: `92c025e71856d13eb34247477c5294d2cead139e`.
- Candidate: `268c6a8508ba91973cef20514bdee9fa7ea09366`.
- Both use the unchanged `BUSTER_DEBUG_INFO=0 ./build.sh`: Clang 23.1.1, `-O3 -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror`, fixed-address executable. `identity.log` records the CPU, tools and binary hashes; `head-files.sha256` records every tracked source file in the candidate and was checked against the measured checkout. The complete source change is the [pinned comparison](https://github.com/buster14a/buster/compare/92c025e71856d13eb34247477c5294d2cead139e...268c6a8508ba91973cef20514bdee9fa7ea09366).
- Locked Ryzen 7 9700X qualification: checker **314,988 checks, 0 failures**; driver/native executables **21,591 checks, 0 failures**; call graph **41 translation units, 23,961 functions, 0 unexpected cycles, 3 allowed cycles, 0 split variables**. The existing parallel runner kept the commands within eight physical CPUs. See the four `*-9700x.log` files.
- Focused optimized checked-plan tests: **49,419 checks, 0 failures**. Independent guarded helper tests under ASan/UBSan: **48,393 checks, 0 failures**. They cover every width through 128 bits, every intra-byte offset, both allocation edges, clear ranges through 2,049 bits, signed and absolute integer-address constants, ordered overlaps and an adjacent relocation. Source/ELF fixtures also cover a packed 128-bit field spanning 17 bytes, designated replacements and a union switch removing a relocation.

The source bridge consumes the validated scalar bytes, including the addend of a symbol-free integer address constant. It preserves source order and masks the two partial boundary bytes; values replace each interior byte once and clears use `memset` for their interior. Neither path requires destination padding.

## Experiments

`cases.sh` specifies every command. Eight original generated inputs cover the issue's two 31-bit fields at N=1,024/4,096/16,384/65,536, packed signed 64-bit and packed 128-bit fields, widths around 8/16/32/64, and repeated designated clears. The other inputs are the frozen SQLite amalgamation and Lua 5.4.8's `lvm.c` and `ltable.c`; their source/header hashes are in `corpus-files.sha256`. External runtime sources are not included in this record.

SQLite uses `SQLITE_OMIT_LOAD_EXTENSION`, `SQLITE_THREADSAFE=0`, `SQLITE_ENABLE_MEMSYS5` and `SQLITE_ENABLE_RTREE`. Lua uses `-U__ELF__ -DLUA_USE_JUMPTABLE=0`, selecting declarations without Lua's unsupported `visibility("internal")` marker and disabling computed-goto dispatch. The initial default-Lua preflight refusal is retained in `lua-default-preflight-refusal.log`; it was not timed. This record makes no default-Lua acceptance claim.

All measured processes run with `-c --lanes 1` pinned to CPU 2. Each experiment takes the shared host lock separately; no other session or CI job runs concurrently. CPATH and C_INCLUDE_PATH are unset and SOURCE_DATE_EPOCH is fixed. Lock-owner/queue messages are excluded from the published evidence.

Preflight compares complete baseline/candidate object files. For the generated tables, Clang `-O0` also compiles the original inputs, and the `.data` bytes must agree. Timing starts only after successful preflight.

Whole-process measurements use an independent invocation of the existing `time-runs` tool for each case: 12 rotated passes, two fresh copies of each executable, one discarded warm-up per slot. Each case has its own warmed output file and **24 measured processes per variant**. A third variant, `control`, is another set of copies of the baseline, providing an A/A physical-page and measurement floor. Every measured process must exit successfully and supply user instructions and cycles. Wall time includes startup, parsing, checking, publication, object writing and teardown; peak RSS and page faults are retained too.

Separate stage-clock measurements use 11 baseline/candidate pairs per case after a discarded pair, alternating order. `publish-data` is the serialization/publication stage; `parse` and `check-declarations` are reported independently. Whole-process comparisons do not enable the stage clock. Raw per-case whole-process reports and all stage reports are retained under `logs/`. `summarize.c` checks statuses, counters and sample counts before computing upper medians, as `time-runs` does.

The pilot under `pilot/` used two six-pass multi-case rounds and reused one output file between cases. This gave the first baseline slot a different output-file size and preceding workload at some case boundaries. Its A/A control exposed substantial wall-time outliers with nearly identical user cycles and instructions, especially for Lua. Those whole-process timings are retained for audit and **excluded from the primary results**. `compare.sh` fixes both conditions by warming and measuring each case independently, with a separate output file. The stage experiment already discarded the first pair for each case and measures publication before object writing, so it remains valid. The root `measure.sh` retains the preflight/stage command bodies of the original execution harness in `pilot/measure.sh`.

## Results

The corrected run contains 792 successful measured compiler processes, with 24 samples per variant and case. All 11 preflight object comparisons passed, as did all eight generated-table comparisons with Clang. The bounded byte/word path is retained: it removes measurable work and improves the available publication and whole-compilation paths.

| Case | Publication ms, base → candidate | Publication change | Whole compile ms, base → candidate | Whole change | A/A wall change | Instructions change |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| plain-1024 | 0.124 → 0.045 | -63.71% | 2.165 → 2.094 | -3.28% | -1.52% | -5.97% |
| plain-4096 | 0.489 → 0.168 | -65.64% | 5.032 → 4.744 | -5.72% | +0.99% | -10.32% |
| plain-16384 | 2.021 → 0.749 | -62.94% | 14.637 → 13.337 | -8.88% | -0.43% | -12.63% |
| plain-65536 | 8.535 → 3.423 | -59.90% | 47.473 → 42.322 | -10.85% | +0.10% | -13.38% |
| packed-16384 | 2.559 → 1.081 | -57.76% | 21.289 → 19.726 | -7.34% | -0.76% | -9.57% |
| wide-16384 | 4.186 → 1.164 | -72.19% | 22.927 → 19.862 | -13.37% | -0.36% | -17.10% |
| mixed-4096 | 2.427 → 0.966 | -60.20% | 15.991 → 14.514 | -9.24% | -0.27% | -12.81% |
| clear-16384 | 2.423 → 0.899 | -62.90% | 27.714 → 26.049 | -6.01% | +7.78% | -8.27% |
| sqlite | 0.550 → 0.556 | +1.09% | 146.792 → 146.413 | -0.26% | -0.10% | ≈0% |
| lua-vm | 0.004 → 0.005 | +25.00% | 13.299 → 13.327 | +0.21% | -0.22% | ≈0% |
| lua-table | 0.006 → 0.006 | ≈0% | 6.796 → 6.816 | +0.29% | +0.60% | ≈0% |

The 65,536-record table uses **10.85% less whole-compile time** (47.473 → 42.322 ms), **13.38% fewer user instructions** (797.517486 → 690.822562 million) and **15.17% fewer user cycles**. Its publication stage uses **59.90% less time** (8.535 → 3.423 ms). The 16,384 packed 128-bit records use **13.37% less whole time** and **72.19% less publication time**. Publication time falls by 57.76–72.19% across the generated cases.

For the largest table, parsing is 4.402 → 4.440 ms and initializer checking is 8.734 → 8.718 ms: the saving is in publication. Peak RSS is essentially unchanged (295,364 → 295,184 KB); `summary.tsv` retains every case's RSS and cycle results.

The repeated-clears case has a large A/A wall-time shift (+7.78%, with a 10.01% spread between control copies), so its observed whole-time delta is not a reliable standalone wall-time claim. Its publication and retired-instruction reductions are recorded separately. SQLite and configured Lua whole-time differences lie inside their A/A copy ranges; **no ordinary-corpus speedup or regression is claimed**. Lua's publication stage lasts only 4–6 microseconds, close to the report's one-microsecond resolution, so its relative stage percentages are not meaningful.

These measurements use one code placement per build and two fresh physical copies per variant. They establish this workload/host result, not a cold-cache, multicore or universal speedup. The A/A results and raw per-copy ranges are retained rather than treating every small delta as an algorithmic effect.

## Assembly

The baseline's plan is inlined into `check_data_emit`: its value loop at `0x8e1891`–`0x8e18ec` still iterates once per bit, and its clear loop at `0x8e173c`–`0x8e175a` does too. The host compiler did not eliminate the work. In the candidate, it outlines `check_data_plan_object` and the 218-byte value helper, and combines runs of eight whole bytes into bounded 64-bit stores. The scalar planner is unchanged in size (0x2975 bytes). The disassemblies retain these decisions; the comparisons charge their effects.

This change keeps a small scalar operation because each accepted value affects at most 17 contiguous bytes and overlap resolution retains source order. It does not introduce a SIMD or multicore speedup claim. Measurements below concern the complete available publication path and the whole compiler, including preparation and memory costs.

## Reproduction

Check out the two named Buster commits in directories named `base` and `head` beside a directory named `evidence` containing this record. Build each under the shared 9700X lock. Compile and run `generate.c` to populate `evidence/inputs/`; place the external sources/headers at the paths in `cases.sh` and verify their recorded hashes. Then run `qualify.sh` under the shared lock and `queue.sh` outside it (the queue takes that lock for each bounded experiment). Compile `summarize.c` with `clang -std=c17 -O2 -Wall -Wextra -Werror` and run it as `summarize logs 1`. Completion markers apply only to the immutable recorded campaign; remove them when changing binaries, inputs or configuration.

For the focused tests, compile `focused.c` with `-O3 -march=native -I BUSTER/src -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror -Wno-unused-function -lm -ldl`. `sanitize.sh BUSTER OUTPUT` extracts the actual helpers and independent guarded test from the pinned source and runs ASan/UBSan.

All implementation, fixture, generator and measurement glue here is original project material under Apache-2.0 WITH LLVM-exception. Clang is an external acceptance/object-byte oracle; no Clang implementation or external fixture source is incorporated.
