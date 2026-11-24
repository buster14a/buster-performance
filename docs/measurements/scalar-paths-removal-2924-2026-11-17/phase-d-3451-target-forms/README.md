# #3451 / #2924 phase D: the target forms' extended rows

The gate record of buster14a/buster's `claude/2924-3451-target-forms` PR. Session:
`session_01EgbxndFreFrJqAywiEGoue`.

`x86_target_forms` builds a target's byte table of allowed forms. Its vector loop reads one 32-bit compact word per form:
features 0 to 23, six more, an extended mark and the classified bit. The 221 rows that need a feature past that
projection (`BUSTER_X86_TARGET_EXTENDED`) carry the mark, which every target lacks. After the loop, a scalar pass over
their full 64-bit requirements decided them.

The PR deletes the scalar pass:
- **A rest word per form** (`x86_target_rest_requirements`) holds the 31 features the compact word doesn't project. It
  is 0 but for the extended rows. A static assertion requires the two words to hold every feature.
- **A compile-time bitset** of the blocks of 16 forms that hold an extended row (`x86_target_extended_blocks`) is built
  by expanding the rows file once per 64-bit word.
- **After main's loop, unchanged,** those blocks are decided again, 16 lanes at a time, by both words.

`dist.c` counts the layout at main `9da8765c5`: 8,358 forms in 523 blocks, and the 221 extended rows in 25 runs, in
29 blocks.

## Designs measured in the cloud container

Every design below read 0 mismatches. "Scalar pass alone" is main's loop without the pass, for its share only.

| design | new/old |
| --- | --- |
| scalar pass alone (main's loop without it) | 0.855 |
| a branch a block on its extended lanes, then a masked load of their rest words | 1.31-1.36 |
| the masked rest load and both tests in every block, branch-free | 1.40-1.43 |
| an unmasked rest load and a `vpternlogd` of both words in every block | 1.23-1.26 |
| **main's loop, then the 29 blocks from the bitset (the PR)** | **0.96** |

The pass cost main about 130 ticks of about 900, about 0.6 a row. In the second design, the branch was taken in 29
scattered blocks of 523, too irregular for the predictor. Reading a second 33 KB table every block cost more than the
whole scalar pass.

## The gate (9700X)

`gate.c` and `side.c` build one executable with main's `x86_target_forms.c` (old) and the branch's (new), each with its
tree's encoder:
- **Check:** both sides' tables compared over 2^20 random feature sets, every single bit, none and all.
- **Timing:** rdtsc ticks a call for four targets (none, features 0 to 22, all, and all but a few), 21 passes of 256
  calls alternating which side goes first, the medians.

`run.sh` ran three rounds under `exclusive.sh` on CPU 2, with clang 23.1.4 at `-march=znver5`. The log is
`logs/run.log`.

| round | none | low-23 | all | most |
| --- | ---: | ---: | ---: | ---: |
| 1 | 0.936 | 0.937 | 0.937 | 0.938 |
| 2 | 0.929 | 0.929 | 0.929 | 0.930 |
| 3 | 0.930 | 0.931 | 0.931 | 0.931 |

Mismatches were 0 over 1,048,642 feature sets in every round. The function's work doesn't depend on the target's size
(every call reads every form), so these four targets are its sizes.

## Tests and mutation

`test-x86-target` checks `x86_target_forms` against its definition from the full requirements
(`x86_target_test_definition`):
- every subset of every row's features;
- every single feature bit;
- the six profiles with each feature removed;
- reserved bits and an unaligned output.

Its policy part now also checks every form's rest word: its round trip to the row's features past the compact word,
bit 31 clear, and 0 for every row that isn't extended.

`mutation/run.py` builds and runs `test-x86-target` for each mutant:
- **`round1.txt`:** 5 of 6 killed:
  - the rest word's BF16 bit ignored;
  - only the first block of each word;
  - two rest features on one bit;
  - unknown rows allowed;
  - a block's bit at `% 63`.

  The sixth, the mark left in the extended test, did not build (an unused variable).
- **`round2.txt`:** that mutant rewritten (`run2.py`) and killed.
