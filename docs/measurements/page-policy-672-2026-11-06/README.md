# Huge pages, base pages and the other cores (buster#672), 2026-11-06

The frozen `sqlite3.c`'s `-c` at Buster main [`ec5f0f6b`](https://github.com/buster14a/buster/tree/ec5f0f6be04660d5b36ec688ba3d8ed3511ee85b)
on the Ryzen 7 9700X, one compile alone and several at once, with the arenas' huge pages and without them. Also: where
the compile's peak holds huge pages it uses little of, by arena. This record backs Buster's branch
`claude/dreamy-franklin-mxyhql` (buster#672):
- its small front-end arenas start with base pages;
- a compile that finds the host busy when it starts takes base pages.

## Sources and identities

| what | identity |
| --- | --- |
| Buster main | [`ec5f0f6be04660d5b36ec688ba3d8ed3511ee85b`](https://github.com/buster14a/buster/tree/ec5f0f6be04660d5b36ec688ba3d8ed3511ee85b) |
| main's executable (`./build.sh`, Release, native, debug information) | SHA-256 `42fda678ee1a663e798b335bdb6af3a05c88a6ec2a3d6dc9168b9b59a091b848` |
| the branch's executable | SHA-256 `29a2c89038064edd081cde3946cd184ec8da0384be733986b0bf3fea3905cf16`: the branch's code on `ec5f0f6b`, plus an experiment-only `BUSTER_EXP_FLOOR_MB` knob in `main.c` (below) |
| input | the frozen corpus's `sqlite3.c`, SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d` |
| host | `benchpress`, AMD Ryzen 7 9700X (8 cores, 15 CPUs online), Linux 6.18.50-2-lts, THP `always` (defrag `madvise`), CPU 2's governor and EPP `performance` |
| toolchain | the host's clang 23.1.1, perf 7.2.9 |

The options are the 9700X job's `compile_time` step's, with one lane:

```sh
-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c --lanes 1
```

**Scope.** This is exploratory evidence for buster#672 and buster#1561, not hardware qualification. Every script
below ran under the host's lock (`scripts/lock.sh`), but each took one hold for its whole series of runs, against the
host's rule of a hold per run ("Lock holds and their limits", below). The 9700X job's own steps remain the
qualification. Every timing below is an observed figure from unpaired runs in a fixed order, with unchecked
processes. None of them shows that one executable or page mode is faster than another. A repeat under the host's rule
needs its own procedure, reviewed with a negative-test harness and admitted by the hardware coordinator. It isn't
part of this record, and none of it has run.

The objects that were hashed are the same bytes (`*/objects*.sha256`, `final/objects-unique.txt`). None of them comes
from a timed worker round. Each script hashed its objects at its end, after later runs had written over the timed
rounds' objects at the same paths:
- `measure.sh`'s come from its `perf stat` runs;
- `workers.sh`'s from its two `perf stat -a` runs;
- `final.sh`'s from its `--time-stages` runs and its decision round.

The worker rounds' processes were not checked one by one either ("Lock holds and their limits").

## Lock holds and their limits

The host's `README-9700x.md` asks for a hold per build, test, benchmark or perf run, never around a series of runs. This
session's scripts each took a single hold (`lock.sh SCRIPT`) and ran a series inside it, all on 2026-11-06:

| hold | what ran inside it |
| --- | --- |
| main's build (`./build.sh`) | one build |
| `measure.sh` | 7 `--time-stages` compiles, 5 `vmstat` compiles, `perf stat -r 7`, 5 rounds of 8 concurrent compiles, one `perf stat -a` round of 8 |
| `pages.sh` | `time-runs` of `-E`, `parse` and `-c` in both page modes, 6 `--time-stages` compiles |
| `workers.sh` (huge pages) | 20 rounds of 1 to 8 concurrent compiles, `perf stat -a` of 1 and of 8 |
| `workers.sh` (base pages) | the same |
| `profile.sh` | `perf record` of 5 compiles |
| the branch's build | one build |
| `fe-workers.sh` | 40 rounds of 1 or 8 concurrent `parse` or `-E` (not in this record) |
| `final.sh` | 18 `--time-stages` compiles, 168 rounds of 1 to 8 concurrent compiles, 6 rounds of 8 with `--time-stages` |
| `profile8.sh` | `perf record -a` of 3 rounds of 8 (not in this record) |

- **The series.** Each hold covered a series of runs where the host asks for one hold per run. No hold recorded when
  it took or gave back the lock, so the record cannot say how long any hold lasted or how it delayed anyone else's.
- **Concurrent processes in one hold.** The worker rounds start up to 8 compiler processes at once inside a hold. That
  is the measurement itself, which needs the whole machine.
- **No receipts.** No script recorded the owner file while it held the lock, so the record has no positive receipt
  that a given run held it. Only `exclusive.sh`'s own mechanism and the queue's waiting messages in the session's logs,
  which aren't in this record, show it did.
- **No per-process status.** The worker rounds started their processes in the background and waited for all of them,
  without checking each one's exit status. Their objects were overwritten round after round, and then by the runs
  after the rounds, whose objects alone were hashed. The record therefore shows that the hashed objects match. It does
  not show that any timed round's processes succeeded, and the wall times of a round with a failed process would mean
  nothing.

A repeat under the host's rule, one hold per run, is not part of this record. A first draft of its scripts went
through two reviews here (buster-performance#296). They found that it needs:
- the exact base, head, integrated tree, corpus, headers and toolchain pinned and rechecked at each boundary;
- a clean build with a positive lock receipt and a source and environment manifest;
- every retained object rechecked against its manifest before completion;
- a negative-test harness exercised without the shared host.

The hardware coordinator must also decide whether a batch of concurrent compiles may count as one run. The draft was
removed from this record and was never run.

## Main's baseline (`main-ec5f0f6b/`, `scripts/measure.sh`, `scripts/pages.sh`)

- **One compile**, pinned to CPU 2: 140.4 ms (`perf stat -r 7`), 67.7 MB/s of source, 1,636 M user instructions,
  676 M user cycles and 94 M kernel cycles. Peak RSS 293.7 MB (`--time-stages`, 7 runs).
- **Pages faulted, illustratively:** `/proc/vmstat`'s system-wide deltas around 5 single compiles (`vmstat.txt`) are
  163 transparent huge pages and about 5,950 base pages each, about 349 MB, against the 294 MB peak. They count the
  whole host, not the compile alone.
- **Its stages** (median of 7): `check-input` 59.7 ms and +149.9 MB of the peak, `check-program` 27.0 ms,
  `check-expressions` 10.2 ms, `lower` 10.3 ms, `preprocess` 9.8 ms and +47.1 MB, `parse` 7.4 ms and +79.7 MB,
  `tier0` 5.1 ms.
- **Its profile** (`profile-main/profile.txt`, `perf record -F 20000` of 5 compiles): the kernel's `clear_page_erms`
  is the largest function, 8.77% of the samples, then `check_input_run` 7.45% and `check_driver_common_warnings`
  4.82%.

With the arenas in base pages (`BUSTER_HUGE_PAGES=0`) against huge pages, one compile at a time (`pages-hp*.txt`).
`time-runs` ran 7 runs of each command, rotating the three commands' order within one page mode. The huge-page set
ran first, then the base-page set, not interleaved:

| command | huge pages | base pages |
| --- | ---: | ---: |
| `-E` | 17.4 ms, 52.1 MB | 19.1 ms, 36.5 MB |
| `parse` | 18.0 ms, 131.9 MB | 22.4 ms, 76.6 MB |
| `-c` | 140.0 ms, 293.7 MB | 166.7 ms, 225.0 MB |

(`wait4` peaks.) Alone, base pages' observed `-c` median was 19% above huge pages', with 73,137 faults against 6,613
and 8% more user cycles.

## Several compiles at once (`workers-main-hp*/`, `scripts/workers.sh`)

1, 2, 4 and 8 independent processes, each pinned to its own physical core (CPUs 0 to 7). 5 rounds, each running the
counts in the same order, 1, 8, 2 and 4, with no rotation. The two page modes ran in separate scripts and holds, one
after the other, not interleaved. Each round's wall time is from the first start to the last exit:

| compiles at once | huge pages | base pages (`BUSTER_HUGE_PAGES=0`) |
| ---: | ---: | ---: |
| 1 | 141.9 ms, 67.0 MB/s | 168.5 ms, 56.4 MB/s |
| 2 | 161.4 ms, 117.8 MB/s | 181.3 ms, 104.8 MB/s |
| 4 | 206.6 ms, 184.0 MB/s | 206.2 ms, 184.4 MB/s |
| 8 | 326.1 ms, 233.2 MB/s | 282.0 ms, 269.7 MB/s |

`perf stat -a` of one round of 8 (`perf-w8.csv`): huge pages took 10,651 M user cycles and 3,007 M kernel cycles, base
pages 9,080 M and 2,813 M. These count the whole host over one round each, whatever else ran, and attribute nothing
to a compile. One compile alone faults 11 times as often in base pages (`pages-hp*.txt`).

## Where the peak holds huge pages it uses little of (`diag/`)

This attribution is illustrative, from another system. On this session's cloud VM (Intel Xeon, THP `madvise`, which
the arenas' own advice turns on), with the arenas' huge
pages forced on (`BUSTER_HUGE_PAGES=1`) and off (`=0`), main's `-c` peaks at 297.0 MB against 228.0 MB.
`diag/diag-instrumentation.patch` (never for Buster's tree) logs each arena mapping with its call stack and the TSC
(`BUSTER_ARENA_LOG`), pushes of 16 KB or more, and copies `/proc/self/smaps` at every `--time-stages` mark
(`BUSTER_SMAPS_DIR`). `diag/attribute.py` and `diag/permap.py` match each mapping's resident memory to the call site
that reserved it. The results are in `diag/by-site-hp*.txt` (every mark) and `diag/peak-by-mapping.txt` (the peak, huge
against base in KB).

At the peak (the backend's end), the differences larger than 0.5 MB:

| arena | huge pages | base pages | difference |
| --- | ---: | ---: | ---: |
| the checker driver's arena (`check_driver_command`) | 86,020 KB | 59,052 KB | 26,968 KB |
| the checker driver's output arena | 43,072 KB | 35,308 KB | 7,764 KB |
| the preprocessor's output columns (`pp_tokens_reserve`) | 12,544 KB | 6,944 KB | 5,600 KB |
| the history replay's output columns (one warning's, buster#1339) | 12,544 KB | 6,944 KB | 5,600 KB |
| the checker driver's scratch | 56,832 KB | 53,328 KB | 3,504 KB |
| the thread's scratch (`scratch_begin`) | 4,160 KB | 1,048 KB | 3,112 KB |
| the parser's token columns | 9,736 KB | 6,968 KB | 2,768 KB |
| the type table's index | 2,112 KB | 128 KB | 1,984 KB |
| the file cache's records arena | 2,112 KB | 268 KB | 1,844 KB |
| the file cache's bytes arena | 2,112 KB | 376 KB | 1,736 KB |
| the replay's history arrays (`pp_history_grow`) | 4,748 KB | 2,592 KB | 2,156 KB |
| the object writer's two arenas | 10,352 KB | 8,340 KB | 2,012 KB |
| the file cache's three token columns | 14,528 KB | 11,152 KB | 3,376 KB |

- **The checker's three arenas** hold 38 of the 69 MB: buster#628's.
- **The replay** is a second preprocessing of the whole unit, which `sqlite3.c`'s one `-Wempty-body` warning (a false
  one, buster#1339) asks for to place itself in its macro. It adds about 18 MB to the peak; buster#1547 asks for the
  history only where an enabled warning needs it.
- **Four arenas** each took a huge page or two for under a megabyte: the index, the file cache's records and bytes
  arenas, and the thread's scratch. The thread's scratch took two because a large file's windowed preparation
  (`pp_prepare_windows`) pushes three arrays of a word for every 64 of its bytes, 3.5 MB for `sqlite3.c`, and touches
  each one's start.

The branch's first commit gives those four base pages for their first 2 or 4 MB. On the VM, the peak falls from 296.8 to
288.3 MB (two runs each, 386 more faults), with the object the same bytes.

This attribution is the VM's, from instrumentation that isn't in any measured 9700X executable. It shows where the VM's
compile held its pages. It does not by itself show the 9700X's allocations, or cause the 9700X's timings.

## The branch against main (`final/`, `scripts/final.sh`)

The branch's executable (SHA-256 `29a2c890…cf16`, `final/identities.txt`) is not the PR head's. It was built from the
branch's two commits on `ec5f0f6b` as they stood before the PR's head, with two differences:
- an experiment-only knob in `main.c`, `BUSTER_EXP_FLOOR_MB=N`, gives every arena of the calling thread N MB of base
  pages first (`arena_small_floor`). It tests whether a fixed floor could do what the busy test does, and it is not in
  the branch;
- `--time-stages` reads the busy decision directly, where the head copies it into a `CheckClock` field
  ("Limits", below).

Six configurations, each on 1, 2, 4 and 8 independent processes pinned one per physical core:
- `main`, main's executable as it runs;
- `br`, the branch as it runs;
- `br-hp1`, the branch with `BUSTER_HUGE_PAGES=1`, its small arenas alone;
- `br-hp0`, the branch with `BUSTER_HUGE_PAGES=0`;
- `br-f8` and `br-f32`, the branch with huge pages and floors of 8 and 32 MB.

7 rounds, medians. Neither the configurations nor the counts rotate (`scripts/final.sh`): each round runs the
configurations in the order listed, and each configuration on 1, 8, 2 and 4 in that order.

| configuration | 1 at once | 2 at once | 4 at once | 8 at once |
| --- | ---: | ---: | ---: | ---: |
| `main` | 141.5 ms, 67.2 MB/s | 160.8 ms, 118.2 MB/s | 205.6 ms, 184.9 MB/s | 325.0 ms, 234.0 MB/s |
| `br` | 141.0 ms, 67.4 MB/s | 161.1 ms, 118.0 MB/s | 206.6 ms, 184.1 MB/s | 281.4 ms, 270.3 MB/s |
| `br-hp1` | 141.0 ms, 67.4 MB/s | 161.7 ms, 117.6 MB/s | 204.7 ms, 185.8 MB/s | 322.5 ms, 235.9 MB/s |
| `br-hp0` | 169.5 ms, 56.1 MB/s | 181.9 ms, 104.5 MB/s | 207.6 ms, 183.2 MB/s | 282.7 ms, 269.0 MB/s |
| `br-f8` | 150.7 ms, 63.1 MB/s | 169.0 ms, 112.5 MB/s | 210.0 ms, 181.1 MB/s | 312.2 ms, 243.6 MB/s |
| `br-f32` | 153.8 ms, 61.8 MB/s | 171.3 ms, 111.0 MB/s | 210.2 ms, 180.9 MB/s | 310.2 ms, 245.2 MB/s |

Each configuration's `--time-stages` alone (3 runs on CPU 2, medians), and the `huge-pages` decision of each process in
a last round of 8 at once (`final/decide-*.txt`):

| configuration | peak RSS alone | the clock's span alone | minor faults alone | huge pages alone | 8 at once decided |
| --- | ---: | ---: | ---: | --- | --- |
| `main` | 293,720 KB | 139.9 ms | 6,747 | `system` | `system` ×8 |
| `br` | 287,180 KB | 138.7 ms | 7,143 | `system` | `busy` ×8 |
| `br-hp1` | 287,184 KB | 139.5 ms | 7,144 | `system` | `system` ×8 |
| `br-hp0` | 227,304 KB | 162.6 ms | 73,276 | `off` | `off` ×8 |
| `br-f8` | 268,340 KB | 146.5 ms | 23,314 | `system` | `system` ×8 |
| `br-f32` | 267,484 KB | 149.3 ms | 30,013 | `system` | `system` ×8 |

These are observed medians of unpaired rounds in a fixed order, with unchecked processes, not a comparison that
establishes a difference or its absence:
- **Eight at once.** The branch's median round was 281.4 ms against main's 325.0 ms (270.3 against 234.0 MB/s),
  close to `br-hp0`'s 282.7 ms. In the one round whose processes reported their decision (`decide-*`), each of the 8
  reported `busy`. The timed rounds recorded no decision and no per-process status.
- **One, two and four at once.** The branch's and main's medians were within 0.5% of each other. Alone, its
  `--time-stages` runs reported `huge-pages system`. With huge pages forced (`br-hp1`), its peak alone was 6.5 MB
  below main's.
- **Fixed floors.** The 8 and 32 MB floors' medians were 6.5% and 8.7% above main's alone, and 3.9% and 4.6% below
  main's at 8.
- **The objects hashed are the same bytes:** 54 objects, one hash (`final/objects-unique.txt`). They are the six
  configurations' `--time-stages` objects and the 48 of the decision round. The decision round ran after the seven
  timed rounds and wrote over their objects at the same paths, so no timed round's object was hashed.

`scripts/summarize.py final` prints both tables from the raw files.

## Limits

- One input, one host. The busy test's share, a quarter of the CPUs online or 4 of this host's 15, was chosen where
  the two page modes' observed medians were closest (4 at once). That is not an established crossover.
- The worker rounds start all their processes at once, where a build starts a compile as another ends; the busy test
  reads the runnable tasks when each process starts.
- `BUSTER_EXP_FLOOR_MB` exists only in the measured executable (`final/`'s `br-f*` configurations), not in the branch.
- The VM's attribution is the arenas' own; the 9700X's peak (293.7 MB) is within 1.2% of the VM's (297.0 MB).
- `scripts/fe-workers.sh` (the front end alone on 1 and 8) and `scripts/profile8.sh` (a system-wide profile of 8 at
  once) ran after the branch's measurement, each in one hold ("Lock holds and their limits"). Their results are not in
  this record.
- **The measured branch executable's source** is retained exactly: `final/measured-tree.diff` is its worktree's
  whole diff against `ec5f0f6b`, with no untracked files outside `build/`. Its `build/compiler` still had the measured
  SHA-256 when the diff was taken. `final/measured-to-head.diff` is that tree's `src` and `tests` diff to the PR head
  `9d6b50e3`: the experiment-only knob, the `CheckClock` field the driver sets for `--time-stages`, `tests/peak-rss.c`'s
  base pages, and comments in `lane.c`. The build environment (the host's clang 23.1.1, CMake, the libraries) has no
  manifest. The executable is not the head's, and no measurement here is of the head's.
- **Causes.** The timings compare executables and page modes. The counters are system-wide, and the attribution comes
  from the VM. Together they fit the explanations given (the 2 MB clears, their locality), but they do not establish
  them.
