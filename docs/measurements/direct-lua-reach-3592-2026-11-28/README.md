# Lua's units on the direct path (buster#3592), 2026-11-28

[buster14a/buster#3592](https://github.com/buster14a/buster/issues/3592)'s last comment left this item: Lua 5.4.8's
units mostly leave the direct path. This record measures why, and the change that brings 13 of them onto it.

## The census

Lua 5.4.8's 34 units are compiled by `-c`, one process each. The flags are its Makefile's, `-std=gnu99 -O2
-DLUA_COMPAT_5_3 -DLUA_USE_LINUX`, without `-Wall -Wextra`, since any `-W` option keeps every unit off the direct
path. Headers are the host's. The census ran with glibc 2.39 in a cloud container and with glibc 2.44 on the 9700X;
both gave the same reasons. `scripts/lua-census.sh` records each unit's path and `BUSTER_TEST_DIRECT_BAILS` reason
(`results/census-main.txt`). The throwaway `patches/debug-bail.patch` prints the tokens around each first bail
(`results/census-main-bail-tokens.txt`, token kinds as `FTOK_*` numbers).

The full pipeline is silent on all 34 units, so every unit that left did so where it needn't have. On main `cc7d4ffb`,
18 of 34 units took the direct path. The other 16 left at:

| first reason | units | the construct |
| --- | --- | --- |
| attributes of a file-scope declaration | lcode, ldo, llex, lmem, lparser, lundump | `l_noret`, `void __attribute__((noreturn))`, on a definition |
| operands of distinct pointer types | lapi, lauxlib, ldblib, ldebug, liolib, lstate | a function pointer `== NULL`/`!= NULL`, NULL being `((void *)0)` |
| declaration specifiers | loadlib | `cast_func(p)`, `(__extension__ (lua_CFunction)(p))`: `(__extension__` read as a cast |
| declaration specifiers | lbaselib, lstrlib | glibc's `tolower`/`toupper` under `-O2`, `(__extension__ ({ ... }))` (`__tobody`) |
| constant conversion the full pipeline questions | lvm | `step < 0 ? F2Iceil : F2Ifloor` into an `F2Imod` parameter |

## The change

The change is buster#3592's pull request from branch `claude/modest-dijkstra-vaiwch`; the guide is
`docs/commands/driver.md`.

- **Noreturn functions.** A function's noreturn comes from any declaration so far, as `FastSym.is_noreturn`. A call to
  one by name, or to `__builtin_unreachable`, that is its expression's whole (`f(args);`) ends the path, and the
  function compiler's reachability now lives in `cc->live`.
  - A noreturn definition leaves at a `return` or an end that may be reached: that is `-Winvalid-noreturn`.
  - A definition without the attribute after a declaration with it is checked the same way. Main's direct path
    compiled that quietly where the full pipeline warns.
- **A function pointer against `void *`** for `==` and `!=`. Clang questions this only with `-pedantic`. Relational
  comparisons and a conditional's arms still leave.
- **`__extension__` is no type name's start.** `(__extension__ (T)(p))` is a parenthesized expression. Main's direct
  path compiled `(__extension__ long) x`, `sizeof (__extension__ int)` and `(__extension__ T) 1` as casts, where the
  full pipeline errors with "expected expression"; now they leave. Before a block's declaration or a `for`'s first
  clause, `__extension__` stays quiet.

`results/census-head.txt`: 31 of 34 direct. The three left:
- **lvm**: past the enum arms (`patches/emul-enum-arms.patch`, a throwaway that took them quietly), it leaves at its
  computed `goto` dispatch table (`&&L_OP_MOVE`; `results/census-head-emul-enum-arms-bail-tokens.txt`).
- **lbaselib and lstrlib**: glibc's `__tobody` statement expression.

## Correctness

- **Probes** (`results/probes/`): 126 small sources. `scripts/probe-diff.sh` compiles each by default and by
  `--no-direct` and compares stderr and status. Each form was first checked against the full pipeline.
  - Head: no file differs, and 57 are direct.
  - Main: 4 files differ, and 17 are direct. The four are main's own gaps: the three `(__extension__` casts and the
    inherited noreturn.
- **`test-direct`**: 276 of 276. Its new case list holds 16 forms that take the direct path and 19 that leave, plus
  `-w` runs and executed code. Two mutants were checked against it: dropping the noreturn end check, and dropping the
  call's shape test. Both fail it.
- **`test-direct --differential tests/`**: all 4,789 files exit and print alike; 323 are direct.
- **Corpus equivalence** (`scripts/equiv-run.sh`, `equiv-one.sh`: tests/, c-testsuite, Lua, musl by `-std=c99` and
  `gnu99`, sqlite3.c and shell.c in 14 configurations; run in the container):
  - 32 units changed from the full pipeline to the direct path, with the same status and stderr
    (`results/equiv/differing-units.tsv`): 13 of Lua's, 9 of musl's in each mode (`_Exit`, `abort`, `assert`, `exit`,
    `quick_exit`, `err`, `siglongjmp`, `thrd_exit`, `_exit`) and one test.
  - No unit that both builds compile on the direct path changed its object.
- **Symbols** (`scripts/symbols-vs-full.sh`): the global and weak symbols of the 32 newly direct units match
  `--no-direct`'s (names, binding, visibility, defined or not, a definition's type). Three units have one extra
  undefined reference, each a behavior main's direct path already has:
  - `abs` in lcode and `memcpy` in lstate: the direct path calls them where the full pipeline expands them.
  - `luaM_toobig` in lundump: a decided `&&` doesn't make the `?:` around it constant, so the dead arm's call is
    emitted. `int g(void); int f(int n) { return (sizeof(n) >= 8 && n + 1 > 5) ? g() : 1; }` references `g` on main.

## On the 9700X

`scripts/bench.sh`, `results/bench-9700x.log`: main `cc7d4ffb` against the change on the same base.

- Both binaries were built `BUSTER_HOST_ARCH=znver5`, Release, in a cloud container, and stripped. The 9700X's `/home`
  had no room for a build tree: its btrfs metadata was full.
- Measured under the lock, CPU 2, a process a unit, 11 rounds rotated, medians.

| | main | head | |
| --- | ---: | ---: | ---: |
| Lua's 34 units, wall | 114.76 ms | 67.17 ms | -41.5% |
| user cycles | 446.8 M | 261.0 M | -41.6% |
| kernel cycles | 188.3 M | 110.5 M | -41.3% |
| user instructions | 1,030.7 M | 620.6 M | -39.8% |
| direct | 18 of 34 | 31 of 34 | |
| musl's 1,336 by `-std=c99`, wall | 1,150.2 ms | 1,141.1 ms | -0.8% |
| direct | 1,001 | 1,010 | |
| `sqlite3.c` (CI's count flags), user instructions, `perf stat -r 7` | 211,390,188 | 211,442,624 | +0.025% |
| `sqlite3.c` user cycles | 81.77 M | 81.80 M | |

`sqlite3.c`'s object is the same on both (`61550269372a26d9`). Its +52 K instructions are this change's two new tests:
- a call's symbol test, about 14,000 calls;
- the declaration-start test at each block statement.
