# Round 21: loads of values just written in pieces, and placements that sample alignment

[buster#3597](https://github.com/buster14a/buster/pull/3597)'s head p8 (c4085ccd2) against main 1e1ca2dd6, toward the
owner's ask for parity (2026-11-26). Builds are the 9700X job's (`BUSTER_HOST_ARCH=znver5`, Release) under the host
lock; sqlite3.c with the host's headers, pinned to CPU 2, `perf stat -r 5` cycles:u and instructions:u, rounds 2 and 3
of three.

## Where main's and the head's cycles wait (`scripts/mainstall.py`, `scripts/rangediff.py`, `results/main-stalls.txt`)

From round 19's unthrottled profiles (cycles every 100,000, IBS ops every 262,144, 300 compiles a side): per line,
cycles beyond ops at main's mean rate (0.453 cycles an op). Main's largest are its identifier lookup (5.3 M cycles over
`fast_ident_lookup`'s lines and 1.7 M in `fast_ident_intern`, which #3583 measured: perfect lookups save 0.57 ms of the
lexing stage and ten designs saved nothing) and copies of a value just written a field at a time (`call_args`' two
copies 1.1 M, the expression's final value 0.49 M, the subscript's operands 0.35 M, a static constant's return 0.29 M).
The head added more of the second kind, found by comparing function ranges line by line:

| head line | head | main | what |
| --- | ---: | ---: | --- |
| `ex->vstack[ex->vsp++] = res;` (assignment) | 0.94 M | 0.00 M | a local written by fval_store in four stores and three field stores, copied whole |
| `const FastTok bt = body[i];` (`#define`) | 0.41 M | 0.00 M | the kind and flags loaded as one word over the first token's one-byte flags store |
| `ftype_from_index` | 0.46 M | 0.08 M | Clang widened the kind's byte load to four bytes, over three stores of a new record |

## The fixes (`patches/`)

- q2 (e9aa37581): an assignment's result written where the left operand stands, as the binary operators' are; the
  subscript reads its operands in place.
- q4 (d9df83bfc): a define's first token written again whole (one 8-byte store; an empty asm keeps Clang from
  narrowing it back to the flags' byte).
- q5 (3e20301fe): call arguments stay on the value stack, live while the call is emitted (main's copy, too).
- q6 (586a174e3): `ftype_from_index` loads the kind's byte (an empty asm keeps the load a byte).
- q7 (cf0505bb5): the argument stack and its scans removed.

Each keeps sqlite3.c's object (host and corpus configurations), every file's result and bail reason over `tests/`,
c-testsuite and musl, and the probe sets.

## Measurements

The first two sweeps moved the checker's code by 0, 1024, 2048 and 3072 bytes (`scripts/bp-placeq.sh`,
`scripts/bp-placeq5.sh`): multiples of 64, which change its page offsets but not its alignment within cache lines and
fetch windows, so an arm's own size change went unaveraged. The same p8 build already spans 82.04 to 82.90 M cycles
over those four page offsets.

| sweep (rounds 2 and 3) | main | p8 | q2 | q5 (q2, q4, q5) | q6 (+ q6) |
| --- | ---: | ---: | ---: | ---: | ---: |
| 1, four page offsets (`results/bp-placeq.out`) | 75.46 M | 82.13 M | 81.84 M | | |
| 2, four page offsets (`results/bp-placeq5.out`) | | 82.41 M | | 82.93 M | 81.93 M |
| instructions | 195.79 M | 213.84 M | 213.65 M | 213.36 M | 213.36 M |

q5 read 0.5 M cycles worse than p8, and q6, one byte load more, 1.0 M better than q5 at the same instructions: the
alignment q6's size moved, not the load. The third sweep (`scripts/bp-alignq.sh`, `results/bp-alignq.out`) moves the
code by 0, 528, 1056, ... 3696 bytes, 16-byte steps within 64 bytes across the pages, with main in the same hold:

| offset | main | p8 | q7 |
| ---: | ---: | ---: | ---: |
| 0 | 75.53 M | 82.29 M | 81.61 M |
| 528 | 75.54 M | 82.44 M | 82.58 M |
| 1056 | 75.62 M | 82.39 M | 82.09 M |
| 1584 | 75.53 M | 82.16 M | 81.89 M |
| 2112 | 75.72 M | 82.83 M | 82.28 M |
| 2640 | 75.71 M | 82.96 M | 82.36 M |
| 3168 | 75.75 M | 82.47 M | 82.02 M |
| 3696 | 75.53 M | 82.21 M | 82.14 M |
| mean | 75.61 M | 82.47 M | 82.12 M |
| instructions | 195.79 M | 213.84 M | 212.53 M |

q7 is lower at seven of the eight placements: 0.35 M cycles and 1.31 M instructions less than p8, of which the
argument stack's scans (q7 against q6) were 0.83 M instructions. The line profile had put 0.94 + 0.41 + 0.38 M cycles
on the head's three stalls and 1.1 M on main's argument copies; what came back is about a fifth. The head now runs
+6.51 M cycles (+8.6%) and +16.74 M instructions (+8.5%) over main.

## What it leaves

- Main's identifier lookup is its largest wait, and #3583 measured it: perfect lookups save 0.57 ms of the lexing
  stage, and ten designs of the lookup saved nothing.
- The expression's final value copied to the caller (0.48 M at its line, main's too), a static constant returned by
  copy (0.3 M), the redeclaration check's random load of the previous symbol's record (0.27 M), the attribute names'
  `memcmp` (0.14 M): at a fifth of their line excess, about 0.2 M together.
- The expression-side checks at an ideal gate's cost (round 20's A1) were 4.2 M instructions and about 2.2 M cycles at
  one placement; a redesign recovers some fraction of that, and the declarations', statements' and directives' checks
  (about 2.5 M cycles by function deltas, their instructions mostly hidden: the declarator's +1.3 M ops cost no
  cycles) less.

Parity needs about 6.5 M cycles. At their ceilings, A1's 2.2 M and these stalls' 1.2 M of line excess are half of it;
at what this round's fixes returned of their lines' excess, about a fifth, the stalls give about 0.2 M.
