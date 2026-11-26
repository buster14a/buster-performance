# Issue #1384: liveness audit and separate frame-address capacity finding

Date: 2026-11-26. Source revision: [`8e4d32879e17b7d9548cad54257a2f8461328366`](https://github.com/buster14a/buster/commit/8e4d32879e17b7d9548cad54257a2f8461328366).

Scope: read-only inspection of allocation liveness, `current_slots`, and frame-object lifetime storage, followed by bounded diagnostic compilations using the exact CI product identified by the parent validation record (workspace executable `ci-product/product/bin/compiler`). No production source changes or GitHub writes were made by this audit. These are cloud-host correctness and resource observations, not 9700X qualification or native timing evidence.

## Findings

The implementation no longer allocates the five full blocks-by-all-global-values bit matrices described by [#1384](https://github.com/buster14a/buster/issues/1384). Edge-local phi operands are excluded from global liveness; genuinely global values are processed in groups of at most 512; large block-group products use a sparse worklist. The forward spill-slot analysis likewise processes groups with rows only for touched blocks. This source audit found no remaining representation defect in those changes.

The new initialized-buffer/early-return fixture exposes a distinct capacity limitation. Lowering defines all frame-object addresses at entry, and selection retains those definitions when raw IR use counts prevent address-valued folding. Later calls therefore keep future scopes' address values live through earlier scopes. Early-return blocks interrupt layout coalescing, producing quadratically many actual live memberships and interval runs for the selected program. The explicit interval cap is the strongly supported explanation for the observed `cfg-allocation error=2`; its internal production counter was not directly observed.

The lexical objects have short lifetimes. The long address-value lifetimes are avoidable consequences of placement and selection, not a requirement of the C program. Address selection or rematerialization before liveness is the appropriate follow-up. This result does not demonstrate that the removed dense storage remains, and it occurs before #3521's frame-object lifetime analysis runs.

## Original liveness and `current_slots` audit

### Representation and algorithm

| Area | Audited behavior | Pinned source |
| --- | --- | --- |
| Edge-local phi operands | Every phi occurrence is examined. An operand passed from its own defining block stays local unless another occurrence or ordinary use makes it global. Promotion to global clears the edge-local flag. Local operands retain their home-to-edge tails. | [tier1_cfg.c:2684–2728][phi-classification] |
| Global grouping | The group width is 512 bits. Storage for the four dense working rows is at most 256 bytes per block, independent of the number of global groups. Phi occurrences are stored explicitly instead of a fifth dense `passed` matrix. | [dataflow.c:28–32][width], [tier1_cfg.c:1937–2022][live-setup] |
| Sparse threshold | Production chooses sparse groups when there is more than one group and `blocks * groups > 65,536`. Tests can force this path. The threshold bounds dense sweep work; it is not a total-memory cap. | [tier1_cfg.c:1705–1710][threshold], [tier1_cfg.c:1937–1944][group-choice] |
| Sparse propagation | Generation stamps initialize rows only when touched. Pending deltas propagate backwards through predecessors; definitions kill incoming propagation. Phi operands are included in predecessor OUT state. The result is counted and filled into ordered live lists. | [tier1_cfg.c:1766–1926][sparse-solve] |
| Realized live memberships | Later preparation enumerates the values actually live into blocks and transposes those memberships into per-value block lists. There is no unconditional allocation proportional to all blocks times all values. These lists can still be quadratic when the selected program itself has quadratically many live pairs. | [tier1_cfg.c:2885–2910][live-lists] |
| Spill-slot currency | Candidates are values with spill slots and non-home live entries. Groups contain at most 512 candidates. A row is created only for a live entry or spill fragment; predecessor intersection and a forward loss worklist establish which slots are current. Counting/filling visits touched rows; the next group releases its predecessor's rows. | [tier1_cfg.c:3283–3446][slot-solve], [tier1_cfg.c:3448–3573][slot-lists] |
| Failure handling | `current_slots` publishes its output only after success. Failure restores output and scratch and leaves previously published lists usable. | [tier1_cfg.c:3559–3573][slot-rollback], [tier1_cfg_spill_test.c:400–428][slot-regression] |
| Frame-object lifetimes | The lifetime solver groups slots by 512 and reuses one block-row workspace, with marker lists grouped by slot group. It no longer reserves a block-by-all-object matrix. | [tier1_emit_cfg.c:1350–1426][frame-lifetimes] |

The audit covered remote/local mixed phi occurrences, ordinary-use promotion, home tails, entry/definition handling, sparse predecessor propagation, generation-stamp behavior, ordered list construction, missing predecessor rows in slot currency, loop intersections, and rollback. No concrete correctness defect was identified. This is a bounded audit, not a proof that every compiler input is handled.

### Metric limitations

`liveness_bytes` on the sparse path reports `peak_rows * sizeof(Tier1CfgLiveRow)`, the largest number of rows touched by one group. However, `solver.rows` reserves capacity for `blocks` rows in the scratch arena. Rows are initialized on first touch. Consequently this field is neither total scratch capacity nor peak RSS, and should not be described as such. The reservation is still linear in blocks, with fixed-width rows. See [reservation at tier1_cfg.c:2009–2019][row-reservation], [initialization at 1766–1783][row-initialization], and [reported metric at 2154–2165][metrics].

`liveness_iterations` counts the first solve used to count memberships. Sparse worklist visits during the fill solve are excluded (`fill ? 0 : 1`), and dense multi-group fill re-solves are likewise excluded. The field is useful for comparing logical-solve work, but it is not a count of all executed solver visits. See [tier1_cfg.c:1841–1849][sparse-counter] and [2083–2092][dense-counter].

### Existing bounded regressions inspected

These are existing source-level gates, not new test runs performed when writing this report. The parent validation record contains suite execution results.

| Regression | Relevant bound and assertion | Pinned source |
| --- | --- | --- |
| Local phi storage | Widths 8, 65, 513, and 8,193; preparation has 8 MiB scratch. Checks zero/one global value, local-operand counts, bounded working storage, and exact home-tail intervals. | [tier1_cfg_test.c:2239–2247][phi-regression-sizes], [2336–2357][phi-regression-checks] |
| Nonlocal values | Ladder sizes 255, 511, 512, 1,100, and 20,000; 32 MiB scratch. Checks grouping, threshold choice, bounded working rows, and live lists against an independent per-value backward walk. | [tier1_cfg_test.c:2761–2777][nonlocal-regression-sizes], [2934–2954][nonlocal-regression-checks] |
| Sparse scoped loops | Sizes 1, 255, 1,200, 3,000, and 6,000. Checks the sparse threshold and independent walk; doubling the two largest sizes permits at most 2.2 times the first-solve visits and peak touched rows. | [tier1_cfg_test.c:2708–2759][loops-regression] |
| Forced-sparse equivalence | Every allocation case is rerun with sparse liveness forced; allocation fields compared by `tier1_cfg_differs` must agree, after normalizing the solver's byte/iteration counters. Generated live lists are separately checked against the per-value walk. | [tier1_cfg_test.c:1207–1232][forced-sparse], [2371–2516][walk-checker], [2518–2537][generated-lists] |
| Sparse spill-slot groups | 4,098 candidates across 10,245 blocks fit 768 KiB scratch. Checks exact sorted slot lists, loops with stores on one or both incoming arms, and rollback at 384 KiB without replacing the successful result. | [tier1_cfg_spill_test.c:313–328][slot-regression-shape], [400–428][slot-regression] |

## New frame-address fixture: direct observations

Each generated scope has this shape, with a distinct literal `i`:

```c
{
    unsigned char bytes[32] = {0};
    bytes[0] = (unsigned char)((unsigned)a + i);
    bytes[31] = (unsigned char)i;
    h_bytes(bytes, 32u);
    if (a == i) return (int)bytes[0];
}
```

This differs from the #3521 scope-local-address fixture, `{ char buf[32]; if (a == i) take(buf); }`: it adds initialization and stores, an unconditional call, and a subsequent conditional load/return. The parent separately reports the original `frame_local` shape passing through 32,000 scopes in both tiers; its [Tier 1 log](cases/frame_local-32000-tier1.compile.log) and [receipt](cases/frame_local-32000-tier1.json) are retained separately.

| Scopes | Direct result | Child peak RSS | Evidence |
| ---: | --- | ---: | --- |
| 4 | Strict Tier 1 compiles; assembly starts with four frame-address LEAs. Report has no rematerializations or dropped definitions. | Not separately recorded | [source](diagnostics/frame-unrolled4-audit.c), [IR](diagnostics/frame-unrolled4-ir.txt), [assembly](diagnostics/frame-unrolled4-tier1.s), [production report](diagnostics/frame-unrolled4-tier1.log) |
| 512 | Strict Tier 1 compiles, exit 0. Compiler report in the tool transcript has 506 rematerializations, 506 dropped definitions, 512 return tails, and zero fallbacks. | 68,404 KiB | [exit/RSS receipt](diagnostics/frame-audit-512.log) |
| 1,536 | Strict Tier 1 fails, exit 1. Tool transcript reports `cause=cfg-allocation error=2` with Tier 0 fallback forbidden. | 74,960 KiB | [exit/RSS receipt](diagnostics/frame-audit-1536.log) |
| 8,000 | Parent's strict Tier 1 run fails with the same diagnostic. | 673,788 KiB | [complete diagnostic](cases/frame-8000-tier1.compile.log), [exit/RSS receipt](cases/frame-8000-tier1.json) |

The N=512 and N=1,536 `.log` files are JSON wait4 resource receipts. Compiler stdout/stderr from those two invocations was returned in the tool transcript and was not separately retained as raw files. This report does not reconstruct complete logs. The N=8,000 log is the retained direct failure diagnostic. No extra tests were run to produce this report, and no linked execution was performed by this audit for the N=512/N=1,536 binaries.

The larger generated sources are reproducible using [validate1384.c](validate1384.c): after building that harness, run `validate1384 generate frame N FILE` with N=512, 1536, or 8000. The packet records generated-source digests in [source-manifest.sha256](source-manifest.sha256); the N=512/N=1,536 source files are not linked as separate packet artifacts.

The production assembly for N=4, lines 11–14, is:

```asm
lea (%rsp), %rax
lea (%rsp), %rbx
lea (%rsp), %rbp
lea (%rsp), %r12
```

Later scopes obtain their call pointers from the retained `%rbx`, `%rbp`, and `%r12` values. The identical eventual frame offsets show that frame coloring reuses the objects' storage; the separate entry-defined address values nevertheless remain allocated. In the promoted section of the retained IR (starting around line 326), `%0` through `%3` are the four entry `stack_addr` values. The scopes' continuing blocks alternate in layout with return blocks.

### Production source chain

1. [ir_lower_emit.c:73–75][lower-entry] emits all `IR_STACK_ADDR` nodes before body blocks.
2. [tier1_select.c:5952–5965][address-comment] states the distinction between shared memory folding and the single-use rule for address-valued roots. [Lines 6028–6035][address-leaf] apply `shared || forest->uses[node] == 1` to frame leaves. [Lines 7133–7155][address-conversion] invoke the address walk with `shared=false` for the relevant pointer conversions. Raw uses that memory patterns subsequently fold therefore still prevent this value-use folding.
3. [tier1_emit_cfg.c:842–862][production-definitions] preserves the original node's definition position. [Lines 872–880][production-uses] count selected effective uses, so the later argument conversion keeps the entry address live even though memory operands have folded it.
4. [tier1_cfg.c:2885–2910][live-lists] enumerates realized memberships. [Lines 3020–3038][interval-extents] derive each block range. [Lines 3062–3075][interval-merge] merge adjacent layout ranges only where permitted. Return blocks separate the continuing scopes.
5. [tier1_allocate.c:23–25][interval-cap] defines the 1,048,576 interval limit. [tier1_cfg.c:2986–3002][cap-guard] checks interval and split counts before filling arrays. [Line 2660][capacity-default] sets the default failure to `TIER1_CFG_CAPACITY`; [lines 3234–3245][prepare-rollback] return that error after rollback if preparation cannot finish.
6. [tier1_cfg.c:3830–3837][allocation-order] prepares liveness and intervals before assignment. [tier1_emit_cfg.c:2011–2045][drop-definitions] drops recomputed definitions using completed allocation data. Rematerialization recipes can therefore remove emitted definitions without preventing the preparation growth.
7. [tier1_emit_cfg.c:5250–5255][emit-allocation] must succeed before [5280–5283][emit-frame] invokes frame construction. Frame construction calls lifetime analysis at [1526–1528][frame-lifetime-call]. The observed CFG allocation failure is before that analysis.

## Derived explanation, not an observed internal counter

For N scopes, number the retained frame addresses from 1 through N. Under the observed entry placement and alternating continuing/return layout, the address used in scope j stays live through earlier continuing scopes but is dead in their return arms. Its layout ranges consequently contribute approximately j runs. The address-only growth model is therefore `N * (N + 1) / 2`, before accounting for ordinary values or any additional splitting.

This gives 131,328 address runs for N=512 and 1,180,416 for N=1,536. The latter exceeds the 1,048,576 cap even before other values are included. This calculation, the explicit cap, the small assembly, and the observed pass/fail results strongly support interval-cap exhaustion as the diagnosis. Low RSS at the N=1,536 failure also weighs against host physical-memory exhaustion. It does not alone exclude every arena-capacity path that shares error 2.

**Neither number is a captured production interval count.** No exact production threshold was measured. A child-process ptrace probe intended to inspect the counter was denied by the environment; no bypass was attempted. The strongest evidence retained is the source chain plus direct compilation outcomes.

The [N=4 allocation-adapter output](diagnostics/frame-unrolled4-cfg.txt) directly reports 249 values and 259 intervals, certification success, and `sparse liveness groups (#1384): same=1 differed=0`. Its ten excess intervals are consistent with six additional frame-address runs plus four argument runs. However, `test-tier1-cfg-source` adapts promoted IR through `tier1_cfg_from_ir` rather than using the production selected-machine problem: see [tier1_cfg_source_test.c:174–214][adapter-invocation] and [tier1_cfg_ir.c:4–26][adapter-model]. The exact adapter count must not be relabeled a production-emitter count. Its forced-sparse comparison is at [tier1_cfg_source_test.c:256–272][adapter-comparison].

## Follow-up options and scope

The narrowest promising fix is selection-aware sinking of a recognized stable frame address with exactly one remaining materialized value use. After folding memory operands, an address can have many raw IR uses but just one selected use requiring a value. Materializing it at that use would remove the entry-to-use lifetime without duplicating a shared LEA. Preserve the existing behavior when multiple selected value uses remain. Integration would involve the address walk and selected-use/coverage accounting at [tier1_select.c:8529–8621][selected-use-construction]; this is a design direction, not an implemented or validated patch.

A broader option is rematerialization of stable, input-free recipes before global liveness, so recipe-only spans need no allocated value. That needs explicit treatment of CFG edges, phi operands, allocation invariants, and certificates. Raising the interval cap or changing only return-block layout would leave excessive live-membership work and is not the preferred fix.

The original issue asks for storage and work proportional to actual live ranges rather than an unconditional blocks-by-values matrix. The new fixture has excessive actual ranges because of definition placement. It should be recorded as a distinct address-liveness/rematerialization issue, cross-referenced from #1384. This audit identifies no remaining implementation defect in #1384's representation changes; it does not supply the required native acceptance evidence or recommend treating cloud results as that evidence. The separate 9700X acceptance status remains for the parent task to resolve.

[phi-classification]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_cfg.c#L2684-L2728
[width]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/dataflow.c#L28-L32
[live-setup]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_cfg.c#L1937-L2022
[threshold]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_cfg.c#L1705-L1710
[group-choice]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_cfg.c#L1937-L1944
[sparse-solve]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_cfg.c#L1766-L1926
[live-lists]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_cfg.c#L2885-L2910
[slot-solve]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_cfg.c#L3283-L3446
[slot-lists]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_cfg.c#L3448-L3573
[slot-rollback]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_cfg.c#L3559-L3573
[slot-regression]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_cfg_spill_test.c#L400-L428
[frame-lifetimes]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_emit_cfg.c#L1350-L1426
[row-reservation]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_cfg.c#L2009-L2019
[row-initialization]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_cfg.c#L1766-L1783
[metrics]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_cfg.c#L2154-L2165
[sparse-counter]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_cfg.c#L1841-L1849
[dense-counter]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_cfg.c#L2083-L2092
[phi-regression-sizes]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_cfg_test.c#L2239-L2247
[phi-regression-checks]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_cfg_test.c#L2336-L2357
[nonlocal-regression-sizes]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_cfg_test.c#L2761-L2777
[nonlocal-regression-checks]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_cfg_test.c#L2934-L2954
[loops-regression]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_cfg_test.c#L2708-L2759
[forced-sparse]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_cfg_test.c#L1207-L1232
[walk-checker]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_cfg_test.c#L2371-L2516
[generated-lists]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_cfg_test.c#L2518-L2537
[slot-regression-shape]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_cfg_spill_test.c#L313-L328
[lower-entry]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/ir_lower_emit.c#L73-L75
[address-comment]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_select.c#L5952-L5965
[address-leaf]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_select.c#L6028-L6035
[address-conversion]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_select.c#L7133-L7155
[production-definitions]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_emit_cfg.c#L842-L862
[production-uses]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_emit_cfg.c#L872-L880
[interval-extents]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_cfg.c#L3020-L3038
[interval-merge]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_cfg.c#L3062-L3075
[interval-cap]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_allocate.c#L23-L25
[cap-guard]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_cfg.c#L2986-L3002
[capacity-default]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_cfg.c#L2658-L2662
[prepare-rollback]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_cfg.c#L3234-L3245
[allocation-order]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_cfg.c#L3830-L3837
[drop-definitions]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_emit_cfg.c#L2011-L2045
[emit-allocation]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_emit_cfg.c#L5250-L5255
[emit-frame]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_emit_cfg.c#L5280-L5283
[frame-lifetime-call]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_emit_cfg.c#L1526-L1528
[adapter-invocation]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_cfg_source_test.c#L174-L214
[adapter-model]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_cfg_ir.c#L4-L26
[adapter-comparison]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_cfg_source_test.c#L256-L272
[selected-use-construction]: https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_select.c#L8529-L8621

---
Audit task: `/root/liveness_audit`
Parent session: `6b07ef94-8120-83eb-9da1-dd9f28574068` (OpenAI session ID; no share URL exposed)
Model: OpenAI / GPT-6 Astra Pro
