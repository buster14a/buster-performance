# #1385: the overflow builtins as the operation and seto, and one 64-bit or 128-bit operation, on the 9700X

Record for the pull request that finishes [buster#1385](https://github.com/buster14a/buster/issues/1385) (its byte
swaps were [buster#1651](https://github.com/buster14a/buster/pull/1651)): `__builtin_add/sub/mul_overflow` (and
clang's typed ones) were two-limb recipes for every type, a 64-bit product from four 32x32 products. Signed 64-bit
operands and destination of one class become the typed operation and an `X86` row of `add`, `cmp` or `imul` and
`seto`, which the IR takes as the intrinsics `saddo`, `ssubo` and `smulo`; the other classes' recipes take one 64-bit
operation of operands of at most 32 bits, the 64-bit operation's own carry or sign test for a sum or difference of
operands of the destination's signedness, and one U128 product's high limb for a product of a 64-bit operand.

## Sources and builds

- base: buster `73fcf006db22f7e10acfe315f85e379b77eff875` (main, the branch's parent);
- head: buster `24d2a14b5b5cd25f5b34f905593e5bfd0a24c62a` (the branch's code commit, `opencode/1385-overflow-builtins`).

Each tree is `git archive` of its commit (`scripts/build-trees.sh`), built with `BUSTER_HOST_ARCH=znver5
BUSTER_DEBUG_INFO=0 ./build.sh` in one lock hold per build (`base-73fcf006.build.log`, `head-24d2a14b.build.log`).
`host.txt` has the kernel, clang 23.1.1, CPU 2's governor and EPP (`performance`), both commits and the SHA-256 of
both compilers and every kernel binary and object.

## The kernels

`scripts/kern.c` has five loops over `n` elements, each of one overflow builtin: the issue's two, a signed long's
running sum (`ov += __builtin_add_overflow(s, p[i], &s)`) and products (`ov += __builtin_mul_overflow(p[i], p[n - 1 -
i], &r); ov ^= r`), and the same sum of ints and products of ints and of unsigned longs. `scripts/drv.c`, compiled once
by clang -O2, fills 4,096 elements with a xorshift sequence shifted right by its own low bits (products of every
magnitude, so both outcomes of each test occur), calls each kernel 20,000 times per repetition and prints the best of
3 repetitions, and a hash of every result, which every binary printed alike (`bee0f36679463800`).
`scripts/prepare.sh` (one lock hold) compiles `kern.c` by each tree's compiler, by Tier 0 (`-c`) and Tier 1
(`--tier1 -c`), at the default target (`x86-64`: the rows' and the recipes' forms are baseline, the same at every
target), and by clang 23.1.1 `-O0` and `-O2`, each linked with the same driver object.

`scripts/measure.sh` runs every binary once per round on CPU 2 (`taskset -c 2`), all of a round in one lock hold, in an
order that rotates by round. Three rounds ran (`results/round-0.txt` to `round-2.txt`); each kernel's three values
varied by at most 0.8 ms. `results/holds.txt` has each hold's own line of the lock's owner file. `kernels.tsv` has each
binary's three rounds and their median, in ms:

| kernel | main Tier 0 | main Tier 1 | PR Tier 0 | PR Tier 1 | clang -O0 | clang -O2 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `add_long` | 119.8 | 68.9 | 59.2 | 30.9 | 48.4 | 15.0 |
| `mul_long` | 241.9 | 169.7 | 103.6 | 48.1 | 75.3 | 30.4 |
| `add_int` | 147.9 | 82.7 | 59.4 | 36.9 | 48.2 | 15.0 |
| `mul_int` | 247.7 | 185.7 | 88.9 | 48.7 | 73.4 | 30.5 |
| `mul_ulong` | 218.5 | 143.0 | 118.5 | 59.3 | 74.3 | 33.5 |

Tier 1's loops now run in 0.64 to 0.80 times clang -O0's time (main's: 1.4 to 2.5 times), and Tier 0's in 1.2 to 1.6
times (main's: 2.5 to 3.4 times). Tier 0's remaining distance is its loops' own code (the induction variable's
compare through `setb` and `test`, register moves): the builtins' own instructions are clang -O0's, `imul`, `seto` and
`movzx`, with the typed operation's `imul` for the stored value beside them; `mul_ulong`'s U128 product goes through
Tier 0's 128-bit slots.

`instructions.tsv` counts each function's instructions in its object (`objdump -d`, without padding): the kernels', and
`scripts/funcs.c`'s, one call each of the classes the issue counted and others:

| function | main Tier 0 | main Tier 1 | PR Tier 0 | PR Tier 1 | clang -O0 | clang -O2 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `add_overflow(int, int, int*)` | 66 | 30 | 17 | 9 | 15 | 5 |
| `add_overflow(long, long, long*)` | 65 | 27 | 15 | 8 | 15 | 5 |
| `sub_overflow(long, long, long*)` | 65 | 28 | 15 | 8 | 15 | 5 |
| `mul_overflow(int, int, int*)` | 103 | 56 | 17 | 9 | 15 | 5 |
| `mul_overflow(long, long, long*)` | 102 | 54 | 15 | 9 | 15 | 5 |
| `add_overflow(unsigned long, ...)` | 58 | 16 | 17 | 6 | 15 | 5 |
| `mul_overflow(unsigned long, ...)` | 95 | 40 | 37 | 13 | 16 | 8 |
| `mul_overflow(long, unsigned long, long*)` | 100 | 49 | 47 | 23 | 35 | 20 |
| `add_overflow(long, unsigned long, int*)` | 64 | 26 | 56 | 26 | 33 | 18 |
| the `mul_long` kernel | 137 | 83 | 55 | 27 | 36 | 47 |
| the `add_long` kernel | 91 | 47 | 45 | 23 | 29 | 36 |

## Compile time

`scripts/compile.sh` (its generated `results/sqlite.sh`, one lock hold) compiles the frozen `sqlite3.c` (SHA-256 in
`results/sqlite.txt`) with the 9700X workflow's `compile_time` options (`-c -DSQLITE_OMIT_LOAD_EXTENSION
-DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`, the default target): 11 alternating whole
processes per tree, then `perf stat -r 11` of each (`results/perf-sqlite-*.csv`). Every compile exited 0, and the two
trees' objects are identical: the unit has no overflow builtin (its `GCC_VERSION` tests take the portable branches
under clang's predefines).

| sqlite3.c `-c` | main | PR |
| --- | ---: | ---: |
| wall, median of 11 | 121.57 ms | 121.85 ms |
| task-clock (perf, mean of 11) | 119.66 ms | 119.43 ms |
| user instructions (perf, mean of 11) | 1,307,822,745 | 1,307,824,613 |
| user cycles (perf, mean of 11) | 582.00 M | 581.31 M |

The lowering's new test, whether a builtin's call is a signed long's of one class, runs on its integer builtins'
emission alone; the unit's time doesn't change within the runs' spread (the wall medians 0.23% apart one way,
task-clock 0.19% the other, instructions 0.0001%).

## Limitations

- The kernels are synthetic loops of the issue's shape; programs whose time isn't in these builtins don't change.
- One host (the 9700X), one clang (23.1.1), CPU 2 only; three rounds of one process per binary, each the best of 3
  repetitions.
- The lock-wait messages that `exclusive.sh` writes (other sessions' commands, each of one line here) are removed from
  the build, preparation and run logs and from `results/sqlite.txt` by their `exclusive.sh: waiting` and
  `title:`/`link:`/`pull request:` lines. Each file is otherwise as written. `scripts/chain.sh` ran the builds,
  `prepare.sh`, `measure.sh` and `compile.sh` in turn.
