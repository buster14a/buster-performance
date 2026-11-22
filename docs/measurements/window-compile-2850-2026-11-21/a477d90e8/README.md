# Function and file-scope source compilation

Preserving the initializer planner’s events and attached notes fixes both automatic and static-duration overridden initializers. All 92 case/policy comparisons and all 21 linked default cases match. Warnings promoted to errors suppress output in both compilers. [Inputs and policies](initializer-policies.tsv)

[Coverage and ELF hashes](native.tsv), [raw records](raw.tar.gz), [source](source.patch) and [independent-process replay](replay.py). Apply the source patch to Buster 0e1d5b825801135bf50e79da9d546bc95209ab30 and build the native compiler. The local qualification used a checker translation unit compiled at -O0 and the other Develop units. The optimized performance comparisons have separate build and machine receipts.
