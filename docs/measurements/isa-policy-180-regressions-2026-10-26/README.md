# PR421 remaining-performance fixes

Current compiler head is 597ee55, pushed to draft PR421. Leave it open/unmerged.
No performance exception is requested or accepted. Native qualification, local
sanitizers and fresh changed-head CI pass. Six-round controls are complete;
encoding remains unapproved. Direct-policy and matched-invocation follow-up
are complete. A simple function-alignment prototype is rejected for selection
costs; a dedicated-section prototype is still unpublished and being qualified.
Completed c051 controls and every exploratory result remain separate campaigns.

## Frozen sources and images

| Role | Source commit | Tree |
| --- | --- | --- |
| Frozen main | 35f26f68d7caa9bf5f6248822100a51c06e2c878 | 4687d54d63d0edd4cfd3c3db9e2180c9691d0fb8 |
| Main plus previous PR implementation | fb4a01fde21b339a81c20e0dc4aa20f446829911 | 2db67ecdb710aa208dfc3519d263a52562e5e8c9 |
| Constructor-only control | c0cc199a7e601ecbeb537d8429fc3b23afb300ec | edaf0db06401ad02eba7c9d5e7ff428d084e24d0 |
| Rejected shared-descriptor candidate | 8cde401861c4a5b5cc9d80b8df21f04e9312eefe | 3e5255568d0e2cbf4e6e701964edd3badaecce3c |
| Previous caller-table candidate | c051292af035c9a957158fcd8c20a2d50d1e3839 | 1de637e4626eca8eda071cad57c800481a5e42b9 |
| Current hybrid candidate | 597ee55a09f9257a22ba62be9f4e9940692a4929 | eea4aadc698e343720850838896892ae421149fc |

The published pre-follow-up head is 86a9bbdc58370706604f77794d4561e10febe4d3.
Its [previous qualification](../isa-policy-180-review-2026-10-26/README.md)
remains historical; its 598 baseline is not relabeled as this campaign's main35.

Every 9700X build, functional test, benchmark, counter run and artifact census
uses ordinary exclusive.sh per run, with owner/title/PR link. Timings use CPU2.
No reservation, CI cancellation, host-setting change or outer campaign lock.
A single performance controller compares frozen images; queued functional and
read-only inspection jobs also take the lock, so host work never runs together.

Local diagnostics are explicitly separate: Ryzen 9 7940HS (Zen 4), Clang 23.1.4,
cores FIFO grants (four physical cores for the build, one per test), nice19.
The short single-threaded probe took under 30 seconds and used the documented queue
exemption, nice19 and idle I/O. Local diagnostics establish no 9700X timing result.

## Current implementation

Main units share pure nonlegacy template construction in the X86 home.
Default64/APX callers supply the immutable description table already used by
their consumer. Address32 has an explicit canonical-home-table path for its
forced writer adapter, avoiding retention of otherwise unused caller tables.
The choice is outside the form loop. Caller template storage/readiness and
legacy properties remain private. No storage, guard, gap, alignment, allocator,
encoder-loop, instruction-format, producer, preprocessor or tuning change.

The original row arithmetic is factored into an always-inlined value helper.
The constructor requires descriptions/output to be disjoint. Unsupported modes
and missing required descriptors return false without writes. Address32 accepts
both supplied and canonical tables.

The owned fixture compares 250,560 complete 64-byte entries across four cases:
default64, supplied address32, APX and canonical address32, including raw/fixup
halves, unavailable rows, fallback rows and segment variants. A separate metadata
copy's NOP 0x90-to-0x91 change must appear in output while the global catalogue stays 0x90.
Outputs are dirty and deliberately unaligned; prefix/suffix/gap sentinels and
null-metadata refusal cases are checked. Bulk and private per-form construction
share a pure body, so the independent frozen five-mode dump remains the
before/after semantic boundary.

X86Instruction stays 16 bytes. Existing eligibility, matching and record-policy
interfaces remain intact.

597 retains static descriptions in DRIVER, ASSEMBLER, BACKEND and CHECKER,
including the C source pipeline's actual physical copy. Other main units share
X86's hidden immutable catalogue; standalone units retain static catalogues.
This removes four otherwise retained cold-unit tables. Mutable template
storage, readiness and legacy properties stay local, with no initialization or
allocation added. The initializer contents and description representation are
unchanged.

## Previous c051 qualification

The corrected c051 9700X build, complete target/assembler suites, all five
encoder modes and the call/state graph pass. The graph reports 42 units,
23,845 functions, 141,528 calls, zero unallowed cycles, three existing allowed
cycles and zero split variables. Current five-mode dump generation passes;
the exact-length, full-byte comparison and source-provenance inspection also pass.

