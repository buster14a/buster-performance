# Independent source review during regression fixes

Read-only review by the existing isa_policy_review agent. No independent host execution or benchmark execution was performed by the reviewer.

## c0cc199

No source findings. The final delta from 3de8725 marks only the two private direct/test adapters unused; it neither suppresses warnings globally nor forces retention. Completed target, assembler, five encoder-mode and graph receipts match the stated counts. The full five-mode dumps both contain 16,035,840 bytes with SHA-256 a7672bd6a6c4796f780d5a9c274b6c68a46889e77d1595df2ce665e82d4d6cd7.

The reviewer identified that candidate-census.log does not explicitly print dump exits or cmp status. The added candidate-commands-and-status.json preserves separate successful dump statuses and the successful set-e size/cmp command. Both all-mode runs exited zero before comparison.

The reviewer independently checked all preliminary screen arithmetic: 27 AB children and 567 time-runs children, zero failures. Adverse c0-versus-main35 medians are backend vector +0.276%, encoding +1.149%, short-C RSS +336 KiB, short-C minor faults +4, and ASM1 minor faults +1. All vector/RSS/fault pairs increase. Initialization and short-C wall improve versus main but worsen versus the composed control. These are unapproved screen costs, not acceptance.

## 8cde401

No actionable source finding. The X86 home supplies one hidden, immutable descriptor definition; other main units declare the identical const element type, extent and hidden visibility. Standalone encoder inclusions retain static data. UMONITOR identity and descriptor subtraction still refer to the proper array object. No mutable state crosses units and no required constant expression depends on initializer visibility.

Nonhome units lose initializer visibility, which can affect constant folding. Relevant actual consumers are instruction_is_valid/x86_validate, encode_one, matcher admission and assembler relative-byte relaxation. Their runtime indices generally already need loads, but constant callers could previously fold fields. Standalone benchmark-backend retains its own static table and does not directly expose this main-only effect. Actual main benchmark-assembler and whole compiler paths must be measured. c0 timings do not qualify 8cde401.

The reviewer checked all 12 normal-qualification statuses and their logs: all
exit zero, including 200,448 complete-entry comparisons, assembler
1,882,483/zero failures, all five encoder modes and graph 42 units/23,821
functions/141,501 calls/zero cycles/three allowed/zero split variables.
All 478 main and 481 candidate source-manifest entries match.

The new binary SHA-256 is
6182d70245a2142abe9cdd4a92663e4e16d54ffb9accfd5a5f0664cc8f89c309.
All three dumps match the expected 16,035,840-byte length and the full hash
recorded above, with an explicit composed/metadata cmp-zero receipt.

| Bytes | Versus main35 | Versus composed | Versus c0 |
| --- | ---: | ---: | ---: |
| File | -3,892,877 | -3,722,205 | -2,672,432 |
| .text | -2,688 | -43,952 | +576 |
| .data.rel.ro | -3,671,504 | -3,674,880 | -2,672,640 |
| .bss | -3,692,480 | unchanged | unchanged |

The census retains 16 descriptor arrays: one hidden main-unit array and
standalone copies. The data reduction from c0 equals eight 334,080-byte arrays.
Selected consumer symbol-size multisets are identical from c0 to 8cde401,
including instruction_is_valid, encode_one, tier0_select, x86_encode_64 and
run_backend_benchmark. This is narrower than proving identical instructions or
excluding lost folding elsewhere. No timing conclusion follows from sizes.

The canonical documentation correctly states the common-body oracle limitation
and separate frozen comparison. Final sanitizer and performance evidence review
remains pending; this audit covers normal qualification only.

## c051 caller-table candidate

Source review of39846e5 and0fa9692 finds no cold-path correctness issue. Supplied descriptions flow through per-form construction, GS patching and fallback rebuilds. Numeric row mapping is unchanged. UMONITOR pointer identity stays in caller-local legacy-property construction. The restrict contract is valid for current disjoint callers. Address32 alone permits null metadata for its immutable home canonical table; default64/APX reject missing descriptors before writes. Standalone inclusions retain their own static canonical data.

