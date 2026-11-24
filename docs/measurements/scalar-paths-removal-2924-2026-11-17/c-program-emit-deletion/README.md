# #2924 C12c-4 (c): the emission's scans, the static data, the lazy planner and the unwind tables keep their vector paths alone

PR [#3465](https://github.com/buster14a/buster/pull/3465). Base: the tests commit `272844c6c` (the twins present).
Head: the deletion commit `3e44732ad`. The later commits change only tests, comments and docs.

The gate was C12c's (7014944772) at parity: the program's emission, the static data and the lazy planner, and the
unwind tables under `--tier1` (7020214238). The owner chose deletion at parity (rule 3).

## The 9700X deletion run (`run.sh`, `logs/`)

**Objects:** 1,373 of 1,373 byte-identical in `-Wall -Wextra`, `--scalar`, `--tier1` and `-flazy-system-headers
-Wall -Wextra`, over sqlite3.c, Lua, musl, buster's `main.c` and `--deferred-bodies` sqlite3.c.

**Stderr:** the same, but for the lock's report of other processes (a `git` row in base's Lua and musl lists).

**User cycles,** head against base (base again for scale):

| List | Head | Base again |
| --- | --- | --- |
| sqlite3.c | +0.03% | +0.59% |
| Lua | +0.14% | +0.21% |
| musl | +0.03% | +0.07% |

**Placement:** `.text.buster_start` holds the same functions in both.

## Local checks (`local/`)

- the 41 blocks of `tools/ci/correctness.tests` that name the checker's runners, test-unwind, test-emitted-code,
  test-streaming, test-tier0, test-debug and test-executable. 38 passed; the other 3 failed for the container
  (clang 23.1.6 rather than 23.1.4, no perf, no 9700X corpus);
- UBSan, ASan and MSan through test-checker's 8 parts, test-unwind and test-emitted-code: 30 of 30 passed.
