# The deferred lanes' race over the rare columns' huge pages, 2026-10-29

The 9700X's measurements for Buster's issue [#764](https://github.com/buster14a/buster/issues/764) and its PR
[#791](https://github.com/buster14a/buster/pull/791). `check_input_run` reserves an arena of its own at each reading for
the columns few tokens have an entry in, with the binding table (#572): base pages for its scope stacks and huge pages
past them. When the deferred reader (#113) reads the bodies on more than one lane, the lanes write their bodies' entries
into that arena's 2 MB regions at once, and lanes that write a region with no page yet, or the huge zero page, each
allocate and clear a huge page for it, of which the kernel maps one. Record
[deferred-copies-697](https://github.com/buster14a/buster-performance/tree/79c90346c27d937bb8dffb771be9d9fcca6995b6/docs/measurements/deferred-copies-697-2026-10-28)
found the race, and left where its time goes open. Cited by Buster's `docs/c-deferred-bodies.md` ("The rare columns'
huge pages (#764)").

In short:

- **Where the time goes.** In the kernel, clearing pages. Clearing fresh memory runs at about 26 GB/s on this host
  however many threads share it: a first write into a fresh 2 MB region takes 82 µs alone and 651 µs when eight threads
  write regions of their own at once, and threads that write one region at once each allocate and clear a page. A cycles
  profile at a fixed period (`perf record -c 200003`, whose samples count cycles) has main's woken lanes, in eight-lane
  readings of `b16x77.c` whose walks raced, spend 180 Mcycles in `clear_page_erms` over 24 readings, against 6 with the
  token columns in base pages and 4 with them committed before the lanes; with the race, the process took 57 ms more of
  CPU, nearly the 65 ms by which its lanes' walks took longer. The record above sampled at a frequency (`-F 20000`) and
  found the clears too few to account for the walks.
- **The fix.** #791's head `3b87d0c9`: the arena is base pages throughout where the reader's rule gives the bodies more
  than one lane, which the reader works out from the parser's tree before its top level's walk; a reading on one lane,
  as source order's, keeps the huge pages. Of the five trees campaign D1 measured, base pages throughout read the bodies
  fastest on eight lanes, and kept every unit's eight-lane walks within 3.2 ns/token over five rounds, where main's
  spread by up to 28.9.
- **Five rounds' walks** (campaign A5, A2's 43 units, eight lanes with every lane): the head's walks spread over the
  rounds by a median of 1.40 ns/token and at most 4.94, the base-page control's 1.12 and 5.68, main's 1.33 and 37.79,
  past 5 on 12 units.
- **The lane rule fitted again** on A5's grid: 1,280 tokens and a third of the top level's (`62142bec`), rather than
  1,024 and a quarter, forgo 45.3 points rather than 49.4 and read the worst unit 2.1% slower on its lanes than on one,
  rather than 4.8%.
- **By the rule** (campaign B5, the head `95fc3668` with the refitted rule against main): the 43 units 0.6% slower by
  the median, from 22.9% faster to 8.6% slower. Twelve read more than 1% faster, `sqlite3.c` 4.6%; nineteen more than 1%
  slower, fourteen of them units on two to eight lanes whose lanes didn't race in main, where base pages cost the merge's
  pass and the phases after it 0.6 and 0.9 ns/token of 4 KB read faults (the medians) and the lanes' span 0.9.
- **`sqlite3.c` and later readings.** By the rule, eight lanes, the head reads `sqlite3.c` 5.1% faster than main and
  10.4% faster than source order (campaign S5). At a state's later readings (`--warm`, campaign W5), whose lanes race in
  every round in main, the head reads four of diag9's units 12 to 28% faster than main.
- **Source order** keeps its huge pages: against main, 0.5% slower by the median (0.8% faster to 2.2% slower) and
  `sqlite3.c` 0.8% faster (campaign SO5), running the same instructions to 0.005% (campaign SOI).

## Sources and inputs

| Tree | Buster source | Files under `src` | Source manifest's SHA-256 |
| --- | --- | ---: | --- |
| `main-bc11fddb` | main `bc11fddb` (#773 merged), #791's base | 555 | `68e3b0298f73a2887d758602dd35903e7a3251f14a08269a608cfb870267247b` |
| `pr791-561e5f1c` | `561e5f1c`, #791's first head (a ChatGPT session's): the arena in base pages throughout at every deferred reading | 555 | `c30229263b43e66d71097555273c7cc18739f798800c3876f7836ddf834be404` |
| `cols-2954544c` | `2954544c`, not pushed (`patches/cols-2954544c.diff`): the reader's token columns alone in base pages at every deferred reading | 555 | `7676984cb507102b480d3b667a05d518315c19839416b98774965f703edce1e3` |
| `multicols-865271ef` | `865271ef`, not pushed: the token columns alone in base pages where the rule gives the bodies more than one lane | 555 | `72eab4b422fbaa66683dbd77abd97ef34cc9d9e2b0bbed91ab72fdfe64ec4fae` |
| `pop-98023033` | `98023033`, not pushed: the token columns committed on the calling thread (`MADV_POPULATE_WRITE`) before more than one lane | 555 | `52fe1c9117c4f3ba6bd4f9e7e360092ce2ad34fb1b9c98297bc0012d8be352b8` |
| `head-3b87d0c9` | `3b87d0c9`, #791: the arena in base pages throughout where the rule gives the bodies more than one lane | 555 | `873a7d9ccb94d4e462c364aceeb75a58b42b3277c09de563c8da84c75c35fc21` |
| `head-95fc3668` | `95fc3668`, #791: and the rule's refitted constants (`62142bec`), with the three fixtures they change | 555 | `ef92376af8f489738310061fad5e0f691287dcdecfaece2502eb11cb060b124c` |

`trees.txt` has each tree's commit; `source-TREE.sha256` the SHA-256 of `build.sh` and of every file under `src`, whose
own SHA-256 is the manifest's (`scripts/manifests.sh`); `patches/TREE.diff` each tree's difference from main. The three
trees that weren't pushed were diagnostic candidates: their commits exist only in the session's checkout, and their
diffs here are their sources. Each tree was built as the 9700X job builds it, `env BUSTER_DEBUG_INFO=0 ./build.sh`, a
lock hold each (`scripts/build.sh`, `logs/builds.txt`, with every build's exit status and its binary's SHA-256;
`binaries.sha256`).

The inputs are record A2's 43 units (`inputs.sha256`, each file's SHA-256 the same as record deferred-copies-697's
`inputs.sha256` gives it): four of c-testsuite's single-exec programs (`00182.c`, `00200.c`, `00204.c`, `00213.c`) at
commit `5c7275656d751de0e68b2d340a95b5681858ed07`, the frozen `sqlite3.c` and 38 synthetic units from A2's generator
(`gen2.c`). diag9's six units are `h16x19.c`, `h16x38.c`, `x16x19.c`, `b16x77.c`, `l16x38f384.c` and `h16x10.c`. Every
file is read with the frozen corpus's pinned predefines and headers (`scripts/env.sh`); `SOURCE_DATE_EPOCH=1792454400`;
`CPATH` and `C_INCLUDE_PATH` are unset. The command is record A2's:

```sh
./build/compiler benchmark-checker-deferred --passes 24 --lanes L --cpus 2,0,1,3,4,5,6,7 [--every-lane] [--warm] [the options] FILE
```

with `--passes 12` for `sqlite3.c`, each unit, tree and lane count in a process of its own (`scripts/runs.sh`). Each
process reads the unit by source order, then on one lane, then on `L` lanes (by the rule, or with `--every-lane` on
every lane the bodies can take), each reading in its passes in the six orders of the three, and reports each reading's
median per token; `-every` after a tree's name in the logs is `--every-lane`, and `-warm` is `--warm` (the state kept
from one reading to the next). A campaign's jobs (`scripts/*.jobs`: a unit's runs) run in rounds, a round's jobs in an
order that starts 7 jobs further on each round and a job's runs in an order that starts one run further on, in lock
holds of 7 to 22 jobs, 30 s apart (`scripts/queue.sh`, `scripts/batch.sh`). Every run's heading, output and exit status
are in the campaign's log; all are 0.

Host (`logs/host.txt`): AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9-1; transparent huge pages
`always` (defrag `madvise`, the huge zero page in use); CPU 2 has the performance governor and energy preference, CPUs
0, 1 and 3 to 7 powersave and `balance_performance`.

The scripts ran as chains (`scripts/master*.sh`, `logs/chain.txt`): `master1.sh` built four trees; `master1b.sh` built
`pop` and was stopped; `master1c.sh` ran `thprace --keep`, D1 and the attribution; `master2b.sh` built `head-3b87d0c9`,
ran its tests and A5; `master3.sh` W5, S5 and the corpus tests; `master4.sh` SO5 and the driver's runs (which failed,
below); `master5b.sh` built `head-95fc3668`, ran its tests and B5; `master6.sh` SOI. `master2.sh` and `master5.sh` were
replaced before they ran. The lock's waiting messages went to files of their own, which name other sessions' work and
aren't published; `logs/builds.txt` keeps only the lines its script writes and `build.sh`'s own, and the tests' logs had
the lock's messages removed (`analysis/strip_lock.py`).

## Where the time goes

### Clearing fresh memory (`tools/thprace.c`)

`thprace` maps fresh memory each round, pins a thread to each CPU of `--cpus`, lets every thread spin for 3 ms (so that
the powersave CPUs reach their clock), releases them together and times each thread's writes; 64 rounds a mode. With
`--keep`, a mode's rounds keep their memory until the mode ends, so that each round's huge pages come from the
allocator's free lists rather than from the pages the round before freed on the same CPU. The runs without `--keep`
used `tools/thprace-before-keep.c` (SHA-256 `9e3324bc…`, as `logs/thprace.txt` logs it), and those with it
`tools/thprace.c` (`cc9a1944…`), which `tools/thprace-keep.diff` shows. Microseconds a thread (the median over the
rounds), on CPUs `2`, `2,0`, `2,0,1,3` and `2,0,1,3,4,5,6,7`, with the pages each round allocated and the TLB
shootdowns it sent on eight threads (`/proc/vmstat`'s `pgalloc_normal`, and `/proc/interrupts`' `TLB` row summed over
the CPUs):

| Mode | 1 thread | 2 | 4 | 8 | Pages a round on 8 | Shootdowns a round on 8 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `distinct --keep`: a fresh 2 MB region each | 82.5 | 153.2 | 310.6 | 650.6 | 4,104 | 0 |
| `distinct`: pages the CPU just freed where it has them | 14.1 | 64.0 | 229.9 | 564.9 | 4,104 | 0 |
| `same --keep`: one fresh region, a 4 KB page each | 80.2 | 29.2 | 26.4 | 34.1 | 4,104 | 0 |
| `same-zero --keep`: the same after a read mapped the huge zero page | 86.5 | 23.2 | 27.7 | 37.3 | 4,103 | 7 |
| `base-same --keep`: 16 base pages each of one 2 MB range | 8.7 | 10.2 | 13.2 | 24.3 | 134 | 0 |
| `base-same-zero --keep`: the same after a read of each page | 7.7 | 24.6 | 70.5 | 235.5 | 128 | 896 |

- A first write into a fresh 2 MB region takes 82.5 µs alone, 25 GB/s; two, four and eight threads that write regions of
  their own at once take 153, 311 and 651 µs each, 27, 27 and 26 GB/s in all. More threads clear no faster. A page the
  CPU freed just before clears in 14 µs, from its caches; on eight threads, the other CPUs' pages come from the free
  lists.
- Eight threads that write one region at once allocate eight huge pages (4,104 pages a round), and the kernel maps one
  (`thp_fault_alloc` 1 a round). The losers free theirs on their own CPUs, whose next rounds reuse them from their
  caches, so `same`'s times after the first round are of cached pages.
- A base page's first write takes 0.5 µs alone and 1.5 µs on eight threads at once. But a write to a page a read mapped
  to the zero page replaces a mapping the other CPUs may hold, and the kernel sends each of them a TLB shootdown: 14.7
  µs a page on eight threads, 896 shootdowns a round (128 pages, 7 other CPUs each).

### The reader's lanes (`scripts/attrib.sh`)

Main, the token columns alone in base pages (`multicols`) and the columns committed before the lanes (`pop`) on
`b16x77.c` and `h16x19.c`, on eight lanes with every lane, 24 passes: two processes of each under `perf stat`, and one
under `perf record -e cycles -c 200003`, whose samples count cycles at a fixed period (`logs/attrib.txt`,
`reports/stat-*.csv`; `reports/samples/*.txt.gz` are `perf script -F pid,tid,ip,sym`'s, with every kernel address
replaced by `ffffffff80000000` by `analysis/mask_kernel.py`, and `reports/attrib-*.txt` their summaries by
`analysis/attrsum.py`, the same as of the unmasked samples). `task-clock` and the kernel's cycles are the process's, its
three readings a pass together; the profile's columns are the woken lanes' (every thread but the first):

| Unit | Tree | Walks on 8, each stat process | `task-clock`, ms | Kernel cycles, M | The profile's walks | Its lanes' kernel Mcycles | Of which `clear_page_erms` |
| --- | --- | --- | --- | --- | ---: | ---: | ---: |
| `b16x77.c` | `main` | 64.98, 36.49 | 315.0, 291.4 | 525, 459 | 76.38 | 241.8 | 179.8 |
| `b16x77.c` | `multicols` | 34.28, 34.68 | 271.8, 272.7 | 386, 393 | 30.37 | 135.8 | 6.0 |
| `b16x77.c` | `pop` | 22.74, 22.11 | 257.9, 256.6 | 347, 353 | 23.37 | 50.8 | 4.0 |
| `h16x19.c` | `main` | 16.49, 17.32 | 120.6, 126.2 | 168, 209 | 17.94 | 97.2 | 41.4 |
| `h16x19.c` | `multicols` | 22.04, 23.40 | 122.4, 125.4 | 187, 196 | 22.44 | 66.8 | 2.4 |
| `h16x19.c` | `pop` | 12.54, 13.87 | 113.3, 127.2 | 163, 169 | 14.45 | 44.4 | 2.4 |

Main's racing processes of `b16x77.c` spent their lanes' time clearing pages: 180 Mcycles in `clear_page_erms` over 24
readings in the profiled run (walks 76 ns/token), against 6 with the columns in base pages and 4 with them committed.
Its first stat process (walks 65 ns/token) took 57 ms more of CPU than `pop`'s first (23 ns/token), whose walks took 65
ms less in all: the walks' extra time is the lanes' CPU time, in the kernel. In base pages the lanes take 4 KB faults
instead, with the zone's and LRU's locks and TLB shootdowns among them (136 Mcycles of the kernel's against main's 242).

## Campaign D1: five candidates

diag9's six units, `00200.c` and `sqlite3.c` on eight lanes with every lane, five trees, five rounds, a round's 8 jobs a
lock hold (`logs/D1.txt`, `scripts/d1.jobs`): main; the arena in base pages throughout at every deferred reading
(`pr791`, #791's first head); its token columns alone in base pages at every deferred reading (`cols`) and only where
the rule gives the bodies more than one lane (`multicols`); and the token columns committed on the calling thread before
more than one lane (`pop`). The medians of the rounds on eight lanes, in ns/token, with the eight-lane walks' spread
over the rounds in parentheses (`tables/D1.md` has every round's walks and source order, `tables/D1-summary.txt` every
phase, by `analysis/dsum.py`):

| Unit | `main` | `pr791` | `cols` | `multicols` | `pop` |
| --- | ---: | ---: | ---: | ---: | ---: |
| `h16x19.c` | 39.75 (0.6) | 41.31 (1.0) | 43.05 (1.2) | 42.92 (3.2) | 39.54 (1.3) |
| `h16x38.c` | 36.21 (5.0) | 34.99 (1.2) | 36.49 (1.2) | 36.72 (1.2) | 36.28 (0.6) |
| `x16x19.c` | 50.56 (0.4) | 49.78 (0.8) | 51.73 (1.6) | 52.00 (0.8) | 52.98 (0.3) |
| `b16x77.c` | 32.48 (28.9) | 26.50 (1.2) | 31.19 (0.7) | 31.56 (1.1) | 33.50 (0.2) |
| `l16x38f384.c` | 40.95 (12.7) | 35.03 (1.6) | 39.37 (0.8) | 40.35 (1.4) | 40.77 (0.2) |
| `h16x10.c` | 44.95 (1.7) | 47.68 (3.2) | 47.89 (4.4) | 47.97 (1.0) | 45.43 (2.3) |
| `00200.c` | 39.86 (0.1) | 42.34 (0.1) | 44.18 (0.2) | 43.48 (0.1) | 39.96 (0.1) |
| `sqlite3.c` | 64.68 (1.5) | 60.97 (1.0) | 62.74 (1.2) | 62.64 (0.6) | 67.79 (1.2) |

And on one lane, the same processes' one-lane readings:

| Unit | `main` | `pr791` | `cols` | `multicols` | `pop` |
| --- | ---: | ---: | ---: | ---: | ---: |
| `h16x19.c` | 43.67 | 46.05 | 47.39 | 43.82 | 43.82 |
| `h16x38.c` | 40.71 | 42.20 | 43.49 | 41.04 | 40.64 |
| `x16x19.c` | 50.08 | 51.39 | 53.33 | 50.12 | 51.00 |
| `b16x77.c` | 38.26 | 36.29 | 40.78 | 38.17 | 38.61 |
| `l16x38f384.c` | 44.06 | 40.89 | 45.52 | 43.92 | 44.22 |
| `h16x10.c` | 47.15 | 50.05 | 50.56 | 46.71 | 47.17 |
| `00200.c` | 39.30 | 40.89 | 42.73 | 39.26 | 39.57 |
| `sqlite3.c` | 81.99 | 79.11 | 80.70 | 82.23 | 82.21 |

- Main's walks spread over the rounds by up to 28.9 ns/token (`b16x77.c`, 24.5 to 53.4) and 12.7 (`l16x38f384.c`); base
  pages throughout kept every unit's within 3.2.
- Base pages throughout read the bodies on eight lanes fastest of the base-page trees: `sqlite3.c` 5.7% faster than
  main, `b16x77.c` 18.4%, `l16x38f384.c` 14.5%, `h16x38.c` 3.4% and `x16x19.c` 1.5%, and `h16x19.c`, `h16x10.c` and
  `00200.c` (two bodies, on two lanes) 3.9 to 6.2% slower. The columns alone in base pages read every unit slower than
  base pages throughout: the binding table, which the lanes don't write, is no cheaper in huge pages.
- `pop`'s walks were the fastest of all, but the phases after the merge read committed zero pages where they had read
  the huge zero page, which costs no memory traffic: its `rest` on eight lanes took 4.1 ns/token more than main's on
  `sqlite3.c`, which read 4.8% slower than main.
- On one lane, where nothing races, base pages read five units 2.6 to 6.2% slower than main, and `sqlite3.c`,
  `b16x77.c` and `l16x38f384.c` 3.5 to 7.2% faster. #791's head therefore keeps the huge pages on one lane, as source
  order's.
- Base-page readings in a process slow its source order's reading, whose huge pages then come from the free lists
  rather than from the pages a huge-page reading just freed: `pr791`'s processes read source order up to 9.3% slower
  (`h16x38.c`), though its code is the same. Campaign SO5 measures source order without them.

## Campaign A5: five rounds' walks

A2's 43 units, five rounds, 11 jobs a lock hold (`logs/A5.txt`, `scripts/a5.sh`): the head `3b87d0c9` on 2, 3, 4 and 8
lanes with every lane, and on 8 beside it the base-page control (`pr791`, base pages at every deferred reading) and
main. `tables/A5.md` has each unit's walks, readings and source order; `tables/A5-summary.txt` every round's walks
(`analysis/a5sum.py`); `tables/summaryA5-full.tsv` the grid (`analysis/grid3.py`).

- The eight-lane walks' spread over the rounds: the head's median over the units 1.40 ns/token and highest 4.94, the
  control's 1.12 and 5.68, main's 1.33 and 37.79. Main's passes 5 on 12 units (`h16x77.c` 37.8, `x16x77.c` 27.2,
  `l8x38f384.c` 22.6, `l16x10f384.c` 18.7, `b16x77.c` 17.5 among them); the head's on none (at most 4.9, `b16x19.c`),
  the control's on two (`b16x19.c` 5.7, `b16x5.c` 5.1).
- Against main on eight lanes with every lane, the head reads the units 1.7% slower by the median (22.0% faster to 9.5%
  slower), the control 1.0% slower (25.8% faster to 10.7% slower): the racing units gain, units of few or short bodies
  lose, and the rule reads most of those on one lane. On one lane, the head 0.4% slower (2.2% faster to 3.3% slower),
  with the same pages as main's, and the control 3.1% slower (14.0% faster to 7.4% slower).
- Source order in A5's processes: the head 1.1% slower than main by the median, the control 4.0%.

## The lane rule fitted again

`analysis/rule3.py` (record deferred-copies-697's, unchanged, as `grid3.py`) on A5's grid of the head: for each pair of
constants, the rule's lanes for each unit, the gains it forgoes against each unit's best lane count, summed in
percentage points, and its worst unit's change on its lanes against one lane (`tables/fitA5.txt`,
`tables/fitA5-fine.txt`; `tables/fitA5-rule.txt` each unit at 1,280 and 3; `tables/fitA5-rounds.txt` each round's grid
apart).

- 1,024 tokens and a quarter of the top level's, the constants before, forgo 49.4 points and read the worst unit 4.8%
  slower on its two lanes than on one. A second lane's first touches of base pages cost more than of huge pages, and
  more with a larger top level, whose walk mapped the zero page into more of the arena.
- 1,280 tokens and a third forgo 45.3 and read the worst unit 2.1% slower, with 31 of the 43 units within one point of
  their best. They do better than 1,024 and a quarter in four of the five rounds (all but the fourth), and replace them
  (`62142bec`). They read every c-testsuite program on one lane, `00204.c` too (2,282 tokens beyond its critical path,
  5.4% faster on two lanes than on one).
- 64 tokens and half the top level's forgo 40.7 points, but 128 and a half forgo 52.3: the difference is two lanes for
  `00204.c` and for `00213.c`, of 460 tokens, too narrow a fit to take.

## Campaign B5: by each tree's rule

A2's 43 units, the head `95fc3668` (with the refitted rule) and main, each by its own rule on up to eight lanes, five
rounds, 22 jobs a lock hold (`logs/B5.txt`, `scripts/b5.sh`). The medians of the rounds, in ns/token, and each tree's
rule against one lane in the same processes (the median, lowest and highest of the rounds); `tables/B5-phases.txt` has
each unit's phases, head less main (`analysis/b5phases.py`):

| Unit | Head's lanes | Main's lanes | Head, rule against 1 | Main, the same | Head on its lanes | Main on its | Head against main |
| --- | ---: | ---: | --- | --- | ---: | ---: | ---: |
| `00200.c` | 1 | 1 | +0.4% (-0.9 to +0.7) | +0.3% (-0.0 to +0.6) | 38.82 | 38.94 | -0.3% |
| `00204.c` | 1 | 2 | +0.3% (+0.1 to +0.5) | -6.4% (-6.8 to -5.9) | 63.13 | 59.93 | +5.3% |
| `00182.c` | 1 | 1 | +0.0% (-0.8 to +1.1) | +0.4% (+0.1 to +0.7) | 57.57 | 57.22 | +0.6% |
| `sqlite3.c` | 8 | 8 | -25.1% (-25.8 to -24.9) | -21.1% (-21.8 to -20.9) | 61.73 | 64.74 | -4.6% |
| `l16x19f192.c` | 4 | 5 | -5.0% (-5.5 to -4.4) | -11.7% (-12.6 to -10.8) | 38.99 | 35.94 | +8.5% |
| `l16x38f192.c` | 7 | 8 | -16.0% (-16.5 to -15.7) | -10.4% (-11.9 to -10.3) | 35.73 | 37.38 | -4.4% |
| `l16x38f384.c` | 7 | 8 | -18.1% (-18.6 to -17.0) | -8.4% (-10.5 to -3.7) | 36.26 | 39.94 | -9.2% |
| `l16x77f384.c` | 8 | 8 | -25.5% (-25.7 to -24.2) | -2.3% (-11.8 to -1.0) | 35.01 | 45.42 | -22.9% |
| `l16x5f384.c` | 1 | 2 | +0.7% (+0.0 to +1.2) | -3.6% (-4.1 to -2.9) | 40.70 | 39.20 | +3.8% |
| `l16x10f384.c` | 2 | 3 | -1.8% (-2.7 to -1.7) | -6.2% (-7.5 to -5.2) | 40.31 | 38.53 | +4.6% |
| `l16x19f384.c` | 4 | 5 | -5.0% (-5.2 to -4.3) | -7.4% (-7.9 to -5.7) | 38.69 | 37.47 | +3.3% |
| `l16x10f192.c` | 2 | 3 | -0.8% (-1.4 to -0.0) | -8.1% (-8.4 to -8.0) | 41.82 | 38.82 | +7.7% |
| `l8x38f384.c` | 4 | 5 | -5.1% (-5.8 to -3.7) | -6.0% (-7.0 to -5.5) | 38.82 | 37.77 | +2.8% |
| `l4x38f384.c` | 2 | 2 | -0.7% (-0.9 to -0.1) | -4.9% (-5.8 to -4.5) | 40.72 | 38.25 | +6.5% |
| `d2x1f384s288.c` | 2 | 2 | -0.0% (-3.1 to +1.7) | -5.3% (-6.0 to -3.3) | 40.55 | 37.35 | +8.6% |
| `d2x1f480s240.c` | 3 | 4 | -5.6% (-7.2 to -3.7) | -5.3% (-7.4 to -3.7) | 39.74 | 38.46 | +3.3% |
| `d16x19f384s288.c` | 5 | 6 | -13.1% (-15.0 to -12.4) | -7.4% (-9.2 to +1.0) | 38.42 | 40.63 | -5.4% |
| `d16x19f384s192.c` | 6 | 8 | -12.2% (-12.8 to -9.9) | -7.1% (-7.9 to -6.3) | 37.30 | 39.43 | -5.4% |
| `00213.c` | 1 | 1 | -0.5% (-1.6 to +0.6) | -0.2% (-4.5 to +0.6) | 185.24 | 181.30 | +2.2% |
| `h16x1.c` | 1 | 1 | +0.4% (+0.2 to +0.5) | -0.2% (-0.2 to +0.1) | 52.36 | 52.01 | +0.7% |
| `h16x2.c` | 1 | 1 | -0.5% (-0.7 to +0.1) | +0.1% (-0.2 to +0.7) | 50.81 | 50.65 | +0.3% |
| `h16x5.c` | 1 | 2 | -0.3% (-0.4 to +0.5) | -2.1% (-2.8 to -1.5) | 48.58 | 47.68 | +1.9% |
| `h16x10.c` | 2 | 3 | +2.6% (+0.4 to +3.3) | -4.9% (-7.0 to -4.0) | 47.72 | 44.05 | +8.3% |
| `h16x19.c` | 4 | 5 | -3.5% (-5.3 to -3.1) | -9.1% (-9.9 to -5.7) | 41.94 | 39.29 | +6.7% |
| `h16x38.c` | 7 | 8 | -13.9% (-14.5 to -12.6) | -11.3% (-13.3 to -9.6) | 35.97 | 36.12 | -0.4% |
| `h16x77.c` | 8 | 8 | -23.8% (-24.2 to -23.1) | -3.4% (-13.4 to -1.0) | 34.33 | 43.27 | -20.7% |
| `h16x154.c` | 8 | 8 | -27.7% (-28.3 to -27.3) | -9.5% (-10.3 to -6.3) | 36.00 | 45.48 | -20.8% |
| `h2x40.c` | 1 | 1 | +0.1% (-0.3 to +0.5) | +0.0% (-0.4 to +0.1) | 47.51 | 47.23 | +0.6% |
| `h2x80.c` | 1 | 1 | +0.2% (+0.1 to +0.3) | -0.0% (-0.2 to +0.1) | 45.34 | 45.11 | +0.5% |
| `h2x160.c` | 1 | 1 | +0.0% (-0.7 to +0.5) | +0.2% (+0.0 to +0.3) | 42.16 | 41.89 | +0.6% |
| `h2x240.c` | 1 | 1 | +0.4% (-0.9 to +0.8) | -0.2% (-1.3 to +0.7) | 39.97 | 39.73 | +0.6% |
| `h2x320.c` | 1 | 1 | -0.5% (-1.2 to +1.2) | +0.1% (-0.9 to +2.2) | 40.71 | 40.97 | -0.6% |
| `h2x480.c` | 1 | 1 | +0.5% (-0.1 to +1.3) | +0.7% (-0.6 to +1.5) | 42.79 | 42.52 | +0.6% |
| `h64x1.c` | 1 | 2 | +0.2% (-0.1 to +0.4) | -1.7% (-2.1 to -1.2) | 49.61 | 48.68 | +1.9% |
| `h64x3.c` | 3 | 3 | +0.0% (-3.4 to +1.3) | -6.0% (-7.6 to -5.4) | 46.45 | 43.20 | +7.5% |
| `h64x10.c` | 8 | 8 | -13.7% (-15.1 to -12.9) | -11.3% (-14.4 to -7.3) | 36.37 | 37.46 | -2.9% |
| `b16x5.c` | 3 | 4 | -8.4% (-8.9 to -7.2) | -10.2% (-10.5 to -9.5) | 43.38 | 42.64 | +1.7% |
| `b16x19.c` | 8 | 8 | -17.4% (-19.4 to -13.9) | -23.7% (-24.7 to -22.0) | 30.07 | 27.99 | +7.4% |
| `b16x77.c` | 8 | 8 | -27.6% (-27.7 to -26.7) | -18.6% (-20.6 to -0.9) | 28.11 | 30.95 | -9.2% |
| `x16x10.c` | 1 | 1 | +0.0% (-0.3 to +1.6) | +0.5% (-1.6 to +1.1) | 51.60 | 51.31 | +0.6% |
| `x16x19.c` | 2 | 2 | +0.6% (-0.5 to +1.5) | +0.9% (+0.4 to +1.2) | 51.19 | 49.71 | +3.0% |
| `x16x38.c` | 3 | 4 | -10.8% (-11.4 to -9.7) | -6.4% (-7.1 to -5.2) | 46.42 | 47.77 | -2.8% |
| `x16x77.c` | 5 | 7 | -17.1% (-17.8 to -16.4) | -4.8% (-10.4 to -2.1) | 42.17 | 49.02 | -14.0% |

The head reads the units 0.6% slower than main by the median, from 22.9% faster to 8.6% slower:

- Twelve read more than 1% faster, `sqlite3.c` by 4.6%: their lanes no longer race, and their top level's walk, which
  in huge pages clears every 2 MB region it writes, is up to 5.4 ns/token faster.
- Twelve are within 1%, all but `h16x38.c` on one lane in both.
- Nineteen read more than 1% slower: fourteen units of two to eight lanes whose lanes didn't race in main, by 1.7 to
  8.6%; four that the refitted rule reads on one lane where main's read them on two (`00204.c`, `h16x5.c`, `h64x1.c`,
  `l16x5f384.c`); and `00213.c`, on one lane in both. On the fourteen, in base pages, the merge's pass and the phases
  after it read the arena's untouched pages a 4 KB fault at a time where main's read the huge zero page, 0.6 and 0.9
  ns/token more (the medians), and the lanes' span takes 0.9 more; on the five of them whose lanes the refit leaves as
  they were (`b16x19.c`, `d2x1f384s288.c`, `h64x3.c`, `l4x38f384.c`, `x16x19.c`), the span 0.9 more too.

## Campaign W5: later readings

`--warm` (the state kept from one reading to the next, as a process's readings after its first), diag9's units and
`sqlite3.c` on eight lanes with every lane, the head `3b87d0c9` and main, five rounds, a round's 7 jobs a lock hold
(`logs/W5.txt`, `scripts/w5.jobs`; `tables/W5.md`):

| Unit | Tree | Walks on 8 by round (spread) | On 8 | On 1 | Source order |
| --- | --- | --- | ---: | ---: | ---: |
| `h16x19.c` | main | 42.6 71.9 39.9 34.0 37.6 (37.9) | 37.90 | 41.23 | 38.05 |
| `h16x19.c` | head | 15.4 15.6 22.3 21.5 14.6 (7.7) | 36.91 | 40.33 | 36.78 |
| `h16x38.c` | main | 62.0 61.9 59.2 59.3 62.3 (3.1) | 37.40 | 38.98 | 36.81 |
| `h16x38.c` | head | 26.3 21.7 25.2 26.1 24.9 (4.6) | 32.72 | 38.57 | 36.01 |
| `x16x19.c` | main | 51.4 53.5 51.6 50.4 51.8 (3.2) | 54.21 | 49.17 | 44.64 |
| `x16x19.c` | head | 12.2 11.3 12.3 11.7 12.2 (1.0) | 46.48 | 47.71 | 43.51 |
| `b16x77.c` | main | 73.6 68.4 68.6 70.9 69.4 (5.2) | 36.27 | 37.81 | 36.23 |
| `b16x77.c` | head | 32.8 32.9 33.1 33.4 32.6 (0.7) | 26.15 | 36.26 | 35.28 |
| `l16x38f384.c` | main | 66.4 67.8 67.1 67.4 67.5 (1.4) | 42.95 | 42.14 | 39.49 |
| `l16x38f384.c` | head | 24.4 24.3 24.3 24.7 24.5 (0.4) | 34.16 | 40.93 | 38.04 |
| `h16x10.c` | main | 6.2 6.2 6.1 7.0 6.2 (0.9) | 36.85 | 42.30 | 38.31 |
| `h16x10.c` | head | 12.0 12.1 13.3 17.6 12.5 (5.6) | 40.24 | 42.36 | 38.43 |
| `sqlite3.c` | main | 26.9 27.3 26.8 26.9 27.2 (0.5) | 63.40 | 80.03 | 67.75 |
| `sqlite3.c` | head | 19.1 18.8 19.3 19.5 19.0 (0.7) | 60.06 | 80.29 | 68.36 |

A state's later readings reach their walks at once, and main's lanes race in every round: their walks take 52 to 69
ns/token on four units (the medians), the head's 12 to 33. The head reads those four 12 to 28% faster than main on
eight lanes, `sqlite3.c` 5.3%, and `h16x10.c`, on which main's lanes didn't race, 9.2% slower. A rule for later
readings (#697's item 3) can be fitted on such a grid now that their walks no longer depend on the lanes' timing.

## Campaign S5: `sqlite3.c` by the rule

The frozen `sqlite3.c` by each tree's rule on up to eight lanes, 24 passes, six processes of each of the head
`3b87d0c9` and main, their order alternating, a pair a lock hold (`logs/S5.txt`, `scripts/s5.sh`; `tables/S5.md`). The
medians of the six, in ns/token:

| | head | main |
| --- | ---: | ---: |
| source order | 68.44 (67.95 to 69.69) | 68.47 (68.12 to 68.75) |
| one lane | 81.53 | 81.78 |
| the rule's lanes (8) | 61.30 | 64.57 |
| its walks, summed over the lanes | 20.14 | 27.21 |
| its lanes' span | 4.24 | 5.27 |
| its top level, merge and later phases | 56.84 | 59.03 |
| the rule's lanes against source order | -10.4% | -5.6% |

The head reads `sqlite3.c` 5.1% faster than main by the rule, its walks take 7.1 ns/token less in all, and its top
level's walk, which no longer clears huge pages in the arena, 0.9 less.

## Campaigns SO5 and SOI: source order

SO5: A2's 43 units with `--lanes 1`, so that no reading in either tree's processes is on more than one lane and none
reads anything in base pages, the head `3b87d0c9` and main, five rounds, 22 jobs a lock hold (`logs/SO5.txt`,
`scripts/so5.sh`; `tables/SO5.md`). Against main, the head's source order reads the units 0.5% slower by the median
(0.8% faster to 2.2% slower), `sqlite3.c` 0.8% faster, and its one-lane deferred readings 0.6% slower (0.7% faster to
2.1% slower).

SOI: the same processes under `perf stat -e instructions:u,cycles:u`, three of each of the head `95fc3668` and main in
turn on four units, in one lock hold (`logs/SOI.txt`, `scripts/soi.sh`; `tables/SOI.txt` by `analysis/soisum.py`). The
medians:

| Unit | User instructions, head against main | User cycles | Source order's reading |
| --- | ---: | ---: | ---: |
| `d2x1f480s240.c` | +0.003% | +0.66% | +1.5% |
| `d16x19f384s288.c` | +0.002% | +0.56% | +1.6% |
| `h16x19.c` | +0.005% | +0.47% | +0.8% |
| `sqlite3.c` | +0.005% | +0.47% | +1.1% |

The two trees run the same instructions there, but for the plan's sums over the bodies before each deferred reading
among them (70,000 to a million instructions a process), and their cycles differ by less than the 2% that two builds of the same
code differ by on the 9700X (Buster's `docs/profiling.md`, "Comparing two versions"). The source order readings of SOI
and SO5 disagree in sign on `sqlite3.c` (+1.1% and −0.8%).

## Tests

- `test-checker-deferred` on the 9700X, a lock hold each (`logs/tests-head-*.txt`): `3b87d0c9` and `95fc3668`, 111
  fixtures, 2,554 checks, 1,080 merged, 0 failures.
- `test-checker-corpus --deferred 8` on `3b87d0c9` (`scripts/corpus.sh`): c-testsuite's single-exec programs at
  `5c7275656d751de0e68b2d340a95b5681858ed07` (an existing checkout on the host at that commit; 220 accepted by clang
  and by the checker, 449 bodies, 0 differences) with `--id-order 153`, and the frozen `sqlite3.c` with `--symbols`
  (2,608 bodies, 0 differences, its symbols the same as clang's but the one documented inlined function;
  `logs/checker-sqlite-head-3b87d0c9.tsv`).
- The mutation check (`scripts/mutants.sh`, `logs/mutants.txt`): four mutants of `3b87d0c9`, each built at `-O1` on the
  owner's laptop, where `test-checker-deferred` must fail. The lanes never planned (`planned` always 1): 669 failures.
  #791's first head's policy, base pages at every deferred reading: 432. `check_input_sparse_arena` ignoring the policy:
  1, the mapping check. The second largest body taken wrong in the plan: 27, the rule's fixtures.

## Limitations

- The driver's `-fsyntax-only` of `sqlite3.c` under `perf stat -r 11`, which `scripts/so5.sh` ran after SO5, failed at
  its first argument in both trees (`--no-default-config` is the benchmarks' option, not the driver's; `logs/driver.txt`,
  exit status 1 in its first round's two runs, after which its other rounds were stopped), and gives no figure. The
  driver reads by source order, whose arena this change leaves as it was; SO5 and SOI measure source order's reader.
- Campaign D1's trees `cols`, `multicols` and `pop` exist only as the commits named above and their patches here.
- The mutation check ran on the owner's laptop (AMD Ryzen 9 7940HS, a Zen 4 core with AVX-512), not on the 9700X.
- Everything ran with transparent huge pages `always` (defrag `madvise`); other settings weren't measured.
- The synthetic units are A2's, of one statement shape; B5's trade-off on real code is `sqlite3.c`'s and c-testsuite's
  (all of whose programs the rule reads on one lane).
