# Tier 1 frame planner (#2699), 2026-11-14

Evidence for buster14a/buster#2763, which answers buster14a/buster#2699: `tier1_frame_plan` sorts a function's small
frames by rank instead of by 20 radix passes, and colors them in one branch-free ordered pass on both paths instead of
by pointer jumping on the vector path.

## Revisions

- buster main `21e0d999aa6867320f49e24fa3198122acf7b00f` (the PR's base).
- `head-a`, `222dce1607f874719597decc313f74d14f798c81`: the new preparation, and the ordered coloring pass as clang
  compiled it at first, with branches on the event's kind.
- `head-b`, `36f27ec95edd15b89f44dd5d11251a529c184aad`: the pass's selects kept as conditional moves, with two stores
  an event. The PR's later commits change comments, documentation and tests only, so `head-b` is the PR's planner.
- The trees on the 9700X are a clone of buster at main and a worktree for each head, built with
  `BUSTER_DEBUG_INFO=0 ./build.sh --config Release` (CI's toolchain, clang 23.1.4), each under the lock.

## Hosts

- **9700X**: benchpress, AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, CPU 2 (governor and EPP `performance`) for every
  timing, every step under `exclusive.sh` (`scripts/q1.sh`, `q1b.sh`, `q2b.sh`, `q3.sh`, `q4.sh`). Each log starts
  and ends with the load average and the busiest processes. A dozen sessions shared the host that afternoon, so the
  steps of one script are minutes apart; each comparison's runs are in one hold.
- **Container**: a Claude Code cloud container, an Intel Xeon with the full AVX-512 set `host_isa.h` requires. It
  gave the census of frame requests below, the test runs and the byte comparisons the PR lists. No timing comes
  from it.

## Identities (9700X, `9700x/identities.txt`)

| file | SHA-256 |
| --- | --- |
| main's `build/compiler` | `0873211a7c382bbbe21e7b9a1d25a899e3cb9a73e2591c61d2e06dcd3b75329c` |
| head-a's | `65af29683b5630116f7f8a29bb94e576131fe15aaafd8d9e30b1dcf6c2e069f9` |
| head-b's | `df7bc06c3ae6a97eb2b8515a25aeab2a0b5b721775f601f3771a2117a23ba18f` |
| `sqlite3.c` (the frozen corpus's) | `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d` |

`scripts/sq.sh COMPILER OUT [OPTIONS]` is the compile every whole-compile number here is of: `-c --tier1` of the frozen
corpus's `sqlite3.c` with the corpus's pinned predefines and headers, `-march=znver5 -std=gnu17`.

## What a compile asks of the planner (`container/`)

`container/frame-requests-sqlite3.txt` has one line for each of the 1,368 `tier1_frame_plan` calls of that compile
(`objects classes columns slots minimum_position maximum_position`, printed by the temporary lines in
`scripts/frame-requests.patch.txt`); `scripts/frame-requests.py` summarizes it (`container/frame-requests-sqlite3-summary.txt`).

| objects in the frame | plans | share of plans | share of objects |
| --- | ---: | ---: | ---: |
| 0 | 334 | 24.4% | 0% |
| 1 to 4 | 671 | 49.0% | 21.6% |
| 5 to 8 | 174 | 12.7% | 15.2% |
| 9 to 16 | 104 | 7.6% | 17.1% |
| 17 to 32 | 56 | 4.1% | 18.1% |
| 33 to 64 | 19 | 1.4% | 11.5% |
| 65 to 128 | 8 | 0.6% | 9.5% |
| 185 and 307 | 2 | 0.1% | 7.1% |

- The median frame has 2 objects, and 1,339 of the 1,368 (97.9%) have at most 32, the rank sort's limit.
- 1,033 of the 1,034 frames with objects have at most 8 classes (603 have one), the class register's limit. One has 11.
- Every request names its rows by indices. The largest position is 81,326 (median 532), so the event keys differ in
  two or three bytes; a request's columns are 279 rows at the median and 40,788 at most.

## The planner's share of the compile

A temporary `rdtsc` pair around `tier1_frame_plan_path` (`scripts/probe.py`, then `scripts/probe2.py`) sums the
planner's ticks over the compile, on CPU 2 with `--lanes 1`. The TSC counts at 3.8 GHz there.

The first probe (`probe.py`: `9700x/probe-sqlite.log` for main, `probe-sqlite-a.log` for head-a) prints a line after
every plan, 1,368 a compile; the table takes each compile's last line:

| build | path | ticks, median (range) | at 3.8 GHz | of the compile's 621 ms |
| --- | --- | ---: | ---: | ---: |
| main | vector, the default | 9,829,042 (9,684,490 to 10,054,382), 7 runs | 2.59 ms | 0.42% |
| main | `--scalar` | 8,853,886 (8,847,654 to 8,902,602), 3 runs | 2.33 ms | 0.38% |
| head-a | vector | 2,329,286 (2,284,522 to 2,367,476), 7 runs | 0.61 ms | 0.10% |
| head-a | `--scalar` | 3,460,660 (3,451,008 to 3,494,974), 3 runs | 0.91 ms | 0.15% |

- Main's planner is 0.42% of the compile on the default path: 1.9 µs a plan over all 1,368, 2.5 µs over the 1,034
  with objects.
- The write between each plan and the next costs the next plan its warm caches, so these are upper bounds, and more so
  for the heads, whose plans are short: head-a's 448 ns a plan is several times the benchmark's hot 80 to 340 ns
  below. `probe2.py` prints one line, at the compile's last plan; its runs for main and head-b are in
  `9700x/probe2-b.log` once they have run (the host's queue was long that afternoon).
- The whole compile's cycles below agree in size: main less head-a is 12.9 M cycles, which is 8.9 M of these ticks.

## The whole compile

`perf stat` of `scripts/sq.sh` on CPU 2, main and a head alternating, 7 runs each (`9700x/stat-a.log`, `stat-b.log`):

| run | build | cycles:u, median (range) | instructions:u, median | task-clock, median |
| --- | --- | ---: | ---: | ---: |
| a | main | 3,343,071,941 (3,340,919,094 to 3,349,077,814) | 8,313,954,348 | 621 ms |
| a | head-a | 3,330,184,921 (3,327,392,552 to 3,334,609,524) | 8,291,950,736 | 619 ms |
| b | main | 3,342,580,496 (3,335,726,249 to 3,345,625,648) | 8,313,954,390 | 621 ms |
| b | head-b | 3,333,663,203 (3,329,305,246 to 3,340,832,276) | 8,291,976,870 | 619 ms |

- Instructions fall by 22.0 M (0.265%) on both heads; head-b executes 26,134 more than head-a, the coloring pass's
  both stores and selects over the compile's 13,962 events.
- Cycles fall by 12.9 M (0.39%) in run a, where the two builds' ranges don't meet, and by 8.9 M (0.27%) in run b, where
  they overlap. The two heads differ by the coloring pass alone, which is under 0.2 M cycles of this compile, so the
  4 M between the runs is what a different executable's layout and the host's afternoon do to 3.3 G cycles, not the pass.
- An earlier `perf stat -r 7` of main alone (`9700x/stat-main.log`): 3,361,676,753 cycles:u (±0.63%), 631.5 ms.

## `benchmark-tier1-frame` (`9700x/frame-*.log`, two rounds a build)

`taskset -c 2 ./compiler benchmark-tier1-frame`, a process for each round. Whole plan, ns per function:

| shape | objects | main scalar | main vector | head-b scalar | head-b vector | main vector / head-b vector |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| leaf | 16 | 1,928 / 1,924 | 2,023 / 2,018 | 334 / 337 | 145 / 141 | 14.2 |
| calls (indexed) | 256 | 8,888 / 8,899 | 15,607 / 15,799 | 3,344 / 3,445 | 3,275 / 3,291 | 4.8 |
| variadic | 4,096 | 79,726 / 79,903 | 308,889 / 312,411 | 45,912 / 46,052 | 39,529 / 39,635 | 7.8 |
| dynamic-realigned (indexed) | 32,768 | 1,171,938 / 1,169,995 | 3,904,223 / 3,949,037 | 611,675 / 611,648 | 547,014 / 544,697 | 7.2 |

Preparation, ns per function:

| shape | objects | main scalar | main vector | head-b scalar | head-b vector |
| --- | ---: | ---: | ---: | ---: | ---: |
| leaf | 16 | 1,871 / 1,867 | 1,859 / 1,853 | 259 / 259 | 64.3 / 64.4 |
| calls | 256 | 8,250 / 8,305 | 8,367 / 8,555 | 2,539 / 2,748 | 2,424 / 2,455 |
| variadic | 4,096 | 72,345 / 72,551 | 69,000 / 69,167 | 33,424 / 33,522 | 26,296 / 26,440 |
| dynamic-realigned | 32,768 | 970,456 / 969,501 | 986,891 / 986,205 | 500,852 / 501,336 | 434,698 / 435,012 |

The color phase, cycles per object (both of a head's paths run the one pass):

| shape | objects | main scalar (one pass, branches) | main vector (pointer jumping) | head-a (one pass, branches) | head-b (one pass, selects) |
| --- | ---: | ---: | ---: | ---: | ---: |
| leaf | 16 | 7.18 / 7.20 | 42.6 / 42.8 | 9.87 / 9.84 | 11.59 / 11.60 |
| calls | 256 | 9.15 / 9.06 | 150.5 / 151.4 | 9.32 / 9.29 | 11.38 / 11.38 |
| variadic | 4,096 | 7.66 / 7.54 | 319.0 / 323.7 | 9.58 / 9.62 | 11.49 / 11.48 |
| dynamic-realigned | 32,768 | 31.89 / 31.85 | 489.0 / 497.0 | 23.87 / 23.95 | 12.90 / 12.87 |

Reading the color phase:

- Pointer jumping costs 4 to 15 times main's own scalar pass, as #2699 found, and 3.7 to 38 times head-b's.
- The benchmark colors one prepared frame over and over. Up to 4,096 objects the predictor learns that frame's
  kinds, so a pass with branches measures 7 to 10 cycles an object there; at 32,768 objects it can't, and the same
  passes measure 24 and 32. The pass with selects measures 11.4 to 12.9 at every size. A compile's frames don't
  repeat, so the selects' number is the one a compile gets; the probe above compares the two passes on sqlite3.c's
  frames.
- head-a's pass at 32,768 objects (24 cycles) against main's scalar one (32): the same branches, without main's second
  store-to-load forward an object (the level holds the item, not its color).

Layout is unchanged: 38 to 40 ns at 16 objects, 0.93 ns per object at 32,768, on every build.

## At a frame's size (`9700x/sizes-*.log`)

`benchmark-tier1-frame --count N` for main and head-b, the indexed `calls` shape (a compile's requests are indexed),
vector path unless said, ns per function:

| objects | main prepare | head-b prepare | main color | head-b color | main total | head-b total | head-b scalar total | main / head-b |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | 1,128 | 37.7 | 30.6 | 7.8 | 1,179 | 79.9 | 109 | 14.8 |
| 2 | 1,400 | 41.4 | 35.6 | 8.8 | 1,300 | 84.8 | 109 | 15.3 |
| 4 | 1,454 | 70.2 | 40.9 | 11.2 | 1,537 | 101 | 254 | 15.2 |
| 8 | 1,848 | 78.7 | 78.7 | 17.7 | 1,944 | 130 | 279 | 15.0 |
| 16 | 2,267 | 97.7 | 122 | 33.7 | 2,448 | 174 | 364 | 14.1 |
| 32 | 2,862 | 216 | 326 | 65.6 | 3,230 | 338 | 530 | 9.6 |
| 33 | 2,857 | 350 | 391 | 67.5 | 3,346 | 478 | 514 | 7.0 |
| 48 | 3,138 | 471 | 573 | 97.3 | 3,808 | 624 | 686 | 6.1 |
| 64 | 3,671 | 1,009 | 999 | 131 | 4,766 | 1,154 | 1,217 | 4.1 |
| 128 | 5,763 | 1,467 | 2,883 | 259 | 8,797 | 1,863 | 1,959 | 4.7 |

- The rank sort's limit, 32 objects (64 events): preparation is 216 ns by rank at 32 objects and 350 ns by radix
  passes at 33. A radix pass costs about 125 ns at this size whatever the count (its 256 counters' prefix sum), and the
  rank sort's compares grow with the square, so the two would meet near 48 objects; 8 key registers and 8 rank
  registers are what 64 events take.
- Above the limit preparation follows the passes the keys need: two at 33 and 48 objects (one position byte and the
  class byte), three from 64 (positions pass 255).
- These are a hot loop's numbers on one frame. A compile's plans run cold, between the rest of a function's work:
  the probe's ticks per plan are several times these.

## Twin identity (`9700x/twin-a.log`, `twin-b.log`)

`sq.sh` by each head, by each head with `--scalar`, and by main: one object,
`11ac73bd8e38c8b21a14f6fb22136dd21d9d50f02095eb26ce7187df04a5d681`, on both heads. `test-tier1-frame` on the 9700X:
2,279,386 checks, 0 failures.

## Tables

`python3 scripts/tables.py`, run in this directory, prints these tables from the logs.
