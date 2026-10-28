Terminal C, `check`, and `-E` commands explicitly tear down their owned source mappings immediately before the process exits. This adds redundant teardown work to tiny invocations. Keep explicit cleanup in reusable command wrappers, and let ordinary process exit reclaim mappings only on main's terminal routes. Output files close and worker operations finish before return.

Adds repeated success/error reuse checks that require stable `VmSize` after both the source and preprocessor wrappers return.

Local validation of this PR head, based on main `321f5976`:

- Release build: 41 translation units passed.
- Driver: 21,653 checks, zero failures, including repeated success/error reuse.
- `test-parser --clang`: passed, including repeated `-E` and injected reservation-failure cleanup.
- Call graph: 41 translation units, zero disallowed cycles and zero split variables.

[Frozen 9700X evidence](https://github.com/buster14a/buster-performance/tree/4df43f7d7a685133b6beade655d9e9a306947081/docs/measurements/unclaimed-perf-2026-10-28/issue-652/target) compares cleanup-only `24e9c1f8` with `bc1b4861`. Isolated A/A, A/B and reversed B/A controls show about 13–14% lower empty syntax latency, 12% lower preprocessing latency and 6.4–6.7% lower tiny object latency; SQLite is neutral. These historical timings are not measurements of this PR head. Current-head CI qualification remains separate.

All implementation and added fixtures are original project material; no external code or fixtures were imported.

Addresses the release-at-exit direction in #652; arena reservation and page-policy setup remain separate work.
