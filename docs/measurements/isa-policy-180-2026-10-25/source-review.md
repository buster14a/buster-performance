# Independent source review

Reviewed Buster candidate: `30e7bbc860056779b0e9fa3f426565e1bc010ec4`.
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
  Attribution of earlier timing shifts to alignment was an inference until the
  implementing session's final locked A/B measurements.

Final reviewed SHA256 values:

| Source | SHA256 |
| --- | --- |
| `x86_target_forms.c` | `190e2e7d38b82b2dfc68a4d4143f7ace8e81a99c1ee2798e33a093597b7c4d74` |
| `x86_target_policy_test.c` | `11a5962b22cb4f8eb82f1062c3db5e0a9c729313564ef30e2b0b89be83d7b079` |
| `x86_target_selection_test.c` | `05d6658c4c2b499436606b8c34bf5c872a6a2d27b61fdcf0bd0f01444e917ee1` |
| `audit-elf.c` | `287a86aed79b1f77cd8be970fa936ec33f685b87f7c2eb167bd795a045e48537` |
| `policy-instructions.c` | `68ec66ee236dcfba2934a4e20ea97f707a3fc94870c98a223253709a5268bddb` |

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
