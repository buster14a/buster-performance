Large functions insertion-sort every local before assigning a bounded register pool. Builtin-generated functions can therefore spend quadratic time ordering locals that will never receive a register. This keeps the stable first 16 eligible candidates of each register kind in linear work, then uses the existing greedy assignment and save-mask rules. The vector rank path for at most 64 locals stays unchanged.

Fixes #664.

The implementation preserves unsigned-count ordering, earlier-local precedence on ties, preassigned homes and address-taken exclusions. Order scratch is 32 identities instead of a local-sized allocation; the final partial block forms its high-half home pointer only when that half has active lanes. Permanent tests compare candidates and complete homes/save masks with an independent full stable ordering, including guarded columns through 100,000 locals.

Current-head validation (based on main `321f5976`):

- Release build: all 41 units; backend syntax check passes.
- `test-tier0 --seed 664 --count 64 --cross-check --cross-count 12`: **95,965 checks, zero failures**.
- `test-x86-target-selection`: scalar/vector templates, Tier 0/Tier 1 selection and native SSE/VEX/EVEX kernels pass, including lower-profile rejection.
- CI and fresh current-head native qualification: pending.

[Immutable frozen qualification](https://github.com/buster14a/buster-performance/tree/4df43f7d7a685133b6beade655d9e9a306947081/docs/measurements/unclaimed-perf-2026-10-28/issue-664/target/README.md) compares `bc1b4861` with `be441ff8`: popcount 4k/8k Tier 0 time falls from 13.267/49.633 to 2.052/4.081 ms, with doubling growth changing from 3.74× to 1.99×. Objects are byte-identical and independent native runtime checks pass. Ordinary-input/vector controls are near-neutral; the scalar twin's 42.12→43.55 ns/entry cost is retained explicitly. These measurements describe those frozen revisions and are not timings of this rebased PR head.
