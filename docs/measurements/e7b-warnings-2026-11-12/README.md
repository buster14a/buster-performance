# E7b warning PRs, base against heads, 2026-11-12

Base-against-head timings on the 9700X for package E7b's warning PRs in buster14a/buster (round E of #1447).

| PR | Issue | What it adds | Tree | Log |
| --- | --- | --- | --- | --- |
| [#2489](https://github.com/buster14a/buster/pull/2489) | #2264 | `-Wshift-sign-overflow` | `h2264s`, `943110bc10a8e45497293ad63cf58b46328ee685` | [run-2264s.log](run-2264s.log) |
| [#2496](https://github.com/buster14a/buster/pull/2496) | #2264 | `-Wassign-enum` | `h2264e`, `e41c87d451c42f350f04597443c388645a01b46e` | [run-2264e.log](run-2264e.log) |

Both heads branch from main `a221f633246aeb99bf5c33d27cee76b719e4a4a7`, the `base` tree. Both warnings are off by default, so the timed commands run their code only as far as the check that skips them.

## Host and method

- **Host:** Ryzen 7 9700X (`benchpress`), CPU 2 (`taskset -c 2`).
- **Builds:** `setup.sh NAME REVISION` clones and checks out a tree. `build.sh NAME` builds it with `BUSTER_HOST_ARCH=znver5 ./build.sh` (Release) under its own `exclusive.sh` hold.
- **Timing:** `run.sh BASE HEAD LINK` builds both trees, then runs one `time-runs` comparison under a single `exclusive.sh` hold: 21 runs and 3 warm-ups per build, interleaved. It times four command lists:
  1. `-fsyntax-only` of `sqlite3.c`, copied from `~/buster-fast-bench/frontend-baseline-claude/baseline/sqlite3.c`;
  2. `-c -o /dev/null` of `sqlite3.c`;
  3. `-fsyntax-only` of the base tree's `src/buster/compiler/main.c`, with clang's predefines;
  4. `-c -o /dev/null` of that `main.c`.

## Results (medians of 21 runs)

| List | base instructions | #2489 | #2496 |
| --- | --- | --- | --- |
| 1, `-fsyntax-only` sqlite3.c | 1,041,950,007 | +0.033% | −0.008% |
| 2, `-c` sqlite3.c | 1,326,634,578 | +0.026% | −0.006% |
| 3, `-fsyntax-only` main.c | 9,136,786,897 | +0.049% | +0.012% |
| 4, `-c` main.c | 10,446,726,220 | +0.043% | +0.011% |

| List | #2489 wall / user cycles | #2496 wall |
| --- | --- | --- |
| 1 | +0.55% / +0.33% | +0.91% |
| 2 | +0.29% / +0.33% | +0.07% |
| 3 | +0.14% / +0.11% | +0.25% |
| 4 | +0.33% / +0.10% | +0.23% |

The wall-time medians differ by less than each list's run-to-run range (in the logs). For #2489, the instruction delta is the constant reader's added `CHECK_OP_SHIFT_LEFT` test, which hands off to an out-of-line hook. #2496 adds nothing to a unit's work unless the warning is enabled.
