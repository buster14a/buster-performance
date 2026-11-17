# The tests on the window, second half: what is left, and a first rule (buster#2850, step 2): 2026-11-17

Groundwork for the second half of [the piece's specification](https://github.com/buster14a/buster/issues/2850#issuecomment-6951406678),
after [the first half](../window-tests-2850-2026-11-17/README.md) (buster14a/buster#2948). No pull request yet:
experiment builds and one work in progress, each a patch here against main `9a1422eab` on top of nothing else (they
hold the first half's sources).

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

## Files

- `patches/`: `tests-x1`, `-x2`, `-x5` (experiments, not for a pull request), `tests-q1`, `-q2` (the rule), each the
  whole diff of the sources against main `9a1422eab`. `quiet-rule-on-main-aa09d1a04.patch`: `q2`'s rule alone,
  against main `aa09d1a04`, which has the first half (buster14a/buster#2948, merged as `63f3918c1`).
- `results/9700x/x1`, `x2`: `skipN-<corpus>-K.txt`, a reading at `BUSTER_TESTS_SKIP=N`. `q1`, `q2`:
  `window-tests-<corpus>-K.txt`; `o/vs-q1-*`, `o/vs-q2-*`: the first half's build in the same turns.
- `results/cloud/`: `x3` (the shapes' histogram), `x5` (the predicate's counts), `q1`, `q2` (the rule under
  `--verify`).
