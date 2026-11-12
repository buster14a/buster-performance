# #2538's eight-lane baseline measured again without the stray process (2026-11-12)

The baseline of [`tier1-compile-cost-138-2026-11-12`](../tier1-compile-cost-138-2026-11-12/)
(buster-performance#445, the measurements behind
[buster#2538](https://github.com/buster14a/buster/issues/2538)'s design) was
measured in holds that started from 11:40 to 12:03 UTC on 12 November. A test program started by hand
was looping at 100% of a CPU on the 9700X then, outside the lock
([buster#2555](https://github.com/buster14a/buster/issues/2555)). It sat on
core 0, and the baseline's eight-lane rows run on CPUs 0 to 7. buster#2555
marks those six rows high and not handled. This record measures that baseline
again on the clear host, with the same commit, scripts, inputs and method. The
eight-lane rows are measured twice, and the one-lane rows once as the control.

- **Source:** buster `c5f0efb20199618a542f0d8de61951916c15d76c`, the first
  record's commit. A clean clone (`scripts/setup.sh`; `COMMIT` lists 0 changed
  files) was built on the host by `./build.sh` (Release, the default host) in
  one hold of the lock (`raw/build-src.log`). The first record's executable was
  no longer on the host, so this is a new build of the same commit: SHA-256
  `af11b7de7732a99bb30685ff26997705becf6e9a0d6a288c9c5918f09ef6eab6`,
  172,106,848 bytes, against the first's `bc81ec29…`, 172,108,992 bytes. The
  two builds ran in directories of different names, which the debug information
  records. The control below shows the code is the same: every one-lane row
  retires the first record's user instructions exactly.
- **Host:** the Ryzen 7 9700X (`benchpress`). The kernel, clang, perf, the
  governor and the file system are the first record's (`env.txt`).
- **Inputs:** the first record's: the frozen corpus's `sqlite3.c` and musl, and
  Lua 5.4.8's 33 units. `scripts/inputs.sh` checked the hashes of the Lua
  tarball, copied from the first record's directory on the host, and of
  `sqlite3.c`. `env.txt` gives each workload's hash, the same as the first
  record's.
- **Scripts:** the first record's `baseline3.sh`, `corpora.sh`, `runs.py`,
  `setup.sh`, `inputs.sh`, `build.sh`, `queue.sh` and `tools/baseline_table.py`,
  byte for byte. `lock.sh` names this record's lock owner, and `env.sh` lists
  only this tree. Two scripts are new:
  - `rerun.sh` runs one row of `baseline3.sh` inside one hold of the lock. Inside
    that hold it writes the lock's owner line (`hold.txt`), and before and after
    the row the busiest processes (`ps-before.txt`, `ps-after.txt`) and
    `/proc/loadavg`.
  - `go.sh` runs the build, then the queue `q-round1.txt`, one hold a line.
  `tools/compare.py` makes `tables/comparison.md`.
- **Runs:** 20:00:00 to 20:01:06 UTC, one hold of the lock a row
  (`raw/queue.log`, `raw/*/*/hold.txt`). Round 1 is the first record's six
  rows, eight lanes first. Round 2 is the three eight-lane rows again. As in the
  first record: the default compile against `--tier1` in a Williams design's
  order after a warm-up round, 7 runs (musl: 5) under `perf stat`, pinned to
  CPU 2 for one lane or CPUs 0 to 7 for eight; then 3 rounds without `perf` for
  the peaks.
- **The host was clear.** Across the 18 snapshots the busiest other process
  used 1.3% of a CPU, a btrfs kernel worker. `/proc/loadavg` counted one
  runnable task each time, the reader itself.

## Eight lanes

Medians, with the wall times' range (`tables/comparison.md`):

| corpus | compile | wall ms, the first record, beside the stray | round 1, clear | round 2, clear | round 1 against the first |
| --- | --- | ---: | ---: | ---: | ---: |
| `sqlite3.c` | default | 115.8 (114.5 to 116.9) | 112.2 (111.8 to 113.4) | 113.0 (112.5 to 114.1) | −3.1% |
| | `--tier1` | 176.4 (174.3 to 177.2) | 166.7 (166.0 to 168.2) | 166.5 (165.9 to 168.9) | −5.5% |
| Lua, 33 units | default | 34.6 (28.5 to 39.6) | 27.2 (26.8 to 27.6) | 26.9 (26.6 to 27.8) | −21.4% |
| | `--tier1` | 54.6 (46.2 to 71.4) | 40.1 (39.8 to 41.1) | 40.5 (40.2 to 41.0) | −26.4% |
| musl, 1,336 units | default | 242.0 (241.2 to 251.3) | 206.2 (205.0 to 453.4) | 205.0 (204.3 to 208.4) | −14.8% |
| | `--tier1` | 296.1 (295.0 to 313.1) | 253.0 (251.4 to 257.8) | 252.4 (250.3 to 257.2) | −14.5% |

- **Beside the stray, the eight-lane rows read 3% to 36% high.** `sqlite3.c`
  read 3% and 6% high: one unit, whose lanes synchronize a few times. musl's
  command of 1,336 units read 17% high. Lua's read 27% and 36% high: a command
  of 27 to 40 ms, where a lane's wait of about a millisecond (buster#2545) is a
  large part. Lua's ranges, 11 and 25 ms wide beside the stray, are under 1.4 ms
  wide here. musl agrees with the whole-build record's eight-lane pass
  (buster-performance#448, another commit's executable): its musl command read
  234.0 ms beside the stray and 203.4 ms on the clear host, 15% high.
- **The two rounds agree:** every median within 1.1%.
- **On the clear host, `--tier1` adds 54.5 ms to `sqlite3.c`'s eight-lane
  compile** (166.7 against 112.2; round 2: 53.5). The first record read 60.6 ms
  (176.4 against 115.8). On Lua it adds 12.9 ms (20.0 in the first record), and
  on musl 46.8 ms (54.1).
- **Cycles are higher on the clear host for the same instructions.** User
  cycles are 0.6% to 1.4% higher on `sqlite3.c`, 5% to 10% on Lua and about 2%
  on musl. Kernel cycles are 0.6% to 21% higher on `sqlite3.c`, 20% to 27% on
  Lua and 8% to 10% on musl. buster#2536's rerun found the same direction for
  compiles side by side (buster#2555's third comment). So the first record's eight-lane cycles
  are no better a reference than its wall times; use these rows for both.
- **Page faults are within 1% of the first record's** in every row
  (`runs.tsv`'s `minor_faults`), so both took the same kind of pages.
- **One outlier.** Run 0 of round 1's musl default row took 453.4 ms with the
  other runs' cycles (5,730 M user, 2,257 M kernel): about 250 ms off the CPUs.
  The snapshots show nothing else running, and round 2's five runs of the row
  are within 204.3 to 208.4 ms. It is in the range, not in the median.

## One lane: the control

| corpus | compile | wall ms, the first record | round 1, clear | wall | user cycles | user instructions, M, both |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | default | 124.0 (123.4 to 149.3) | 124.0 (123.5 to 124.9) | +0.0% | −0.0% | 1,347.5 |
| | `--tier1` | 426.1 (425.5 to 426.9) | 425.2 (424.6 to 426.2) | −0.2% | −0.1% | 5,278.7 |
| Lua, 33 units | default | 91.7 (91.5 to 104.7) | 91.4 (91.3 to 91.6) | −0.4% | −0.1% | 1,165.0 |
| | `--tier1` | 167.5 (167.4 to 180.8) | 166.7 (162.7 to 171.5) | −0.5% | −0.0% | 2,014.2 |
| musl, 1,336 units | default | 1,052.9 (1,052.3 to 1,080.4) | 1,055.2 (1,054.0 to 1,073.9) | +0.2% | +0.4% | 12,756.1 |
| | `--tier1` | 1,352.4 (1,350.9 to 1,354.1) | 1,352.6 (1,350.2 to 1,354.1) | +0.0% | +0.2% | 15,145.0 |

Every one-lane row retires the first record's user instructions exactly. Its
medians are within 0.5% in wall time and 0.4% in user cycles. So the new build
is the same code, and the first record's one-lane rows stand, as buster#2555
said: pinned to CPU 2, their medians and counters weren't touched. Single runs
were: the first record's slowest default compiles of `sqlite3.c` and Lua
(149.3 and 104.7 ms) are 20% and 14% above their medians. Here those rows'
slowest runs are under 1% above theirs. Every `--time-stages` report of these rows says
`huge-pages system`.

## What this changes

- **The first record's eight-lane rows** are replaced by these for any
  comparison. Its one-lane rows, its stage attribution and its prototypes (all
  on CPU 2) stand.
- **`docs/tier1-one-allocation.md` in buster** quotes the eight-lane rows and
  "on eight lanes it adds 60.6 ms to `sqlite3.c`'s compile". Its figures are
  updated from this record. The design's argument rests on the one-lane rows
  and doesn't move.

## Files

- `raw/round1/<corpus>-<lanes>/` and `raw/round2/<corpus>-8/`: each row's
  `runs.tsv` (a line a run, then the medians and ranges), `peaks.tsv`,
  `tier1-report.txt` and `units.txt`, and on one lane the `--time-stages`
  reports. With them the hold's owner line, written twice (`hold.txt` by
  `rerun.sh`, `holder.txt` by `baseline3.sh`), the snapshots (`ps-*.txt`,
  `loadavg-*.txt`) and `status.txt`. `runs.log` and `peaks.log` are
  `runs.py`'s output, empty since it printed nothing.
- `raw/build-src.log`: the build, with its exit status and the executable's
  SHA-256. `raw/queue.log`: each hold's start, end and exit status. Neither
  waited for the lock.
- `tables/round1.md` and `tables/round2.md`, made by the first record's
  `tools/baseline_table.py`; `tables/comparison.md`, made by
  `tools/compare.py` from the first record's `raw/baseline3` and these rounds.
- `env.txt`, `COMMIT`.

To reproduce on the host: `scripts/setup.sh`, `scripts/inputs.sh`, then
`scripts/go.sh`.
