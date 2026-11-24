# #2924 C12c-4 (b): the program, selection and the aliases keep their vector paths alone

PR [#3462](https://github.com/buster14a/buster/pull/3462). Base: the tests commit `a84f46f98` (the twins present).
Head: the deletion commit `bef8f7e0f`. The later commits change tests and comments only.

The gate was C12c's ([7014944772](https://github.com/buster14a/buster/issues/2924#issuecomment-7014944772)), user
cycles with the scalar arm forced on sqlite3.c, Lua and musl:

- the program: +0.9% to +1.8%;
- selection: +0.33% to +1.08%;
- the aliases: +0.09% to +0.63%.

The owner chose deletion for these (rule 3, 7112387760).

## The 9700X deletion run (`run.sh`, `logs/`)

Every compile ran under the lock on CPU 2; the deferred list ran on CPUs 2 to 9.

**Objects** (`logs/status.txt`):
- 1,373 objects compared, 0 differ, in each of `-Wall -Wextra`, the default, `--scalar` and `--tier1`. The lists are
  sqlite3.c, Lua's units, musl's units, buster's `main.c` and `--deferred-bodies` sqlite3.c.
- The `-g` mode's objects all differ, because each tree compiles in its own directory and the DWARF records it.
  Compiled in one directory, `-g` objects are byte-identical (`gsame/`).

**Stderr:** the same in every mode and list but one. `--scalar` Lua's head stderr has one more line, a process row
from the lock's report (`cc1`, another session's), not the compiler's.

**Timing:** `ab`, three rounds, around `time-runs` (three runs of three copies) of base, head and base again. User
cycles, median of 9:

| List | Head against base | Base again against base |
| --- | --- | --- |
| `-c` sqlite3.c | −0.16% | +0.37% |
| `-c` Lua's units | −0.03% | −0.01% |
| `-c` musl's units | +0.14% | +0.00% |
| `-c -g` sqlite3.c | −0.17% | −0.10% |
| `-c --lanes 4 --deferred-bodies` sqlite3.c | −0.20% | −0.79% |

The default path doesn't run the deleted code, and head reads at parity throughout.

**Placement:** `.text.buster_start`'s functions are the same in both executables (`logs/start-*.txt`).

## Local checks (`local/`)

Run in a 4-core AVX-512 container with CI's toolchain, Release:

- test-checker parts 1 to 8 on the tests commit, the deletion and the nits commit;
- the 39 blocks of `tools/ci/correctness.tests` that name the checker's runners. 35 passed; the 4 that need the 9700X's
  frozen corpus ran there;
- UBSan, ASan and MSan builds, each through test-checker's 8 parts: 24 of 24 passed.
