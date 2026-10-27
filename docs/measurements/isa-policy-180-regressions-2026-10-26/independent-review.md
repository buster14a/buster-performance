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

Read-only review of unpublished 3953bcc confirms that its only difference from
597 is the aligned(64)/dedicated text-section annotation and comment. No source
correctness defect was identified. The first matrix has five passes and three
setup failures; it establishes no errno or filesystem cause. The reviewer
requested precise external-check and metadata-attribution wording, now corrected
in README. No candidate performance or functional acceptance was inferred.

3953 artifact follow-up independently confirms four unchanged active instruction
sequences after relocation normalization (encoder 1425, runner 1378, reader 72,
tables 5222), native 64-byte-aligned 9417-byte entry, and reproduced object
ordinary text alignment 16 / dedicated executable section alignment 64. Native
and sanitizer 42-unit records, 481 hashes in each passing eight-suite matrix,
graph and exact five-mode dump receipts verify. Input-section metadata is from
a reproduced compile; disassembly is from the actual linked native binary.
No source/provenance defect or performance acceptance was inferred.

All30 section64 screen metrics independently reproduce across54 TSV rows and
captured outputs. In addition to vector costs, RSS rises252/244KiB and faults4
versus597, all three pairs. The reviewer recommends the smaller single-group
remainder guard: the linked first loop consumes every full16-record group, then
rechecks the same condition. Source proof leaves groups2/4 unchanged; no
performance benefit is assumed. Hot linkage remains an unadopted prototype with
ABI/register and specialization risks.

cb56 native/local provenance independently verifies all units/hashes, eight
suites each, graph, complete dump and linked size reductions. The eventual
address-range capture is964 instructions. All30 historical guard metrics
reproduce across54 rows/captures; scalar, encoding and whole-wall costs remain
unaccepted. The current-main merge preserves all12 concrete #535 rows, exactly
four newly classified in the canonical table. XSAVE is low bit16 and survives
the compact projection unchanged. The reviewer's duplicate table-build call
was removed in df02bc. New placement/copy qualification remains separate.

## Historical df02 / pinned main a66f audit

The read-only reviewer rechecked all1944 timed whole-C rows (648 per round): every status0, positive cycles/instructions, no major faults. All648 slot medians/extrema and every printed aggregate median and exact cycle spread match strict upper medians. SQLite head/main cycles are +0.03072%, +0.08004%, +0.15177%; main-again -0.03307%, +0.02213%, +0.03305%. SQLite wall costs from displayed ms are +0.00625%, +0.03282%, +0.05628%; peak RSS +96/+92/+80KiB and one extra minor fault each round. Placement/copy ranges span zero; the three positive cycle directions and resource costs remain unaccepted. Short-C cycles fall3.3644%,3.2214%,3.3225%; instructions fall6.01704% each round.

The current generated retry proof independently matches all six full-file SHA256s, objects2056c6d309380ad3e83b683d076f379887622f977b283580d9579c00b7d711ee/programsd1d3722f28d5a5b5178a14d3c202dc69d66e12a9e7a90add2c3c361660ccd3ae. The161-byte/50-instruction executable section FNV remains d384614d5b244074; current whole files differ from historicalcf0b/4a81 artifacts, so historical whole-process runtime measurements do not qualify these current programs. All six current outputs match the fresh ClangO0 reference.

The reviewer verifies41 instrumented local units, seven passing suites and the one selector-audit failure. Direct pinned-base/head probes both reproduce the identical tier0_generate.c:3117 empty-shape global overread. The summary correctly labels this inherited defect and pending owner coordination; no sanitizer pass or waiver is inferred. Encoder campaign arithmetic and final CI remain pending.

## Final ac57 / pinned main74 source and receipt review

The independent read-only reviewer checked the final conflict integration, all64
concrete #565 masks, the expanded seven-input matcher cache identity and the
owner-written #584 hotfix boundary. Its FS/GS movq tie-break finding is fixed by
normalizing both form IDs with x86_form_row. The final eight-case GNU-as fixture
uses real newlines and an object symbol label; both intermediate fixture failures
are retained. No remaining source correctness defect was identified.

The reviewer independently recomputed all1,944 final whole-C timed rows and648
slot medians: unique/status0, positive cycles/instructions, zero major faults.
All966 summary JSON values match, including CPU time, every upper median,
matched placement/copy ratios and separate Cartesian harness bounds. SQL cycles
are+0.0418349%,-0.1475197%,-0.0263769%; short-C cycles-3.0679256%,
-2.9203710%,-3.0508712%. Mixed tiny SQL directions establish no neutrality or
speedup. Memory/fault reductions and baseline-again controls remain explicit.

