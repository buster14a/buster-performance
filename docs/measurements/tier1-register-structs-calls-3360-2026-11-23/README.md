# #3360: Tier 1 register-class structs at call sites (#3311)

buster14a/buster#3360 passes a call's register-class struct arguments as their parts and takes a one-part result back
as the call's value (`ir_sroa_scalarize_calls`), and compiles inline candidates that pass aggregates by the whole
Tier 1 pipeline. Measured on benchpress (Ryzen 7 9700X), Release builds of both trees:

- base: buster `1b9821afe448258d08f47f6110922478aa0e4121` (main, the PR's merge base);
- fix: `cd395c23a3fe3eb4ef949d525358a7281dcead56` (the PR's head, with main merged and the part-width fix);
- clang: benchpress's host clang 23.1.1, `-O2`.

`build.sh`, `kernels.sh`, `compile.sh` and `all.sh` are the drivers; `build-*.log` the builds.

## Run time

The #3311 kernels (`i4.c`, `i2.c`, `l2.c`: `acc = addv(acc, d)` 100,000,000 times, `addv` noinline), each kernel's
timing one run under `exclusive.sh`, pinned with `taskset -c 2`, 11 rounds of the three binaries in turn (`time.sh`).
All builds print the same value (`outputs.txt`; the chain ran twice, hence the repeated lines). `perf stat`'s counters
were unavailable (empty columns); wall times only. `times-*.tsv`: binary, round, ms.

| struct | clang -O2 | `--tier1` base | `--tier1` fix | base ÷ fix |
| --- | ---: | ---: | ---: | ---: |
| `{ int x, y, z, w; }` | 109.5 | 134.9 | 109.2 | 1.24× |
| `{ int x, y; }` | 109.2 | 91.2 | 73.1 | 1.25× |
| `{ long x, y; }` | 73.1 | 120.2 | 73.4 | 1.64× |

Medians in ms; every binary's 11 runs within 1 ms of its median.

## Compile time

`time-runs --runs 21 --warmups 2` of `--tier1 -c sqlite3.c` (SQLite 3.53.4, sha256
`b1dd5d74ec7f29055a6684fa06fb3c2f6821c87dd38f9a458dfd2e8a1db28189`), both builds in a Williams order, the whole
`time-runs` under one `exclusive.sh` hold (`time-runs-sqlite.txt`):

| build | median wall ms (range) | user cycles | instructions | peak RSS KiB |
| --- | ---: | ---: | ---: | ---: |
| base | 197.130 (195.682 to 199.746) | 3,382,466,610 | 8,146,127,767 | 570,160 |
| fix | 198.026 (196.596 to 210.060) | 3,421,631,483 | 8,221,424,990 | 576,124 |

+0.45% wall, +1.2% user cycles, +0.92% instructions, +1.0% peak RSS: the call-site pass over every function with
calls, and the second (whole) pipeline for inline candidates that pass aggregates.

An earlier `ab` pass of the same command (`compile.sh`) only orders runs and records no timing; it is not kept.
