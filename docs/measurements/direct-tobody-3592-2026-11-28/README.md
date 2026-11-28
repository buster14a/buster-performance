# glibc's tolower and toupper on the direct path (buster#3592), 2026-11-28

[buster14a/buster#3592](https://github.com/buster14a/buster/issues/3592)'s Lua comment left glibc's `__tobody` as one of
the constructs that keep Lua 5.4.8's units off the direct path. This record measures it and the change that takes it.
The change is on buster's branch `claude/tobody-direct-3592` (head `eaacb53`, on main `3900992`). The guide is
`docs/commands/driver.md`.

## The construct

Under `__OPTIMIZE__` (`-O1` and up), glibc's `<ctype.h>` defines `tolower`, `toupper`, `tolower_l` and `toupper_l` by
`__tobody`. That is a statement expression, the same in glibc 2.39 (the container) and 2.44 (the 9700X):

```c
#define __tobody(c, f, a, args) \
  (__extension__ ({ int __res; if (sizeof (c) > 1) { if (__builtin_constant_p (c)) \
      { int __c = (c); __res = __c < -128 || __c > 255 ? __c : (a)[__c]; } else __res = f args; } \
      else __res = (a)[(int) (c)]; __res; }))
```

The direct path compiles no statement expression, so a unit that calls them at `-O2` leaves it at the `({`.

## The census

`scripts/lua-census.sh` compiles Lua's units with its Makefile's flags but `-Wall -Wextra`: `-std=gnu99 -O2
-DLUA_COMPAT_5_3 -DLUA_USE_LINUX`, the host's headers.

| | direct | the others' first reason |
| --- | ---: | --- |
| main `3900992` (`results/census-main.txt`) | 31 of 34 | `lbaselib` and `lstrlib`: "unclosed operator in expr" at `__tobody`'s `({`; `lvm`: "constant conversion the full pipeline questions" |
| head (`results/census-head.txt`) | 33 of 34 | `lvm` alone |

The ceiling was emulated first, with `results/emulation-ctype.h`. That header defines `__tobody` again as the
conditional expression below, and with it both units took the direct path.

## The change

- **glibc's definition takes the conditional expression it computes.** The definition must be glibc's token for token:
  the name `__tobody`, four parameters and its 80 tokens. Its body then becomes 75 of those tokens
  (`fast_pp_tobody_body` in `c_direct_lex.c`):

  ```c
  ((int) (sizeof (c) > 1 ? (__builtin_constant_p (c) ? ((int) (c) < -128 || (int) (c) > 255 ? (int) (c)
      : (a)[(int) (c)]) : f args) : (a)[(int) (c)]))
  ```

  - Each arm is what its branch assigns to `__res`. Both conditions are constants, so the direct path compiles the arm
    they select, and checks the others as dead arms without code.
  - `c` is evaluated once, by that arm.
  - A redefinition is still checked against the definition's text. Any other body keeps its tokens and leaves at its
    `({`.
- **`__builtin_constant_p`'s operand.** On main, the direct path compiled it as an ordinary argument, with its code:
  `__builtin_constant_p(g())` called `g`, where clang and the full pipeline don't (`results/semantics-main.txt`:
  `count=1` against `count=0`). Through `__tobody`, `tolower(g())` would have called `g` twice.
  - Now an operand with a side effect is compiled without code, and the builtin gives 0
    (`fast_cc_constant_p_effects` in `c_direct_cc.c`).
  - A side effect means an increment, a decrement, an assignment, a brace, or a call: a `(` after a name, a `]`, or a
    `)` that doesn't close a cast's type name.
  - Any other operand compiles as on main.

## Correctness

The container's Release build (`-march=native`) did all of this except the timings.

- **`test-direct`**: 277 of 277. Its new case, `c_direct_test_tobody`:
  - compares the object of a unit that has glibc's definition, as glibc lays it out, with the same unit with the
    conditional written out, over each arm;
  - checks which functions the selected arms name;
  - runs `__builtin_constant_p` of side effects in-process;
  - has three near-shapes that must leave.

  Two mutants fail it: the rewrite turned off, and the operand test turned off.
- **`test-direct --differential tests/`**: all 4,793 files exit and print alike; 323 are direct.
- **Corpus equivalence** (`scripts/equiv-run-O2.sh`, `one.sh`).
  - The run covers record `direct-lua-reach-3592-2026-11-28`'s units, with three `-O2` passes added: `tests/`,
    c-testsuite, and Lua by its Makefile's flags. That makes 12,818 compiles each by main and by head.
  - Two units differ (`results/equiv/differing-units.tsv`): Lua's `lbaselib.c` and `lstrlib.c` at `-O2`. They move
    from the full pipeline to the direct path, with the same status and an empty stderr.
  - No unit that both builds compile on the direct path changed its object.
- **Symbols.** The two units' global, weak and undefined symbols are `--no-direct`'s: 59 and 66 symbols, `lstrlib`'s
  `tolower` reference included.
