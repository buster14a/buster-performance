# buster#2451's cost, base against heads, 2026-11-12

[buster#2451](https://github.com/buster14a/buster/pull/2451) gives clang's `-Wtautological-constant-out-of-range-compare`,
which is on by default. The owner held it until it costs nothing measurable. E7's version measured +0.83% to +1.74% of
cycles and +0.62% to +2.0% of wall time (buster-performance#430). These runs trace package E7b's rework to the final head.

## Host and method

- **Host:** Ryzen 7 9700X (`benchpress`), CPU 2 (`taskset -c 2`). The builds' compiler is clang version 23.1.1.
- **Trees:** `setup.sh NAME REVISION` clones and checks out a tree. `build.sh NAME` builds it with `BUSTER_HOST_ARCH=znver5 ./build.sh` (Release), under its own `exclusive.sh` hold.
- **Base:** `base91`, main `91a87ab25a43eddf714c3120eb5aeb5725533cad`, which each head merges.
- **Head:** `h2451`, the branch `e7/2218-out-of-range`, checked out again before each run (revisions below).
- **Each comparison:** one `time-runs` call (interleaved, 3 warm-ups) under a single `exclusive.sh` hold. The scripts:
  - `run.sh`: base and head, 21 runs. It times `-fsyntax-only` and `-c` of `sqlite3.c` and `main.c`.
  - `run3.sh`: base, an identical copy of base's binary (the noise floor) and head, 21 runs. It times sqlite3.c, each with the warning on and off (`-Wno-tautological-constant-out-of-range-compare`).
  - `run4.sh`: base, its copy and head, 21 runs. It times all four lists.
  - `run5.sh`: `run4.sh` with 41 runs.
- **`stat.sh`** gives `perf stat -e instructions:u` of `-fsyntax-only` for main.c and sqlite3.c, three runs each, with the warning on and off. Its output was read from the console, not kept, and its figures are quoted below.

## Runs

| Log | Head | What changed |
| --- | --- | --- |
| [run-2451a.log](run-2451a.log) | `7564aad4` | The candidate test decides the out-of-range verdict, and comparisons leave the reach scan's operator set for a 16-node pass of their own |
| [run-2451b.log](run-2451b.log) | `013f2dde` | The vector test also rejects an int or long builtin that covers the constant's type |
| [run-2451c.log](run-2451c.log) | `08a664fa` | The candidates' tests share one type query per operand, and the pass rides the reach scan's own blocks |
| [run-2451d.log](run-2451d.log) | `71c0a757` | The vector test also rejects a narrow builtin's in-range int constant (its payload value gathered) |
| [run-2451e.log](run-2451e.log) | `71c0a757` | `run3.sh`: the noise floor, warning on and off |
| [run-2451f.log](run-2451f.log) | `a07ea8ec` | `run3.sh`: comparisons compressed into a list and tested in full batches of 16 |
| [run-2451g.log](run-2451g.log) | `a07ea8ec` | `run4.sh`: main.c's batches, tested after the whole scan, find its columns cold |
| [run-2451h.log](run-2451h.log) | `592e90cc` | `run4.sh`: each batch tested as soon as 16 comparisons are listed |
| [run-2451i.log](run-2451i.log) | `592e90cc` | `run5.sh`, 41 runs: the final code |

The PR's final head, `0e1f0a63`, is `592e90cc` with main `4c8c3c9c` merged in and the warning renumbered. The warning's code is unchanged.

## Final result (run-2451i.log, 41 runs, against base91)

| List | base91-copy wall | head wall | base91-copy cycles | head cycles | head instructions |
| --- | --- | --- | --- | --- | --- |
| 1, `-fsyntax-only` sqlite3.c | −0.57% | −0.39% | −0.20% | +0.34% | +0.109% |
| 2, `-c` sqlite3.c | +0.08% | +0.28% | +0.14% | +0.25% | +0.085% |
| 3, `-fsyntax-only` main.c | +0.26% | +0.23% | +0.17% | +0.17% | +0.037% |
| 4, `-c` main.c | +0.11% | +0.24% | +0.09% | +0.30% | +0.033% |

An identical binary moves −0.57% to +0.26% in wall time, and −0.20% to +0.17% in cycles. In earlier runs (e to h) it moved up to +0.67% in wall time and +0.47% in cycles. The head's medians fall within that spread.

With the warning off, `stat.sh` gave the head within 0.03% of base's instructions on both files. Its differences between builds (about ±1.5M instructions) follow code placement in the checker's unity unit, not work.

## What the cost was

On main.c (1.38M graph nodes, 26K comparisons) and sqlite3.c (317K nodes, 10.9K comparisons), counted with temporary instrumentation:

1. **Every comparison stopped the reach scan, and every narrow operand compared with a constant started a walk.** These were 9K and 3.3K comparisons, and none was out of range. Deciding the verdict before the walk (a) removed the walks.
2. **The scalar test cost about 700 instructions a comparison, from repeated type queries.** One query per operand (c) and two vector rejections (b, d) cut the comparisons that take it.
3. **Per-block gathers did a lane or two of work each.** sqlite3.c has about 1.3 comparisons per 16-node block, which cost +0.57% of its cycles (e). Full batches of 16 (f) fixed sqlite3.c.
4. **Batches tested after the scan found main.c's columns cold.** That showed as +1.11% of cycles on +0.03% of instructions (g). Testing each batch as it fills (h, i) fixed it.
