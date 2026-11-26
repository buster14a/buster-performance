# Independent frame-lifetime source audit and pipeline limitation

## Scope and revision

Audited `buster14a/buster` at **`8e4d32879e17b7d9548cad54257a2f8461328366`**. This is a read-only audit of the frame-object portion of #1384 and an investigation of the already-recorded pipeline test failures. No Buster source was changed, no test was waived, and no 9700X work was performed. The audit did not repeat the pipeline suite.

## Frame-object lifetime storage

**Observed in source:** [`tier1_emit_cfg_lifetimes`](https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_emit_cfg.c#L1352-L1424) groups IR slots in sets of up to 512. It allocates one reusable pair of 512-bit masks per CFG block, one worklist entry and one generation stamp per block, one record per lifetime marker, and one offset per slot group. It does not allocate a block-by-slot matrix.

With `B` CFG blocks, `M` lifetime-marker occurrences, and `S` IR slots, the requested temporary arrays total:

```text
128B masks + 4B worklist + 4B stamps + 8M markers + 4ceil(S/512) offsets
= 136B + 8M + 4ceil(S/512) bytes, plus alignment padding.
```

This bound describes the lifetime pass's temporary arrays, not whole-compiler memory or the caller's output columns. The pass restores its saved scratch-arena length before returning, on both success and allocation failure.

**Source-based inference:** [`tier1_emit_lifetime_row` and `tier1_emit_lifetime_group`](https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_emit_cfg.c#L1266-L1348) preserve the previous lifetime-hull semantics. Reverse marker order makes a block's final marker determine its exit state. Each newly live exit extends the hull to its block's end and every successor's entry, including a successor that immediately ends the lifetime. Seen/pending masks prevent repeated propagation of the same `(block, slot)` exit fact and duplicate queued entries while a block is pending. Unmarked slots and slots without starts retain whole-function intervals. The group identifier cannot wrap within the `uint32_t` slot-count limit.

The implementation initializes only rows reached by a marker or live edge in a group. Work depends on realized live facts and traversed edges; it is not an unconditional scan of every block for every group. This is not a claim that all possible live-range graphs or the whole compiler have linear time complexity.

## Existing regression coverage

**Observed in source, not new test executions by this audit:** [`tier1_emit_test_many_lifetimes`](https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_emit_test.c#L1243-L1318) constructs **2,049 short-lived slots**, **2,050 CFG blocks**, and **2,052 total slots**. The additional slots cover an end-only slot, a slot live through all loops, and an unmarked slot. It checks exact hull endpoints across back edges, a synthetic entry, and a partial final 512-slot group. The lifetime pass must fit **384 KiB** of temporary scratch; a second call with **128 bytes** must return `TIER1_EMIT_MEMORY` and restore the arena length.

The adjacent [`tier1_emit_test_lifetimes`](https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_emit_test.c#L1320-L1380) contains four native semantic fixtures, with 32 input samples per fixture. They cover shared rows for disjoint lifetimes, separate rows for overlap, a branch that ends a lifetime while another keeps it, and objects referenced only by lifetime markers.

No concrete remaining frame-lifetime storage or semantic defect was identified. This source audit is not a new execution of those regressions or a substitute for the separately recorded test runs.

## Pipeline cross-check: three actual failures

**Observed in [`tests/pipeline.log`](tests/pipeline.log):** the exact-main CI Release artifact's `test-tier1-pipeline --cross-check` run reported **3,959 checks, 3 failures, 1,088 native results, and 0 Clang results**. The failed assertions were:

1. `private subreaper collects the command, child and detached grandchild`
2. `setsid grandchild is also killed and reaped`
3. `both Clang optimization levels check every original fixture/input`

The command failed and must not be described as passing.

### Minimal capability probe

**Observed:** the standalone C probe in [`probe-frame-audit/proc_children.c`](probe-frame-audit/proc_children.c) successfully enabled `PR_SET_CHILD_SUBREAPER`, created a detached grandchild with `setsid`, adopted it after its parent exited, and reaped it with `waitpid`. Opening `/proc/self/task/<pid>/children` failed with **`ENOENT` (2)**. The observed output is retained in [`probe-frame-audit/proc_children.log`](probe-frame-audit/proc_children.log).

Thus the unavailable facility is the procfs children-list file. The probe does not support describing `PR_SET_CHILD_SUBREAPER`, `setsid`, or adoption/reaping as denied syscalls.

### Causal explanation from source

**Inference supported by the probe and source:** [`tier1_pipeline_reap`](https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_pipeline_test.c#L874-L916) first kills the command's original process group. It then reads `/proc/self/task/<pid>/children` to discover adopted descendants that changed process groups. The timeout fixture deliberately creates a `setsid` grandchild. The absent file prevents discovery and cleanup of that descendant, explaining the two cleanup assertions.

**Observed in source:** at [line 1749](https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/tier1_pipeline_test.c#L1746-L1763), Clang is invoked only if `cross_check && test.failures == 0`. The earlier cleanup failures therefore skip the oracle. The later assertion still requires the full Clang result count whenever cross-checking was requested, producing the third failure.

Consequently, **zero Clang results means the comparison was skipped; it is not an observed Clang mismatch**. The recorded native results remain valid observations, but no Clang cross-check success can be claimed from this command.

## Limits

The source changes addressing frame-object lifetime storage are already merged through [#3521](https://github.com/buster14a/buster/pull/3521). This audit adds no implementation claim. It does not establish 9700X throughput acceptance, and it does not convert an environment-limited failing test into a passing result. Historical PR measurements and historical differential runs, if cited elsewhere, must remain identified as those earlier sessions' evidence.

---
Audit task: `/root/frame_audit`
Parent session: `6b07ef94-8120-83eb-9da1-dd9f28574068` (OpenAI session ID; no share URL exposed)
Model: OpenAI / GPT-6 Astra Pro
