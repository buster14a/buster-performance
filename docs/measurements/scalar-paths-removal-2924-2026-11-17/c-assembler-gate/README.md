# C11's gate: the assembler's vector path against its scalar twin (#2924)

[`run.sh`](run.sh) ran on the 9700X with main `0c113feb1`'s Release build (C10's gate's), every run under the lock,
pinned to CPU 2. `benchmark-assembler` runs both paths in 21 interleaved passes after a warm-up, checks that their
objects are the same outside the timed interval, and reports each phase's median and the whole run's.

It ran:
- the four synthetic workloads (mixed Intel, Intel registers and immediates, AVX-512 masks and broadcasts, AT&T) at 1,
  4, 16, 64, 256 and 2,048 functions;
- three real inputs: `sqlite3.c` by gcc `-O2 -S` (AT&T), by clang `-O2 -S -masm=intel` (Intel), and Lua 5.4.8's
  `lvm.c` by clang `-O2 -S`.

The `.s` files aren't kept here; `run.sh` makes them ([`logs/inputs-sizes.txt`](logs/inputs-sizes.txt) has their
sizes).

Whole-run medians, and the layout phase's. Layout's ratio is given where its median is at least 0.05 ms; below that,
the two read the same at the report's microsecond.

| Workload | Functions | Scalar ms | Vector ms | Scalar / vector | Layout, scalar / vector |
| --- | ---: | ---: | ---: | ---: | ---: |
| mixed | 1 | 0.018 | 0.009 | 2.00 | even |
| mixed | 4 | 0.067 | 0.030 | 2.23 | even |
| mixed | 16 | 0.266 | 0.113 | 2.35 | even |
| mixed | 64 | 1.036 | 0.449 | 2.31 | 0.985 |
| mixed | 256 | 4.209 | 1.844 | 2.28 | 0.988 |
| mixed | 2,048 | 35.727 | 17.164 | 2.08 | 0.986 |
| registers | 1 | 0.015 | 0.006 | 2.50 | even |
| registers | 4 | 0.056 | 0.022 | 2.55 | even |
| registers | 16 | 0.220 | 0.083 | 2.65 | even |
| registers | 64 | 0.870 | 0.332 | 2.62 | 1.000 |
| registers | 256 | 3.441 | 1.352 | 2.55 | 1.000 |
| registers | 2,048 | 29.066 | 12.163 | 2.39 | 0.998 |
| simd | 1 | 0.017 | 0.010 | 1.70 | even |
| simd | 4 | 0.065 | 0.034 | 1.91 | even |
| simd | 16 | 0.257 | 0.133 | 1.93 | even |
| simd | 64 | 1.029 | 0.541 | 1.90 | 1.000 |
| simd | 256 | 4.152 | 2.138 | 1.94 | 0.997 |
| simd | 2,048 | 33.598 | 18.814 | 1.79 | 1.006 |
| att | 1 | 0.018 | 0.011 | 1.64 | even |
| att | 4 | 0.064 | 0.038 | 1.68 | even |
| att | 16 | 0.256 | 0.147 | 1.74 | even |
| att | 64 | 1.020 | 0.582 | 1.75 | 1.000 |
| att | 256 | 4.126 | 2.355 | 1.75 | 0.989 |
| att | 2,048 | 34.948 | 21.193 | 1.65 | 0.998 |

| Input | Instructions | Scalar ms | Vector ms | Scalar / vector | Layout, scalar / vector |
| --- | ---: | ---: | ---: | ---: | ---: |
| sqlite3.c by gcc | 218,692 | 161.110 | 115.167 | 1.40 | 0.993 |
| sqlite3.c by clang, Intel | 253,704 | 163.523 | 118.111 | 1.38 | 0.992 |
| `lvm.c` by clang | 5,522 | 2.887 | 1.765 | 1.64 | 0.982 |

The vector path wins every run, by 1.38 to 2.65 times, and every phase but layout in every run
([`logs/`](logs/)): lexing, parsing, matching and encoding.

**Layout** reads the same or up to 1.8% slower on the vector path: 0.982 to 0.993 on the real inputs, 0.985 to 1.006 on
the synthetic ones from 64 functions. Its only path-dependent code is the relaxation's 16-records-at-a-time arms
(`asm_relax_first`, `asm_relax_place`). The rest of the phase is shared, and in each pass it runs after a different
path's earlier phases, so this run doesn't separate the two arms from the cache state they find.
