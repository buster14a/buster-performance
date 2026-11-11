# Type sugar table (buster#2326), 2026-11-11

The base-vs-head A/B that buster's package C4b requires for each PR that touches the type table. All runs were on the
Ryzen 7 9700X (benchpress), each `time-runs` process under its lock and pinned to CPU 2.

- **base:** buster `2d0756cf` (main).
- **head:** branch `c4b/type-sugar` at each commit below.
- **inputs:** `sqlite3.c` from `~/buster-fast-bench/frontend-baseline-claude/baseline/`, and buster's own `main.c` at
  base, with `-march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing`.
- **lists:** `-fsyntax-only` and `-c` of each.
- **build:** `build.sh` builds both Release trees, each under the lock.

## The runs

1. **`ab1.log`** (`ab.sh`), head `bc28c34e`, 3 rounds × 5 runs × 3 copies, with base-again as the floor.
   - sqlite3.c is neutral.
   - main.c is +0.45 to +0.79% in user cycles, with instructions within +0.02%.
2. **`shifts.log`** (`shifts.sh`): six placements of the checker's unit per build (0, 704, 1408, 2112, 2752, 3456 bytes).
   - main.c stays +0.28 to +0.56% at every placement, so this is not code placement.
3. **`ab2.log`** (`ab2.sh`), head `9215ba4d`, the sugar fields moved to the end of `CheckInput` and the builders cold.
   - main.c is still +0.4 to +0.7%.
   - Cause: main.c declares calling-convention functions, so the reader allocated and zeroed a per-token
     `declared_sugar` column.
4. **`ab3.log`**, head `ae0a8d7c`, the column replaced by a sparse map of the few declarations with sugar. Every list
   is within the base-again floor:

   | list | head round 1 | head round 2 | head round 3 | base-again (rounds 1–3) |
   |---|---|---|---|---|
   | sqlite3.c `-fsyntax-only` | −0.19% | +0.11% | −0.14% | −0.06%, +0.32%, +0.13% |
   | sqlite3.c `-c` | +0.28% | +0.24% | −0.21% | +0.11%, +0.46%, −0.03% |
   | main.c `-fsyntax-only` | +0.57% | +0.02% | +0.30% | +0.12%, −0.14%, +0.47% |
   | main.c `-c` | +0.26% | +0.09% | −0.01% | +0.05%, +0.01%, +0.32% |