The complete local ASan/UBSan build passes 42 units. All seven local suites pass:
target, assembler cross-check, default64/address32/APX/32-bit/16-bit encoder.
Both complete target runs include 250,560 entry comparisons, 513 feature
configurations, 434 cached admissions, all 65,536 form values at six profiles,
independent FMA negatives, live CPUID/macros, 708 Clang/GCC checks, 26 complete
Clang preambles, baseline/v3/v4 selection/native kernels and 17,577 GAS checks
with 144 explicit external oracle gaps. Both assembler receipts pass
1,882,483 checks with zero failures.

The [local instrumentation summary](raw/local-c051-asan-summary.json) verifies
42 unique compile entries, each ending in -O1 with address/undefined sanitizers,
frame pointers and no recovery. All 481 expected source files match.
Leak detection and halt-on-error are enabled. Native identity/predefine tests
also pass on this Zen4 diagnostic host; no older-host production fallback was
introduced.

Local sanitizer image SHA256:
b71955ebcb12ef047c6caac80b286ec88978f38527c5578a1cf2478fca2e799d.
9700X current image SHA256:
86f3a88fca7d0097fd38208744b0a28796f81d78f9a6b1e7b15d887b2da00b03.
The byte oracle [template-dump.c](template-dump.c) uses exclusive creation,
requires all five initializers to succeed and writes 16,035,840 bytes.
Both composed and c051 dumps have that exact length and match byte for byte,
SHA256 a7672bd6a6c4796f780d5a9c274b6c68a46889e77d1595df2ce665e82d4d6cd7.
The [provenance summary](raw/caller-fixed-provenance-summary.json) checks all
481 native source hashes and 42 distinct native compile records ending in -O3,
without debug info or sanitizers. Original -MJ records remain in the raw receipt.