- **Lua's own tests** (`scripts/lua-tests.sh`, `results/lua-tests.txt`). The units by default (33 of 34 direct) and by
  `--no-direct`, linked by clang, each run Lua 5.4.8's suite (`lua-5.4.8-tests`, sha256 `9581d5a7...`) with
  `lua -e"_U=true" all.lua`. Both end "final OK !!!".
- **Run against clang** (`scripts/semantics.sh`, `results/semantics.txt`). `semantics/ctype.c` has every arm: an int, a
  char, a signed char, constants in and out of the table's range, a call's argument counted, a long. The direct path's
  object, the full pipeline's and clang's `-O2` print the same, and the direct one has the full pipeline's undefined
  references.
- **Probes** (`results/probes/`, `scripts/probe-diff.sh`, `results/probes-diff.txt`). 32 odd uses by `-std=gnu99 -O2`,
  each compiled by default and by `--no-direct`: none differs in status or stderr.
  - Constant-expression contexts leave the direct path: `case tolower(300):`, a file-scope initializer, an array bound,
    `_Static_assert`, an enumerator and a bit-field width. There the new body would be a constant where glibc's is no
    constant expression, and the full pipeline errors.
  - So do `&tolower(c)`, `tolower(c) = 1`, a pointer argument, `tolower(3.5)`, `_Generic` and `__typeof__`.
  - `tolower(*p++)` leaves too: the increment is in `sizeof`'s operand.
  - The 14 probes that are direct and compute a value give the full pipeline's results when run
    (`scripts/probe-values.sh`, `results/probes-values.txt`).

## On the 9700X

`scripts/bench.sh`, `results/bench-9700x.log`.

- Both binaries were built `BUSTER_HOST_ARCH=znver5`, Release, in a cloud container, and stripped: main `3900992`
  (`009a3389...`) and head `eaacb53` (`816ea040...`).
- Measured under the lock on CPU 2, a process a unit, 11 rotated rounds, medians.

| | main | head | |
| --- | ---: | ---: | ---: |
| Lua's 34 units, wall | 67.48 ms | 57.51 ms | **-14.8%** |
| user cycles | 261.3 M | 220.9 M | -15.5% |
| kernel cycles | 112.2 M | 95.5 M | -14.9% |
| user instructions | 620.1 M | 536.0 M | -13.6% |
| page faults | 15,221 | 13,416 | |
| direct | 31 of 34 | 33 of 34 | |
| `lbaselib.c` alone, wall (`perf stat -r 21`) | 4.01 ms | 1.06 ms | |
| `lstrlib.c` alone, wall | 7.66 ms | 1.71 ms | |
| musl's 1,336 by `-std=c99` (a control: no `__tobody`), wall | 1,144.1 ms | 1,142.0 ms | |
| `sqlite3.c` (CI's count flags), user instructions, `perf stat -r 7` | 211,442,666 | 211,465,678 | +0.011% |
| `sqlite3.c` user cycles | 82.48 M | 81.79 M | |

`sqlite3.c`'s object is the same (`61550269372a26d9`).

### The instructions on `sqlite3.c`

The branch's first commit asked about `__builtin_constant_p` at every call. It asked whether the callee was the builtin
at each call's `(`, and checked a mark at its `)`. It also asked four questions of each `#define`'s shape.

| `sqlite3.c`, user instructions, each run's own main | main | the build | |
| --- | ---: | ---: | ---: |
| first commit (`results/bench-9700x-v1.log`) | 211,443,033 | 211,690,653 | +247,620 |
| the question asked where a builtin's name is pushed (`results/bench-9700x-v2.log`) | 211,442,204 | 211,498,389 | +56,185 |
| and one question a definition, its token count: head (`results/count-9700x.log`) | 211,441,946 | 211,465,039 | +23,093 |

Neither move changed an object, and the Lua timings above are the head's.

## Not done

- `lvm.c`: its enum conditional, then its computed `goto` (#3666 is changing the direct path's labels).
- `tolower(*p++)` and other side effects in `sizeof`'s operand. The full pipeline is quiet there, inside glibc's macro,
  but the direct path leaves.

## Files

- `scripts/`: `lua-census.sh`, `equiv-run-O2.sh`, `one.sh`, `probe-diff.sh`, `probe-values.sh`, `semantics.sh`,
  `lua-tests.sh`, `bench.sh` and `count.sh`. Some are adapted from `direct-lua-reach-3592-2026-11-28/scripts/`. The
  equivalence scripts expect the corpus where the container keeps it, `/tmp/claude-0/corpus`, copied from the 9700X's
  `/var/lib/buster-9700x/corpora/preprocessor-391e729af658`.
- `results/equiv/`: both runs' rows (`main.tsv.gz`, `head.tsv.gz`), their summaries and the differing units.
- `results/probes/`, `results/semantics/`: the sources.
- `results/lua-tests/`: the two runs' logs.
