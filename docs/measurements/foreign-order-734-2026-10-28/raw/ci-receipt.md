# CI receipt collected 2026-10-28

Source PR: https://github.com/buster14a/buster/pull/747

## Initial integration74430099d12c2dde80e1b7fd10c9973b93c1d901

Workflow: https://github.com/buster14a/buster/actions/runs/40772591383

| Check | Job | Conclusion |
| --- | --- | --- |
| Hosted native | 123113528459 | failure; own-translation-unit check |
| Hosted x86-64 | 123113528477 | success |
| Physical build prerequisite | 123119984842 | failure |
| Physical tests/benchmarks | 123119986830 | skipped |
| changes | 123113436612 | success |
| Measurement storage | 123113430314 | success (workflow40772591157) |

The native annotation says the repository translation-unit checker exits1.
The independent reviewer reports84/85 correctness commands passing, with
the two i64-index gather expansions rejected; the foreign matrix passes2113/0.
Exact finding: https://github.com/buster14a/buster/pull/747#pullrequestreview-5690176941

## Subsequent public head85629e6c4d616613ceb07124b95facee21c56449

Workflow: https://github.com/buster14a/buster/actions/runs/40777260992

| Check | Job | State at collection |
| --- | --- | --- |
| Hosted native | 123129761358 | in progress |
| Hosted x86-64 | 123129761273 | in progress |
| changes | 123129658216 | success |
| Measurement storage | 123129657695 | success (workflow40777261538) |

The coordinator's source correction and exact-source qualification ownership:
https://github.com/buster14a/buster/pull/747#issuecomment-6481872037

The measured foreign implementation remains732b7913. The changed856 conversion
helper has no transferred correctness count or whole-command timing claim.
Later CI state must be refreshed against the exact public head; this receipt
is a snapshot and does not assert landing readiness.