[9700X CI 40422280997](https://github.com/buster14a/buster/actions/runs/40422280997)
passes all 82 test commands and every selected benchmark.
It checked merge 433ccce1558c6b1e9899fffdb85f4eb8c7331944, c051 into
6b2c92268802e72d76cdcd06e21e80a2bef90e22. That integration revision is distinct
from frozen manual main35. The [raw job log](raw/ci-40422280997-test.log) and
[job/revision summary](raw/ci-40422280997-summary.json) preserve that boundary.
Hosted measurement-storage CI 40422281063 also passes. CI correctness and its
informational timings do not replace controlled performance acceptance.
Raw logs preserve original whitespace, including GitHub timestamp-only lines;
unfiltered diff whitespace checks report those lines. Source/docs/list whitespace
checks exclude raw receipts, whose byte hashes remain unchanged.

## Previous c051 static footprint

These are actual ordinary-Wild 9700X images from the
[locked census](raw/caller-fixed-size.log), not source-size estimates.

| Bytes | Main35 | Composed fb4 | Constructor-only c0 | Current c051 |
| --- | ---: | ---: | ---: | ---: |
| File | 33,956,472 | 33,785,800 | 32,736,027 | 32,736,372 |
| .text | 18,981,962 | 19,023,226 | 18,978,698 | 18,978,906 |
| .rodata | 3,358,058 | 3,137,831 | 3,137,276 | 3,137,313 |
| .data.rel.ro | 10,828,272 | 10,831,648 | 9,829,408 | 9,829,408 |
| .bss | 241,442,465 | 237,749,985 | 237,749,985 | 237,749,985 |

Current versus main: file -1,220,100 bytes, .text -3,056 bytes.
Versus composed: file -1,049,428 bytes, .text -44,320 bytes.
Versus constructor-only: file +345, .text +208, .rodata +37; .data.rel.ro and
BSS extent unchanged. These intermediate costs are recorded alongside the
actual main comparison.

The current image retains 24 descriptor arrays (nine main-unit and 15 standalone),
8,017,920 descriptor bytes, matching c0. The forced-adapter retention concern
did not materialize after the canonical address32 refinement. BSS starts 384 bytes
later than c0. Assembler/checker default-table spans cover two PMD-sized address
regions each and backend spans cover three. Geometry is not physical-residency
or latency evidence. BSS is virtual zero-fill extent, not RSS.

## Previous c051 generated programs

The locked [functional suite](raw/current-generated-code.log) rebuilds the
existing C ELF auditor against c051, checks its ISA-negative/bounds self-test,
and generates the frozen unsigned-arithmetic fixture at baseline/v3/v4 with
both main35 and c051. All six cases pass. Each object's executable section is
161 bytes/50 decoded instructions; both scalar and vector decoders agree and
every record is admitted by the selected ISA. Every program prints
14213000051299467171, matching a freshly built Clang -O0 baseline reference.
Both compiler images and all three original helper-source hashes are checked
before execution. [Commands](raw/current-generated-code-command.json) and the
[artifact summary](raw/current-generated-code-summary.json) retain the identities.

All six complete objects are byte-identical, SHA256
cf0bc0708b9f00a4319c6d8701ac79c2fb9aaf0affa66ee8c6683176bfefa47d.
All six linked executables are byte-identical, SHA256
4a81f4d5c91b7409b59f7343b520d0bd661e8270cfc4b5c8cb8bcdac84668259.
This suite establishes no generated-code size or instruction-stream change
for this fixture. Its execution duration is a functional receipt, not a new
runtime benchmark or a broad generated-program runtime-neutrality claim.
Separate fresh target tests execute SSE/VEX/EVEX positives and lower-ISA negatives.

## Completed c051 screen and repeated controls

The [three-round actual-image screen](raw/caller-fixed-screen-3rounds.log)
completes successfully: 18 AB children, 378 timed children, all statuses zero,
six successful time-runs drivers and one AB success footer. The original C
reader verifies every child, command, median and range before producing the
[complete summary](raw/caller-fixed-screen-summary.json). Its ten local
[positive/negative/boundary checks](raw/screen-reader-validation.json) pass;
synthetic reader fixtures are not measurement samples.

| Measure | Main35 | c051 | Change | Pairs lower/higher/equal |
| --- | ---: | ---: | ---: | ---: |
| Assembler cold init, ms | 0.86 | 0.683 | -20.581% | 3/0/0 |
| Warm scalar assembly, ms | 3.723 | 3.363 | -9.670% | 3/0/0 |
| Warm vector assembly, ms | 1.47 | 1.377 | -6.327% | 3/0/0 |
| Backend vector, ns/entry | 14.49 | 14.5 | 0.069% | 1/2/0 |
| Backend scalar, ns/entry | 41.52 | 41.26 | -0.626% | 3/0/0 |
| Encoding, ns/entry | 0.88 | 0.89 | 1.136% | 0/2/1 |
| SQLite checking, ms | 146.724 | 147.448 | 0.493% | 0/3/0 |
| One-function assembly peak, KiB | 16860 | 14604 | -13.381% | 3/0/0 |

The separate [six-round C procbench control](raw/procbench-control-summary.json)
completes 1,584 timed children and 72 warmups. Every child exits zero; all
requested counters are positive with no multiplexing marker. All 54 backend
and 18 large-assembler captures, complete archives and compiler identities
pass the recorded checks. Its [pinned source/build](raw/procbench-source-and-build.json)
uses unmodified first-party C; its [plan](raw/procbench-control-plan.json) has
all six role permutations. Each archive contains inner TSV round 1; filenames
identify the six outer rounds. Treat the six round/list summaries as clusters,
not 1,584 independent image comparisons. Children run in command blocks.

Procbench wall time is release-to-wait4; its external counters start at exec
and include kernel and user, while resource usage includes child setup.
Backend inner counters exclude kernel/hypervisor and retain no enabled/running
times. The external harness records a multiplexing marker but not raw
enabled/running values. This is a distinct
protocol from time-runs; do not combine its absolute times with that screen.
A separate locked runtime-image identity snapshot at 08:20:44 UTC verifies the
two byte-identical 16,552-byte payloads. It is not a per-round runtime hash check.

Per-round baseline reference is the midpoint of the two identical-command
baseline medians. Across six rounds, medians use the midpoint of the central
pair. The controls retain costs: SQLite +0.415%, backend vector +0.328%, encoding +1.136% and backend peak RSS +2064 KiB, each higher in all six pairs. Scalar backend and assembly improve;
those gains do not waive these costs. Runtime samples exercise byte-identical
programs; their mixed timing differences are not a code-quality speedup claim.
All arrays and A/A differences remain in the summary. c051 is not accepted.

## Hybrid candidate 597ee55

The current published candidate is 597ee55a09f9257a22ba62be9f4e9940692a4929,
tree eea4aadc698e343720850838896892ae421149fc. It keeps static descriptions in
DRIVER/ASSEMBLER/BACKEND/CHECKER and shares other main-unit copies through X86.
The canonical symbol is hidden and Wild localizes it. Actual retention is five
main plus fifteen standalone tables, down from nine plus fifteen in c051.
The [census](raw/hybrid-static-summary.json) removes exactly 1,336,320 data.rel.ro
bytes (four 334,080-byte arrays); .text, .rodata, .eh_frame and BSS extent match
c051 exactly. File size is 31,399,868 bytes, 2,556,604 below frozen main; .text is
18,978,906 bytes, 3,056 below main. Backend storage intersects two PMD-sized
address regions, versus three in c051 and two in main. Geometry alone is not
resident-page or latency evidence.

Normal 42-unit build, all seven native suites, graph and complete five-mode
16,035,840-byte comparison pass. The full local ASan/UBSan build, all 42 final-O1
instrumentation records, 481 source hashes and seven diagnostic suites also
pass. Three freshly generated baseline/v3/v4 programs match the previous full
object/executable hashes and Clang result. The actual native compiler SHA256 is
52f569c36404f9ad25d431dbcd4b1bb16880e8ac41293d5f4c7067a8e930a7a1;
the separate local sanitizer image is
1b84706e81a6bb181d8d9f48148eb93b8bf014c6eeab2b36b20593f034130abb.
Native commands/statuses, all 481 source hashes, original 42 compile records,
full symbol tables and selected disassemblies are retained under raw/hybrid-*.
All linked FUNC symbol address/size/binding/visibility/section/name sequences
match c051. Five nonempty selected consumer disassemblies match after only
RIP-relative data displacements/comments are normalized. Both x86_validate
snapshots are empty (inlined/no emitted symbol); they establish no validation
code-generation equivalence. Independent source/receipt review found no
actionable production finding.

Fresh [9700X CI40483449001](https://github.com/buster14a/buster/actions/runs/40483449001)
passes 84/84 commands and every selected benchmark; measurement-storage
CI40483448916 also passes. Actual integration is
965f163c72a4097c30ceeca2af4b439f6b08de74, 597 into
51bf882baf051f2a208a8fdef697a23e257cb09a, distinct from manual main35.
Its graph reports 42 units/24,235 functions/143,757 calls/zero unallowed
cycles/three existing allowed cycles/zero split variables. The
[original decoded log](raw/ci-40483449001-test.log) is 1,055,731 bytes, SHA256
5f41e0bee55e6af736d78130be72498b2942af824928cd470e10c00894337f91.
[Exact job and revision metadata](raw/ci-40483449001-summary.json) retains the
boundary between integration CI, manual controls and local diagnostics.

The [three-image preliminary screen](raw/hybrid-prelim-summary.json) rotates
main/c051/597 through three cyclic orders, not all six permutations and not A/A.
All 792 timed children and 36 warmups exit zero, all captures validate, and
each round checks all three compiler and runtime hashes. This is a separate
preliminary period, not final acceptance or a pooled extension of c051 controls.

| Median of three round medians | Main35 | c051 | 597 | 597 versus main |
| --- | ---: | ---: | ---: | ---: |
| ASM1 wall, ms | 1.413852 | 1.287525 | 1.297714 | -8.214% |
| ASM1 peak RSS, KiB | 15,704 | 13,556 | 15,632 | -0.458% |
| SQLite wall, ms | 147.577671 | 147.565168 | 147.521706 | -0.038% |
| SQLite peak RSS, KiB | 596,296 | 596,188 | 596,164 | -0.022% |
| Short C wall, ms | 2.728829 | 2.682211 | 2.668606 | -2.207% |
| Short C peak RSS, KiB | 36,944 | 36,876 | 36,848 | -0.260% |
| Backend peak RSS, KiB | 413,664 | 415,680 | 413,644 | -0.005% |
| Backend vector, ns/entry | 14.49 | 14.55 | 14.50 | +0.069% |
| Backend scalar, ns/entry | 41.45 | 50.54 | 41.28 | -0.410% |
| Encoding, ns/entry | 0.88 | 0.87 | 0.88 | 0.000% |
| ASM2048 wall, ms | 707.134346 | 659.348390 | 697.091508 | -1.420% |
| ASM2048 peak RSS, KiB | 77,200 | 75,096 | 77,176 | -0.031% |
| ASM2048 instructions, kernel+user | 19,517,727,366 | 17,586,914,135 | 17,586,994,003 | -9.892% |
| Identical-program wall, ms | 1.938577 | 1.949437 | 1.952622 | +0.725% |

597 gives back 2,076 KiB of c051's ASM1 RSS saving and is 0.791% slower than
c051 on that workload, while remaining below main in both observations.
ASM2048 wall is 5.724% higher than c051 with mixed paired direction, and peak
RSS is 2,080 KiB higher. Backend RSS falls 2,036 KiB versus c051. SQL observations
in this period are near neutral for both candidates, so these data do not prove
the hybrid caused a SQL improvement. The unchanged c051 binary's scalar result
shifts from 41.255 ns in its earlier six controls to 50.54 ns here: cycles rise
from 228.645 to 280.08 per entry while displayed instructions stay 571.32.
Corpus and compiler/harness hashes match; no cause or algorithmic speedup is
inferred. Runtime payloads are byte-identical; timing offsets are not attributed
to generated code. All round-level arrays and directions remain in the summary.

The [final frozen six-round plan](raw/hybrid-control-plan.json) compares two
main roles against 597 in every permutation. It uses the same pinned C harness
and process protocol as c051 controls: CPU2, normal ASLR, 1,584 timed children,
72 warmups, 54 backend captures and 18 large-assembler captures. Each bounded
round takes and releases the ordinary shared lock. Per-round checks cover both
compiler images and both runtime images. The [execution status](raw/hybrid-control-status.json)
and [complete summary](raw/hybrid-control-summary.json) are separate from the
plan. Every child exits zero, all captures have empty stderr, every identity
matches, and independent recomputation reproduces all 72 metric series.

| Six-round medians | Main35 A/A reference | 597 | Change | Pairs lower/higher/equal |
| --- | ---: | ---: | ---: | ---: |
| ASM1 wall, ms | 1.41010275 | 1.2931255 | -8.296% | 6/0/0 |
| ASM1 peak RSS, KiB | 15,674 | 15,616 | -0.370% | 5/1/0 |
| ASM2048 cold initialization, ms | 0.84275 | 0.7775 | -7.743% | 6/0/0 |
| ASM2048 warm scalar, ms | 32.34075 | 29.0505 | -10.174% | 6/0/0 |
| ASM2048 whole wall, ms | 731.5320975 | 656.9894855 | -10.190% | 6/0/0 |
| ASM2048 peak RSS, KiB | 77,237 | 77,172 | -0.084% | 5/1/0 |
| SQLite checking, ms | 147.59704675 | 147.5139305 | -0.056% | 3/3/0 |
| SQLite peak RSS, KiB | 596,332 | 596,164 | -0.028% | 6/0/0 |
| Short C compilation, ms | 2.7353635 | 2.6649685 | -2.574% | 6/0/0 |
| Short C peak RSS, KiB | 36,949 | 36,840 | -0.295% | 6/0/0 |
| Backend vector, ns/entry | 14.495 | 14.490 | -0.034% | 4/2/0 |
| Backend scalar, ns/entry | 41.490 | 41.235 | -0.615% | 6/0/0 |
| Backend peak RSS, KiB | 413,649 | 413,648 | -0.0002% | 3/2/1 |
| Encoding, ns/entry | 0.875 | 0.885 | +1.143% | 1/5/0 |
| Encoding, cycles/entry | 4.845 | 4.905 | +1.238% | 1/5/0 |
| ASM2048 instructions, kernel+user | 19,517,766,903.75 | 17,586,972,539.5 | -9.892% | 6/0/0 |
| Identical-program wall, ms | 1.94246825 | 1.955363 | +0.664% | 1/5/0 |

Initialization is one cold observation per ASM2048 process, not its 21 warm
passes. Encoding's ns display is rounded to 0.01; four head observations exceed
both main medians, and five cycle observations do. Displayed instructions stay
17.78 in every process. This remains an unapproved observation, not a rounding
waiver. Runtime bytes remain identical; its positive offset is not an inferred
generated-code change. All A/A arrays, individual medians, ranges and paired
directions are retained. No performance acceptance is inferred from other wins.

The new [active-loop inspection](raw/hybrid-main-hotcode-command.json) reads
the actual backend x86_encode_16 (16-record batch, not 16-bit mode), measured
caller and counter boundary. x86_encode_64 was another batch variant. The
matched-invocation [probe plan](raw/context-control-plan.json) compares absolute
and identical relative executable names through the same existing env -C helper,
with normal ASLR and unchanged frozen binaries. The original C
[context fixture](context-check.c) verifies argv0, AT_EXECFN, inherited PWD and
the actual working directory before timing. This tests invocation-context
sensitivity; it does not isolate any one component or assume the explanation.
Outer wall/resources include env/chdir/extra exec and must not be pooled with
the earlier direct-exec protocol. Backend inner windows remain separate.

## Completed direct eligibility-table measurements

The [six-pair policy campaign](raw/hybrid-policy-summary.json) uses the existing
unmodified benchmark on the same main35/597 production images. All 24 process
statuses are zero, every captured stderr is empty, and every harness/input/image
identity matches. Independent recomputation reproduces all 24 summary metrics.
Each internal value is a median of 21 interleaved passes, 10,000 full
8,352-row znver5 tables per sample. The conditioned case performs 200 ms of
predefined-macro work before each variant/pass. These are synthetic table
construction observations, not whole-compilation speedups.

| Internal ns/table | Main35 | 597 | Latency change | Paired lower/higher |
| --- | ---: | ---: | ---: | ---: |
| Scalar reference, plain | 392.710 | 380.480 | -3.114% | 6/0 |
| SIMD, plain | 319.645 | 131.440 | -58.879% | 6/0 |
| Scalar reference, after predefines | 436.255 | 420.105 | -3.702% | 6/0 |
| SIMD, after predefines | 410.740 | 129.055 | -68.580% | 6/0 |

Scaled user cycles/table also decrease in all six internal comparisons.
No raw internal sample arrays or enabled/running values are retained. Plain
outer process wall time improves in five pairs and worsens in one; the all-six
claim applies to the internal kernel metrics. Cross-version eligibility tables
need not contain identical bytes because this PR adds correctly classified rows;
each version checks its own exact scalar/vector output before and after timing.

## Completed invocation-context investigation

The [context controls](raw/context-control-summary.json) finish all six frozen
rounds, 864 timed children and 36 warmups, every exit zero. All 108 backend
captures have empty stderr. Each round verifies the original and symlinked
compiler/runtime images, resolved paths and tool/input hashes. The independent
review reproduces all 56 metrics and five contrast series.

Relative invocation retains the encoding cost: 0.875 to 0.890 ns/entry
(+1.714%), and 4.8425 to 4.925 cycles/entry (+1.704%), higher in all six pairs;
all six cycle observations exceed both baseline medians. Absolute-context
aggregate medians reverse slightly, with larger mixed A/A variation. The
hypothesis did not remove the cost and no individual context component is
identified as its cause. Identical-program whole-wall medians are about 0.5%
lower in both contexts in this period; these are not a source/code-quality gain
or a pooled correction to the earlier positive offset.

Collection notifications used an obsolete hardcoded files=28 even though their
validation already required the actual 41 files. The original
[collection status](raw/context-control-status-collected.json) is preserved;
the corrected status records 41 and an explicit metadata erratum. Independent
review confirms 41 files per archive, reproduces the raw arithmetic, and verifies
that the collected-to-corrected status difference changes only metadata. The
writer records that the original validator already required 41 files.

## Rejected entry-alignment prototypes

Unpublished 6f5defc633100957d35738bd8fa636a00aae1ab4 (tree
f626422a9f3ab346d4c688d93b63bb968d109155) differs from 597 by only the comment
and aligned(64) annotation in [the source patch](prototype-align64.patch).
The separate DRIVER-sharing experiment ea33c47 is reverted in this tree and
not combined with it. Native build, eight suites, graph and exact complete
five-mode bytes pass. The local sanitizer artifact has 42 unique final-O1
ASan/UBSan records, 481 matching source hashes and eight successful suites;
its original build process exit receipt was unavailable after a tool-host
generation transition and is not invented as zero. The full log, linked
artifact provenance and test exit zero are retained separately.

The actual native compiler SHA256 is
1ddde1e430c4f5f99dc6e0417c82fc29a4d195fc579af5acd4a5ce2d8a3c2c50.
File size is 31,401,132 and .text 18,980,170 bytes, both 1,264 above 597 but
still below main. All 22 retained default kernels are 64-aligned. Independent
inspection confirms identical active-loop/caller/counter-reader instructions
after relocation normalization. Reproducing the exact backend compile shows
its ordinary input .text alignment changing from 16 to 64 and size increasing
by 32 bytes. This couples other functions to that section's placement; the
receipts do not establish Wild's sorting rule or the hardware cause.

The [complete three-round screen](raw/align64-triage-summary.json) retains all
54 successful processes in three cyclic source orders. Vector selection costs
14.500 to 14.900 ns/entry (+2.759%) directly and 14.450 to 14.900 (+3.114%)
under relative invocation, each three pairs higher. Scalar selection also
loses its earlier benefit; encoding is not fully resolved. The candidate is
rejected, with no performance exception or changed public PR head.

The next unpublished prototype is 3953bccd3402cded7382715729c74724d78ba737,
tree 89b1064f804440b2d6897d9da91311b244fc4998, shown in
[its source patch](prototype-section64.patch). It gives only the aligned
production kernel its own .text.x86_encode_16 input section, separating its
alignment requirement from ordinary unit code. The normal 42-source build
passes. The first eight-suite matrix exits one: all five encoder modes pass,
but the target command stops before its macro/GAS comparisons, temporary-directory
creation fails in the assembler cross-check, and disassembler CLI/oracle setup
fails before useful output checks. The original log/status are
preserved. A separate repeat passes all eight suites, including every external
comparison; the direct assembler probe also passes. The first failure's cause
remains unknown. The complete 42-unit local ASan/UBSan build and all eight
suites pass, with matching 481 source hashes and recorded build/test exits zero.
The full dump remains exactly 16,035,840 identical bytes, the graph passes, and
independent inspection verifies native instructions and both native/local
artifact provenance. The input-section proof comes from a reproduced compile;
linked hot-code inspection comes from the actual native image. The complete [three-round screen](raw/section64-triage-retry1-summary.json)
retains 54 successful processes, no warmups, and all 41 files per archive.
Vector selection is 14.49 to 14.57 ns/entry directly (+0.552%) and 14.46 to
14.58 relatively (+0.830%), higher in all three pairs against both main and597.
Encoding median ns is lower directly and equal relatively, with mixed paired
directions; this does not offset the vector cost. Against597, RSS grows252KiB
directly /244KiB relatively and minor faults grow4 in both contexts, each
three paired increases. Independent review reproduces all30 metric series. The prototype is rejected
without a performance waiver. The first screen launch failed duplicate-directory
setup before any timed child; its error, empty archive and plan remain intact,
and the successful retry has separate receipt paths. The real loop body and every experimental batch
variant remain unchanged; generated-program ISA and data-storage alignment
remain unchanged. #180 claims 6440428642 and 6441745311 record this narrow
scope extension after refreshed encoder ownership checks.

## Single-group remainder-loop candidate

Unpublished cb56f1cb638c3cec2207048be268138e1083aab4, tree
f52ed93ecd943c4afa1b2f8f1b0fb5b23c88a08e, starts from597 and skips the second
full-group loop when groups equals one: the first loop has already exhausted
the identical condition. Groups greater than one retain the remainder loop.
No encoder API, table pointer, storage, record format or producer is changed.
Independent source review supports the proof; no performance gain is assumed.

The local Clang23.1.4 object diagnostic targets znver5 and reduces the backend
kernel from9417 to6345 bytes. This is codegen diagnosis, not9700X performance.
The [frozen native qualification](raw/group-guard-qualification-plan.json) also
passes:42-source finalO3 build,481 source hashes, eight suites, graph
42/23845/141528/zero unallowed cycles/three existing allowed/zero split
variables, and exactly16035840 identical five-mode bytes. Original receipts
are in raw/group-guard-qualification. Actual native SHA256 is
ce9fc3067d74e39797da19872f6a2c930e9a3ae4f473a405d0de39ffab23c6cd.
Its backend entry is6345 bytes; whole file31176348 and text18755386 bytes,
both223520 below597. Rodata3137313, data.rel.ro8493088 and bss237749985
bytes retain their previous sizes. Symbol/size evidence is from the linked
native image. The initial name-selected dump misses the backend copy. The successful first
screen round captures its exact linked address range after timing:964 decoded
instructions, versus1425 in597; no empty snapshot is treated as code evidence.

The full local Zen4 sanitizer build and all eight suites pass, with42 unique
finalO1 ASan/UBSan/frame-pointer/no-recovery records and481 checked source
hashes; original build/test exits are zero. This is functional diagnosis only.
No changed-head CI is claimed for the unpublished candidate.

The [three-round screen](raw/group-guard-triage-plan.json) is frozen and
running through the sole measurement controller with the ordinary lock held
separately per round. It compares main35,597 andcb56 directly and under the
existing matched-relative protocol. The first round also captures the actual
backend instruction range after timing (42 archive files); other rounds have41.
All54 timed children succeed. The [historical screen](raw/group-guard-triage-summary.json)
retains scalar costs +1.445% direct/+1.590% relative and encoding +1.149%
in both contexts, all three pairs higher versus main35. Whole-process wall is
+1.015%/+0.955%, all three pairs higher. Vector selection is -0.207%/-0.277%,
all three lower, and displayed encoding instructions fall17.78 to17.74. These
point costs remain unaccepted. The unchanged main image now has peak RSS about
415160KiB versus413649KiB in earlier controls; no source cause is established.

A separate caller-template hot-linkage prototype is preserved in
[its source patch](prototype-kernel-shared.patch) but not adopted. Its fast
local C driver fails compilation because it omitted stdio.h; no execution or
performance qualification is claimed. Independent review identifies ABI and
caller-specialization risks and recommends the smaller loop guard first.

## Current-main composition and final-method refresh

Freeze current main a66f863878d28cd2c242b81a3544fc47d35f5996. The composed
head is df02bc1065eb2da98e21eed723087b7d65c3eed2, tree
8b6d18febae93beb1168499f46f8465ed846b230. Its merge1364610 resolves only
x86_target_forms.c: retain the canonical generator and preserve #535
(merged079af33) exactly. Eight of that PR's twelve concrete rows were already
classified; three baseline PCMPEQD forms and XSAVE-gated XGETBV add four.
Named profile positives and XSAVE-only positive/AVX-only negative record checks
cover the handoff. The reviewer found one duplicate test-table rebuild, removed
in df02; no incoming producer implementation is edited.

Current [profiling guidance](https://github.com/buster14a/buster/blob/a66f863878d28cd2c242b81a3544fc47d35f5996/docs/profiling.md#comparing-two-versions)
requires sampling code placements and fresh physical copies, with a repeated
reference. The old unshifted campaigns remain historical and retain every cost;
they are not relabeled or discarded. The new [frozen qualification plan](raw/current-qualification-plan.json)
builds current main and composed head normally, with twelve backend placements
spread over a page (0 through3696, step336) for subsequent copy controls. These
are measurement images; production source gains no padding. Builds, tests,
final-copy/placement timing and fresh CI for this source remain pending. The
head's full local sanitizer build is queued through the shared core scheduler.

## Exploratory history and rejected costs

Historical counter-protocol correction: the earlier review report calls its
assembler/SQLite perf-wrapper pairs rotating. Their raw headers actually use
one /usr/bin/perf tree and two fixed-order configurations. Counts and paired
directions remain as recorded; the image order did not rotate. Those counters
do not establish a causal wall-time comparison. Current image screens rotate
the actual trees. The superseded common-parent diagnostic proposed all six role
permutations and 27 child runs for nine lists; completed c051 procbench controls
replace it. That original plan was not executed.
The superseded five-round/21-sample diagnostic plan was never run.

- Initial1829ac1c6fd69ba2a62edc0e4251bc364452430d failed ordinary compilation
  because two private direct/test adapters became unused under Werror. No
  qualification binary. The e9a2e347004dbdd87fbefd15b28c162af7eebcda/
  3de8725fdc4d5340df5a0909a33dcd3f53ff3395 fixture revision removes extra
  global-mode references; it was not qualified before the targeted unused
  annotations in c0. No global warning suppression was added.
- c0's complete three-image/three-round screen is retained in
  [raw/screen-summary.json](raw/screen-summary.json). It improves several
  observations but raises short-C RSS/faults and some backend observations;
  these are unapproved. An initial encoder invocation used an unsupported
  --cross-check argument and failed usage; five corrected mode commands pass.
- 8cde shares immutable descriptors globally. Normal suites and all three
  five-mode dumps pass with identical16,035,840-byte payloads/SHA256
  a7672bd6a6c4796f780d5a9c274b6c68a46889e77d1595df2ce665e82d4d6cd7.
  It removes another2,672,640 data bytes versus c0, but the exploratory screen
  still has short-C memory/wall costs. Main RSS is37,936/37,936KiB, c0 is
  37,280/37,256 and8cde is39,008/39,036. Short-C wall is3.718/3.714,
  3.701/3.779 and3.728/3.804ms respectively. It is rejected.
- That screen intentionally ends after two complete rounds,18 AB children and
  378 status-zero timed children; six time-runs drivers report zero failures.
  The owned controller was stopped while its queued current child completed;
  that last wrapper's zombie exit_code was verified zero before the owned
  controller was killed. There is no AB success footer; SSH exits1. The
  [stop record](raw/metadata-early-stop.json) and
  [all two-round arrays](raw/metadata-screen-summary.json) preserve this
  rejected experiment. No other owner or CI job was stopped.
- 39846e5fa23fd6b8f8c73344f023e79075ea316e passes caller metadata but is an
  unbuilt intermediate. Source review identifies forced address32 adapters'
  potential descriptor retention;0fa96923bba585b171655e8154d44989fc6b17a4
  adds the explicit canonical path.
- 0fa builds but its new test uses the wrong raw opcode offset. It fails after
  100,224 full default-mode comparisons and skips subsequent constructor cases.
  The [short local ASan/UBSan probe](caller-probe.c) prints slots40,91,
  duplicate91, fixup91 and global90. c051 corrects the test to raw slot1,
  after the optional REX slot, with no production change.

The host's THP setting is always, PMD size2,097,152; no setting is modified.
The older campaign already records rejected static2MiB alignment (ordinary Wild
rejects Unsupported alignment0x200000) and rejected aligned allocation. They
are not repeated. The existing reviewed C mapping observer remains available
for attribution; no new traced residency result is claimed here.

## Measurement status and ownership

The completed main/c051 three-round screen is retained:
[exact command](raw/caller-fixed-screen-command.json). It used the sole
performance controller, and each child uses the shared lock separately.
Self-checks precede timing. Whole-driver lists use21 processes each. This is
not acceptance until complete results, remaining validation and CI are reviewed.
The original C [screen reader](summarize-screen.c) requires all 18 headers,
378 successful children, six unique driver footers and a terminal AB success
footer before writing a summary. It checks frozen commands, rotation,
workload identities, finite values, medians and ranges against every child.
Zero-to-positive percentages are undefined and written as null. Incomplete input is rejected with no summary output; all ten positive/mutation
checks pass. Reader correctness is separate from performance acceptance.
The initial [larger campaign draft](raw/planned-final-campaign.json) is not an
execution receipt; follow-up repeats should target uncertain observations while
preserving the acceptance limits and every collected sample.

Claims on #180: resumed 6425582554, immutable-data scope 6426549601,
caller-table refinement 6428440681 and hybrid refinement 6437199232,
branch codex/180-isa-policy-completion, sole
root writer. [Progress on the PR](https://github.com/buster14a/buster/pull/421#issuecomment-6427920728)
distinguishes published historical86 evidence from this follow-up.
[Independent review](independent-review.md) covers source, normal/diagnostic
receipts and arithmetic; no reviewer executes measurements. Final performance
review, final handoff and claim release remain pending.

No Tier0/Tier1/preprocessor producer, tuning or hot encoder-loop ownership is
taken. Configured-target production-guard adoption remains with#136/#133;
the target policy interfaces and explicit record checks remain the handoff.
This PR does not close#180.

PR535 is separately owned and open at eb996944af47331c5433508775021275f95cff11
when checked at 10:02 UTC. It adds baseline x87/MXCSR/XCHG/PCMPEQD rows and
XSAVE-gated XGETBV, plus admitted matcher names. Whichever PR integrates second
must carry those rows into its canonical representation and repeat the ISA
positive/negative checks. This performance slice edits neither its matcher nor
its row additions. #136/#133 retain production configured-target guard adoption;
future lowering/builtin/per-function-target integrations remain with their owners.
