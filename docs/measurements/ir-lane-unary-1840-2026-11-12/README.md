# buster#1840's lanes' unary operations: Zen 5 rows

buster#1840's `lane_unary` intrinsic decodes `vpopcntb` to `vpopcntq`, `vplzcntd`, `vplzcntq`, `vpconflictd` and
`vpconflictq` (clang's `__builtin_elementwise_popcount` and `_clzg`, and the x86 builtins' `_mm*_popcnt_*`, `_lzcnt_*`
and `_conflict_*`); Tier 1 selects the same instructions back. This records the 9700X's measurement of the 24 forms
(8 instructions at 3 widths) that had no Zen 5 row.

- **Host:** benchpress (AMD Ryzen 7 9700X). The build and the measurement each took one hold of
  `~/buster-fast-bench/exclusive.sh`; the measurement was pinned to CPU 2 (`run-zen5.sh`, its log `run-zen5.log`).
- **Build:** buster `8c7ae67c3` (branch `ir/1840-lane-unary`, with the 24 rows `U`), built `BUSTER_HOST_ARCH=znver5
  BUSTER_DEBUG_INFO=0`.
- **Command:** `measure-x86-zen5 --missing --table` (`zen5-table.txt`, its standard error in `zen5-errors.txt`). The rows
  it gave are in `rows.txt`.

In 1/256 cycle (latency, throughput, macro-ops):

| Forms | Latency | Throughput | Macro-ops |
| --- | ---: | ---: | ---: |
| `vpopcntb` to `vpopcntq`, `vplzcntd`, `vplzcntq`, every width | 512 | 128 | 256 |
| `vpconflictd`, `vpconflictq` of an xmm register | 768 | 128 | 256 |
| `vpconflictd`, `vpconflictq` of a ymm or a zmm register | 1792 | 256 | 512 |

Machine rows at `--tier1 -march=znver5` (Debug builds, both compilers compiling the change's sources merged with main,
which has the reductions): `main_unit_frontend.c` 6 → 1, `main_unit_backend.c` 162 → 141.
