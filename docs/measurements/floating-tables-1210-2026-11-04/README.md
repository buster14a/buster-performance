# Compact float and double literal tables (#658)

Evidence for [buster14a/buster#1210](https://github.com/buster14a/buster/pull/1210), part of
[#658](https://github.com/buster14a/buster/issues/658): file-scope `float` and `double` tables of literals published as
one bytes part, with whole-table fallback to the ordinary path.

## Sources

| tree | revision | executable's SHA-256 |
| --- | --- | --- |
| `main` | `c79fd0076fc8ee3ba0a43d02f94dca417a7557ea` (the main merged into the PR) | `984ee8de5365e49ef0b72fef2e6c100f6fa5286a5a02ee26834abedd6ad339b4` |
| `head` | `e20248976702bf4c3242a4dbd7f3abaeb278a97c` (the PR's head) | `0229f9dbcf2b7692648fffbf211f38ca42db3f8292cb27f49de02ca1ec202125` |

`main-again` is `main`'s executable timed again, the floor. Each tree was a `git worktree` built on the 9700X with
`BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh`, each build under the machine's lock.

The inputs are 200,000-element tables that `scripts/gen.c` writes (values of a 32-bit LCG scaled to [−0.5, 0.5), eight
to a line); `scripts/run.sh` has the commands:

| input | what | SHA-256 |
| --- | --- | --- |
| `float_f_200000.c` | `float`, each value with an `f` suffix (`%.9gf`) | `90f8ab21c19a36db702e17d2ff5cb8917f770ed6dc38a29cedf4b0eceb757f67` |
| `float_x_200000.c` | `float`, double literals of a third of each value (`%.17g`), which round to float | `f0083f289aa9ec124489409a33630b51e8e6c3267c6d0d137054b39086fbebb8` |
| `double_x_200000.c` | `double`, the same literals | `52d3cd54dcd9136396521f61aa83b77ee8d602bb8dfeb626a48dcc95364fff00` |
| `float_fallback_200000.c` | `float_x_200000.c` with a last element `16777217`, which float can't hold, so the whole table falls back | `22394d5d609ff605518c88748e686e16a4e7cebc6e68239d5f64bdecb2d29ebb` |
| `scripts/gen.c` | the generator | `737b9323bc5123a45a3b036333989802fe3e8a2a64f7204b24b5b57511538c01` |

## Host

AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, transparent huge pages `always`, defrag `madvise`. Timed
processes pinned to CPU 2 (`taskset -c 2`); the `time-runs` process ran under the shared 9700X lock.

## Runs

`raw/ab-1210-large.txt`: one `time-runs --runs 15 --warmups 2 --copies 3` process with `main`, `head` and `main-again`,
five lists. The log keeps only what `time-runs` prints; the lock's waiting notice, which names another job, was dropped.

## Results

Wall time, the median of each build's 45 runs, the range over its copies, and the peak resident set (copy 1):

| input | `main` | `head` | `head` against `main` | `main-again` (floor) | peak KiB `main` → `head` |
| --- | ---: | ---: | --- | --- | --- |
| `float_f` `-fsyntax-only` | 92.272 ms | 32.069 ms | −65.25% (−65.34% to −65.12%) | −0.11% | 275,672 → 114,980 |
| `float_x` `-fsyntax-only` | 96.010 ms | 44.093 ms | −54.08% (−54.16% to −54.00%) | −0.28% | 277,160 → 116,564 |
| `double_x` `-fsyntax-only` | 95.981 ms | 36.158 ms | −62.33% (−62.36% to −62.20%) | −0.16% | 277,208 → 116,456 |
| `float_fallback` `-fsyntax-only` | 96.234 ms | 122.999 ms | **+27.81%** (+27.61% to +28.08%) | −0.26% | 277,160 → 279,240 |
| `float_x` `-c` | 104.172 ms | 44.565 ms | −57.22% (−57.49% to −56.58%) | +0.32% | 281,788 → 116,804 |

User instructions per process (copy 1): `float_f` 1,890 M → 588 M, `float_x` 1,946 M → 796 M, `double_x` 1,947 M →
644 M, `float_fallback` 1,946 M → 2,517 M.

## The fallback's cost

A table that the compact path refuses at its last element converts every element before it, then discards them, and
the ordinary path does it all again: 571 M more instructions (2,855 for each of the 199,999 elements converted in
vain), 27 ms more wall time. The other refusals that the grammar's scan doesn't catch first (a literal's range warning,
an imaginary or bit-precise constant, a malformed spelling) cost the same when they come late. Refusals by shape
(designators, expressions, nested braces) are caught before any conversion.

## Limits

- One session's run of one `time-runs` process; the floor's spread is the comparison's noise.
- Only 200,000-element tables were timed. Small tables (128 to 4,096 elements) were generated but not timed.
- `sqlite3.c` has no such tables; the PR's CI A/B on it (Benchpress, run 41845398921) was neutral.
