# enable_if and diagnose_if in C overload resolution: `-fsyntax-only` base vs head (buster#2381)

The evidence behind [buster#2381](https://github.com/buster14a/buster/pull/2381) (buster#1447, package D3).

That PR changes the overload code (`c_check_overload*.c`) and the condition code (`c_check_condition*.c`). It adds a field to `CheckGraph` and a comparison in the overload index's compaction. sqlite3.c has no overload tables. main.c has overload tables but no conditions. Neither unit runs the new code beyond count tests.

- **Base:** buster `e43dfc1027368452a3e6b6c3f32e54faffae587a` (main, the PR's merge base).
- **Head:** buster `935cfd18f79c9a373724e236d48f9ecd3f6e85a0` (the PR's head when measured).
- **Host and command.** The Ryzen 7 9700X (`benchpress`), clang 23.1.1, Release `native` builds (`pr.sh`, digests in `pr-compilers.sha256`). One `time-runs` under `exclusive.sh`, pinned to CPU 2: 2 warm-ups, then 15 runs of each build per list in a Williams design's order. The raw output is in `times-pr.txt`.
- **Workloads:**
  - list 1: `-fsyntax-only` of the host corpus's `sqlite3.c`;
  - list 2: `-fsyntax-only -march=native -I… -fwrapv -funsigned-char -fno-strict-aliasing -Wall` of the head's `main.c`.

## Result

| | base | head | change |
|---|---|---|---|
| sqlite3.c median wall (ms) | 100.592 (98.960 to 103.048) | 101.503 (99.514 to 102.388) | +0.90% |
| sqlite3.c median user cycles (M) | 472.338 | 471.055 | -0.27% |
| sqlite3.c median instructions | 1,030,477,299 | 1,031,295,467 | +0.08% |
| main.c median wall (ms) | 618.519 (615.261 to 626.900) | 618.326 (615.114 to 624.045) | -0.03% |
| main.c median user cycles (M) | 3104.424 | 3103.000 | -0.05% |
| main.c median instructions | 9,220,693,486 | 9,226,325,652 | +0.06% |

The cycle counts are unchanged, and both wall-time changes fall inside both builds' run ranges.

The native builds' instruction counts rise slightly. sqlite3.c never reaches the new code, so I counted it exactly: callgrind (valgrind 3.22.0) on `-fsyntax-only` of the same `sqlite3.c`, run on both trees built with `BUSTER_HOST_ARCH=x86-64`. That build is the same checker logic on its scalar path, since valgrind can't run AVX-512. The counts were 2,122,196,287 instructions for base and 2,122,168,571 for head (-0.001%). The outputs are `callgrind-base.txt` and `callgrind-head.txt`, and the identities are in `callgrind-identities.sha256`. The work done is the same. The native builds' +0.08% therefore comes from how clang compiles the unity unit after the change (its inlining and register choices), not from added work, and it costs no cycles.

`perf.sh`, `perf-pr-base.txt` and `perf-pr-head.txt` are an `instructions:u` profile by symbol of each native build. Its sampling is too coarse to attribute a 0.08% difference; it is kept for completeness.

## Limitations

This covers one host, one session, one placement and 15 runs per build. The callgrind comparison was made on a cloud container (an Intel Xeon with AVX-512), not on the 9700X, with the baseline build.
