# Round 20: pricing parity with main

[buster#3597](https://github.com/buster14a/buster/pull/3597)'s head c4085ccd2 (p8) compiles the 9700X job's sqlite3.c
in 82.5 M user cycles and 213.84 M instructions against main 1e1ca2dd6's 75.5 M and 195.79 M (round 19). The owner
asked for parity (2026-11-26). Builds are the 9700X job's (`BUSTER_HOST_ARCH=znver5`, Release) under the host lock,
the unit pinned to CPU 2.

## What a redesign of the expression checks could recover (`scripts/abl-a1.py`, `patches/abl-a1.patch`)

A1 is p8 with #3577's expression-side checks behind an opaque test (`cc->pos == UINT32_MAX`, never true and not
foldable, about an ideal gate's cost per site), main's own checks kept: the binary operators' operand gate and its
out-of-line check, unary operands, conditions, the implicit conversion's non-pointer cases and the own-type
shortcut (main's pointer gate kept), a bit-field's constant, an assignment's const-member record, precedence, a
string literal's `+`, a name's marks, a subscript's index and element, and the expression's end (-Wunsequenced, an
assignment or a parenthesized equality as a condition, a discarded value). sqlite3.c's object is p8's in both
configurations (host headers; the corpus's headers and pinned predefines).

`scripts/bp-abl.sh`, `results/bp-abl-a1.out`, rounds 2 and 3 of three, seven runs each:

| | user cycles | user instructions |
| --- | ---: | ---: |
| main 1e1ca2dd6 | 75.44 to 75.56 M | 195.79 M |
| p8 | 82.41 to 82.64 M | 213.84 M |
| A1 | 80.26 to 80.47 M | 209.64 M |

A redesign of those checks (a class per value and one table answer per operation, or any other) recovers at most
about 2.2 M cycles and 4.2 M instructions of the 7.0 M and 18.0 M. The rest by round 19's function deltas: the
expression's bookkeeping (the wider entries, the logging compile again, the operator's token) about 2 M cycles, the
statements about 0.85 M, the declarations about 1.2 M, the directives about 0.8 M, and the input the full
pipeline's answers bring in (fifteen more headers, the atomics branch) about 0.4 M, which is correct work.

## A main-side candidate: the call argument's copy (`scripts/bp-place9.sh`, `patches/p9-call-args-words.patch`)

main's own hot lines include copies of a 32-byte value just written in pieces, which a single wide load can't take
from the stores (`ex.call_args[ex.arg_sp++] = ex.vstack[--ex.vsp]`, 0.75 M and 0.37 M cycles at its two lines in
main). p9 moves the argument a word at a time (four 8-byte loads and stores, an empty asm keeping them apart), whose
loads each take one store of a name's or a literal's push. Over four placements of the checker's code
(`results/bp-place9.out`, rounds 2 and 3):

| offset | p8 | p9 |
| ---: | ---: | ---: |
| 0 | 82.20 M | 82.40 M |
| 1024 | 82.42 M | 83.55 M |
| 2048 | 82.49 M | 82.50 M |
| 3072 | 82.10 M | 82.96 M |
| mean | 82.30 M | 82.85 M |

0.55 M cycles worse, with 0.22 M more instructions. With round 19's p5 (the push as one 32-byte store), the second
fix of this family that lost: dropped.

## The budget

Against the 7.0 M cycle gap: the expression checks' redesign at most 2.2 M (realistically about half: the binary
gate's common case already costs about 22 ops, a table gate about 12), the declarations', statements' and
directives' checks' rewrite perhaps 1 M of their 2.9 M, the bookkeeping perhaps 0.5 M of its 2 M, the input none.
That is about 2.5 to 3.5 M, leaving +4 to +6% on sqlite3.c's direct compile; the main-side family tried here gave
nothing, and no other main-side candidate is priced.
