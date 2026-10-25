# Independent source review

Reviewed Buster candidate: `174c435539c3970558561e94b1f08445aa6d3c01`.
Measured production image: `6c722994e9dfccc9d6047235191d761376b6b3d1`.
Reviewer: independent read-only Codex agent `isa_policy_review`, separate from
the implementation writer. The reviewer performed no builds, tests,
measurements, remote-host operations or GitHub mutations. Executed results in
the qualification record belong to the implementing session and CI.

The review covered the requirement-row additions, ISA/host/tuning separation,
scalar/vector eligibility and fail-closed behavior, selector test integration,
native SSE/VEX/EVEX fixtures, feature/subset negatives, compiler macro oracles,
GNU assembler differential, original evidence harnesses and documented limits.
It was repeated after current-main integration and every final oracle/layout
delta. The final source conclusion was: no actionable code findings remain.

Findings addressed before freezing:

- GCC's macro differences are explicit rather than mistaken for policy errors:
  absent INVPCID/RDPRU macros and named-Zen5 SHSTK behavior.
- Independent FMA minimum-feature expectations supplement tests whose scalar
  specification is the requirement table itself. Every existing FMA form is
  covered, including individual feature removals and subset negatives.
- GNU as uses an independently accepted, zero-diagnostic Zen5 control before
  any architecture-negative comparison. Canonical forms and warning-free LEA
  operands retain their ISA meaning; raw flagged records are tested separately.
- Restricted-architecture diagnostics must name the exact input and an actual
  instruction line, with the ordinary error prefix. Internal errors, fatal or
  unplaced diagnostics, warnings, unavailable tools and abnormal statuses fail.
- GAS's Nocona feature model supplies its separately tracked FISTTP capability;
  removing MONITOR and adding ABI-level extensions represents the intended
  profile. An SSE3 command-line extension alone did not enable FISTTP in GAS.
- The 144 packed EVEX XMM/YMM FMA cases admitted by GAS 2.47 without VL remain
  policy-denied. Their exact independent catalogue enumeration is guarded only
  by the disabled feature and observed GAS acceptance; policy denial is checked
  inside the branch. They are reported as gaps, not exact external comparisons.
  A future GAS rejection takes the ordinary comparison.
- The instruction-count probe refuses unavailable, zero or multiplexed counters
  and failed clocks. It does not nest counters around repository counter users.
- The ELF audit checks section-table/file bounds and exact initialized twin
  decoder records, tests ISA negatives and separated sections, and explicitly
  initializes both encoder and decoder. It audits Buster objects to preserve
  the boundary with foreign CRT/library code and unclassified ENDBR64.
- Explicit 64-byte requirement-table alignment matches repository conventions
  and keeps each full eight-row SIMD load within one cache line. Table extent,
  contents, bounds, APIs and the 16-byte instruction representation are unchanged.
  Attribution of earlier timing shifts to alignment remains an inference;
  final locked A/B measurements inform performance acceptance, which also needs
  the user's explicit approval of any retained regression.
- The two VEX/EVEX whitelist prechecks are necessary conditions for equality
  with the compared strings. The enclosing `name[0] == 'v'` condition makes
  `name[1]` safe, including the one-character string case. Admission is
  unchanged. The original C experiment copies the exact old/proposed functions,
  checks all 8,352 forms and target-filtered tables, uses valid clocks and
  positive unmultiplexed counters, rotates measurement order, and prevents
  compiler elision. Its scope is the supported-name admission pass, excluding
  roles/buckets and other full-initialization work.

Final reviewed SHA256 values:

| Source | SHA256 |
| --- | --- |
| `x86_target_forms.c` | `190e2e7d38b82b2dfc68a4d4143f7ace8e81a99c1ee2798e33a093597b7c4d74` |
| `x86_target_policy_test.c` | `11a5962b22cb4f8eb82f1062c3db5e0a9c729313564ef30e2b0b89be83d7b079` |
| Current `x86_target_selection_test.c` | `777745ec28a8acdfe28f714ba9fa2da9df325ec16d71af41e6e763d4263f8f23` |
| Measured `6c72299` selector test | `05d6658c4c2b499436606b8c34bf5c872a6a2d27b61fdcf0bd0f01444e917ee1` |
| `x86_match.c` | `17a689e24e87873c73db5783401f18b1f0105ec2004d69c5105838c82ac32fdd` |
| `audit-elf.c` | `287a86aed79b1f77cd8be970fa936ec33f685b87f7c2eb167bd795a045e48537` |
| `policy-instructions.c` | `68ec66ee236dcfba2934a4e20ea97f707a3fc94870c98a223253709a5268bddb` |
| `syntax-prefix.c` | `fcc045e2c86c8f9d4b03d742ee80add6938335cbe889fd1c041ec204f96fdba9` |
| `sanitize-compiler.c` | `2b68184e7c9af24f29ba2dad24be045812e1fb42d56660b942f07483d2261dc6` |

