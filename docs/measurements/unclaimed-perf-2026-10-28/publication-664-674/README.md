# Focused publication heads, 2026-10-28

User authorization to begin creating PRs was relayed by the coordinator.
Both publication worktrees start at main
`321f5976d5af2b4c54fa45a639895739f2b8a8c9`. Frozen experimental branches are
unchanged; rejected #451 code is absent from both publication diffs.

## #664

- Draft PR: https://github.com/buster14a/buster/pull/688
- Branch: `codex/664-bounded-register-homes`.
- Head: `1eaf52025dd45c500e316fe6dc1a6dcaa28cd208`.
- Production `tier0.c` is byte-identical to qualified `be441ff8`, including
  stable top-16 candidates and the guarded final high-half pointer.
- Current-head release build: 41 units; backend syntax check passes.
- Tier 0: 95,965 checks, zero failures, including external cross-checks.
- Current x86 target selection: Tier 0/Tier 1 and native SSE/VEX/EVEX paths pass.
- Observed after creation: open, draft, mergeable; changes/storage checks pass,
  9700X qualification queued.

## #674

- Draft PR: https://github.com/buster14a/buster/pull/690
- Branch: `codex/674-reader-graph-summaries`.
- Head: `40ea0a058513ca2933232cfc7d30f7c046576fbe`.
- Compact VALUE leaf counter and recorder functions exactly match the validated
  d3 integration. Other producers still validate; `--verify` checks reader
  summaries; append invalidation and rollback remain intact.
- Current-head release build: 41 units; checker syntax check passes.
- Focused graph ASan/UBSan: 6,411 checks, zero failures.
- Checker driver: 21,648 checks, zero failures.
- SQLite verified scalar/vector objects match SHA-256
  `1cafbadf926eed2245cb6a81ac1ee511f42d300995c2b2144c98e495d8c394d6`.
- Full checker: 474,515 checks, four familiar local Clang fpclassify
  conditional-selector/known-category oracle disagreements; not a full pass.
- Observed after creation: open, draft, mergeable; changes/storage checks
  starting. Native CI qualification remains pending.

Each PR was attached immediately through `attach_artifact`. Neither was merged
or force-pushed. The coordinator owns issue comments and later CI follow-up.
Descriptions link immutable evidence commit
`4df43f7d7a685133b6beade655d9e9a306947081` and explicitly keep frozen timings
scoped to their old revisions. #674 claims only the qualified frozen
eight-worker effect; its one-worker gain remains unresolved.
