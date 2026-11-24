# Deep shapes for #2995 and #1355

The Ryzen 7 9700X record for #1355 includes the return, goto and break scaling curves, the other jump shapes, cycle profiles, and ordinary-code controls. [9700X results for #1355](9700x-1355/README.md)

The generators below reproduce the inputs for the two compiler changes. [GNU break targets and variable-length array statements (#3244)](https://github.com/buster14a/buster/pull/3244) · [Tier 1 lifetime walks (#3245)](https://github.com/buster14a/buster/pull/3245)

## Generators

`cc -O2 -o gen2995 gen2995.c` and `cc -O2 -o gen1355 gen1355.c`; each prints one C file: `genNNNN SHAPE N > SHAPEN.c`.

- `gen2995` SHAPEs:
  - `regions`: N nested statement expressions in a loop, with a GNU `break` at the innermost;
  - `bounds`: one array of N variable bounds, `int a[n][n]...[n]`;
  - `declarators`: one declaration of N variable-length arrays, `int a0[n], a1[n], ...`.
- `gen1355` SHAPEs, else-if chains of N arms inside a function, each arm a block with a local:
  - `gt`: `goto out`;
  - `gotoin`: a goto into a block;
  - `case`: nested cases;
  - `addr`: labels whose address is taken;
  - `asm`: asm goto;
  - `brk`, `cont`, `contl`: break and continue of `for`, `while` and `do`.

Both reproduce, byte for byte, the files the sessions measured (`gen2995`: all 15 of the three shapes at 2,000 to
32,000; `gen1355`: all 36 of the eight shapes at 4,000 to 32,000).

## 9700X recipe

Release builds (`./build.sh --config Release`) of main and of each PR's head, each run under `exclusive.sh`, one run per
lock. `timing.sh BINARY RUNS FLAGS DIR SHAPE...` prints the median check-program stage (`--time-stages`) at N = 4,000,
8,000, 16,000 and 32,000:

```sh
./timing.sh build/compiler 7 --tier1 chains gt gotoin case addr asm brk cont contl   # #1355
./timing.sh build/compiler 7 "" shapes regions bounds declarators                    # #2995
```

Add a no-regression check on ordinary code: `ab` or `time-runs` of sqlite3.c and the c-testsuite programs, main
against each PR, as `docs/commands/profiling.md` describes.

## Cloud readings so far (Develop builds, shared 4-CPU container; not acceptance evidence)

- #2995, wall time of `-w -c`, best of 3, main against the branch, at 32,000:
  - `regions`: 2.109 s against 0.052 s;
  - `bounds`: 1.465 s against 0.073 s;
  - `declarators`: 1.610 s against 0.117 s.

  Objects are identical. Steps passed, which don't depend on the host, at 8,000:
  - `regions`: 24,002 (96,028,000 without kept answers);
  - `bounds`: 16,004 (64,024,002);
  - `declarators`: 48,000 (64,055,998).
- #1355, check-program stage of `gt` at 16,000 with `--tier1`: 1,226 ms on main against 19 ms on the branch. Lifetime
  walk steps at 1,024 arms of test-checker's own generated sources (`CheckProgramOptions.lifetime_work` against main's
  walks as the test's oracle): gotos out 154,692 against 4,212,736; breaks and continues 596,081 against 5,295,107.
