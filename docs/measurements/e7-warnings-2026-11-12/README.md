# E7 warnings PRs, base against heads, 2026-11-12

Base-against-head timings on the 9700X for the package E7 PRs in buster14a/buster that touch the `-fsyntax-only` path:

| PR | Issue | What it adds |
| --- | --- | --- |
| [#2472](https://github.com/buster14a/buster/pull/2472) | #2217 | `-Winteger-overflow`'s clang text; the reader's overflow events keep their result |
| [#2451](https://github.com/buster14a/buster/pull/2451) | #2218 | `-Wtautological-constant-out-of-range-compare`, on by default |
| [#2457](https://github.com/buster14a/buster/pull/2457) | #2409 | `-Wunused-but-set-variable`: the binding pass reads each use's operator |

## Host and method

- **Host:** Ryzen 7 9700X (`benchpress`), CPU 2 (`taskset -c 2`), clang 23.1.1.
- **Builds:** each tree is built with `BUSTER_HOST_ARCH=znver5 ./build.sh` (Release) under its own `exclusive.sh` hold (`build.sh`, `all.sh`).
- **Timing:** each run is one `exclusive.sh` hold around one `time-runs` (21 runs, 3 warm-ups, Williams order) that interleaves the builds. It times four command lists:
  1. `-fsyntax-only` on the pinned corpus's `sqlite3.c`;
  2. `-c` on `sqlite3.c`;
  3. `-fsyntax-only` on base's `src/buster/compiler/main.c`;
  4. `-c` on `main.c`.

## Trees

| Name | Revision |
| --- | --- |
| `base` | main `8c67a8d61825d3c28ab88d046cca0ad2d813abd2` |
| `h2217` | `f0f2688264af0df1a4d56a6b8c9acb6ad802d97a` |
| `h2218` in run 1 | `8dedcbc1daef9716747576706046b0a76739d062`: every comparison with one integer constant took the comparison walk |
| `h2218` in run 2 | `a9a5bcdd59b931fce17a39abff6b219aa2539167`: only those whose operand is narrower than the comparison's type, or a boolean |
| `h2409u` | `dd7857b3af28344ba874e7e3ebe8bc898e4e3f3f` |

## Results (medians of 21 runs)

Run 1 (`run1.txt`, `run.sh`): base against all three heads.

| List | Measure | base | h2217 | h2218 (first) | h2409u |
| --- | --- | ---: | ---: | ---: | ---: |
| 1 sqlite3.c `-fsyntax-only` | instructions | 1,034,789,272 | 1,034,786,984 (0.00%) | 1,046,405,422 (+1.12%) | 1,037,978,077 (+0.31%) |
| | user cycles (M) | 471.404 | +0.70% | +2.07% | +0.82% |
| | wall (ms) | 100.524 | +0.75% | +1.79% | +1.97% |
| 2 sqlite3.c `-c` | user cycles (M) | 588.118 | +0.12% | +1.63% | +0.52% |
| 3 main.c `-fsyntax-only` | instructions | 9,090,897,633 | +0.01% | +0.33% | +0.07% |
| | user cycles (M) | 3026.109 | +0.49% | +1.04% | +0.37% |
| 4 main.c `-c` | user cycles (M) | 3428.009 | +0.43% | +0.88% | +0.50% |

Run 2 (`run2.txt`, `run2.sh`): base against #2218's narrowed head.

| List | Measure | base | h2218 (narrowed) |
| --- | --- | ---: | ---: |
| 1 sqlite3.c `-fsyntax-only` | instructions | 1,034,789,269 | 1,040,365,631 (+0.54%) |
| | user cycles (M) | 472.196 | 476.104 (+0.83%) |
| | wall (ms) | 100.618 | 102.453 (+1.82%) |
| 2 sqlite3.c `-c` | user cycles (M) | 588.006 | 598.238 (+1.74%) |
| 3 main.c `-fsyntax-only` | instructions | 9,090,887,362 | 9,107,467,300 (+0.18%) |
| | user cycles (M) | 3026.865 | 3046.520 (+0.65%) |
| 4 main.c `-c` | user cycles (M) | 3426.981 | 3451.606 (+0.72%) |

## Reading

- **#2217:** instruction counts are flat (sqlite3.c's within 2,300 of base's); the cycle differences are within run-to-run spread.
- **#2409's `-Wunused-but-set-variable`:** +0.31% instructions on sqlite3.c and +0.07% on main.c, from reading each local's use's parent operator in the binding pass.
- **#2218:** the first head put every comparison with one integer constant on the common walk (+1.12% instructions on sqlite3.c). The narrowed head walks only a comparison whose other operand is narrower than the comparison's type or is a boolean, the only ones that can be out of range: +0.54% instructions on sqlite3.c and +0.18% on main.c. What remains is the reach scan's comparison operators and each one's candidate test, and the walks of the narrow candidates (sqlite3.c compares many `char`s with constants).
