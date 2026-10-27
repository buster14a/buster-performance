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
output. Review of the revised reader and its final positive/mutation checks
remain pending. The measurement controller and raw data are unchanged.
