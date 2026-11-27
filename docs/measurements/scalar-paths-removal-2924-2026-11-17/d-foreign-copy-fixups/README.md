# Foreign linker copy relocations and the last fixup group

The vector path marks possible copy relocations in groups of 16 fixups and visits the remaining rows one by one. The measured checkout includes the directive classifier in #3670. [Compiler baseline](https://github.com/buster14a/buster/tree/2e4400b66b351a989625acbcb80ba079cbb31310) · [Issue #3453](https://github.com/buster14a/buster/issues/3453)

The foreign-link tests entered the vector copy-discovery stage 97 times. Of these 77 reached fixup marking after finding an import. The 1,182 visited fixups included 622 scalar-tail rows. The exact path reached marking 76 times. The copy-relocation oracle passed 249 checks. GCC-built C and C++ PIEs also reached the tail on both one-lane and eight-lane links. The C executable had 483 fixups and 3 tail rows. The C++ executable had 309 fixups and 5 tail rows. The corpus compared executable behavior and ELF results to ld.lld and passed 110 checks. The separate general foreign suite recorded 33 DWARF debugger failures in this environment.

Each locked 9700X run used five input shapes and 135 fixup counts, from zero through 16,384, with three process repetitions and nine in-process samples per side. Each candidate was compared with the original vector-plus-tail and the full scalar walk. A separate eligibility computation checked the entire output bitmap. Guarded inputs end at a protected page. Aligned inputs follow the 64-byte alignment of the linker's own columns.

The first three candidates measure fixup marking alone. The last three time the complete discovery operation, including the old path's symbol-to-bitmap preparation, clearing and final count. Two experiments assume an import-presence bit from the name producer. Their timings exclude collecting this bit on the name-publication paths, which would also need qualification before shipment. Each cell counts the sizes with a median at or below the original vector path. The archive includes all scalar comparisons.

| Candidate | Layout | No imports | Mixed | All direct | Repeated calls | Indirect only |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| Masked load | Guarded | 0/135 | 5/135 | 25/135 | 5/135 | 11/135 |
| Expand load | Guarded | 0/135 | 5/135 | 25/135 | 6/135 | 9/135 |
| Aligned fixup groups | Guarded | 2/135 | 4/135 | 23/135 | 8/135 | 9/135 |
| Aligned fixup groups | Aligned | 6/135 | 42/135 | 40/135 | 72/135 | 82/135 |
| Direct symbol lookup | Guarded | 0/135 | 135/135 | 112/135 | 104/135 | 100/135 |
| Direct symbol lookup | Aligned | 0/135 | 135/135 | 111/135 | 100/135 | 101/135 |
| Per-symbol marks | Guarded | 135/135 | 123/135 | 131/135 | 131/135 | 106/135 |
| Per-symbol marks | Aligned | 135/135 | 123/135 | 131/135 | 131/135 | 105/135 |
| Count first marks | Guarded | 135/135 | 135/135 | 100/135 | 97/135 | 135/135 |
| Count first marks | Aligned | 135/135 | 135/135 | 102/135 | 107/135 | 135/135 |

Masked loads that span into a protected page were especially slow at one fixup. Aligning the loaded address and reading the symbol source directly removed this penalty. Direct lookup beat the original at all mixed-input sizes but regressed when the input had no imports. Counting first marks with the producer hint covered all empty, mixed and indirect sizes in both layouts. Dense and duplicate-heavy groups still missed the gate at several sizes. The existing compiler route remains in use. [Implementations, raw data, reach and correctness receipts](copy-fixups.tar.xz)
