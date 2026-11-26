# Round 22: what the checks' conditions cost, what the rest is, and Zen 5's store forwarding

[buster#3597](https://github.com/buster14a/buster/pull/3597)'s head eeee61ef8 (round 21's code) against main
1e1ca2dd6, toward the owner's ask for parity (2026-11-26). Builds are the 9700X job's (`BUSTER_HOST_ARCH=znver5`,
Release) under the host lock; sqlite3.c with the host's headers, `taskset -c 2`, `perf stat -r 5` cycles:u and
instructions:u. Every measurement-only arm keeps sqlite3.c on the direct path with the head's object, byte for byte
(`patches/`, built by `scripts/abl-grp-make.sh` and `scripts/abl-a1-make.sh`, checked by their sqlite3.c compiles).

## The conditions against the rest (`scripts/bp-abl22.sh`, `results/abl22.txt`)

Two arms gate checks behind an opaque never-true test, so their conditions are never evaluated: A1 (`abl-a1.py`, the
expression-side checks, as round 20) and ALL (`abl-all.py` then A1: each of the 253 `if`s this branch added whose body
leaves the direct path, plus A1). Four placements that also move the code's alignment (offsets 0, 528, 1056, 1584),
rounds 2 and 3:

| arm | cycles | instructions |
| --- | ---: | ---: |
| main | 75.47 M | 195.79 M |
| head | 82.05 M (+6.58) | 212.53 M (+16.74) |
| A1 | 80.26 M | 208.42 M |
| ALL | 78.96 M | 206.35 M |

- The conditions (head against ALL): 6.19 M instructions and 3.09 M cycles, at 2.0 instructions a cycle. The opaque
  test is a volatile byte's load and a branch at each site, so their own cost is a little more.
- The rest (ALL against main): 10.56 M instructions and 3.49 M cycles, at 3.0 a cycle: what the checks keep and read
  (the 32-byte values and 28-byte operator entries, the marks, the token positions, the larger records), the work of
  answering `__has_*` as the full pipeline does (about 0.4 M cycles, round 9), and the directives' walks.
- **With every condition free the head would still be 3.49 M cycles (4.6%) over main.** Parity needs the rest cut or
  main's own code made faster by as much.

## Where the conditions are

By file (`scripts/bp-ablgrp.sh`, `results/ablgrp.txt`, one placement, instructions exact):

| arm: that file's bail `if`s gated | instructions | against the head |
| --- | ---: | ---: |
| `c_direct_lex.c` (28) | 212.197 M | -0.338 M |
| `c_direct_types.c` (67) | 212.870 M | +0.335 M (the gates' own loads cost more than the conditions) |
| `c_direct_cc.c` (164, six of them A1's) | 208.941 M | -3.594 M |

A1 by part (`scripts/abl-a1-part.py`, `scripts/bp-a1parts.sh`, `results/a1parts.txt`, one placement):

| A1 part gated alone | instructions saved |
| --- | ---: |
| the binary operators' operand gate and its two out-of-line checks | 2.292 M |
| a name's push marks (purity, an enumerator's enum, the `-Wunsequenced` identity) | 0.976 M |
| `-Wunsequenced`'s counting and its end | 0.676 M |
| precedence (`-Wparentheses`' family) and a string literal's `+` | 0.525 M |
| conditions (`-Wpointer-bool-conversion` and kin) | 0.346 M |
| unary operands | 0.242 M |
| a subscript's checks | 0.223 M |
| the expression's end (an assignment or parenthesized equality as a condition, a discarded value) | 0.208 M |
| an assignment's record with a const member | 0.034 M |
| implicit conversions through main's gate instead of this branch's | -0.625 M (main's gate costs more) |

## Profiles (`scripts/bp-prof-all.sh`, `results/pu-*-all.txt`, `scripts/three.py`)

IBS ops every 262,144 and cycles every 100,000, 300 compiles, against round 21's main and head profiles: totals per
compile main 77.27 / head 83.65 / ALL 80.90 M cycles. By function the conditions and the rest mix with inlining that
differs between arms (in the head the record parser is inlined into `fast_cc_parse_decl_specs_full`; in ALL it isn't),
so read them by cluster: `fast_cc_compile_func` with the declarators and specifiers is about +0.9 M cycles of the rest.

## Zen 5's store-to-load forwarding (`scripts/stlf.c`, `results/stlf*.out`)

A dependency chain through a store and a load at an offset into it (rdtsc ticks a step; `stlf.out` to `stlf4.out` are
the program's successive versions, each a superset):

- Forwards: a GPR store and the same address (0.69, memory renaming); a 16 or 32-byte vector store to any contained
  1, 4 or 8-byte load at any offset, across a 64-byte line too (8.9); a 16 or 32-byte load inside a larger store
  (13.0, as a whole reload; a 32-byte load at 8, 16 or 24 inside a 64-byte store 15.8); the younger of two
  overlapping stores. A load 4096 or 8192 bytes from an in-flight store costs nothing (no 4K aliasing).
- Refuses, one `ls_bad_status2.stli_other` a step: a 64-byte store at line offset S other than 0 or 32, to a load in
  the next 64-byte line at line offset r with (r mod 32) < (S mod 32) (17.1 against 6.8 with the chain through the
  address); a load spanning two stores (9.6 against 0.7); a byte-masked store (13.0 against 8.9).

Clang zeroes a struct over 64 bytes with such stores at whatever offset the frame gives: the head's 88-byte
`FastDeclaratorResult` (`dr.attr.aligned`, `asm_label`, `asm_label_len` read right after) is one case. But on
sqlite3.c's compile it is no lever (`scripts/bp-stli.sh`, `bp-pv256.sh`, `bp-stack.sh`):

- Refused forwards a compile: main 367-457 K, the head 222-365 K (fewer: round 21 removed main's argument copies), ALL
  275 K; one build's count moves 30% between runs, and the time doesn't follow.
- `-mprefer-vector-width=256` (32-byte stores everywhere): main +0.17 M instructions, +0.43 M cycles and +83 K refused
  forwards; the head +0.23 M instructions and +0.33 M cycles (`results/pv256.txt`, one placement).
- ASLR off and the stack moved through eight positions by the environment's size: main 75.2-75.8 M cycles, the head
  82.4-83.1 M, neither following the stack's alignment (`results/stack.txt`).

## What this leaves

The largest single cost of the conditions is the binary operators' gate (2.3 M instructions, about 85 for each of
sqlite3.c's 27,000 operators with its out-of-line checks); then the name push's marks and `-Wunsequenced`'s counting.
At what the conditions cost a cycle, all of them are 3.1 M cycles, and the rest 3.5 M.
