# Multi-declarator ancestor climbs (buster#1378), 9700X qualification

The post-fix scaling campaign that [buster#1378](https://github.com/buster14a/buster/issues/1378) left open after
[buster#1591](https://github.com/buster14a/buster/pull/1591) merged.

## Builds

All Release, `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh`, on benchpress (Ryzen 7 9700X, governor
`performance`, clang 23.1.1), each build under the 9700X lock. Clean checkouts; identities in `9700x/identity.txt`.

| Name | Commit | What |
| --- | --- | --- |
| base | `a6e1f20fc10d13198e1f6f807e74ce0d261b8262` | #1591's merge's first parent (before the fix) |
| fix | `21150b297538dcea56d05d542f885e31201742fa` | #1591's merge |
| main | `b7a95eedbe16fbd8434654f192f8f7aab76c56e5` | main on 2026-11-13 |

## Method

`9700x/measure.sh` generates the inputs (`9700x/inputs/`): the issue's local shape
`int g(int x) { int a0 = x, …; return a0 + a<N-1>; }` and a file-scope shape `int a0 = 0, …;` plus a function using the
first and last, at N = 64, 4,000, 8,000, 16,000, and a two-declarator `small.c`. Seven rounds; each round is one lock
hold that runs every build on every input once, interleaved, pinned with `taskset -c 2`:
`compiler -c --time-stages -o out/obj.o INPUT`. Wall is bash `$EPOCHREALTIME` around the process. `9700x/summarize.sh`
takes medians of the seven runs; every run exited 0. Raw outputs are in `9700x/out/` (`BUILD.INPUT.ROUND`).
The rounds' lock-wait messages (other sessions' commands) are not published.

## Results (medians, ms)

| Input | base wall | fix wall | main wall | base check-input | main check-input | base check-program | main check-program |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| small | 1.86 | 1.70 | 1.54 | 0.11 | 0.13 | 0.03 | 0.07 |
| file 64 | 1.70 | 1.59 | 1.46 | 0.17 | 0.13 | 0.04 | 0.06 |
| local 64 | 1.61 | 1.43 | 1.35 | 0.12 | 0.12 | 0.04 | 0.06 |
| file 4,000 | 11.85 | 4.62 | 4.56 | 1.09 | 1.14 | 7.68 | 0.32 |
| local 4,000 | 38.59 | 4.43 | 4.19 | 8.41 | 1.23 | 7.70 | 0.41 |
| file 8,000 | 36.68 | 7.75 | 7.79 | 1.86 | 2.17 | 29.70 | 0.55 |
| local 8,000 | 73.72 | 7.54 | 7.62 | 31.32 | 2.38 | 29.73 | 0.78 |
| file 16,000 | 129.49 | 13.89 | 13.95 | 3.91 | 4.28 | 117.00 | 1.03 |
| local 16,000 | 259.02 | 13.25 | 13.64 | 120.57 | 4.87 | 116.92 | 1.50 |

`9700x/summary.txt` has every build's row, including `fix`'s stages and `time-stage total`.

- base reproduces the issue (local 16,000: 259 ms against the issue's 252.8 ms; each doubling ×3.5–4 in both stages).
- After the fix both stages grow ×1.8–2.2 per doubling: linear. Local 16,000 is 19× faster (259.0 → 13.6 ms) and
  below clang 23.1.1 `-fsyntax-only`'s 38.0 ms from the issue.
- Small units: no regression from the fix; base → fix is 0.1–0.2 ms faster on all three (other changes on the
  range are not separated; this campaign only bounds the fix's small-unit cost from above).

## Limitations

Seven runs per cell, one CPU; no perf counters. main's changes since the fix are not attributed.
