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

## Alternative stores for repeated target symbols

Three implementations use the import-presence bit from the previous trials. The split variant records direct references and calls in separate byte columns. The clear variant checks symbol type before marking one byte. The binary variant builds the output bitset on its first useful mark and counts it with vector population counts. All three matched the independent bitmap on all 675 fixtures, with guarded and aligned source columns. Each cell counts sizes at parity or better against the shipping vector-plus-tail stage, out of 135.

| Variant | Placement | No imports | Mixed | All direct | Repeated calls | Indirect only |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| split | guarded | 135 | 127 | 132 | 132 | 135 |
| split | aligned | 135 | 127 | 132 | 132 | 135 |
| clear | guarded | 135 | 131 | 132 | 132 | 135 |
| clear | aligned | 135 | 131 | 133 | 133 | 135 |
| binary | guarded | 135 | 133 | 101 | 96 | 135 |
| binary | aligned | 135 | 133 | 104 | 99 | 135 |

The new stores recover most of the repeated-call cases. The short and mixed lists still miss parity. Full scalar comparisons are also present in every raw row. [Implementations, oracle and native samples](mark-stores.tar.xz)

## Keeping candidate targets in one packed bitmap

The linker already counts names resolved from shared libraries when sizing its output tables. That count now lets both serial and parallel handoffs skip copy discovery when no name can be shared. A positive count can include a discarded name. The final bitmap intersects candidates with the actual symbol sources. All relocation kinds, including the last partial cache line, use the same masked classification. The first 64 targets fit in a register, and a reference to a higher target initializes the single packed scratch bitmap. Its population is the number of symbols that need copies.

The 9700X gate covered 135 fixup counts including zero through 96 and boundary counts through 16,384, five relocation distributions and two memory placements. Three processes supplied nine interleaved measurements per cell. The output count and bits were compared with independently computed expectations. The normalized production function and the measured 32-bit bitmap version generated identical native instruction bytes. All 1,350 cells passed against both original paths. Ratios below divide candidate cycles by baseline cycles.

| Placement | Shape | Sizes | Median vs vector | Slowest vs vector | Median vs scalar | Slowest vs scalar |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| guarded | No imports | 135 | 0.643 | 0.812 | 0.250 | 0.458 |
| guarded | Mixed | 135 | 0.626 | 0.981 | 0.381 | 0.532 |
| guarded | All direct | 135 | 0.472 | 0.666 | 0.572 | 0.789 |
| guarded | Repeated targets | 135 | 0.530 | 0.660 | 0.557 | 0.871 |
| guarded | All indirect | 135 | 0.290 | 0.545 | 0.056 | 0.317 |
| aligned | No imports | 135 | 0.667 | 0.800 | 0.250 | 0.439 |
| aligned | Mixed | 135 | 0.631 | 0.963 | 0.388 | 0.542 |
| aligned | All direct | 135 | 0.470 | 0.674 | 0.580 | 0.788 |
| aligned | Repeated targets | 135 | 0.529 | 0.727 | 0.607 | 0.873 |
| aligned | All indirect | 135 | 0.299 | 0.647 | 0.063 | 0.326 |

The complete linker tests exercised 64 input alignments, promotion across bit 63, the final partial batch, calls to an imported function, direct uses of data and duplicate targets. The copy-relocation suite passed 377 checks and the independent GCC/ld.lld corpus passed 110 checks. Eight mutations changed either the population or the expected marks and were rejected. At one and eight lanes, each Buster executable was byte-identical to its baseline. The Lua, SQLite and musl programs ran with the same output as ld.lld’s executables.

The complete link comparisons used seven paired rounds of six links. The initial producer collected the hint during name publication. Reusing the capacity count removed that work. The last column includes the final packed bitmap and the new regression tests, on top of main cc7d4ffb4. Each percentage is a median paired change in user cycles compared with the original executable.

| Corpus | Lanes | Initial producer | Capacity and byte marks | Capacity and packed bits |
| --- | ---: | ---: | ---: | ---: |
| lua | 1 | +0.403% | -1.030% | -0.935% |
| lua | 8 | +0.417% | -0.958% | -1.002% |
| sqlite | 1 | +0.158% | -1.452% | -1.463% |
| sqlite | 8 | +0.058% | -1.304% | -1.617% |
| musl | 1 | +1.827% | -1.014% | -0.970% |
| musl | 8 | +0.652% | -0.964% | -1.042% |

[Gate source, alternative implementations, mutation receipts, native checks, phase timings, linked-image hashes and complete-link results](packed-copy-marks.tar.xz)
