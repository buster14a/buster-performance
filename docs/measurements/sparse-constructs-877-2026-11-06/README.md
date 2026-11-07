# Token-wide work for sparse constructs on the 9700X (#877), 2026-11-06

Evidence for buster14a/buster#877's "Done when": `-c` of the frozen `sqlite3.c` on the 9700X, with the `check-input`,
`check-program` and `lower` stages compared by `measure-compile` and by `time-runs` over code placements (#509). Two
pull requests implemented the issue's remaining items, and each is measured against its own base, the merge's first
parent:

- [#1025](https://github.com/buster14a/buster/pull/1025): items 1, 3 and 5, and the asm labels' side of the attributes
  comment. Base `ebee03e2`, merge `2ffcd901`.
- [#1067](https://github.com/buster14a/buster/pull/1067): bitsets for `plan_first`, `initializers` and the lowering's
  `local_map`. Base `d3086da6`, merge `59a48a56`.

Everything was measured on the locked 9700X (`benchpress`), in `~/buster-fast-bench/877-claude/`.

## Result

| | #1025 | #1067 |
| --- | --- | --- |
| wall, `time-runs` (5 rounds) | −3.03%, −3.17%, −3.07%, −3.11%, −3.06% | +0.12%, +0.17%, −0.01%, +0.09%, −0.01% |
| base against itself | −0.03%, +0.05%, −0.01%, −0.10%, +0.08% | +0.00%, +0.14%, −0.13%, −0.04%, −0.08% |
| user cycles, `time-runs` | −3.54%, −3.77%, −3.54%, −3.65%, −3.68% | +0.16%, +0.25%, −0.01%, +0.21%, −0.02% |
| base against itself | +0.05%, +0.06%, +0.13%, +0.01%, +0.04% | +0.03%, +0.18%, −0.08%, +0.02%, −0.03% |
| instructions per process | 1,411.56 M → 1,384.74 M (−26.8 M, −1.90%) | 1,404.82 M → 1,407.78 M (+2.96 M, +0.21%) |
| `check-input` | 58.969 → 57.061 ms (−3.23%) | 55.911 → 55.761 ms (−0.27%) |
| `check-program` | 13.784 → 11.846 ms (−14.06%) | 10.163 → 10.089 ms (−0.73%) |
| `lower` | 14.283 → 14.186 ms (−0.68%) | 13.453 → 13.614 ms (+1.20%) |
| the stages' span | 133.875 → 129.990 ms (−2.90%) | 126.130 → 126.127 ms (−0.00%) |

- **#1025** is a clear gain. Every `time-runs` round's range over placements excludes zero: over the five rounds they
  span −3.97% to −2.41% for wall time and −4.47% to −2.62% for user cycles. The base against itself is within ±0.13%.
  - At each of the eight offsets, the merge's `check-input`, `check-program` and span are below the base's at every
    offset: below in all 64 pairs of offset medians.
  - `lower` is below in 52 of the 64 pairs, but its range over the offsets crosses zero (−2.79% to +1.24%).
- **#1067**, as a whole process, is about as far from the base as the base is from itself (within ±0.25%, against
  ±0.18%).
  - **`check-program`** is down 0.07 ms, below in 62 of 64 pairs. Those are `plan_first`'s and `initializers`'
    bitsets.
  - **`lower`** is up 0.16 ms. The merge's offset medians are above the base's in 53 of 64 pairs (a Mann–Whitney U of
    53: p ≈ 0.04, two-sided, at eight and eight) and in all three rounds (+1.13%, +1.55%, +1.09%).
  - **Instructions.** The merge retires 2.96 M more instructions. The scalar build's callgrind count was 6.1 M fewer
    ([#1067](https://github.com/buster14a/buster/pull/1067)). On the 9700X, glibc's `memset` of a large block is a
    `rep stosb`, a handful of instructions however large, so the removed fills hardly show in the instruction count,
    while every read of `local_map` gained a bitset test (`check_lower_local_of`).

  So #1067's `local_map` bitset costs the lowering more than the 2.9 MB fill it replaced. The second campaign below
  measures two ways out on current main.
- **Objects.** Each pair's 16 builds wrote the same `sqlite3.o`, byte for byte (`results/objects.txt`). It is in fact
  the same object for all four trees.

## Source revisions and builds

- The trees are worktrees of one clone at `ebee03e2`, `2ffcd901`, `d3086da6` and `59a48a56` (full hashes in
  `logs/commits.txt`).
- **The checker's placement.** These trees predate `BUSTER_CHECKER_OFFSET` (#1233, buster `750f6d0b`), whose
  `main.c` hunk (`scripts/checker-offset.patch`) was applied to all four. At offset 0 it emits nothing: each tree's
  offset-0 build is its unpatched build byte for byte (`logs/receipts.txt`).
- **The offsets.** Each tree was built at #1233's eight offsets of the checker's code: 0, 16, 32, 48, 1040, 2080, 3120
  and 4032. `check_input_run` and `check_program` move by exactly the offset (`logs/placements.txt`).
- **The build.** As the 9700X job's benchmarks build: `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh
  --config Release`, clang 23.1.1, the wild linker (`logs/build-*.log`).
- **The driver** that runs `time-runs` is main `ec5f0f6b`'s build. It times the other executables and nothing of its
  own.
- **The builds' holds.** Each build took the lock alone (`scripts/build.sh`) until about 11-minute waits under
  contention made that slow. The other 24 were built three at a time, one tree each, per hold (`scripts/build2.sh`),
  on every online CPU, which changes no output.

## Method

The input is the frozen `sqlite3.c` (SHA-256 `0a409f16…`, checked by each hold) with the `compile_time` step's
options: `-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`. Every
process ran on CPU 2, under the performance governor (`logs/host.txt`). `scripts/run2.sh` ran eight holds, each its
own hold of the lock (`scripts/hold.sh`):

- **Stages, three holds.** Each ran `measure-compile --runs 11` on all 32 executables (both pairs, eight offsets each),
  the offsets in turn and the four trees within each. Each round starts a third further along. `measure-compile`
  runs 11 compiles with `--time-stages` and 11 without, after a warm-up of each, and reports each stage's median.
  `results/stages-*.txt` are those holds' outputs.
- **Objects.** The first stage hold first wrote every executable's object and compared it with its pair's base's at
  offset 0.
- **Whole processes, five holds.** Each ran `time-runs --runs 3 --copies 3` for each pair, the pairs' order
  alternating by round, with three builds over the eight offsets:
  - the base;
  - the merge;
  - the base again, the comparison's floor.

  Each executable ran from three fresh copies on tmpfs, so each round made 72 processes of each build.
  `results/time-*.txt` have every process's wall time, user cycles and instructions, and `time-runs`' comparisons.

`results/analysis.txt` (`scripts/analyze.sh`, which uses `scripts/summarize.sh`) has:

- each pair's stage medians over the offsets and rounds, with the range over the offsets and the rounds' changes;
- each offset's medians and the count of offset pairs;
- `time-runs`' comparisons;
- the instructions per process.

The ranges over offsets pair nothing, since an offset of one tree is not that offset of another.

## What went wrong, and is discarded

My launches of the detached runners went through an ssh wrapper that retried when its session hung (the tailnet
dropped often). So `chain.sh`, the first runner, was started four times, and `build2.sh` twice.

- **The builds are unaffected.** Each of `build2.sh`'s holds builds the next pending build of each tree, and the lock
  serialised the two copies. Each of the 37 builds ran once: 37 statuses in `logs/receipts.txt`, all 0. Their final
  checks and `logs/placements.txt`'s lines are written twice.
- **The first runner's outputs are discarded.** Every hold still took the lock, but the four copies truncated and
  appended the same files under their own round numbers. Their outputs, from `scripts/run.sh` and
  `scripts/measure.sh`, are kept in `logs/discarded/` and used for nothing.
- **The measurements above** come from `scripts/run2.sh`, a single runner guarded by a lock file of its own. They
  ran from 22:55 to 23:54 UTC (`logs/holds.txt`).

## Limitations

- One machine and one unit. Lua's units and the corpora weren't measured.
- **#1067's `lower` result** rests on eight offsets in each tree. Its range over offsets crosses zero, but the count of
  offset pairs and the rounds agree, and the instruction count supports it. The second campaign tests it directly.
- **Fresh copies of one executable** can differ by up to 0.6% from hold to hold (#1233). Each `time-runs` hold makes
  its own copies, and the five holds agree.
