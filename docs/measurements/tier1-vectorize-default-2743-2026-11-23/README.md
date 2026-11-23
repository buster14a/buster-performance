# Tier 1's loop vectorizer by default (buster#2743, 2026-11-23)

The 9700X record of [buster#3421](https://github.com/buster14a/buster/pull/3421). That PR is stage 4 of
[#2743](https://github.com/buster14a/buster/issues/2743)'s design (`docs/tier1-loop-vectorization.md`):
- `--tier1` runs the loop vectorizer by default, and `--tier1-passes=-vectorize` turns it off.
- The vector-only LICM policy (#2781) moves nothing out of a loop that holds a call (#2831's finding).

The design asks for this record before the default changes: #2743's kernels against the recorded 3.32 and 17.50, short
trip counts, compile cost on the compiler itself and on `sqlite3.c`, and the tracked programs.

By Claude in David's directed session <https://claude.ai/code/session_01Egbxne1aC1Fr28UcheVxVB>
(Anthropic / claude-opus-5-5).

## Commits and builds

| Build | Commit |
| --- | --- |
| base | main `b7d0b5edff73852852f0664c07fab61b00cad378`, the PR's base |
| head | `d682e67a3abae22f09a3855695d4b11f36ea1ffa`, #3421's code |

- **The head commit.** #3421 merged as `d6039117` at its head `01914a5d`. `01914a5d` differs from `d682e67a` in docs
  and comments only.
- **Builds.** Release builds on the 9700X with its staged clang 23.1.4, each under its own hold of the lock
  (`9700x/build-*.log`). `9700x/env.txt` has the machine, clang, perf, the CPU 2 governor and both compilers' sha256.
- **Holds.** Every build, timing run and compile ran under its own hold (`9700x/holds.txt`). No other busy process
  was listed as any hold was taken (`9700x/busy.txt` has the per-run `ps` snapshots).
- **Run conditions.** All runs are pinned to CPU 2. The kernels' timings are the best of 7 samples of about 40 ms.
  The program runs are `measure-tier1-programs --runs 11`.

## Objects

On #2743's kernels (`src/kernels.c`, unchanged from the earlier records), at both znver5 and x86-64, two pairs of
objects are byte-identical (`9700x/*/sha256.txt`):
- head's default object and base's `--tier1-passes=+vectorize` object;
- head's `-vectorize` object and base's default object.

The LICM rule doesn't touch these leaf loops, so the only change on them is the default. Every timed line has status
0, and every kernel's digest equals clang -O2's at every placement and trip count (`summary.txt`: 0 problems).

## #2743's kernels

Geometric means of each build's time over clang -O2's (larger is slower), as linked (placement 0) / at each build's
best of four placements (`9700x/*/summary.txt`):

| | znver5: 19 loops | znver5: 6 controls | x86-64: 19 loops | x86-64: 6 controls |
| --- | ---: | ---: | ---: | ---: |
| main's `--tier1` | 15.27 / 15.68 | 1.09 / 1.09 | 3.27 / 3.26 | 1.08 / 1.08 |
| **#3421's `--tier1`** | **1.32 / 1.29** | 1.09 / 1.09 | **2.04 / 2.06** | 1.08 / 1.08 |
| main / #3421 | 11.54 / 12.17 | 1.00 / 1.00 | 1.60 / 1.58 | 1.00 / 1.00 |

- **Against the issue.** #2743 recorded 17.50 (znver5) and 3.32 (x86-64) for these loops; today's main reads 15.27
  and 3.27.
- **znver5.** All 19 loops vectorize. Most of what remains is the reductions' single accumulator chain (unrolling,
  #2755), `aos_sum`'s and `rgb_to_gray`'s ungrouped strided loads (#2808), and `stencil3_u8` and `matmul_f32`.
- **x86-64.** Only 6 of the unit's loops vectorize (`9700x/x86-64/tier1-report-head.txt`; 19 at znver5): masks,
  lane conversions and reductions are EVEX forms in Tier 1. Those 6 are `add_i32`, `saxpy_f32`, `i32_to_f32`,
  `fill_u32`, `copy_u8` and `matmul_f32`'s inner loop.

## Short trip counts

`src/short.c` calls each kernel with n elements, for 25 trip counts from 0 to 257, and times each call (the best of 5
samples of about 10 ms). Every digest is clang -O2's. The table gives the geometric mean of #3421's time per call over
main's, over the 19 loops:

| n | 0 | 1 | 2 | 4 | 7 | 8 | 15 | 16 | 31 | 64 | 128 | 256 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| znver5 | 1.40 | 1.57 | 1.43 | 1.23 | 0.99 | 0.88 | 0.63 | 0.47 | 0.37 | 0.20 | 0.14 | 0.09 |
| x86-64 | 1.07 | 1.05 | 1.06 | 1.00 | 1.02 | 0.95 | 0.92 | 0.84 | 0.82 | 0.72 | 0.69 | 0.61 |

The six controls stay within 0.95 to 1.04 (they don't vectorize; the spread is placement).

**Break-even.** A vectorized loop pays a fixed cost before it tests whether there is a vector's worth of work. At
znver5 it breaks even at about 7 elements. Below that, the cost per call is:

| Kernel at znver5, ns per call | main | #3421 | clang -O2 |
| --- | ---: | ---: | ---: |
| `sum_i32` at n = 1 | 1.1 | 1.8 | 1.1 |
| `add_i32` at n = 0 | 1.4 | 3.0 | 1.4 |
| `rgb_to_gray` at n = 1 | 1.6 | 5.7 | 1.8 |
| `stencil3_u8` at n = 1 | 1.8 | 4.5 | 2.0 |

The fixed cost has three causes:
- **Guards first.** The overlap guards and the vectors' set-up (the strided loads' permute tables, the splats) come
  before the trip-count test, so even n = 0 pays them.
- **Float remainder.** The float loops (`saxpy_f32`, `i32_to_f32`) keep a scalar remainder, which runs slower than
  main's loop below 16 elements. For example, `saxpy_f32` at n = 7 takes 3.9 ns against 2.7.
- **Clang's shape.** Clang tests the trip count against the vector width first, so its short calls cost what its
  scalar loop does.

## Compile cost

`scripts/compile-cost.sh`: `--tier1 -O2 -march=M -c` by base's and head's compilers, alternating, 11 runs each, pinned
to CPU 2 (so one lane). Each compiler compiles with its own default passes. Medians (`9700x/cost/results.txt`):

| | user cycles | instructions | `.text` bytes |
| --- | ---: | ---: | ---: |
| `sqlite3.c` (speedtest1's options), znver5 | +1.01% | +0.42% (+35.1 M) | 1,457,688 → 1,460,808 |
| `sqlite3.c`, x86-64 | +0.63% | +0.24% (+19.8 M) | 1,456,600 → 1,456,824 |
| the compiler's `main.c` (`-Isrc -fwrapv -funsigned-char -fno-strict-aliasing`), znver5 | +0.64% | −0.03% (−7.0 M) | 1,802,846 → 1,749,870 |

- **`main.c` at x86-64.** No row: the compiler's own source refuses a non-AVX-512 target (#2924), and both compilers
  stop there alike.
- **Against #2831.** #2831 had the option at +0.98% instructions on `sqlite3.c` at znver5. The difference is the LICM
  rule: `sqlite3VdbeExec` is no longer rewritten.
- **`main.c`.** Its object vectorizes 14 loops (`9700x/cost/results.txt`'s report lines). It also loses 2.9% of its
  code: the LICM rule takes its call stores from 12,944 to 10,868 and its spill stores from 11,288 to 10,147. The
  vector lexer is one of the functions that change.

## The tracked programs

`measure-tier1-programs --runs 11`, without tcc, `9700x/programs/`.

**Main.** Main's compiler runs with `+vectorize` as a variant: this PR's default without its LICM rule. At znver5 the
variant is `@scripts/znver5-vec.rsp` (`-march=znver5 --tier1-passes=+vectorize`) against `-march=znver5`.

**The branch.** Head's compiler runs with `-vectorize` as a variant, and at znver5 with `-march=znver5` against
`@scripts/znver5-novec.rsp`. The x86-64 runs pass `--check-code-size`, CI's configuration, and both builds pass it.

The vectorizer on over off, by the same compiler in one run:

| | speedtest1 cycles | speedtest1 instructions | Lua's five scripts, cycles | Lua, instructions |
| --- | ---: | ---: | ---: | ---: |
| main, x86-64 | 0.9982 | 1.0000 | 1.0127 | 1.0005 |
| main, znver5 | **1.0190** | **1.0134** | 1.0005 | 1.0003 |
| #3421, x86-64 | 0.9952 | 1.0000 | 1.0036 | 1.0001 |
| #3421, znver5 | 1.0054 | 1.0019 | 0.9936 | 0.9999 |

**Main at znver5.** speedtest1's +1.34% instructions is #2831's finding. Unit inlining copies the sorter's vectorized
`nDiv *= 16` into `sqlite3VdbeExec`, and LICM moves its two splats out of the interpreter's loop. The function grows
from 87,473 to 130,652 bytes, with 1,788 more stores around calls.

**#3421 at znver5.** With the LICM rule, `sqlite3VdbeExec` is 89,931 bytes and LICM moves nothing in it. The
default costs speedtest1 0.19% of its instructions (+4.6 M). The cycles move within code placement's noise, about 1%
between equal builds.

Few loops in these programs vectorize: 1 in Lua at both targets, 1 in `sqlite3.c` at x86-64 and 3 at znver5 (the
compile cost's report lines). So they show that the default costs nothing, not that it gains anything.

## Vector code: `measure-tier1-rows`

`measure-tier1-rows --runs 11 --march znver5 --base` main's compiler, `9700x/rows.txt`. Head's `--tier1` against
main's:

| Program | user cycles | instructions |
| --- | ---: | ---: |
| rows | 1.000 | 1.000 |
| scan | 0.990 | 1.000 |
| the compiler's lexer | **0.976** | 0.991 |

`c_tokenize` goes from 3.725 to 3.289 cycles a byte; clang -O2 takes 0.757. The lexer's loops hold calls. Main's LICM
moved its vector constants out of them, and Tier 1 stored and reloaded them around every call. The `tokenize_c*`
functions are about 10% smaller with the rule.

## Reproducing

1. `scripts/build-base.sh base` and `scripts/build-base.sh head` build each tree under the lock.
2. `scripts/measure.sh` runs everything after the builds, detached: the rows, the kernels' builds, their timings at
   four placements and at short trip counts, the compile costs, then `scripts/programs.sh` for the branch.
   - Main's two program runs were `programs.sh base base-x86-64 --tier1-passes=+vectorize` and
     `CHECK= programs.sh base base-znver5 -march=znver5 @inputs/znver5-vec.rsp`.
   - `programs.sh` is the second version, whose `CHECK` (empty) leaves out `--check-code-size`. The first x86-64 run
     used the first version, which always passed it.
3. `scripts/summary.py 9700x/M` prints the kernels' and short trip counts' tables.
