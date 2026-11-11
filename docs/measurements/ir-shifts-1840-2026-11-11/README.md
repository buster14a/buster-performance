# buster#1840's shifts by a scalar count: Zen 5 rows and machine-row counts

buster#1840's shifts by a scalar count decode the x86 builtins' shifts by an int (`__builtin_ia32_psllwi512` to
`__builtin_ia32_psraqi128`) into the IR's `shift` intrinsic. Tier 1 selects it as the immediate form where the count is
a constant, else `vmovd` of the count and the form by an xmm count. This records the 9700X's measurement of the 53
register forms that had no Zen 5 row, and the machine rows before and after.

## Zen 5 rows

- **Host:** benchpress (AMD Ryzen 7 9700X).
  - The build and the measurement each took one hold of `~/buster-fast-bench/exclusive.sh`.
  - The measurement was pinned to CPU 2.
- **Working directory there:** `~/buster-fast-bench/1840-claude-b3` (scripts in `1840-claude-b3-scripts`).
- **Build:** buster `e8e7361` (branch `ir/1840-shifts`, the change with its 53 new rows `U`), which is buster#1972's head
  `2461071` plus `shifts.patch`.
  - Built `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0` (`build.sh`; `setup.sh` checked it out).
- **Script:** `zen5.sh`.
- **Command:** `measure-x86-zen5 --missing --table`. It measured the 53 rows without values and printed the whole rows
  file.

### Files

- `zen5-table.txt`: that process's standard output: every fixture's per-iteration counts for the 53 cases, then the
  rows file, with the 53 rows filled.
- `zen5-errors.txt`: its standard error (the lock's wait message), its exit status and the commit measured.

### The rows

Every form measured alike, in 1/256 cycle:

| Forms | Latency | Throughput | Macro-ops | FP ops | Pipes |
| --- | ---: | ---: | ---: | ---: | --- |
| `vpsllw` to `vpsraq` by an xmm count, EVEX, at every width (26 forms) | 512 | 128 | 256 | 256 | 64 |
| `vpsllw` to `vpsraq` by an immediate, EVEX, at every width (27 forms) | 512 | 128 | 256 | 256 | 32 |

So each takes 2 cycles of latency, one macro-op, and runs 2 per cycle. The xmm-count forms issue on one FP pipe and the
immediate forms on another. `VPSRLD_Z_Z_XM128` was already in the table, with the same row.

## Machine rows

Both compilers compiled the same sources, buster#1972's head `2461071`, by
`--tier1 --tier1-report -march=znver5 -Isrc -fwrapv -funsigned-char -fno-strict-aliasing` (built Release, `native`, in
the cloud session; these are counts, not timings). `report-*.txt` hold the reports' lines; `rows-debug.patch` is the
uncommitted counting aid both compilers carried, which prints each emitted machine row's forms.

| Unit | Rows before | Records before | Rows after | Records after |
| --- | ---: | ---: | ---: | ---: |
| `main_unit_frontend.c` | 660 | 543,674 | 628 | 543,620 |
| `main_unit_backend.c` | 967 | 1,542,016 | 792 | 1,541,683 |

No shift by an int stays a machine row (32 and 175 before).