All48 encoder plans and1,728 exact list commands were reviewed: complete
3rounds x4flags x(108plain +36conditioned) shape, correct roles/rotations,
65,537 records in129-record calls,30ms conditioning, full-written/cmp/hash/inode
copies and no outer PMU. Archive failure now propagates independently from the
C harness failure. Complete actual encoder results remain pending.

The reviewer also verifies the full CI log SHA, exact82/82 command result and
actual10f2c5d9f2fc1c35e371e4ea551abad3d25fd7e4 integration ancestry/graph.
The followup plan, final static address census and remaining timing receipts
are under review; no performance exception or final acceptance is inferred.

Final followup-plan review finds no protocol mismatch across33capture batches/
585commands and three runtime scripts. The independent census check verifies
all24images and72selected addresses, resolving the actual-placement qualifier
for both encoder kernels and the backend runner. The source review reports no
new actionable finding. Its README wording correction is applied: the eight
segmented-movq cases are valid byte-oracle cases; negative ISA tests are elsewhere.
All remaining timing/counter limitations above continue to apply.

The original committed reader remains correct and unchanged. An investigation
misread procbench --first and briefly proposed hardcoding innerround1; the
independent reviewer compared the exact pinned harness source and rejected that
proposal before publication. The rejected patch/logs are retained. Tests now
explicitly synthesize matching round3 TSV/captures and reject mismatched round1
TSV with round3 captures; these temporary parser fixtures are not campaign data.
The reviewer confirms this final24-check test design; both configurations now
pass24checks under local ASan/UBSan through the cores queue. The
plain36-row fixture does not prove conditioned30ms parsing, which awaits the
complete actual campaign.

## Complete ac57 encoder and private tail-candidate audit

Independent recomputation verifies all1728children,648summaryrows and432actual
30ms-conditioned headers. All3456hashlines,3456inode rows and3792regularfiles
in48archives match; all1776child/harness stderr files are empty. Wrapper stderr
contains only normal lock-wait metadata. Every median/percentage/Cartesian bound
matches. Plain ac57 medians are12/12higher than both main labels,0.6766–1.6971%;
conditioned results are8higher/3lower/1tie. One major fault is retained at
round1/plain/flags2 command32(main-p10-c0). No filtering or acceptance follows.
The C gate completes, verifies all conditioned headers and fails on /dev/full.

The private masked-tail source passes native8/8, localSan8/8, graph and dump.
Full-loop opcode/memory histograms match ac57 without extra PDEP/masked loads
or spills; whole-function instruction counts increase. Independent decoding
confirms both disassembly captures and the stated footprint components. Both
288-child screens match source-image hashes/inodes and status0, with zero majors.
Partial-batch medians improve every comparison, but no-tail costs against main
persist; reject this candidate.

The second private source only restores main's original remainder loop. Native
8/8 and graph/dump pass. Its initial localSan6/8 run inherited the sanitizer
compiler wrapper into external Clang oracles; the clean-PATH retry passes8/8.
The actual retry did not rebuild; a corrected full reproduction recipe is saved
separately. The independent reviewer finds no semantic change in the loop
restoration. Storage-address arithmetic is checked, including64bytes before
the first template; addresses alone do not prove alias causality. Second-control
timings and the third data-alignment candidate remain unaccepted/incomplete.

Candidate3 and reader batching review (2026-10-27): independent read-only source review found no correctness issue in the five storage-alignment changes or selected-count reader bounds. Native8/8, graph, dump and BSS+105088 receipts agree; no RSS/timing causality claim follows. Review requested a separate54/36 parser fixture and strengthening its out-of-range case to append an invalid index while retaining all valid indices. Both changes are implemented;12ASan/UBSan checks pass. Actual54-row measured campaign qualification remains pending.

Independent review confirmed the corrected54/36 synthetic test preserves every valid row while appending the invalid index. Candidate3 first48-child plain diagnostic was recomputed from raw captures: allstatus0, no major faults, qualified image/copy hashes and distinct physical copy inodes. Tail flags0/3 improve4.6647/4.0312% vs main; full flags0 costs0.89445% vs main and1.80505% vs main-again, while flags3 is mixed. No retention or neutrality follows from this single batch.

Outlined default64 tail source review (SHA4aa2b3b0004fc0104fd80459083a29470bd1568b25574f2e85ceed84e2d1ce6c): no correctness finding. Routed remainders are1..15, so casts and shifts are safe. Constant1/2/4quad kernels preserve bytes, offset masks, marked-end ordering and capacity bounds. Existing page-edge0..199 cases cover the4/5/8/9/15 cutoffs, preceding groups and every output combination. Cursor-address escape remains a codegen risk requiring inspection of the frozen native build; full-group source equality does not prove unchanged linked allocation or timing. LocalSan8/8 passes with exact644source hashes and41O1instrumented units; target-host qualification is pending.
