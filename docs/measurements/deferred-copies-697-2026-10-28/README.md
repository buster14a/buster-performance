# A deferred lane's copy at a process's first reading, 2026-10-28

The 9700X's measurements for the Buster PR of issue [#697](https://github.com/buster14a/buster/issues/697)'s item 2, and
for the issue's last two Done-when items. At a process's first reading, a deferred lane copied the top level's reader,
and most of the copy was the first touches of its pages. The PR changes five things:

- a lane has per-name columns of its own, at places they keep from one reading to the next, rather than copies of the
  top level's;
- a body's binding stream holds proxies of the file-scope events its heads reach, rather than a copy of the top level's
  events;
- a lane's copy of the type table keeps its index's slots where they have the room, with a smaller slack;
- the deferred reader's own arenas are base pages;
- a lane commits the pages of its per-name entries before its bodies.

The last two came out of campaign A3, which measured the first three alone. Then the lane rule is fitted again on
[record A2](https://github.com/buster14a/buster-performance/tree/e4ae6019ed75575d49f9e75fba752820a1da9050/docs/measurements/deferred-lane-costs-113-2026-10-27)'s
43 units, and item 1's phases on `sqlite3.c` are measured against source order after items 1, 2 and 4, for #151. It is
the last of the three PRs that #697's claim names. Cited by Buster's `docs/c-deferred-bodies.md`.

In short: at a process's first reading a lane's copy now takes 41 µs on two lanes and 71 µs on eight (the median of 42
units; 245 and 467 µs on `sqlite3.c`), against main's 72 and 125 µs and A2's 69 and 100 µs. With the state's own arenas
in base pages and a lane's per-name entries committed, which campaign A3 showed the copy had hidden, item 2 reads A2's
43 units 26.3% faster than main on eight lanes and 23.6% faster on one (the medians of campaign A4), and every unit 5.5
to 43.1% faster than main by the lane rule (campaign B4). Fitted again on A4's grid, the rule keeps its constants. On
the frozen `sqlite3.c`, eight lanes read 5.6% faster than source order after items 1, 2 and 4, where main's read 1.1%
faster (campaign S4). By the rule, both trees read c-testsuite's 220 programs on one lane but `00204.c`, and item 2
reads them 30.5% faster than main (the median; campaign CT4). The diagnostics also found that the lanes race to clear
the huge pages of the checker's own arena of rare columns (#572), more often or less by their timing; the PR leaves that
arena as it is, since base pages there cost source order's reader up to 6.6% on the units measured.

## Sources and inputs

| Tree | Buster source | Files | Source manifest's SHA-256 |
| --- | --- | ---: | --- |
| `main3` | main `abc6bf24` (#728 merged: #697's items 4 and 1) | 536 | `d02ef3e1bcb9a855506bcd35dbe1a9500f98780498a58df534a9e56e1ad94a95` |
| `item2` | `a2855804`: `main3` with item 2's first three commits (`c424ab9`, `7d359c5`, `a285580`) | 536 | `989aa1a3d478f6b7e326ff935e4d37002f948389d23e475114fabd472ffcf56f` |
| `main3-nothp` | `main3` with the deferred state's own arenas advised `MADV_NOHUGEPAGE` (`scripts/patch_nothp.py`) | 536 | `84669c2e83006ec7bedd4ffffe9bbc469a352623045bb6804931477b00e61860` |
| `item2-nothp` | `item2` with the same | 536 | `c2192eb605a3d183d8d7f9d7de72b47d19fbee1ee6fc09a1153ab6752a4363fe` |
| `stepA-nothp` | `c424ab9` (the index's slots) with the same | 536 | `8634005226ded104896c7e93e037ce0805532406b6f903a04eac6475d8eca899` |
| `stepAB-nothp` | `7d359c5` (and the per-name columns) with the same | 536 | `c4a7e5fd963105b59960ee743a66a3789116cc6390fc97a9222da71f71e8014f` |
| `item2-nothp-pop` | `item2-nothp` with each lane's whole names arena committed as it is laid out (`scripts/patch_populate.py`) | 536 | `b2de4d3d51a9252d82b36795b71e09184d13ce1159f1083570ef69c679772727` |
| `final4` | `main3` with `patches/final4.diff`: item 2's five commits, the PR's commits (`4085d12`) but for three comments | 536 | `e19cb6443629312a3da44e7e7411f1ecd1613616f99263cb8a374ad26e8b7f78` |
| `item2-nothp-sparse` | `item2-nothp` with `check_input_run`'s arena of rare columns in base pages throughout (`scripts/patch_sparse.py`) | 536 | `824342211cc0e232fd99a4930c6907b7144694f9b77dd29745ec475299b16a2b` |
| `final4-sparse` | `final4` with the same | 536 | `bdb5390e8e6f665b9954907985d1db5467f1fb15192d8ab82b2e1ee23e97468e` |
| `head` | `d4b88131`, a trial merge of the PR's commits (`4085d12`) with main `9bb5060e`, never pushed: the PR's code with main merged in, but for docs, built from a bundle (`scripts/4-head.sh`) for its tests alone | 545 | `4f44e6b9ee80a44340dc95c0fbab3eee06cda8eb4a02ace44293f63761623133` |

Each manifest (`source-*.sha256`) lists the SHA-256 of `build.sh` and of every file under `src/` of the tree, as
`sha256sum build.sh; find src -type f | LC_ALL=C sort | xargs sha256sum` writes them. `main3`'s and `item2`'s match
`git archive` of their commits, `final4`'s `abc6bf24`'s with `patches/final4.diff` applied, and `head`'s its trial
merge's tree; `stepA-nothp` and `stepAB-nothp` match their commits' but for `c_check_deferred.c`, which the patch
changes, and the `-sparse` trees their bases' but for `c_check_input.c`, which `patch_sparse.py` changes. `patches/` has
the diffs from `main3` that `item2` (`item2.diff`), `stepA-nothp` (`stepA.diff`), `stepAB-nothp` (`stepAB.diff`) and
`final4` (`final4.diff`) were made with. `scripts/3-build.sh` built `main3`, `item2` and `final4` from a fresh fetch of
`abc6bf24`; the `-nothp` and `-pop` trees are copies of `main3` with their diffs and patches applied
(`scripts/3-diag3.sh`, `scripts/3-diag4.sh`), the `-sparse` trees copies of `item2-nothp` and `final4`
(`scripts/3-diag9.sh`), and `head` a fetch of main `9bb5060e` with the trial merge from a bundle (`scripts/4-head.sh`).
Each was built on the host by Buster's `./build.sh` with `BUSTER_DEBUG_INFO=0`, as the 9700X job builds it
(`logs/builds*.txt`); `binaries.sha256` has each tree's `build/compiler`, hashed after the runs. `main3`'s directory was
removed by mistake at 22:28 (`3-build.sh` given a wrong commit, whose fetch failed) and built again at 22:29 from
`abc6bf24`, with the same manifest; campaign A3 and the diagnostics before 22:28 ran the first build, A4 and later runs
the second.

`-every` after a tree's name is its binary with `--every-lane` (every lane the bodies can take), and `-warm` with
`--warm` (the state kept from one reading to the next, as a process's readings after its first); without `-warm`, every
deferred reading releases its state first, as a process's one reading does.

The inputs are record A2's 43 units (`inputs.sha256`, each file's SHA-256 the same as A2's `synthetic.sha256` and
`inputs.sha256` give it): four of c-testsuite's single-exec programs (`00182.c`, `00200.c`, `00204.c`, `00213.c`) at
commit `5c7275656d751de0e68b2d340a95b5681858ed07`, the frozen `sqlite3.c` and 38 synthetic units; and for the
c-testsuite sweep, the 220 programs of Buster's `tests/c-testsuite/subset.txt` at the same commit. Every file is read
with the frozen corpus's pinned predefines and headers (`scripts/3-runs.sh`'s options). `SOURCE_DATE_EPOCH=1792454400`;
`CPATH` and `C_INCLUDE_PATH` are unset. Host: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1; transparent huge
pages `always` (defrag `madvise`), the 2 MB size alone; CPU 2 has the performance governor and energy preference, CPUs
0, 1 and 3 to 7 powersave and `balance_performance` (record A2). The command is A2's:

```sh
./build/compiler benchmark-checker-deferred --passes 24 --lanes L --cpus 2,0,1,3,4,5,6,7 [--every-lane] [--warm] [the options] FILE
```

with `--passes 12` for `sqlite3.c`, each unit and lane count in a process of its own (`scripts/3-runs.sh`). Each pass
parses the unit and checks it by source order's `check_input` and by the deferred reader on one lane and on `L`, in the
six orders of the three readings in turn; a figure is the median of the passes, in nanoseconds per token. A unit's
change on `L` lanes is its reading on `L` against its reading on one lane in the same process.

## The runs

| Log | Scripts | Trees and runs | Units | Rounds | Lock holds |
| --- | --- | --- | --- | ---: | --- |
| `logs/A3.txt` | `3-master.sh`, `3-queue.sh`, `3-batch.sh`, `3-runs.sh`, `3-jobsA.txt` | `item2-every` on 2, 3, 4 and 8 lanes, `item2-every-warm` on 2 and 8, `main3-every` on 2 and 8 | 43 | 3 | 12 of up to 11 jobs |
| `logs/diag.txt` | `3-diag.sh` | `item2` and `main3` on 8 lanes with every lane under `perf stat`, twice; then `perf record` of their page faults and cycles (`reports/diag-*`) | `h16x19.c` | 1 | a run each |
| `logs/diag2.txt` | `3-diag2.sh` | the same with `/proc/vmstat`'s huge-page counters around each, and cycles with call chains (`reports/diag2-*`) | `h16x19.c` | 1 | a run each |
| `logs/diag3.txt` | `3-diag3.sh` (the builds), `3-diag3b.sh` | `item2`, `item2-nothp`, `main3` and `main3-nothp` on 8 lanes with every lane | `h16x19.c`, `l16x10f192.c`, `x16x19.c`, `h16x38.c`, `h16x10.c`, `sqlite3.c` | 2 | two a round |
| `logs/diag4.txt` | `3-diag4.sh` | `main3-nothp`, `stepA-nothp`, `stepAB-nothp`, `item2-nothp` and `item2-nothp-pop`, the same way | `h16x19.c`, `h16x38.c`, `x16x19.c`, `h16x10.c`, `l16x38f384.c`, `b16x77.c` | 2 | two a round |
| `logs/diag5.txt` | `3-diag5.sh`, `3-diag5b.sh` | `item2-nothp` and `main3-nothp` on 8 lanes with every lane, 6 passes, under `perf record` of their page faults with their addresses and of their cycles with call chains (`reports/diag5-*`) | `h16x19.c` | 1 | a record each, and one for the reports |
| `logs/diag6.txt` | `3-diag6.sh` | `main3-nothp`, `item2-nothp` and `item2-nothp-pop` on 8 lanes with every lane | `sqlite3.c`, `00213.c`, `00182.c`, `00204.c`, `00200.c`, `h2x40.c` | 3 | a round each |
| `logs/diag7.txt` | `3-diag7.sh` (with `final4`'s build) | `final4`, `item2-nothp-pop`, `item2-nothp` and `main3-nothp`, the same way | `sqlite3.c`, `00213.c`, `00204.c`, `00182.c`, `h2x40.c`, `h16x19.c`, `x16x19.c`, `b16x77.c` | 2 | a round each |
| `logs/diag8.txt` | `3-diag8.sh` | an attempt to list `item2-nothp`'s mappings of 8.26 MB while it runs; it asked for 400 passes, more than the benchmark takes (96), so it ran none | | | 1 |
| `logs/diag9.txt` | `3-diag9.sh` (with the trees' builds, `logs/builds-diag9.txt`) | `item2-nothp-sparse`, `final4-sparse`, `item2-nothp`, `final4` and `main3-nothp` on 8 lanes with every lane; then `final4` under `perf record` of its cycles with call chains (`reports/diag9-*`; and from diag5's profile, `reports/diag5-item2-nothp-lane-kernel-chains.txt`) | `h16x19.c`, `h16x38.c`, `x16x19.c`, `b16x77.c`, `l16x38f384.c`, `h16x10.c` | 2 | a round each, then the record and its reports one each |
| `logs/diag10.txt` | `3-diag10.sh` | `item2-nothp` and `final4` on 8 lanes with every lane, 24 passes between two copies of `/proc/vmstat` (`logs/vmstat/`), then 6 passes under `perf record` of every context switch with its call chain; and the whole kernel chains of the lanes' page clears in diag5's and diag9's profiles (`reports/diag10-*`, `scripts/chains.py`) | `h16x19.c` | 1 | one, and one for the reports |
| `logs/diag11.txt` | `3-diag11.sh`, `3-diag11b.sh` | the page clears in diag2's, diag5's and diag9's cycle profiles by thread, fault path and user frame (`scripts/clearpaths.py`; `3-diag11.sh` printed the same rows without the totals, and `3-diag11b.sh` again with them) | | | one each |
| `logs/diag12.txt` | `3-diag12.sh` | `item2-nothp` on 8 lanes with every lane, 6 and then 48 passes, each between two copies of `/proc/vmstat` | `h16x19.c` | 1 | one |
| `logs/thpcount.txt` | `thpcount.c` | the kernel's counters for 320 regions of 2 MB written, and read then written | | | one |
| `logs/tests-final4.txt` | `4-master.sh` (`3-tests.sh`) | `final4`'s tests; `4-master.sh` was stopped while they ran, its queue started apart (`4-queueA.sh`) to queue beside them | | | a test each |
| `logs/A4.txt` | `4-queueA.sh`, then `4-queueA2.sh` (`3-queue.sh`, `3-batch.sh`, `3-runs.sh`, `4-jobsA.txt`) | `final4-every` on 2, 3, 4 and 8 lanes, `final4-every-warm` on 2 and 8, `main3-every` and `main3-nothp-every` on 2 and 8 | 43 | 3 | one of 11 jobs (110 runs, 5.5 minutes, more than the lock asks), then 30 of up to 4 |
| `logs/S4.txt` | `4-S4.sh` (`3-runs.sh`) | `main3` and `final4` by their rules (8 lanes), 24 passes | `sqlite3.c` | 6 | a process each |
| `logs/B4.txt` | `4-chainB.sh` (`3-queue.sh`, `3-batch.sh`, `3-runs.sh`, `4-jobsB.txt`) | `main3` and `final4` by their rules on up to 8 lanes | 43 | 5 | 20 of up to 11 jobs |
| `logs/CT4.txt` | `4-chainB.sh`, `4-batchCT-final4.sh` (`3-batchCT.sh` with `final4` for `final3`) | `main3` and `final4` by their rules on up to 8 lanes | c-testsuite's 220 | 3 | 33 of 20 programs |
| `logs/CTwarm.txt` | `4-ctwarm.sh` (`3-runs.sh`) | `final4` and `main3` on 8 lanes by their rules, cold and `-warm` | six of c-testsuite's programs under 100 tokens | 2 | one |

The scripts are as they ran; the inner scripts some of them write (`3-diag3-half.sh`, `3-diag4-half.sh`,
`3-diag6-round.sh`, `3-diag7-round.sh`, `3-diag8-inner.sh`, `3-vmstat.sh`, `4-jobsB-final4.txt`, `4-batchCT-final4.sh`)
are in their text. `grid3.py` is record A2's `grid.py` reading only each reading's line (item 1 added a line of the
merge's parts); `rule3.py` is A2's `rule2.py` with the production rule's integer form; `diagsum.py` summarizes a
diagnostic's log by unit and tree; `faultmaps3.py` and `cyclemap.py` made `reports/diag5-*` (`faultmaps.py` and
`faultmaps2.py` misread `perf script`'s sample lines and gave nothing; `cyclemap2.py`'s output, the lanes' kernel call
chains, is `reports/diag5-item2-nothp-lane-kernel-chains.txt`). `difftable.py` made `tables/diag3.txt`, `diag4.txt`,
`diag6.txt` and `diag7.txt`, fuller tables of the same logs with the lanes' span (the tables below are `mdtable.py`'s,
as `tables/diag9.txt` is); `costs3.py` made `tables/copiesA4.txt`, `compare4.py` `tables/compareA4.txt`, `compareA2.py`
`tables/compareA2.txt`, `phases.py` `tables/S4.txt` and `ct4.py` `tables/CT4.txt`. The logs are as the runs wrote them:
each run's heading, its output and its exit status. `logs/queue.lock.txt` has a message for every lock acquisition that
had to wait.

## Campaign A3: item 2's first three commits

On A3, a lane's copy took less than half of what it took before: 33 µs on two lanes and 51 µs on eight (the median of
the 42 units but `sqlite3.c`; `sqlite3.c` 130 and 198 µs), against `main3`'s 77 and 127 µs (456 and 835) and A2's
`branch`'s 69 and 100 µs (401 and 663). The readings didn't follow. The median unit's change on eight lanes against one
was +3.6% (`main3`'s +3.2%), and both trees read most units on eight lanes worse than A2's `branch` had. The rule (1,024
tokens and a quarter of the top level's) read the worst unit 7.3% slower than one lane, put 18 of 43 within one point of
their best and forwent 119.8 points; the best of `rule3.py`'s grid, 4,096 tokens and a third of the top level's, still
forwent 84.7 (`tables/fitA3.txt`, from `tables/summaryA3*.tsv` by `grid3.py`).

## Where a first reading's time went

The diagnostics found two costs that the copy had hidden, and one that the lanes' timing decides. In each table, a
unit's reading on one lane and on eight with every lane is in nanoseconds per token, the lanes' walks on eight are
summed over the lanes, in nanoseconds per token of the unit, and a lane's copy on eight is in microseconds; each figure
is the median of the diagnostic's rounds (`scripts/mdtable.py`, from the logs).

**The deferred state's own arenas in huge pages.** The state's arena, the top level's table and its index were reserved
with `arena_reserve`, huge pages past their first 64 KB. The table has the caller's capacities, each column room for
every type the unit could make, and the arena has room for two linked updates a token, so a reading touched a little at
each column's start, and the kernel cleared a 2 MB page for each. In the cycle profiles of six passes of `h16x19.c` on
eight lanes with every lane, `main3`'s threads cleared huge pages in 414 of their 1,299 samples, 172 on the main thread
and 242 on the lanes, all of these where the lanes wrote over the huge zero page under `check_input_declaration`; with
these arenas in base pages, `main3-nothp`'s cleared them in 63 of 836, none on the lanes (`logs/diag11.txt`,
`scripts/clearpaths.py`, from diag2's and diag5's profiles). The huge pages a process maps (`/proc/vmstat`'s
`thp_fault_alloc`, which counts the one a fault maps) came to 307 in `main3`'s and `item2`'s processes of 12 passes
(`logs/diag2.txt`), and to 91 in 6 passes and 597 in 48 in `item2-nothp`'s (`logs/diag12.txt`): 12 a pass with these
arenas in base pages, 24 with them in huge pages. With these arenas in base pages (`-nothp`), on diag3's units (two
rounds; `tables/diag3.txt`):

| Unit | `main3`, one lane | eight lanes | `main3-nothp`, one lane | eight lanes | `item2`, one lane | eight lanes | `item2-nothp`, one lane | eight lanes |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `h16x19.c` | 62.80 | 72.28 | 45.59 | 41.41 | 62.08 | 70.56 | 46.45 | 48.30 |
| `l16x10f192.c` | 60.35 | 69.26 | 44.84 | 42.02 | 60.03 | 67.73 | 44.68 | 42.38 |
| `x16x19.c` | 69.61 | 72.47 | 52.09 | 53.67 | 71.21 | 77.32 | 53.62 | 57.78 |
| `h16x38.c` | 58.05 | 62.13 | 42.05 | 37.67 | 59.10 | 64.63 | 43.62 | 45.12 |
| `h16x10.c` | 54.62 | 54.20 | 49.15 | 47.90 | 53.70 | 51.29 | 48.50 | 46.50 |
| `sqlite3.c` | 86.00 | 70.10 | 83.05 | 66.50 | 87.31 | 70.25 | 84.61 | 67.09 |

In base pages, `main3` read four of the units in 25 to 28% less time on one lane and 26 to 43% less on eight, `h16x10.c`
in 10 and 12% less, and `sqlite3.c` in 3.4 and 5.1% less.

**The per-name columns' faults.** With the arenas in base pages, `item2-nothp` still read three of those units 8 to 20%
slower on eight lanes than `main3-nothp`. diag4 took item 2's commits one at a time, on the same arenas: the index's
slots (`stepA-nothp`), then the per-name columns (`stepAB-nothp`), then the proxies (`item2-nothp`), and `item2-nothp`
with each lane's whole names arena committed as it is laid out (`item2-nothp-pop`; two rounds, `tables/diag4.txt`):

| Unit | `main3-nothp`, eight lanes | walks | `stepA-nothp`, eight lanes | walks | `stepAB-nothp`, eight lanes | walks | `item2-nothp`, eight lanes | walks | `item2-nothp-pop`, eight lanes | walks |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `h16x19.c` | 42.33 | 15.36 | 41.16 | 16.34 | 48.61 | 56.22 | 47.56 | 56.40 | 41.05 | 16.54 |
| `h16x38.c` | 37.89 | 22.16 | 40.31 | 38.08 | 45.24 | 77.07 | 44.57 | 69.78 | 36.38 | 20.90 |
| `x16x19.c` | 53.02 | 10.74 | 54.97 | 13.01 | 58.88 | 63.14 | 57.40 | 62.50 | 52.84 | 17.14 |
| `h16x10.c` | 48.04 | 10.50 | 46.49 | 10.30 | 46.59 | 11.58 | 45.56 | 9.95 | 46.86 | 11.14 |
| `l16x38f384.c` | 43.51 | 25.82 | 40.64 | 21.24 | 42.99 | 54.05 | 44.47 | 49.65 | 40.51 | 21.99 |
| `b16x77.c` | 35.03 | 44.78 | 39.49 | 68.66 | 40.30 | 73.27 | 39.31 | 68.31 | 33.38 | 30.91 |

The per-name columns brought most of the walks' excess, two to six times `main3-nothp`'s walks on four of the units, and
the proxies kept it; the index's slots brought part of it on `h16x38.c` and `b16x77.c`. Committing the names arena took
all of it away. The whole arena was more than a reading needs: on `sqlite3.c` it cost each of eight lanes about 300 µs
more of copy than `item2-nothp`'s (489 µs against 193), and it made `00213.c`, five bodies, 5% slower on one lane and
21% slower on eight (diag6, three rounds; `tables/diag6.txt`). `final4` commits only the entries a reading's names take,
each column's prefix (diag7, two rounds; `tables/diag7.txt`):

| Unit | `main3-nothp`, one lane | eight lanes | copy | `item2-nothp`, one lane | eight lanes | copy | `item2-nothp-pop`, one lane | eight lanes | copy | `final4`, one lane | eight lanes | copy |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 83.09 | 66.69 | 767 | 84.86 | 67.62 | 192 | 84.12 | 66.66 | 526 | 84.05 | 66.79 | 450 |
| `00213.c` | 197.82 | 253.49 | 29 | 190.61 | 242.91 | 12 | 201.23 | 276.94 | 35 | 184.89 | 236.81 | 21 |
| `00204.c` | 67.97 | 65.83 | 73 | 66.34 | 63.28 | 25 | 67.19 | 63.53 | 51 | 66.24 | 61.92 | 45 |
| `00182.c` | 62.20 | 69.96 | 57 | 61.66 | 65.80 | 19 | 60.98 | 69.25 | 51 | 60.90 | 65.06 | 41 |
| `h2x40.c` | 52.05 | 56.83 | 85 | 51.52 | 52.08 | 27 | 50.90 | 54.43 | 67 | 50.21 | 53.03 | 55 |
| `h16x19.c` | 45.41 | 41.36 | 91 | 46.12 | 47.93 | 38 | 44.71 | 40.65 | 68 | 44.55 | 40.20 | 64 |
| `x16x19.c` | 51.95 | 53.38 | 195 | 53.52 | 58.02 | 56 | 51.04 | 51.30 | 120 | 50.70 | 51.76 | 121 |
| `b16x77.c` | 38.34 | 31.17 | 96 | 40.12 | 39.77 | 42 | 38.32 | 31.92 | 85 | 38.72 | 31.05 | 64 |

On eight lanes, `final4` read seven of the eight units 0.4 to 7.0% faster than `main3-nothp`, and `sqlite3.c` 0.1%
slower; on one lane, six 1.9 to 6.5% faster, and `sqlite3.c` and `b16x77.c` 1.2 and 1.0% slower. Against
`item2-nothp-pop` it read six faster on eight lanes, by 1.1 to 14.5%, and `sqlite3.c` and `x16x19.c` 0.2 and 0.9%
slower. Its walks on eight lanes took 9.1% less to 8.4% more than `main3-nothp`'s (`h16x19.c` 16.32 against 15.06, where
`item2-nothp`'s took 61.00). `final4`'s one-lane `sqlite3.c` is slower than `main3-nothp`'s in its walks (14.51 against
14.07 ns/token, the medians of the two rounds) and in its positions' checks (4.16 against 3.94), which item 2 makes set
a lane's own columns and the proxies for the names each body spells (`logs/diag7.txt`).

