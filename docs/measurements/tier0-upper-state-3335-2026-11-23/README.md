# Tier 0's upper vector state (#3335), 2026-11-23

[buster14a/buster#3335](https://github.com/buster14a/buster/issues/3335): Tier 0 puts a `vzeroupper` before
calls and before the epilogue's (and musttail calls') teardown where its code names ymm0–15/zmm0–15, and rewrites
its legacy SSE records as their VEX twins at an AVX target. Measured on benchpress (Ryzen 7 9700X), CPU 2, each
step under its own hold of the host lock (`~/buster-fast-bench/exclusive.sh`), from Release builds in
`/tmp/3335-claude` (`setup.sh`).

- **base**: `3732541e` (#3347's branch at `1c0e6d81`, merged with main): Tier 1 has #2830's change, Tier 0 not.
- **mine**: `752b41e7` (#3335's first commit on top of base) for the kernel and compile-time runs; `f5554a24` for
  the Zen 5 rows (same Tier 0 code plus the two `U` rows).

## Kernel (`kernel.c`, `driver.c`, `run2.sh`, `9700x/kernel.log`)

`kernel.c` is compiled by each build's Tier 0 at `-march=znver5` (`-ffp-contract` on and off; the assembly is in
`9700x/k-*.s`); `driver.c` (clang -O2) calls, 2000 times per round, `saxpy` over 1024 floats alone (`clean`), after
the issue's `sum16` (`dirty`), or after `add16`, a 512-bit add that returns with zmm0 and zmm1 still wide
(`wide`). ns per element, median of 31 rounds, three repetitions:

| mode | contract | base | mine | base / mine |
| --- | --- | ---: | ---: | ---: |
| clean | on | 0.547 | 0.547 | 1.00 |
| dirty (`sum16`) | on | 0.551 | 0.550 | 1.00 |
| wide (`add16`) | on | 1.127 | 0.549 | 2.05 |
| clean | off | 0.547 | 0.547 | 1.00 |
| dirty (`sum16`) | off | 0.550 | 0.550 | 1.00 |
| wide (`add16`) | off | 1.476 | 0.548 | 2.69 |

`sum16` narrows each register it widened back to xmm (an EVEX write zeroes the bits above) before it returns, so
its missing `vzeroupper` leaves no register the scalar code merges into with wide contents; `add16` does. Base's
saxpy then waits on the wide registers' old values (its legacy `movaps`/`movss`/`mulss`/`addss`); mine's
`vzeroupper` before `add16`'s ret and its VEX forms remove that. An earlier pass (`run.sh`, clean and dirty
only, its log overwritten by `run2.sh`'s) gave the same clean/dirty equality at 0.727–0.729 ns.

## Compile time (`run.sh`, `9700x/sqlite-time.log`)

`-c` of the frozen corpus's `sqlite3.c` (`/var/lib/buster-9700x/corpora/preprocessor-391e729af658`) at
`-march=znver5` by Tier 0, `time-runs --runs 21 --warmups 2`, alternating builds:

| | base | mine | mine / base |
| --- | ---: | ---: | ---: |
| wall (ms, median) | 115.600 | 115.902 | +0.26% |
| user cycles (M, median) | 561.422 | 562.810 | +0.25% |
| instructions (M, median) | 1281.85 | 1283.10 | +0.10% |

The wall-time spread is 114.9–139.6 ms (base) and 115.0–118.4 ms (mine). The objects differ (the VEX forms);
both builds compile it without error (`9700x/sqlite-objects.log`).

## Zen 5 rows (`run3.sh`, `9700x/zen5-missing.txt`)

`measure-x86-zen5 --missing --table` at `f5554a24` measured `VMOVHPS_X_X_M64`'s two rows (MEMORY, MEMORY_INDEX),
the VEX twin of the `movhps` in Tier 0's halves copies. They equal the legacy `MOVHPS_X_M64` rows.

`9700x/runs.log` has the build lines; each log has `ps` and `/proc/loadavg` before and after its hold.
