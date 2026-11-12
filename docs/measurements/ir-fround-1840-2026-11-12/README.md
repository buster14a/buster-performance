# buster#1840's floating operations at their own rounding and truncating conversions: Zen 5 rows

buster#1840's `fround` intrinsic decodes `vaddps` to `vdivpd` with embedded rounding (`_mm512_add_round_ps` to
`_mm512_div_round_pd`), and its `cvtt` decodes the EVEX `vcvttss2si` and `vcvttsd2si`. Tier 1 selects the same records
back. This records the 9700X's measurement of the 11 forms that had no Zen 5 row.

- **Host:** benchpress (AMD Ryzen 7 9700X). The build and the measurement each took one hold of
  `~/buster-fast-bench/exclusive.sh`; the measurement was pinned to CPU 2 (`run-zen5.sh`, its log `run-zen5.log`).
- **Build:** buster `b619b1e42` (branch `ir/1840-fround`, with the 11 rows `U`), built `BUSTER_HOST_ARCH=znver5
  BUSTER_DEBUG_INFO=0`.
- **Command:** `measure-x86-zen5 --missing --table` (`zen5-table.txt`, its standard error in `zen5-errors.txt`). The rows
  it gave are in `rows.txt`.

In 1/256 cycle (latency, throughput, macro-ops):

| Forms | Latency | Throughput | Macro-ops |
| --- | ---: | ---: | ---: |
| `vaddpd`, `vsubps`, `vsubpd` `_Z_Z_Z_ER` | 512 | 128 | 256 |
| `vmulps`, `vmulpd` `_Z_Z_Z_ER` | 768 | 128 | 256 |
| `vdivps_Z_Z_Z_ER` | 2560 | 640 | 256 |
| `vdivpd_Z_Z_Z_ER` | 3328 | 1024 | 256 |
| `vcvttss2si`, `vcvttsd2si` (EVEX, into 32 or 64 bits) | 1920 | 128 | 512 |

The rounding forms measure as the forms without rounding do. The conversions' latency across the register files is
derived, as the model's other bridges are, and equals the legacy forms'.

Machine rows at `--tier1 -march=znver5` (Debug builds, both compilers compiling the change's sources merged with main
`91a87ab2`): `main_unit_frontend.c` 6 → 6, `main_unit_backend.c` 162 → 136.
