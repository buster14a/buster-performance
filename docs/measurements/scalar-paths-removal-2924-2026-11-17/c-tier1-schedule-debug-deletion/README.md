# Tier 1's schedule and debug metadata: the twins deleted (#2924, C7, first slice)

PR buster14a/buster#2964. Base main `67ec04a2c`, head `3e9d2a7bf` (the deletion; later commits add tests only). The
gate is in [`../c-tier1-gate/`](../c-tier1-gate/).

## The 9700X, main against head ([`run.sh`](run.sh), [`logs/`](logs/))

Release, every run under the lock, timings on CPU 2.

- **Tests by head:** `test-tier1-schedule` 11,404 checks and `test-check-debug --cross-check` 3,995 checks, no
  failures.
- **`benchmark-tier1-schedule`, three processes each:**
  - head's one row (schedule + copy + encode): 141.9, 143.9 and 144.1 ns a record;
  - main's vector row: 146.9 to 148.1;
  - main's scalar row: 189.6 to 191.6;
  - encoding alone: 0.56 to 0.62 on both.
- **Objects**, every compile in one directory:
  - `--tier1 --tier1-schedule=post -c` of sqlite3.c, Lua and musl: 1,371 of 1,371 identical;
  - `--tier1 -g -c` of Lua and musl: 1,362 of 1,362 identical.

  Under `-g`, both main and head refuse the same 9 units with the code certificate's error 272: Lua's `lstrlib.c` and
  musl's `qsort.c`, `regexec.c`, `getaddrinfo.c`, `getnameinfo.c`, `crypt_sha256.c`, `crypt_sha512.c` and
  `pthread_barrier_wait.c` (#2870, which #2913 fixes, and #2963).
- **Whole compiles** ([`logs/time.log`](logs/time.log)): `ab`, three rounds, around `time-runs` (3 runs, 3 copies)
  of base, head and base again. User cycles against base, round by round:

  | Compile | Head | Base again | User instructions, head against base |
  | --- | --- | --- | --- |
  | Lua's units, `--tier1 -g` | −0.01%, −0.02%, +0.21% | −0.02%, −0.12%, +0.09% | −1.25 M (−0.03%) |
  | sqlite3.c, `--tier1 --tier1-schedule=post` | +0.06%, +0.18%, +0.27% | +0.01%, −0.03%, +0.13% | −0.37 M |

  Head retires fewer instructions in both. The sqlite3.c compile reads 0.05% to 0.15% above base-again in each round,
  which is inside the 9700X's same-executable wobble (up to 0.4% between copies). Both compiles are measurement
  options; a plain `-c` runs neither path.

## Locally (AVX-512 Xeon)

- All 220 of c-testsuite's single-exec programs give byte-identical objects from main's build and head's, under
  `--tier1 -g` and under `--tier1 --tier1-schedule=post`.
- The complete driver's parse and its `-Wall -Werror` self-check of `main.c` pass.

## Mutants ([`mutation/`](mutation/))

[`mutants.py`](mutation/mutants.py) breaks the vector code that stays, and [`run.py`](mutation/run.py) runs each
mutant on an archived tree.

**Round `pr`: the tests commit's tree** (twins still in the source, tests free of them):
- **Killed:** every schedule mutant that built (s2, s3, s5 to s10) and the debug metadata's g1, g4 and g7.
- **Survived:** g2, g3, g5 and g6. The tests had no case for them, so the PR adds three:
  - a floating parameter's diamond, whose meet sits in the xmm carriers;
  - the backedge kill in `r12`, a carrier past the first eight;
  - `check_tier1_debug_sources` against its definition, across 16-lane batches.
- **Never built:** s1, s4 and g8, which left a variable unused. s1b, s4b and g8b keep it used.

Round `pr2`, on the final tree with the new cases, follows.
