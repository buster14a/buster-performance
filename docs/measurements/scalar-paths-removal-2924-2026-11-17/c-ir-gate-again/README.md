# The IR's gate again (#2924, C9): C9b's tree `0532ae28d`

## Why again

The [C9 gate](../c-ir-gate/) (main `45f3f8561`) timed each IR area's region with its twin. Two confounds were inside
those regions:
- **The verifier's scalar twin.** The lowering verified its output with its own flag (`ir_lower.c:3431` at
  `45f3f8561`), and each optimizer pass's preparation verified with the pass's flag (`ir_optimize_prepare`).
- **The scan for vector values' scalar twin**, in promotion's region.

C9a (#2981) and C9b (#2982) leave the verifier and the lowering with one path each. An area's region now holds its own
twin alone, so every area was measured again.

## Method

Every run uses one Release executable, built from `0532ae28d` plus an experiment-only knob. The lowering's run instead
uses C9b's tests commit `7af2036db`, which still has both lowerings. The runs are on the 9700X, under the lock, on
CPU 2:
- `--tier1 -c` of sqlite3.c, Lua 5.4.8 and musl's units, on one lane ([`objects.sh`](objects.sh));
- the default passes and `--tier1-passes=+all`;
- five rounds in turn, with TSC ticks per function in the area's region.

[`compare.py`](compare.py), [`compare-areas.py`](compare-areas.py) and [`compare-lower.py`](compare-lower.py) take each
function's median over the rounds and sum by size. Their outputs are in [`logs/compare/`](logs/compare/).

**Objects:** in every setting of every run, 1,371 of 1,371 objects are byte-identical to the default's.

| Run | Script | Knob | Settings | Ticks |
| --- | --- | --- | --- | --- |
| Promotion | [`pipeline.sh`](pipeline.sh) | [`c9c-knob2.patch`](c9c-knob2.patch) | AUTO; the twin (`BUSTER_SSA_PROMOTE_SCALAR=1`); the vector path past its 16,384-cell bound (`BUSTER_SSA_FORCE_VECTOR=1`) | [`ticks-promote.tar.xz`](ticks-promote.tar.xz) |
| The verified optimizer's passes | [`optimize.sh`](optimize.sh) | [`c9c-knob3.patch`](c9c-knob3.patch) | AUTO; vector passes at every size (`BUSTER_IR_OPTIMIZE_FORCE=1`); scalar passes (`=2`) | [`ticks-optimize.tar.xz`](ticks-optimize.tar.xz) |
| Every other area, each bit alone against none | [`areas.sh`](areas.sh) | [`c9-areas-knob.patch`](c9-areas-knob.patch) (the C9 gate's `knob.patch`, adapted) | `BUSTER_IR_SCALAR_AREAS` | [`ticks-areas.tar.xz`](ticks-areas.tar.xz) |
| The lowering, on `7af2036db` | [`lower.sh`](lower.sh) | [`c9b-lower-knob.patch`](c9b-lower-knob.patch) | `BUSTER_IR_LOWER_SCALAR=1` | [`ticks-lower.tar.xz`](ticks-lower.tar.xz) |

**Controls:** the same code under another area's bit (promotion's and the optimizer's regions under each bit) reads
0.996 to 1.002. The vector path forced below promotion's bound, which is the same code as AUTO there, reads 0.9998 to
1.0011 by bin.

## Verdicts

Each ratio is the twin's ticks over the vector path's: above 1, the vector path wins. Sizes are Tier 0 entries.

| Area | Configuration | Total | 0-15 | 16-63 | 64-255 | 256-1,023 | 1,024+ | Verdict |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| Lowering (`7af2036db`) | default | 1.035 | 1.014 | 1.025 | 1.036 | 1.045 | 1.051 | passes |
| Lowering (`7af2036db`) | `+all` | 1.034 | 1.014 | 1.025 | 1.035 | 1.046 | 1.050 | passes |
| Inliner | default | 1.096 | 1.058 | 1.119 | 1.119 | 1.139 | 1.078 | passes |
| Inliner | `+all` | 1.030 | 1.022 | 1.028 | 1.035 | 1.028 | 1.031 | passes |
| **Value numbering** (vectors) | default | **0.885** | 0.931 | 0.901 | 0.893 | 0.893 | 0.883 | loses in every bin (32 functions) |
| **Value numbering** | `+all` | **0.875** | 0.904 | 0.889 | 0.874 | 0.868 | 0.869 | loses in every bin |
| **SROA** | `+all` | 1.004 | 1.020 | 1.029 | 1.023 | 1.002 | **0.942** | loses at 1,024+ (54 functions) |
| Wide and vector splits | default | 2.557 | 1.439 | 1.818 | 2.392 | 4.250 | 8.587 | passes |
| Wide and vector splits | `+all` | 2.305 | 1.523 | 1.810 | 2.138 | 3.300 | 5.471 | passes |
| Truth simplification, threading, if-conversion | default | 1.109 | 1.189 | 1.136 | 1.128 | 1.107 | 1.074 | passes |
| Truth simplification, threading, if-conversion | `+all` | 1.131 | 1.160 | 1.142 | 1.139 | 1.128 | 1.112 | passes |
| **LICM** (vectors) | default | 1.002 | 0.957 | 0.989 | 1.004 | 1.005 | 1.002 | parity (32 functions) |
| **LICM** | `+all` | 0.997 | 1.006 | 1.001 | 0.998 | 0.995 | 0.992 | parity |
| Loop vectorizer | `+all` | 1.113 | 1.079 | 1.068 | 1.081 | 1.129 | 1.217 | passes |
| Unroller | `+all` | 1.069 | 1.125 | 1.081 | 1.070 | 1.074 | 1.054 | passes |
| Operand sink | default | 2.428 | 2.386 | 2.514 | 2.573 | 2.557 | 2.101 | passes |
| Operand sink | `+all` | 2.498 | 2.404 | 2.509 | 2.517 | 2.502 | 2.484 | passes |

In every row, each round's own total lies on the same side of 1 as the median total, with two exceptions: SROA's
fifth round (1.0000) and LICM's first under the default passes (0.9992). LICM's rounds read 0.999 to 1.006 (default)
and 0.996 to 0.998 (`+all`) ([`logs/compare/`](logs/compare/)).

### Promotion, by cells (blocks × slots)

This is the twin's ticks over AUTO's. AUTO is the vector constructor up to 16,384 cells and Braun's scalar construction
past them. The last two bins run the same code in both.

| Configuration | Total | 0-63 | 64-255 | 256-1,023 | 1,024-4,095 | 4,096-16,383 | 16,384-65,535 | 65,536+ |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| default (6,518 promotions) | 0.998 | **0.961** | **0.984** | 1.017 | 1.037 | 1.009 | 0.993 | 0.993 |
| `+all` (10,124 promotions) | 1.004 | **0.960** | **0.989** | 1.028 | 1.047 | 1.022 | 0.999 | 0.990 |

Under 64 cells there are 4,072 and 6,484 promotions, about a fifth of the region's ticks.

**The vector constructor past its bound**, its ticks over AUTO's: 1.058 (default) and 1.072 (`+all`) at 16,384 to
65,535 cells; 1.023 and 1.027 past that.

**Where the vector constructor's time goes** ([`profile.sh`](profile.sh): `benchmark-ir-source --only promote` on
sqlite3.c, perf by source line, [`logs/annotate-vector.txt`](logs/annotate-vector.txt)). Of the constructor's samples:
- 28% are in renaming. Most of that is its two scalar passes over every instruction, which counting-sort the accesses
  by (block, slot) (`ssa.c:934`, `:952`).
- 11% are in phi placement, one slot at a time over every block.
- 9% are in pointer jumping, which is scalar above 64 blocks.
- 3% are in entry definitions.

Braun's construction pays instead in simplifying its trivial phis: `ssa_simplify` is 9.7% of the twin's run against
4.0% of the vector path's ([`logs/perf-promote*.txt`](logs/)).

### The verified optimizer's passes, by IR instructions

AUTO runs the scalar passes below 8,192 instructions (#860), so no compile runs the vector passes. AUTO equals the
scalar passes under the default passes (0.9995 total). Under `+all`, AUTO keeps the memory pass's vector path.

The first table is the vector passes forced, their ticks over the scalar passes'. Above 1, the vector passes lose.

| Configuration | Total | 0-31 | 32-127 | 128-511 | 512-2,047 | 2,048-8,191 | 8,192+ |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| default | 1.155 | 1.017 | 1.043 | 1.080 | 1.169 | 1.260 | 1.445 |
| `+all` | 1.049 | 0.956 | 0.973 | 1.006 | 1.082 | 1.159 | 1.217 |

The second table isolates the memory pass under `+all`. AUTO's ticks over the scalar passes' measure the memory pass's
vector path against its twin, the other passes being scalar in both. Below 1, its vector path wins.

| Configuration | Total | 0-31 | 32-127 | 128-511 | 512-2,047 | 2,048-8,191 | 8,192+ |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `+all` | 0.952 | 0.960 | 0.953 | 0.949 | 0.951 | 0.957 | 0.960 |

## Warm loops favor the twins

[`gate.sh`](gate.sh) times each function's promotion and optimizer alone, repeated until a sample takes 0.5 ms
(`benchmark-ir-source --functions`, [`logs/compare/functions-*.txt`](logs/compare/)). There the vector promotion reads
1.012 (sqlite3.c) and 1.043 (Lua) of the twin's time in total, and loses in most bins. In the pipeline it reads 0.998
and 1.004. A function repeated thousands of times teaches the predictor the twin's branches.
`benchmark-ir-source --only promote` over the whole corpus reads in between ([`logs/only-*.log`](logs/)):
- sqlite3.c: 106.1 to 106.6 ns a typed entry for AUTO, against 106.4 to 106.9 for the twin;
- Lua: 118.5 to 119.5, against 113.8 to 114.2.

The verdicts above come from the pipeline alone.
