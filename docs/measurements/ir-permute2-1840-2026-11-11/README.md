# buster#1840's permutes of two tables: Zen 5 rows and machine-row counts

buster#1840's permutes of two tables add a third operand to the IR's intrinsics, in the function's extra array, and its
first ternary kind, `permute2`. It decodes the rows of the permutex2var builtins and of `__builtin_shufflevector` of
two vectors: `vpermt2b` to `vpermt2q`. Tier 1 selects `vpermt2*`, or `vpermi2*` where the destination's register holds
the indices. This records the 9700X's measurement of the 24 register forms of both families that had no Zen 5 row, and
the machine rows before and after.

## Zen 5 rows

- **Host:** benchpress (AMD Ryzen 7 9700X).
  - The build and the measurement each took one hold of `~/buster-fast-bench/exclusive.sh`.
  - The measurement was pinned to CPU 2.
- **Working directory there:** `~/buster-fast-bench/1840-claude-b3` (scripts in `1840-claude-b3-scripts`).
- **Build:** buster `ffbf99c9` (branch `ir/1840-third-operand`, the change with its 24 new rows `U`), built
  `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0` (`permute2-build.log`).
- **Script:** `run-permute2.sh`.
- **Command:** `measure-x86-zen5 --missing --table`. It measured the 24 rows without values and printed the whole rows
  file.

### Files

- `permute2-table.txt`: that process's standard output: every fixture's per-iteration counts for the 24 cases, then
  the rows file, with the 24 rows filled.
- `permute2-errors.txt`: its standard error (the lock's wait message) and its exit status.
- `permute2.commit`: the commit measured.

### The rows

In 1/256 cycle:

| Forms | Latency | Throughput | Macro-ops | FP ops | Pipes |
| --- | ---: | ---: | ---: | ---: | --- |
| `vpermt2b` to `vpermt2q`, `vpermi2b` to `vpermi2q`, 16 bytes | 768 | 128 | 256 | 256 | 864 |
| the same, 32 bytes | 1024 | 128 | 256 | 256 | 864 (`vpermt2*`), 800 (`vpermi2*`) |
| the same, 64 bytes | 1280 | 128 (136: `vpermi2d`, `vpermi2q`) | 256 | 256 | 768 (864: `vpermt2w`) |

So each takes 3, 4 and 5 cycles of latency at 16, 32 and 64 bytes, one macro-op, and runs 2 per cycle.

## Machine rows

Both compilers compiled the same sources, buster `ir/1840-third-operand`'s, by
`--tier1 -march=znver5 -Isrc -fwrapv -funsigned-char -fno-strict-aliasing` (built Debug in the cloud session; these
are counts, not timings). The base is buster#2208's head `f324f2ac` (the lane operations); the change is `ffbf99c9`
with its tests. `rows-debug.patch` is the uncommitted counting aid both compilers carried, which prints each emitted
machine row's forms; `machine-rows.txt` holds the counts.

| Unit | Rows before | Rows after |
| --- | ---: | ---: |
| `main_unit_frontend.c` | 541 | 395 |
| `main_unit_backend.c` | 753 | 666 |
