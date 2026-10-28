# Publication scope: issues 664 and 674

[Authoritative report](README.md), [664 published body](664/pr-body.md),
[674 published body](674/pr-body.md), [binary identities](binary-identities.sha256).
Both refresh on main 321. Issue 664 head 1eaf52025dd45c500e316fe6dc1a6dcaa28cd208
keeps qualified tier0 code byte-identical; build/syntax, 95,965 Tier0 checks and
ISA selection pass. Issue 674 head 40ea0a058513ca2933232cfc7d30f7c046576fbe passes
build/syntax, 6,411 sanitizer checks, driver and verified scalar/vector object
comparisons. Its full checker has four known local fpclassify disagreements,
not a full pass. Only the frozen eight-worker effect is qualified; one-worker
gain remains unresolved. No refreshed-main throughput gain is inferred.

These are frozen publication/correctness receipts, not new performance results.
Original reports and CI JSON preserve their handoff status, not live PR state.
Historical timings remain attributed to their original source revisions.
See [publication method and supersession note](../publication-method/ARCHIVE-SCOPE.md).
