# Tier 1 on array loops: the kernels, the harness and the numbers (buster#2743, 2026-11-14)

This is the evidence for [buster#2743](https://github.com/buster14a/buster/issues/2743): what `--tier1` makes of loops over arrays, beside clang and gcc, and what its back end makes of the same loops once they are written with vector operations. By Droid in David's directed session (Factory Droid session `5d5f629c-b881-4d75-9267-35567e982c31`, model Fable 5.2 as Droid reports it), from the claim in [comment 6878234250](https://github.com/buster14a/buster/issues/2743#issuecomment-6878234250).

**Status of this record:** the sources, the scripts and the local runs are here. The 9700X's runs (`scripts/9700x/measure.sh x86-64 znver5`) are added under `9700x/` when they end; until a `9700x/` directory is here, every number below is from the session's desktop and is preliminary.

## Revisions and toolchains

| Role | Value |
| --- | --- |
| buster | main `c471f32f0136bbb21cfe083c9947f86346de2a0a` |
| local host | Ryzen 9 7940HS (Zen 4), Linux 7.3.4-1-cachyos, clang 23.1.5, gcc 16.2.1 (`local/host.txt`) |
| local compiler | `./build.sh` (Develop) at that commit, sha256 `9b50780a…` |

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

## Local results (Zen 4, preliminary)

`local/x86-64/run1.txt` (12 builds), `local/x86-64/pad-*.txt` (two builds at four placements, with `p*-*.loops`), `local/znver4/run1.txt` (four builds); `tables.md` beside each is `tables.py`'s output. The runs weren't pinned and the desktop wasn't idle.

- **Correctness:** every build gives the same digest on every kernel, at both targets. `--tier1-report` said Tier 1 compiled all 25 functions of `kernels.c` and all 85 of `kernels_hand.c` (its inlined intrinsics included), with no fallback.
- **`-march=x86-64`:** `--tier1` over clang -O2 has a geometric mean of 4.0 on the 19 loops clang vectorizes and 1.14 on the 6 controls.
- **`-march=znver4`:** 11.7 on the 19 and 1.36 on the controls.
- **By cause, x86-64:** `--tier1` over clang's scalar loops that aren't unrolled is 1.28 on the 19 (1.25 with each at its best placement). The rest of the 4.0 is unrolling and vectorization.
- **Placement:** a loop that runs one iteration a cycle runs at half that when it lies across a 64-byte line: `sum_i32` 0.421 ns against 0.212, `copy_u8` 0.421 against 0.211, `find_u8` 0.421 against 0.209. clang's loops that aren't unrolled lose the same when they are pushed across a line (`saxpy_f32`, `scale_u8`, `i32_to_f32` 2.0). So it is the processor's, not either compiler's; whether Zen 5 has it is what the 9700X's four placements answer.
- **The back end on vector code, znver4:** `--tier1` on `kernels_hand.c` is 13 times faster than on the C loops (geometric mean of the 12), 0.94 of clang -O2's own vectorization of the C loops, and 1.10 of clang -O2 on the same vector source.

## Limitations

- The local numbers are from a desktop with other work on it; they name the effects and their sizes, and decide nothing. The 9700X's replace them.
- 8 KB arrays measure the loops' code. They say nothing about memory bandwidth, or about loops of a few iterations, where a vector loop's set-up and masked tail cost the most.
- `kernels_hand.c` is one person's vector code for 12 loops, at one width, without unrolling. It bounds what a vectorizer's output would run at through today's back end; it isn't a vectorizer.
- clang -O2 turns `copy_u8` and `fill_u32` into library calls or their inlined forms; those two compare a loop with a `memcpy`.
