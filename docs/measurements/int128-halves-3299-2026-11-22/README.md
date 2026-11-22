# __int128 values in register halves (#3299), 2026-11-22

Ryzen 7 9700X (benchpress), Release builds, every run under `exclusive.sh`. Kernel: `chain.c` (the issue's
`t = f(t, i | 1)` with `f(a, b) = a * b + (a >> 3)`, 40 million calls). `bench.sh` builds the kernel with each tree's
compiler (Tier 0 and `--tier1`) and clang 23 at -O0 and -O2, and takes the best of 7 runs pinned to CPU 2.

- `run1-sroa-only.txt`: base (main 1f7ce98f) against the SROA step alone: Tier 1 77 -> 66 ms.
- `perf-stat-run1.txt`: cycles, instructions and store-to-load forwards per binary of run 1.
- `run2-final.txt`: base against the PR (SROA + direct result eightbyte loads): Tier 1 77 -> 58 ms (clang -O2 38,
  -O0 44); Tier 0 unchanged at 204 ms.
- `hand-variants.txt`: hand-edited assembly estimating the remaining pieces: direct call-argument loads (-4 ms) and
  add/adc for the carry (-5 ms).
