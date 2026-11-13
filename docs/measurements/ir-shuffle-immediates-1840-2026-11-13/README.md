# buster#1840's byte shuffles by an immediate: Zen 5 rows and machine-row counts

buster#1840's byte shuffles by an immediate decode the rows of `vpshufd`, `vpshuflw`, `vpshufhw`, `vpslldq` and
`vpsrldq` into the IR's `shuffle` (`vpshufb`) of the vector by a constant. Tier 1 matches the constant back to the
immediate form. This records two things:
- the 9700X's measurement of the 15 EVEX register forms that had no Zen 5 row;
- the machine rows before and after.

## Zen 5 rows

- **Host:** benchpress (AMD Ryzen 7 9700X); `host.txt` has its kernel, clang and CPU 2's governor, read after the run.
- **Build:** buster `884372737` (branch `claude/trusting-thompson-ye0dvx`, the change with its 15 rows `U`), built
  `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0` under one hold of `~/buster-fast-bench/exclusive.sh` (`shuffle-build.log`).
  `host.txt` has the SHA-256 of the binary measured.
- **Command:** `measure-x86-zen5 --missing --table`, pinned to CPU 2 under a second hold (`run-shuffle.sh`).

### Files

- `shuffle-table.txt`: that process's standard output: each case's per-iteration counts, then the rows file with the 15
  rows filled. `rows.txt` holds those 15 rows.
- `shuffle-errors.txt`, `shuffle-build.log`: the measurement's standard error and exit status, and the build's log.
  Both had `exclusive.sh`'s wait messages, which name other sessions' commands, titles and links. Those blocks are
  removed, each from its `exclusive.sh: waiting` line through its `link:` line.
- `shuffle.commit`: the commit measured.

**Limitation:** the script logged no lock receipt (the holder's line of `/var/lib/buster-9700x/owner` at each run's
start). Its only evidence of the holds is the wait messages removed above.

### The rows

In 1/256 cycle:

| Forms | Latency | Throughput | Macro-ops | Pipes |
| --- | ---: | ---: | ---: | ---: |
| `vpshufd`, `vpshuflw`, `vpshufhw` at 16, 32 and 64 bytes | 512 | 64 | 256 | 128 |
| `vpslldq`, `vpsrldq` at 16, 32 and 64 bytes | 512 | 128 | 256 | 256 |

So the doubleword and word shuffles take 2 cycles and run 4 per cycle, and the byte shifts take 2 cycles and run 2 per
cycle. That is `vpshufb`'s 2 cycles and 2 per cycle, without its constant's load.

## Machine rows

Both compilers compiled the same sources, buster `884372737`'s, by
`--tier1 --tier1-report -march=znver5 -Isrc -fwrapv -funsigned-char -fno-strict-aliasing`. They were built Develop in
the cloud session; these are counts, not timings.
- The base is main `26f0bb0e`; the change is `884372737`.
- `rows-debug.patch` is the uncommitted counting aid both compilers carried. It prints each machine row's classes and
  records under `BUSTER_ROWS_DEBUG`.
- `machine-rows.txt` holds the report's counts.

| Unit | Rows before | Rows after | Records before | Records after |
| --- | ---: | ---: | ---: | ---: |
| `main_unit_frontend.c` | 1 | 1 | 635,525 | 635,525 |
| `main_unit_backend.c` | 268 | 170 | 1,600,450 | 1,600,450 |

The 98 rows (96 `vpshufd` of a zmm register at immediates 0x00, 0x55, 0xaa and 0xff, and 2 `vpslldq`) were each one
record. Each is now one record of the same form, so the records, spills and row moves are unchanged.
