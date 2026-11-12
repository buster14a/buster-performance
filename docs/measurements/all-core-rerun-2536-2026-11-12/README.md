# The all-core record measured again without the stray process (buster#2536, 2026-11-12)

[`all-core-design-672-2026-11-12`](../all-core-design-672-2026-11-12/), the record behind
[buster#2536](https://github.com/buster14a/buster/issues/2536)'s design, was measured from 10:49 to 12:54 UTC on 12
November beside a stray test program that looped at 100% of a CPU outside the lock
([buster#2555](https://github.com/buster14a/buster/issues/2555) has its account). It was killed at 13:51:28. This
record runs every one of that record's scripts again on the same host, from 14:23 to 15:24 UTC, with the same
executable, the same inputs and the same reductions, and says what the stray had changed.

**In short.** One worker is unchanged. The stray changed four things:

1. **Two workers' page state.** It was one more runnable task in `/proc/loadavg`, which put a two-worker cohort over
   the compiler's busy-host test (#1561's: runnable tasks at least a quarter of the 15 online CPUs). The first record's
   two-worker compiles took base pages (70 of 72); without the stray, 46 of 72 take huge pages and run 13% faster.
   What a compile costs in either state is unchanged.
2. **Four, eight and fifteen workers cost each compile 2% to 4% more user cycles and 7% to 10% more kernel cycles**
   without it. Its slowed worker, which the first record left out, had left the others a lighter host, and it held
   back the package's frequency by 1.3%. At eight workers: 288.8 MB/s against 295.4; 1,350 M cycles a compile against
   1,297 M, 1.97 times one compile alone, where the first record had 1.89.
3. **musl's eight-way rows** (eight lanes, eight commands, eight processes) run 3% to 11% faster without it.
4. **The rate over a cohort's span** (DRAM GB/s, and fifteen workers' throughput) was stretched by the worker that
   shared a CPU with it.

The bytes a compile moves through DRAM (146 a source byte), the ceiling of the bus, the instructions, and the shape of
every by-stage and by-family table are as the first record has them. The model's conclusions hold: the windows and the
node machine each roughly double eight workers' throughput, and 1 GB/s takes both.

## What was run

- **The executable** is the first record's own build of buster `4c8c3c9c154640c2edb81271bcd5dc987f2cfa93`, SHA-256
  `8e609253fe92c1329edabfc830617aba0ac82a7550911a2dc1b623ba5958d793`, as a reflinked copy (the same bytes, another
  inode) in this record's own work directory on the host. `allcore` is the first record's binary (SHA-256 `e6f111af…`,
  built from its `tools/allcore.c`, `03bc0268…`). `env.txt` has both hashes as read after the last run.
- **The scripts** are the first record's, byte for byte (`scripts/SHA256SUMS`; the first record's `scripts/` has them),
  but for `lock.sh`, whose owner, title and link name this re-measurement. Four were added, in `scripts/`:
  `reduce.sh` (`finish.sh` without its `rebucket.sh`: the buckets were just made by the same reducer), `retime.sh`
  (the one-worker timeline again; see "What disturbed the runs"), `rss.sh` (the peak's check below) and `after.sh`
  (starts the second queue when the first ends).
- **The inputs** are the first record's files, copied from its work directory and checked against the hashes in its
  `raw/units/` (`sqlite3.i`, `sqlite3-spine.i`, `musl.all.txt`, `musl.p0.txt` to `musl.p7.txt`): all matched.
- **The host's settings were as the first record found them** (`env.txt`: Linux 6.18.50, clang 23.1.1, perf 7.2.9;
  CPU 2 `performance`, every other CPU `powersave` with `balance_performance`, CPU 10 offline, transparent huge pages
  `always`). The governors' lines are identical to the first record's.
- **The queues** (`raw/queues/`): `q.txt`'s 43 lines are every run of the first record but its build and `units.sh`,
  in the first record's rounds (baseline 6, sets, pages, musl, latency and spine 3 each, the two timelines, the four
  ceilings, the 9 sampled cohorts, the 5 musl samples), then `reduce.sh`; `q2.txt` is `retime.sh`, `rss.sh` and
  `reduce.sh`. Each line was one hold of the lock with 20 s between holds; every one exited 0, and every holder file is
  this re-measurement's (`*holder.txt`, 45 holds).
- **No stray:** all 170 strays files (the foreign processes above half a CPU, before and after each cohort) are empty.
  So `tables.sh` left no worker out of any median (`kept_workers` equals the workers everywhere), and the sampled
  reductions say `without -`.
