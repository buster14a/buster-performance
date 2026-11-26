# Tier 1 dispatch-latch convention investigation (#2553), 2026-11-26

Work in progress for [buster#2553](https://github.com/buster14a/buster/issues/2553) and
[draft PR #3631](https://github.com/buster14a/buster/pull/3631).

- Baseline: `8e4d32879e17b7d9548cad54257a2f8461328366`, tree `8bf0a22e6067a7698ca6257d3e6cbe40f49b108a`.
- Initial candidate: `d3d8ad3bc7373a58e62b3eb3ecb32a0001c61167`, tree `0a158931bbb8bc34e2c951870bd83ca1cdfaa9f8`.
- Scope: a loop latch phi whose inputs mostly carry the successor/header phi unchanged;
  use an earlier matching predecessor's exit convention instead of a cold nearest-layout operand.
- Status: focused and full allocator regression checks pass. Workload measurements and investigation remain in progress.
  This record does not establish the issue's hardware acceptance criteria.

## Correctness evidence

[The validation record](validation/README.md) includes the original C driver, exact commands, hashes and retained logs for 107,813 full-suite checks and 304 focused checks, including sanitizer and negative-control runs.

## Input snapshots

`scripts/snapshot-after-tags.patch` adds a temporary CFG-input snapshot writer after the tag patch. It records every input column, the borrowed dominator analysis and an allocation fingerprint. This is a same-ABI trusted-input debugging format tied to the source revisions above. Set `BUSTER_TIER1_CFG_SNAPSHOT` to an existing directory plus a filename prefix; the existing minimum block count controls capture. It is measurement-only code and is not proposed for the compiler.

Snapshot patch SHA-256: `656418dbd5638bbd47ccf7a7f8e4f54a20018b8227c59aba212626f240f98889`.

## Instrumentation provenance

`scripts/kinds-main-8e4d3287.patch` ports the existing origin tags and CFG dump from
[`3f5909d86842bdd012f89a28afd9a5477ffc49a1`](https://github.com/buster14a/buster-performance/blob/3f5909d86842bdd012f89a28afd9a5477ffc49a1/docs/measurements/tier1-current-slots-2553-2026-11-23/scripts/kinds-main-747fbeff.patch)
to the exact baseline. The port preserves the current CFG/verification arguments in two changed call contexts;
the tag meanings and classifier are unchanged. It changes only temporary measurement builds, not the production PR.

SHA-256: `6d6a015f4e0bb0a082d377d05c48bb1082604b3e8d6f8fb58ebd51d0461605c1`.

Build with `BUSTER_BUILD_DEFINES=-DBUSTER_TIER1_MEASURE_KINDS`.
Set `BUSTER_TIER1_KINDS` to the output sidecar path. For allocation dumps, set both
`BUSTER_TIER1_DUMP_BLOCKS` (minimum function block count) and `BUSTER_TIER1_DUMP_FILE`.
The historical tags are `e/T/U` for phi edge moves/stores/reloads,
`h/t/u` for live-in edge moves/stores/reloads, `x` for scratch moves,
`S/L` for spills, and `C/R` for call saves/restores.

No native hardware has been accessed or queued by this session. Hosted/Linux instruction counts, when recorded,
will be identified separately from hardware timing. The 9700X is excluded by the session's constraint.

Original additions use Apache-2.0 WITH LLVM-exception; the instrumentation's existing notices and provenance are retained.

Agent session: 6b07eefe-ecbc-83eb-8e50-5060ad2a8075 (OpenAI session ID; no share URL is exposed).
Model: OpenAI / GPT-6 Astra Pro.
