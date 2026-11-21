# Integer arithmetic in source-owned predicates

Adding integer arithmetic and bitwise operations to the source producer removes 15,631 SQLite checker graph nodes at 4,737 predicates. Ordinary lowering emits 4,734 of them. This adds 523 predicates and 1,872 removed nodes to the [previous producer](../combined-predicates/). Across SQLite, the Buster translation unit, Lua and musl it removes 36,349 nodes at 10,990 predicates, of which 8,599 reach native lowering. [Coverage by workload and policy](coverage.tsv)

All 4,116 frozen-file and policy comparisons and nine fixture comparisons matched. The comparison includes the surviving checker records and operand edges, native instruction and ABI witnesses, ELF bytes, stdout, diagnostics and exit status. All 1,388 generated diagnostic comparisons also matched. [Diagnostic cases](diagnostics.tsv)

A Clang-linked execution test covers 4,000 combinations of signed promotions, unsigned wraparound, bitwise operations, and guarded volatile reads. The ordinary, debug and warning builds matched Clang's result checksum and 1,350 guard hits. Reversing branch sense changed the checksum. Separate fixtures exercise 3,120 short-circuit inputs and 2,100 fixed-ABI calls. [Runtime checks](executions.tsv)

The diagnostic compiler uses Buster `84a7d3d76`. The performance record for the earlier scalar producer uses separate Release images. [Source and receipts](source-and-results.tar.gz) · [Earlier producer costs](../combined-producer-cost/)
