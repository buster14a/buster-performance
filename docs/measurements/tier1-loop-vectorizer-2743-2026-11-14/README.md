# Tier 1's loop vectorizer on the array loops (buster#2743, 2026-11-14)

The 9700X measurement of [buster#2743](https://github.com/buster14a/buster/issues/2743)'s first loop vectorizer
(`ir_vectorize_loops.c`, `--tier1 --tier1-passes=+vectorize`), on the kernels and harness of
[the issue's earlier record](../tier1-array-loops-2743-2026-11-14/README.md). By Claude in David's directed session
(<https://claude.ai/code/session_01NNmNQvUK6RYgVXj7fzdW7P>, model claude-opus-5-5), from the claim in
[comment 6885294923](https://github.com/buster14a/buster/issues/2743#issuecomment-6885294923).

**Status:** in progress. The scripts and sources are here; the 9700X run is queued on the shared lock, and its results,
tables and summary replace this paragraph when it ends.

## What is measured

- `src/`: the earlier record's 25 kernels (`kernels.c`), its 12 explicit-vector kernels (`kernels_hand.c`) and its
  harness (`harness.c`, always clang -O2), unchanged.
- `scripts/measure.sh` (started detached by `systemd-run --user` in `~/buster-fast-bench/2743-claude/loops`): Release
  builds of the branch (`tree`) and of main (`main`), then for x86-64 and znver5 every build of
  `scripts/build-9700x.sh` (one lock hold) and each timed build at placements 0, 16, 32 and 48 (one hold each,
  `scripts/run-one.sh`, CPU 2), the explicit-vector builds at znver5, then `scripts/compile-cost.sh`'s A/B of
  `--tier1 -c sqlite3.c` without and with the option (11 alternating runs each, one hold per target).
- The builds: `buster-tier1` (the branch without the option), `buster-tier1-vec` (with it), `buster-tier1-vec-scalar`
  (with it, by the scalar path), `main-tier1` and `main-tier0` (main's compiler, for object identity), `buster-tier0`,
  and clang -O2 with and without its vectorizer and unroller.
- `scripts/vectorized.py BEFORE.o AFTER.o` names the kernels whose code the option changed; `scripts/tables.py` makes
  the tables from `run-one.sh`'s lines.