The reviewer identified forced address32-adapter descriptor retention before execution;0fa's explicit canonical path addresses it. Its first execution finds a test error the initial source review missed: raw NOP slot0 is optional REX40, opcode slot1. c051 changes only expected offsets/comment. The reviewer independently derives that slot from constructor semantics; the local ASan/UBSan probe confirms40,91 with unchanged global90. Failed0fa remains failed, not retroactively qualified.

Completed local evidence is checked independently:42 unique -MJ entries end inO1 with ASan/UBSan, frame pointers and no recovery or later disable. All481 source-manifest entries match. Seven local suites pass without sanitizer diagnostics, including250,560 complete entries and all26 native predefine sets. These are Zen4 diagnostics, not9700X performance acceptance.

The locked c051 census retains24 descriptor arrays (9main/15standalone),8,017,920 descriptor bytes, matchingc0. File+345/.text+208/.rodata+37 versusc0; data.rel.ro andBSS extent unchanged, BSS base+384. Assembler/checker default spans intersect2 PMD-sized address regions andbackend3; readiness flags are absent from this census. These are address observations, not resident-page counts.

The rejected8cde screen has exactly18 headings,378 status-zero timed children and6 successful time-runs footers. There is no AB success footer; verified final wrapper exit0 and intentional controller termination match the stop record. Its two-round arrays match the raw prefix.

The completed c051 native receipts cover all 12 normal steps, including all
five encoder modes and graph validation. The reviewer independently checks
the local sanitizer executable and adapter hashes against the retained artifacts.
CI's 82 commands pass on merge 433ccce (c051 into 6b2c922), correctly separated
from manual baseline 35f. No actionable source or completed-receipt finding
remains. Current timing results and performance acceptance remain pending.

## Screen analysis helper

Review found five issues in the first unqualified C reader: undefined
zero-baseline percentages printed as zero, weak command identification,
globally counted rather than unique terminal footers, nonfinite-number
acceptance and unchecked output errors. These are fixed before any completed
screen is summarized. The reader additionally checks child rotation and
reported ranges. Current partial input deliberately fails with zero JSON
output. Follow-up review found two further finite/percentage edge cases, also
fixed before qualification. All ten retained positive/mutation checks now pass:
real summary byte equality, missing success footer, failed child, wrong list,
nonfinite CFI, compensated duplicate footer, wrong child order, zero baseline,
percentage overflow and output failure. These are reader fixtures, not samples.
The measurement controller and original raw data are unchanged.

## 597ee55 hybrid candidate

Read-only review of the complete 21-addition/one-deletion production delta found
no actionable correctness issue. DRIVER, ASSEMBLER, BACKEND and CHECKER retain
static descriptions; CHECKER is the real C source pipeline. X86 supplies the
hidden immutable canonical table for four other main units. Wild localizes the
canonical definition, and each caller's mutable storage/readiness and legacy
properties remain private. Standalone inclusions retain static catalogues.

The reviewer checked all 42 native and 42 local sanitizer compile records,
481 source hashes for each build, seven passing suites per build, graph
42 units/23,845 functions/141,528 calls/zero unallowed cycles/three existing
allowed cycles/zero split variables, complete five-mode output and generated
baseline/v3/v4 artifacts. Local Zen4 instrumentation remains diagnostic only.
The full expected dump size/hash and generated object/executable hashes match.

Static census arithmetic matches: five main plus fifteen standalone descriptor
arrays, exactly four fewer 334,080-byte arrays than c051. File size falls
1,336,504 bytes versus c051 and 2,556,604 versus main35; .text matches c051 and
is 3,056 bytes below main35. Full linked FUNC symbol sequences match c051 in
address, size, binding, visibility, section and name. Five nonempty selected
consumer disassemblies match after normalizing only RIP data displacements and
comments. Both x86_validate snapshots are empty because no symbol is emitted;
they establish no validation-codegen equivalence. Equal section sizes alone
would not prove byte equivalence. PMD-span geometry is not residency or cause.

