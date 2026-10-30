# C4 helper corrections and local qualification for Buster #883

This packet records a correction to the placement helper and its **local**
qualification. The corrected helper accepts the preserved BASE object/image
data without choosing the first of several same-named local functions.
The real C3 producer attempt remains failed. This packet establishes no new
real producer, ready state, candidate/nonzero placement, runtime result or
performance result, and does not make [Buster #883](https://github.com/buster14a/buster/pull/883) ready.

## What changed

The exact producer delta is three files against the preserved **C3** source,
not against performance #147: hp_elf.c and hp_linked.c/h. The other fourteen
producer files are unchanged. The complete current source26/producer17 freeze,
original manifests and exact patches are in
[raw/c4-source-freeze-v1](raw/c4-source-freeze-v1/).
The preceding complete C3 source35 is retained in
[raw/c-review-v3](raw/c-review-v3/), with its
[original source manifest](raw/c-review-v3.sources.sha256).
[PINNED-IDENTITIES.json](PINNED-IDENTITIES.json) gives full hashes.

The ELF reader admits only the reviewed local section-symbol PLT32 executable
site, exact file-backed .eh_frame UNWIND profile, and exact Wild EXEC null-row
profile. Other metadata, bytes, relocations and bounds remain checked.

The linked proof validates every same-key candidate, derives one contribution
base from every key unique in both images, and requires an exact checked
address for every owned function. Valid disjoint duplicates outside that
contribution are allowed; missing/invalid candidates, inconsistent anchors,
duplicate exact addresses and overlapping candidates are refused. STT_FILE
adjacency is context only, not the ownership rule. Existing byte, relocation,
mandatory-member and failure-clearing checks remain.

## Recorded sequence

| Record | Actual result and boundary |
|---|---|
| [C3 real BASE attempt](raw/objects-zero-v3-base/REPORT.txt) | Main exit1; all 52 child statuses0. Strict PLT32 refusal occurred before object/linked receipts, internal final source check, snapshot or ready. Exact b878 objects and db8 whole images did not override that refusal. |
| [C4 copied object trial](raw/object-proof-dev-v4/base-v1/TRIAL-REPORT.txt) | Exit1 at unsupported UNWIND relocation site. |
| [C4 first copied zero trial](raw/zero-proof-dev-v4/base-v1/TRIAL-REPORT.txt) | Exit1 at Wild null-row profile; comparisons unreached. |
| [C4 second copied zero trial](raw/zero-proof-dev-v4/base-v2/TRIAL-REPORT.txt) | Object comparison passed 12,905 symbols / 118,045 relocations / 0 disclosures; linked proof refused global-key ambiguity. Overall exit1. |
| [C4 b175 copied zero trial](raw/zero-proof-dev-v4/base-v3/TRIAL-REPORT.txt) | Fresh adapter build0 and one trial0. Object and linked proofs passed: 810 functions, 8,763 operands / 35,052 masked bytes, base 0x8fb000. All four fresh copies and retained originals were preserved. |
| [C4 local composition](raw/c4-local-validation-v1/REPORT.txt) | Nine builds, eight runs and seventeen postchecks0. Strict/SAN each: ELF 107, normalizer 227, controller 70, actual composition 50; zero failures. |

The copied-data inputs are the older BASE ce1bea1e source/tree, 805 files:
both objects have SHA b8783141… and both images db8cbb44…. The candidate
cecd4962 role, 807 files, is separate; the copied success is **not candidate
execution**. All complete identities are in the pin record and original
receipts.

The adapter 01808de2… was executed on malloc-backed ELF **data**. The separate
nine-unit support output 584f18c0…, 121,584 bytes, was compiled and **never
invoked**, including help. The local composition control calls actual
method_prove, receipt writing and snapshot/membership seams on synthetic
fixtures. Its normalization placeholders attest membership only; unequal
masked operands do not attest numeric relocation semantics. The composition's obsolete-v2 ready fixture and the controller's malformed/v3
ready-binding fixtures are synthetic negative data; none is a qualified ready
result.

## Validation contexts and corrections

The local tool is recorded Clang 23.1.4, binary b5389000…, distinct from the
private official toolchain used in the earlier 9700X construction records.
System headers/libraries are outside this project-file ledger. Actual commands,
compiler options, source pre/post checks, binary identities, environment gates,
genuine per-invocation cores grants and original session outcomes are retained.
Regular and sanitized results are distinct settings, not interchangeable
certificates. The local host context is identified separately in the
[post-curation context](CURATION-CONTEXT.json); it is not a new benchmark.

The earlier linked 61 plus geometry 139 runs give 200 cases per mode:
199 linked cases and one explicit reader refusal. Focused NULL 42 / PLT 53 / UNWIND 52
and older component settings remain separate evidence; they were not rerun to
rename directories. See the corresponding raw reports and original indexes.

The [environment precision note](raw/hot-placement-v4/LINKED-ENVIRONMENT-PRECISION-v1.txt)
limits an earlier prefix census and labels its later observation as post-only.
The actual seventeen-entry run added same-dispatch empty BASH_FUNC/HELD gates
before genuine cores. The [stderr precision note](raw/C4-LOCAL-STDERR-SCOPE-PRECISION-v1.txt)
preserves the chronology: 3,481 entry-level bytes plus 2,765 later-reviewed nested
fake-driver bytes, 6,246 recursively, no sanitizer report. Parent instrumentation
does not establish broader child leak coverage.

The missing-record setup failure, explicit prepared-empty-root reuse amendment,
pre-dispatch platform parse note, authoritative paired symlink ledger and its
unpaired draft remain unchanged. They are not compiler/control failures.
Historical plans, reports and source annotations retain their captured wording,
including PENDING/HELD and the integration source's pre-execution SOURCE DRAFT
ONLY comment. The later literal build/run records bind those same source bytes.
Local reviews do not rewrite or retroqualify earlier attempts.

## Portable archive and omissions

[ORIGINAL-COPY-INDEX.json](ORIGINAL-COPY-INDEX.json) maps every copied member to
its original path, SHA, byte count and mode. Copies preserve raw bytes, including
NUL ledgers and unusual filenames. [OMITTED-PAYLOADS.json](OMITTED-PAYLOADS.json)
records every omitted member in the enumerated roots, including compiled ELF
programs/objects, synthetic ELF byte fixtures, real object/image copies, the
large archive, large raw assembly/inventories and full symbol dumps. Those
original bytes remain local and were not altered. The two /dev/null symlinks
are represented by exact target identities and the original paired NUL ledger;
they are not dereferenced into apparent regular files here.
[Derived ambiguity context](derived/linked-ambiguity-context.json) contains
bounded verbatim rows with their original dump identities, not a replacement
for an omitted full dump.

Original RAW/PAYLOAD indexes deliberately remain byte-exact and can therefore
name omitted files. **Do not interpret them as a complete public payload.**
Verify this selected portable package with PORTABLE-SHA256SUMS; that manifest
excludes itself; its separate digest is recorded in the publication description
and the curator's handoff record.
Git preserves executable bits, not original Unix permission bits; the original
mode/stat ledgers remain authoritative for the recorded runs.

For deliberate reproduction, read the frozen PLAN and literal command JSON,
use a new private output/fixture root and reconstruct the recorded source modes.
Source-relative includes must use the complete archived dependency set. Replace
historical absolute workspace/tool locations explicitly and record the new
environment and identities. No archived command or historical ready fixture
should be treated as permission or successful qualification for a new run.

## Provenance and remaining gates

[Performance #147](https://github.com/buster14a/buster-performance/pull/147)
records the earlier normal construction/C1-C2/first-failure scope and explicitly
does not contain C3 live code. [Performance #151](https://github.com/buster14a/buster-performance/pull/151)
is separate sanitizer diagnostic evidence, not incorporated into this packet.
The retained C3 source and its support/failed-BASE text records bridge the
lineage here.

First-party helper/control source retains Apache-2.0 WITH LLVM-exception notices
and the repository [LICENSE](../../../LICENSE). Original C3 shell sources are
historical reference material; the new functional helper and controls are C.
Clang, Wild, system headers/libraries and source-corpus inputs are external
runtime/build dependencies, not incorporated implementations or redistributed
toolchains in this packet. No historical DCO certification is added.

Full actual controller/source/object/linked/snapshot/ready checks, real
BASE/candidate/nonzero construction, hardware placement/output/runtime controls,
locked two-input A/A/candidate timings, original material certification and
final landing composition remain separate gates. Local helper success is not a
speedup or a full compiler/sanitizer-matrix pass.
