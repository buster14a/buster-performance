# Frozen next-main d3 native target receipts

[Native tests](next-d3-tests.log), [separate parser](next-d3-parser.log),
[build](next-d3-build.log), [image identity](next-d3-identity.log),
[source verification](next-d3-source-check.log),
[local source identities](../next-main-d3-local/IDENTITY.txt).
Exact d3c1d45d087f5b9ac1e54e2ba66248efa623f3d8 is the old416-based integration,
not main 321. Native build 41 passes; ten bounded groups pass, parser passes
separately, tracked source checksums match, and 673 implementation/test source
matches its qualified source. Native image is
c9c49e755ec9b7f6c7cc853f7ad7d7f9db5239e18af37c61a3418424f125cae0.
These receipts establish frozen functional/source identity, not new speedup or
latest-main/9794 compatibility. They remain separate from d74's 321+a11 union.

These are frozen publication/correctness receipts, not new performance results.
Original reports and CI JSON preserve their handoff status, not live PR state.
Historical timings remain attributed to their original source revisions.
See [publication method and supersession note](../publication-method/ARCHIVE-SCOPE.md).
