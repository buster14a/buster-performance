# #3452 piece 1: the assembler lexer's rare route, vector (2026-11-24)

[buster#3452](https://github.com/buster14a/buster/issues/3452), part of
[#2924](https://github.com/buster14a/buster/issues/2924). This piece deletes `asm_lex_scalar`, the byte-at-a-time walk
that `asm_lex_vector` handed strings, comments, a lone `/`, NUL and bytes ≥ 0x80 to. `asm_lex_rare` now scans them 64
bytes at a time:

- **Strings:** a string's escapes come from its backslash runs by one addition, carried across blocks.
- **Comments:** a `#` or `//` comment ends at the next newline's mask. A block comment closes where a `*` mask meets
  the next byte's `/` mask.

Rule 2 applies: the vector route had to be at least as fast at every size on the 9700X. The final round meets it.

## Method

- **Inputs** (`make-inputs.py`): 20,000 strings, escape-heavy strings and comments of N = 1, 2, 4, ..., 256 bytes, one
  per line, plus three real inputs, made with gcc 13.3.0 and clang 23.1.6:
  - `sq-gcc.s` and `sq-clang.s`: `-O2 -S` of SQLite 3.53.2's `sqlite3.c`, with `-DSQLITE_OMIT_LOAD_EXTENSION
    -DSQLITE_THREADSAFE=0`.
  - `lvm-clang-g.s`: `clang -O2 -g -S` of Lua 5.4.8's `lvm.c`.
- **Gate** (`run-3452.sh`): one hold of `exclusive.sh` per round. Each round runs `compiler assemble --timing` on every
  input, pinned to CPU 2, seven times, with three binaries in a rotating order:
  - base: main at 11826d6dd;
  - head;
  - ctrl: a hard link of base, which measures process noise.

  All binaries are znver5 Release builds with `BUSTER_DEBUG_INFO=0` from CI's LLVM 23.1.4, built in a container and
  shipped. `sum.py` gives medians of `lex_ns` and `total_ns`. Every run's status is 0.
- **Exactness:** every head's objects, errors and exit statuses equal base's on:
  - the 30 gate inputs;
  - gcc and clang, AT&T and Intel, `-S` and `-g` outputs of `sqlite3.c` and `lvm.c`;
  - 3,000 random sources from `differential-gen.py`: strings with backslash runs up to 140 bytes across block edges,
    open strings and comments at the end, `/` operators, bytes ≥ 0x80.

  The frozen digest `BUSTER_ASM_TEST_DIGEST` is unchanged.

## Rounds

| Round | Head | What changed | Lexing at 1–4 bytes (head/base) |
|---|---|---|---|
| 1 | b79a1fbf9 | Vector scans, called out of line | 1.07–1.14 |
| 2 | e54e8d62d | The rare token lexed in the block that meets it | 1.05–1.15, no gain |
| 3 | uncommitted | `asm_lex_rare` inlined | strings ≤1.035, comments 1.05–1.10 |
| 4 | a8eba42f0 | Inlined, with the scans taking the lexer's own block register as their first | comments 0.89–0.95, 1-byte strings and escapes 1.028 |
| 5 | 75d6d6063 | A string's close from its masks, not a load | all ≤ 0.998 |

Round 3's slowdown came from the call. Every ZMM register is caller-saved, so the block loop spilled and reloaded its
vector constants around the out-of-line call. The base had inlined its walk.

## Final round (75d6d6063)

Medians of 7, in ms of base and as ratios to base (`rounds/5-summary.txt`):

| Input | Lex, base (ms) | Lex, head/base | Lex, ctrl/base | Total, head/base | Total, ctrl/base |
|---|---|---|---|---|---|
| string-1 | 0.382 | 0.977 | 1.004 | 0.996 | 1.061 |
| string-2 | 0.395 | 0.943 | 0.998 | 0.950 | 1.009 |
| string-4 | 0.458 | 0.814 | 1.002 | 0.924 | 1.002 |
| string-8 | 0.589 | 0.632 | 1.014 | 0.875 | 1.015 |
| string-64 | 2.801 | 0.152 | 0.996 | 0.607 | 1.013 |
| string-256 | 10.725 | 0.050 | 1.003 | 0.463 | 0.992 |
| escape-1 | 0.374 | 0.998 | 1.020 | 0.964 | 1.015 |
| escape-2 | 0.394 | 0.946 | 1.005 | 0.944 | 1.002 |
| escape-4 | 0.394 | 0.946 | 1.005 | 0.944 | 1.006 |
| escape-8 | 0.527 | 0.709 | 0.995 | 0.903 | 1.012 |
| escape-256 | 8.045 | 0.067 | 1.000 | 0.458 | 1.006 |
| comment-1 | 0.316 | 0.948 | 1.002 | 0.972 | 0.987 |
| comment-2 | 0.319 | 0.942 | 1.003 | 0.998 | 1.010 |
| comment-4 | 0.333 | 0.899 | 1.004 | 1.009 | 1.027 |
| comment-8 | 0.366 | 0.819 | 1.002 | 0.997 | 1.020 |
| comment-256 | 2.722 | 0.168 | 1.014 | 0.629 | 1.012 |
| sq-gcc.s | 3.279 | 0.950 | 1.007 | 0.998 | 1.003 |
| sq-clang.s | 6.548 | 0.894 | 1.010 | 0.984 | 1.000 |
| lvm-clang-g.s | 1.354 | 0.606 | 1.031 | 0.939 | 1.015 |

Every size is in `rounds/5-summary.txt`. No input's lexing reads above 0.998 of base. The only total above 1.0 is
comment-4's 1.009, whose control reads 1.027.

## Tests

- **Mutants** (`mutants.txt`): the rounds ran 11, 6, 4 and 3 mutants of the scans, plus two single ones. Every mutant
  is killed in the final tree.
  - Round 1's first run left two survivors, `carry-dropped` and `block-start-early`. New fixtures killed them: a
    backslash on a scan's 64th byte, and `/*/`.
  - Round 2 left `escaped-start-kept`, which a `\\` pair split at a block's end now kills.
  - The `block-below`, `line-below` and `string-below-quote` lines with empty output crashed the test (killed).
  - Two single mutants are killed by 1 and 2 failures: the rerun of `escaped-start-kept` against the new fixture, and
    `quotes | ~quotes` in the close test.
- **Sanitizers** (`sanitizers.txt`): `test-assembler`, `test-assembly-output` and `test-checker-asm` pass under UBSan,
  ASan and MSan at b79a1fbf9. The later rounds changed only control flow and inlining; they get a rerun before the
  queue.
