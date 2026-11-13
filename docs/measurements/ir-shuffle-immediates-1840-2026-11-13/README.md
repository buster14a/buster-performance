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

## Compile time

`time/time-g1.sh` measured two compilers built `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0` on the 9700X:
- **base:** main `26f0bb0e`;
- **head:** `3c9ab01b`, the change with its measured rows. Its code is `884372737`'s; the later commit changes only the Zen 5
  rows, a comment and the docs.

`time-commits.txt` names the trees, `time-binaries.txt` has their binaries' SHA-256, and `time-build-*.log` are the
builds' logs.

**Command:** the head's `time-runs --runs 11 --warmups 2`, pinned to CPU 2 under one hold of the lock per mode, on
`main.c` of the head's sources: `-c` and `--tier1 -c`, at
`-march=znver5 -fwrapv -funsigned-char -fno-strict-aliasing -o /dev/null`. Its Williams design interleaves the two
builds. `time-tier0.txt` and `time-tier1.txt` have every run.

**Lock receipts:** each hold's first command appended the holder's line of `/var/lib/buster-9700x/owner` to
`time-holds.txt`: two builds and two timings, all `claude-1840-g1`. The `exclusive.sh` wait blocks are removed from the
`.log` and `.err` files as above.

| Median of 11 | base | head | head against base |
| --- | ---: | ---: | ---: |
| `--tier1 -c main.c`, wall | 1,190.8 ms | 1,186.1 ms | -0.40% |
| `--tier1 -c main.c`, user cycles | 6,250.2 M | 6,220.7 M | -0.47% |
| `--tier1 -c main.c`, instructions | 19,795.2 M | 19,794.9 M | -0.002% |
| `-c main.c`, wall | 688.0 ms | 685.6 ms | -0.34% |
| `-c main.c`, user cycles | 3,484.6 M | 3,471.2 M | -0.38% |
| `-c main.c`, instructions | 10,560.8 M | 10,559.9 M | -0.008% |

Each wall-time range overlaps the other build's (`--tier1`: base 1,186.9–1,196.6 ms, head 1,182.0–1,190.0 ms). So
the change is within noise of main on both paths, and isn't slower.
