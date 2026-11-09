# Folded array bounds and misplaced-VLA errors, error-free units, base vs head on the 9700X (#1447, PR #1851)

This is the raw evidence for [buster14a/buster#1851](https://github.com/buster14a/buster/pull/1851), "Checker: clang's
folding of array bounds that are no ICE, and its errors for misplaced VLAs"
([#1447](https://github.com/buster14a/buster/issues/1447)).

The head adds three things to error-free compiles:
- a storage-class store for each declaration;
- a variably-modified flag test for each record member;
- in the driver, a split of the folded-constant warning bit, but only on nodes that warn.

This checks that error-free `-fsyntax-only` doesn't pay for them.

## Identity

- **Date and runner:** 2026-11-09, by an agent session (Claude Code), in one hold of `~/buster-fast-bench/exclusive.sh`.
- **Base:** buster main `cb608c1f616f8fe26234bcaaa869caccc571de63`.
- **Head:** `6d71c1a1f662be53945765ddc30b61de6bfc9d7d`, branch `claude/gnu-folding-vla`: main `cb608c1f` merged in, plus the
  PR's commits up to `c8ec004`. The PR's later commit, `06dd570`, changes only the error path.
- **Host:** `benchpress`, AMD Ryzen 7 9700X.
- **Builds:** `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh` in each tree.
- **Inputs:**
  - SQLite's `sqlite3.c`, `~/buster-fast-bench/refine-claude/inputs/sqlite3.c`, with no options;
  - the head tree's `src/buster/compiler/main.c`, with `-march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing`.

## Commands

`run.sh` here takes 7 rounds, interleaved base then head. Each run is
`taskset -c 2 perf stat -x, -e instructions:u,cycles:u,task-clock`. The whole script ran under one lock hold of about
40 s.

An earlier attempt was killed: `ab --rounds 11` holding the lock once per run, which reached 7 of 44 runs in 1 h 46 min.
The coordinating session asked for one short hold. `perf.txt` holds the raw output, including the lock's waiting lines.

## Results

Medians of 7 runs:

| input | base instructions:u | head instructions:u | change | base task-clock (ms) | head task-clock (ms) |
|---|---|---|---|---|---|
| `sqlite3.c` | 975,508,554 | 975,275,544 | −0.024% | 93.66 (93.45–94.42) | 94.02 (93.60–94.19) |
| `main.c` | 26,621,255,405 | 26,619,860,927 | −0.005% | 2034.11 (2025.04–2044.27) | 2034.55 (2030.73–2050.07) |

- The instruction counts are exact to about 30 for `sqlite3.c` and about 70K for `main.c` from run to run. The head
  runs fewer instructions on both inputs.
- The task-clock medians are within each side's range. Cycles:u medians:
  - `sqlite3.c`: base 442.0M, head 442.0M;
  - `main.c`: base 10.366G, head 10.366G.

The 9700X CI job for the PR's head `06dd570` measured `-c sqlite3.c` too, against the same base, over 4 placements ×
2 copies × 5 runs:
- wall time −0.18% (placements −0.92% to +0.06%);
- user cycles −0.29%;
- instructions 1,259,095,690 → 1,258,860,540.
