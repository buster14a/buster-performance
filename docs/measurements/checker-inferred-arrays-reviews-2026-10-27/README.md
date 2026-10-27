# An inferred array's elements after #555's reviews: what the walk costs checking, 2026-10-27

Branch `claude/checker-inferred-arrays` (buster14a/buster) counts the elements of an array whose size its initializer
gives from each element's type as the tree gives it (`check_init_root_type`, `c_check_initializer.c`). Its four review
rounds made the walk take both operands of a binary operator, casts' types (the reader's, at their `)`), a scalar for
constants, `sizeof`, `!`, `&&` and `||`, both arms of a `?:`, and a vector's lane, with 0 only for an expression the walk
has no type for. [The first record](../checker-inferred-arrays-2026-10-27/README.md) measured the first version
(`f92b7505`); this one the head after the reviews, the same way: the whole driver on the frozen `sqlite3.c`, three
rounds of `perf stat -r 11`:

| Measure (`-fsyntax-only` of `sqlite3.c`) | base (main `51bf882b`) | head (`2c083b8c`) | change |
| --- | --- | --- | --- |
| user instructions | 1,591,793,362 | 1,591,477,850 | -315,512 (-0.020%) |
| user cycles | 652.6 M | 651.7 M | -0.14% |
| task clock | 143.0 ms | 142.0 ms | -0.13% |

Every round's instructions are within 4 of its tree's others (`perf.log`); the head's cycles are below the base's in
each round (651.7, 651.2 and 652.5 million against 653.8, 652.1 and 652.6). The base's instructions are 2,838 more than
in the first record's rounds, the same executable in another hold of the lock.

On the 9700X the head's `test-checker` passes against clang 23.1.1, 255,177 checks with 0 failures
(`test_checker.log`), among them the branch's four fixtures: "operators' values in an inferred array", "casts and
operands of no type in an inferred array", "a conditional's arms in an inferred array" and "vector lanes in an
inferred array".

## Trees

| Name | Commit | What it is |
| --- | --- | --- |
| `base` | [`51bf882b`](https://github.com/buster14a/buster/tree/51bf882b) | main, the branch's base: the first record's build of it |
| `head` | [`2c083b8c`](https://github.com/buster14a/buster/tree/2c083b8c) | the branch after its four review rounds |

Each tree was `git archive` of its commit, sent by tar into an empty directory; `source-base.sha256` and
`source-head.sha256` hold the SHA-256 of each of its files, and `inputs.sha256` the executables', the inputs' and the
host's kernel and clang. The base's executable is the one the first record built (hard links of its directory); the
head was built with `BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh` (`build_head.log`).

Host: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, CPU 2 at the performance governor. Each build and each run
took the shared lock on its own (`EXCLUSIVE_OWNER=claude-126`); the lock's waiting messages, which name other sessions'
runs, are removed from the logs, which leaves those of runs that printed nothing (`drive_*.log`) empty.

## Method

`abI.sh` ran it (`abI.log` is its output). Its first two runs stopped at the head's build, whose `mktemp` found the
host's `/tmp` out of inodes (`abI_failed.log`, `abI_failed2.log`); the third, which this records, sets `TMPDIR` to a
directory of its own. The inputs and options are those of
[#475's record](../char-signedness-475-2026-10-26/README.md): the preprocessor oracle's frozen `sqlite/sqlite3.c` with
the pinned gnu17 predefines, `--clang-features`, `-march=znver5 -std=gnu17 -nostdinc` and the corpus's system
directories, `SOURCE_DATE_EPOCH=1792454400`, `CPATH`/`C_INCLUDE_PATH` unset:

- the head's `test-checker`;
- each tree's `-fsyntax-only` once (status 0 on both);
- three rounds, each tree in turn, of `perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2` of the
  whole driver (`perf.log`).

## Limits

One input, with few inferred arrays of records and none of vectors: the walk's vector cases aren't timed here.
