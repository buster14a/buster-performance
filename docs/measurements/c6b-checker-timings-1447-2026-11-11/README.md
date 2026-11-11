# C6b's merged checker changes: `-fsyntax-only` base vs head (buster#1447, package D3)

Package C6b merged seven checker PRs on 2026-11-11 without 9700X timings. This record measures each against its own parent: [#2241](https://github.com/buster14a/buster/pull/2241), [#2243](https://github.com/buster14a/buster/pull/2243), [#2249](https://github.com/buster14a/buster/pull/2249), [#2267](https://github.com/buster14a/buster/pull/2267), [#2272](https://github.com/buster14a/buster/pull/2272), [#2277](https://github.com/buster14a/buster/pull/2277) and [#2280](https://github.com/buster14a/buster/pull/2280).

- **Pairs.** For each PR, "head" is its merge commit on main and "base" is that commit's first parent (`prs.txt`; `run.log` lists the commits). Measuring each against its own parent keeps the other packages' PRs, merged in between, out of each comparison.
- **Host.** The Ryzen 7 9700X (`benchpress`) with clang 23.1.1 (`host.txt`). Each tree was built with `./build.sh` (Release, `native`), one build per lock hold (`setup.sh`). The executables' SHA-256 digests are in `compilers.sha256`.
- **Workloads.** Two lists, with the inputs' digests in `inputs.sha256`:
  - list 1: `-fsyntax-only` of the host corpus's `sqlite3.c`;
  - list 2: `-fsyntax-only -march=native -I… -fwrapv -funsigned-char -fno-strict-aliasing -Wall` of `main.c`, the same source (the #2280 merge's tree) for every pair.
- **Command.** `run.sh` runs one `time-runs` per PR under `exclusive.sh`, pinned to CPU 2: 2 warm-ups, then 15 runs of each build per list in a Williams design's order. The raw output is in `times-PR.txt`.

## Result

Median wall time (ms), base → head, and the change in median instructions:

| PR | sqlite3.c wall | sqlite3.c instructions | main.c wall | main.c instructions |
|---|---|---|---|---|
| #2241 | 96.312 → 96.802 (+0.51%) | -0.0009% | 607.936 → 610.167 (+0.37%) | +0.0036% |
| #2243 | 96.594 → 96.669 (+0.08%) | +0.0007% | 607.080 → 610.106 (+0.50%) | +0.0004% |
| #2249 | 97.824 → 97.885 (+0.06%) | +0.0032% | 613.201 → 610.919 (-0.37%) | +0.0021% |
| #2267 | 97.320 → 97.230 (-0.09%) | -0.0008% | 609.798 → 610.939 (+0.19%) | -0.0024% |
| #2272 | 97.052 → 96.859 (-0.20%) | +0.0017% | 606.002 → 608.097 (+0.35%) | +0.0022% |
| #2277 | 97.453 → 97.628 (+0.18%) | -0.0000% | 610.386 → 612.691 (+0.38%) | -0.0001% |
| #2280 | 98.329 → 98.597 (+0.27%) | -0.0006% | 613.198 → 614.920 (+0.28%) | +0.0003% |

No PR changes the work done: every instruction count moves by less than 0.004%. Every wall-time change falls inside both builds' own run ranges (in `times-PR.txt`).

On main.c the head's median is slightly higher in six of the seven pairs. Two checks address that:

- **A/A control** (`control.sh`, `control-2243.txt`, `control-2280.txt`). Each listed the base build twice, base, head, base again, in one design. For #2243, head was +0.52% and base-again -0.06%, with instructions equal to 0.0004%. For #2280, head was +0.37% and base-again +0.23%.
- **Placements** (`layout.sh`, `layout-2243.txt`). #2243 was built at three placements of the checker's code (`BUSTER_CHECKER_OFFSET` 0, 1024 and 2048, #1233) and compared over them.

Over the three placements, #2243's main.c wall time is **+0.06%** against base, with a range of −0.44% to +0.35%; user cycles are +0.09%. The earlier +0.5% was one placement's effect, not added work. Within each build, the three placements' medians spread by 0.3% to 0.5%. On sqlite3.c, the wall median is +1.04%, but one placement drives it (+2.04%, against −0.20% for another). User cycles are −0.13% and the instruction count is unchanged, so this is noise in the wall time, not work. The placements' digests are in `layout-compilers.sha256`.

## Conclusion

None of the seven PRs regresses `-fsyntax-only` of sqlite3.c or main.c. No issue was filed.

## Limitations

This covers one host, one session, two workloads and 15 runs per build. The placement study covers #2243 only, the pair with the largest main.c change on rerun.