- **The tables reproduce:** the record's own reducer, rebuilt from `tools/allcore.c` off the host, makes all 42 tables
  in `tables/` from `raw/` byte for byte, and makes all 42 of the first record's from its `raw/`.

## 1. The baseline

Per compile, the first record's figure → this one's (`tables/baseline.tsv`; medians of six rounds, interior runs):

| workers | MB/s | wall ms | user cycles | kernel cycles | L2 fills from DRAM | peak RSS | faults | GHz |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1, CPU 2 | 74.26 → 73.17 | 124.98 → 124.99 | 602.4 → 601.5 M | 84.4 → 85.0 M | 13.11 → 13.08 M | 236.7 → 241.0 MB | 7,461 → 7,404 | 5.54 → 5.55 |
| 1, CPU 5 | 74.10 → 75.25 | 125.94 → 125.50 | 602.8 → 602.4 M | 84.4 → 83.1 M | 13.06 → 13.10 M | 236.7 → 241.0 MB | 7,460 → 7,404 | 5.50 → 5.51 |
| 2 | 113.56 → 125.59 | 164.33 → 143.12 | 722.5 → 679.6 M | 164.0 → 100.0 M | 13.91 → 14.95 M | 190.5 → 236.7 MB | 63,081 → 7,460 | 5.51 → 5.52 |
| 4 | 198.93 → 198.77 | 183.39 → 188.00 | 802.4 → 822.7 M | 182.6 → 194.9 M | 15.11 → 15.07 M | 190.7 → 195.2 MB | 63,006 → 62,964 | 5.47 → 5.50 |
| 8 | 295.39 → 288.78 | 252.28 → 259.00 | 1,044.7 → 1,074.4 M | 251.8 → 275.6 M | 15.23 → 15.29 M | 190.7 → 195.2 MB | 62,996 → 62,982 | 5.21 → 5.28 |
| 15 | 323.10 → 321.13 | 432.97 → 446.69 | 1,802.7 → 1,870.7 M | 392.3 → 420.8 M | 15.60 → 15.63 M | 190.7 → 195.2 MB | 62,994 → 62,970 | 5.14 → 5.21 |

- **Kept workers:** the first record kept 2.83 of four (two cores left out in its round 4) and 7 of eight; this keeps
  all. Its throughput took a left-out worker's rate as the others' mean; re-reduced with every worker kept, its own
  rows give 188.9 MB/s at four workers and 291.1 at eight.
- **Every round agrees.** The six rounds at eight workers span 1,059 to 1,080 M user cycles and 263 to 283 M kernel
  cycles, where the first record's span 1,038 to 1,052 M and 249 to 265 M: in user cycles no round of one reaches the
  other's, and in kernel cycles one does.
- **Eight workers:** 3.95 times one worker's throughput (3.98); each compile costs 1.79 times the user cycles (1.73),
  3.24 times the kernel's (2.98) and 1.97 times both (1.89): 1,350.0 M against 686.5 M. Fifteen workers are 11% more
  than eight (9%).
- **1 GB/s** is a slot of 76.1 ms a compile: 401 M cycles at 5.278 GHz, where today's 1,350 M is 3.4 times that (396 M
  at 5.205 GHz and 3.3 times).
- **The peaks' 4.2 to 4.7 MB more** in every row are the executable's file, not the compile: `rss.sh` compiled on
  CPU 2 with the first record's own file and with this copy, alternately, two rounds of six, and the first gives
  236.7 MB and 7,455 to 7,457 faults where the copy gives 240.9 MB and 7,432 to 7,443, for the same cycles (599.8 to
  603.5 M) and the same object (`raw/rss/`). The faults are otherwise unchanged.
- The objects are the same bytes at every worker count (`raw/baseline/r*/objects.txt`).

### Two workers: the page state

`--time-stages` reports each compile's page decision. Split by it, over the six rounds (interior runs):

| two workers, a compile | runs | wall ms | user cycles | kernel cycles | peak RSS | faults |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| first record: busy, base pages | 70 of 72 | 164.3 | 722.4 M | 164.0 M | 190.5 MB | 63,084 |
| this one: not busy, huge pages | 46 of 72 | 141.9 | 677.2 M | 96.7 M | 240.9 MB | 7,457 |
| this one: busy, base pages | 26 of 72 | 163.9 | 722.7 M | 166.1 M | 195.1 MB | 63,016 |