The later read-only evidence audit independently matched the earlier measured-head CI
receipt to head `6c72299`, synthetic merge `78c91f99` and base `b4230905`, including
75/75 commands and the no-recursion graph. It verified all ten SQLite checker
summaries and 210 successful process statuses, the five paired deltas and
150.045 → 149.006 ms aggregate medians. It also matched all nine paired runtime
receipts, exact output identities, the 161-byte/50-instruction object audit,
FNV and linked-executable sizes. Corrected wording identifies the runtime ranges
as ranges of process medians and distinguishes positive native execution from
negative policy rejection before encoding. Older source/probe labels and the
later #423 merge boundary were corrected.

Further read-only audits matched every sustained table/backend median, range,
paired direction, workload total and cycle count to the completed receipt.
The vector backend's +0.279% elapsed / +0.189% cycle increases are explicitly
unaccepted; reported instruction counts retain their two-decimal precision.
The benchmark reports one median from 21 samples, rather than 21 separate
medians. The reviewer then recomputed all 20 short-file summaries directly
from 420 individual successful observations, confirming the medians, min/max,
aggregate changes, mixed paired directions and retained 3.234 ms observation.
No further wording or arithmetic issue remained.

The final startup audit parsed all 60 unique round/configuration/tree headings,
30 one-table observations and 30 complete assembler observations. Every row,
median, range, paired direction and percentage matched the report: table
391 → 411 ns, assembler initialization 0.722 → 0.769 ms and the warm-pass
summaries. All 30 metadata sets matched the fixed workload/index/arena/ELF.
Initialization is correctly distinguished from the 21 warm pass samples, and
the one-table operation is not called whole-process startup. The recorded
costs remain unaccepted pending the user's approval. No measurement was run
by the reviewer.

The final GitHub-thread check found that `6c72299` observed zero depth refusals
but did not enforce zero. `174c435` adds the explicit `refused == 0` condition.
Independent source review verified that every non-success branch increments
that count, so a matching scalar/vector DEPTH refusal now fails. Other failure
handling and cleanup are unchanged. The implementer subsequently ran fresh
optimized and full sanitizer target/assembler checks, and changed-head hosted
CI passes all 79 commands; these executions are separate from source review.

The reviewer independently checked the actual old/new optimized binary copies:
31 build-ID bytes and 1,164 bytes inside the test-only selection entry differ;
zero other bytes differ. Program/section headers and symbols match, with
identical production code/data, addresses, layouts and unwind metadata. Source
and the actual call site restrict that entry to `test-x86-target`. This supports
retaining the correctly labelled `6c72299` measurements for unchanged production
paths; it does not create direct `174c435` timings or new performance approval.
Changed-test execution and consumers of binary identity are outside the reuse
boundary. No static gap required rerunning production performance solely for
this delta. Static inspection ran locally; no compiler execution or measurement
ran there.

The original sanitizer driver adapter was also reviewed: bounded allocation,
NULL termination, preserved argument order, absolute real-Clang execution,
failure handling and cleanup are sound. The existing ordinary build commands
parse all appended options, `-O1` overrides `-O3`, and sanitizer flags reach
linking as well as all 42 compile commands. It is an evidence/build adapter,
not a production dependency.

Material limits remain: sampled canonical operands in the GAS differential;
linear executable-section auditing; an incomplete encoder catalogue;
Tier0's production guard owned by #136/#133; and separate full corpus,
builtin-lowering and per-function-target integration. The review does not
certify unexecuted acceptance or imply a GitHub approval or merge.

Architectural/source references consulted independently:

- [Intel SDM](https://cdrdv2-public.intel.com/868137/325462-089-sdm-vol-1-2abcd-3abcd-4.pdf)
- [GNU instruction templates](https://gnu.googlesource.com/binutils-gdb/+/master/opcodes/i386-opc.tbl)
- [GNU CPU dependencies](https://gnu.googlesource.com/binutils-gdb/+/2abac9c95cc1852c25cf8d67322e0af10d688b8a/opcodes/i386-gen.c)
- [GNU assembler diagnostics](https://gnu.googlesource.com/binutils-gdb/+/3fb6f5457e5b53fdb73a98a24b3764e821e8ccc5/gas/config/tc-i386.c)

These sources establish behavior and architecture facts. No external
implementation is copied into the original C changes or evidence helpers.
