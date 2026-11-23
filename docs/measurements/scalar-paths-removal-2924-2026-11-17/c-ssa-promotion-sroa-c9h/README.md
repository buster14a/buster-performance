# Promotion and SROA (#2924, C9h)

Session `session_01Egbxng5eKny6uSFCaAo3ep`, 2026-11-23. Main at the measurement: `968a085f`.

## Promotion: a new dense vector constructor, then the twin deleted

The old vector constructor lost to Braun's scalar twin below 256 cells and past 16,384 ([c-ir-gate-again](../c-ir-gate-again/)).
The new constructor ([`measured-constructor.patch`](measured-constructor.patch), the PR's first commit before cleanups)
works a block's locals at a time: one pass over the accesses (renaming in-block reads), sparse frontiers, the pruned
phis of every local at once by bit rows, entry and exit rows in reverse postorder.

**Method:** Release builds of `968a085f` plus the patch and [`knob.patch`](knob.patch) (experiment only:
`BUSTER_SSA_PROMOTE_SCALAR=1` takes the twin; `BUSTER_SSA_PROMOTE_TICKS` appends a line per promoted function: blocks,
slots, instructions, TSC ticks). On the 9700X, CPU 2, one locked run ([`gate3.sh`](gate3.sh), [`one-hold2.sh`](one-hold2.sh)):
`--tier1 -c` of sqlite3.c, Lua 5.4.8 and musl's units on one lane, the default passes and `--tier1-passes=+all`, seven
rounds, the settings' order turning each round. [`compare.py`](compare.py) takes each function's median over the rounds
and sums by cells (blocks × slots). Raw ticks: [`ticks.tar.xz`](ticks.tar.xz) (`g3`: new vector `head-0` vs twin
`head-1`; `g4`: new vector vs main's promotion `base-0`). Comparisons: [`logs/compare.txt`](logs/compare.txt).

| New vector / twin | Total | 0-63 | 64-255 | 256-1,023 | 1,024-4,095 | 4,096-16,383 | 16,384-65,535 | 65,536+ |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| default (6,702) | 0.861 | 0.966 | 0.907 | 0.864 | 0.810 | 0.735 | 0.637 | 0.971 |
| `+all` (10,124) | 0.840 | 0.956 | 0.893 | 0.843 | 0.789 | 0.692 | 0.585 | 0.961 |
| vs main, default | 0.859 | 0.933 | 0.896 | 0.880 | 0.839 | 0.737 | 0.633 | 0.954 |
| vs main, `+all` | 0.842 | 0.920 | 0.883 | 0.866 | 0.823 | 0.701 | 0.583 | 0.944 |

Every round's total is on the same side (0.859-0.864, 0.839-0.842 against the twin). Functions past 65,536 cells take
the bounded construction in both settings, where only its rename differs: its vector arm stays. Objects: 1,371 of
1,371 byte-identical in every setting ([`logs/status.txt`](logs/status.txt)).

**#1353's case** ([`rss.sh`](rss.sh), one function of N for-loops, `--tier1 -c --time-stages`, peak RSS): main 45, 67,
164, 364 MB and head 70, 94, 166, 366 MB for N = 1,000 to 8,000. These functions are past the dense budget and take the
bounded construction in both; the gap at N ≤ 2,000 follows the huge-page state each run reported (`busy` against
`system`), not the code. The 2.53 GB of #1353 was gone on main already.

**Mutants** ([`mutation/`](mutation/), run locally against test-ssa, test-ssa-ir, test-ir-lowering and test-ssa-source
on c-testsuite and 24 generated programs): 18 of 18 killed; m05 (no entry row in placement) was equivalent (the entry
dominates every block, its frontier is empty) and the line went.

## SROA: its own twin, timed alone

[`sroa-knob.patch`](sroa-knob.patch) (experiment only): `BUSTER_IR_SROA_SCALAR=1` takes the uses scan's twin in
`ir_sroa_provenance` alone, the preparation and the DCE rewrite on the caller's path in both settings;
`BUSTER_IR_SROA_TICKS` a line per `ir_optimize_sroa` call. Same corpora and method ([`gate-sroa.sh`](gate-sroa.sh),
[`one-sroa.sh`](one-sroa.sh), [`compare-sroa.py`](compare-sroa.py), by instructions; ticks `s1`):

| Vector / twin | Total | 0-63 | 64-255 | 256-1,023 | 1,024-4,095 | 4,096-16,383 | 16,384+ |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| default (419 calls) | 0.961 | 0.982 | 0.970 | 0.964 | 0.950 | — | 0.953 |
| `+all` (6,763) | 0.949 | 0.976 | 0.954 | 0.945 | 0.942 | 0.941 | 0.949 |

Every round below 1; objects identical. The C9 gate's 0.94 at 1,024+ entries was the optimizer's DCE twin, which
toggled with SROA's flag (C9g's area).
