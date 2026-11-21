# Source argument cache and provisional types

The argument cache associates each entry with its producing window, so the producer can advance a generation instead of clearing the entire cache for every window. A separate mode avoids a repeated type-table lookup on an already-known request. A third gives the synchronous reader a private type-table view for provisional pointer types. The latter appends only beyond the ordinary table's count, then drops the view. A separate correctness mode hashes the complete canonical index before and after each use.

| Corpus | Argument generation, preparation | Argument generation, all intervals | Unindexed view, all intervals |
| --- | ---: | ---: | ---: |
| SQLite | −6.21 | −2.23 (2/3 lower) | +2.71 (0/3 lower) |
| Lua | −14.35 | −9.43 (3/3 lower) | −0.35 (2/3 lower) |
| musl | −23.93 | −17.74 (3/3 lower) | +4.00 (0/3 lower) |

The values are median paired changes in invariant TSC ticks per swept source record. All three paired preparation observations improved in each corpus with generations. The unindexed view is an ownership experiment. SQLite and musl slowed in all three paired sums when it was enabled. The intermediate fast-request variant moved the all-interval median by −0.03 (SQLite), +0.80 (Lua) and −0.57 (musl). The measured entry point was the same instrumented source shadow as the parent record.

Locked CPU 2 ran 72 full-corpus observations, three rounds of four modes forward and reverse, rotating the starting mode each round. The paired reference and native receipts were identical in every observation. Four frozen corpora under default, Wall/Wextra and Weverything policies also matched every witness between the indexed and unindexed modes, including the index-integrity check. See [pairs](pairs.tsv), [all observations](samples.tsv), [native counts](oracle.tsv), [policy comparisons](policies.tsv) and the [raw checks](correctness.tar.xz).

The 400 generated driver compiles compare 20 inputs, five policies and four modes. They include a correction needed by the independent source-to-native consumer when a local VLA's stack slot already holds its address. Six comparisons had disagreed in the earlier experiment. With the correction all 400 matched in exit status, stdout, diagnostics, ELF and the full graph. The locked experiment used [source.patch](source.patch) alone. Apply [vla-address.patch](vla-address.patch) after it to reproduce the separate driver comparisons using [fixtures.py](fixtures.py).

The parent directory contains the host identity, common build helpers, and reducer. Extract [the raw sample counters](raw-counters.tar.xz) and pass the extracted directory, an empty output directory and `overlay` to that reducer.
