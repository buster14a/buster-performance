# buster#1840's AES rounds: Zen 5 rows and machine-row counts

buster#1840's AES rounds decode the aesenc builtins' rows (`vaesenc` and `vaesenclast`) into the IR's `aes`, a binary
intrinsic kind whose model is FIPS 197's round of each 16-byte lane. Tier 1 selects the form back. This records the
9700X's measurement of the 10 register forms that had no Zen 5 row, and the machine rows before and after.

## Zen 5 rows

- **Host:** benchpress (AMD Ryzen 7 9700X).
  - The build and the measurement each took one hold of `~/buster-fast-bench/exclusive.sh`.
  - The measurement was pinned to CPU 2.
- **Build:** buster `a8e4ec92` (branch `ir/1840-aes`, the change with its 10 new rows `U`), built
  `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0` (`aes-build.log`).
- **Script:** `run-aes.sh`.
- **Command:** `measure-x86-zen5 --missing --table`.

### Files

- `aes-table.txt`: that process's standard output: every fixture's per-iteration counts for the 10 cases, then the rows
  file, with the 10 rows filled.
- `aes-errors.txt`: its standard error (the lock's wait message) and its exit status.
- `aes.commit`: the commit measured.

### The rows

Every form, `vaesenc` and `vaesenclast`, VEX and EVEX at 16 and 32 bytes and EVEX at 64, measured alike, in 1/256 cycle:
latency 1024, throughput 128, macro-ops 256, FP ops 256, pipes 64. So each round takes 4 cycles of latency at every
width, one macro-op, and runs 2 per cycle.

## Machine rows

Both compilers compiled the same sources, buster `ir/1840-aes`'s, by
`--tier1 -march=znver5 -Isrc -fwrapv -funsigned-char -fno-strict-aliasing` (built Debug in the cloud session; counts,
not timings). The base is the compresses' head `ec902c4b`; the change is `a8e4ec92`. `rows-debug.patch` is the
uncommitted counting aid both compilers carried; `machine-rows.txt` holds the counts.

| Unit | Rows before | Rows after |
| --- | ---: | ---: |
| `main_unit_frontend.c` | 299 | 234 |
| `main_unit_backend.c` | 570 | 557 |

No AES row is left in either unit.
