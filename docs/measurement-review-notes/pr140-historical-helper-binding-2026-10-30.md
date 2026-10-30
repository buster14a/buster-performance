# PR #140: historical standalone-helper binding limitation

This additive review note qualifies the standalone replay and comparison-cost
claims in the [original intrinsic-filter packet](../measurements/intrinsic-filter-914-2026-10-30/README.md).
It addresses [review 5713257713](https://github.com/buster14a/buster-performance/pull/140#pullrequestreview-5713257713).
The original packet, including its README, tools, raw observations and checksum
manifest, is preserved unchanged. Read this note alongside that historical report.

## Missing historical binding

The packet retains the replay harness, recipes and run logs for `replay-base`,
`replay-fixed` and the separate `LOOKUP_COSTS` builds. It does **not** retain
the historical expanded build arguments, executable hashes, or an equivalent
build/transfer receipt that binds each measured standalone helper to its actual
`BUSTER_INTRINSIC_CATALOG` source path and revision. The reproduction recipe in
the original README is not such a receipt. The logs' `filter=1` marker does not
distinguish originally reviewed source
`6f5c0645096b01831f58cde3cec5449cbf2454ad` from corrected source
`60429e6479ee5f9ccbfb790dc86581a36c1279d2`.

Accordingly, the standalone warmed-replay timings and comparison-counter rows
are **observations of the recorded helper runs, without verified historical
executable, build-argument or exact-source binding**. In particular, the SQLite
roughly 32-to-9 ns/name observation must not be presented as an independently
verified exact-604 lookup improvement. The numeric logs, reductions, output
digests and comparison-count arithmetic remain retained observations; this
limitation narrows their attribution rather than changing those values. It
also applies to the standalone helper comparison costs on the small inputs.

No hash of a currently available or newly rebuilt helper can retroactively
supply the missing identity of a past measured executable. An authentic retained
historical receipt can be added and reviewed separately if it becomes available.
This note supplies no new build, measurement or reconstructed historical receipt.

## Separately bound evidence and remaining scope

The six shipping-compiler variants identified by
[`placements/binary-sha256.txt`](../measurements/intrinsic-filter-914-2026-10-30/placements/binary-sha256.txt)
and the two diagnostic adapters plus runner identified by
[`setup/binary-sha256.txt`](../measurements/intrinsic-filter-914-2026-10-30/setup/binary-sha256.txt)
are different artifacts. Their independently retained source/build, object,
binary and placement bindings remain applicable to their own results; they
do not identify the standalone replay or cost executables.

The shipping SQLite whole-compile observations still range from approximately
−0.521% to +0.104%, including a change of sign. They establish neither a
placement-independent whole-compiler gain nor neutrality. The complete
initializer measurements remain diagnostic adapter results, with the stated
clock, code-layout and instrumentation limitations; the small builtin input's
19–541 ns initializer regression remains visible. The independently bound
production disassembly retains its before/after gather evidence, but does not
bind the historical standalone timing executables. No source acceptance,
current-head qualification or closure of Buster #893/#914 follows from this
editorial note. The source owner's integration and broader acceptance work
remains separate.

## Immutable original identities

Original performance commit: `529141eef76c7e9ca9ead6171134dd2779ce3be8`.
Its repository tree is `4734a8f961c2d2e9b4b4774db5dc989c3b1dd3a5` and its
180-file packet subtree at `docs/measurements/intrinsic-filter-914-2026-10-30/`
is `bcb56eac1742e25161b86b34ecb89d3291452fc4` (Git object identities).

The following SHA-256 identities pin original file bytes, not missing helper
executables:

| Original packet path | SHA-256 |
| --- | --- |
| `README.md` | `87798588309b94a7bcaee82870213df5cf44b8efdd7f59eb0a9fe0e0f911fc0f` |
| `SHA256SUMS` | `4f94f58917e56074fdb34ca56947ae0fbbedb933affae6e24eaa1f1ee7b28d91` |
| `placements/binary-sha256.txt` | `df4cdc345bc1f42433a1d13bcb64a8748d7d1de1c8b79b63961236422923532b` |
| `setup/binary-sha256.txt` | `cae238a5d4a037f862654ae445bcfd0eb26c32ff44957bcaa9f57b5197fd33c5` |

The original manifest continues to cover its original 179 other packet files.
This note is outside that packet and outside the scope of that preserved
manifest. The Git commit adding this note records its own attribution and bytes;
it does not add or alter any historical human certification.
