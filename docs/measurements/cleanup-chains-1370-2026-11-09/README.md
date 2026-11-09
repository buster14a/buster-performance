# Cleanup chains (buster#1370, PR buster#1880), 2026-11-09

Each `__attribute__((cleanup))` call is emitted once, at its scope's end, and every exit jumps into that shared chain.
Before this change, every exit re-emitted all pending cleanup calls. Measured on benchpress (Ryzen 7 9700X), each run
under `~/buster-fast-bench/exclusive.sh`, pinned with `taskset -c 2`, by `time-runs` (whole processes, Williams order).

- `shapes.c` generates the inputs, `shapes SHAPE N`. The shapes are `returns`, `nested`, `loop` and `goto`: N cleanup
  variables, each followed by an exit. `none` is the `returns` shape without the attribute, code that must not change.
- `r2/` holds the current measurement: head `768a227099f2` against main `3279bd325`, both
  `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0`. Both were built in the session's container and copied to benchpress.
  `ab2.sh` ran all of them under one lock hold, 5 runs and 1 warm-up each.
- `first-head/` holds the first head `7ee3e5559263` against main `cb608c1f61`, both built on benchpress:
  - `sizes.tsv`: `.text` bytes and calls of every shape, N, build and tier;
  - timings by `run.sh` (11 runs) and `ab.sh` (5 runs).
  The first head still had quadratic check-program planning, visible at 2000–10000 (`time-*-head.txt`). The second
  head fixed it.

## Results (r2)

| input | main | head | wall | user cycles |
| --- | ---: | ---: | ---: | ---: |
| sqlite3.c `-c` | 115.620 ms | 115.355 ms | -0.23% | +0.00% |
| none, N=2000 | 6.351 ms | 6.077 ms | -4.32% | -2.44% |
| returns, N=85 | 1.452 ms | 1.018 ms | -29.89% | -46.30% |
| loop, N=40 | 1.217 ms | 0.940 ms | -22.75% | -32.46% |

Head only (main fails with "code output capacity exhausted" past 85 cleanups for `returns`, `nested` and `goto`, and
at 85 for `loop`):

| shape | N=400 | N=2000 | N=10000 |
| --- | ---: | ---: | ---: |
| returns | 2.777 ms (21.7 M instructions) | 8.490 ms (106.2 M) | 36.439 ms (528.8 M) |
| loop | 3.960 ms (31.5 M) | 11.709 ms (154.9 M) | 51.240 ms (773.1 M) |
| nested | | | 38.860 ms (587.0 M) |
| goto | | | 35.068 ms (501.6 M) |

The instruction counts grow linearly in N. Code size and calls of `g` (`first-head/sizes.tsv`; the second head's
lowering is the same): calls equal N on both tiers. At N=85, `returns` has 4,991 bytes and 85 calls on Tier 0, where
main had 61,533 bytes and 3,825 calls. Tier 1 refuses past about N=800 (`cause=cfg-allocation`). Main refuses the same
control flow written by hand with gotos; buster#1384 tracks it.

The objects of sqlite3.c (Tier 0 and `--tier1`), `main.c`, `c_lexer.c` and `x86_64_encoder.c` are byte-identical
between head and main. That was checked in the container: no cleanup there, no change.
