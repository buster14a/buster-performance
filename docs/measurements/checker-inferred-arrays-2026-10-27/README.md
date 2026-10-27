# An inferred array's elements of operators' values: what the fix costs checking, 2026-10-27

Branch `claude/checker-inferred-arrays` (buster14a/buster) fixes the count of an array whose size its initializer gives
when an element is a binary operator's value (`S a[] = { *(p + 1), p[0] }`, `v16hi b[] = { ha + (short)n, -ha }`):
`check_init_root_type` (`c_check_initializer.c`) now walks binary operators and `-`, `+` and `~`, and a vector element's
test takes the walk's type first. The walk runs only for an inferred array's elements of struct, union or vector
type, so this measures the whole driver on the frozen `sqlite3.c`, three rounds of `perf stat -r 11`:

| Measure (`-fsyntax-only` of `sqlite3.c`) | base (main `51bf882b`) | head (`f92b7505`) | change |
| --- | --- | --- | --- |
| user instructions | 1,591,790,524 | 1,591,472,930 | -317,594 (-0.020%) |
| user cycles | 649.7 M | 652.1 M | +0.36% |
| task clock | 142.0 ms | 142.3 ms | +0.18% |

Every round's instructions are within 2 of its tree's others. The head's cycles are 0.1% to 0.5% above the base's in
each round (649.0, 650.1 and 649.7 million against 652.1, 652.1 and 650.3), though it runs fewer instructions.

On the 9700X the head's `test-checker` (`test_checker.log`) passes, 255,135 checks with 0 failures, among them the
branch's fixture "operators' values in an inferred array", against clang 23.1.1.

## Trees

| Name | Commit | What it is |
| --- | --- | --- |
| `base` | [`51bf882b`](https://github.com/buster14a/buster/tree/51bf882b) | main, the branch's base |
| `head` | [`f92b7505`](https://github.com/buster14a/buster/tree/f92b7505) | the branch: the fix and its fixture |

Each tree was `git archive` of its commit, sent by tar into an empty directory; `source-base.sha256` and
`source-head.sha256` hold the SHA-256 of each of its files, and `inputs.sha256` the executables', the inputs' and the
host's kernel and clang. Each was built with `BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh` (`build_base.log`,
`build_head.log`).

Host: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, CPU 2 at the performance governor. Each build and each run
took the shared lock on its own (`EXCLUSIVE_OWNER=claude-126`); the lock's waiting messages, which name other sessions'
runs, are removed from the logs.

## Method

`abI.sh` ran it (`abI.log` is its output). The inputs and options are those of
[#475's record](../char-signedness-475-2026-10-26/README.md): the preprocessor oracle's
frozen `sqlite/sqlite3.c` with the pinned gnu17 predefines, `--clang-features`, `-march=znver5 -std=gnu17 -nostdinc` and
the corpus's system directories, `SOURCE_DATE_EPOCH=1792454400`, `CPATH`/`C_INCLUDE_PATH` unset:

- the head's `test-checker`;
- each tree's `-fsyntax-only` once (status 0 on both: `drive_base.log` and `drive_head.log` are empty);
- three rounds, each tree in turn, of `perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2` of the
  whole driver (`perf.log`).

## Limits

One input, which has no vector arrays: the fix's vector path isn't timed here. A cycles difference this size with fewer
instructions is within what code placement moves between builds (`docs/profiling.md`, "Comparing two versions").