**The checker's rare columns.** `check_input_run` reserves an arena of its own at each reading for the columns few
tokens have an entry in, with the binding table (#572): base pages for its scope stacks, huge pages past them, since its
walk reads most of the columns at every token. The top level's walk skips the bodies, and the lanes' walks write their
bodies' entries into the same 2 MB regions. A region nothing has written yet has no page, or the huge zero page where
the top level's walk read it, and a write there allocates and clears a huge page before the fault takes the region's
lock (Linux 6.18's `do_huge_pmd_anonymous_page` and `do_huge_zero_wp_pmd`); a lane that then finds another lane's page
mapped there frees its own. In the profiles of six passes of `h16x19.c`, the lanes cleared huge pages under
`check_input_declaration` in 49 of `item2-nothp`'s 308 samples and in 40 of `final4`'s 294, by both paths, and in none
of `main3-nothp`'s 260 (`logs/diag11.txt`; the whole kernel chains in `reports/diag10-diag*-clears.txt`). diag5's map of
`item2-nothp`'s lanes' page faults has those under that function in a mapping of 8.26 MB, none of the lanes' or the
state's (`reports/diag5-item2-nothp-faultmap.txt`, whose `base` column says nothing: `perf`'s page-fault event is taken
as a fault starts, before the kernel picks the page's size, so every fault reads `base`). diag10's processes of 24
passes mapped 307 huge pages each, and `item2-nothp`'s allocated 264,077 pages to `final4`'s 204,283 (`logs/diag10.txt`,
`logs/vmstat/`): 59,794 more, as many as 117 huge pages. diag9 put that arena in base pages throughout
(`scripts/patch_sparse.py`: `item2-nothp-sparse` and `final4-sparse`), on eight lanes with every lane, two rounds
(`tables/diag9.txt`):

| Unit | `main3-nothp`, one lane | eight lanes | walks | `item2-nothp`, one lane | eight lanes | walks | `item2-nothp-sparse`, one lane | eight lanes | walks | `final4`, one lane | eight lanes | walks | `final4-sparse`, one lane | eight lanes | walks |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `h16x19.c` | 45.33 | 41.50 | 15.23 | 45.50 | 47.84 | 48.19 | 47.48 | 42.36 | 22.72 | 44.69 | 41.11 | 17.70 | 47.02 | 42.85 | 23.56 |
| `h16x38.c` | 41.67 | 36.97 | 19.32 | 43.08 | 44.82 | 69.06 | 42.58 | 35.44 | 27.02 | 41.98 | 35.86 | 19.60 | 42.62 | 35.56 | 25.79 |
| `x16x19.c` | 51.92 | 53.41 | 9.27 | 53.37 | 57.36 | 58.42 | 51.61 | 48.88 | 12.41 | 50.98 | 51.86 | 11.72 | 51.69 | 49.89 | 13.44 |
| `b16x77.c` | 38.39 | 34.31 | 39.66 | 39.44 | 38.62 | 70.91 | 36.30 | 26.91 | 33.53 | 39.36 | 37.44 | 67.34 | 36.49 | 26.72 | 33.73 |
| `l16x38f384.c` | 44.66 | 41.25 | 21.31 | 45.35 | 45.25 | 62.70 | 41.30 | 35.46 | 25.71 | 44.11 | 40.20 | 21.02 | 41.34 | 35.36 | 25.37 |
| `h16x10.c` | 49.09 | 47.58 | 11.11 | 48.14 | 46.11 | 12.00 | 51.02 | 48.10 | 16.63 | 47.61 | 45.70 | 10.97 | 50.61 | 47.63 | 15.87 |

In base pages, `item2-nothp`'s walks on eight lanes took 0.85 to 1.5 times `main3-nothp`'s, where in huge pages they
took 1.1 to 6.3 times; in base pages a lane faults in the pages it writes, a few at each body. `final4`'s walks were
`main3-nothp`'s on five of the units (0.99 to 1.27 times), but `b16x77.c`'s took 65 and 70 ns/token in its two rounds,
where diag7's took 24, and `main3-nothp`'s took 53 in one round and 26 in the other (`logs/diag9.txt`): the race depends
on the lanes' timing, and main's reader runs into it too. Committing the names arena delays each woken lane's first
walk, which may be why `final4` and `item2-nothp-pop` run into it less often than `item2-nothp`. What it costs
`item2-nothp`'s walks is more than the clears: under `perf`, its lanes' clears took 49 samples to `final4`'s 40, where
its walks took five times as long (90.6 against 18.5 ns/token in those runs), and its lanes didn't sleep in a fault: on
eight lanes, both trees' lanes switched out only to wait at the lanes' syncs (`futex`), to move to their CPUs
(`sched_setaffinity`) and, two or three times, for a file's page (`reports/diag10-*-switches.txt`). Where the rest of
that time goes is still to be found. The base pages cost source order's reader, whose arena it is too: against `final4`,
`final4-sparse`'s source order read `h16x19.c`, `h16x38.c`, `x16x19.c` and `h16x10.c` 6.6, 3.7, 1.0 and 6.5% slower, and
`b16x77.c` and `l16x38f384.c` 4.2 and 2.9% faster; its one lane 1.4 to 6.3% slower on the first four and 7.3 and 6.3%
faster on the last two, and its eight lanes 4.2% slower on `h16x19.c` and `h16x10.c` and 0.9 to 28.6% faster on the
others. The PR leaves the arena as it is.

## Campaign A4: item 2, and the rule fitted again

A2's grid on `final4`, with every lane on 2, 3, 4 and 8 lanes and warm on 2 and 8, beside `main3` and `main3-nothp` on 2
and 8, on A2's 43 units, three rounds (`logs/A4.txt`; `tables/summaryA4*.tsv` by `grid3.py`, and
`tables/summaryA2-full.tsv`, `grid3.py --full-precision` of record A2's `logs/A2.txt`, which it reproduces exactly).

**A lane's copy** (`tables/copiesA4.txt`; the median of the 42 units but `sqlite3.c`, then `sqlite3.c`'s) takes 41 µs on
two lanes and 71 µs on eight (245 and 467 µs), against `main3`'s 72 and 125 µs (450 and 787), `main3-nothp`'s 65 and 102
(448 and 808) and A2's `branch`'s 69 and 100 (401 and 663). It includes the commit of the lane's per-name entries, 257
µs of `sqlite3.c`'s on eight lanes (diag7). A later reading's (`final4-every-warm`) takes 3 and 4 µs (48 and 86),
against A2's `branch`'s 6 and 9 (140 and 457).

**The readings.** Against `main3`, `final4` read the 43 units 26.3% faster on eight lanes (the median; 5.2 to 42.9%) and
23.6% faster on one (2.6 to 34.3%); against `main3-nothp`, 1.9% faster on eight (8.4% faster to 10.7% slower) and 1.3%
faster on one (5.8% faster to 3.8% slower). `sqlite3.c` read 5.2 and 2.6% faster than `main3`, and 0.2 and 1.2% slower
than `main3-nothp` (`tables/compareA4.txt`). Each unit's change against one lane in the same process, on two and on
eight lanes with every lane, has its median at −5.1% and −2.3% on `final4`, with 34 and 26 of the 43 units faster than
on one lane, against `main3`'s −3.0% and +4.5% (35 and 13) and A2's `branch`'s −2.9% and −1.9% (32 and 24)
(`tables/compareA2.txt`).

**The rule.** On `final4`'s grid (`scripts/rule3.py`, `tables/fitA4.txt`), the rule, one lane more per 1,024 tokens and
a quarter of the top level's beyond the critical path, forgoes 48.5 points, the least of the grid, and puts 26 of the 43
units within one point of their best; its worst unit, `x16x19.c`, reads 1.7% slower on its two lanes than on one, where
four lanes read it 0.4% faster (`tables/fitA4-rule.txt`). 768 tokens and a quarter forgo 50.5 points, 1,536 tokens and a
sixth 51.2 with their worst unit at +0.7%, and A3's best, 4,096 tokens and a third, 79.9 at +0.0%. The rule keeps its
constants. Most of what it forgoes is on units whose eight lanes read worse than four, where `final4`'s walks ran into
the rare columns' race in some rounds: `l16x77f384.c` read 12.1% faster on four lanes and 6.8% on eight, its walks on
eight 57, 66 and 36 ns/token in the three rounds against `main3-nothp`'s 28, 23 and 25; `h16x77.c` 11.6% faster on three
and 7.9% on eight, its walks 64, 39 and 40 against 34, 24 and 24. A fix of the race would call for the rule to be fitted
again.

**The warm grid** runs into the race more. With copies of 3 and 4 µs a woken lane reaches its first walk at once: eight
lanes read `h16x38.c` 3.0% slower than one lane warm, and 9.2% faster cold, its walks 61 to 64 ns/token warm and 20 and
21 cold. No rule for later readings fits that grid (`tables/fitA4-warm.txt`: every one forgoes 150 points or more), and
no caller reads several units with one state yet (#697's item 3).

## Campaign B4: the rule on main and with item 2

Each tree by its rule, on up to eight lanes against one lane in the same process, five rounds, 11 units a lock hold
(`logs/B4.txt`; `tables/summaryB4*.tsv`, `tables/B4.txt`). The rule's constants are the same in both trees, so it gives
every unit the same lanes in both: the medians of the five rounds (their lowest and highest in parentheses), and the
readings on the rule's lanes in nanoseconds per token:

| Unit | The rule's lanes | Main, the rule's lanes against 1 | Item 2, the same | Main on them | Item 2 on them | Item 2 against main |
| --- | ---: | --- | --- | ---: | ---: | ---: |
| `00200.c` (2: 20,420 tokens and 30) | 1 | +0.4% (-0.2 to +1.9) | +0.2% (-0.2 to +0.8) | 46.65 | 39.79 | -14.7% |
| `00204.c` (108) | 2 | -5.3% (-5.9 to -2.1) | -6.1% (-6.5 to -5.7) | 66.20 | 61.03 | -7.8% |
| `00182.c` (11) | 1 | -0.4% (-0.7 to +0.0) | -0.1% (-0.3 to +0.4) | 64.08 | 58.87 | -8.1% |
| `sqlite3.c` (2,608) | 8 | -18.7% (-19.4 to -18.2) | -20.6% (-20.6 to -20.5) | 70.40 | 66.53 | -5.5% |
| `l16x19f192.c` | 5 | -2.3% (-6.0 to -0.6) | -11.8% (-12.5 to -9.4) | 54.81 | 36.53 | -33.4% |
| `l16x38f192.c` | 8 | +0.8% (-5.6 to +3.8) | -10.4% (-13.0 to -8.5) | 61.26 | 38.11 | -37.8% |
| `l16x38f384.c` | 8 | +3.8% (+2.8 to +4.9) | -7.9% (-9.6 to -6.9) | 68.59 | 41.38 | -39.7% |
| `l16x77f384.c` | 8 | -6.9% (-9.0 to -5.5) | -3.6% (-6.0 to -2.8) | 55.87 | 44.89 | -19.7% |
| `l16x5f384.c` | 2 | -1.3% (-2.0 to -0.3) | -3.4% (-4.3 to -2.7) | 54.59 | 39.91 | -26.9% |
| `l16x10f384.c` | 3 | -2.1% (-4.9 to -0.5) | -5.6% (-6.4 to -4.7) | 55.90 | 39.50 | -29.3% |
| `l16x19f384.c` | 5 | -1.6% (-2.6 to -0.7) | -7.4% (-8.5 to -6.3) | 57.81 | 38.41 | -33.6% |
| `l16x10f192.c` | 3 | -4.9% (-5.3 to -3.4) | -7.6% (-7.8 to -7.3) | 51.51 | 39.80 | -22.7% |
| `l8x38f384.c` | 5 | -0.7% (-2.8 to +0.7) | -5.1% (-8.3 to -4.4) | 58.11 | 38.82 | -33.2% |
| `l4x38f384.c` | 2 | -2.6% (-3.4 to -0.9) | -5.2% (-6.8 to -4.7) | 55.32 | 39.45 | -28.7% |
| `d2x1f384s288.c` | 2 | -1.4% (-3.0 to -0.7) | -0.3% (-0.8 to +0.2) | 56.25 | 39.75 | -29.3% |
| `d2x1f480s240.c` | 4 | -1.4% (-2.1 to -0.9) | -2.3% (-3.1 to -0.8) | 55.76 | 39.79 | -28.6% |
| `d16x19f384s288.c` | 6 | +2.1% (+1.4 to +3.9) | -5.7% (-7.6 to -4.5) | 64.70 | 41.95 | -35.2% |
| `d16x19f384s192.c` | 8 | +7.1% (+6.1 to +8.6) | -6.4% (-7.0 to -4.8) | 70.24 | 40.65 | -42.1% |
| `00213.c` (5 bodies) | 1 | +1.1% (-3.1 to +4.7) | +0.5% (-2.9 to +3.3) | 249.51 | 184.43 | -26.1% |
| `h16x1.c` | 1 | -0.4% (-0.6 to +0.3) | +0.0% (-0.4 to +0.8) | 58.08 | 53.43 | -8.0% |
| `h16x2.c` | 1 | -0.1% (-0.3 to +0.3) | -0.2% (-1.0 to +0.1) | 56.32 | 51.60 | -8.4% |
| `h16x5.c` | 2 | -1.5% (-2.0 to -0.9) | -1.9% (-2.5 to -1.6) | 52.68 | 48.87 | -7.2% |
| `h16x10.c` | 3 | -4.4% (-5.0 to -3.7) | -5.0% (-7.2 to -4.0) | 51.32 | 45.00 | -12.3% |
| `h16x19.c` | 5 | +0.4% (-3.7 to +2.2) | -8.1% (-9.0 to -6.6) | 55.91 | 40.56 | -27.5% |
| `h16x38.c` | 8 | -1.5% (-2.3 to +9.9) | -10.9% (-13.3 to -9.3) | 58.67 | 36.77 | -37.3% |
| `h16x77.c` | 8 | -1.1% (-4.1 to -0.8) | -5.0% (-10.2 to +1.6) | 59.93 | 43.06 | -28.1% |
| `h16x154.c` | 8 | -9.4% (-9.5 to -7.1) | -7.4% (-7.8 to -7.2) | 54.87 | 45.04 | -17.9% |
| `h2x40.c` | 1 | +0.0% (-0.2 to +0.3) | +0.3% (-0.3 to +0.6) | 52.86 | 48.83 | -7.6% |
| `h2x80.c` | 1 | +0.9% (+0.2 to +2.2) | +0.0% (-0.1 to +0.1) | 52.85 | 46.32 | -12.4% |
| `h2x160.c` | 1 | +1.3% (-0.2 to +2.0) | +0.2% (-0.0 to +0.8) | 54.06 | 43.01 | -20.4% |
| `h2x240.c` | 1 | +0.6% (-0.3 to +1.1) | +0.4% (-0.1 to +0.6) | 54.90 | 40.17 | -26.8% |
| `h2x320.c` | 1 | -0.4% (-1.3 to +0.7) | -0.2% (-0.4 to +1.4) | 56.04 | 41.33 | -26.2% |
| `h2x480.c` | 1 | +0.5% (-0.6 to +1.4) | +0.8% (+0.2 to +1.7) | 62.01 | 43.20 | -30.3% |
| `h64x1.c` | 2 | -1.4% (-1.7 to -0.6) | -1.0% (-1.3 to -0.8) | 53.45 | 50.24 | -6.0% |
| `h64x3.c` | 3 | -5.1% (-6.4 to -3.5) | -5.6% (-5.9 to -5.1) | 49.33 | 44.03 | -10.7% |
| `h64x10.c` | 8 | +4.5% (-2.3 to +6.6) | -12.9% (-13.4 to -8.9) | 64.46 | 36.69 | -43.1% |
| `b16x5.c` | 4 | -11.0% (-11.5 to -10.0) | -10.4% (-11.6 to -10.0) | 49.71 | 43.06 | -13.4% |
| `b16x19.c` | 8 | -20.2% (-20.7 to -19.4) | -23.3% (-23.5 to -20.2) | 33.11 | 28.57 | -13.7% |
| `b16x77.c` | 8 | -1.4% (-2.7 to -1.1) | -16.0% (-19.3 to -8.2) | 56.35 | 32.84 | -41.7% |
| `x16x10.c` | 1 | +0.5% (+0.1 to +2.1) | -0.0% (-0.4 to +0.6) | 67.09 | 52.13 | -22.3% |
| `x16x19.c` | 2 | +0.6% (+0.1 to +0.7) | +0.2% (-1.0 to +0.6) | 68.02 | 50.10 | -26.3% |
| `x16x38.c` | 4 | -4.1% (-4.4 to -3.7) | -4.9% (-6.6 to -3.4) | 65.22 | 48.12 | -26.2% |
| `x16x77.c` | 7 | -7.0% (-7.9 to -6.4) | -9.8% (-9.9 to -7.5) | 58.73 | 45.61 | -22.3% |

With item 2, the rule's lanes read the 31 units it gives more than one lane 23.3% faster to 0.2% slower than one lane
(the median −6.1%), where main's read them 20.2% faster to 7.1% slower (−1.5%); `l16x77f384.c`, `h16x154.c`,
`d2x1f384s288.c` and `b16x5.c` gain 0.6 to 3.3 points less against one lane than with main. The 12 units it reads on one
lane, whose two readings are the same work, came within −0.2 to +0.8% of each other (the medians; −2.9 to +3.3% in a
round). Item 2 reads every unit faster than main on the rule's lanes, by 5.5% (`sqlite3.c`) to 43.1% (`h64x10.c`), the
median 26.2%, and on one lane by 3.1 to 34.3% (the median 25.2%).

## Campaign CT4: c-testsuite by the rule

c-testsuite's 220 programs by each tree's rule, three rounds, each program's two runs a process each, their order
alternating by program and by round, 20 programs a lock hold (`logs/CT4.txt`; `tables/summaryCT4*.tsv` by `grid3.py`,
`tables/CT4.txt` by `scripts/ct4.py`). Both rules read every program on one lane but `00204.c`, on two, which item 2's
two lanes read 5.9% faster than one lane (−6.0 to −5.3% in the three rounds) and main's 4.7% (−4.8 to −3.2). Item 2
reads the programs 30.5% faster than main by the rule (the median; 8.6 to 44.5%), and the 220 in 20.0% less time (20.80
against 26.00 ms). By main's reading on one lane, it reads those under 50 µs 31.7% faster (the median), those of 50 to
200 µs 30.8%, those of 200 µs to 1 ms 14.6% and `00200.c`, of 1.1 ms, 14.9%. On A4's units, item 2 read only 1.3% faster
on one lane than main with the state's arenas in base pages (the median).

The programs read on one lane, whose two readings are the same work, came within:

| Programs | `main3` | `final4` |
| --- | --- | --- |
| 61 of 1,000 tokens or more | −1.2 to +0.9% (a standard deviation of 0.35%) | −0.6 to +0.9% (0.35%) |
| 27 of 100 to 999 | −1.4 to +1.1% (0.58%) | −4.1 to +4.4% (1.83%) |
| 131 under 100 | −1.5 to +2.2% (0.80%) | −7.6 to +6.4% (3.41%) |

Item 2 reads the programs under 100 tokens in 29 to 43 µs on one lane, main in 44 to 73. On 26 of them its two readings
differed by more than 1% the same way in all three rounds, against main's 2, and the difference is in what follows the
merge (the benchmark's `rest`). But it isn't the program's: six of them run again in one lock hold, two rounds, cold and
warm (`scripts/4-ctwarm.sh`, `logs/CTwarm.txt`), and `00012.c`, +5.3, +5.4 and +5.9% in CT4, read −5.2 and −4.4% cold
and −1.1 and +1.7% warm. The six programs' cold readings came within −7.2 to +6.3% by item 2 and −0.2 to +2.9% by main,
and warm within −3.5 to +3.3% and −5.2 to +4.4%. It doesn't bear on the rule, which reads these programs on one lane in
both trees.

## Campaign S4: item 1's phases on `sqlite3.c` after items 2 and 4

The frozen `sqlite3.c` by each tree's rule on eight lanes (both take eight), six processes of 24 passes each, their
order alternating by round (`logs/S4.txt`; `tables/S4.txt` by `scripts/phases.py`). The medians of the processes, and
their lowest and highest, in nanoseconds per token:

| | `main3` (items 1 and 4) | `final4` (items 1, 2 and 4) |
| --- | ---: | ---: |
| source order's reader | 71.13 (70.78 to 72.64) | 70.39 (69.78 to 70.88) |
| the deferred reader, one lane | 86.52 (86.22 to 87.35) | 83.82 (83.34 to 84.02) |
| its merge | 5.02 | 4.97 |
| the deferred reader, eight lanes | 70.49 (70.26 to 71.03) | 66.42 (66.27 to 66.68) |
| its top level | 23.34 | 22.67 |
| the history's index | 0.24 | 0.17 |
| the lanes' span | 5.50 | 5.24 |
| the bodies' walks, summed over the lanes | 27.09 | 27.21 |
| their position checks, summed | 5.39 | 6.51 |
| the merge | 2.61 | 2.44 |
| its pass over the tokens, on the lanes | 1.66 | 1.55 |
| `check_input_run`'s phases after the merge | 38.85 | 35.87 |
| eight lanes against source order, each process's | −1.1% (−2.2 to −0.3) | −5.6% (−5.9 to −5.0) |

On eight lanes, `final4`'s serial part, the top level, the history's index, the merge but its pass and the phases after
it, takes 59.6 of the reading's 66.4 ns/token; the lanes take 6.8, their span and the merge's pass. Against `main3`,
item 2 takes 3.0 ns/token off the phases after the merge and 0.7 off the top level, with the state's own arenas in base
pages, and adds 1.1 to the position checks, summed over the lanes.

## Tests

`final4`'s tests on the 9700X (`logs/tests-final4.txt`, `scripts/3-tests.sh`), each command a lock hold of its own:

- `test-checker-deferred`: 111 fixtures, 2,220 checks, 1,080 merged, 30,120 bodies read apart, 0 failures;
- `test-types`, every section with 0 failures; `test-call-graph`, 37 cases, 0 failed; `./build.sh check-call-graph`: 41
  translation units, 25,818 functions, 0 cycles (3 allowed), 0 split variables;
- `test-checker --seed 133` with clang 23.1.4, the CI's toolchain: 500,417 checks, 0 failures;
- `test-checker-corpus --clang /usr/bin/clang --deferred 8`, with no differences from source order: c-testsuite's 220
  programs, all merged, 449 bodies read apart; the frozen `sqlite3.c` with `--symbols`, merged, 2,608 bodies, its
  symbols compared with one documented difference (an inlined function) and none unexplained; and the frozen musl's
  `src`, 1,524 files, 1,486 merged and 38 left to source order (37 with a body that reports an error, one that doesn't
  parse), 21,918 bodies read apart. These are item 1's counts (record `deferred-merge-697-2026-10-28`).

The same commands passed on `item2`, before the last two commits, with the same counts but for the call graph's 25,812
functions (`logs/tests-item2.txt`).

The PR's code with main `9bb5060e` merged in (`head`, `logs/tests-head.txt`, `scripts/4-head.sh`), each command a lock
hold: `test-checker-deferred`, 111 fixtures, 2,553 checks (333 of them with the identifiers' ids in another order,
main's #153), 1,080 merged, 30,120 bodies read apart, 0 failures; and `test-checker-corpus --deferred 8` on the same
three corpora with the same counts and no differences. The 9700X job's CI runs the rest on the PR's head.

## Limitations

One host, whose CPUs other than 2 run the powersave governor (record A2): a woken lane's speed is that host's. The
synthetic units are A2's, of one statement shape; the rule's refit holds for them, for c-testsuite's programs and for
`sqlite3.c`. The reader alone is timed (`check_input`'s work), not the checked graph after it. Readings compared across
two builds also carry their code's placement, which moves a build by about 2% on this host (Buster's
`docs/profiling.md`, "Comparing two versions"); the rule's fit reads each unit's lanes against one lane in the same
process. Programs of a few dozen tokens take 30 to 45 µs to read, and their two readings of the same work differ by
several percent (CT4). Cold readings recreate the deferred state's mappings and fault their pages in, and each process
preprocesses its input once and reads it repeatedly: they are not full-process or full-compile measurements, and this
record has no RSS series. The diagnostics ran on one to eight units, and their `perf` runs add their own overhead; they
explain the rare columns' race only in part, since where most of its cost goes isn't found. `main3`'s first build ran A3
and the diagnostics before 22:28, its second the later runs, from the same commit and manifest. The timing claims are
this record's, on these frozen trees: `head`, main merged in, was tested, not timed.
