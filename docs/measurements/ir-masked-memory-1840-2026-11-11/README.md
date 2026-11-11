# buster#1840's masked loads and stores: Zen 5 rows, machine rows and `--tier1` time

buster#1840's masked loads and stores ([buster#2368](https://github.com/buster14a/buster/pull/2368)) decode the masked
load and store builtins' rows into the IR's new memory opcodes, `masked_load` and `masked_store` (the owner's Option B).
Tier 1 selects `vmovdqu8` to `vmovdqu64` under the mask's k register. The opcode tables grow from 64 to 128 entries.

This record has three parts: the 9700X's measurement of the 11 masked stores that had no Zen 5 row, the machine rows
before and after, and a base-vs-head timing of `--tier1 -c` of `main.c`.

## Zen 5 rows

- **Host:** benchpress (AMD Ryzen 7 9700X). The build and the measurement each took one hold of
  `~/buster-fast-bench/exclusive.sh`; the measurement was pinned to CPU 2.
- **Build:** buster `05ff617f2` (branch `ir/1840-masked-memory`, the change with its 11 new rows `U`), built
  `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0` by clang 23.1.1.
- **Script:** `run-zen5.sh`.
- **Command:** `measure-x86-zen5 --missing --table`.

### Files

- `zen5-table.txt`: that process's standard output: every fixture's per-iteration counts for the 11 cases, then the
  rows file, with the 11 rows filled.
- `zen5-errors.txt`: its standard error (the lock's wait message).

### The rows

`vmovdqu8`, `vmovdqu16` and `vmovdqu64` of an xmm, ymm or zmm register to `[base]` under an opmask, and `vmovdqu32` of
an xmm or ymm register (its zmm one had a row), the `MASKED_MEMORY` kind, in 1/256 cycle:

- **16 and 32 bytes:** throughput 128 (2 per cycle), one macro-op, as the unmasked stores.
- **64 bytes:** throughput 256 (1 per cycle), two macro-ops, as `vmovdqu32`'s zmm row.

A store has no latency column (`U`), as the unmasked ones haven't. The model has no row of a masked load merging into
its destination by design (buster's `docs/x86-zen5.md`): Tier 1's masked loads are such records.

## Machine rows

`machine-rows.txt`. Both compilers compiled the change's sources by
`--tier1 --tier1-report -march=znver5 -Isrc -fwrapv -funsigned-char -fno-strict-aliasing`, built Debug in the cloud
session (counts, not timings). The base is main `e43dfc102`; the change is `05ff617f2`.

| Unit | Rows before | Rows after |
| --- | ---: | ---: |
| `main_unit_frontend.c` | 241 | 38 |
| `main_unit_backend.c` | 558 | 218 |

The checker driver's machine-rows fixture goes from 24 rows to 16 at `-march=x86-64-v4`, under its floor of 20, which
the change lowers to 10.

## `--tier1` compile time

- **Builds:** base main `e43dfc102` and head `3b4e02cc1` (the change with its measured rows), each built
  `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0` under the lock.
- **Command:** `time-runs --runs 11 --warmups 2`, both compilers, of
  `-c --tier1 -march=znver5 -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -o /dev/null src/buster/compiler/main.c`
  (head's sources), pinned to CPU 2, one hold of the lock (`run-time.sh`, `time-tier1.txt`).

| Build | Median wall | Range | User cycles | Instructions |
| --- | ---: | ---: | ---: | ---: |
| base | 994.810 ms | 992.767 to 1144.841 | 5171.4 M | 15514.5 M |
| head | 999.807 ms | 997.069 to 1022.754 | 5199.1 M | 15530.4 M |

Head is 0.50% slower in wall time and 0.54% in cycles, with 0.10% more instructions. Its masked loads and stores are now
IR instructions that Tier 1 selects, where base placed rows; its opcode lookups take `vpermi2b` where base's took
`vpermb`. The `-fsyntax-only` and plain `-c` paths don't run the IR and aren't affected.
