# The tests on the window, second half: what is left, and the constants with no test to make (buster#2850, step 2): 2026-11-17

The second half of [the piece's specification](https://github.com/buster14a/buster/issues/2850#issuecomment-6951406678),
after [the first half](../window-tests-2850-2026-11-17/README.md) (buster14a/buster#2948). Sections 1 to 5 are its
groundwork: experiment builds and a first form of the rule, each a patch here against main `9a1422eab` (they hold the
first half's sources). Sections 6 to 10 are the rule as its pull request has it (buster14a/buster#2955), on main
`aa09d1a04`, and the forms tried on the way.

- 9700X: CPU 2, Release, each run its own hold of the lock, readings in turn; the directory and scripts of the
  first half's record, and `scripts/turns-env.sh` (one executable, a setting a turn by its environment).
- TSC ticks a record of the expressions the tests ran on. Medians of three readings (`x1`, `x2`) or seven (`q1`,
  `q2`; musl's of three).

## 1. What the tests that read T's records are (`patches/tests-x1.patch`, `results/9700x/x1`)

An experiment build with switches (`BUSTER_TESTS_SKIP`) that leave parts of `node_tests_expression` out; each
part is the difference of two settings of the same executable. Its verdicts are then wrong, and only its ticks are
read.

| the tests on T's records | `sqlite3.c` | Lua |
| --- | ---: | ---: |
| all | 38.0 | 52.4 |
| the operators' tests (`node_tests_operator`) | 19.2 | 30.3 |
| the call's fixed part (the root's kind, the pragmas' bodies, the events, the lists' frame) | 6.3 | 6.5 |
| the tree's tests | 4.0 | 4.0 |
| the root's own | 3.1 | 4.5 |
| the unsequenced test | 1.9 | 3.0 |
| what is left with no call at all: T between other code, the root's bytes | 3.5 | 4.2 |

The settings' readings: `sqlite3.c` 37.99 (0), 34.00 (1: no tree's tests), 18.77 (2: no operators'), 14.82 (3),
12.94 (7: and no unsequenced test), 9.80 (15: and no root's), 3.47 (16: no call). Lua 52.35, 48.37, 22.09, 18.23,
15.26, 10.73, 4.21.

## 2. The operators' tests, by what they are (`patches/tests-x2.patch`, `results/9700x/x2`)

The same with switches inside `node_tests_operator`. The switches themselves cost this build 4 ticks a record (all:
42.2 on `sqlite3.c` where `x1` reads 38.0), so the parts are read as differences, in this build's ticks.

| | `sqlite3.c` | Lua |
| --- | ---: | ---: |
| operators listed | 48,645 | 16,513 |
| of them: for a constant operand alone | 27,241 | 8,742 |
| calls | 12,918 | 4,182 |
| the rest | 8,486 | 3,589 |
| ticks a record: a constant operand alone | 8.0 | 9.9 |
| calls | 5.4 | 6.2 |
| the rest | 3.1 | 7.7 |
| the loop over the list and the call | 3.4 | 4.8 |
| what every listed operator loads first | 2.6 | 3.1 |

## 3. What the constants' tests conclude (`patches/tests-x5.patch`, `results/cloud/x3`, `x5`)

Counted in the cloud container (counts, not times).

- **97% conclude nothing.** Of `sqlite3.c`'s 27,243 operators listed for a constant operand alone, 26,466 have no
  test that fires and send nothing; 777 go to the census's code; none fires in place. Lua: 8,582 of 8,742.
- **A rule on bytes covers most of those.** `node_tests_quiet` in the patch, a predicate beside the tests: every
  operand's type a plain integer of 8 to 64 bits (no enumeration, no bit-field), and by the operator's class: `+ - *
  & | ^`, their assignments and the unary ones, any constant; `== !=`, a constant against no constant zero or 1 to
  126, or a pointer against zero; `< <= > >=`, 1 to 126, or zero against a signed operand; a shift (not under
  `-Wshift-sign-overflow`), a count under 32 and a shifted constant zero or 1 to 126; `/ %`, a divisor 1 to 126; `=`,
  an initialization and a return's conversion, the result's type a plain integer too and the constant zero or 1 to
  126.

| the rule's operators, of those listed for a constant alone | default warnings | `-Wall -Wextra` |
| --- | ---: | ---: |
| `sqlite3.c` | 20,956 of 27,243 | 10,206 of 14,228 |
| Lua | 7,036 of 8,742 | 5,724 of 6,882 |
| musl | 14,481 of 22,537 | 10,597 of 15,427 |
| the compiler's own source | 22,746 of 27,511 | 11,058 of 13,077 |
| of them with a test that fired or a record sent | 0 | 0 |

Not covered: a subscript of an array by a constant (its length is asked), pointer arithmetic, `p = 0`.

## 4. The rule in the loop, 64 records a step (`patches/tests-q1.patch`, `tests-q2.patch`; work in progress)

- The records' bytes' pass makes one more byte a record (`window_plains`): its type a plain integer by its word (the
  kind, the class, no fact, none of the six bits), signed, a plain pointer; and, an integer constant the record
  holds whole, zero, 1 to 126, 0 to 31, from its payload.
- The loop reads each side's such byte by its distance, the operator's class by one more table, and takes the
  rule's operators out of its list.
- With the reader's verify, each operator left out runs `node_tests_operator` all the same, and must find and send
  nothing.

Exact in the cloud container on the four corpora, with the default warnings and with every warning under
`--verify`: no expression differs, and no operator left out has a test (`results/cloud/q1`, `q2`). `q1`'s counts
are the predicate's.

On the 9700X, in turn with the first half's build (`o`):

| ticks a record | `sqlite3.c` `o` | `q1` | `q2` | Lua `o` | `q1` | `q2` |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| all | 54.3, 54.1 | 53.1 | 51.4 | 69.9, 69.6 | 67.8 | 66.1 |
| the records' bytes | 9.0, 8.9 | 11.9 | 10.8 | 9.8, 9.8 | 13.2 | 12.1 |
| the loop | 0.7, 0.7 | 1.2 | 1.2 | 0.9, 0.9 | 1.8 | 1.8 |
| an expression's part | 7.2, 7.2 | 7.8 | 7.8 | 7.7, 7.6 | 8.1 | 8.1 |
| the tests on T's records | 37.3, 37.2 | 32.2 | 31.7 | 51.4, 51.1 | 44.6 | 44.1 |

(`o` was read twice, once in each job's turns.) musl, three readings: `o` 122.0 and 116.9, `q1` 125.1, `q2` 116.1.

- **`q1`: the payload's two halves by two masked gathers.** The tests fall by 5.1 and the bytes rise by 2.9: 1.2
  less in all on `sqlite3.c`. A masked gather costs what a gather costs.
- **`q2`: one gather,** of the constants of types of 32 bits at most, whose value is the payload's low half (40 fewer
  operators covered on `sqlite3.c`). 2.6 less in all on `sqlite3.c`, 3.6 on Lua, 0.8 on musl.
- **The rule's inputs cost half of what it saves.** The tests fall by 5.5 on `sqlite3.c`; the bytes, the loop and an
  expression's part rise by 2.9.

## 5. What it says of the second half

- **Each gather of a field of the kernel's record is about 1.4 ticks a record.** The six of the first half are its
  8.9. A byte the kernel wrote as it made the record would cost a store.
- **The operators' tests are half of what is left** (19.2 of 38.0), a call's 114 ticks an operator.
- **3.5 ticks are T's second run's residue** and go with it.
- **The gate (40) is 14 away.** The rule as it is gives 2.6.

## 6. The rule as it landed (`patches/tests-f2-on-main.patch`, `results/9700x/f2`)

The pull request's sources, on main `aa09d1a04`, which has the first half (`main2` is that main's build). What
changed from section 4's work in progress:

- **A record says its constant's value.** No gather of the payload: a record's exponent, which only a floating value
  used, says the payload and one (0xffff past 0xfffd, 0 for none), written where the record is made
  (`node_facts_small`). The standing's gather has it. T's own record says none.
- **A kind a record,** in three spare bits of the value's byte: none, a plain pointer, a plain integer signed or
  unsigned, an integer constant zero, 1 to 31, 32 to 126 or other. No column of its own.
- **One table by the pair:** 64 bytes by the two operands' kinds, the classes the pair is left out for; one byte
  permute a step of 64 records.
- **The verify's words** (the operators left out, by expression) are made in a loop of their own, after the timed
  sweep.

TSC ticks a record of the expressions the tests ran on; `f2` and `main2` in turn; medians of seven readings, musl's of
fifteen; with every warning of five, musl's of fifteen:

| | `sqlite3.c` `main2` | `f2` | Lua `main2` | `f2` | musl `main2` | `f2` |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| all | 54.68 | 48.69 | 69.97 | 63.20 | 111.91 | 108.71 |
| the records' bytes | 8.96 | 9.33 | 9.73 | 10.37 | 16.91 | 17.93 |
| the loop | 0.72 | 0.85 | 0.96 | 1.11 | 2.22 | 2.41 |
| an expression's part | 7.21 | 7.43 | 7.57 | 7.71 | 13.13 | 12.72 |
| the tests on T's records | 37.78 | 30.98 | 51.63 | 43.88 | 80.29 | 75.42 |
| operators listed | 48,645 | 27,750 | 16,513 | 9,486 | 36,260 | 21,783 |
| with every warning: all | 73.01 | 70.13 | 81.72 | 76.89 | 131.06 | 130.42 |
| operators listed | 62,602 | 52,451 | 19,138 | 13,420 | 45,924 | 35,327 |
| beside `--verify`, one reading | 61.69 | 71.15 | 79.06 | 87.23 | 127.58 | 139.46 |
| the window without the tests: the kernel in place | 15.55 | 15.69 | 20.15 | 20.24 | 18.88 | 18.73 |
| the front | 52.49 | 52.78 | 70.39 | 70.28 | 86.92 | 88.31 |
| the names' pass, a name | 22.42 | 22.58 | 94.10 | 93.76 | 68.50 | 68.24 |

- No expression differs in any run, and beside `--verify` no operator left out has a test (20,895, 7,027 and 14,477
  checked) and no value said is another than its payload (46,532, 16,700 and 30,664 checked).
- `-c sqlite3.c` (`compile-1.txt`, `compile-2.txt`: 21 runs a build, twice): wall -0.07% and -0.01%, user cycles
  +0.15% and -0.01%; `main2` against itself -0.08% and +0.04%, +0.05% and +0.03%.

## 7. The forms tried on the way (`results/9700x/k2`, `p4`, `p5`, `s1`, `s2`, `s3`, `s5`, `s6`, `f1`)

Each in turn with `main2` (`results/9700x/main2/vs-<label>-*`). `sqlite3.c`, medians of seven:

| | all | bytes | loop | part | T's records | what it is |
| --- | ---: | ---: | ---: | ---: | ---: | --- |
| `main2` | 54.3 to 54.7 | 8.9 | 0.8 | 7.2 | 37.5 | |
| `p4` | 51.33 | 10.70 | 1.07 | 7.87 | 31.66 | section 4's `q2` with its fixtures: one masked gather of the payload |
| `p5` | 51.92 | 11.09 | 1.12 | 7.89 | 31.66 | a literal's value from the front's column, a gather for the other constants |
| `k2` | 48.33 | 6.94 | 1.20 | 7.92 | 32.24 | the kernel writes a record's three tests' bytes as it makes it; the pass gathers them |
| `s1` | 50.33 | 9.73 | 1.05 | 7.90 | 31.70 | the value said in the exponent; the rule as fourteen byte tests and mask logic |
| `s2` | 50.20 | 9.30 | 0.80 | 7.26 | 32.67 | the rule as one table by the pair; the verify's words out of the sweep |
| `s3` | 48.97 | 9.39 | 0.79 | 7.38 | 31.42 | the value said is the payload's alone |
| `s5` | 49.31 | 9.36 | 0.80 | 7.34 | 31.75 | a plain copy says what its operand says; a pointer's kind by its type alone |
| `s6` | 48.75 | 9.25 | 0.78 | 7.42 | 31.24 | the kind in the value's byte: no column of its own |
| `f1` | 48.79 | 9.29 | 0.79 | 7.42 | 31.28 | `s6` and a fixture line |
| `f2` | 48.69 | 9.33 | 0.85 | 7.43 | 30.98 | `f1` with one line's maker's expression written directly: section 6 |

- **`k2` is not taken.** Its tests read 48.33, but the window's kernel in place read 19.50 ticks a record where
  `main2` reads 15.6 to 15.8 in the other jobs (Lua 25.03 for 20.1 to 20.3, musl 22.30 for 18.7 to 19.0), the names'
  pass 24.78 a name for 22.6 to 23.3, and the front 54.19 for 52.5 to 53.0. `tests-k3-on-main.patch` is the same with
  the kernel's lines' bytes made once a line.
- **musl, by build** (all; `main2` beside it in the same turns): `p4` 115.55 (113.94), `p5` 118.68 (114.52), `s1`
  114.75 (113.79), `s2` 111.68 (114.18), `s3` 111.43 (112.98), `s5` 116.77 (115.49) and over fifteen readings 115.17
  (113.33), `s6` 113.48 (113.33), `f1` 110.52 (112.09), `f2` 108.71 (111.91). With every warning: `s1` 140.78
  (129.24), `s2` 128.67 (129.39), `s3` 135.50 (129.25), `s5` 132.91 (129.31) and over fifteen 133.97 (129.65), `s6`
  128.05 (129.65), `f1` 128.42 (132.01), `f2` 130.42 (131.06).

## 8. musl and the environment's size (`scripts/pads.sh`, `pads.py`; `results/9700x/*/pad*`)

One reading of each build at each of twelve sizes of an environment variable (0 to 192 bytes), which moves the stack:

| musl | sizes' median | least | most |
| --- | ---: | ---: | ---: |
| default warnings (`pad5`): `main2` | 112.50 | 107.95 | 121.24 |
| `s5` | 114.94 | 110.91 | 125.52 |
| every warning (`pad5-wall`): `main2` | 129.73 | 126.19 | 145.84 |
| `s5` | 132.69 | 130.73 | 141.43 |
| every warning, an hour before (`pad-wall`): `main2` | 135.52 | 127.61 | 145.08 |
| `s2` | 131.89 | 127.02 | 141.56 |
| `s3` | 133.69 | 128.58 | 138.45 |

- One executable's reading on musl moves by 8% to 16% with the environment's size alone, and the same executable's
  median over the sizes read 135.52 and 129.73 an hour apart.
- `sqlite3.c` (`pad5`): `main2` 54.13 to 56.11 (median 54.75), `s5` 48.83 to 50.55 (49.22): no size at which they
  cross. Lua: 69.39 to 77.24 (70.21) and 63.75 to 71.87 (64.41).
- So musl's figures in section 6 are medians of fifteen readings in turn, and a difference of 1% to 3% there is not
  read as one.

## 9. Faults (`faults/`)

Faults put into the new code one at a time, each in a copy of the tree: the Debug compiler built, and the node
machine's tests run (`test-checker --seed 133 --part 5/8`). A fault the tests don't fail is a survivor.

- `round1.py` (123 faults, on `s3`'s sources), `round2.py` (43: round 1's survivors against new fixture lines, its
  texts that didn't build written again, and the code that changed), `round3.py` (24, after the kind moved into the
  value's byte), and `final.py`: the 130 of them whose text is in `f1`'s sources, run again on those. One of the 130
  is a text of round 1's superseded in round 2 (`p-class-binary-any`, which no longer builds): 129 faults. `last.py`:
  three on the line `f2` changed, one of them among the 129. `p4.py` is an earlier campaign on the masks' form (61
  faults).
- **131 faults on the pull request's sources: 129 fail the tests.** The other two change no result a test can read:
  `l-right-near-left` (the second operand's kind read only where the first one's is near: a second operand of an
  operator the rule takes is the record before it) and `f-from-with-operand-s` (the store's slow rule's converted
  constant saying its operand's value: the window's kernel makes such a record by the fast path, and the slow rule
  makes one in the reads' census alone, which reads no value said).
- What the rounds changed: fixture lines for each survivor (pointer arithmetic, a pointer against 1, a shift by zero,
  zero first in an equality and in an ordering, a stored zero, a return of zero, of 300, into a float and into a
  pointer, 126 and 127, a floating operand, an enumeration under `-Wassign-enum` without the mix's warnings); and
  code a fault showed to do nothing, removed: an initialization's class (its root is no record of the window's), the
  six type bits beside the type's kind, a constant's kind beside its type's, the wide standing's test beside the
  value said, a unary class's test of a second operand, a pointer's constant kind.

## 10. The cloud container's checks (`results/cloud/final`)

The pull request's sources on main `aa09d1a04` (the work branch's `02e0412b3`; 4 CPUs, native host, Release;
`checks.sh`, `progress.txt`):

- `test-checker`, all eight parts: 842,777 checks, 0 failures (`test-checker-status.txt`).
- The shadow on `sqlite3.c`, Lua, musl and the compiler's own source in 12 modes: 48 runs, each status 0
  (`shadow/status.txt`). `shadow/` has the `--window-tests` runs' outputs: no expression differs; beside `--verify` no
  operator left out has a test (20,897, 7,027, 14,477 and 22,663 checked; with every warning 10,152, 5,718, 10,597
  and 10,989) and no value said is another than its payload (46,536, 16,700, 30,664 and 41,190 checked).
- The self-check, the self-parse, `test-call-graph` and `check-call-graph`: status 0.
- The complete driver's lists (`complete-light.log`, `complete-heavy.log`): one heading fails, as on main in this
  container, "Test the preprocessor on the repository's translation units against clang": the container's clang names
  its resource directory `/usr/lib/llvm-23/lib/clang/23`, and the 45 differences are that path.
- The sanitizer rows a pull request's checks don't run (`sanitizers.sh`, `sanitizers-progress.txt`): native memory,
  address and thread, a build each; `test-checker --part 5/8` (210,330 checks, 0 failures) in each; and for memory and
  address the shadow with `--window-tests --verify` and with `--window-tests --verify -Wall -Wextra` on `sqlite3.c`,
  Lua and the compiler's own source. Every run status 0, no report.
- `head/`: the pull request's head (buster14a/buster#2955, `305cc222b`), the same diff on main `56e93bf02`
  (`head-check.sh`): `test-checker --part 5/8` (210,330 checks, 0 failures) and 20 `--window-tests` runs, each status
  0.

## Files

- `patches/`: `tests-x1`, `-x2`, `-x5` (experiments, not for a pull request), `tests-q1`, `-q2` (the rule's first
  forms), each the whole diff of the sources against main `9a1422eab`. `quiet-rule-on-main-aa09d1a04.patch`: `q2`'s
  rule alone, against main `aa09d1a04`, which has the first half (buster14a/buster#2948, merged as `63f3918c1`).
  `tests-<label>-on-main.patch`: sections 6 and 7's builds, each the whole diff of `src` against main `aa09d1a04`.
- `results/9700x/x1`, `x2`: `skipN-<corpus>-K.txt`, a reading at `BUSTER_TESTS_SKIP=N`. `q1`, `q2`:
  `window-tests-<corpus>-K.txt`; `o/vs-q1-*`, `o/vs-q2-*`: the first half's build in the same turns.
- `results/9700x/<label>` for sections 6 and 7: `window-tests-<corpus>-K.txt` (default warnings), `window-tests-wall-*`
  (`-Wall -Wextra`), `window-tests-verify-*` (beside `--verify`), `window-<corpus>-K.txt` (`--front-window`, the
  window without the tests), `compile-N.txt` (`-c sqlite3.c` against `main2`), `pad*-<corpus>-pad<bytes>.txt`
  (section 8), `build.log`, `revision.txt`, `compiler.sha256` and the patch built. `main2/vs-<label>*`: main's build
  in the same turns. `job-<label>.log`: the job's steps.
- `results/cloud/`: `x3` (the shapes' histogram), `x5` (the predicate's counts), `q1`, `q2` (the rule under
  `--verify`), `final` (section 10).
- `scripts/`: `turns-env.sh` (one executable, a setting a turn), `pads.sh` and `pads.py` (section 8), `tables2.py`
  (a job's tables: `tables2.py results LABEL main2`). The other scripts are the first half's record's.
- `faults/`: section 9's lists and their results.
