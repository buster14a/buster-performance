# Final source qualification for PR 3257

The normal and warning-enabled source campaigns compared 2,830 exact status, complete diagnostic-stream and whole-ELF results with true mainline parent 9be958d5c61538562177a788a76c8c23dead9694. The candidate was a884290a63ab5aac84fd9e29f0501737ddabfb40. Each policy covered SQLite, all 34 Lua sources, all 1,336 musl sources, Buster's own compiler, four generated or focused units, and 39 checker fixtures. Rejected fixtures preserve their original diagnostic and status. Member names in the compressed tables are repository- or corpus-relative.

The separate multi-input runs selected the same translation units inside one compiler process and compared 1,438 emitted member-object pairs as well as full diagnostics. They covered all musl sources together, plus all Lua sources under ordinary, warning-enabled and poisoned-arena policies. The pinned Clang 23.1.4 suites for the shipping checker and driver completed all eight seeded shards each; individual summaries are included.

[Production PR](https://github.com/buster14a/buster/pull/3257)
[Exact locked hardware and raw checked-column verification](https://github.com/buster14a/buster-performance/tree/1da68ec2a57682c29a23486a825f49009dd3fc20/docs/measurements/window-compile-2850-2026-11-21/a884290a6)
