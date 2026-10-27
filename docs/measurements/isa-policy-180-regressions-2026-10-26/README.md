# PR421 remaining-performance fixes

Work in progress. Leave the compiler PR draft/open/unmerged. No performance
exception is requested or accepted. New timings are not yet complete. Normal
suites, local sanitizers and changed-head CI pass. This report keeps rejected experiments
separate from the current candidate.

## Frozen sources and images

| Role | Source commit | Tree |
| --- | --- | --- |
| Frozen main | 35f26f68d7caa9bf5f6248822100a51c06e2c878 | 4687d54d63d0edd4cfd3c3db9e2180c9691d0fb8 |
| Main plus previous PR implementation | fb4a01fde21b339a81c20e0dc4aa20f446829911 | 2db67ecdb710aa208dfc3519d263a52562e5e8c9 |
| Constructor-only control | c0cc199a7e601ecbeb537d8429fc3b23afb300ec | edaf0db06401ad02eba7c9d5e7ff428d084e24d0 |
| Rejected shared-descriptor candidate | 8cde401861c4a5b5cc9d80b8df21f04e9312eefe | 3e5255568d0e2cbf4e6e701964edd3badaecce3c |
| Current caller-table candidate | c051292af035c9a957158fcd8c20a2d50d1e3839 | 1de637e4626eca8eda071cad57c800481a5e42b9 |

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

## Current qualification

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

## Current static footprint

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

## Exploratory history and rejected costs

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

The current main/c051 three-round screen is active:
[exact command](raw/caller-fixed-screen-command.json). It is the only active
performance controller, and each child uses the shared lock separately.
Self-checks precede timing. Whole-driver lists use21 processes each. This is
not acceptance until complete results, remaining validation and CI are reviewed.
The original C [screen reader](summarize-screen.c) requires all 18 headers,
378 successful children, six unique driver footers and a terminal AB success
footer before writing a summary. It checks frozen commands, rotation,
workload identities, finite values, medians and ranges against every child.
Zero-to-positive percentages are undefined and written as null. Current
partial input is rejected with no summary output; final positive/mutation
checks remain pending. Reader correctness is separate from performance acceptance.
The initial [larger campaign draft](raw/planned-final-campaign.json) is not an
execution receipt; follow-up repeats should target uncertain observations while
preserving the acceptance limits and every collected sample.

Claims on #180: resumed 6425582554, immutable-data scope 6426549601 and
caller-table refinement 6428440681, branch codex/180-isa-policy-completion, sole
root writer. [Progress on the PR](https://github.com/buster14a/buster/pull/421#issuecomment-6427920728)
distinguishes published historical86 evidence from this follow-up.
[Independent review](independent-review.md) covers source, normal/diagnostic
receipts and arithmetic; no reviewer executes measurements. Final performance
review, final handoff and claim release remain pending.

No Tier0/Tier1/preprocessor producer, tuning or hot encoder-loop ownership is
taken. Configured-target production-guard adoption remains with#136/#133;
the target policy interfaces and explicit record checks remain the handoff.
This PR does not close#180.
