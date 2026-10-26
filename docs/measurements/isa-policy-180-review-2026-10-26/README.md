# ISA policy review follow-up — issue 180 / PR 421

Qualification in progress. This report addresses review
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
[full sanitizer build](raw/final-asan-build.log) complete at 86. All42 ordinary
units compile. Observed normal/sanitizer durations are 28.5/52.1 s; main598's
normal build is 28.4 s. These single observations are build receipts, not
controlled build-throughput acceptance. The original reviewed C sanitizer
adapter appends `-O1 -fsanitize=address,undefined -fno-omit-frame-pointer -fno-sanitize-recover=all`
after ordinary flags. Source SHA256:
`2b68184e7c9af24f29ba2dad24be045812e1fb42d56660b942f07483d2261dc6`;
binary SHA256:
`6c336080f6d472e383767c4c84a131c4eb2b79a7bbe3d3c3d72c1aadeeafb8df`.
The final source/archive→image manifest and 42-unit flag receipt are pending.

Fresh [normal target](raw/final-target.log) and
[sanitizer target](raw/final-asan-target.log) each pass:

- 50,112 complete template entries, including both byte/layout/fixup halves.
- 513 feature configurations, target/output overlap, unaligned buffers,
  sentinels, raw/reserved bits and negative first-failure checks.
- 434 cached matcher configurations against uncached syntax plus scalar ISA eligibility.
- Every 16-bit encoded form value at all six profiles;7,872 randomized admitted records.
- 396 FMA forms across 1,272 relevant feature subsets.
- Native CPUID `0x1fffffffffffffff`, Zen 5 recognition and synthetic OS/XCR0 negatives.
- 708 Clang/GCC feature checks, 26 complete Clang preambles and 11 bounded
  builtin-query/option/tuning fixtures.
- 17,577 GNU as comparisons, with 144 explicitly counted external AVX512VL/FMA
  oracle gaps rather than a loosened policy.
- Baseline/v3/v4 each audit all 1,960 Tier0 templates and 96 functions/26,448
  records with zero depth refusals; both Tier1 covers and allocators pass.
- Native SSE/VEX/EVEX cases emit 40/40/41 bytes, execute and match the oracle;
  lower-profile instructions are rejected before encoding.

Fresh [normal assembler](raw/final-assembler.log) and
[sanitizer assembler](raw/final-asan-assembler.log) each pass **1,882,483 checks,
zero failures**, including all 16 GCC/Clang O0/O2 Intel/AT&T ordinary and
separate-section GNU object, execution and unwind cases. Sanitizer runs enable
leak detection and halt on either sanitizer error.

The earlier [wrong-directory invocation](raw/shared-assembler-wrong-cwd.log)
could not find the source of its 16 external cases. The corrected 333 invocation
passed; final86 then passed both complete suites. The failed invocation
qualifies no corpus and is retained as a failure.

Final-source projection compile controls, six frozen C-corpus runs and fresh
generated-program artifact audits are pending at this checkpoint.

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
fields and confirms final normal/sanitizer suite receipts. Final evidence
review is ongoing; source review does not approve a performance cost.

## Final repeated table and assembler measurements

[Raw 15-round campaign](raw/ab-final-table-assembler-15rounds.log);
[all values, ranges and paired directions](raw/final-15round-summary.json).
Actual normal optimized main598/final86 images, 60 child processes:
15 per image/configuration. Table construction follows 100 ms of predefines
work; the ordinary two-path assembler uses 21 timed passes per process.

| Quantity | Base median | Final median | Change | Paired lower / higher / equal |
| --- | ---: | ---: | ---: | ---: |
| Table after predefines | 411 ns | 160 ns | -61.071% | 15 / 0 / 0 |
| Cold assembler initialization | 0.716 ms | 0.703 ms | -1.816% | 12 / 3 / 0 |
| Warm scalar assembly | 3.690 ms | 3.500 ms | -5.149% | 15 / 0 / 0 |
| Warm vector assembly | 1.464 ms | 1.467 ms | +0.205% | 6 / 8 / 1 |

The previous scalar-assembly regression is reversed in every paired round
against the new frozen baseline. Table construction improves in every pair.
Cold init ranges overlap and are bimodal (base 0.651–0.803 ms,
final 0.545–0.762 ms); the median is not a uniform gain. Vector ranges overlap
(1.459–1.495 / 1.450–1.511 ms) with mixed directions. Its positive point
estimate is explicit and unapproved; this is neither a vector gain nor
proof of uniform neutrality.

The five-round whole-driver campaign, three-round hot-path campaign and
three-round assembler instruction-count control are running. No preliminary
whole-driver value is presented as acceptance.

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
13,632→15,528 KiB (+1,896 KiB). This remains an unapproved observation.

## Commands and ownership boundary

Frozen host directories share prefix
`/home/david/buster-fast-bench/codex-180-review-20261026-`:
main is 598, final/final-asan are 86, sized is 1a02, shared is 333, alias is 8fced
and loop is e1. Archives remain frozen after builds. The final C controller
is main598's compiler, outside an outer lock:

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

Remaining acceptance: finish/review final evidence, and fix remaining costs
or obtain the user's explicit exception. Correctness CI, historical timings
and separate wins do not waive the original limits. Keep draft and unmerged.
