# The graph's leaves as records plus payload rows (buster#628, buster#1562), 2026-11-06

This record holds the measurements behind [buster#1562](https://github.com/buster14a/buster/pull/1562), which stores each
of the expression graph's `VALUE` leaves as a 32-byte `CheckGraphLeaf` record, plus a whole `CheckValue` payload row only
for a value with more than a record holds, where each leaf was a 96-byte `CheckValue`. It has the 9700X's A/B, the
cloud VM's runs, and the peak map that chose the change.

## Sources

| tree | Buster commit | what |
| --- | --- | --- |
| `main` | [`ec5f0f6be04660d5b36ec688ba3d8ed3511ee85b`](https://github.com/buster14a/buster/tree/ec5f0f6be04660d5b36ec688ba3d8ed3511ee85b) | main when the change was made |
| `branch` | [`9cfc0f50296d0b6ffa498bdf494fcb1bf41c60aa`](https://github.com/buster14a/buster/tree/9cfc0f50296d0b6ffa498bdf494fcb1bf41c60aa) | the change on `ec5f0f6b` |

The PR then merged main `f4272a46` and added validation of the records' rows (`e291e7a5`, `ea62b513`, `54871dd7`),
which touches only the graph validators and their tests. This record doesn't measure those commits.

`receipts.txt` has the 9700X's host, kernel, CPU 2's governor and EPP, the transparent huge pages' setting, clang's and
perf's versions, both executables' SHA-256 and the input's. The input is the frozen corpus's `sqlite3.c` (SQLite 3.53.2),
SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`, with the `compile_time` step's options:

```sh
-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c
```

## Method

The 9700X (`round1/`), CPU 2, through `~/buster-fast-bench/exclusive.sh`. The scripts are in `scripts/`:
- `setup.sh` cloned both trees.
- `build.sh` built each with `BUSTER_HOST_ARCH=znver5`, one hold of the lock per build.
- `ab.sh` ran `ab-inner.sh` under one hold: a reference object, then 8 rounds, the order alternating, each a warm-up
  and `perf stat -r 3` of each tree, every object compared with `cmp`; then `measure-compile --runs 11` by each tree
  with the other as its reference. The hold lasted from 19:49:52 to 19:50:12 UTC (`round1/ab1/` files' times).
- `objects.sh`, under another hold, compiled with each tree by default (with `--time-stages`), with `--scalar`, with
  `--lanes 8` and with `-g`, and compared the objects.
- `start.sh`, under a third hold, compiled an empty file three times with each tree with `--time-stages`, for the
  processes' starting resident sets.

**Limitation.** Each script's compiles share one hold of the host's lock. AGENTS.md and the host's README say to hold
the lock "per run, never around a series of runs". Reviewers of buster#1562 read the A/B's 8 rounds and two 11-run
series as a series, and consider these numbers not qualifying under that rule. The CI job's own `compile_time` step
takes one hold for its series too. The rule's reading is the owner's decision. Until it's settled, read these
numbers as measured by the method above.

The cloud VM (`vm/`): a 4-CPU Xeon with AVX-512, so the vector path runs. Three interleaved `--time-stages` runs of
`-c` by each tree, pinned to CPU 2, with huge pages as the 9700X has them (`BUSTER_HUGE_PAGES=1`, `*-1-*.txt`) and with
the VM's default of base pages (`*-default-*.txt`).

The peak map (`peak-map/`): main `ec5f0f6b` on the VM with huge pages, built with the attributes column's record's
`peak-map.patch`
([`attributes-column-1167-2026-11-03/scripts/peak-map.patch`](../attributes-column-1167-2026-11-03/scripts/peak-map.patch)),
plus a log of every arena push of 32 KB or more (`BUSTER_PEAK_ALL`), and a count of the leaves' fields.
- `reader-end-sites.txt` and `stage7-sites.txt` rank the pushes by their resident pages at the reader's end and at
  `check-declarations`' end, with `-w`.
- `scratch-highwater.txt` lists the checker's scratch's pushes in order, marking those that raise its high-water
  (`scripts/highwater.py`).
- `nw.shapes` and `w.shapes` count the mappings by size and resident pages in the backend (`lower`'s end), without
  `-w` and with it. The difference is the deferred history's replay, which `sqlite3.c`'s one warning makes the
  preprocessor run.

## Results

**The 9700X**, main (A) against the change (B):

| measure | main | records |
| --- | ---: | ---: |
| task clock (`perf stat`, median of 8 rounds) | 138.86 ms | 138.28 ms |
| user cycles | 676.1 M | 674.1 M |
| user instructions | 1,636.3 M | 1,637.8 M |
| kernel cycles | 94.7 M | 93.0 M |
| peak RSS (`wait4`, `measure-compile`) | 293,592 KiB | 289,976 KiB |
| peak RSS (`--time-stages`, `objects1/`) | 293,660 KiB | 289,888 KiB |
| its growth past the process's start | 291,792 KiB | 284,176 KiB |
| `check-input`'s peak added | 149,916 KiB | 143,840 KiB |
| `check-input` (`measure-compile`) | 59.71 ms | 59.22 ms |

- **Time.** Every round of the 8 has B 0.3 to 1.0 ms faster.
- **Objects.** Every object is the same bytes: by default, `--scalar`, `--lanes 8` and `-g`.
- **Memory.** `check-input` adds 6.1 MB less, as on the VM, and the process grows 7.6 MB less past its start. But on
  `sqlite3.c` B's process starts 3.8 MB larger at its first mark (5,712 against 1,868 KiB). An empty file's doesn't
  (2,016 against 1,868 KiB, `round1/start.log`), nor the VM's (5,556 against 5,588 KiB), and nothing the change writes
  runs by then. This record doesn't attribute the gap. The whole peak is 3.8 MB lower.

**The VM** (`vm/`), three runs each, which agree within 8 KiB:

| pages | measure | main | records |
| --- | --- | ---: | ---: |
| huge (`BUSTER_HUGE_PAGES=1`) | peak RSS | 297,024 KiB | 290,836 KiB |
| | `check-input`'s peak added | 145,328 KiB | 139,188 KiB |
| base (the VM's default) | peak RSS | 227,988 KiB | 218,908 KiB |
| | minor faults | 72,411 | 70,154 |

**The peak map.** On main, `-c sqlite3.c` has three peaks almost alike: the reader's end (283.5 MB, with its 31 MB arena
of rare columns), `check-declarations`' end (286.1 MB) and the backend (278.8 MB with `-w`; 297.0 MB without, which is
the compile's peak). All three hold the parser's columns (16 MB), the graph's leaves (14.3 MB), the preprocessor's
output tokens (12.5 MB) and its file's windows (11.5 MB). The leaf count found 144,720 leaves, of which 24,071 have
more than the stream's columns hold, 23,991 of those only an integer, and 80 more than a 64-bit integer.