`arena_host_busy` (`lane.c`) calls the host busy when its runnable tasks, the compile's own among them, are at least a
quarter of the online CPUs: 4 of 15. Two compiles are 2; the stray made 3, and any fourth task (the runner, a kernel
thread, `perf`) made the host busy. Without it, a fourth and a fifth are needed, and 26 of 72 still found them. Of
the first record's 72 one-worker compiles, 3 found the host busy (in rounds 4 and 5: the compile, the stray and two
more, one of them another session's `git` in round 4); here none of 72 did. The two-worker row of the first record is
the base-page state the stray chose, and so is its "from two workers on, a compile finds the host busy": that holds
from four.

## 2. The other counters at one worker and at eight

`tables/sets-*.tsv`; per compile:

| | 1 worker | 8 workers |
| --- | ---: | ---: |
| user cycles (`ls_not_halted_cyc`) | 601.1 → 601.6 M | 1,033.7 → 1,067.4 M |
| … with a load not complete at retirement | 248.3 → 248.9 M | 638.8 → 668.2 M |
| ops dispatched; retired | 1,716 → 1,715 M; 1,267 → 1,267 M | 1,739 → 1,740 M; 1,283 → 1,283 M |
| dispatch slots: no ops from the frontend; backend stalls | 1,185 → 1,182 M; 1,914 → 1,912 M | 1,610 → 1,619 M; 4,929 → 5,153 M |
| backend stalls' share of the slots | 39.7% → 39.7% | 59.1% → 60.4% |
| L1D demand fills: all; from the L3; from DRAM | 11.34 → 11.38 M; 1.20 → 1.22 M; 1.43 → 1.43 M | 10.93 → 10.93 M; 0.77 → 0.81 M; 2.95 → 3.01 M |
| L2 fills from the L3, user | 8.62 → 8.68 M | 2.50 → 2.44 M |
| L2 fills from DRAM: user; kernel | 7.97 → 7.99 M; 5.07 → 5.10 M | 10.16 → 10.15 M; 5.15 → 5.09 M |
| the prefetcher's L1D fills from DRAM | 0.74 → 0.74 M | 1.94 → 1.97 M |
| mispredicted branches | 3.62 → 3.62 M | 3.70 → 3.70 M |

419 M of the 466 M more user cycles have a load not complete (390 M of 433 M).

An L3 miss's sampled latency (`tables/latency.tsv`), the three rounds:

| | idle | 1 worker | 2 | 4 | 8 | 15 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| first record, ns | 82, 83, 94 | 116, 115, 115 | 101, 104, 104 | 114, 116, 115 | 146, 147, 145 | 160, 159, 162 |
| this one, ns | 79, 79, 79 | 117, 115, 116 | 127, 127, 138 | 120, 120, 119 | 150, 150, 150 | 166, 166, 166 |
| L3 lookups that miss, this one | 19% to 26% | 59% | 69% to 70% | 80% | 85% | 85% to 86% |
| user cycles with a load not complete, a compile | | 248.9 → 249.2 M | 360.4 → 311.7 M | 432.5 → 445.4 M | 647.3 → 668.0 M | 1,244.1 → 1,313.5 M |

The two workers' latency is their huge pages' (the same page state as alone, with a neighbour).

## 3. DRAM traffic

`tables/baseline-umc.tsv`, less each round's idle control; the medians of the six rounds (the first record's of its
exact rounds, r3 to r5, as its section 3 has them):

| workers | read, MB a compile | written | bytes a source byte | GB/s over the cohort's span | the data bus in use |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | 887 → 875 | 495 → 507 | 146 → 145 | 10.6 → 11.0 | 13% → 13% |
| 2 | 907 → 948 | 379 → 480 | 135 → 150 | 15.5 → 18.5 | 18% → 22% |
| 4 | 971 → 972 | 399 → 397 | 144 → 144 | 24.0 → 28.7 | 28% → 34% |
| 8 | 978 → 983 | 406 → 406 | 146 → 146 | 38.2 → 42.0 | 46% → 50% |
| 15 | 999 → 1,008 | 418 → 414 | 149 → 150 | 37.8 → 46.1 | 45% → 55% |

- A compile moves the same bytes. The cohort's rate over its span is what changed: the first record's slowed worker
  stretched its spans, as it said.
