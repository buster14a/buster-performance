# #3450 / #2924 phase D: Tier 1's parallel moves

The record of buster14a/buster's `claude/2924-tier1-moves` PR. Session: `session_01EgbxndFreFrJqAywiEGoue`.

`tier1_resolve_moves` took two routes:
- `tier1_resolve_moves_scalar`, a cubic scan, for up to 8 moves;
- `tier1_resolve_moves_indexed` beyond: a merge sort, scalar binary searches and a heap (only its validation was
  AVX-512).

The PR replaces both with two vector forms, each the only code for its range:
- **the register form,** up to 32 moves;
- **the wide form,** beyond.

The order and the objects stay the same. The coordinator's reading of the owner's rule (2026-11-23) allows a size
switch between two vector forms when each is the only code for its range.

## Census

`dump.diff` (on main 4e791faa, experiment only) appends every call's set to a file. It was run over `--tier1 -c
--lanes 1` of sqlite3.c, Lua 5.4.8 and musl, the same command lines as the tier1-frame record's `objects.sh`.

**Counts:** 41,188 sets, with at most 12 moves:

| moves | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 12 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| sets | 1,374 | 14,013 | 11,796 | 7,434 | 2,810 | 2,554 | 982 | 178 | 27 | 17 | 2 | 1 |

596 sets needed the scratch to break a cycle. The register form therefore takes every real set. The wide form is
reached only by the tests, which go up to 2^20 moves.

## Gate

The gate harness is `side.c`, `gate.c` and `run.sh`. One executable links two translation units:
- **old:** main's `tier1_allocate.c`;
- **new:** the branch's.

It times each call with rdtsc. Every pass runs both sides, alternating which goes first, and the harness reports the
median of 21 passes. It has two modes:
- **replay:** every dumped real set, grouped by count;
- **synth:** 256 distinct random sets per count (8 or 2 past 1,024), mixing fan-out, cycles and outside sources.

It checks that both sides give identical output for every set (`mismatches`).

The runs were on the 9700X under `exclusive.sh`, on CPU 2, built with the toolchain's clang 23.1.4 at `-march=znver5`.

| run | register form up to | real sets, all | worst count (new/old) | best |
| --- | ---: | ---: | --- | ---: |
| `run-1.log` | 16 | 0.535 | 17 moves: 0.963 | 0.204 |
| `run-2.log` | 16 | 0.543 | 17 moves: 0.976 | 0.214 |
| `run-3.log` | 32 (the PR) | 0.576 | 0 moves: 0.888 | 0.120 |

- **The first version** kept 16 moves in one register. It already won at every count, but at 17 moves, where the
  wide form starts, by only 2 to 4%. The register form was widened to 32 moves (two registers) so the boundary
  holds a margin.
- **With 32,** `run-3.log` reads 0.12 to 0.89 at every count from 0 to 2^20. The real sets read 0.28 to 0.89 by
  count. The register form's two halves cost a little at the smallest counts (8 moves: 0.40 against 0.33 with 16
  lanes) but remain clear wins. Mismatches are 0 everywhere.
- **Objects:** all 1,371 objects of sqlite3.c, Lua and musl under `--tier1` are byte-identical between main and the
  branch.

## Tests and mutation

The tests commit replaces the comparisons with the old routes by `tier1_move_test_definition`, the policy as a plain
cubic scan. Every resolved order in the tests must be exactly its order.

`mutation/` holds the harness (`harness.c`: `lane.c`, `tier1_allocate.c` and the move tests), `mutants.py`, `run.sh`
and four rounds:
- **`round1.txt`** (16 lanes): two real gaps:
  - a duplicate destination in the wide form's last sorted pair;
  - (later shown equivalent) the register's 16th lane.

  It also found two pieces of dead code, removed: a `& pending` on the reader rows and the reset of `preserved`.
- **`round2.txt`:** after the duplicate test.
- **`round3.txt`** (32 lanes): moving the random sets of up to 32 moves to the register form left the wide form's
  identity moves untested. Random sets of 33 to 64 moves now cover them.
- **`round4.txt`:** only three equivalent mutants survive, each because of an invariant:
  - the threshold (32 against 31): both forms give one order;
  - the lower bound's `<` against `<=`: destinations are unique;
  - the cycle cursor's step: a shorter step only rescans.
