# Function and file-scope source compilation

All 7,298 frozen SQLite external declarations compile with zero retained expression nodes in the unit graph. The 2,674 source function definitions use 319,280 local nodes, and 79 file-scope object initializers use the remaining 4,343. Their checked data includes the six-row floating point date conversion table. The same path emits the complete Buster object using 144,088 persistent nodes. SQLite writes its graph rows on demand, avoiding 59,986,388 cumulative bytes of preliminary clearing across its source roots. Filling these same temporary columns with 0xa5 still produced both reference objects. The mixed integer and floating initializer matrix matched all 92 comparisons. [Policies](edge-policies.tsv)

[Coverage and ELF hashes](native.tsv), [raw records](raw.tar.gz), [source](source.patch) and [independent-process replay](replay.py). Apply the source patch to Buster 0e1d5b825801135bf50e79da9d546bc95209ab30 and build the native compiler. The local qualification used a checker translation unit compiled at -O0 and the other Develop units. The optimized performance comparisons have separate build and machine receipts.

The independent ordinary compiler and the all-local path matched exact status, stdout, stderr, and the complete ELF or its absence on all 6860 source/policy pairs, including 863 expected failures. [SQLite](sqlite-policies.tsv.xz), [Buster](main-policies.tsv.xz), [Lua](lua-policies.tsv.xz) and [musl](musl-policies.tsv.xz).

[Local optimized end-to-end comparison](local-develop/README.md)
