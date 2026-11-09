# Head errors, operand duplicates and typeof sugar: error-free units, base vs head (#1835, #1836, #1837, PR #1976)

Raw evidence for [buster14a/buster#1976](https://github.com/buster14a/buster/pull/1976). That PR changes:
- the operand readers' loops, which error-free units run (`check_constant_specifiers`, the enum base reader: a
  repeated specifier's warning, #1836);
- a warning operand's spelling, which a warning's creation reads (`check_input_typeof_spelling`, #1837).

This checks error-free `-fsyntax-only`.

## Identity

- **Date:** 2026-11-09, by an agent session (Claude Code), the whole A/B in one hold of `~/buster-fast-bench/exclusive.sh`.
- **Base:** buster main `784b580` (sha256 of the binary `8b874b0b…`).
- **Head:** `de3a1ce`, branch `recovery/1447-file-scope-errors` (binary `3a4655ad…`).
- **Builds:** `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh` in the session's container. The binaries were copied
  to the 9700X and their hashes checked there, as the coordinating session asked, to keep builds off the shared host.
- **Host:** `benchpress`, AMD Ryzen 7 9700X.
- **Inputs:**
  - SQLite's `sqlite3.c` (`~/buster-fast-bench/refine-claude/inputs/sqlite3.c`), with no options;
  - the head tree's `src/buster/compiler/main.c` with `-march=native -Isrc -fwrapv -funsigned-char`, the same input for
    both binaries.

## Commands

`ab.sh` here: three interleaved rounds, each `taskset -c 2 perf stat -x, -e instructions:u,cycles:u -r 5`. `ab.txt`
holds the raw output.

## Results

Instructions:u, the means of 5 runs, the same in every round to within a few instructions (sqlite) or 30K (main.c):

| input | base | head | change |
|---|---|---|---|
| `sqlite3.c` | 972,723,627 | 972,692,900 | −0.003% |
| `main.c` | 58,639,656K | 58,639,944K | +0.0005% |

Cycles:u, the means of three rounds:

| input | base | head |
|---|---|---|
| `sqlite3.c` | 443.68M | 442.97M |
| `main.c` | 15.504G | 15.427G |

The cycle differences (−0.2%, −0.5%) are within code-placement noise for changes this small. Neither input pays for the
change.