The existing unmodified 518-line procbench source and its license were checked
at performance commit 24f54c2f6a214c67bd83d791b4ff3acebef0c4a8. Source SHA256
12be4d95da5915fb43af696ae6abc304b27e341a5d57285469ad36ce05f7dac3 and
native tool SHA256 94d7c1ff56e666a3065a3577bdda5c7fa2cf2535a3bd0de5254fddd5a12745aa
match the receipts. External procbench counters include kernel and user;
backend inner counters exclude kernel/hypervisor and retain no enabled/running
times. A positive external counter without a multiplexing marker is not a
backend PMU enabled/running receipt.

All 71 preliminary summary metrics reproduce from three raw TSVs and all
27 backend/nine large-assembler captures. All 792 timed and 36 warmup statuses
are zero; 801 externally counted rows (1,602 counter values) are positive with
no multiplexing marker. Captured stderr is empty. Every compiler/runtime and
harness/input identity check matches.

The reviewer explicitly preserves adverse hybrid-versus-c051 observations:
ASM1 wall +0.791%, RSS +2,076 KiB; large-ASM wall +5.724% with mixed paired
direction and RSS +2,080 KiB. In contrast, hybrid-versus-main is lower for
those medians. The unchanged c051 scalar path shifts from 41.255 to 50.54 ns,
cycles 228.645 to 280.08, with displayed instructions unchanged at 571.32.
Same corpus/compiler/harness identities do not explain its cause. The apparent
18.3% hybrid advantage over that slower state is not an established source
improvement. Final six-round controls and their acceptance review are pending.

No reviewer built or executed either compiler or any measurement. No review
grants a performance exception or authorizes merging.

## Completed six-round 597 controls and active-code inspection

Independent recomputation reproduces all 72 metrics from six raw TSVs and all
captures, including 18 single-process cold-init observations. Every 1,584 timed
child and 72 warmup exits zero. All 54 backend and 18 large-assembler captures
have empty stderr; 1,602 externally counted rows have positive counters with no
multiplexing marker. Input hashes, compiler/runtime identities and six role
permutations match. Medians, midpoint A/A references, paired percentages and
above/below-both counts reproduce exactly.

The remaining encoding observation is 0.875 to 0.885 ns/entry (+1.142857%),
five increases/one decrease, four above both baseline medians. Cycles increase
4.845 to 4.905 (+1.238%), five above both, while displayed instructions remain
17.78. Identical runtime executable hashes do not explain its +0.663833% offset.
Neither cost is waived. Initialization is one observation per process, not a
21-pass median. Fresh CI40483449001 passes 84/84 on integration965f163c72,
separate from the frozen manual images.

The exact nonempty main-versus-597 backend slices match after relocation
normalization: x86_encode_16 has 1,425 instructions, tier0_benchmark_run 1,378,
its counter reader 72, and tier0_tables_open 5,222. Instruction order,
register/immediate operands and relative instruction offsets are identical;
three measured-caller tail references move only assertion diagnostic strings.
The top-level benchmark's inlined construction/build_template calls become
x86_build_nonlegacy_templates before timing; the measured helper sequence stays
intact. x86_encode_16 is the active 16-record-batch encoder, distinct from
16-bit mode and from the previously captured 64-record variant. This establishes
code structure, not equal time or a causal explanation for address effects.
No timed hot-source change is justified by this evidence.

The proposed env-C comparison is a justified invocation-context test. Relative
execution changes CWD alongside argv0 and AT_EXECFN, so success cannot isolate
any one of them as the cause. Record resolved symlinks and image hashes.
Outer wall/resource/counter observations include env, directory changes and
the extra exec; the same helper does not prove identical overhead. Backend
inner windows remain separate and have no external PMU group. Preserve all
earlier observations and analyze this new protocol separately.
