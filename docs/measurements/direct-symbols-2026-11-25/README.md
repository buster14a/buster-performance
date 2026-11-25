# The direct path's symbols against the full pipeline's (buster#3595)

For [buster#3595](https://github.com/buster14a/buster/issues/3595). The direct path (`c_direct`, buster#3566) is the default
`-c`. At main `f74b0b28` it wrote other symbols than `--no-direct` for valid C:
- `extern inline` bodies were emitted at `-O1` and up, so two objects that include `<stdlib.h>` didn't link;
- glibc's `__REDIRECT` labels were read as their first literal;
- `visibility("internal")` was default rather than hidden.

The fix is buster `d3a33e47a`, on #3593's head `8d15cd217`.

## The symbols of every direct unit

`scripts/symbols-run.sh COMPILER OUT.tsv` compiles every unit of the 7,556-unit corpus with the default `-c`. Where the
direct path took the unit, `scripts/symbols-one.sh` compiles it again with `--no-direct` and compares the two objects'
symbols, as `scripts/syms.py` lists them:
- name, binding, type, visibility and section name;
- an undefined symbol by name, binding and visibility only;
- left out: `FILE` and `SECTION` symbols, `.L` names, and local objects (function-local statics are named `x.0` by one
  path and `f.x` by the other).

The corpus is the tests, the c-testsuite, Lua, musl by `c99` and by `gnu99`, and SQLite in fourteen option sets. It was
run in a cloud container with CI's LLVM 23.1.4.

| | main `f74b0b28` | the fix |
| --- | ---: | ---: |
| direct units | 1,892 | 1,860 |
| of them, `--no-direct` fails (buster#3577's subject) | 277 | 269 |
| the others, with other symbols than `--no-direct`'s | 146 | 113 |
| Lua's 31 direct units with other symbols | 25 | 4 |

`results/symbols-kinds-main.txt` and `results/symbols-kinds-fix.txt` classify each difference (`scripts/classify.py`
over `scripts/diff1.sh`'s whole diffs). The kinds the fix removes:
- **visibility, Lua's 429 symbols in 20 units:** `LUAI_FUNC` is `visibility("internal")`;
- **`fopen`, `tmpfile`, `fcntl`, `fstat`, `lstat`, `stat`, `ftruncate`, `open`, `pread`, `pwrite` and `mmap` rather
  than their `64` names (Lua, SQLite), and `signal` rather than `__sysv_signal` (Lua's `lua.c`):** `__REDIRECT`;
- **17 of glibc's inline functions (`atoi` to `vprintf`) defined by `sqlite3.c` at `-O2`:** `gnu_inline`;
- **`f` defined by `tests/driver/programs/inline-modes/direct-source.c`:** a C99 inline definition;
- **`f` both defined and undefined, or an undefined `f` beside a local one:** a block's `int f(void);`.

What is left, which #3595 doesn't claim:
- objects initialized to zero in `.data` rather than `.bss`, or a `const` one in `.data.rel.ro` or `.bss` rather than
  `.rodata`;
- undefined references only one side's code makes: the direct path's `memcpy`, `memcmp`, `memset`, `abs`, `labs`,
  `fabs` and musl's dead `isdigit`, the full pipeline's `memset` and `memmove`;
- unused static functions the direct path keeps;
- in test sources that warn (buster#3577):
  - `__private_extern__` read as an object's name;
  - a used `static` function with no definition as a local undefined symbol.

`results/symbols-differ-main.tsv` and `results/symbols-differ-fix.tsv` list each differing unit with its first
differences. `results/symbols-summary-*.txt` count the units by corpus, path and verdict.

## Inline definitions

`scripts/inline-matrix.sh COMPILER` compiles the 21 units in `inline/` three ways (clang 23, the default `-c`, and
`--no-direct`) and prints what each object says of `f`. At main, 12 of the 21 differed between the direct path and the
full pipeline (`results/inline-matrix-main.txt`); with the fix, none (`results/inline-matrix-fix.txt`). The full
pipeline is clang's in each but c7: a `gnu_inline` on a prototype before an `extern inline` definition. Units c8 and
c9 are `-fgnu89-inline`, which the fix keeps off the direct path.

## Every unit against main

`scripts/equiv-run.sh` (with `scripts/equiv-one.sh`) records each unit's status, stderr hash, object hash and path.
`results/equiv-against-main.txt` compares the fix's records with main `f74b0b28`'s; `results/equiv-changed-units.tsv`
lists the 77 units that changed:
- **45 direct objects change.** Each now has the full pipeline's symbols, or differs only in the unclaimed kinds above.
- **32 test sources leave the direct path:**
  - 8 are ones the full pipeline rejects;
  - 16 get warnings the direct path had dropped;
  - none are in Lua, musl, SQLite or the c-testsuite.

## Seeded faults

`scripts/faults.py` applies 41 single-line faults to the new code, one at a time, and runs `test-direct`
(`results/faults-1.txt`, then `results/faults-2.txt` for the reruns):
- **34 found at once.** One more failed to build (an unused variable), was rewritten, and was found.
- **Six survived.** Each led to a change:
  - three to new tests, which find them: a static prototype before an unreferenced inline definition, a reference
    before an inline-only definition, and a block declaration under a local of the name;
  - one to removing a dead check: a block declaration's asm label never reaches the check, since a body's statements
    leave at `__asm__`;
  - two are equivalent:
    - a `visibility` operand that isn't followed by `)` leaves the attribute parser's parenthesis count off by one,
      so the unit leaves the direct path anyway;
    - a block declaration with nothing visible binds nothing, and any use of the name is refused as undeclared.

## 9700X

`compiler-s1m` (#3593's head, main + `s1m.patch`) against `compiler-sym2` (the fix, main + `sym2.patch`). Both were
built on the host by `build-variant.sh` under the lock, and `test-direct` passed there (`results/build-sym2.log`).

One hold ran three scripts from [`direct-reach-fixed-cost-2026-11-25/scripts`](../direct-reach-fixed-cost-2026-11-25/scripts),
each rotating the variants by round on CPU 2:
- `ab.sh 11` (`results/ab-sym2.txt`);
- `stages.sh 11` (`results/stages-sym2.txt`);
- `builds-ab.sh 5` (`results/builds-ab-sym2.txt`).

| medians | #3593's head | the fix |
| --- | ---: | ---: |
| a one-function unit | 0.24 ms | 0.25 ms |
| `stdio.h` and a `printf` | 0.62 ms | 0.62 ms |
| six headers and a `main` | 1.22 ms | 1.22 ms |
| musl's `wcwidth.c` | 0.35 ms | 0.36 ms |
| `sqlite3.c` | 16.76 ms, 220.69 M instructions | 16.80 ms, 221.07 M |
| `sqlite3.c`'s preprocess and tier0 stages | 7.100, 8.650 ms | 7.088, 8.697 ms |
| Lua's 34 units, 5 rounds | 79.95 ms | 79.69 ms |
| musl's 1,336 units by `gnu99`, 5 rounds | 1,499.48 ms | 1,495.30 ms |

- **`sqlite3.c`'s instructions rise 0.17%.** A file-scope declarator's attributes and inline spelling are joined into
  its symbol (`fast_cc_decl_join`). Its time moves within a build's placement, which moves each stage by up to
  0.12 ms (`../direct-reach-fixed-cost-2026-11-25`). CI's compile count moves +0.219% against `8d15cd217`, within its
  half percent.
- **Each process takes 6 to 8 more page faults.** A unit with no string literal of its own takes them too, so they
  are most likely the larger executable's code, not the units' data.
- **Objects:** Lua's and `sqlite3.c`'s change, as the symbols above say. musl's are the same.
