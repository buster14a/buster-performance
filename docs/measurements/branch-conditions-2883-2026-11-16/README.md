# A condition's `&&` and `||` lowered as branches (buster#2883), 2026-11-16

[buster#2883](https://github.com/buster14a/buster/issues/2883), under
[its claim](https://github.com/buster14a/buster/issues/2883#issuecomment-6922262960),
with the node machine's side agreed with the holder of its files
([the revision](https://github.com/buster14a/buster/issues/2883#issuecomment-6923333995),
[the holder's answer](https://github.com/buster14a/buster/issues/2883#issuecomment-6923501702)).
The pull request is buster#2889 (`d8b672d0`, the lowering; `ee1bcd80`, the
node machine's refusal), on main `ccbc303d`.

The lowering made `&&` and `||` a value even as a condition: `if (a < b && b < c)`
was the first compare and its branch, the second compare's value made 0 or 1,
a jump to a join where the other arm loaded 0, and the joined value tested
again: twelve instructions where `cmp; jge; cmp; jge` is four. This change
writes a statement's condition (`if`, `while`, `for`, `do`) and a
conditional's condition whose expression, under its `!`s, is an `&&` or `||`
as branches to the condition's own targets.

**Result.** The joins are left at **14 of 2,822 in `sqlite3.c`, 11 of 354 in
Lua and 18 of 1,253 in musl** (0.50%, 3.1%, 1.4%): 41 of them values (an
`&&` or `||` that is a value's `||`'s or `&&`'s first operand, out of the
claim's scope) and 2 Lua conditions of other shapes. The objects have **7.3%, 3.0% and 5.5% fewer instructions**
and 5.3%, 2.2% and 3.8% less code. The stream has 3.5%, 1.8% and 3.4% fewer
typed entries. A compile of `sqlite3.c` is **within main's own repeat** (wall
-0.06% where main again reads -0.05%, 2.44 million fewer instructions of
1.364 billion). The compiler built by Tier 0 with the change compiles
`sqlite3.c` in **4.85% fewer instructions and 2.5% less time** than the one
built without it.

## What was built

- **The lowering** (`src/buster/compiler/c_check_program_lower.c`): a
  `CHECK_LOWER_BRANCH` task, popped one level at a time (`check_lower_branch`).
  An `&&` where false and an `||` where true branch to the target on either
  operand; an `&&` where true and an `||` where false branch on their first
  operand, the other way, to a label of their own past the second; a `!` swaps
  the targets. A leaf is its value, its truth and the branch, as before.
  - A statement's `CONDITION`, popped with its control's branch under it,
    takes the branch off the stack and pushes the task with its target
    (`check_lower_condition_branches`, in the expansion and in the vector
    path's `check_lower_plain`). The `CONDITION` stays the popped root of its
    expression.
  - A conditional pushes the task in place of its test of its condition.
  - Left as they were: `&&` and `||` used as values (an `&&` that is an `||`'s
    first operand among them), a condition without one (`if (!p)`), GNU's
    `a ?: b`, and an operator whose first operand's truth the program knows.
- **The node machine** leaves the two shapes to the tasks (refused by
  `template`): a `CONDITION` whose operand is branches and a conditional whose
  condition is, asked from the machine's records
  (`node_machine_branch_condition`), on top of buster#2887.
- **Tests:** `tests/checker/branch-conditions` (two programs run natively
  against clang) and `c_check_branch_condition_test.c`.

## How it was measured

- The 9700X (`benchpress`), CPU 2, every build and run under the host's lock,
  one hold a run (`scripts/lock.sh`; `scripts/queue.sh` runs a list of them
  with 20 s between two holds).
- **The gate's pair:** `main2` is buster main `ccbc303d` (with #2877's fusion,
  buster#2884, merged at 17:25 UTC), `head2` is main with the change
  (`results/head2/head2.patch`, sha256 `d8c419d1`), both
  `./build.sh --config Release` (`scripts/build-label.sh`). Queue:
  `scripts/queue-5.txt`.
- **The pair before #2877:** `main` is main `1c6cc8ab`, `head` the same patch
  on it (queues 1 to 3; the head was rebuilt twice as the structure settled,
  and the bytes of the objects never changed). It shows the lowering's change
  alone, without the fusion of the leaves' compares.
- The corpora are #2850's: the frozen corpus's `sqlite3.c` and musl
  (`preprocessor-391e729af658`), and Lua 5.4.8 (`scripts/corpora.sh`).

## The joins

`scripts/joins.sh` (#2877's): `test %eax,%eax; setne %al; movzbl %al,%eax;
jmp; xor %eax,%eax` or `mov $K,%eax`; `test %eax,%eax; je/jne`, and those
with `setCC %al; movzbl %al,%eax` before.

| | main2 | head2 | left | main (before #2877) | head |
| --- | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 2,822 | 14 | 0.50% | 2,819 | 14 |
| Lua 5.4.8 | 354 | 11 | 3.1% | 340 | 11 |
| musl | 1,253 | 18 | 1.4% | 1,248 | 18 |

**What is left, by its reason** (each site's function read in the source):

- **41 are values** whose first operand is an `&&` or `||`, which the value
  tests and branches on: returned (`return a && b && c;`: musl's
  `__loc_is_allocated`, `iswcntrl`, `is_lost_conn`, `ascii_is_unsafe`, Lua's
  `isKstr`, `l_checkmode`, `luaV_equalobj`, `luaV_flttointeger`'s
  `lua_numbertointeger`, SQLite's `isFatalError`, `allowedOp`,
  `sqlite3ExprCanBeNull`, `sqlite3RealSameAsInt`), assigned (SQLite's
  `isMemdb`, `isNewJrnl`, `isSpecialError`, `isSearch`, `identPut`'s, musl's
  `builtin` and blowfish's `ok`), or an expression statement (musl's
  `getenv(...) && *val || ...` and `__getopt_msg`'s chain of `&&`, Lua's
  `luaL_argcheck` and `luaL_argexpected`, `l_likely(c) || error()`). All 14 of
  `sqlite3.c`'s and all 18 of musl's are these. The claim left values as they
  are.
- **2 are conditions of other shapes,** both in Lua: `check_capture`'s
  `if (l_unlikely(a || b || c))`, whose `||` is under `__builtin_expect` and a
  `!= 0` (`luai_unlikely`), and `luaV_modf`'s `luai_nummod`,
  `if ((m > 0) ? b < 0 : (m < 0 && b != m))`, a conditional whose arm is an
  `&&`. A condition is branches only where it is an `&&` or `||` under `!`s.

## The objects

`scripts/objects.sh`, `scripts/shapes.sh`:

| | instructions | `.text` bytes | object bytes |
| --- | ---: | ---: | ---: |
| `sqlite3.c` | 327,214 to 303,456 (-7.26%) | 1,146,328 to 1,085,736 (-5.29%) | 2,122,168 to 2,061,544 |
| Lua 5.4.8 | 86,328 to 83,767 (-2.97%) | 298,477 to 291,958 (-2.18%) | 771,640 to 765,112 |
| musl | 189,730 to 179,263 (-5.52%) | 720,292 to 692,788 (-3.82%) | 2,545,232 to 2,517,664 |

Before #2877: 354,742 to 337,323 (-4.91%), 91,332 to 89,290 (-2.24%),
204,187 to 195,598 (-4.21%) instructions.

## The stream

`measure-tier0-entries` (`scripts/census.sh`) and `benchmark-backend-source`
(`scripts/backend.sh`, three runs each, medians):

| | typed entries | records | Tier 0's vector path, cycles an entry | branch sizing | encoder |
| --- | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 395,061 to 381,259 (-3.49%) | 327,214 to 303,456 | 65.25 to 66.11 | 5.14 to 5.07 | 3.56 to 3.47 |
| Lua 5.4.8 | 89,543 to 87,935 (-1.80%) | 86,328 to 83,767 | 86.16 to 86.98 | 6.44 to 6.48 | 4.42 to 4.41 |
| musl | 199,891 to 193,159 (-3.37%) | 189,698 to 179,231 | 99.15 to 101.21 | 6.49 to 6.45 | 4.55 to 4.48 |

The entries removed were cheap ones (a constant, a test, a join's jump and
label), so Tier 0's cycles an entry rise while its cycles a file fall:
`sqlite3.c` 25.78 to 25.20 million (-2.2%), Lua 7.72 to 7.65, musl 19.82 to
19.55. The conditional branches are as many (16,876 in `sqlite3.c`); 11,127
of them now take a compare behind its test against zero (#2877's fusion), from
8,952.

## The compile, `-c sqlite3.c`

`scripts/compare.sh main2 head2 3`: whole processes, three comparisons of 21
runs of base, head and base again in a Williams order, each run its own hold.

| | wall | user cycles | instructions |
| --- | ---: | ---: | ---: |
| main | 122.307 ms | 594,908,978 | 1,364,249,104 |
| this change | 122.238 ms (-0.06%) | 595,406,043 (+0.08%) | 1,361,804,452 (-0.18%) |
| main again | 122.241 ms (-0.05%) | 594,977,802 (+0.01%) | 1,364,249,101 |

Medians of the 63 runs of each build. Each comparison alone, wall against
base: head -0.20%, +0.25%, -0.33%; base again -0.17%, +0.06%, -0.25%. Within
main's own repeat.

**Many small compiles** (`scripts/stat.sh`, `perf stat` of each corpus's
compiles, a process a file; Lua and musl in alternating holds, three rounds):

| | user cycles, main2 | head2 | instructions |
| --- | ---: | ---: | ---: |
| Lua's 34, rounds 1 to 3 | 545.1, 566.0 (a hold of 3.2% spread), 545.1 M | 545.3, 544.3, 544.6 M | -0.01% |
| musl's 1,336, rounds 1 to 3 | 5,399.3, 5,391.0, 5,393.6 M | 5,377.2, 5,375.1, 5,402.1 M | -0.01% |

## At run time

The compiler built by each build from this change's sources (43 units by
Tier 0, `scripts/selfbuild2.sh`), timed compiling `sqlite3.c` (three
comparisons of 21 runs):

| the compiler built by | its `.text` | wall | user cycles | instructions |
| --- | ---: | ---: | ---: | ---: |
| main2 | 86,879,461 | 995.8 ms | 5,426,038,133 | 10,109,089,145 |
| head2 | 84,916,581 (-2.26%) | 970.6 ms (-2.54%) | 5,288,044,850 (-2.54%) | 9,618,707,078 (-4.85%) |
| main2 again | | 998.1 ms (+0.22%) | 5,440,342,675 (+0.26%) | 10,109,089,147 |

The self-host qualification (`scripts/qualify.sh`, `tools/ci/selfhost.c`)
passes: 43 units, 14 smoke commands, 5 probes, 10 byte comparisons, 10
executable runs (`results/head2/qualify`).

## The node machine

The node machine (#2524, #2850) writes the same stream and is checked exact
against it. It doesn't write a condition's branches yet, so C leaves the two
shapes to the tasks (`node_machine_branch_condition`, the lowering's rule read
from the machine's records, as C also runs at reader time), refused by
`template`. Counted in the cloud container (counts, not timings), by the
change with that refusal on top of buster#2887 (`5eb316fb`), `--list 3`
(`scripts/cloud/shadow-modes2.sh`, `results/cloud/shadow-on-2887-summary.txt`):

| `measure-node-machine --shadow` | `sqlite3.c` | Lua | musl | `main.c` |
| --- | ---: | ---: | ---: | ---: |
| census-taken expressions, as on main | 51,338 (98.03%) | 10,829 (93.66%) | 23,037 (86.93%) | 19,954 (71.98%) |
| machine-taken expressions: main | 51,047 | 10,433 | 21,561 | |
| machine-taken expressions: this change | 48,884 (95.22%) | 10,131 (93.55%) | 20,636 (89.58%) | 16,218 (81.28%) |
| machine-taken evaluated nodes: main, this change | 98.85%, 89.80% | 94.32%, 86.39% | 91.13%, 82.89% | , 61.99% |
| refused by `template`: main, this change | 291, 2,454 | 395, 697 | 1,414, 2,339 | |

- **On the pull request's final tree** (`ee1bcd80`, on main): `test-checker`
  passes whole, 842,718 checks, 0 failures (`results/cloud/checker-final.txt`),
  and the shadow's six modes that exist on main exit 0 with no difference on
  the three corpora, with the counts above
  (`results/cloud/shadow-final-summary.txt`).
- **`test-checker` on the tree on top of #2887 passes whole:** 842,723 checks, 0 failures
  (`results/cloud/checker-on-2887-with-refusal.txt`; the refusal's diff is
  `results/cloud/node-machine-on-2887.patch`).
- **Exit status 0 and no difference in values, entries or the twin** in each
  of ten modes on each of the four inputs: plain, `--verify`, `-g`,
  `--fused`, `--facts --facts-operators`, `--facts-reads`, `--front-types`,
  `--front-sweeps`, and `--front-tests` with the default warnings and with
  `-Wall -Wextra`.
- **At reader time** (`--front-tests`): taken there and refused by the census
  0, tests that differ 0, root kinds that differ 0, on the four inputs with
  either set of warnings. C and X there (`--front-sweeps`) compare 50,558,
  10,544, 22,324 and 13,484 expressions with no difference; they refuse 2,964,
  758, 3,192 and 7,173 by template (#2887's description reads 842, 473 and
  2,347 on the three corpora before this change).
- **What the refusal costs the machine** is about 9 points of the evaluated
  nodes it takes, the conditions with `&&` and `||`, which are large
  expressions. Writing them as branches in C and X is the follow-up the holder
  of the files takes under #2524.
- **Without the refusal** the shadow differs: on main `1c6cc8ab` with the
  change alone (`results/head/shadow-*.txt`, the 9700X), 2,163, 302 and 925
  expressions' entries differ and each run exits 1; the census's counts are
  main's. The same refusal asked of the program instead of the records (tried
  first on main) gave the same counts.

## Correctness

In the cloud container (4 CPUs, the frozen corpus, c-testsuite and SQLite's
tree fetched by `tools/ci/fetch-*.sh`), the branch on main `ccbc303d`:

- **The correctness inventory** (`tools/ci/correctness.tests`, the parallel
  runner, `results/cloud/inventory-native.txt`) on the native build: 135 of
  150 commands passed, 2 skipped (no Tcl, no GNU disassembler), 13 failed:
  - **9 are this container's tools**, and fail the same way with main's
    compiler (`results/cloud/inventory-environment-main.txt`): clang 23.1.6
    where the oracles want CI's 23.1.4 (the preprocessor's two, the integer
    builtins' two), GNU as, mold and perf (branch sizing, the object writer,
    the assembler, streaming), and lld's documented differences (the foreign
    linker);
  - **2 read `build/predefines.h`**, which the build wipes, and pass with it
    regenerated (`results/cloud/inventory-rerun-predefines.txt`);
  - **`test-checker`'s part 7** hit the harness's 60 s limit on clang's own
    oracle build under the load, and passes alone (71,300 checks);
  - **`test-checker`'s part 5** is the node machine's fixture line
    `if (a && (b || c)) // machine: taken`, which the machine's refusal
    changes to `template`. With the refusal `test-checker` passes whole:
    842,716 checks on main and 842,723 on top of #2887, 0 failures.
  - Among those that passed: SQLite's shell by both tiers against clang's,
    c-testsuite end to end by Tier 0 and by Tier 1, the semantic driver's
    eight parts against clang, `test-tier0`, the node templates on
    c-testsuite and SQLite, the lanes, the differential harness, `main.c`
    against clang and by both paths, and the IR's and SSA's passes over
    c-testsuite, SQLite and musl.
- **`BUSTER_HOST_ARCH=x86-64`:** `test-checker` 845,463 checks with the same 3
  failures of the node machine's fixture line; c-testsuite against clang by
  Tier 0 and by Tier 1, 220 of 220 each; `test-tier0 --cross-check`,
  21,550,459 checks, 0 failed.
- **Both host paths write the same bytes:** the objects of the three corpora
  by the native and the `x86-64` builds are the same files (1,371 of them).
- **The sanitizers** (a pull request's own checks don't run them): `x86-64`
  Release under MemorySanitizer, AddressSanitizer and ThreadSanitizer, with
  CI's fatal options (`tools/ci/sanitizers.sh`): `test-checker`'s part 4 (the
  new fixtures, run natively against clang) 60,883 checks and 0 failures in
  each; its part 5 (the census and the shadow) 210,262 checks with the same 3
  failures of the node machine's fixture line, status 1, not a report; and
  `-c sqlite3.c`, whose object is the native build's to the byte. No sanitizer
  reported anything.
- **Six mutants** (`scripts/cloud/mutants-build.sh`, `mutants-test.sh`: each a
  copy of the tree with one change, built, `test-checker` whole), each failing
  the new tests:

  | mutant | failures | caught by |
  | --- | ---: | --- |
  | a statement's condition not taken as branches | 32 | the shapes' functions 0 to 7 (a join, a value tested again) |
  | an `&&` or `\|\|`'s operands pushed in the other order | 7 | the order program against clang (its trace) |
  | the first operand's branch past the second not inverted | 103 | both programs against clang |
  | a `!` that doesn't swap the targets | 11 | both programs against clang |
  | a conditional's condition not taken as branches | 11 | the shapes' functions 8 and 9 |
  | the vector path's `CONDITION` not taken as branches | 173 | the shapes on that path's lowering, and the check that both paths' typed functions agree |

## Files

- `scripts/`: the 9700X runners (#2877's, renamed, with `build-label.sh` taking
  several patches, `shadow.sh`, `selfbuild2.sh` on head2's tree and `after.sh`).
  `scripts/cloud/`: the cloud session's runners (the objects' counts, the
  shadow's modes, the native suites, the mutants).
- `results/main2`, `results/head2`: the gate's pair. `results/main`,
  `results/head`: the pair before #2877. `results/queue.log`: every queued
  run's start and status.
