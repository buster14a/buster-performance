Deeply nested cases and gotos repeatedly walked their shared outer ancestors while checking GNU statement-expression entry rules. Stop at the first target subtree containing the source, and skip the walk when the unit has no regions. The scalar path retains the full parent walk as an independent diagnostic oracle.

Reuse the reader's shared `postorder_positions` and `subtree_sizes`; the default tree-only parser path needs no optional parser size column or extra size pass. Added coverage compares every token pair across nested/sibling regions on normal/tree-only and scalar/vector schedules, checks null metadata for a zero-region unit, and bounds repeated transfers through a 65,536-deep chain. Source fixtures cover jump legality against Clang.

Local validation of this head on main `321f5976`:

- Release build: all 41 translation units passed.
- Focused region equivalence and deep-regression checks: 12,332 checks, zero failures.
- Driver: 21,648 checks, zero failures.

[Frozen 9700X qualification](https://github.com/buster14a/buster-performance/tree/4df43f7d7a685133b6beade655d9e9a306947081/docs/measurements/unclaimed-perf-2026-10-28/issue-657/target) compares `bc1b4861` with `086c24b1`: depth-16k check-input is 508.544→23.359 ms for plain switches, 516.750→24.900 ms inside a statement expression, and 130.889→15.179 ms for local region-wrapped gotos. All 55 object pairs match. These are targeted stage measurements of those frozen revisions, not whole-compile throughput measurements of this later head; current-head CI qualification is separate.

Fixes #657.
