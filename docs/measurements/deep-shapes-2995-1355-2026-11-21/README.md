# Deep shapes for #2995's and #1355's linear walks: generators and the owed 9700X A/B

**Inputs and recipe, plus cloud readings; no 9700X figure yet.** Compiler PRs:
[#3244](https://github.com/buster14a/buster/pull/3244) (#2995: statement expressions' GNU break targets and
variable-length arrays' statements) and [#3245](https://github.com/buster14a/buster/pull/3245) (#1355: Tier 1's
lifetime walks for goto, case and break). Both state that the issue's scaling acceptance, and the
measurement the repository asks for of each part that stays scalar, are owed on the 9700X. This record keeps the
inputs that measurement needs, which existed only in a session's scratch.

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

## Recipe (owed, on the 9700X)

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
