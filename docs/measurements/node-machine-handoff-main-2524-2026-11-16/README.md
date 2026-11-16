# buster#2524's hand-off series on today's main, with buster#2882: C and X, and the tests, at reader time (2026-11-16)

The first two commits of [the hand-off series](../node-machine-own-tests-2524-2026-11-16/patches/handoff)
(`0001`, C and X where they sit, and `0002`, the tests where they sit) re-picked on main `1c6cc8ab5`, under
[the claim on buster#2524](https://github.com/buster14a/buster/issues/2524#issuecomment-6919991971), with two
fixes that the compiler's own source asked for: buster#2882
([claimed there](https://github.com/buster14a/buster/issues/2882#issuecomment-6919987408)) before them, and one
after them. The pull request is opened from buster's branch `claude/exciting-archimedes-agaary` once this record is
on main; its number is added here then. It is all the node machine's shadow (`measure-node-machine --shadow`): no
compile takes any of it.

**Result.** On today's main the series is what its records say: at reader time C and X give the shadow's tape on
every expression compared (50,555, 10,544 and 22,324 on `sqlite3.c`, Lua and musl, 0 differences), and the tests
take nothing the census refuses and differ in no bit, with the default warnings and with `-Wall -Wextra`. The
ticks are the hand-off's within 1% to 4%. A compile is unchanged. **Two things were found on the way, both on the
compiler's own source, which no shadow run could read before:**

- **buster#2882:** the shadow's comparison did not know the lowering's rewrite of a named result (buster#1375):
  192 false differences on `main.c`, and exit status 1 there with every option.
- **A string in a body that is never lowered:** the census's test of a returned address took a string's object for
  a local where the selection gives it no symbol. The tests at reader time, compared in such bodies too, took two
  returns of `main.c` that the census refused. Reader time was right.

## 1. The four commits

| commit | what | from |
| --- | --- | --- |
| `8b79e674d` | the shadow's comparison knows a named result (buster#2882) | this session |
| `ba9eebaba` | C and X where they sit, at reader time (`--front-sweeps`) | the hand-off's `0001`, by `git am --3way` |
| `3717c4c74` | the tests where they sit, at reader time (`--front-tests`) | the hand-off's `0002`, the same way |
| `5eb316fb2` | a string's object is no local in a body that is never lowered | this session |

`git am --3way` kept each of the hand-off's commits' author, message and sign-off. What it met on main `1c6cc8ab5`
(the series' base was `3d0d56ed7`; buster#2875, buster#2878 and buster#2880 came in between):

- `0001`: buster#2875's terms in `c_check_node_census.c`'s exit-status expression, and the shadow's fixture's
  comment, where buster#2882's sentence sits.
- `0002`: the same file's usage comment, its options' check and the exit-status expression again.

Both sides are kept in each. Nothing else conflicted, and the fixture's text merged by itself (the hand-off's lines
are inside its long function, buster#2882's two functions after it).

## 2. buster#2882: a named result in the comparison

- **What it was.** buster#1375 (buster#2675, on main since 2026-11-14) builds a returned local where the hidden
  pointer points. `check_lower_named_rewrite` goes over the function's entries once the tasks wrote them and makes
  each `LOCAL_ADDRESS` of that local a `LOCAL` of the pointer. The shadow compares its tape with the entries after
  that pass, and the tape has the local's address, as the tasks had.
- **How it showed.** `named/named.c` is a 20-line function that returns its one local: 5 of its expressions
  differ. `named/main-before.txt` has the compiler's own source at main `1c6cc8ab5`: 192 expressions (132
  statements, 49 conditions, 11 initializers), each one's first different entry the tape's `LOCAL_ADDRESS` against
  the stream's `LOCAL 0` of class U64 (read with a print added at the first entry that differs, not kept).
- **Since when.** `docs/node-machine.md` said `main.c` had no difference, which was so before buster#2675. A run
  of 2026-11-15 under a baseline host's predefines read 169.
- **The fix.** The inventory's log (`CheckLowerOwners.named`, two words a body) keeps each body's named local and
  hidden pointer's local, written where the labels' entries are, and `node_shadow_same_entries` takes the stream's
  `LOCAL` of the hidden pointer at a tape's `LOCAL_ADDRESS` for the same entry, the tape's object bound to the
  named local in the body's map of objects and locals.
- **The reverse check.** With the comparison's term disabled, the shadow's fixture (which gained a function with
  a named result) fails in its three runs, 6 entries differing in each.
- **After it:** `main.c` has no difference, plain and with `--verify`, `-g`, `--facts --facts-operators` and
  `--facts-reads`, and the command exits 0. So nothing else was behind the first different entry.

## 3. A string in a body that is never lowered

Found by `--front-tests` on the compiler's own source, in the native MemorySanitizer row's run of it
(`named/main-front-tests-before-strings-fix.txt`, here from a plain build of the next commit of the series, whose
tests' code is the same):

```text
node-shadow: reader-time tests difference file=src/buster/compiler/main.c line=324 never-lowered tests=0x800000 (reader 0) kind=return (reader return) reader-takes=yes UNSOUND
node-shadow: reader-time tests difference file=src/buster/compiler/main.c line=3993 never-lowered tests=0x800000 (reader 0) kind=return (reader return) reader-takes=yes UNSOUND
```

- **The two lines** are `c_builtin_library.c`'s 324 and `assembler.c`'s 3993: each a
  `return a ? "one" : b ? "two" : "three";` in a function the selection leaves out (the file's name in the line is
  the unit's).
- **Why the census refused them.** `0x800000` is the test of a returned address. `node_census_local_object` calls
  an object a local where it has no symbol and no static declaration. A string's object has no declaration, and in
  a body that is never lowered it has no symbol either. Before `0002` the census never read such a body; the
  comparison of the tests at reader time does.
- **Why reader time took them.** There a string's object stands for its own symbol (`0001`'s columns), so it is
  no local. That is the right answer: no warning is due.
- **The fix.** `node_census_local_object` takes the value's own flag too (`BUSTER_CHECK_STATIC_OBJECT`, which a
  string's value has). The census's own reports are the same: in a lowered body a string has its symbol.
- **The reverse check.** The clean fixture gained a function the selection leaves out whose returns are strings.
  Without the new term its reader-time run fails: 2 expressions taken there that the census refuses.
- **The three corpora have none:** `sqlite3.c`, Lua and musl read 0 before the fix and after it.

## 4. The 9700X

Release builds, CPU 2, under the lock, a hold a run (`scripts/job1.sh`, `scripts/job2.sh`; `results/tables.txt` by
`scripts/tables.py`). `main` is `1c6cc8ab5`. `head` is that main with the branch's `src`, `tools` and `tests`
before the last commit (`patches/head.patch`); `head2` with it (`patches/head2.patch`).

### At reader time, by `head`

Every reading gives the same counts (seven on `sqlite3.c` and Lua, three on musl), and `head2`'s one reading a
corpus gives them again.

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| expressions T took at reader time, which the tests ran on | 51,185 | 10,859 | 43,481 |
| compared with the census: lowered; never lowered | 51,122; 63 | 10,846; 13 | 22,518; 20,963 |
| taken there and refused by the census; tests that differ; root kinds that differ | 0; 0; 0 | 0; 0; 0 | 0; 0; 0 |
| refused there by a test; of them, ones C and X take | 567; 4 | 302; 208 | 435; 298 |
| with `-Wall -Wextra`: refused there; of them, ones C and X take | 3,821; 3,256 | 824; 728 | 2,408; 2,243 |
| with `-Wall -Wextra`: taken there and refused by the census; tests that differ | 0; 0 | 0; 0 | 0; 0 |
| `--verify` there: values not the action's; nodes whose action warns | 0; 0 | 0; 0 | 0; 0 |
| declarations' discards left alone | 5,355 | 2,275 | 13,991 |
| C and X there: taken; refused for a template or a row | 50,343; 842 | 10,386; 473 | 41,134; 2,347 |
| compared with the shadow's C and X: expressions; entries; differences | 50,555; 331,155; 0 | 10,544; 65,963; 0 | 22,324; 133,898; 0 |
| patched in them: globals' entries; direct calls | 2,199; 12,555 | 668; 3,845 | 2,396; 4,871 |

These are the hand-off's counts, to the expression.

TSC ticks a record T typed at reader time, medians of the readings in turn (their ranges in `results/tables.txt`):

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| T alone (`--front-types`) | 71.2 | 94.0 | 152.3 |
| T, C and X (`--front-sweeps`) | 134.1 | 158.9 | 251.5 |
| with the tests between T and C (`--front-tests`) | 299.9 | 343.6 | 505.3 |
| C and X in place (the difference) | 62.9 | 64.9 | 99.2 |
| the tests (the difference) | 165.8 | 184.7 | 253.8 |
| the hand-off's, at main `be6515fba`: the three sweeps; the tests | 134.3; 165.5 | 158.5; 179.9 | 254.1; 274.0 |

### Main against the branch

| | `main` | the branch |
| --- | ---: | ---: |
| `-c sqlite3.c`, instructions (`head2`) | 1,364,589,356 | 1,364,582,348 |
| its wall time, 21 runs a build from three fresh copies, twice (`head2`) | 122.711 ms; 122.715 ms | -0.37%; -0.31% |
| `main` against itself in the same runs | | -0.24%; -0.33% |
| its user cycles (`head2`); `main` against itself | | -0.13%; -0.13%; and -0.12%; -0.12% |
| the same comparison by `head`: instructions; wall; `main` against itself | 1,364,589,353 | 1,364,580,262; -0.38%, -0.19%; -0.27%, +0.11% |
| T alone at reader time, all its ticks, M: `sqlite3.c`; Lua; musl | 21.42; 7.80; 35.10 | 20.79; 7.21; 34.28 |
| the expressions it ran on | 56,681; 13,184; 57,888 | 51,326; 10,909; 43,897 |
| the shadow's T, C and X after the pipeline, cycles an evaluated node | 180.0; 154.3; 139.1 | 179.0; 151.7; 136.8 |
| their instructions | 595.0; 684.4; 646.1 | 594.3; 683.7; 645.6 |
| buster#2850's fact words, the first pass's cycles a record: `sqlite3.c`; musl | 24.12; 20.26 | 23.68; 20.26 |
| the same with the operators | 43.47; 38.94 | 42.95; 38.95 |
| their instructions a record | 93.17; 89.26; 149.38; 169.89 | the same |

- **A compile is unchanged.**
- **T alone at reader time runs on fewer expressions** (`0002` leaves a declaration's discard alone), so its
  total is 2.9%, 7.6% and 2.3% lower while a typed record reads dearer: the cheap records left the count.
- **The census's own reports** (no shadow) are `main`'s line for line on the three corpora, with the default
  warnings and with `-Wall -Wextra`, by `head` and by `head2`.

## 5. The sanitizer rows

A pull request's checks don't run them. In the cloud container (4 CPUs), Release builds as CI's rows build them
(`-O3`), on the branch's final sources (`5eb316fb2`; `scripts/sanitizers.sh`, then `scripts/sanitizers-2.sh`, as
they ran; `sanitizers/progress.txt`): the part of `test-checker` with the census's tests, and for the memory and
address rows the shadow with `--verify --front-tests` on `sqlite3.c`, Lua and the compiler's own source. The
address row is CI's `-fsanitize=address,undefined,bounds`.

| row | `test-checker --seed 133 --part 5/8` | the shadow's exit status: `sqlite3.c`; Lua; the compiler's own source | reports |
| --- | --- | --- | --- |
| `x86-64`, memory | 210,269 checks, 0 failures | 0; 0; 0 | none |
| `x86-64`, address | 210,269 checks, 0 failures | 0; 0; 0 | none |
| `x86-64`, thread | 210,269 checks, 0 failures | not run | none |
| native, memory | 210,305 checks, 0 failures | 0; 0; 0 | none |
| native, address | 210,305 checks, 0 failures | 0; 0; 0 | none |
| native, thread | 210,305 checks, 0 failures | not run | none |

- **No sanitizer reported anything,** on these sources or on the ones before the last commit
  (`sanitizers/progress-before-strings-fix.txt`, whose rows stop where the chain was stopped for that commit).
- **The one status 1** is in that earlier file: the native memory row's shadow run on the compiler's own source,
  which is how section 3's two lines were found. It is the shadow's own exit status for a difference, not a report.
- **The whole `test-checker`** (eight parts, a plain native Release build of the same sources): 842,487 checks, 0
  failures.

The reader-time code runs beside the reader's coded walk, the vector paths', so the native rows are the ones that
reach it: an `x86-64` row's shadow run reads no front.

## Files

- `results/main`, `results/head`, `results/head2`: each build's log, revision and compiler's checksum, and the
  runs (`types-`, `sweeps-`, `tests-`, `tests-wall-`, `verify-`, `sweeps-lean-`: the shadow at reader time;
  `shadow-`: the shadow alone; `facts-`, `facts-operators-`: buster#2850's kernels; `census-`, `census-wall-`:
  the census alone; `compile-`: the whole compile's comparison). `results/tables.txt` is their summary.
- `scripts`: the 9700X's (`setup.sh`, `lock.sh`, `corpora.sh`, `build-label.sh`, `turns.sh`, `compile.sh`,
  `job1.sh`, `job2.sh`), `tables.py`, and the cloud container's `sanitizers.sh`, `sanitizers-2.sh` and
  `sanitizers-chain.sh` (which ran the second after the first), with that container's paths as they were.
- `patches`: `fix.patch` (buster#2882's fix alone), `head.patch` and `head2.patch`, each against main
  `1c6cc8ab5`'s `src`, `tools` and `tests`.
- `named`: the reproduction of buster#2882 and the compiler's own source before each fix.
- `sanitizers`: the rows' progress (`progress.txt`: the final sources'), each row's build log, `test-checker`
  output and shadow outputs. No row wrote a report.
