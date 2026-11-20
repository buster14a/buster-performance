# Filter and order Tier 1 callee offers

[PR #3143](https://github.com/buster14a/buster/pull/3143) compares [802ad72131](https://github.com/buster14a/buster/commit/802ad721317a7f36feb1bd78de10b0e2ba72ffd7) with [5004d01282](https://github.com/buster14a/buster/commit/5004d01282769d19cca9ff78631ec84197cb74ab).

The Tier 1 inliner inspects call instructions when deciding which callee summaries to offer. This change skips temporary keys and the body mark table for functions with no call descriptors, finds call opcodes 64 at a time, and visits their indices in source order. During compaction it records the symbol digits that vary. The existing radix sorter can skip constant digits, and already ordered lists can feed the consumer directly. The revocation rule still checks every direct call of a candidate against its signature.

In release SQLite, 2,544 offer preparations examined 562,963 IR nodes for 12,728 call instructions. Of these preparations 465 had no descriptors. Of 1,783 nonempty sorts, 623 were already ordered. Only one or two of the four radix digits varied in each. An independently instrumented parent reproduced the original SQLite and Lua objects.

Across eight alternating local pairs, SQLite release compilation retired 0.115% fewer instructions and the Lua parser retired 0.206% fewer. With debug information the reductions were 0.075% and 0.153%. Cycle results varied. The first version, which only filtered calls, saved 0.050% of SQLite release instructions.

All 1,336 frozen musl objects, 70 Lua/SQLite debug objects and two linked Lua interpreters remained byte-identical. The native inlining suite passed 125,265 checks including 22,432 independent executions. A separate 290-symbol fixture exercised ascending, descending, shuffled and repeated offers, indirect and replaceable calls, one to four lanes, and retained or replayed summaries. All 24 builds matched the corresponding parent object and the Clang runtime result.

Part of #2541. Stacked on #3130. The local measurements use the Ryzen 9 7940HS. Direct 9700X timing is pending.

The [offer census](offer-counts.tsv) and [per-sort symbol digits](radix-digits.tsv) use instrumented parent objects. The [290-symbol test](order/) compares preserved machine output and execution across the production and scalar diagnostic configurations. The [release](sort-normal-summary.txt) and [debug](sort-debug-summary.txt) files give the paired ranges for the production compilers.
