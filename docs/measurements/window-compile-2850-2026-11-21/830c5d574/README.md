# Function and file-scope source compilation

Moving 78 SQLite file-scope objects into checked source-local images leaves one aggregate containing 24 floating and integer literal nodes in the unit graph. In Buster, 285 file-scope objects account for 810,627 retired nodes. The growing graph reserves 8,192 SQLite nodes and 262,144 Buster nodes. The three source-local lists have peak capacities of 343,284 and 5,052,696 bytes respectively. The negative initializer matrix matches 76/76 outcomes. [Floating, integer, address, compound and diagnostic cases](edge-policies.tsv)

[Coverage and ELF hashes](native.tsv), [raw records](raw.tar.gz), [source](source.patch) and [independent-process replay](replay.py). Apply the source patch to Buster 0e1d5b825801135bf50e79da9d546bc95209ab30 and build the native compiler. The local qualification used a checker translation unit compiled at -O0 and the other Develop units. The optimized performance comparisons have separate build and machine receipts.
