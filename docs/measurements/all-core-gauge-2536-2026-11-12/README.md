# The all-core gauge measured against its gate (buster#2536, step 0, 2026-11-12)

Step 0 of [buster's all-core path](https://github.com/buster14a/buster/blob/ce5b30a65074fbe094a5a02b74a0def06d932a8c/docs/all-core-path.md)
([buster#2536](https://github.com/buster14a/buster/issues/2536)) is a gauge: what a compile costs at one worker and at
eight on the 9700X, its cycles in user mode and in the kernel, its peak and its faults, for the whole compile and by
stage, the stages from each worker's own `--time-stages` report. It is `tools/allcore/allcore.c` in buster
([`ce5b30a6`](https://github.com/buster14a/buster/blob/ce5b30a65074fbe094a5a02b74a0def06d932a8c/tools/allcore/allcore.c),
its guide [`docs/commands/all-core.md`](https://github.com/buster14a/buster/blob/ce5b30a65074fbe094a5a02b74a0def06d932a8c/docs/commands/all-core.md)).
Its gate: reproduce the stage table of [`all-core-rerun-2536-2026-11-12`](../all-core-rerun-2536-2026-11-12/) (the
design's record, buster-performance#451) within 3% at `4c8c3c9c`, in two holds of the lock of under 30 s each. This
record is the gauge run against that gate twice.

**In short.** Both runs took two holds each, 14.3 s and 13.4 s, then 14.9 s and 13.4 s. Within 3% of the record in both
runs: the whole compile's 14 figures at one worker and at eight, and the stage table's times, user cycles, inflation and
faults but in the two smallest stages' rows (68 and 69 of 72 cells). Not within 3%: the kernel cycles of the stages that
have few (10 and 11 of 24 cells hold), where the record's own two measurements of the same executable don't reproduce
either.

## What was run

- **The executable** is the record's own build of buster `4c8c3c9c154640c2edb81271bcd5dc987f2cfa93`, SHA-256
  `8e609253fe92c1329edabfc830617aba0ac82a7550911a2dc1b623ba5958d793`, as a reflinked copy of the rerun record's copy in
  this record's own work directory on the host (`~/buster-fast-bench/2536-gauge-claude/src/build/compiler`).
- **The input and the options** are the record's: the frozen corpus's `sqlite3.c` (9,507,037 bytes), `--time-stages
  --lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE
  -I$sqlite`, the 9700X job's `compile_time` options (`scripts/gate.sh`).
- **The gauge**: `scripts/allcore.c` is the tool as committed in buster (`657834a6…`). Run 1 ran `allcore-run1.c`
  (`2045f45d…`) and run 2 `allcore-run2.c` (`da71bc87…`); they measure the same way and differ from the final one in
  their reductions alone: run 1's took the rounds' mean MB/s, and neither had `compare --record-raw`. Every table in
  `tables/` is the final tool's, from `raw/`; `tables/runN/first-reduction/` are the tables each run's own tool wrote.
- **The parts**, each one hold (`scripts/queue.sh`: the tool's build and the host's state, then `gate.sh counted`, then
  `gate.sh sampled`, 20 s between holds, each through `scripts/lock.sh`):
  - `counted`: six rounds, each a cohort of one worker on CPU 2 and one of eight on CPUs 0 to 7 (the order alternating),
    six compiles a worker, each run counted by inherited counters (cycles and instructions in each mode, APERF and
    MPERF);
  - `sampled`: six rounds of a cohort of one worker (six compiles) and one of eight (five), each under a group on every
    worker's CPU, `{cycles, cycles:u, cycles:k}`, leader-sampled every 100,003 cycles with each sample's time on
    `CLOCK_MONOTONIC` and its address; the tool reads the ring buffers itself and puts each sample's deltas in its run
    and stage, the run's stage clock anchored by the compiler's symbols as the record's `buckets` did.
- **The holds** (`raw/runN/holds.tsv`, `*.holder.txt`): run 1 counted from 17:03:20 to 17:03:34 UTC (14.304 s), sampled
  from 17:05:00 to 17:05:13 (13.414 s); run 2 counted from 17:11:03 to 17:11:18 (14.857 s), sampled from 17:12:47 to
  17:13:00 (13.362 s). Every holder line is this session's.
- **Clean:** every cohort's strays file is empty (no other process above half a CPU over it), no sample was lost, no ring
  filled, no group was multiplexed, and every run of the sampled part had its anchors (`raw/runN/*.log`).
- **The page state:** every compile at eight workers found the host busy and took base pages, as in the record. Of the
  one-worker compiles, two found it busy too: one of run 2's 24 counted ones (`whole.tsv`'s `huge_pages`) and one of run
  1's sampled ones (round 0's second, whose preprocessing and parse took 20% and 43% more cycles than its neighbours' and
  its exit three times as many), out of 72 a run.
- **The host as found** (`raw/runN/env.txt`): Linux 6.18.50, CPU 2 `performance`, every other CPU `powersave` with
  `balance_performance`, CPU 10 offline, transparent huge pages `always`, `perf_event_paranoid` -1, the NMI watchdog on
  (one counter), `perf_event_max_sample_rate` 63,300 (the sampling's 55,000 a second a CPU stays under it). Nothing was
  changed.

## The whole compile

`tables/runN/whole.tsv`; medians over each worker's runs but its first and last, per compile; MB/s is the median of the
rounds' rates:

| | run 1 | run 2 | the record |
| --- | ---: | ---: | ---: |
| one worker: MB/s | 76.05 | 76.16 | 75.97 (its rounds' median; their mean is 73.17) |
| wall ms | 124.71 | 124.72 | 124.99 |
| user cycles | 600.8 M | 601.0 M | 601.5 M |
| kernel cycles | 84.7 M | 84.8 M | 85.0 M |
| user instructions | 1,348.9 M | 1,348.9 M | 1,348.9 M |
| peak RSS | 236.7 MB | 236.7 MB | 241.0 MB |
| faults | 7,460 | 7,459 | 7,404 |
| eight workers: MB/s | 286.49 | 285.76 | 287.94 (mean 288.78) |
| wall ms | 260.03 | 260.31 | 259.00 |
| user cycles | 1,075.1 M | 1,075.1 M | 1,074.4 M |
| kernel cycles | 275.3 M | 276.2 M | 275.6 M |
| peak RSS | 190.7 MB | 190.7 MB | 195.2 MB |
| faults | 62,997 | 62,994 | 62,982 |

- **MB/s** is the median of the rounds' rates here. The record took their mean, and its first round's one-worker cohort
  ran a never-read copy of the executable (its second compile took 291 ms), which pulled the mean down to 73.17 where
  the rounds' median is 75.97. `compare --record-raw` takes the record's median from its raw rows.
- **The peaks** are 4.3 to 4.5 MB under the rerun record's and equal to its first record's (236.7 and 190.7 MB): the
  executable's file, as the rerun's `rss.sh` found, which a copy maps differently from another.
- GHz from APERF and MPERF: 5.545 and 5.544 at one worker, 5.268 and 5.259 at eight (the record: 5.55 and 5.28).

## The stage table

`tables/run1/table.tsv`, per compile (run 2's is beside it):

| stage | ms 1 | ms 8 | user Mcycles 1 | user Mcycles 8 | times | kernel Mcycles 1 | kernel Mcycles 8 | faults 1 | faults 8 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| preprocess | 9.66 | 15.76 | 43.2 | 61.3 | 1.42 | 9.9 | 18.0 | 881 | 5,646 |
| parse | 7.19 | 24.61 | 23.1 | 77.2 | 3.35 | 17.1 | 48.0 | 995 | 10,430 |
| check-input | 45.92 | 107.01 | 218.3 | 420.0 | 1.92 | 34.9 | 126.0 | 4,874 | 33,433 |
| check-expressions | 11.45 | 20.86 | 58.0 | 87.6 | 1.51 | 5.0 | 16.7 | 67 | 6,650 |
| check-declarations | 2.48 | 3.97 | 12.6 | 18.8 | 1.49 | 1.0 | 3.5 | 5 | 549 |
| check-program | 23.85 | 46.72 | 128.1 | 232.5 | 1.81 | 1.7 | 7.6 | 22 | 2,546 |
| select | 1.08 | 2.89 | 5.0 | 12.1 | 2.44 | 0.9 | 2.7 | 2 | 782 |
| lower | 11.32 | 19.41 | 60.9 | 97.9 | 1.61 | 1.5 | 2.9 | 399 | 2,147 |
| emission | 8.58 | 12.31 | 46.0 | 60.7 | 1.32 | 1.0 | 0.8 | 7 | 299 |
| object | 1.44 | 2.57 | 4.7 | 5.1 | 1.09 | 3.3 | 7.6 | 1 | 37 |
| start | 0.28 | 0.31 | 1.1 | 1.8 | 1.66 | 8.4 | 41.6 | 123 | 391 |
| total | 123.25 | 256.42 | 600.8 | 1,075.1 | 1.79 | 84.7 | 275.3 | 7,376 | 62,910 |

## Against the gate

`tables/runN/compare.tsv` puts every cell beside the record's (`inflation-sq.tsv`, `stages-sq.w1.tsv` for the faults at
one worker, `baseline.tsv` and its raw rows for the whole compile). Within 3%:

| | run 1 | run 2 |
| --- | ---: | ---: |
| the whole compile (MB/s, wall time, both modes' cycles, user instructions, peak, faults, at one worker and at eight) | 14 of 14 | 14 of 14 |
| the stage table: ms at one worker; at eight | 11; 11 of 12 | 12; 10 of 12 |
| user cycles at one worker; at eight | 12; 11 of 12 | 11; 12 of 12 |
| the inflation (`times`) | 11 of 12 | 12 of 12 |
| faults at eight | 12 of 12 | 12 of 12 |
| kernel cycles at one worker; at eight | 5; 5 of 12 | 7; 4 of 12 |
| the stage table, all of it | 78 of 96 | 80 of 96 |
| the faults at one worker (not in the record's stage table) | 9 of 12 | 8 of 12 |

Every cell outside 3% in either run, beside the record and its first measurement
([`all-core-design-672-2026-11-12`](../all-core-design-672-2026-11-12/), the same executable beside #2555's stray):

| stage | column | run 1 | run 2 | the record | its first measurement |
| --- | --- | ---: | ---: | ---: | ---: |
| preprocess | kernel Mcycles 8 | **18.0** (-4%) | **18.0** (-4%) | 18.7 | 17.5 |
| check-input | kernel Mcycles 1 | **34.9** (+5%) | **34.2** (+3%) | 33.1 | 33.9 |
| check-expressions | kernel Mcycles 8 | **16.7** (-6%) | **16.7** (-6%) | 17.8 | 15.5 |
| check-program | kernel Mcycles 1 | **1.7** (-11%) | **2.4** (+26%) | 1.9 | 2.2 |
| check-program | kernel Mcycles 8 | **7.6** (-16%) | **8.3** (-9%) | 9.1 | 6.3 |
| select | ms 8 | 2.89 (+2%) | **2.95** (+4%) | 2.84 | 2.65 |
| select | kernel Mcycles 1 | **0.9** (-10%) | **0.9** (-10%) | 1.0 | 0.9 |
| select | kernel Mcycles 8 | **2.7** (+13%) | **2.6** (+8%) | 2.4 | 2.3 |
| lower | kernel Mcycles 1 | **1.5** (-6%) | **1.8** (+12%) | 1.6 | 1.7 |
| lower | kernel Mcycles 8 | **2.9** (-31%) | **3.2** (-24%) | 4.2 | 2.6 |
| emission | kernel Mcycles 1 | **1.0** (-23%) | 1.3 (+0%) | 1.3 | 1.3 |
| emission | kernel Mcycles 8 | **0.8** (-47%) | **1.0** (-33%) | 1.5 | 0.6 |
| object | ms 8 | **2.57** (-5%) | **2.48** (-8%) | 2.70 | 2.45 |
| object | user Mcycles 8 | **5.1** (+4%) | 4.9 (+0%) | 4.9 | 5.4 |
| object | times | **1.09** (+5%) | 1.05 (+1%) | 1.04 | 1.19 |
| object | kernel Mcycles 1 | **3.3** (-38%) | **3.3** (-38%) | 5.3 | 3.8 |
| object | kernel Mcycles 8 | 7.6 (-3%) | **7.4** (-5%) | 7.8 | 8.1 |
| start | ms 1 | **0.28** (+4%) | 0.27 (+0%) | 0.27 | 0.28 |
| start | user Mcycles 1 | 1.1 (+0%) | **1.0** (-9%) | 1.1 | 1.3 |
| start | kernel Mcycles 1 | **8.4** (+11%) | 7.7 (+1%) | 7.6 | 7.4 |
| start | kernel Mcycles 8 | **41.6** (+16%) | **40.6** (+13%) | 35.9 | 38.2 |

- **The times, the user cycles, the inflation and the faults hold** but in the object's and the start's rows (under
  3 ms and 6 M cycles a compile, where a table's last digit is a few percent) and `select`'s time at eight in run 2.
- **The kernel cycles of the stages that have few don't.** The misses are cells of 0.8 to 41.6 M cycles; every kernel
  cell above them holds (`parse` and `check-input` at eight, and both totals, which equal the counted medians by
  construction). A stage's kernel cycles are the sampled ones less the sampling's own (its kernel cycles a sampled
  cycle, the sampled total less the counted median, times the stage's cycles), a difference that the runs' own spread
  moves by a few million cycles. The record's two measurements differ by more than 3% on 11 of the 14 kernel cells run 1
  misses (up to 86%), and the gauge's two runs agree with each other better than the record's two on 10 of them.
- **The start's kernel cycles at eight** (41.6 and 40.6 M against 35.9) are the exit and the exit helper's teardown.
  The record's one sampled cohort of them had short teardowns: 3.36 ms a run from the exit to the reap, where its own
  counted cohorts had 4.76 ms, and the gauge's had 4.50 and 4.89 counted and 4.91 sampled. The gauge's six sampled
  rounds are the representative figure.

So the gauge reproduces the record wherever the record reproduces itself. The gate as written holds for the times, the
user cycles, the inflation, the faults and the whole compile, and not for the kernel cycles of individual stages under
a few tens of millions of cycles; a later step's gate on one of those needs a band wider than 3% or another method.

## Reproducing the tables

```sh
cc -std=c17 -O2 -Wall -Wextra -Werror -o allcore scripts/allcore.c
for run in run1 run2; do
    cp -r raw/$run /tmp/$run
    for part in counted sampled; do tar -xzf /tmp/$run/$part/stages.tar.gz -C /tmp/$run/$part; done
    ./allcore table --out /tmp/$run --bytes 9507037 > /tmp/$run/table.txt
    ./allcore compare --out /tmp/$run --record ../all-core-rerun-2536-2026-11-12/tables --record-raw ../all-core-rerun-2536-2026-11-12/raw --bytes 9507037 > /tmp/$run/compare.tsv
done
```

Every file in `tables/run1` and `tables/run2` (but `first-reduction/`) comes out byte for byte.

## Limits

- **Two runs, one hour, one host state.** The spread between the gauge's two runs is what this record says of its
  repeatability; the host's state on another day moves both.
- **The kernel cycles by stage** inherit the record's method and its resolution, above.
- **No DRAM traffic and no other counters.** The record's stage table also has the cycles with a load not complete, the
  demand fills from DRAM and the bytes the memory controllers moved; the gauge measures none of them (its guide says
  why for the controllers).
- **The anchors** are the record's (the first sample in `parse_`, `check_input` and `tier0_generate` functions, less the
  stages before each); a stage's boundary is as exact as they are. The clock started 0.34 to 0.42 ms after a run's
  start alone and 0.62 to 0.71 at eight (the rounds' medians; the record: 0.375 and 0.633), with a run's estimates
  usually within 0.33 ms of each other alone and 1.3 ms at eight. In three of the 24 cohorts one run's estimates spread
  10.4 to 17.2 ms: one anchor's first sample came a stage early, and the median of three left it out.

## Files

- `scripts/`: `allcore.c` (as committed in buster), `allcore-run1.c` and `allcore-run2.c` (as run), `gate.sh`,
  `queue.sh`, `lock.sh`, and `SHA256SUMS` of them all.
- `raw/run1`, `raw/run2`: the host's state (`env.txt`), the hashes as run (`SHA256SUMS`: the tool's source, its binary,
  the executable), the holds and their holders, the queue's log, each part's log, and for each part every cohort's rows,
  strays and (sampled) buckets, with every run's stage report in `stages.tar.gz`.
- `tables/run1`, `tables/run2`: `table.tsv`, `whole.tsv`, `table.txt` (both, as `table` prints them), `compare.tsv`,
  and `first-reduction/`.
