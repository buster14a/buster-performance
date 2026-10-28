# Final private main-241 functional composition

This local functional batch pins main `241fcb3e9a5a55d8ccc3dfffc7d9d0efd56bdda7`
and PR #678 `4b2a8a6f51cf8dee5a5833a8f32138d865d780b8` once. It does not publish
or modify any PR and establishes no new performance result.

Final disposition and exact positive/negative source scopes are in `RESULTS.md`.
The original nine-command matrix passed in both host modes, but the added ASM
suite found two generic test-expectation failures at the original freeze. Those
negative receipts and binaries are retained. A separate one-line test-only
correction was verified by focused actual-production-source adapters, including
the complete ASM suite, without repeating two whole compiler builds.

The source freeze is `4349d8fd` (full commit/tree in `source-identity.txt`). The
native checkout is `work/final-batch-241`; the separate generic checkout is
`work/final-batch-241-generic`, detached at exactly the same freeze. Native and
generic builds run sequentially through `cores -n 2`, with debug information
disabled; the generic build selects `BUSTER_HOST_ARCH=x86-64`.

Included publication pins:

| Slice | Exact head |
| --- | --- |
| #636 | 600262cbfac4a0917eea751d9b5c2ee9c14ee3b0 |
| #649 | 927c46e15cea9b95a5e2cb6c9119aaa04ce40d31 |
| #647 | b645da36951e15d7e4fbad6c5b800618e5e164d4 |
| #652 | a08583d3ef27672309a9f3ee42f1212ba4cab69d |
| #664 | 1eaf52025dd45c500e316fe6dc1a6dcaa28cd208 |
| #590 | d1a9070b300ed95f517d3373b6b70b6abc00fef7 |
| #674 | 40ea0a058513ca2933232cfc7d30f7c046576fbe |
| #657 | ed73205fa8298dffafdd8e4552a31e9a764fbc59 |
| #628/#641/#658 | 96a4ad102cb7882ba834374ddfcf38eac080b924 |
| #673 guardian correction | b1b3e490cde7639e2030619c7b0054f352327679 |

Excluded: unqualified #665 and the #628 bulk-fill experiment `95be46e6`.

Mechanical integration retains PR #678's host guards alongside bounded home
selection, recorded graph validation, warning metadata and prepared static
declaration scans. Both backend-startup and external-budget lane regressions
are retained. The newly added literal-table helper uses the same host guards
as previously validated private composition `d74d8736`; its implementation is
otherwise identical to that helper. No producer algorithm changes are made.

The new #113 reusable deferred-reader contracts were independently reviewed:
each reading refreshes its lane reader/input while retaining only memory
arenas. Nullable ASM remaps, per-lane warning-index resets, final warning-row
recounts, literal-table plan/part TypeId replay and immutable traversal metadata
are preserved. The worker-budget source is unchanged from reviewed `b1b3e490`;
initialization precedes source IO, guardian dispatch precedes dry-run handling,
and final close is outside terminal mapping-release guards.

Planned functional commands, on each executable through a fresh `cores -n 2`
grant: `test-checker --seed 241 --clang clang`, `test-checker-driver --clang
clang --executable ./build/compiler`, `test-checker-deferred`, `test-check-lanes
--seed 241 --executable ./build/compiler`, `test-preprocessor --clang --jobs 2
--seed 241`, `test-parser --clang clang`, `test-streaming --seed 241`,
`test-lanes --rounds 128 --seed 241`, and `test-tier0 --cross-check`.

Raw outputs, explicit command/status receipts and binary identities remain in
the `native/` and `generic/` directories. Historical timing records and prior
oracle failures remain separate from these exact-source functional results.
