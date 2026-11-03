# The preprocessor's tables in one reservation (#652)

Evidence for [buster14a/buster#1237](https://github.com/buster14a/buster/pull/1237), part of
[#652](https://github.com/buster14a/buster/issues/652): a small unit's fixed setup cost, here the number of its arenas.

## Sources

| tree | source | what |
| --- | --- | --- |
| `base` | `730eea0a7b3f5c6a95be4f13653bd86759b39a2d`'s `git archive` | main when measured |
| `head` | `1bfef0cf9f23d1b7452222e765dabf4b050d917f`'s `git archive` | the PR's first commit: the tables in one reservation |

The PR's second commit (`26dd19db6d8b2871ca03c5797c54bf56db38e5d7`: a refused tables reservation switches the thread to compact reservations, and its
resources check) changes only that failure path and was not timed. Both trees were built on the 9700X with
`BUSTER_HOST_ARCH=znver5 ./build.sh`, each build under the machine's lock; `raw/ab.log` begins with the executables' and
inputs' SHA-256.

## Host

AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, transparent huge pages `always`, defrag `madvise`. Timed processes
pinned to CPU 2. Every build and every measurement batch ran under the shared 9700X lock, taken per batch. The
inventories (`raw/inventory-*.txt`, `raw/footprints-main-nothp.txt`) were taken on a Ryzen 9 7940HS (Linux 7.3.1, THP
`always`) with that machine's native build.

## Runs

- `scripts/rb2.sh` (output `raw/reserve-layouts-9700x.log`): two rounds of `scripts/reserve_bench2.c`, #1168's
  reservation microbenchmark with three more layouts: 90 arenas, each committing its first 64 KB and touching a page, in
  a forked child, medians of 401, by layout: 64 GB each (`lazy`, main's), 1 GB, 128 MB and 2 MB each (`cap=`), ranges of
  one mapping each made writable on its own (`dense`), and one writable mapping with a page touched every 64 KB (`flat`,
  the faults alone); none (`lazy` 0) for the floor.
- `scripts/mmaps.py` (a gdb script) logs each `mmap`'s length, protection, call stack and result, and the process's
  `/proc/PID/smaps` and page-table size at `_exit`; `scripts/inventory.py` attributes the resident kilobytes in each
  mapping to its call site (`raw/inventory-{main,head}-{empty-fsyntax-only,tiny-c}.txt`), and `scripts/compare.py` lines
  up each reservation's resident kilobytes across runs (`raw/footprints-main-nothp.txt`: main's executable, an empty
  file, `sqlite3.c` and this compiler's `main.c`, each `-fsyntax-only` with transparent huge pages disabled for the
  process, `prctl(PR_SET_THP_DISABLE)`, so that each counts the base pages it touches).
- `scripts/fewer-ab.sh` (log `raw/ab.log`): three rounds of `perf stat -x, -r 51 -e
  task-clock,page-faults,instructions:u,instructions:k` of an empty file's `-fsyntax-only` and a one-line function's
  `-c` on each tree; `strace -f -c` of each tree's empty `-fsyntax-only` (`raw/strace-*.txt`); then `ab --rounds 3 --cpu
  2` of `time-runs --copies 3` with `base`, `head` and `base-again` (the same executable as `base`, the floor), one input
  per `time-runs` process: empty `-fsyntax-only`, empty `-E -P` and tiny `-c` (31 runs each), `sqlite3.c` `-E -P` (11),
  `-fsyntax-only` and `-c` (7).
- `scripts/refuse.c` runs a command with inaccessible reservations of 8 to 64 GiB refused with `EINVAL`, the filter the
  PR's resources check adds.

The logs keep only the lines these scripts and the compiler's `ab`/`time-runs` print; the lock's waiting notices, which
name other sessions, were dropped.

## Results

`raw/reserve-layouts-9700x.log`, medians of 401 for 90 arenas: 64 GB each 327.8 and 328.8 µs, 1 GB 316.2–316.3,
128 MB 229.6–230.5, 2 MB 216.0–217.0, ranges of one mapping 146.1–150.9, faults alone 69.8–70.2, no arenas 25.9–26.4.
Per arena, the floor subtracted: 3.35–3.36, 3.22–3.23, 2.26, 2.11, 1.34–1.38 and 0.49 µs.

Inventories (local): main's empty `-fsyntax-only` reserves 81 mappings, touches 44 and has 260 VMAs at exit; the head's
43, 26 and 125. The one-line `-c`: 92, 56 and 262 against 54, 38 and 134. `raw/footprints-main-nothp.txt` gives the
preprocessor's tables' largest footprints: on `sqlite3.c` 368 KB (`c_preprocessor.c:17866`, the macros), on `main.c`
1,852 KB (`:17867`, the items) and 1,076 KB (the macros). On the empty file each record table and stack column touches
4 KB or none, and the file cache's struct (`:17906`) 124 KB.

`perf stat -r 51`, three rounds (`raw/ab.log`'s `== stat` lines):

| tree | empty `-fsyntax-only` | kernel instructions | faults | one-line `-c` | kernel instructions | faults |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| base | 0.56 ms | 3.64–3.65 M | 376 | 0.67 ms | 4.31–4.33 M | 442–443 |
| head | 0.46–0.47 ms | 2.92 M | 389 | 0.57–0.58 ms | 3.57–3.59 M | 454 |

`strace -f -c` of the empty `-fsyntax-only` (`raw/strace-*.txt`): base 363 calls (`mmap` 93, `mprotect` 82, `madvise`
48), head 214 (55, 44, 11).

`time-runs` medians against `base`, per round (wall time; user cycles):

| input | head, wall | base-again, wall | head, user cycles | base-again, user cycles |
| --- | --- | --- | --- | --- |
| empty `-fsyntax-only` | −13.27%, −13.42%, −13.22% | +0.06%, −0.12%, +0.21% | +3.13%, +2.40%, +3.16% | +0.89%, −0.30%, +1.20% |
| empty `-E -P` | −16.45%, −16.00%, −16.17% | +0.04%, −0.07%, −0.17% | +1.50%, +1.91%, +2.02% | +1.59%, +1.16%, +1.24% |
| one-line `-c` | −9.07%, −10.17%, −10.44% | −0.27%, −0.22%, −0.28% | +1.28%, +1.62%, +2.05% | +0.58%, +0.53%, −0.31% |
| `sqlite3.c` `-E -P` | −2.41%, −2.31%, −1.68% | −0.35%, −0.44%, +0.41% | −1.34%, −0.77%, −0.97% | −0.57%, +0.02%, −0.21% |
| `sqlite3.c` `-fsyntax-only` | −0.58%, −0.04%, −0.13% | −0.02%, +0.08%, −0.11% | −0.28%, +0.26%, +0.01% | +0.53%, +0.08%, −0.06% |
| `sqlite3.c` `-c` | −0.36%, −0.46%, −0.39% | −0.27%, +0.00%, −0.24% | −0.24%, −0.32%, −0.20% | −0.02%, +0.22%, −0.04% |

Per process (`time-runs`' `list` lines): the empty `-fsyntax-only` makes 407 minor faults against 394, executes
1,398,450 user instructions against 1,406,394, and peaks at 11,744 KiB against 13,660 (the file cache's huge page);
`sqlite3.c`'s `-c` 4,859 faults against 4,844 and 298,056 KiB against 300,028.

## Limitations

- One machine and kernel for the timings; the inventories come from another (the 7940HS).
- `reserve_bench2` isolates reservation layouts; it doesn't measure the compiler.
- The footprints are one run each, by call site and occurrence; a site reserved in a loop is told apart by its order.
