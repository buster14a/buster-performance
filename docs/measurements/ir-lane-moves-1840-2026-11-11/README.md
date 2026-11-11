# buster#1840's one-lane moves: Zen 5 rows and machine rows

buster#1840's one-lane moves decode `vmovd`, `vmovq`, `vpextrb` to `vpextrq` (after `vextracti32x4` past a vector's low 16
bytes), `vpinsrb` to `vpinsrq`, and `vpmovmskb`, `vmovmskps` and `vmovmskpd` into the IR's `lane_extract`, `lane_insert`
and `movemask` intrinsic kinds; Tier 1 selects the same instructions back. This records the 9700X's measurement of the 14
forms that had no Zen 5 row, and the machine rows before and after.

## Zen 5 rows

- **Host:** benchpress (AMD Ryzen 7 9700X). The build and the measurement each took one hold of
  `~/buster-fast-bench/exclusive.sh`; the measurement was pinned to CPU 2.
- **Build:** buster `fa324bef0` (branch `ir/1840-lane-moves`, with the 14 rows `U`), built
  `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0` by clang 23.1.1 (`run-zen5.sh`).
- **Command:** `measure-x86-zen5 --missing --table` (`zen5-table.txt`, its standard error in `zen5-errors.txt`).

In 1/256 cycle (latency, throughput, macro-ops):

| Forms | Latency | Throughput | Macro-ops |
| --- | ---: | ---: | ---: |
| `vpextrb`, `vpextrw`, `vpextrd`, `vpextrq` (EVEX) | 1664 | 128 | 512 |
| `vpinsrb`, `vpinsrw`, `vpinsrd`, `vpinsrq` (EVEX) | 1152 | 256 | 512 |
| `vpmovmskb`, `vmovmskps`, `vmovmskpd` of an xmm register | 1152 | 128 | 256 |
| the same of a ymm register | 1664 | 128 | 256 |

The latencies across the vector and general register files are derived, as the model's other bridges are.

## Machine rows

`machine-rows.txt`. Both compilers compiled the change's sources at `--tier1 -march=znver5` (Debug builds, counts only):

| Unit | Rows before | Rows after |
| --- | ---: | ---: |
| `main_unit_frontend.c` | 38 | 15 |
| `main_unit_backend.c` | 218 | 193 |
