# The loop vectorizer's AVX-512 masked remainder (buster#2807, 2026-11-20)

The 9700X measurement of [buster#2807](https://github.com/buster14a/buster/issues/2807): the Tier 1 loop vectorizer's
tail as one masked vector iteration instead of the scalar loop, where the target has masked moves and the masks from a
general register (`--tier1 --tier1-passes=+vectorize`). By Claude in David's directed session
(<https://claude.ai/code/session_01NNmNQvmuGSny2j5d2tWFbo>, model claude-opus-5-5), from the claim in
[comment 7040943386](https://github.com/buster14a/buster/issues/2807#issuecomment-7040943386).

- **Base:** buster `8a1b1a03621fd1c5a4e3b026057a128d93ded488` (main where the branch starts).
- **Head:** buster `a6a2b25d0b233344bc10a0ca7cf6f17f3151f974` (branch `claude/peaceful-brahmagupta-rk1esk-2807`).
- Both Release builds (`BUSTER_DEBUG_INFO=0`) on the 9700X; receipts in `9700x/record/receipts.txt`.

## Method

`scripts/record.sh`, one run, every step one hold of `exclusive.sh` (15 holds, `9700x/record/holds.txt`; the busiest
processes at each timed step in `busy.txt`: the machine was idle).

- **Kernels:** buster#2743's `kernels.c` and `kernels.h` unchanged (`src/`, copied from
  [`tier1-array-loops-2743-2026-11-14/src`](../tier1-array-loops-2743-2026-11-14/src) at the revision in
  `src/SOURCE-REVISION`), compiled by each tree with `--tier1 --tier1-passes=+vectorize --tier1-report --verify -O2
  -march=znver5`; every other part by clang -O2.
- **Short lengths** (`src/short.c`, new): the 12 loops Tier 1 vectorizes at znver5, each at lengths 0, 1, 3, 7, 8, 9, 15,
  16, 17, 31, 32, 33, 63, 64, 65, 100, 127, 128, 129 and 257: 20,000 calls a measurement, the least of 7 measurements as
  TSC ticks a call, on CPU 2; three rounds of each build, alternating. A digest of every result, which both builds print
  alike (`917eb7d6ca028fab`).
- **8 KB arrays:** #2743's `harness.c` unchanged, every one of its 25 kernels, three rounds of each build, alternating.
- **Compile cost:** `--tier1 --tier1-passes=+vectorize -O2 -march=znver5 --lanes 1 -c sqlite3.c` (the repository's
  frozen amalgamation, as #2743's record), 11 alternating runs a tree, `perf stat` user counters.

`scripts/tables.py 9700x/record` makes `tables.md`. For each kernel and length it takes the least of the three rounds,
then the geometric mean of head/base over the lengths below one vector, over those with a remainder past one vector and
over the exact multiples of the lanes (at 64 bytes: 8 for the loops with an 8-byte element or accumulator, 64 for
`copy_u8`, 16 for the rest; `stencil3_u8`'s trip count is n - 2).

## Results

Head/base, ticks a call (smaller is faster):

| kernel | lanes | below one vector | remainder past one | exact multiples | all lengths |
| --- | ---: | ---: | ---: | ---: | ---: |
| `sum_i32` | 8 | 1.173 (3) | 0.941 (11) | 1.092 (5) | 1.013 |
| `sum_u8` | 16 | 0.728 (6) | 0.783 (9) | 0.995 (4) | 0.805 |
| `dot_i16` | 16 | 0.724 (6) | 0.861 (9) | 1.109 (4) | 0.860 |
| `cond_sum_i32` | 8 | 0.905 (3) | 0.848 (11) | 1.100 (5) | 0.918 |
| `popcount_u64` | 8 | 0.859 (3) | 0.916 (11) | 1.042 (5) | 0.938 |
| `add_i32` | 16 | 0.771 (6) | 0.798 (9) | 1.060 (4) | 0.838 |
| `scale_u8` | 16 | 0.683 (6) | 0.851 (9) | 1.162 (4) | 0.848 |
| `blend_u8` | 16 | 0.578 (6) | 0.723 (9) | 0.917 (4) | 0.708 |
| `clamp_i32` | 16 | 0.531 (6) | 0.731 (9) | 1.119 (4) | 0.723 |
| `fill_u32` | 16 | 0.651 (6) | 0.704 (9) | 1.034 (4) | 0.745 |
| `copy_u8` | 64 | 0.448 (12) | 0.532 (5) | 1.062 (2) | 0.513 |
| `stencil3_u8` | 16 | 0.660 (7) | 0.571 (11) | (none) | 0.604 |
| all 12 | | 0.650 | 0.774 | 1.062 | 0.781 |

- **Below one vector** the loops run in the masked tail alone: 0.650 of base's time over the 12 loops, most where a
  vector holds many elements (`copy_u8`, 64 lanes: 0.448). The exception is `sum_i32` (8 lanes, 1.173): its scalar loop
  of at most 7 additions is cheaper than the mask, the masked load and the reduction.
- **Past one vector with a remainder:** 0.774.
- **At exact multiples** head reads 6.2% slower (1.062): the remainder test before the join, and the tail's code
  between the vector loop and its exit.
- **8 KB arrays** (`tables.md`): a geometric mean of 0.984 over the 25 kernels, which no tail decides (8 KB is a
  multiple of every vector). The loops neither tree vectorizes move as much (`matmul_f32` 0.938, `max_i32` 1.045,
  their code the same), so these differences are the functions' placement, not this change.
- **Code size** (`size-*.txt`): the kernels' `.text` from 3,599 to 4,991 bytes, 116 bytes a vectorized loop.
- **Compile cost** (`cost.tsv`): `sqlite3.c`, whose two loops the pass vectorizes, 3,322.1 M to 3,328.2 M user cycles
  (+0.18%), 8,173.43 M to 8,179.41 M instructions (+0.073%), medians of 11.
- Both reports (`report-*.txt`): 12 of 27 loops vectorized, all at 64 bytes, no fallback.

## Reproduction

On the 9700X, with `base/` and `head/` checkouts of the two commits beside `harness/`, and `harness/` holding `src/`,
`scripts/` and `sqlite3.c`: `bash scripts/record.sh` from `harness/`, then `python3 scripts/tables.py record`.
