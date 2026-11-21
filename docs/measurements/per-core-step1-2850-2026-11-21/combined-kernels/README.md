# Combining operand lists with call checking

The packed operand list and the fused call rule together took **25.950 cycles per taken SQLite identifier or lookup** in lean mode, compared with 27.455 for the packed operands alone. The median paired difference was −1.503 cycles, with reductions in all four rounds. The complete pass including the given-record setup also improved in every SQLite round, by 0.310 cycles per window record. The given-only subtraction changed by +0.255 per window record. The Step 1 budget is 10.

The reference carries each lookup’s destination and first operand in one 32-bit entry. The combined kernel also finishes each call and its argument conversions together. The small-window variant executes up to 16 lookups directly in dependency order. The separated variant keeps 32 bytes of hot facts and 32 bytes of conversions in distinct columns and runs the same rules on those columns. Per-use argument conversions still write the secondary column. The independent comparer reconstructs records from the two columns after the untimed correctness runs.

| Input and record | factsoperands | factscombined | factssmall | factsseparated |
| --- | ---: | ---: | ---: | ---: |
| sqlite whole | 28.765 | 27.880 | 27.600 | 28.125 |
| sqlite lean | 27.455 | 25.950 | 26.830 | 26.475 |
| lua whole | 22.178 | 21.767 | 20.155 | 21.445 |
| lua lean | 21.693 | 21.040 | 19.357 | 21.100 |
| musl whole | 19.293 | 18.965 | 17.693 | 18.867 |
| musl lean | 18.713 | 17.793 | 16.415 | 17.768 |

Small windows helped whole SQLite, Lua, and musl. Lua lean reached 19.357 and musl lean 16.415. Separate hot and conversion columns gave the smallest SQLite lean median for the unsubtracted pass, 22.190 cycles per window record. Fused calls gave the smallest net cycles per taken lookup or identifier.

Each cell is the median of four symmetric round means on locked Ryzen 7 9700X CPU 2. Each process did five passes. Across 192 fresh processes, all taken records, lookup lists, and poison and decoy comparisons matched the reference for each corpus and mode. The small-window path completed more lookups directly in whole mode. On SQLite 214 required the general rule, compared with 316 in the reference. On Lua the counts were 26 and 56. SQLite lean retained 93,682 identifiers and 51,973 of 52,013 lookups. The [paired intervals and full/given-only measurements](paired.tsv), [individual observations](samples.tsv), [source and binary hashes](builds.tsv), and [diagnostic outputs](measurements.tar.xz) accompany the source patches.
