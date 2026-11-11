# buster#1840's compresses and expands: Zen 5 rows and machine-row counts

buster#1840's compresses and expands decode the register rows of the compress and expand builtins
(`vpcompressb`..`vpcompressq` and `vpexpandb`..`vpexpandq`, merged under a writemask) into the IR's `compress` and
`expand`, two ternary intrinsic kinds. Tier 1 selects the form merged under the mask into the destination. This records
the 9700X's measurement of the 24 masked register forms that had no Zen 5 row, and the machine rows before and after.

## Zen 5 rows

- **Host:** benchpress (AMD Ryzen 7 9700X).
  - The build and the measurement each took one hold of `~/buster-fast-bench/exclusive.sh`.
  - The measurement was pinned to CPU 2.
- **Build:** buster `9b6989cc` (branch `ir/1840-compress`, the change with its 24 new rows `U`), built
  `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0` (`compress-build.log`).
- **Script:** `run-compress.sh`.
- **Command:** `measure-x86-zen5 --missing --table`. It measured the 24 rows without values and printed the whole rows
  file.

### Files

- `compress-table.txt`: that process's standard output: every fixture's per-iteration counts for the 24 cases, then the
  rows file, with the 24 rows filled.
- `compress-errors.txt`: its standard error and its exit status.
- `compress.commit`: the commit measured.

### The rows

Every form `MASKED` (merged under a writemask), in 1/256 cycle:

| Forms | Latency | Throughput | Macro-ops | FP ops | Pipes |
| --- | ---: | ---: | ---: | ---: | --- |
| 16 bytes | 576 (512: `vpcompressq`) | 256 | 512 | 512 | 256 |
| 32 bytes | 1024 | 256 | 512 | 512 | 256 |
| 64 bytes | 1280 | 256 | 512 | 512 | 256 |

So each takes about 2.25, 4 and 5 cycles of latency at 16, 32 and 64 bytes, two macro-ops, and runs one per cycle.

## Machine rows

Both compilers compiled the same sources, buster `ir/1840-compress`'s, by
`--tier1 -march=znver5 -Isrc -fwrapv -funsigned-char -fno-strict-aliasing` (built Debug in the cloud session; these
are counts, not timings). The base is buster#2338's head `3249be86` (the bitwise functions of three vectors); the
change is `9b6989cc`. `rows-debug.patch` is the uncommitted counting aid both compilers carried; `machine-rows.txt` holds
the counts.

| Unit | Rows before | Rows after |
| --- | ---: | ---: |
| `main_unit_frontend.c` | 340 | 299 |
| `main_unit_backend.c` | 587 | 570 |

The 7 compress rows left in the backend are the compress-stores to memory.
