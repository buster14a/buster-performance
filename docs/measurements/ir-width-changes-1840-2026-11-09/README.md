# The width changes' Zen 5 rows (buster#1840)

The 9700X's measurement of the six register forms that buster#1840's width changes add to Tier 1:
- `vextracti32x4` of a ymm and of a zmm register, and `vextracti64x4`;
- `vinserti32x4` into a ymm and into a zmm register, and `vinserti64x4`.

Tier 1 selects them for the IR's `extract` and `insert` intrinsics.

- **Host:** benchpress (AMD Ryzen 7 9700X, clang 23.1.1).
  - The build and the measurement each took one hold of `~/buster-fast-bench/exclusive.sh`.
  - The measurement was pinned to CPU 2.
- **Working directory there:** `~/buster-fast-bench/1840-claude`.
- **Build:** buster main `cb608c1` with `familyb.patch` applied: the family's working tree when measured, whose Zen 5 rows were `U`.
  - Built `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0`.
- **Script:** `zen5.sh`.
- **Command:** `measure-x86-zen5 --missing --table`. It measured the six rows without values and printed the whole rows file.

## Files

- `zen5-table.txt`: that process's standard output. It holds every fixture's per-iteration counts for the six cases, then the rows file, with the six rows filled.
- `zen5-errors.txt`: its standard error, the lock's wait message.

The six rows, as committed:

| Form | Latency (1/256 cycle) | Throughput (1/256 cycle) | Macro-ops (1/256) | Pipes |
| --- | ---: | ---: | ---: | --- |
| `VEXTRACTI32X4_XM128_Y_IMM8` | 512 | 64 | 256 | 128 |
| `VEXTRACTI32X4_XM128_Z_IMM8` | 512 | 64 | 256 | 128 |
| `VEXTRACTI64X4_YM256_Z_IMM8` | 512 | 64 | 256 | 128 |
| `VINSERTI32X4_Y_Y_XM128_IMM8` | 512 | 128 | 256 | 256 |
| `VINSERTI32X4_Z_Z_XM128_IMM8` | 512 | 128 | 256 | 256 |
| `VINSERTI64X4_Z_Z_YM256_IMM8` | 512 | 128 | 256 | 256 |

So each takes 2 cycles of latency and one macro-op. The extracts run 4 per cycle and the inserts 2.

## The permutes' rows (buster#1840, family C)

A second process measured 19 more register forms with the same method:
- **Script:** `zen5c.sh`.
- **Build:** buster main `cb608c1` with `familyc.patch`: families B and C, the permutes' rows `U`.
- **Output:** `zen5c-table.txt` (standard output) and `zen5c-errors.txt` (standard error).

The forms are those Tier 1 selects for the IR's `permute`, `shuffle`, `align` and `shuffle_lanes`:
- `vpermb` of xmm and ymm registers;
- `vpermw` of all three widths;
- `vpermd` of ymm and zmm registers;
- `vpermq` of zmm registers;
- `vpshufb` (EVEX) of all three widths;
- `valignd` and `valignq` of all three widths;
- `vshufi64x2` of ymm and zmm registers.

`vpermb`'s zmm row was already in the table.

| Form | Latency | Throughput | Macro-ops | Pipes |
| --- | ---: | ---: | ---: | --- |
| `VPERMB_X_X_XM128` | 512 | 128 | 256 | 256 |
| `VPERMB_Y_Y_YM256` | 1024 | 128 | 256 | 256 |
| `VPERMW_X_X_XM128` | 512 | 128 | 256 | 256 |
| `VPERMW_Y_Y_YM256` | 1024 | 128 | 256 | 256 |
| `VPERMW_Z_Z_ZM512` | 1280 | 128 | 256 | 256 |
| `VPERMD_Y_Y_YM256_EVEX` | 1024 | 128 | 256 | 256 |
| `VPERMD_Z_Z_ZM512` | 1280 | 128 | 256 | 256 |
| `VPERMQ_Z_Z_ZM512` | 1280 | 128 | 256 | 256 |
| `VPSHUFB_X_X_XM128_EVEX` | 512 | 128 | 256 | 256 |
| `VPSHUFB_Y_Y_YM256_EVEX` | 512 | 128 | 256 | 256 |
| `VPSHUFB_Z_Z_ZM512` | 512 | 128 | 256 | 256 |
| `VALIGND_X_X_XM128_IMM8` | 512 | 128 | 256 | 256 |
| `VALIGND_Y_Y_YM256_IMM8` | 1024 | 128 | 256 | 256 |
| `VALIGND_Z_Z_ZM512_IMM8` | 1280 | 128 | 256 | 256 |
| `VALIGNQ_X_X_XM128_IMM8` | 512 | 128 | 256 | 256 |
| `VALIGNQ_Y_Y_YM256_IMM8` | 768 | 128 | 256 | 256 |
| `VALIGNQ_Z_Z_ZM512_IMM8` | 1280 | 128 | 256 | 256 |
| `VSHUFI64X2_Y_Y_YM256_IMM8` | 768 | 128 | 256 | 256 |
| `VSHUFI64X2_Z_Z_ZM512_IMM8` | 1280 | 128 | 256 | 256 |

Latency and throughput are in 1/256 cycle, so each permute runs 2 per cycle. A 16-byte permute's latency is 2 cycles, a 32-byte one's 3 to 4, and a 64-byte one's 5, except `vpshufb`, which is 2 cycles at every width.
