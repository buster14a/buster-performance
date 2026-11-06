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

Every run held the host's lock (`scripts/lock.sh`), one hold per script. Every object of every configuration is the
same bytes (`*/objects*.sha256`, `final/objects-unique.txt`).

## Main's baseline (`main-ec5f0f6b/`, `scripts/measure.sh`, `scripts/pages.sh`)

- **One compile**, pinned to CPU 2: 140.4 ms (`perf stat -r 7`), 67.7 MB/s of source, 1,636 M user instructions,
  676 M user cycles and 94 M kernel cycles. Peak RSS 293.7 MB (`--time-stages`, 7 runs).
- **The pages it faults:** 163 transparent huge pages and about 5,950 base pages a compile (`vmstat.txt`, 5 runs), about
  349 MB, against the 294 MB peak.
- **Its stages** (median of 7): `check-input` 59.7 ms and +149.9 MB of the peak, `check-program` 27.0 ms,
  `check-expressions` 10.2 ms, `lower` 10.3 ms, `preprocess` 9.8 ms and +47.1 MB, `parse` 7.4 ms and +79.7 MB,
  `tier0` 5.1 ms.
- **Its profile** (`profile-main/profile.txt`, `perf record -F 20000` of 5 compiles): the kernel's `clear_page_erms`
  is the largest function, 8.77% of the samples, then `check_input_run` 7.45% and `check_driver_common_warnings`
  4.82%.

With the arenas in base pages (`BUSTER_HUGE_PAGES=0`) against huge pages, one compile at a time, 7 rotated runs each
(`pages-hp*.txt`):

| command | huge pages | base pages |
| --- | ---: | ---: |
| `-E` | 17.4 ms, 52.1 MB | 19.1 ms, 36.5 MB |
| `parse` | 18.0 ms, 131.9 MB | 22.4 ms, 76.6 MB |
| `-c` | 140.0 ms, 293.7 MB | 166.7 ms, 225.0 MB |

(`wait4` peaks.) Alone, base pages cost `-c` 19%: 73,137 faults against 6,613, and 8% more user cycles.

## Several compiles at once (`workers-main-hp*/`, `scripts/workers.sh`)

1, 2, 4 and 8 independent processes, each pinned to its own physical core (CPUs 0 to 7), 5 rounds with the counts
rotating; each round's wall time is from the first start to the last exit:

| compiles at once | huge pages | base pages (`BUSTER_HUGE_PAGES=0`) |
| ---: | ---: | ---: |
| 1 | 141.9 ms, 67.0 MB/s | 168.5 ms, 56.4 MB/s |
| 2 | 161.4 ms, 117.8 MB/s | 181.3 ms, 104.8 MB/s |
| 4 | 206.6 ms, 184.0 MB/s | 206.2 ms, 184.4 MB/s |
| 8 | 326.1 ms, 233.2 MB/s | 282.0 ms, **269.7 MB/s** |

`perf stat -a` of one round of 8 (`perf-w8.csv`): huge pages took 10,651 M user cycles and 3,007 M kernel cycles, base
pages 9,080 M and 2,813 M. That is 15% fewer user cycles and 6% fewer kernel cycles, though base pages fault 11
times as often.

## Where the peak holds huge pages it uses little of (`diag/`)

On this session's cloud VM (Intel Xeon, THP `madvise`, which the arenas' own advice turns on), with the arenas' huge
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

## The branch against main (`final/`, `scripts/final.sh`)

The branch's executable (SHA-256 `29a2c890…cf16`, `final/identities.txt`) is the branch's two commits on `ec5f0f6b`
plus an experiment-only knob in `main.c`: `BUSTER_EXP_FLOOR_MB=N` gives every arena of the calling thread N MB of base
pages first (`arena_small_floor`). The knob tests whether a fixed floor could do what the busy test does. It is not
in the branch.

Six configurations, each on 1, 2, 4 and 8 independent processes pinned one per physical core:
- `main`, main's executable as it runs;
- `br`, the branch as it runs;
- `br-hp1`, the branch with `BUSTER_HUGE_PAGES=1`, its small arenas alone;
- `br-hp0`, the branch with `BUSTER_HUGE_PAGES=0`;
- `br-f8` and `br-f32`, the branch with huge pages and floors of 8 and 32 MB.

7 rounds, configurations and counts rotating, medians:

| configuration | 1 at once | 2 at once | 4 at once | 8 at once |
| --- | ---: | ---: | ---: | ---: |
| `main` | 141.5 ms, 67.2 MB/s | 160.8 ms, 118.2 MB/s | 205.6 ms, 184.9 MB/s | 325.0 ms, 234.0 MB/s |
| `br` | 141.0 ms, 67.4 MB/s | 161.1 ms, 118.0 MB/s | 206.6 ms, 184.1 MB/s | 281.4 ms, **270.3 MB/s** |
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

- **Eight at once.** The branch runs 15.5% faster than main (270.3 against 234.0 MB/s): every process found the host
  busy and took base pages, as fast as `BUSTER_HUGE_PAGES=0`.
- **One, two and four at once.** It runs as fast as main: one compile alone keeps huge pages. The small arenas alone
  (`br-hp1`) take 6.5 MB off the peak, within the noise in time.
- **A fixed floor does neither.** 8 and 32 MB of base pages in front of every arena cost a compile alone 6% to 8%, and
  gain 4% on 8.
- **Every object is the same bytes:** 54 objects, one hash (`final/objects-unique.txt`).

`scripts/summarize.py final` prints both tables from the raw files.

## Limits

- One input, one host. The busy test's share (a quarter of the CPUs online) is this host's crossover, 4 of 8 cores.
- The worker rounds start all their processes at once, where a build starts a compile as another ends; the busy test
  reads the runnable tasks when each process starts.
- `BUSTER_EXP_FLOOR_MB` exists only in the measured executable (`final/`'s `br-f*` configurations), not in the branch.
- The VM's attribution is the arenas' own; the 9700X's peak (293.7 MB) is within 1.2% of the VM's (297.0 MB).
- `scripts/fe-workers.sh` (the front end alone on 1 and 8) and `scripts/profile8.sh` (a system-wide profile of 8 at
  once) were queued after the branch's measurement; their results are not in this record.
- The branch's measured executable predates the branch's documentation, some comment edits, `tests/peak-rss.c`'s
  base pages, and a refactor of how `--time-stages` learns the `busy` decision (a `CheckClock` field the driver sets,
  so that `tests/peak-rss.c` still compiles). The compiler's behavior is otherwise the branch head's.
