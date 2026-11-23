# Tier 1's loop vectorizer: counts, strided loads and 32-bit indices (buster#2808, 2026-11-23)

The 9700X measurement promised by [buster#3321](https://github.com/buster14a/buster/pull/3321) (part of
[buster#2808](https://github.com/buster14a/buster/issues/2808) and [#2743](https://github.com/buster14a/buster/issues/2743)):
#2743's 25 kernels and harness ([the first vectorizer's record](../tier1-loop-vectorizer-2743-2026-11-14/README.md)),
`--tier1 --tier1-passes=+vectorize -O2 -march=znver5` by main and by the PR, against clang -O2; and the compile cost of
sqlite3.c with the option. By Claude in David's directed sessions: the runs at dfef2f42 by
<https://claude.ai/code/session_01Egbxneu6YHu1odx59NRyLk>, the PR's merged head and this record by
<https://claude.ai/code/session_01NNmNQvp5jYBqvP8rkVuFfM> (both Anthropic / claude-opus-5-5).

**Status:** complete for znver5, which is what the PR promised. x86-64 was not timed (the three kernels stay scalar
below x86-64-v4).

## Commits and objects

- PR head: `e4dceced5904788362000660b8877d7b21d7adcd` (buster#3321 with main merged), `9700x/env.txt`.
- main: `1b9821afe448258d08f47f6110922478aa0e4121`, the main merged into it.
- Release builds on the 9700X with its staged clang 23.1.4, each under its own hold (`9700x/holds-builds.txt`).
- The kernels' objects and linked programs: `9700x/znver5/sha256.txt` and `linked-sha256.txt`. clang -O2's and
  main's `+vectorize` objects, the harness and every linked program of theirs are byte-identical to the earlier run's
  in `~/buster-fast-bench/2808-claude` (`9700x/earlier-dfef2f42/sha256.txt`: that run's main was a891cc05), so their
  timings were not rerun: `run-one.sh` skips `main-tier1-vec`, and `summary.awk` takes clang -O2's and main's lines from
  `9700x/earlier-dfef2f42/results.txt` and the PR's from `9700x/znver5/results.txt`. Only the PR's object changed.
- Every timed line has status 0, and every kernel's digest equals clang -O2's (`summary.awk` prints any mismatch;
  none).

## Results

Geometric means of Tier 1's time over clang -O2's (larger is slower), as linked (placement 0) / at each build's best
of four placements, `9700x/znver5/summary.txt`:

| | 19 loops clang vectorizes | 6 controls |
| --- | ---: | ---: |
| main, `+vectorize` | 2.05 / 1.96 | 1.09 / 1.09 |
| PR, `+vectorize` | **1.30 / 1.28** | 1.09 / 1.09 |

The PR's tier1 report on the kernels: 19 loops vectorized, from main's 16 (`tier1-report-vec*.txt`). The three loops
it adds, in ns per element, as linked / best:

| Kernel | clang -O2 | main | PR | PR / clang | main / PR |
| --- | ---: | ---: | ---: | ---: | ---: |
| `count_eq_u8` | 0.0194 / 0.0194 | 0.2497 / 0.2380 | 0.0036 / 0.0036 | 0.19 / 0.19 | 69.4 / 66.1 |
| `aos_sum` | 0.0529 / 0.0529 | 0.3448 / 0.3444 | 0.0833 / 0.0821 | 1.57 / 1.55 | 4.14 / 4.19 |
| `rgb_to_gray` | 0.0480 / 0.0480 | 0.7775 / 0.7774 | 0.0675 / 0.0674 | 1.41 / 1.40 | 11.5 / 11.5 |

No other kernel moved by more than 5% at its best placement. (At dfef2f42, the PR's second commit, `max_i32` was
12.7% slower than main; at the merged head it is within 5%.) `count_eq_u8` compares 64 bytes per iteration and adds
the mask's population count, where clang -O2 widens the bytes into vector accumulators. `aos_sum` and `rgb_to_gray`
load each strided access separately and de-interleave with `vpermt2*`; members of one struct aren't grouped yet,
which is where most of their remaining 1.4x to 1.6x is.

## Compile cost

`compile-cost.sh`: `--tier1 --tier1-passes=+vectorize -O2 -march=znver5 -c sqlite3.c` by main's and the PR's
compilers, alternating, 11 runs each, pinned to CPU 2, under one hold (`9700x/cost/results.txt`). Medians:

| | user cycles | instructions |
| --- | ---: | ---: |
| main | 3,337,124,074 | 8,229,747,111 |
| PR | 3,339,120,350 | 8,238,850,732 |
| PR / main | +0.06% | +0.11% (+9.1 M) |

The PR vectorizes 3 of sqlite3.c's loops where main vectorizes 1 (the report gains `reductions=1` and `guards=1`).

## Local differential check (not a 9700X measurement)

`stress/`: 27 loops built by buster `--tier1 --tier1-passes=+vectorize --tier1-strict --verify -O2 -fwrapv` at
znver5, x86-64-v4, x86-64-v3 and x86-64 (`-DP=v_ -c kernels.c`), against clang -O0 (`-DP=r_`), driven by `main.c`
(clang -O2): counts at five widths and of two arrays (also the same array twice), struct and strided loads at strides 2
to 9 and negative strides, a strided store and a strided load into an overlapping store, `rgb_to_gray` and `pairs_i16`
with the output at every offset from -24 to +24 bytes of the input, trip counts 0 to 300 at five misalignments and up
to 2,100, each input ending right before (or, for negative strides, starting right after) a `PROT_NONE` page, and
32-bit indices that wrap inside a vector (unsigned and, under `-fwrapv`, signed) over a 17 GiB `MAP_NORESERVE` mapping.
On the cloud session's AVX-512 host, 236,056 checks and 0 failures at every target, with the PR's merged head by its
Release and its AddressSanitizer builds (znver5 vectorizes 21 of the 27 loops, x86-64-v4 16).
