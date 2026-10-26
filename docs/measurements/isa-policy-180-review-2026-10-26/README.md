# ISA policy review follow-up — issue 180 / PR 421

Source fixes, final functional qualification and measured comparisons are complete.
Independent source and final evidence review are complete; findings are addressed.
This report addresses review
[5652658592](https://github.com/buster14a/buster/pull/421#pullrequestreview-5652658592)
by source changes and new measurements; it does not infer approval of a cost.
The PR remains draft, open and unmerged. The
[previous campaign](../isa-policy-180-optimization-2026-10-26/README.md) belongs
to its recorded ad08/551 revisions and remains historical.

## Frozen revisions

| Role | Revision | Tree |
| --- | --- | --- |
| Previous main attribution control | `55141e0a19e8143a76e72ae1593fd99b0d4b2c32` | `1f16b7d4f5cbcea6c91a6ea26ad4d36d01b3d19e` |
| Previous reviewed PR | `ad08d9404663412c5de544653b8a81dee2261ddb` | `7c5346c97194747b3c775731f534a5a9a1e29160` |
| Isolated fixture routing fix | `01370443dd3c72dbf8ca880be5f234fc91a371cf` | `9bb6d8760c5d0ed88a74b76df5eb0ea851dbbb6d` |
| Current-main baseline | `598f3fb1a8b65926de53ee260ac6d5c3b58e9d05` | `2d4c638b24deccb2e8ec8e648b52252f23a14097` |
| Normal composition with main | `40d9e7b48d5ac9f809f9a879fd6a11c51b348870` | `f44d9ee8166238e5a1737d35abe4c76eb690aa79` |
| Scalar sizing control | `1a02c486950df6dcdc3c86fae073088df398b9cc` | `8b22f2f50a9004b83ac8e8de4c65376dbd421157` |
| Shared immutable-table checkpoint | `33362346129e38cd9d8319c0ea6954a5aad17544` | `904d38642c072c041dc1710f38ae577e3ebbe791` |
| Unretained restrict-helper experiment | `8fced8d112837115d889c9e64296f73355cf0c03` | `b6c6661d4ce656f25f7cd897ea9b482fc11a24df` |
| Independent row-loop checkpoint | `e1f2cdfaa8250400bc3ceaabbc877af70c011df3` | `42c79fd43909080a8b78d644f66bbd101a70a451` |
| **Final directly qualified source** | **`86a9bbdc58370706604f77794d4561e10febe4d3`** | **`ff394cd5bb5e1add2bd075ab18f3fb415e971925`** |

The sole writer uses `codex/180-isa-policy-completion`. The resumed
[claim](https://github.com/buster14a/buster/issues/180#issuecomment-6417218172),
[routing scope](https://github.com/buster14a/buster/issues/180#issuecomment-6417614491),
[scalar sizing scope](https://github.com/buster14a/buster/issues/180#issuecomment-6417882029)
and [immutable table scope](https://github.com/buster14a/buster/issues/180#issuecomment-6418198860)
are explicit. The previous #233/#234 claims were checked live and released.
No Tier 0/Tier 1/preprocessor producer, assembler parser, allocator/global THP
or merge ownership is taken. The cold-builder-sharing prototype was parked
without a retained source change or execution claim.

## Protocol

All compiler/helper builds, executions, tests and measurements use the approved
Ryzen 7 9700X (`benchpress`), through the ordinary shared
`~/buster-fast-bench/exclusive.sh` separately per run. Timings use CPU 2.
AB controllers run outside an outer lock and acquire it per child. No
reservation, bypass, competing measurement or CI cancellation is used.
Local work is source/Git/static inspection. The new local FIFO `cores` queue
was consulted; current AGENTS also queues single-threaded runs beyond about
30 seconds. No local compiler execution or multicore campaign was used.

Source archives are exact Git trees, each in a new frozen host directory.
The compiler uses its normal `BUSTER_DEBUG_INFO=0 ./build.sh`, including the
installed default Wild linker. No Python or new dependency is added.

## Demonstrated duplication and routing correction

[All symbols](raw/all-symbols.txt) and the
[function deltas](raw/function-size-deltas.tsv) compare frozen 551/ad08 images.
Function sizes sum to 17,448,759 and 17,873,872 bytes (+425,113); this is not
identical to the .text difference because .text includes padding and other
bytes. BACKEND alone grows 424,325 function bytes. It gains 157 private
`pp_`/`predefines_`/`refine_` functions totaling 376,475 bytes after the complete
target command moved there. The assembler parser and matcher hot functions
retain their earlier sizes; that observation alone does not prove identical
runtime or address layout.

`0137044` keeps the complete command and selector/encoder state in BACKEND,
as #424 requires, and calls macro/preprocessor fixtures in their FRONTEND
home. The [new census](raw/routed-image-census.txt) and
[routing deltas](raw/routing-function-deltas.tsv) show all 157 duplicate
helpers removed. Executable bytes fall from 33,765,532 to 33,281,882
(-483,650); .text falls from 18,775,797 to 18,389,894 (-385,903).
These are isolated checkpoint results, not final-head totals. Against the old
551 baseline this checkpoint still costs 65,672 executable bytes and 43,424
.text bytes; neither is silently accepted.

## Final source changes

Both matcher candidates retain complete `x86_validate` checks. Scalar sizing
now calls `encode_one` after acceptance, avoiding the checked wrapper's identical
second validation. There is no record mutation between validation and sizing.
The catalogue's found scalar requests compare selected/direct/checked lengths,
require a positive checked result, bound comparisons to 15 bytes, compare every
emitted byte and require nonzero coverage. Malformed operands, selected-record
scalar/vector comparison, ISA negatives and external GAS checks remain.
The catalogue coverage does not imply coverage of every arbitrary record.

Main units share one hidden, aligned, immutable full64/compact32 requirement
pair. Standalone inclusions retain static tables. Canonical rows and projection
assertions remain unchanged; assertions also remain active in declaration-only
units. The linked home pair is LOCAL HIDDEN in read-only .rodata and both
objects are 64-byte aligned. Two standalone compact copies remain.

Named requirements occupy **167,040 bytes**: one full64 and three compact32
tables. Main598 has six full64 copies (400,896 bytes); pre-sharing1a02 has
three full64 and six compact32 copies (also 400,896). The final reduction
against either is **233,856 bytes**, with different copy compositions.
[Exact extraction commands](raw/table-byte-commands.txt) and
[byte results](raw/table-bytes-result.txt) compare all 17 complete copies
across 1a02/333/e1 (734,976 bytes) with the frozen 1a02 reference:
full64 SHA256 `c35d7b55c598adba85606f3b0cef65ca2b4687019d49aeaaa73cb28b881bec45`,
compact32 `1fb85ef113d8d2c59e3ccc76725caef1a26f6ad1fd61b29d6a821febdf302693`.
These are linked bytes. Final86 is byte-identical to the inspected e1 normal
optimized image.

External declarations hid initializers from other units; Clang then emitted
an alias-range guard and scalar fallback. The actual scalar benchmark body
grew 507→828 bytes. A restrict-helper experiment built and passed tests but
did not improve code generation, and was removed. The retained scalar loop
states independent row iterations with `vectorize(assume_safety)`: immutable
global requirements cannot legally alias writable output, every iteration
writes its own byte, and target features are captured first. Public target/
output overlap remains valid and is tested exactly. The final
[scalar body](raw/loop-scalar.disasm) is 507 bytes and
[vector body](raw/loop-vector.disasm) remains 401 bytes; the
[shared control](raw/shared-scalar-alias-check.disasm) preserves the 828-byte
rejected result. These are local static inspections of host binaries with
verified hashes, not local performance executions.

The forced hint is omitted only during ASan/UBSan compilation. The failed e1
O1 sanitizer attempt diagnosed unavailable forced vectorization under Werror;
[its log](raw/loop-asan-forced-build-failed.log) qualifies no executable.
Final86 retains full instrumentation and the same scalar predicate.
Clang documents the [independence annotation](https://clang.llvm.org/docs/DiagnosticsReference.html#rpass-analysis)
and [sanitizer feature check](https://clang.llvm.org/docs/AddressSanitizer.html#conditional-compilation-with-has-feature-address-sanitizer).
There is no runtime CPU fallback.

## Final functional qualification

[Normal build](raw/final-build.log) and
[full sanitizer build](raw/final-asan-build.log) complete at 86. All 42 ordinary
units compile. Observed normal/sanitizer durations are 28.5/52.1 s; main598's
normal build is 28.4 s. These single observations are build receipts, not
controlled build-throughput acceptance. The original reviewed C sanitizer
adapter appends `-O1 -fsanitize=address,undefined -fno-omit-frame-pointer -fno-sanitize-recover=all`
after ordinary flags. Source SHA256:
`2b68184e7c9af24f29ba2dad24be045812e1fb42d56660b942f07483d2261dc6`;
binary SHA256:
`6c336080f6d472e383767c4c84a131c4eb2b79a7bbe3d3c3d72c1aadeeafb8df`.
[Host provenance](raw/final-host-provenance.log), expected source manifests
([main: 474 files](raw/main-source-files.sha256), [final: 477 files](raw/final-source-files.sha256))
and full host checks ([main](raw/manifest-main.log), [final](raw/manifest-final.log),
[final-ASan](raw/manifest-final-asan.log)) bind both frozen source directories.
All hashes match the expected clean Git source/build.sh path sets.
The [instrumentation summary](raw/final-instrumentation-summary.json) checks 42
unique entries per image: normal builds end in -O3; every sanitizer entry ends
in -O1 and contains all three instrumentation/frame/recovery flags.
The untouched [main](raw/main-compile-commands.json),
[final](raw/final-compile-commands.json) and
[ASan](raw/final-asan-compile-commands.json) receipts are Clang -MJ comma-terminated
object fragments; analysis removes the final trailing comma, then wraps the
fragments in an array. The original receipts are not JSON arrays. Final ASan image SHA256 is
`e7d6bdf06475fae1662b68a6557bfb9f5318900435fd830b7769a7a4afc8a978`.
The recorded tools are Clang 23.1.1, GCC 16.2.1 and the installed Wild version.

Fresh [normal target](raw/final-target.log) and
[sanitizer target](raw/final-asan-target.log) each pass:

- 50,112 complete template entries, including both byte/layout/fixup halves.
- 513 feature configurations, target/output overlap, unaligned buffers,
  sentinels, raw/reserved bits and negative first-failure checks.
- 434 cached matcher configurations against uncached syntax plus scalar ISA eligibility.
- Every 16-bit encoded form value at all six profiles; 7,872 randomized admitted records.
- 396 FMA forms across 1,272 relevant feature subsets.
- Native CPUID `0x1fffffffffffffff`, Zen 5 recognition and synthetic OS/XCR0 negatives.
- 708 Clang/GCC feature checks and 26 complete Clang preambles.
- 12 builtin-query/option/tuning fixtures: six profile queries, one ordering/
  tuning case and five invalid options. The query table contains 11 builtin names.
- 17,577 GNU as comparisons, with 144 explicitly counted external AVX512VL/FMA
  oracle gaps rather than a loosened policy.
- Baseline/v3/v4 each audit all 1,960 Tier 0 templates and 96 functions/26,448
  records with zero depth refusals; both Tier 1 covers and allocators pass.
- Native SSE/VEX/EVEX cases emit 40/40/41 bytes, execute and match the oracle;
  VEX/EVEX records are rejected under lower ISA profiles before encoding.

Fresh [normal assembler](raw/final-assembler.log) and
[sanitizer assembler](raw/final-asan-assembler.log) each pass **1,882,483 checks,
zero failures**, including all 16 GCC/Clang O0/O2 Intel/AT&T ordinary and
separate-section GNU object, execution and unwind cases. Sanitizer runs enable
leak detection and halt on either sanitizer error.

The earlier [wrong-directory invocation](raw/shared-assembler-wrong-cwd.log)
could not find the source of its 16 external cases. The corrected 333 invocation
passed; final86 then passed both complete suites. The failed invocation
qualifies no corpus and is retained as a failure.

Final-source [definition positive](raw/projection-definition-positive.log) and
[declaration positive](raw/projection-declaration-positive.log) compile controls
return 0. Their [definition negative](raw/projection-definition-negative.log) and
[declaration negative](raw/projection-declaration-negative.log) each return 1
at the actual production static assertion, with AVX512BF16 deliberately outside
the compact projection. Both fail for the intended guard, not missing includes
or unrelated syntax.

All six current-source corpus runs pass 220/220, with zero unsupported, failed
or not-run cases: [main baseline](raw/corpus-main-x86-64.log),
[main v3](raw/corpus-main-x86-64-v3.log), [main v4](raw/corpus-main-x86-64-v4.log),
[final baseline](raw/corpus-final-x86-64.log),
[final v3](raw/corpus-final-x86-64-v3.log), [final v4](raw/corpus-final-x86-64-v4.log).
They use c-testsuite `5c7275656d751de0e68b2d340a95b5681858ed07` and identical frozen
220-case subset SHA256 `cf2301d719f1377d91921faec7f888883abaedb75ea2577893c9731414b7d54c`.
The unchanged original C profile adapter injects the explicit target, while
cross-checks compare compiler paths, execute programs and test system linking.
This is not an ISA audit of every emitted corpus object.

The original C ELF auditor is rebuilt against final86, and its
[self-test](raw/audit-helper-selftest.log) passes baseline/VEX/EVEX positives,
lower-profile negatives, section gaps, truncated headers and bounds.
Fresh baseline/v3/v4 objects from both images pass all six audits
([final v4 receipt](raw/audit-final-x86-64-v4.log)). Each has 161 executable bytes/
50 instructions, exact independent scalar/vector decoder records, valid
operands and configured ISA eligibility; FNV1a64 `d384614d5b244074`.
Fresh executable builds and all six executions match a freshly compiled Clang
reference: 14213000051299467171. [Artifact provenance](raw/generated-artifact-provenance.log)
confirms all six object SHA256 values are
`cf0bc0708b9f00a4319c6d8701ac79c2fb9aaf0affa66ee8c6683176bfefa47d`,
and all six executable values are
`4a81f4d5c91b7409b59f7343b520d0bd661e8270cfc4b5c8cb8bcdac84668259`.
Linked text/data/BSS is 1,253/468/1 bytes each. GNU size's object 167-byte
"text" includes six non-executable read-only bytes; it is not 167 instruction
bytes. Fresh generation, decoder checks and executions establish deterministic
identity across both sources and the three profiles.

Generated runtime timing reuse is explicit: the exact linked hash matches the
[historically timed payload](https://github.com/buster14a/buster-performance/tree/85541498e98b254582c143bef3b5af49c098e611/docs/measurements/isa-policy-180-2026-10-25#generated-program-code-size-and-runtime).
That campaign has three paired processes/profile, 21 executions/image/process:
baseline medians 2.029/2.032 ms, v3 2.028/2.029 ms, v4 2.029/2.029 ms.
Those are historical observations of these exact bytes, **not fresh 86 timings**.
There is no newly generated instruction stream to qualify for this fixture.
No runtime speedup or broad runtime-neutrality claim is inferred.

Only Buster-produced executable sections are audited; foreign CRT/libc code is
outside that audit. Separate native SSE/VEX/EVEX fixtures force the optional
ISA levels; this unsigned-arithmetic runtime alone does not exercise them.

## CI and independent review

[Final-head CI 40350308402](https://github.com/buster14a/buster/actions/runs/40350308402)
passed **82/82** commands; [complete job receipt](raw/ci-40350308402-job-121668349776.log).
It compiled synthetic merge `47f3d1e58eb7b421240186ec3b221bbed054a66b`
(tree `ea12a7328ec03448494f66498b37f6da85b55f3f`) with integrated main
`ff8936bef4460465c827e8afd4221714d3d1c284`, distinct from manual main598.
The call/state gate reports 42 units, 23,685 functions, 140,496 calls, zero
unallowed cycles, three explicitly allowed cycles and zero split variables.
[Storage CI 40350308352](https://github.com/buster14a/buster/actions/runs/40350308352)
passed. The earlier 333 CI receipt remains historical.

A separate read-only reviewer inspected routing013, normal main composition,
sizing1a02, sharing333, the removed restrict helper, e1's independent loop and
final86's diagnostic-only guard at exact revisions. No actionable source
finding remains. Review covered mutable state homes, directory lifetime,
full matcher validation, checked/direct regression, linkage, visibility/
alignment, standalone fallback, future projection assertions, independence
and sanitizer feature names. No executions or source edits were performed
by that reviewer. The reviewer independently recomputes all 15-round summary
fields and confirms final normal/sanitizer suite receipts. Evidence
review independently recomputes every completed table/assembler/whole/hot
summary, including all 840 successful timed-child values and the retained
first-round C outliers. Final provenance/counter/artifact review also passes.
The [independent review receipt](independent-review.md) records its scope and
addressed findings. No review approves a performance cost.

## Final repeated table and assembler measurements

[Raw 15-round campaign](raw/ab-final-table-assembler-15rounds.log);
[all values, ranges and paired directions](raw/final-15round-summary.json).
Actual normal optimized main598/final86 images, 60 child processes:
15 per image/configuration. Each table process reports the median of 21
one-table timings, each preceded by 100 ms of predefines work outside its timer.
Cold initialization is one observation per process. Each warm assembler row
is the median of 21 interleaved passes of the ordinary two-path benchmark.

| Quantity | Base median | Final median | Change | Paired lower / higher / equal |
| --- | ---: | ---: | ---: | ---: |
| Table after predefines | 411 ns | 160 ns | -61.071% | 15 / 0 / 0 |
| Cold assembler initialization | 0.716 ms | 0.703 ms | -1.816% | 12 / 3 / 0 |
| Warm scalar assembly | 3.690 ms | 3.500 ms | -5.149% | 15 / 0 / 0 |
| Warm vector assembly | 1.464 ms | 1.467 ms | +0.205% | 6 / 8 / 1 |

The previous scalar-assembly regression is reversed in every paired round
against the new frozen baseline. Table construction improves in every pair.
Cold init observations vary and their ranges overlap (base 0.651–0.803 ms,
final 0.545–0.762 ms); the median is not a uniform gain. Vector ranges overlap
(1.459–1.495 / 1.450–1.511 ms) with mixed directions. Its positive point
estimate is explicit and unapproved; this is neither a vector gain nor
proof of uniform neutrality.

## Final whole-process comparisons

[Whole raw log](raw/ab-final-whole-5rounds.log) and
[all values/ranges/directions](raw/final-whole-summary.json): 40 AB children,
each with 21 timed subprocesses and the ordinary untimed warmup. All 840
timed subprocesses return 0; every driver and the AB footer report zero failures.
These are medians of five process medians, preserving all first-round outliers.

| Configuration | Wall ms, base→final | Change | Pairs lower/higher | Peak KiB, base→final | Minor faults, base→final |
| --- | ---: | ---: | ---: | ---: | ---: |
| One-function assembly | 1.389→1.278 | -7.991% | 5/0 | 14,912→15,524 | 175→185 |
| Verified short C object | 2.733→2.633 | -3.659% | 4/1 | 37,836→36,740 | 521→535 |
| Same C after 100 ms scalar work | 2.711→2.651 | -2.213% | 4/1 | 37,832→36,748 | 521→535 |
| Frozen SQLite checking | 147.760→147.983 | **+0.151%** | **0/5** | 597,404→596,280 | 1,446→1,460 |

Conditioning is outside child timers. Wall includes the whole spawned command;
peak is the independent median of child ru_maxrss values (KiB), not the RSS
of the median-wall child, a sum, or steady-state RSS.
All major faults are 0. Source/headers and complete options are frozen in raw
configuration headings; SQLite is syntax/type checking, not emitted SQLite code.

The SQLite process-median ranges are disjoint:
147.715–147.803 versus 147.856–148.141 ms. Individual child ranges overlap;
neither fact erases the five paired increases. The earlier SQLite regression
therefore persists at +.150920%. One-function peak RSS grows 612 KiB/+4.104% in
every pair. Its ranges 14,908–14,916 versus 15,520–15,576 KiB are disjoint.
Minor faults rise in every paired round of all four configurations.
These costs are unapproved. C/SQLite peak-memory decreases and other latency
gains do not offset them. The two short-C first-round head medians 2.889/3.149 ms
remain included; their gains are not uniform across pairs.

## Bulk kernels, backend and instruction controls

[Hot raw log](raw/ab-final-hot-3rounds.log) and
[complete summary](raw/final-hot-summary.json) cover 18 successful AB runs.
The bulk table protocol uses 21 trials of 10,000 tables/sample, distinct from
the one-table 15-round protocol.

| Quantity | Base→final | Change | Paired lower/higher/equal |
| --- | ---: | ---: | ---: |
| Plain scalar table, ns | 391.63→385.17 | -1.650% | 3/0/0 |
| Plain vector table, ns | 320.56→129.38 | -59.639% | 3/0/0 |
| Conditioned scalar table, ns | 439.74→418.60 | -4.807% | 3/0/0 |
| Conditioned vector table, ns | 411.81→131.22 | -68.136% | 3/0/0 |
| Tier 0 vector, ns/typed entry | 14.54→14.51 | -0.206% | 3/0/0 |
| Tier 0 scalar, ns/typed entry | 41.63→41.87 | **+0.577%** | **0/3/0** |
| Branch sizing, ns/typed entry | 1.11→1.11 | 0.000% | 1/0/2 |
| Encoding, ns/typed entry | 0.87→0.87 | 0.000% | 1/1/1 |

Every backend process has identical workload metadata: 2,008 functions,
262,874 entries, 303,116 records, 1,171,371 bytes and 9,414 deferred entries.
Vector timing ranges overlap. Scalar ranges 41.56–41.64 versus 41.76–41.93
do not overlap, and every pair rises; that +.576507% remains unapproved.
Reported instructions/entry are 169.82/571.32/12.62/17.78 at displayed two-decimal
precision, not a proof of exact instruction-count identity or a causal/
throttling explanation.

[Actual assembler command counters](raw/ab-final-assembler-instructions-3rounds.log)
and [counter summary](raw/final-counter-summary.json) use three rotating pairs
under perf, which reports 100.00% running; --no-scale preserves raw counts.
For 2,048 functions/79,872 instructions, both paths warm up on pass 0 and the
scalar path runs 21 timed passes. Median retired user instructions fall
19,509,208,105→18,315,174,427 (-6.120%, all three pairs lower).
This includes startup, generation, both warmups, validation, object writing
and all timed passes; it is not a counter isolated to matching/sizing or the
256-function timing workload. No nested counter user is wrapped.

The [additional SQLite counter control](raw/sqlite-instructions-3rounds.log)
measures the same checking command in three separate pairs:
instructions 1,713,352,364→1,713,302,849 (-.002890%, all three lower),
cycles 679,634,850→680,103,063 (+.068892%, one lower/two higher).
All counter samples report 100.00% running. These are different samples from the
five-round wall campaign, and do not reverse its +.151% result or establish a
cause for it.

The original standalone C [policy counter control](raw/policy-counter-3rounds.log)
is rebuilt against each frozen source. Across three rotating pairs, scalar
instructions/table stay 6367.0219; vector counts fall 6803.0217→2802.0215
(-58.812%, all three lower). Each process checks scalar/vector equality and
21 rotating passes; counter unavailability/multiplexing fails rather than
becoming zero. This is an isolated same-source control, not the production
executable or its linking/data-ownership context, and its ns values are not
acceptance substitutes. Its printed 66,816 requirement bytes mean only the
full64 reference, not combined requirement storage.


## Footprint and remaining acceptance

Final86 normal compiler SHA256:
`957e97c75598cb90a0813ab57b2280f6b7165d2b0ff9271885502788210e7e72`.
It matches the e1 screening image exactly; the final sanitizer guard does
not change the optimized image. Main598 SHA256:
`54b639e1e223c26cf47e1be374a481829150e294454289910e0a58772b760cbc`.

| Bytes | Main598 | Final86 | Difference |
| --- | ---: | ---: | ---: |
| Executable file | 33,597,069 | 33,429,949 | -167,120 |
| .text | 18,665,082 | 18,709,898 | +44,816 |
| .rodata | 3,329,110 | 3,108,883 | -220,227 |
| .data.rel.ro | 10,822,656 | 10,826,032 | +3,376 |
| .bss (virtual) | 241,362,209 | 237,669,729 | -3,692,480 |
| Named requirement tables | 400,896 | 167,040 | -233,856 |

[Final static image census](raw/final-static-image-census.txt) records the
byte-identical e1/final86 artifact. The full [symbols](raw/final-all-symbols.txt)
and [function deltas](raw/final-function-deltas.tsv) compare it with frozen
main598. Defined FUNC bytes sum to 17,745,995→17,790,488 (+44,493), versus
.text +44,816 including padding/other bytes. The two target test entry points
and their new frontend fixture bridge grow by 34,811 bytes combined; the
assembler test entry adds 86. That is a partial attribution, not a claim that
every remaining byte is production code or that these test costs are accepted.

The .text increase remains unapproved despite the smaller executable.
Virtual .bss does not cancel a physical RSS cost. The
[three-round screen](raw/ab-initial-3rounds.log) is preliminary and includes
333/e1 checkpoints; final86 matches e1 but its final whole-driver campaign
is separate. One-function assembly in that screen has median RSS
13,632→15,528 KiB (+1,896 KiB). The screen remains preliminary; the final five-round result above is the
current comparison. Both observed memory costs remain visible, with their
separate sampling contexts.

## Commands and ownership boundary

Frozen host directories share prefix
`/home/david/buster-fast-bench/codex-180-review-20261026-`:
main is 598, final/final-asan are 86, sized is 1a02, shared is 333, alias is 8fced
and loop is e1. Archives remain frozen after builds. [Exact commands and statuses](raw/final-commands-and-status.json) preserve all
four actual performance campaigns, final functional commands, the post-campaign
fixtures/counters and the artifact snapshot. [Post-campaign commands](raw/post-campaign-commands.txt)
and [46 expected statuses](raw/post-campaign-results.json) distinguish the two
intentional compile failures from passing commands.
The final C controller is main598's compiler, outside an outer lock:

```sh
EXCLUSIVE_OWNER=codex-180-review EXCLUSIVE_TITLE="PR421 final table/assembler 598/86" \
EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/421 LC_ALL=C \
./build/compiler ab --rounds 15 --cpu 2 --lock /home/david/buster-fast-bench/exclusive.sh \
  ../codex-180-review-20261026-main ../codex-180-review-20261026-final \
  -- benchmark-x86-target --only avx512 --after-predefines 100 --iterations 1 \
  -- benchmark-assembler
```

Expanded configuration headers in all AB logs preserve arguments. Functional
commands run from the respective frozen checkout, each separately:

```sh
EXCLUSIVE_OWNER=codex-180-review EXCLUSIVE_TITLE="PR421 final target at 86a9bbd" \
EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/421 \
/home/david/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler test-x86-target
```

The assembler command is `test-assembler --cross-check`.
Sanitizer commands add `env ASAN_OPTIONS=detect_leaks=1:halt_on_error=1 UBSAN_OPTIONS=halt_on_error=1`
before taskset.

This is a bounded slice of #180. The six profiles, host/target separation,
predefined macros, supported queries and independent tuning reuse existing
policy interfaces. Unknown forms remain denied. Producer integration via
`x86_target_forms`/`x86_target_validate` remains with #136/#133; future vector/
intrinsic lowering, complete builtin lowering and per-function targets remain
with their existing owners. #424 merged and released its claim; it is not an
active blocker here. Further encoder-storage redesign would be new scope,
not an outstanding fix promised by that owner.

Remaining acceptance: fix the observed SQLite/scalar-backend/vector-assembly
point estimates, assembly RSS, minor-fault and .text costs, or obtain the user's
explicit exception. The vector-assembly estimate has mixed directions;
SQLite/scalar-backend/RSS have consistently higher paired results. Causes of
the residual latency/memory differences have not been independently established.
Correctness CI, historical timings and separate wins do not waive the original
limits. Keep draft and unmerged.
