# Reader errors that still stop the unit, Buster #1447 (2026-11-09)

Base-vs-head `-fsyntax-only` timings on the Ryzen 7 9700X (`benchpress`) for the compiler PRs of #1447's
"reader errors that still stop the unit" package: [#1884](https://github.com/buster14a/buster/pull/1884)
(invalid declarations stay bound, their uses quiet), [#1891](https://github.com/buster14a/buster/pull/1891)
(tags defined in `_Atomic(...)` and `typeof(...)` specifiers) and [#1928](https://github.com/buster14a/buster/pull/1928)
(C23 redefinitions of an enum, stacked on #1884). #1905 (an enum's complex mode) changes only rejected units' paths
and was not timed.

## Sources and binaries

| Name | Source | Built | `compiler` SHA-256 |
|---|---|---|---|
| base | main `2c62bb2fb` | on benchpress, `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh` | `45ba008e…7eba1` |
| head | #1884 `c9ec41eb4` | same | `573fb540…bb70` |
| atomic | #1891 `e11ab7674` | same | `a04f9e3d…20ce` |
| atomic2 | #1891 `9030854` (the group scan out of line) | in a cloud container, same command, copied | `6d627a2e…a1b3` |
| enum | #1928 `5a9827c52` | on benchpress, same command | `ac4bef16…e1c3` |

Input: `sqlite3.c` (SHA-256 `b1dd5d74ec7f29055a6684fa06fb3c2f6821c87dd38f9a458dfd2e8a1db28189`, the frozen amalgamation
of `refine-claude/inputs`) and Buster's own `src/buster/compiler/main.c` at base, with
`-march=znver5 -I<base>/src -fwrapv -funsigned-char -fno-strict-aliasing`.

Host: clang 23.1.1, kernel 6.18.50-2-lts, CPU 2 (`taskset -c 2`), governor `performance`. Each build and each
`time-runs` invocation took the 9700X lock once (`exclusive.sh`); `run*.sh` and `measure4.sh` are the exact scripts.
`time-runs` interleaves the builds in a Williams design and reports wall time, user cycles and instructions.

## Results (medians)

| Comparison | Runs | sqlite3.c wall | sqlite3.c cycles | main.c wall | main.c cycles | File |
|---|---|---|---|---|---|---|
| head vs base | 21 | +0.17% | +0.10% | +0.01% | −0.07% | `times.txt` |
| atomic vs base | 21 | +0.71% | +0.11% | +0.46% | +0.54% | `times-atomic.txt` |
| atomic vs base | 11 | +0.39% | +0.14% | +0.32% | +0.36% | `times-atomic2.txt` |
| atomic2 vs base | 11 | +0.03% | −0.30% | +0.05% | +0.06% | `times-atomic2.txt` |
| enum vs head | 21 | −0.19% | −0.37% | +0.29% | +0.30% | `times-enum.txt` |

- #1884's cost is within noise (sqlite3.c instructions +0.05%).
- #1891's first form inlined the `_Atomic`/`typeof` group check into a hot always-inlined scan, which cost main.c
  0.3–0.5% (ranges apart in the 21-run set). The pushed form tests the stopping token's kind once and walks the groups
  out of line; it is within noise.
- `report-*.txt` are `perf report` of `instructions:u` samples (`-c 20000`) of sqlite3.c for base, atomic and atomic2.
- #1928's main.c difference comes with fewer instructions than #1884's head (26,640.24M against 26,640.96M); its
  new code runs only where an enumerator's name is already bound in its scope.

Limitations: one session's runs, 11 or 21 per build; benchpress was shared with other sessions' locked commands
between runs.
