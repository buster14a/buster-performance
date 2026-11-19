# An lvalue's truth is its value's (buster#3028), 2026-11-19

The evidence for [buster14a/buster#3028](https://github.com/buster14a/buster/issues/3028)'s fix: a condition on an
lvalue at an absolute address (`if (*(int*)4096)`) was compiled as true and its load dropped. The checker's truth rule
(`check_action_truth`) read such an lvalue's truth from its address.

## 1. The 9700X, on main `b84780116` (`9700x/`)

`job-fix3028b.sh b84780116`: two Release builds, main's and the fix's (`fix-3028b.patch`, the fix's sources and
tests), each run its own hold of the lock.

- **The twenty forms** (`abs3.c`, a truth test of an lvalue at an absolute address in each), compiled with `-c` by
  both: `abs3-base.s` and `abs3-head.s`. Main's code reads the lvalue in 8 of the 20 (none in `f01`, `f02`, `f03`,
  `f05`, `f06`, `f07`, `f14` to `f19`); the fix's in all 20.
- **The three corpora, a unit at a time, by both** (`objects.txt`, a line a unit: the verdict, the two exit statuses,
  the unit): `sqlite3.c`, Lua's 34 units and musl's 1,336 are the same bytes with and without the fix (1,371 lines,
  each `same`).
- **`test-checker`'s eight parts** in the fix's tree (`status.txt`): no failure.

`first-base/` has the first run of the same, on main `6427879e1` before buster#3030 merged: the fix's eight parts
and its twenty forms.

## 2. The cloud container, on the fix's commit (`cloud/`)

`checks-progress.txt`: a native Release build; `test-checker`'s eight parts (`test-checker/`); C on the window on the
three corpora and the compiler's own source with the default warnings and with `-Wall -Wextra` (`shadow/`, each run's
count lines: the counts of buster#3030, no difference); the shadow's eleven other modes on `sqlite3.c` and Lua; the
self-check, the self-parse and the call graph; the build's ownership check; and the complete driver's lists
(`complete-light-items.txt`: one item fails in this container, as on main: its clang spells its include directory
another way).

`sanitizers-progress.txt`: the rows a pull request's checks skip (memory, address and thread, native): the fix's part
of `test-checker` (4 of 8) and the node machine's (5 of 8) under each, and under memory and address C on the window on
`sqlite3.c`, Lua and the compiler's own source.
