# What eight workers cost a compile, stage by stage: the measurements behind buster#2536's design (2026-11-12)

These are the measurements that [buster#2536](https://github.com/buster14a/buster/issues/2536)'s design
(`docs/all-core-path.md` in buster) rests on, taken for
[buster#672](https://github.com/buster14a/buster/issues/672)'s all-core target: eight workers on the 9700X. They
compare a compile of the frozen `sqlite3.c` alone with the same compile beside seven others (and beside one, three and
fourteen), stage by stage and by family of function, with the memory controllers' own counts of the DRAM traffic; they
do the same for the unit without its function bodies; and they compile musl's units five ways, on lanes and as
processes. Section 12 is a model over those tables of what the designs in hand would leave. Nothing here measures
the design itself: it isn't built.

- **Source:** buster `4c8c3c9c154640c2edb81271bcd5dc987f2cfa93` (main on 12 November), a clean clone built on the
  host by `./build.sh` (Release, the default host, debug information), `raw/build.log`, 89.5 s under the lock. The
  executable's SHA-256 is `8e609253fe92c1329edabfc830617aba0ac82a7550911a2dc1b623ba5958d793`.
- **Host:** the Ryzen 7 9700X (`benchpress`), Linux 6.18.50, clang 23.1.1, perf 7.2.9, 64 GB in two channels whose
  clock the controllers report as 2,595 MHz. `env.txt` has the kernel, the CPUs, the governors, transparent huge
  pages, the tools' versions and every script's and input's hash.
- **The host's settings were left as found**, and they are part of what was measured: CPU 2 runs the `performance`
  governor and every other CPU `powersave` with `balance_performance`; CPU 10 (CPU 2's second thread) is offline, so
  fifteen CPUs are online; transparent huge pages are `always`.
- **Every run was one hold of the machine's lock** (`scripts/lock.sh`; a cohort, or one round of cohorts, a hold),
  queued by `scripts/queue.sh` with 20 s between holds. Each script writes the lock's own line for its hold first
  (`holder.txt`). `raw/queues/` has the queues as they ran and their logs, whose times include the wait for the lock.
- **Workloads:** `-c --lanes 1` of the frozen corpus's `sqlite3.c` (SHA-256 `0a409f16…`, 9,507,037 bytes, 716,136
  preprocessed tokens) with the 9700X job's `compile_time` options; and the corpus's musl, the first source of each
  base name: 1,336 units, 5,039,561 tokens.
- **No third-party code was built or run on the host.** The only programs are the compiler, `perf` and
  `scripts/tools/allcore.c`, which is this record's own.

## The method

`scripts/tools/allcore.c` is the runner and every reducer (C17; `clang -std=c17 -O2 -Wall -Wextra -Werror`).

- **A cohort** (`allcore cohort`) is one worker a CPU, each pinned, all starting together (they spin to a common
  deadline), each running its command several times one after another as fresh processes. The workers' CPUs are one a
  physical core: CPU 2 for one worker (and CPU 5 as a second one-worker cohort, a `powersave` core), 2 and 3 for two,
  0 to 3 for four, 0 to 7 for eight, and every online CPU for fifteen.
- **Each run is counted by counters of its own** (`perf_event_open` on the child, enabled at its `exec`, inherited):
  the compiler's exit helper, which shares its address space and outlives it, is counted with it, and the runner is
  the helper's reaper (`PR_SET_CHILD_SUBREAPER`), so a run's row has when it exited and when its teardown ended.
  A row also has the run's resource use (`wait4`) and its orphans'. No counter set has more than five core events
  (the NMI watchdog holds the sixth), and every row's `counted` column is 100: nothing was multiplexed.
- **The counter sets** (`scripts/common.sh`, with perf's own encodings for the names): `basic` is user and kernel
  cycles and instructions, L2 fills from DRAM, APERF and MPERF; `td` the pipeline's dispatch slots; `lat` the cycles
  with a load not complete at retirement and the L1D demand fills by source; `mem` the L2 fills from DRAM by mode,
  from the L3, the prefetcher's fills from DRAM and the mispredicted branches.
- **A cohort's figure is the median over its interior runs**: every worker's runs but its first and its last, which
  the other workers' runs don't overlap as the runs between are. Rounds are pooled. The throughput is the workers'
  bytes over the cohort's span.
- **Counters by stage** (`scripts/sampled.sh`) are the one-core record's method
  ([`one-core-design-672-2026-11-12`](../one-core-design-672-2026-11-12/)) run on every worker's CPU at once: one
  cohort under `perf record -a -C` of a leader-sampled group (every 100,003 cycles) with sample times on
  `CLOCK_MONOTONIC`, the clock the cohort's rows are on; `allcore buckets` puts each sample in the run its CPU and
  time fall in and in the stage its time falls in, from that run's own `--time-stages` report. A report's times are
  relative, so each run's clock start is the median of three anchors (the first sample of `parse_`, of `check_input`
  and of `tier0_generate` against those stages' starts). The emission's stages (`tier0` to `code-atoms`) interleave
  function by function and are one row. The same samples summed by function and by family of function
  (`scripts/families.tsv`, prefixes) are the family tables.
- **DRAM traffic** is the memory controllers' own (`amd_umc/umc_cas_cmd.rd/` and `.wr/`, 64 bytes a command, with
  `umc_data_slot_clks.all` and `umc_mem_clk`), on every CPU around a cohort, less the idle host's rate from a 2 s
  control in the same hold. It is system-wide: the compiles' and whatever else the host moved. buster#672 holds its
  physical-traffic claims conditional on
  [buster-performance#49](https://github.com/buster14a/buster-performance/issues/49), and so do these. No DF or L3
  alias stands for traffic here; `l2_fill_rsp_src.dram_io_near` appears only as a core's own fills.
- **The tables** are `scripts/tables.sh`'s, made from the raw files alone (`tables/*.tsv`; `tables.md` has all of
  them as Markdown). On the host the scripts write `results/`; here that directory is `raw/`, and its `tables/` and
  `tables.md` are at the top.

### What disturbed the runs

- **A stray process held a core all day.** A test program of another session (`run`, PID 3239052, started by hand at
  08:16 UTC, its parent gone) looped at 100% of a CPU outside the lock. It was reported to the owner and not touched.
  Every cohort records the foreign processes above half a CPU before and after it (`*.strays.txt`): in 252 of 338
  snapshots the stray was on CPU 8, the second thread of core 0; in 48 on CPU 0; in 30 on CPU 2, which it left when
  a pinned worker ran there (the one-worker rounds agree within 0.6% in cycles whether it had been there or not).
  The worker that shared core 0 took 300 to 330 ms a compile where the others took 252.
- **So, from four workers on, the medians leave out the worker on CPU 0** (`rows --without 0`: the `kept_workers`
  column says how many were kept), and the throughput takes that worker's rate as the others' mean. The sampled
  cohorts leave out the stray's core the same way and its own samples by PID. Cohorts of fifteen have no CPU to
  spare: their span is stretched in the rounds where the stray shared a worker's CPU.
- **A `git` process of another session** (PID 3353408) ran during baseline round 4's two- and four-worker cohorts:
  their controllers' counts (1,032 and 1,152 MB read a compile where the other rounds have 903 to 976) are left out
  of section 3, and the per-run counters' medians are not moved by it.
- **The first rounds counted five memory-controller events**, and a controller has four counters: baseline rounds 0
  to 2, `sets` round 0 and `pages` round 0 were multiplexed at 79% to 80% (`counted_percent` in the `-umc` tables),
  so their read and write counts are scaled estimates. Section 3 uses the exact rounds alone.
- **The host was shared** with CI and several sessions: each hold waited two to five minutes. The queues were
  shortened while they ran (the kernel-mode and load-wait profiles of the preprocessed units and their timelines,
  the profiles of a process a unit and of the eight commands' user side, and the rounds past those listed); what is
  here is what ran.
- **The first harness was discarded.** It counted per CPU around the cohort (`perf stat -a -A -C`), which included
  the workers' start-up spin and the stray. Nothing of it is in the tables.

## 1. The baseline: one worker to fifteen

`scripts/baseline.sh ROUND`, six rounds (`raw/baseline/r0` to `r5`), each a hold: the cohorts in an order rotated by
the round, 6 compiles a worker (4 at fifteen). `tables/baseline.tsv`; per compile:

| workers | MB/s | wall ms | user cycles | kernel cycles | user instructions | L2 fills from DRAM | peak RSS | minor faults | GHz |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1, CPU 2 | 74.26 | 124.984 | 602.39 M | 84.36 M | 1,348.90 M | 13.11 M | 236.7 MB | 7,461 | 5.54 |
| 1, CPU 5 | 74.10 | 125.944 | 602.82 M | 84.38 M | 1,348.90 M | 13.06 M | 236.7 MB | 7,460 | 5.50 |
| 2 | 113.56 | 164.329 | 722.47 M | 164.02 M | 1,348.96 M | 13.91 M | 190.5 MB | 63,081 | 5.51 |
| 4 | 198.93 | 183.390 | 802.43 M | 182.56 M | 1,348.96 M | 15.11 M | 190.7 MB | 63,006 | 5.47 |
| 8 | 295.39 | 252.280 | 1,044.74 M | 251.79 M | 1,348.96 M | 15.23 M | 190.7 MB | 62,996 | 5.21 |
| 15 | 323.10 | 432.968 | 1,802.67 M | 392.35 M | 1,348.96 M | 15.60 M | 190.7 MB | 62,994 | 5.14 |

- The frequency is the TSC's rate times APERF over MPERF while the run was on its CPU.
- Eight workers: 3.98 times one worker's throughput; 1.73 times the user cycles a compile, 2.98 times the kernel's,
  1.89 times both (1,296.5 M against 686.8 M). Fifteen: 9% more throughput than eight.
- From two workers on, a compile finds the host busy when it starts and takes base pages (buster#1561): the stage
  reports' `huge-pages` line says `busy` for every such run. That is the step in the peak and the faults.
- A run's teardown (its exit to its helper's end) is 0.002 ms alone and 3.5 ms at eight workers, 12.9 at fifteen.
- The objects are the same bytes at every worker count (`raw/baseline/r*/objects.txt`).

## 2. The other counters at one worker and at eight

`scripts/sets.sh ROUND`, three rounds. `tables/sets-td.tsv`, `sets-lat.tsv`, `sets-mem.tsv`; per compile:

| | 1 worker | 8 workers |
| --- | ---: | ---: |
| user cycles (`ls_not_halted_cyc`) | 601.1 M | 1,033.7 M |
| … with a load not complete at retirement (`ex_no_retire.load_not_complete`) | 248.3 M | 638.8 M |
| ops dispatched; retired | 1,716 M; 1,267 M | 1,739 M; 1,283 M |
| dispatch slots: no ops from the frontend; backend stalls | 1,185 M; 1,914 M | 1,610 M; 4,929 M |
| backend stalls' share of the slots (8 a cycle) | 39.7% | 59.1% |
| L1D demand fills: all; from the L3; from DRAM | 11.34 M; 1.20 M; 1.43 M | 10.93 M; 0.77 M; 2.95 M |
| L2 fills from the L3, user | 8.62 M | 2.50 M |
| L2 fills from DRAM: user; kernel | 7.97 M; 5.07 M | 10.16 M; 5.15 M |
| the prefetcher's L1D fills from DRAM | 0.74 M | 1.94 M |
| mispredicted branches | 3.62 M | 3.70 M |

390 M of the 433 M more user cycles have a load not complete.

`scripts/latency.sh ROUND`, three rounds: the L3's sampled miss latency on every CPU around each cohort
(`l3_xi_sampled_latency.dram_near` times 10 ns over its requests). `tables/latency.tsv`, `latency-lat.tsv`:

| | idle | 1 worker | 2 | 4 | 8 | 15 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| an L3 miss, ns (the three rounds) | 82, 83, 94 | 116, 115, 115 | 101, 104, 104 | 114, 116, 115 | 146, 147, 145 | 160, 159, 162 |
| L3 lookups that miss | 15% to 30% | 59% | 69% to 73% | 77% to 79% | 84% | 83% to 84% |
| user cycles with a load not complete, a compile | | 248.9 M | 360.4 M | 432.5 M | 647.3 M | 1,244.1 M |

## 3. DRAM traffic

The controllers' counts around the baseline's cohorts, less the idle control. `tables/baseline-umc.tsv` has every
round; the exact rounds are r3 to r5. Each figure is the median of those three, the bytes a source byte from the
median of the rounds' sums; at two and four workers r4 is left out (the `git` process) and the figure is the mean of
r3 and r5:

| workers | read, MB a compile | written | bytes a source byte | GB/s over the cohort's span | the data bus in use |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | 887 | 495 | 146 | 10.6 | 13% |
| 2 | 907 | 379 | 135 | 15.5 | 18% |
| 4 | 971 | 399 | 144 | 24.0 | 28% |
| 8 | 978 | 406 | 146 | 38.2 | 46% |
| 15 | 999 | 418 | 149 | 37.8 (42.1 in r4) | 45% |

- The cohort's rate is its bytes over its span, which a slowed worker stretches. `scripts/timeline.sh` reads the
  controllers every 2 ms through one eight-worker cohort (`raw/timeline/sq-timeline.w8.*`): the intervals' median is
  41.3 GB/s and their 90th percentile 51.7. The bytes over the time the eight all run is 43 GB/s.
- 43 GB/s over 146 bytes a byte is 295 MB/s, which is the throughput measured: buster#672's model.
- **The ceiling** (`scripts/ceiling.sh`, `tables/ceiling.tsv`): `allcore membw`, 1 GB a worker, 2 s, the controllers
  read every 100 ms. What the bus moved, in GB/s, on eight cores and on one:

| stream | 8 cores: read + written | 1 core |
| --- | ---: | ---: |
| read | 55.3 + 0.0 | 47.9 + 0.0 |
| ordinary stores | 26.0 + 26.0 = 52.0 | 22.9 + 22.9 = 45.9 |
| non-temporal stores | 0.0 + 27.6 | 0.0 + 26.9 |
| copy | 37.3 + 18.6 = 55.9 | 34.1 + 17.0 = 51.1 |

Two channels at 5,190 MT/s carry 83.0 GB/s at most; the controllers' data-slot clocks put a read stream at 67% of
the bus and eight compiles at 46%.

## 4. The inflation by stage

`scripts/sampled.sh sq … w1|w8 work|lat|kern` (`raw/sampled/sq-*`), reduced by `tables.sh`'s section 10
(`tables/inflation-sq.tsv`; the groups' own tables are `sampled-sq-work.tsv`, `-lat.tsv`, `-kern.tsv`). Per compile,
one worker against eight:

| stage | ms | user cycles, M | times | with a load not complete, M | kernel cycles, M | demand fills from DRAM, thousands | L2 fills from DRAM, thousands: user; kernel | faults at 8 | DRAM MB |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | --- | ---: | ---: |
| preprocess | 9.66 → 15.59 | 43.1 → 60.2 | 1.39 | 8.7 → 23.3 | 10.2 → 17.5 | 15 → 57 | 247 → 235; 546 → 472 | 5,643 | 93 → 80 |
| parse | 7.28 → 23.03 | 22.9 → 69.4 | 3.03 | 3.9 → 44.3 | 17.0 → 41.7 | 12 → 204 | 222 → 738; 1,160 → 815 | 10,430 | 178 → 141 |
| check-input | 46.10 → 101.77 | 219.0 → 401.8 | 1.84 | 94.7 → 244.6 | 33.9 → 115.6 | 762 → 1,138 | 3,456 → 3,481; 2,193 → 2,583 | 33,433 | 602 → 558 |
| check-expressions | 11.47 → 20.52 | 58.4 → 85.3 | 1.46 | 19.9 → 42.9 | 4.9 → 15.5 | 38 → 119 | 719 → 784; 439 → 526 | 6,650 | 98 → 111 |
| check-declarations, static-data | 2.47 → 4.07 | 12.6 → 17.0 | 1.35 | 7.1 → 11.6 | 1.0 → 3.3 | 53 → 59 | 178 → 148; 76 → 65 | 549 | 37 → 27 |
| check-program | 23.91 → 45.50 | 128.4 → 226.6 | 1.76 | 68.7 → 157.5 | 2.2 → 6.3 | 380 → 747 | 1,987 → 3,005; 252 → 222 | 2,546 | 208 → 251 |
| select | 1.06 → 2.65 | 5.0 → 11.4 | 2.30 | 2.5 → 8.3 | 0.9 → 2.3 | 16 → 60 | 64 → 138; 70 → 68 | 782 | 13 → 16 |
| lower | 11.42 → 19.65 | 61.0 → 101.4 | 1.66 | 25.9 → 64.1 | 1.7 → 2.6 | 95 → 234 | 762 → 983; 141 → 177 | 2,147 | 69 → 101 |
| the emission, `tier0` to `code-atoms` | 8.56 → 12.26 | 46.1 → 64.3 | 1.39 | 12.7 → 28.5 | 1.3 → 0.6 | 39 → 96 | 299 → 455; 111 → 60 | 299 | 33 → 54 |
| the object | 1.43 → 2.45 | 4.5 → 5.4 | 1.19 | 1.2 → 2.7 | 3.8 → 8.1 | 7 → 17 | 52 → 79; 53 → 82 | 37 | 11 → 10 |
| the process's start and end | 0.28 → 0.33 | 1.3 → 1.9 | 1.51 | 0.4 → 0.7 | 7.4 → 38.2 | 1 → 2 | 18 → 9; 153 → 140 | 392 | 22 → 25 |
| whole compile | 123.64 → 247.82 | 602.4 → 1,044.7 | 1.73 | 245.8 → 628.5 | 84.4 → 251.8 | 1,419 → 2,733 | 8,001 → 10,056; 5,194 → 5,209 | 62,908 | 1,364 → 1,374 |

- **The stages' times** are the stage reports' medians of the unsampled baseline (`tables/stages-sq.w1.tsv`,
  `stages-sq.w8.tsv`), and so are the faults (base pages at eight workers; alone the compile has huge pages and 7,461
  faults).
- **The user cycles** and the cycles with a load not complete are the `lat` group's by stage, scaled to the
  unsampled medians: that cohort's own totals are 613.9 M user cycles alone (2% over the median) and 1,038.0 M at
  eight workers (0.6% under). A stage's figure assumes the difference is spread evenly.
- **The kernel cycles** are the `kern` group's (the leader counts both modes) less the sampling's own: the sampled
  total less the unsampled median (16.7 M alone, 51.5 M at eight workers), taken off in proportion to the samples.
- **The fills** are as sampled, unscaled: the demand fills from the `work` group, whose eight-worker cohort ran
  lighter than the median (989 M user cycles; 2.73 M demand fills from DRAM where section 2 counts 2.95 M), and the
  L2 fills from the `kern` group.
- **The DRAM megabytes** are `timeline.sh`'s: each 2 ms interval's count divided among the stages that the cohort's
  runs were in during it (`raw/timeline/*.umcstages.tsv`). At eight workers a stage's figure is blurred by what the
  other workers' stages moved in the same interval.
- **The kernel at eight workers, by function** (`raw/sampled/sq-kern.w8.buckets.tsv`, both modes' sampled cycles a
  compile, before the correction): `_raw_spin_lock` 57 M, `do_anonymous_page` 51 M, `clear_page_erms` 44 M,
  `lock_vma_under_rcu` 32 M, `native_queued_spin_lock_slowpath` 22 M, `asm_exc_page_fault` 21 M,
  `folio_remove_rmap_ptes` 13 M. Alone (huge pages): `clear_page_erms` 59 M, and nothing else above 4 M.

## 5. The page policy apart from the load

`scripts/pages.sh ROUND`, three rounds: the other two corners, `BUSTER_HUGE_PAGES=0` alone and `=1` at eight
workers. `tables/pages-*.tsv`; per compile:

| | wall ms | user cycles | kernel cycles | load not complete | L1D demand fills from DRAM | peak RSS | faults | DRAM MB (exact rounds) | MB/s |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 worker, huge pages (main) | 125.0 | 602.4 M | 84.4 M | 248.3 M | 1.43 M | 236.7 MB | 7,461 | 1,388 | 74.3 |
| 1 worker, base pages | 150.2 | 659.9 M | 155.1 M | 303.2 M | 1.37 M | 190.7 MB | 62,990 | 1,150 and 1,307 | 62.5 |
| 8 workers, base pages (main) | 252.3 | 1,044.7 M | 251.8 M | 638.8 M | 2.95 M | 190.7 MB | 62,996 | 1,385 | 295.4 |
| 8 workers, huge pages | 282.7 | 1,206.3 M | 276.6 M | 791.7 M | 3.53 M | 236.7 MB | 7,465 | 1,731 and 1,723 | 272.1 |

With the pages the same on both sides, eight workers cost 1.58 times the user cycles and 1.62 times the kernel's in
base pages, and 2.00 and 3.28 times in huge pages. `tables/stages-sqbase.w1.tsv` and `stages-sqhuge.w8.tsv` have the
corners' stages.

## 6. The bodies and the file scope

`scripts/units.sh` makes the unit preprocessed (`-E -P`) and the same unit with each function body replaced by `;`
(`allcore spine`, the one-core record's split: 2,674 bodies of 568,641 tokens; 150,169 tokens stay;
`raw/units/spine.txt`). `scripts/spine.sh ROUND`, three rounds, compiles both at one worker and at eight under three
counter sets. `tables/spine-basic.tsv`, `spine-lat.tsv`, `spine-mem.tsv`, `spine-umc.tsv`, `stages-whole.*`,
`stages-spine.*`; per compile:

| | whole, 1 | without bodies, 1 | bodies, 1 | whole, 8 | without bodies, 8 | bodies, 8 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| wall ms | 117.2 | 18.9 | 98.3 | 243.6 | 36.2 | 207.4 |
| user cycles | 563.3 M | 74.3 M | 489.0 M | 1,006.0 M | 123.2 M | 882.8 M |
| kernel cycles | 80.3 M | 26.4 M | 53.9 M | 247.1 M | 52.7 M | 194.4 M |
| load not complete | 239.1 M | 19.3 M | 219.8 M | 636.1 M | 61.3 M | 574.7 M |
| L1D demand fills from DRAM | 1.40 M | 0.07 M | 1.33 M | 2.95 M | 0.27 M | 2.68 M |
| peak RSS | 228.5 MB | 84.9 MB | | 180.5 MB | 43.8 MB | |
| minor faults | 6,816 | 2,278 | | 60,979 | 12,017 | |
| DRAM MB (read + written) | 1,344 | 223 | 1,121 | 1,364 | 182 | 1,182 |

By stage, in ms of the stage reports (whole less without bodies): `check-input` to `lower` 81.3 alone and 166.2 at
eight workers; the parse 5.6 and 19.0; `tier0` to `code-atoms` 8.4 and 12.4. The compile's totals are 116.1 and
240.0.

**By family of function** (`scripts/sampled.sh whole|spine … work`, `tables/families-bodies.tsv`): the whole unit's
sampled user cycles less the unit without its bodies, in cycles a body token:

| family | alone | at eight | times |
| --- | ---: | ---: | ---: |
| the parser and the tree's columns | 44.1 | 140.9 | 3.19 |
| libc: `memset`, `memmove`, `memcmp` | 26.8 | 50.9 | 1.90 |
| the program and its controls | 127.0 | 235.7 | 1.86 |
| the reader's other functions | 159.9 | 283.1 | 1.77 |
| the graph's construction | 99.4 | 174.3 | 1.75 |
| the type table | 4.3 | 7.1 | 1.64 |
| warnings | 124.2 | 198.1 | 1.59 |
| initializers and static data | 23.9 | 37.6 | 1.57 |
| the lowering | 93.1 | 141.8 | 1.52 |
| the C rules for a node | 29.6 | 39.9 | 1.35 |
| the graph run and its loop | 53.8 | 64.9 | 1.21 |
| the emission | 74.5 | 90.0 | 1.21 |
| all (with the preprocessor's 5.7 → 21.3, the kernel's addresses 5.8 → 61.7 and the rest 10.9 → 14.2) | 883.3 | 1,561.3 | 1.77 |

The families are the one-core record's, by the functions' names; `scripts/families.tsv` is the list.

## 7. musl five ways

`scripts/musl.sh ROUND`, three rounds (`raw/musl/r0` to `r2`): the 1,336 units to objects as one command on one lane
(CPU 2), one command on 8 lanes (CPUs 0 to 7), 8 commands at once with a share of the units and one lane each
(`units.sh` deals the units largest first), a process a unit one at a time, and a process a unit 8 at a time.
`tables/musl-pass.tsv` (a round a line), `musl.tsv`, `musl-umc.tsv`; per pass over the units, the median round:

| way | pass ms | units/s | user cycles | kernel cycles | L2 fills from DRAM | minor faults | DRAM read + written |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| one command, one lane | 1,072 | 1,246 | 4,816 M | 1,101 M | 10.3 M | 343,109 | 1.18 + 0.37 GB |
| one command, 8 lanes | 222 | 6,016 | 5,812 M | 2,295 M | 47.8 M | 326,797 | 3.10 + 1.79 GB |
| 8 commands, one lane each | 218 | 6,131 | 5,479 M | 1,501 M | 39.1 M | 392,180 | 2.63 + 1.25 GB |
| a process a unit, one at a time | 2,300 | 581 | 5,894 M | 4,319 M | 44.8 M | 855,089 | 4.4 + 2.3 GB |
| a process a unit, 8 at a time | 457 | 2,922 | 7,033 M | 5,621 M | 91.5 M | 1,777,589 | 7.2 + 3.7 GB |

- Every way retires the same user instructions for the units (12,764 M to 12,788 M a pass in a command; 13,991 M as
  a process a unit).
- One lane's pass is in one of two page states, as
  [the file-scope record](../file-scope-design-672-2026-11-12/) found: round 2's median has 368,141 faults where the
  others have 343,109.
- **By family of function** (`scripts/muslsample.sh`, `tables/musl-families.tsv`). A command of several units
  reports no stages, so the families stand for them. Sampled user cycles a pass, one cohort each way (2 passes on
  one lane, 4 on eight); their totals inflate 1.16 times where the unsampled medians above inflate 1.21:

| family, user cycles a pass | one lane | 8 lanes | times |
| --- | ---: | ---: | ---: |
| the reader's other functions | 1,489.3 M | 1,615.2 M | 1.08 |
| the preprocessor and the lexer | 804.6 M | 1,001.7 M | 1.24 |
| the emission | 324.9 M | 341.0 M | 1.05 |
| the parser and the tree's columns | 279.3 M | 301.0 M | 1.08 |
| libc: `memset`, `memmove`, `memcmp` | 239.2 M | 325.8 M | 1.36 |
| the graph's construction | 224.5 M | 254.8 M | 1.13 |
| warnings | 175.5 M | 192.8 M | 1.10 |
| the program and its controls | 164.9 M | 186.7 M | 1.13 |
| the lowering | 102.1 M | 127.3 M | 1.25 |
| the type table | 98.4 M | 102.3 M | 1.04 |
| initializers and static data | 96.0 M | 102.0 M | 1.06 |
| the graph run and its loop | 80.5 M | 87.5 M | 1.09 |
| the C rules for a node | 63.7 M | 73.3 M | 1.15 |
| rest | 570.6 M | 626.8 M | 1.10 |
| samples at the kernel's addresses | 184.7 M | 356.0 M | 1.93 |
| all | 4,898.2 M | 5,694.2 M | 1.16 |

- **The kernel's families**, both modes' sampled cycles a pass:

| family | one lane | 8 lanes | 8 commands |
| --- | ---: | ---: | ---: |
| page faults | 456 M | 572 M | 628 M |
| pages given back (`madvise`, unmapping) | 285 M | 417 M | 416 M |
| TLB flushes sent to other CPUs | 12 M | 663 M | 14 M |
| spin locks | 162 M | 216 M | 215 M |
| clearing pages | 85 M | 183 M | 88 M |
| writeback of the written files | 27 M | 208 M | 22 M |
| sleeping locks (the address space's) | 5 M | 34 M | 8 M |
| other kernel | 292 M | 693 M | 439 M |

The lanes' command and the eight commands write the same objects; the lanes' writeback figure is one cohort's and
wasn't looked into.

## 8. The model

`scripts/tools/model.awk` over `tables/model-inputs.tsv` (each stage's user cycles at one worker and at eight, the
bodies' share of each, its faults; `tables.sh`'s section 9) gives `tables/model.tsv`: a compile's cycles at eight
workers and the cohort's MB/s after each step of buster#2536's design, of the node machine's (buster#2524) and of
both, in three cases. Its rules are in its header and in the design's "The model". It is an estimate over measured
inputs; the residuals (what a stage that stays in its caches still costs beside seven others: 1.30, 1.17, 1.08) and
the node machine's coverage and cost are assumptions, the first from sections 4, 6 and 7 and buster#672's
experiment, the second from `docs/node-machine.md`.

| eight workers on `sqlite3.c` | conservative: M cycles, MB/s | expected | optimistic |
| --- | ---: | ---: | ---: |
| today | 1,297, 295 | 1,297, 295 | 1,297, 295 |
| this design, step 1 | 1,264, 303 | 1,248, 307 | 1,226, 312 |
| step 2 | 1,155, 333 | 1,114, 345 | 1,048, 366 |
| step 3 | 938, 415 | 874, 444 | 779, 498 |
| step 4 | 815, 483 | 741, 531 | 631, 623 |
| step 5 | 789, 501 | 709, 558 | 590, 671 |
| the node machine alone, its step 2 | 1,002, 382 | 943, 405 | 916, 417 |
| its step 3 | 930, 411 | 828, 460 | 762, 499 |
| its step 4 | 751, 510 | 603, 634 | 496, 768 |
| both: step 2 here, the machine's step 2 | 922, 415 | 848, 451 | 792, 482 |
| step 2 here, the machine's step 3 | 876, 437 | 777, 491 | 711, 535 |
| step 3 here, the machine's step 4 | 631, 611 | 517, 743 | 432, 884 |
| step 4 here, the machine's step 4 | 508, 772 | 384, 1,020 | 283, 1,376 |
| step 5 here, the machine's step 4 | 481, 821 | 351, 1,125 | 242, 1,629 |

1 GB/s is a slot of 76.1 ms a compile: 396 M cycles at the 5.205 GHz that eight workers run at.

## Limits

- **One day, one host, one revision.** The stray process and the shared host are described above; the one-worker
  figures agree with the one-core record's of the same day at `d96b2e73` (602 M against 596 M user cycles, 125.0
  against 123.8 ms).
- **The worker on CPU 0 is left out from four workers on.** Seven workers' medians stand for eight; the throughput
  assumes the eighth would run as the seven do.
- **A stage's counters come from one sampled cohort a group** (4 interior runs alone, 18 to 21 at eight workers).
  The stage times and faults are from all six rounds.
- **DRAM megabytes by stage are blurred at eight workers**: an interval's count is divided among the stages running
  in it. The whole compile's figure is exact; a stage's is an attribution.
- **The controllers count the whole host.** The idle control is taken off (about 0.05 GB/s), but another session's
  process that runs during a cohort is in its count; the rounds left out are named in section 3.
- **Physical-traffic figures are conditional** on buster-performance#49, as buster#672's are.
- **musl's profiles** are one cohort each (2 to 4 passes); the profiles of a process a unit didn't run.
- **The model is not a measurement.**

## Files

- `README.md`, `env.txt` (the host, as `scripts/env.sh` wrote it after the last run), `tables.md`.
- `tables/`: every table, as `scripts/tables.sh` made it on the host from `raw/` alone.
- `scripts/`: `lock.sh` (the lock), `queue.sh`, `build.sh`, `probe.sh` (formats only), `common.sh` (the corpus, the
  options, the CPUs, the counter sets), `units.sh`, `baseline.sh`, `sets.sh`, `pages.sh`, `spine.sh`, `latency.sh`,
  `ceiling.sh`, `timeline.sh`, `sampled.sh`, `musl.sh`, `muslsample.sh`, `rebucket.sh`, `tables.sh`, `report.sh`,
  `finish.sh`, `env.sh`, `families.tsv`, and `tools/allcore.c` and `tools/model.awk`.
- `raw/`: `COMMIT`, `build.log` (the lock's lines about other holders removed), and a directory a script:
  `baseline/r0`–`r5`, `sets/r0`–`r2`, `pages/r0`–`r2`, `spine/r0`–`r2`, `latency/r0`–`r2`, `musl/r0`–`r2`,
  `ceiling/`, `timeline/`, `sampled/`, `muslsampled/`, `units/`, `queues/`. In each: the cohorts' rows
  (`*.rows.tsv`, a line a run), the controllers' counts (`*.umc.csv`), the strays (`*.strays.txt`), the lock's line
  (`holder.txt`), and every run's `--time-stages` report in `stages.tar.gz`.
- **Not here:** the samples' text (`perf script`'s, 15 files, 560 MB with the units), which stayed in the host's
  `~/buster-fast-bench/672-allcore-claude/scratch`; the buckets made from them are in `raw/sampled` and
  `raw/muslsampled`.
