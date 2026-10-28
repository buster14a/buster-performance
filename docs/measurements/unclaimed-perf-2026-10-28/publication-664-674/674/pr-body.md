The source reader already fills checker graph nodes in dependency order, but the scheduler rescans their cold columns to reconstruct purity and allocation facts. This records those facts as each preceding node is completed, flushes the final node and diagnostic-only prefix, and copies the retained purity bytes into the scheduler's mutable marks. Exceptional counters are updated only by nodes that contribute to them.

Fixes #674.

Other graph producers retain ordinary validation. `--verify` independently validates reader graphs and compares every summary counter and purity byte; mismatches roll back output, and appending a node invalidates the published summary. This port also records the current compact VALUE leaf count, matching the validated current-main integration protocol. Generated, guarded and source fixtures compare both validators and schedules; mutation tests cover stale metadata, purity, topology and rollback.

Current-head validation (based on main `321f5976`):

- Release build: all 41 units; checker syntax check passes.
- Focused ASan/UBSan graph checks: **6,411 checks, zero failures**, including recorded metadata, compact-leaf totals, rollback and guarded graphs.
- `test-checker-driver`: **21,648 checks, zero failures**.
- SQLite `--verify -c` succeeds with both schedules; objects are byte-identical (SHA-256 `1cafbadf926eed2245cb6a81ac1ee511f42d300995c2b2144c98e495d8c394d6`).
- Full local checker: **474,515 checks, four existing Clang fpclassify oracle disagreements** in the conditional-selector/known-category effect cases. This is not reported as a full-suite pass.
- CI and fresh current-head native qualification: pending.

[Immutable frozen qualification](https://github.com/buster14a/buster-performance/tree/4df43f7d7a685133b6beade655d9e9a306947081/docs/measurements/unclaimed-perf-2026-10-28/issue-674/target/README.md) compares `bc1b4861` with `7274e1bc`: eight-worker pinned SQLite throughput is 190.958→194.163 MB/s (+1.68% pooled). Unpaired ranges remain positive across actual checker-section placements and fresh executable copies, with balanced predecessor work and all faults retained. The single-worker gain remains unresolved. Those timings apply only to the frozen revisions; they are not transferred to this compact-leaf/current-main PR head.
