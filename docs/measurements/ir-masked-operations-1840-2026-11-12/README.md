# Tier 1's masked operations: Zen 5 rows and compile time (buster#1840 item 5, 2026-11-12)

This is the evidence for buster14a/buster's `e1/1840-masked-op` (package E1, round E). In Tier 1, `vselect m, op(a, b), w` becomes one EVEX instruction of `op` under `m`'s k register: merging into `w`, or zeroing where `w` is a zero vector.

## Zen 5 rows

- **What:** 164 rows that had no values: 155 `MASKED` rows, plus the `REGISTER` rows of the EVEX doubleword variable shifts, whose zeroing form takes the unmasked row.
- **Build:** buster `a48af16e`, built with `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0` and clang 23.1.1.
- **Measurement:** on the 9700X (benchpress), under the lock, `taskset -c 2 ./build/compiler measure-x86-zen5 --missing --table`. `run-zen5.sh` is the script; `zen5-missing-table.txt` is its whole output, every case's experiments and the printed rows file; `zen5-measure.stderr.txt` and `zen5-build.tail.txt` are the logs.
- **Result:** buster `0b4ff1fa` commits these rows unchanged. `test-x86-zen5` passes, with 1,846 cases in 180 IDs and none incomplete.

| | Latency (cycles) | Throughput (cycles) |
| --- | ---: | ---: |
| `vpaddd` zmm, unmasked | 2 | 0.25 |
| `vpaddd` zmm/ymm, merge-masked | 3 | 0.25 |
| `vpmulld` zmm, unmasked or merge-masked | 3 | 0.5 |
| `vmulps` zmm, unmasked or merge-masked | 3 | 0.5 |
| `vdivpd` zmm, unmasked or merge-masked | 13 | 4 |

## Compile time

`run-time.sh` takes base buster `b935fa30` (main) and head `0b4ff1fa`, both Release builds (`./build.sh`, native). It runs `time-runs --runs 21 --warmups 3` on CPU 2, under one lock hold, over `main.c`. `time-runs.txt` is the output.

| | base | head | change |
| --- | ---: | ---: | ---: |
| `-c main.c`, median wall | 681.690 ms | 680.807 ms | −0.13% |
| `-c main.c`, user cycles | 3443.0 M | 3438.4 M | −0.13% |
| `--tier1 -c main.c`, median wall | 1004.859 ms | 1005.666 ms | +0.08% |
| `--tier1 -c main.c`, user cycles | 5215.6 M | 5223.3 M | +0.15% |

Both are within the runs' spread: base `--tier1` ran from 1001.8 to 1026.3 ms, and head from 1002.6 to 1013.1 ms.

## Code effect (cloud container, not timed)

These are counts from `objdump` of `--tier1 -march=znver5 -c` of buster's own units. The compilers are main `b935fa30` and the head, both compiling the head's sources.

| unit | `vpblendm` base → head | masked arithmetic base → head | records base → head | machine rows |
| --- | --- | --- | --- | --- |
| `main_unit_frontend.c` | 261 → 230 | 42 → 73 | 547,777 → 547,774 | 15 → 15 |
| `main_unit_backend.c` | 411 → 329 | 96 → 178 | 1,581,983 → 1,581,961 | 193 → 193 |

The record counts drop by less than the blends do. Some merges first move `w` into the destination, plus an operand into xmm15, because the allocator has no hint to put the result in `w`'s register.
