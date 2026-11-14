# Tier 1 on array loops: the kernels, the harness and the numbers (buster#2743, 2026-11-14)

This is the evidence for [buster#2743](https://github.com/buster14a/buster/issues/2743): what `--tier1` makes of loops over arrays, beside clang and gcc, and what its back end makes of the same loops once they are written with vector operations. By Droid in David's directed session (Factory Droid session `5d5f629c-b881-4d75-9267-35567e982c31`, model Fable 5.2 as Droid reports it), from the claim in [comment 6878234250](https://github.com/buster14a/buster/issues/2743#issuecomment-6878234250).

**Status of this record:** the sources, the scripts and the local runs are here, and so are the 9700X's runs of the two intrinsic loops that [buster#2750](https://github.com/buster14a/buster/issues/2750) came from ("By-value vectors' copies below AVX-512" below). The 9700X's completed x86-64 matrix for the 25 kernels is under `9700x/x86-64/`; the shorter znver5 run is in progress under `9700x/znver5/` (currently the completed Tier 1 and clang -O2 builds). Until its explicit-vector rows arrive, those and the znver4 kernel numbers are from the session's desktop and are preliminary.

## Revisions and toolchains

| Role | Value |
| --- | --- |
| buster | main `c471f32f0136bbb21cfe083c9947f86346de2a0a` |
| local host | Ryzen 9 7940HS (Zen 4), Linux 7.3.4-1-cachyos, clang 23.1.5, gcc 16.2.1 (`local/host.txt`) |
| local compiler | `./build.sh` (Develop) at that commit, sha256 `9b50780a…` |
| 9700X | Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.4, gcc 16.2.1, perf 7.2.9, governor and EPP `performance` (`9700x/env.txt`) |
| 9700X compiler | `./build.sh --config Release` at that commit, sha256 `26e3cb81…`; the patched tree's, `0dfcb62b…` (`9700x/vector-copies-ab.txt`) |

## What is measured

`src/kernels.c` has 25 loops as C programmers write them, with no `restrict`, no intrinsics and no pragmas:

- **19 that clang -O2 vectorizes:** sums, a dot product, a maximum, a conditional sum, a count, a population count, an array-of-structs sum, `d[i] = a[i] + b[i]`, saxpy, byte scaling and blending, a clamp, an int-to-float conversion, a fill, a copy, a 3-tap stencil, RGB to gray and a matrix multiply.
- **6 controls that it leaves scalar:** a float dot product (no `-ffast-math`), a prefix sum, a histogram, a byte search, a table CRC and FNV-1a.

`src/kernels_hand.c` has 12 of them as a loop vectorizer would hand them to the back end: one AVX-512 loop over whole vectors, the last partial vector under a mask, and a run-time overlap test before a loop that stores. It doesn't unroll. The other 13 are `kernels.c`'s, unchanged.

`src/harness.c` is always built by clang -O2 and linked with one build of the kernels. It calls each kernel through the unit's boundary on 8 KB arrays (so the loops run from the L1 cache), prints a digest of three calls' results and of every output array, and times calibrated repetitions: the best of 7 samples of about 40 ms. A line is `KERNEL ELEMENTS REPETITIONS SECONDS NS_PER_ELEMENT DIGEST`.

## Scripts

- `scripts/build-all.sh BUSTER MARCH`, `scripts/run-all.sh MARCH [CPU]`: the 12 local builds and their runs.
- `scripts/pad.sh MARCH NAME [CPU]`: one build linked behind 0, 16, 32 and 48 bytes of padding, with each innermost loop's placement.
- `scripts/loops.py BINARY`: each `k_*` function's innermost loop (its shortest backward branch): start, end, bytes, instructions, whether it lies across a 64-byte line, and its start's offset in the line.
- `scripts/tables.py [--march M] FILE...`: the Markdown tables from result lines.
- `scripts/9700x/`: `build-compiler.sh` (the Release build under the lock), `measure.sh MARCH...` (one `exclusive.sh` hold per build step and per (build, placement), each run pinned to CPU 2), `build-9700x.sh` and `run-one.sh`. At placement 0, `run-one.sh` also takes `perf stat`'s user cycles and instructions of a 1-repetition run and of a run of the calibrated repetitions, so the kernel's own counts are their difference.

- `scripts/9700x/sse-probe.sh`, `vector-copies-ab.sh`, their launchers and `scripts/ab-table.py`: buster#2750's runs, described in their section below.

The builds:

| Name | Command |
| --- | --- |
| `clang-O0`, `clang-O1`, `clang-O2`, `clang-O3` | `clang -ON -march=MARCH` |
| `clang-O2-novec` | `clang -O2 -fno-vectorize -fno-slp-vectorize` |
| `clang-O2-novec-nounroll` | the same with `-fno-unroll-loops` |
| `gcc-O2`, `gcc-O3` | `gcc -ON -march=MARCH` |
| `buster-tier0` | `compiler -O2 -march=MARCH` |
| `buster-tier1` | `compiler --tier1 -O2 -march=MARCH` |
| `buster-tier1-licm`, `buster-tier1-all` | with `--tier1-passes=+licm`, `--tier1-passes=+all` |
| `clang-O2-hand`, `buster-tier1-hand` | `kernels_hand.c` by `clang -O2` and by `--tier1` |

## 9700X kernel results (x86-64)

`9700x/x86-64/results.txt` is the completed four-build, four-placement run:
400 timing lines and 100 `perf` lines, all with status 0. `tables.md` beside it
is `scripts/tables.py`'s complete output. The directory also keeps the build
and run logs, compiler hash, Tier 1 reports and each linked binary's loop
placements. The lock holds and host are `9700x/holds.txt` and `9700x/env.txt`.
Every build gives the same digest on every kernel.

Geometric means of the time ratios (larger is slower):

| Ratio | 19 vectorized, as linked | 19 vectorized, best placement | 6 controls, as linked | 6 controls, best placement |
| --- | ---: | ---: | ---: | ---: |
| `--tier1` / clang -O2 | 3.32 | 3.39 | 1.08 | 1.08 |
| `--tier1` / clang -O2, no vectorizer or unroller | 1.08 | 1.10 | 1.03 | 1.03 |
| clang without vectorizer or unroller / clang without vectorizer | 1.41 | 1.42 | 1.05 | 1.05 |
| clang without vectorizer / clang -O2 | 2.18 | 2.17 | 1.00 | 1.00 |

So the dominant missing piece is vectorization (2.18), with unrolling a
separate smaller component (1.41). At this target Tier 1's scalar loops are
within 1.08 of clang's when clang's vectorizer and unroller are disabled.

Placement does not reproduce the desktop's simple 64-byte-line rule. Most
Tier 1 loops vary by only a few percent across the four placements. The largest
worst/best ratios are `matmul_f32` 1.96, `saxpy_f32` 1.89, `clamp_i32` 1.38 and
`blend_u8` 1.28, but their slow placements are not consistently the ones whose
innermost loop crosses a 64-byte line. The raw placement tables retain every
case; no alignment rule is inferred from them.

The original long script was stopped after this x86-64 matrix because the
shared lock was heavily contended. `scripts/9700x/measure-short.sh` runs the
smaller znver5 set as linked (placement 0): Tier 1 and clang -O2 on the C and
explicit-vector units, plus clang's two scalar configurations. Its partial output is
under `9700x/znver5/`: the first two builds give `--tier1` / clang -O2 a
geometric mean of 17.50 on the 19 vectorized loops and 1.09 on the controls,
with matching digests. The other builds in
`scripts/9700x/measure.sh` were not run on the 9700X.
## Local results (Zen 4, preliminary)

`local/x86-64/run1.txt` (12 builds), `local/x86-64/pad-*.txt` (two builds at four placements, with `p*-*.loops`), `local/znver4/run1.txt` (four builds); `tables.md` beside each is `tables.py`'s output. The runs weren't pinned and the desktop wasn't idle.

- **Correctness:** every build gives the same digest on every kernel, at both targets. `--tier1-report` said Tier 1 compiled all 25 functions of `kernels.c` and all 85 of `kernels_hand.c` (its inlined intrinsics included), with no fallback.
- **`-march=x86-64`:** `--tier1` over clang -O2 has a geometric mean of 4.0 on the 19 loops clang vectorizes and 1.14 on the 6 controls.
- **`-march=znver4`:** 11.7 on the 19 and 1.36 on the controls.
- **By cause, x86-64:** `--tier1` over clang's scalar loops that aren't unrolled is 1.28 on the 19 (1.25 with each at its best placement). The rest of the 4.0 is unrolling and vectorization.
- **Placement:** a loop that runs one iteration a cycle runs at half that when it lies across a 64-byte line: `sum_i32` 0.421 ns against 0.212, `copy_u8` 0.421 against 0.211, `find_u8` 0.421 against 0.209. clang's loops that aren't unrolled lose the same when they are pushed across a line (`saxpy_f32`, `scale_u8`, `i32_to_f32` 2.0). So it is the processor's, not either compiler's; whether Zen 5 has it is what the 9700X's four placements answer.
- **The back end on vector code, znver4:** `--tier1` on `kernels_hand.c` is 13 times faster than on the C loops (geometric mean of the 12), 0.94 of clang -O2's own vectorization of the C loops, and 1.10 of clang -O2 on the same vector source.

## By-value vectors' copies below AVX-512 (buster#2750), on the 9700X

`src/sse_probe.c` has two loops written with SSE2 intrinsics: one adds two `int32_t` arrays, one accumulates a float product in one vector. `src/avx_probe.c` is the same two with 32-byte vectors. `src/sse_bench.c` (clang -O2) is linked with one object of either and times 7 samples of 20,000 calls of each loop on 2,048 elements, keeping the best; the counters are `perf stat`'s of one more whole run, in user mode. Every run was pinned to CPU 2 inside one `exclusive.sh` hold (`9700x/holds.txt`).

- `9700x/sse-probe.txt`, `9700x/sse/*.perf`: main's compiler (`scripts/9700x/sse-probe.sh`, launched by `sse-launch.sh`). The issue was filed from these.
- `9700x/vector-copies-ab.txt`, `9700x/ab/*.perf`: main's compiler beside the patched one (`scripts/9700x/vector-copies-ab.sh`). `9700x/vector-copies-ab.md` is `scripts/ab-table.py`'s tables of it.
- `scripts/9700x/vector-copies-launch.sh` built the patched tree from main's with `scripts/9700x/vector-copies.patch` (`9700x/fix-build.log`). The patch is buster commit `32cdedc330717a7a36a18ed35eac3dcaa791ed4e`'s change to its three compiler sources, without that commit's test and guides.
- `9700x/vector-copies-objects.txt`: `cmp` and `sha256sum` of the A/B's kept objects, each of main's against the patched compiler's.

`--tier1 -O2`, main's compiler and the patched one:

| Source, `-march` | `add_i32`, `dot_f32` ns/element, main | patched | User cycles, main | patched | Ratio | Store-to-load conflicts, main | patched |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| SSE2, `x86-64` | 4.740, 5.957 | 0.093, 0.093 | 17,012 M | 297 M | 57.3 | 2,027 M | 0.28 M |
| SSE2, `x86-64-v2` | 4.740, 5.959 | 0.093, 0.093 | 17,012 M | 297 M | 57.3 | 2,027 M | 0.28 M |
| SSE2, `x86-64-v3` | 4.741, 5.957 | 0.055, 0.093 | 17,012 M | 240 M | 70.9 | 2,062 M | 0.28 M |
| AVX2, `x86-64-v3` | 2.626, 3.307 | 0.048, 0.051 | 9,439 M | 157 M | 60.0 | 1,027 M | 0.28 M |
| SSE2, `x86-64-v4` | 0.055, 0.093 | 0.055, 0.093 | 239 M | 247 M | 0.97 | 0.26 M | 0.26 M |
| AVX2, `x86-64-v4` | 0.031, 0.051 | 0.031, 0.051 | 134 M | 132 M | 1.01 | 0.28 M | 0.28 M |

What the runs say:

- **Before:** below x86-64-v4, `--tier1` took 6.4 to 7.4 times Tier 0's cycles on these loops and 60 to 67 times clang -O2's with its vectorizer and unroller off. The conflicts are `ls_bad_status2.stli_other`, about 14 for each iteration of either loop (2,027 M over 143 M iterations of 4 elements; 1,027 M over 72 M of 8): the 16- or 32-byte loads of vectors that were stored as 8-byte integers.
- **After:** `--tier1` takes 0.10 to 0.12 of Tier 0's cycles, and 0.84 to 1.11 of clang -O2's without its vectorizer and unroller on the same source.
- **What didn't change:** all six Tier 0 objects, and both x86-64-v4 Tier 1 objects, are byte-identical between the two compilers (`9700x/vector-copies-objects.txt`). Every one of the 36 programs printed the same digest.
- **How far a single timing can be trusted:** the two x86-64-v4 rows ran identical objects, and their whole-run cycles differ by 3% and 1%. Tier 0's `add_i32` time differs far more between two runs of identical objects (AVX2 source at x86-64-v4: 0.643 and 0.133 ns/element; SSE2 at x86-64: 0.258 and 0.284), with equal instruction counts. Its cause wasn't looked for; no conclusion here rests on a Tier 0 timing to better than that.

The session's desktop ran the tests, on a Develop build (`local/vector-copies/`):

- `test-*.log`: `test-ir`, `test-ir-lowering`, `test-ir-sroa`, `test-ir-inline`, `test-ir-simd`, `test-tier1-masks`, `test-tier1-pipeline --cross-check`, `test-x86-intrinsics`, `test-check-builtins-x86` and `test-check-builtins-vector` with the patch: no failures.
- `checker-driver-N.log`: `test-checker-driver --executable ./build/compiler --part N/8 --in-process` with the patch and its fixture. Parts 1, 6 and 7 have 4 failures each, the same checks that main's compiler fails there (`base-checker-driver-N.log`; `failures-N.txt` equals `base-failures-N.txt`). The desktop's clang is 23.1.5 and the tests' reference is 23.1.4.
- `before-test-checker-driver-4.log`: part 4 before the fixture was added, 14,422 checks; with it, 14,433.
- `commit-checker-driver-4.log`: part 4 again on the build of commit `32cdedc33` itself (sha256 `102b280c…`): 14,433 checks, no failures.
- `old-rule-checker-driver-4.log`: part 4 with the AVX-512 rule put back under the fixture. Its four frame checks fail: 800 bytes against 296 at x86-64 and 1,600 against 480 at x86-64-v3, by each path.
## Limitations

- The local numbers are from a desktop with other work on it; they name the effects and their sizes, and decide nothing. The 9700X's replace them.
- 8 KB arrays measure the loops' code. They say nothing about memory bandwidth, or about loops of a few iterations, where a vector loop's set-up and masked tail cost the most.
- `kernels_hand.c` is one person's vector code for 12 loops, at one width, without unrolling. It bounds what a vectorizer's output would run at through today's back end; it isn't a vectorizer.
- clang -O2 turns `copy_u8` and `fill_u32` into library calls or their inlined forms; those two compare a loop with a `memcpy`.
