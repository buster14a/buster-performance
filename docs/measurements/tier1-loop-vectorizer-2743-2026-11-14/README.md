# Tier 1's loop vectorizer on the array loops (buster#2743, 2026-11-14)

The 9700X measurement of [buster#2743](https://github.com/buster14a/buster/issues/2743)'s first loop vectorizer
(`ir_vectorize_loops.c`, `--tier1 --tier1-passes=+vectorize`), on the kernels and harness of
[the issue's earlier record](../tier1-array-loops-2743-2026-11-14/README.md). By Claude in David's directed session
(<https://claude.ai/code/session_01NNmNQvUK6RYgVXj7fzdW7P>, model claude-opus-5-5), from the claim in
[comment 6885294923](https://github.com/buster14a/buster/issues/2743#issuecomment-6885294923).

**Status:** complete. With the option, Tier 1 vectorizes 12 of the 19 loops clang -O2 vectorizes at znver5 and 5 at
x86-64; those loops run 12.6x and 4.8x faster than Tier 1 without it, at 1.53x and 1.36x clang -O2's time (from 19.32x
and 6.50x). Nothing else changes: the other loops' and the controls' code is the same, and without the option the
branch's objects are main's byte for byte. Compiling sqlite3.c with the option cost 2.30% more cycles at znver5 in the first build and 1.04% at
a5b52808d (0.44% at x86-64); see "Compile cost".

## Results

Geometric means of the time ratios (larger is slower), as linked / at each build's best placement, from
`9700x/MARCH/tables.md`:

| Ratio | znver5: 19 loops | znver5: the 12 vectorized | x86-64: 19 loops | x86-64: the 5 vectorized | controls (6) |
| --- | ---: | ---: | ---: | ---: | ---: |
| Tier 1 / clang -O2 | 16.75 / 16.41 | 19.32 / 19.24 | 3.44 / 3.39 | 6.50 / 5.92 | 1.09 / 1.08 |
| Tier 1 + vectorize / clang -O2 | 3.44 / 3.23 | 1.53 / 1.47 | 2.31 / 2.31 | 1.36 / 1.38 | 1.09 / 1.08 |
| Tier 1 / Tier 1 + vectorize | 4.86 / 5.09 | 12.60 / 13.12 | 1.49 / 1.47 | 4.78 / 4.30 | 1.00 / 1.00 |
| Tier 1 + vectorize / clang -O2 without vectorizer and unroller | 0.22 / 0.21 | 0.09 / 0.08 | 0.75 / 0.75 | 0.27 / 0.26 | 1.03 / 1.03 |

The controls column is znver5 / x86-64 as linked.

- **znver5** (64-byte vectors, `bytes64=12`): `sum_i32`, `sum_u8`, `dot_i16`, `cond_sum_i32`, `popcount_u64`, `add_i32`,
  `scale_u8`, `blend_u8`, `clamp_i32`, `fill_u32`, `copy_u8`, `stencil3_u8`. The element-wise loops reach clang:
  `add_i32` 0.99x, `scale_u8` 0.82x, `blend_u8` 0.86x, `fill_u32` 1.04x, `clamp_i32` 1.27x, `copy_u8` 1.34x. The
  reductions stay 1.65x (`cond_sum_i32`) to 2.82x (`popcount_u64`) behind: clang's loop (as a local clang 23.1.6
  builds it) keeps four accumulators where the vector loop has one dependency chain (buster#2755's unroller), and
  multiplies `dot_i16`'s pairs with `vpmaddwd`. The explicit-vector probe's sources are faster still on `sum_u8` and
  `dot_i16` (4.93x and 2.88x the vectorized C loop) and slower on `clamp_i32` and `cond_sum_i32` (0.58x, 0.84x).
- **x86-64** (SSE2, `bytes16=5`): `add_i32`, `saxpy_f32`, `fill_u32`, `copy_u8`, `matmul_f32`'s inner loop. Masks,
  conversions between lane widths, reductions and population counts are EVEX forms in Tier 1, so the other nine
  loops the pass takes at znver5 refuse with `width` here.
- **Refused** (`refusals.txt`: each kernel compiled alone with `--tier1-report` by buster 6380781, whose `loops` count
  includes outer loops): `max_i32` (`shape`: if-conversion keeps its update a
  branch, buster#2805), `saxpy_f32`, `matmul_f32`'s inner loop and `dot_f32` at znver5 (`operation`: the C driver's
  contracted `fma`) and `i32_to_f32` (`operation`: `sitofp`, both buster#2806), `aos_sum` (`address`: strided),
  `rgb_to_gray` (`use`: `3 * i` at `int`, a strided access) and `count_eq_u8` (`width`: bytes counted into `size_t`,
  all three buster#2808); the controls `dot_f32` at x86-64, `crc32_table` and `fnv1a` (`phi`: a float sum and
  recurrences), `prefix_sum_i32` (`dependence`), `histogram_u8` (`address`: gathered) and `find_u8` (`shape`: an
  early exit); `matmul_f32`'s two outer loops (`shape`). The masked AVX-512 remainder is buster#2807.
- **Placement.** `matmul_f32` at znver5 (0.497 to 0.737 ns per element as linked, 0.373 to 0.374 at best) and
  `clamp_i32` at x86-64 (0.530 to 0.725) are the same code in both builds: their placement tables span 1.98x and
  1.37x. The "19 others" columns' as-linked differences are those two.
- **Object identity** (`sha256.txt`): `buster-tier1-vec` and `buster-tier1-vec-scalar` are one object (the vector and
  scalar paths agree), `buster-tier1` is `main-tier1`, and `buster-tier0` is `main-tier0`, at both targets. Every
  build's digests agree for every kernel.

### Compile cost

`--tier1 -O2 -c sqlite3.c` by the branch's Release compiler without and with the option, 11 alternating runs each on
CPU 2, medians (`9700x/cost/`):

| Build | Target | Cycles (user) | Instructions (user) | Wall |
| --- | --- | ---: | ---: | ---: |
| a1a0892, without | znver5 | 3,344.2 M | 8,209.24 M | 0.6277 s |
| a1a0892, with | znver5 | 3,421.1 M (+2.30%) | 8,397.58 M (+2.29%) | 0.6419 s (+2.26%) |
| a1a0892, without | x86-64 | 3,346.6 M | 8,208.77 M | 0.6285 s |
| a1a0892, with | x86-64 | 3,397.0 M (+1.51%) | 8,335.57 M (+1.54%) | 0.6377 s (+1.46%) |
| 6380781, without | znver5 | 3,340.5 M | 8,209.36 M | 0.6276 s |
| 6380781, with | znver5 | 3,381.5 M (+1.23%) | 8,298.18 M (+1.08%) | 0.6351 s (+1.20%) |
| 6380781, without | x86-64 | 3,336.6 M | 8,208.89 M | 0.6266 s |
| 6380781, with | x86-64 | 3,357.5 M (+0.63%) | 8,236.17 M (+0.33%) | 0.6304 s (+0.61%) |
| a5b52808d, without | znver5 | 3,333.7 M | 8,209.24 M | 0.6258 s |
| a5b52808d, with | znver5 | 3,368.5 M (+1.04%) | 8,289.85 M (+0.98%) | 0.6325 s (+1.07%) |
| a5b52808d, without | x86-64 | 3,328.4 M | 8,208.77 M | 0.6246 s |
| a5b52808d, with | x86-64 | 3,343.1 M (+0.44%) | 8,227.84 M (+0.23%) | 0.6277 s (+0.50%) |

The pass vectorizes 2 of sqlite3.c's loops. In-process cycle counters in a local build put 84% of its time in the CFG
(44%) and the dominator analysis (40%), built for the 890 of 2,602 functions with a phi on a back edge in block order;
6380781 finds its loops from the blocks' terminators instead (`scripts/cost2.sh`), which halves the cost, and a5b52808d
(`scripts/cost3.sh`) skips the per-row arrays and kinds in the 651 candidates without a loop of the admitted shape (the
pass's own time by the same counters: 56.3, 16.2 and 11.3 million). The rest is not the pass's alone: at znver5 the
option adds 80.6 M instructions against x86-64's 19.1 M for the same analysis, and its two loops are `unixShmLock`'s and
`chacha_block`'s, which unit inlining puts in `sqlite3_randomness` and from there in `sqlite3VdbeExec` (which changes
size and gains 8 zmm and 5 ymm operands; without inlining, the option vectorizes 4 loops in `chacha_block`,
`unixShmLock` and `vdbeSorterAddToTree` and `sqlite3VdbeExec` has no zmm operand). Its profiles (`base-symbols.txt`,
`vectorize-symbols.txt`, one run each, about 12 M instructions of sampling noise on the largest symbols) can't place the
61 million; `scripts/cost4.sh` times both sides without unit inlining (results pending).

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
- `scripts/measure2.sh` restarted `measure.sh` after x86-64's `buster-tier1-vec` placements with one lock hold per
  build (its four placements in turn) instead of one per placement, the shared lock's queue having made each hold wait
  about ten minutes; x86-64's interrupted `buster-tier1` build ran again whole.
- `scripts/cost2.sh` re-ran the compile-cost A/B after the pass stopped building a CFG and dominators (buster
  6380781): `9700x/cost/` has both runs.
