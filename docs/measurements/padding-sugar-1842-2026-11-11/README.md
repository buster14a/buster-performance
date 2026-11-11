# clear_padding's sugared arrays (buster#1842's 1b), 2026-11-11

The base-vs-head A/B that buster's package C4b requires for each PR that touches the type table's sugar.
All runs were on the Ryzen 7 9700X (benchpress), each `time-runs` process under its lock, pinned to CPU 2.

- **base:** buster `a8855682` (main).
- **head:** branch `c4b/1842-padding-sugar` at `048e880d`. The reader makes a group's PAREN sugar over an array only in a
  unit that names `__builtin_clear_padding`, which one intern lookup a unit decides. Neither input names it.
- **inputs:** `sqlite3.c` from `~/buster-fast-bench/frontend-baseline-claude/baseline/`, and buster's own `main.c` at
  base, with `-march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing`.
- **lists:** `-fsyntax-only` and `-c` of each.
- **runs:** `build.sh` builds both Release trees, each under the lock. `ab.sh` runs 3 copies × 5 runs, with base-again
  as the floor. Its log is `ab.log`.

## Result: neutral

Medians of user cycles against base:

| list | head | base-again (floor) |
|---|---|---|
| sqlite3.c `-fsyntax-only` | −0.10% | −0.07% |
| sqlite3.c `-c` | −0.81% | −0.47% |
| main.c `-fsyntax-only` | −0.19% | −0.12% |
| main.c `-c` | −0.01% | +0.04% |

Head retires about 0.01% fewer instructions on both inputs.