- `timeline.sh`'s eight-worker cohort, the controllers read every 2 ms (`raw/timeline/`): 42.6 GB/s over the time
  all eight run (42.1 by the same reduction of the first record's), an interval median of 43.5 GB/s (41.5) and a 90th
  percentile of 52.4 (51.7). 42.6 GB/s over 146 bytes a byte is 292 MB/s, against 288.8 measured: #672's model holds.
- **The ceiling** (`tables/ceiling.tsv`) is unchanged: on eight cores 55.3 GB/s reading (55.3), 52.0 with ordinary
  stores (52.0), 27.7 non-temporal (27.6), 57.3 copying (55.9); on one core 47.8, 45.9, 26.9 and 51.1, as before.

## 4. The inflation by stage

`tables/inflation-sq.tsv`; per compile, one worker → eight, the first record's line above this one's:

| stage | ms | user cycles, M | times | with a load not complete, M | kernel cycles, M | demand fills from DRAM, k | faults at 8 | DRAM MB |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| preprocess | 9.66 → 15.59<br>9.68 → 15.70 | 43.1 → 60.2<br>43.2 → 60.3 | 1.39<br>1.40 | 8.7 → 23.3<br>8.9 → 23.7 | 10.2 → 17.5<br>10.0 → 18.7 | 15 → 57<br>13 → 53 | 5,643<br>5,639 | 93 → 80<br>96 → 80 |
| parse | 7.28 → 23.03<br>7.25 → 24.50 | 22.9 → 69.4<br>23.0 → 78.8 | 3.03<br>**3.43** | 3.9 → 44.3<br>4.0 → 53.7 | 17.0 → 41.7<br>17.3 → 46.9 | 12 → 204<br>11 → 230 | 10,430<br>10,430 | 178 → 141<br>183 → 151 |
| check-input | 46.10 → 101.77<br>46.10 → 106.27 | 219.0 → 401.8<br>217.9 → 421.3 | 1.84<br>1.93 | 94.7 → 244.6<br>94.1 → 259.5 | 33.9 → 115.6<br>33.1 → 127.7 | 762 → 1,138<br>770 → 1,257 | 33,433<br>33,430 | 602 → 558<br>609 → 576 |
| check-expressions | 11.47 → 20.52<br>11.43 → 20.92 | 58.4 → 85.3<br>58.1 → 86.6 | 1.46<br>1.49 | 19.9 → 42.9<br>19.4 → 44.2 | 4.9 → 15.5<br>5.0 → 17.8 | 38 → 119<br>37 → 129 | 6,650<br>6,649 | 98 → 111<br>102 → 113 |
| check-declarations, static-data | 2.47 → 4.07<br>2.50 → 3.92 | 12.6 → 17.0<br>12.6 → 18.8 | 1.35<br>1.49 | 7.1 → 11.6<br>7.2 → 13.4 | 1.0 → 3.3<br>1.0 → 3.6 | 53 → 59<br>46 → 58 | 549<br>549 | 37 → 27<br>34 → 25 |
| check-program | 23.91 → 45.50<br>23.87 → 46.47 | 128.4 → 226.6<br>128.6 → 232.2 | 1.76<br>1.81 | 68.7 → 157.5<br>68.9 → 163.4 | 2.2 → 6.3<br>1.9 → 9.1 | 380 → 747<br>381 → 824 | 2,546<br>2,546 | 208 → 251<br>214 → 252 |
| select | 1.06 → 2.65<br>1.09 → 2.84 | 5.0 → 11.4<br>5.0 → 12.1 | 2.30<br>2.43 | 2.5 → 8.3<br>2.5 → 8.6 | 0.9 → 2.3<br>1.0 → 2.4 | 16 → 60<br>21 → 66 | 782<br>782 | 13 → 16<br>12 → 15 |
| lower | 11.42 → 19.65<br>11.47 → 19.77 | 61.0 → 101.4<br>61.7 → 98.3 | 1.66<br>1.59 | 25.9 → 64.1<br>26.8 → 61.4 | 1.7 → 2.6<br>1.6 → 4.2 | 95 → 234<br>97 → 255 | 2,147<br>2,147 | 69 → 101<br>71 → 88 |
| the emission, `tier0` to `code-atoms` | 8.56 → 12.26<br>8.57 → 12.18 | 46.1 → 64.3<br>45.6 → 59.3 | 1.39<br>1.30 | 12.7 → 28.5<br>12.3 → 24.3 | 1.3 → 0.6<br>1.3 → 1.5 | 39 → 96<br>37 → 95 | 299<br>298 | 33 → 54<br>32 → 51 |
| the object | 1.43 → 2.45<br>1.45 → 2.70 | 4.5 → 5.4<br>4.7 → 4.9 | 1.19<br>1.04 | 1.2 → 2.7<br>1.3 → 2.3 | 3.8 → 8.1<br>5.3 → 7.8 | 7 → 17<br>8 → 21 | 37<br>37 | 11 → 10<br>13 → 9 |
| the process's start and end | 0.28 → 0.33<br>0.27 → 0.31 | 1.3 → 1.9<br>1.1 → 1.8 | 1.51<br>1.70 | 0.4 → 0.7<br>0.3 → 0.7 | 7.4 → 38.2<br>7.6 → 35.9 | 1 → 2<br>2 → 2 | 392<br>382 | 22 → 25<br>20 → 27 |
| whole compile | 123.64 → 247.82<br>123.68 → 255.58 | 602.4 → 1,044.7<br>601.5 → 1,074.4 | 1.73<br>1.79 | 245.8 → 628.5<br>245.9 → 655.1 | 84.4 → 251.8<br>85.0 → 275.6 | 1,419 → 2,733<br>1,421 → 2,991 | 62,908<br>62,889 | 1,364 → 1,374<br>1,386 → 1,387 |

- One worker's figures repeat within about 1%. At eight workers the stages that scatter over the unit inflate a
  little more than the first record measured (the parse 3.43 times, `check-input` 1.93, `check-program` 1.81) and the
  ones that stream or stay in a function as before or less (the lowering 1.59, the emission 1.30).
- **The kernel at eight workers**, by function (both modes' sampled cycles a compile, before the correction):
  `_raw_spin_lock` 57 → 56 M, `do_anonymous_page` 51 → 53 M, `clear_page_erms` 44 → 52 M, `lock_vma_under_rcu` 32 →
  33 M, `asm_exc_page_fault` 21 → 21 M, `native_queued_spin_lock_slowpath` 22 → 15 M, `folio_remove_rmap_ptes` 13 →
  14 M. Alone, `clear_page_erms` is 57 M (59). The clearing still doesn't grow.

## 5. The page policy apart from the load

`tables/pages-*.tsv`, `pages-umc.tsv`; per compile:

| | wall ms | user cycles | kernel cycles | load not complete | L1D demand fills from DRAM | faults | DRAM MB | MB/s |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 worker, huge pages (main) | 125.0 → 125.0 | 602.4 → 601.5 M | 84.4 → 85.0 M | 248.3 → 248.9 M | 1.43 → 1.43 M | 7,461 → 7,404 | 1,388 → 1,380 | 74.3 → 73.2 |
| 1 worker, base pages | 150.2 → 149.2 | 659.9 → 658.7 M | 155.1 → 156.6 M | 303.2 → 301.5 M | 1.37 → 1.37 M | 62,990 → 62,990 | 1,150 to 1,307 → 1,155 to 1,184 | 62.5 → 62.6 |
| 8 workers, base pages (main) | 252.3 → 259.0 | 1,044.7 → 1,074.4 M | 251.8 → 275.6 M | 638.8 → 668.2 M | 2.95 → 3.01 M | 62,996 → 62,982 | 1,385 → 1,389 | 295.4 → 288.8 |
| 8 workers, huge pages | 282.7 → 289.4 | 1,206.3 → 1,239.5 M | 276.6 → 278.5 M | 791.7 → 814.2 M | 3.53 → 3.54 M | 7,465 → 7,460 | 1,727 → 1,733 | 272.1 → 267.2 |

With the pages the same on both sides, eight workers cost 1.63 times the user cycles (1.58) and 1.76 times the
kernel's (1.62) in base pages, and 2.06 (2.00) and 3.28 (3.28) in huge pages. #1561's policy is worth 8.1% at eight
workers (8.6%).

## 6. The bodies and the file scope

`tables/spine-*.tsv`, `stages-whole.*`, `stages-spine.*`; per compile:

| | whole, 1 | without bodies, 1 | whole, 8 | without bodies, 8 |
| --- | ---: | ---: | ---: | ---: |
| wall ms | 117.2 → 116.9 | 18.9 → 18.9 | 243.6 → 245.8 | 36.2 → 36.7 |
| user cycles | 563.3 → 562.2 M | 74.3 → 74.3 M | 1,006.0 → 1,021.9 M | 123.2 → 126.3 M |
| kernel cycles | 80.3 → 81.3 M | 26.4 → 26.9 M | 247.1 → 258.4 M | 52.7 → 55.5 M |
| load not complete | 239.1 → 236.9 M | 19.3 → 19.2 M | 636.1 → 656.9 M | 61.3 → 63.7 M |
| peak RSS | 228.5 → 233.2 MB | 84.9 → 89.4 MB | 180.5 → 185.2 MB | 43.8 → 48.4 MB |
| DRAM MB | 1,344 → 1,343 | 223 → 222 | 1,364 → 1,362 | 182 → 179 |

The bodies are 86% of a compile's cycles at eight workers and 84% alone, as before; the file scope alone inflates
1.70 times in user cycles (1.66). By stage (the reports' `process total`, 116.1 → 115.8 ms alone and 240.0 → 242.3 at
eight): the bodies' part of `check-input` to `lower` is 81.5 ms alone and 167.4 at eight (81.3 and 166.2); of the
parse 5.6 and 20.8 (5.6 and 19.0); of the emission 8.3 and 12.2 (8.4 and 12.4).

**By family of function** (`tables/families-bodies.tsv`), the bodies' user cycles a body token:

| family | alone | at eight | times |
| --- | ---: | ---: | ---: |
| the parser and the tree's columns | 44.1 → 43.7 | 140.9 → 144.4 | 3.19 → 3.30 |
| libc: `memset`, `memmove`, `memcmp` | 26.8 → 25.5 | 50.9 → 44.2 | 1.90 → 1.74 |
| the program and its controls | 127.0 → 126.0 | 235.7 → 225.5 | 1.86 → 1.79 |
| the reader's other functions | 159.9 → 157.1 | 283.1 → 285.8 | 1.77 → 1.82 |
| the graph's construction | 99.4 → 98.0 | 174.3 → 175.9 | 1.75 → 1.80 |
| the type table | 4.3 → 5.0 | 7.1 → 8.0 | 1.64 → 1.60 |
| warnings | 124.2 → 123.3 | 198.1 → 205.7 | 1.59 → 1.67 |
| initializers and static data | 23.9 → 24.3 | 37.6 → 39.9 | 1.57 → 1.64 |
| the lowering | 93.1 → 93.0 | 141.8 → 142.5 | 1.52 → 1.53 |
| the C rules for a node | 29.6 → 31.8 | 39.9 → 41.2 | 1.35 → 1.30 |
| the graph run and its loop | 53.8 → 52.0 | 64.9 → 66.6 | 1.21 → 1.28 |
| the emission | 74.5 → 75.8 | 90.0 → 90.9 | 1.21 → 1.20 |
| all | 883.3 → 879.1 | 1,561.3 → 1,570.2 | 1.77 → 1.79 |

## 7. musl five ways

`tables/musl-pass.tsv`, `musl.tsv`, `musl-umc.tsv`; per pass over the 1,336 units, each column's median round:

| way | pass ms | units/s | user cycles | kernel cycles | L2 fills from DRAM | minor faults | DRAM read + written |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| one command, one lane | 1,072 → 1,054 | 1,246 → 1,268 | 4,816 → 4,774 M | 1,101 → 1,050 M | 10.3 → 7.6 M | 343,109 → 343,084 | 1.18 + 0.37 → 1.00 + 0.29 GB |
| one command, 8 lanes | 222 → 207 | 6,016 → 6,444 | 5,812 → 5,676 M | 2,295 → 2,265 M | 47.8 → 47.9 M | 326,797 → 327,488 | 3.10 + 1.79 → 3.12 + 1.77 GB |
| 8 commands, one lane each | 218 → 212 | 6,131 → 6,313 | 5,479 → 5,219 M | 1,501 → 1,417 M | 39.1 → 39.1 M | 392,180 → 386,350 | 2.63 + 1.25 → 2.57 + 1.25 GB |
| a process a unit, one at a time | 2,300 → 2,217 | 581 → 603 | 5,894 → 5,812 M | 4,319 → 4,072 M | 44.8 → 36.0 M | 855,089 → 805,820 | 4.4 + 2.3 → 3.6 + 1.6 GB |
| a process a unit, 8 at a time | 457 → 405 | 2,922 → 3,297 | 7,033 → 6,712 M | 5,621 → 5,342 M | 91.5 → 87.8 M | 1,777,589 → 1,743,541 | 7.2 + 3.7 → 6.9 + 3.7 GB |

- The three rounds of each eight-way row are all faster than the first record's: eight lanes 207, 220 and 207 ms
  (218, 242 and 222), eight commands 210, 212 and 218 (218, 217 and 224), eight processes 408, 405 and 404 (457, 456
  and 457).
- **Eight lanes are 5.1 times one lane** (4.8) for 1.36 times the cycles (1.37): the user cycles 1.19 times (1.21),
  the kernel's 2.16 (2.08).
- **Lanes against processes:** the eight commands take 2% longer than the lanes (the first record had them 2% faster)
  for 16% fewer cycles (14%): 0.92 times the lanes' user cycles and 0.63 times their kernel cycles. The lanes pay 848 M
  kernel cycles a pass more (794) and 457 M user cycles (333): 1.20 times the commands' cycles (1.16).
- **A process a unit** costs 1.70 times the cycles of one command alone (1.73) and 2.07 times at eight at a time
  (2.14), and takes 1.95 times as long as the command on lanes (2.06). A unit's own compile as a process costs 1.15
  times the user cycles at eight at a time (1.19).
- **One lane** has 26% fewer L2 fills from DRAM (7.6 M a pass against 10.3) and a process a unit one at a time 20%
  fewer, both on CPU 2, for 1% fewer user cycles; `sqlite3.c` alone has the same fills (13.08 M against 13.11). musl's
  units fit in the L3, where any other running program's lines evict theirs; this record doesn't say what evicted
  them on the first one's host.

**By family of function** (`tables/musl-families.tsv`, sampled user cycles a pass, one cohort each):

| family | one lane | 8 lanes | times |
| --- | ---: | ---: | ---: |
| the reader's other functions | 1,489.3 → 1,488.8 M | 1,615.2 → 1,621.5 M | 1.08 → 1.09 |
| the preprocessor and the lexer | 804.6 → 817.4 M | 1,001.7 → 1,000.1 M | 1.24 → 1.22 |
| the emission | 324.9 → 330.3 M | 341.0 → 343.3 M | 1.05 → 1.04 |
| the parser and the tree's columns | 279.3 → 287.6 M | 301.0 → 304.0 M | 1.08 → 1.06 |
| libc: `memset`, `memmove`, `memcmp` | 239.2 → 247.6 M | 325.8 → 338.2 M | 1.36 → 1.37 |
| the graph's construction | 224.5 → 224.7 M | 254.8 → 258.6 M | 1.13 → 1.15 |
| warnings | 175.5 → 180.1 M | 192.8 → 195.3 M | 1.10 → 1.08 |
| the program and its controls | 164.9 → 172.3 M | 186.7 → 190.6 M | 1.13 → 1.11 |
| the lowering | 102.1 → 105.3 M | 127.3 → 128.6 M | 1.25 → 1.22 |
| the type table | 98.4 → 104.0 M | 102.3 → 103.3 M | 1.04 → 0.99 |
| initializers and static data | 96.0 → 96.6 M | 102.0 → 103.0 M | 1.06 → 1.07 |
| the graph run and its loop | 80.5 → 83.2 M | 87.5 → 90.2 M | 1.09 → 1.08 |
| the C rules for a node | 63.7 → 65.4 M | 73.3 → 75.6 M | 1.15 → 1.16 |
| rest | 570.6 → 577.5 M | 626.8 → 616.3 M | 1.10 → 1.07 |
| samples at the kernel's addresses | 184.7 → 186.1 M | 356.0 → 388.9 M | 1.93 → 2.09 |
| all | 4,898.2 → 4,966.9 M | 5,694.2 → 5,757.5 M | 1.16 → 1.16 |

**The kernel's families**, both modes' sampled cycles a pass:

| family | one lane | 8 lanes | 8 commands |
| --- | ---: | ---: | ---: |
| page faults | 456 → 458 M | 572 → 573 M | 628 → 646 M |
| pages given back (`madvise`, unmapping) | 285 → 286 M | 417 → 403 M | 416 → 431 M |
| TLB flushes sent to other CPUs | 12 → 13 M | 663 → 776 M | 14 → 15 M |
| spin locks | 162 → 162 M | 216 → 220 M | 215 → 236 M |
| clearing pages | 85 → 86 M | 183 → 192 M | 88 → 99 M |
| writeback of the written files | 27 → 35 M | 208 → 64 M | 22 → 91 M |
| sleeping locks (the address space's) | 5 → 6 M | 34 → 39 M | 8 → 9 M |
| other kernel | 292 → 310 M | 693 → 562 M | 439 → 472 M |

The writeback figures move with when the btrfs threads run, not with the compile: one cohort each, as the first
record said of its own.

## 8. The model

`tables/model.tsv`, the first record's `tools/model.awk` over this record's inputs (`tables/model-inputs.tsv`). Its
rules and assumptions are the first record's; only the measured inputs changed. Eight workers on `sqlite3.c`, MB/s
(times today's rate):

| | conservative | expected | optimistic |
| --- | ---: | ---: | ---: |
| today | 295 → 289 | 295 → 289 | 295 → 289 |
| this design, step 1 | 303 → 294 | 307 → 298 (1.03) | 312 → 303 |
| step 2 | 333 → 325 | 345 → 336 (1.16) | 366 → 356 |
| step 3 | 415 → 412 | 444 → 441 (1.53) | 498 → 493 |
| step 4 | 483 → 489 | 531 → 538 (1.86) | 623 → 631 |
| step 5 | 501 → 509 | 558 → 567 (1.96) | 671 → 681 |
| the node machine alone, its step 2 | 382 → 373 | 405 → 395 (1.37) | 417 → 407 |
| its step 3 | 411 → 400 | 460 → 448 (1.55) | 499 → 485 |
| its step 4 | 510 → 500 | 634 → 620 (2.15) | 768 → 751 |
| both: step 2 here, the machine's step 2 | 415 → 405 | 451 → 439 (1.52) | 482 → 468 |
| step 2 here, the machine's step 3 | 437 → 425 | 491 → 476 (1.65) | 535 → 517 |
| step 3 here, the machine's step 4 | 611 → 602 | 743 → 727 (2.52) | 884 → 859 |
| step 4 here, the machine's step 4 | 772 → 781 | 1,020 → 1,032 (3.57) | 1,376 → 1,392 |
| step 5 here, the machine's step 4 | 821 → 834 | 1,125 → 1,144 (3.96) | 1,629 → 1,660 |

What the designs leave a compile, expected: the windows alone 708 M cycles (709), the node machine alone 628 M (603),
both 385 M (384), against a slot of 401 M (396). 1 GB/s still takes both, and neither alone reaches it in its
optimistic case.

## What disturbed the runs

- **The one-worker timeline, first run** (`raw/timeline/first-w1/`, 14:56 UTC): the controllers counted 1,542 MB a
  compile where the baseline's count 1,380 for the same compile, with 370 k read commands in the intervals between
  runs (71 k in the first record's) and a burst in its first 100 ms. The controllers count the whole host; no foreign
  process was above half a CPU. `retime.sh` ran it again at 15:22 (1,386 MB a compile, 80 k between runs), and the
  tables use that one.
- **Baseline round 0's one-worker cohort** read 1,273 MB a compile, the first runs of the copied executable (its file
  read into the page cache); its other rounds read 870 to 880. The medians are of six rounds.
- **The host was shared** with another session's holds of the lock (each of this record's holds waited for its turn);
  nothing ran beside a hold but kernel threads, as the strays files say.
- **Peaks** are 4.3 to 4.5 MB above the first record's: the executable's file (section 1).

## Limits

- **Same day, same host, same revision, another hour.** Nothing else separates the two records but the stray and the
  executable's inode; whatever else changed on the host between 11:00 and 15:00 UTC is in the difference too.
- **The sampled tables are one cohort a group,** as in the first record: their small differences (a stage's few
  percent) are within what one cohort varies.
- **Physical-traffic figures are conditional** on buster-performance#49, as the first record's are.
- **The model is not a measurement.**

## Files

- `README.md`, `env.txt` (the host after the last run; its `git` line fails because the executable's directory holds
  no clone: the source is the first record's), `tables.md`, `tables/` (as `reduce.sh` made them on the host).
- `scripts/`: the scripts this record changed or added, and `SHA256SUMS` of every script and binary as run.
- `raw/`: `COMMIT`, `queues/`, and a directory a script as the first record's `raw/` has them (`baseline/r0`–`r5`,
  `sets/`, `pages/`, `spine/`, `latency/`, `musl/` `r0`–`r2`, `ceiling/`, `timeline/` with `first-w1/`,
  `sampled/`, `muslsampled/`), and `rss/`. Each run's `--time-stages` reports are in `stages.tar.gz` beside its rows.
  The samples' text (`perf script`'s) stayed on the host.
