# The preprocessor's tables in one reservation (#652)

Evidence for [buster14a/buster#1237](https://github.com/buster14a/buster/pull/1237), part of
[#652](https://github.com/buster14a/buster/issues/652): a small unit's fixed setup cost, here the number of its arenas.

The PR changed after this record's first part. [buster14a/buster#1203](https://github.com/buster14a/buster/pull/1203)
(#1128) merged a general arena of tables (`arena_reserve_tables`) for the preprocessor's records' tables, the output's
and each stack's columns; the PR's merge with that main took its mechanism, and its final head puts the stacks' columns
and the file cache among the unit's tables, all in base pages. [After #1203](#after-1203) measures that head against
the main it merged. The first part below measures the PR's first design against the main before #1203, and its
reservation-layout benchmark and inventories still stand.

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

## After #1203

Files under `after-1203/`. The PR's head was merged with main `eac92264` (#1203 and the rest), then given base pages
throughout; each tree was a `git archive` of a named commit, built on the 9700X with `BUSTER_HOST_ARCH=znver5`, each
build under the lock:

| tree | source | what |
| --- | --- | --- |
| `base` | `eac92264049cff02cf8116030a196b83b45d6fa4` | main with #1203 |
| `head` | `d02fb1ea0d156aa146288c7ebb397ac35fd3f04a` | the PR's merge with it: the stacks' columns and the file cache among the unit's tables, each table with huge pages past its first pages as #1203 lays them out |
| `headB` | `d02fb1ea` with `scripts/headB.patch` | the same with every one of the unit's tables in base pages (`.small` at least its bytes) |
| `final` | `92d72e19901177470b79eb4768b5a2458db07f49` | the PR's head: `headB`'s layout, written as `pp_table` without its base-pages argument |

`final` lays out the same tables as `headB`; its code differs in `pp_table`'s signature and comments. The host, its
toolchain, CPU 2's governor and the transparent huge pages' settings are at the top of `raw/ab-merge.log` and
`raw/ab-final.log`, then the executables' and inputs' SHA-256 (`sqlite3.c` is the same frozen file as in the first
part; `main.c` is `base`'s `src/buster/compiler/main.c`).

### Runs

- `scripts/merge-ab.sh` (`raw/ab-merge.log`): three rounds of `perf stat -x, -r 51` of an empty file's `-fsyntax-only`
  and a one-line function's `-c` on `base` and `head`, `strace -f -c` of the empty `-fsyntax-only` (written as
  `strace-base.txt` and `strace-head.txt`, here `raw/strace-main-merge-run.txt` and `raw/strace-merge.txt`), then
  `ab --rounds 3 --cpu 2` of `time-runs --copies 3` with `base`, `head` and `base-again`.
- `scripts/merge-ab2.sh` (`raw/ab-variant.log`): `perf stat` and `strace` (`raw/strace-variant.txt`) of `headB`, then
  `time-runs` with `base`, `head`, `headB` and `base-again`, with `main.c`'s `-E -P` added.
- `scripts/merge-ab3.sh` (`raw/ab-final.log`): `final`'s build, then the same as `merge-ab.sh` on `base` and `final`
  (`raw/strace-main-final-run.txt`, `raw/strace-final.txt`) with `main.c`'s `-E -P`.
- `raw/local/`: `strace -f -c` of the empty `-fsyntax-only` on the 7940HS with that machine's native builds of `base`
  (`strace-main-7940hs.txt`), `head`, `headB` and `final`.

Each `perf stat` line ends with its pipeline's status and each `ab` run with `ab`'s (`== ab status=`), all 0. The logs
keep only the lines the scripts, `ab` and `time-runs` print (an allowlist of their shapes); the lock's waiting notices,
which name other sessions, were dropped, and nothing else was.

### Results

`perf stat -r 51` (`raw/ab-final.log`'s `== stat` lines), three rounds: an empty file's `-fsyntax-only` 0.51 to 0.52 ms
on `base` and 0.46 on `final`, kernel instructions 3.27 to 3.29 M against 2.84 M, faults 392 against 392 to 393, user
instructions 1,396,741 against 1,394,587; the one-line `-c` 0.63 against 0.58 ms, 3.98 to 3.99 M kernel instructions
against 3.54 M, faults 464 against 463. `headB` (`raw/ab-variant.log`) read the same: 0.46 and 0.58 ms, 2.86 and 3.55 M.

`strace -f -c` of the empty `-fsyntax-only` on the 9700X: `base` 237 calls (`mmap` 49, `mprotect` 38, `madvise` 54),
`head` 224 (45, 34, 50), `headB` and `final` 186 (45, 34, 12).

`time-runs` medians against `base`, per round (wall time; user cycles), `raw/ab-final.log`:

| input | final, wall | base-again, wall | final, user cycles | base-again, user cycles |
| --- | --- | --- | --- | --- |
| empty `-fsyntax-only` (31 × 3) | −7.13%, −6.42%, −6.40% | +0.20%, +0.63%, +0.52% | +2.65%, +1.79%, +3.07% | +1.43%, +0.45%, +1.23% |
| empty `-E -P` (31 × 3) | −7.96%, −7.96%, −8.29% | +0.59%, +0.27%, +0.21% | +1.88%, +1.34%, +1.55% | +0.94%, +0.83%, +0.95% |
| one-line `-c` (31 × 3) | −4.45%, −5.13%, −4.68% | +1.27%, +0.07%, +0.29% | +3.19%, +1.88%, +2.20% | +1.53%, +0.74%, +0.25% |
| `sqlite3.c` `-E -P` (11 × 3) | −2.10%, −0.21%, −1.38% | −0.48%, +0.48%, −0.89% | −1.06%, −0.40%, −0.11% | +0.03%, −0.03%, −0.14% |
| `sqlite3.c` `-fsyntax-only` (7 × 3) | +0.37%, −0.23%, −0.38% | +0.12%, −0.07%, −0.16% | +0.23%, −0.16%, +0.05% | +0.06%, +0.11%, +0.01% |
| `sqlite3.c` `-c` (7 × 3) | −0.18%, −0.41%, −0.48% | +0.02%, −0.28%, −0.43% | −0.07%, −0.06%, −0.48% | +0.20%, −0.05%, −0.29% |
| `main.c` `-E -P` (7 × 3) | −0.90%, −0.80%, −0.82% | −0.13%, +0.12%, −0.09% | −0.19%, +0.00%, −0.17% | −0.06%, +0.23%, −0.05% |

`raw/ab-merge.log` and `raw/ab-variant.log`, wall time against `base`:

| input | head (merge-ab) | base-again (merge-ab) | head (merge-ab2) | headB (merge-ab2) | base-again (merge-ab2) |
| --- | --- | --- | --- | --- | --- |
| empty `-fsyntax-only` | +0.91%, +0.95%, +0.59% | −0.10%, +0.34%, +0.25% | +0.17%, +0.72%, +0.71% | −6.41%, −6.39%, −6.32% | +0.52%, +0.53%, +0.77% |
| empty `-E -P` | −0.22%, −0.01%, −0.33% | +0.32%, +0.29%, −0.09% | | | |
| one-line `-c` | +0.02%, +0.69%, +0.77% | −0.02%, +0.41%, −0.33% | +1.06%, +0.92%, +1.14% | −3.59%, −4.40%, −4.09% | +0.87%, +0.30%, +0.31% |
| `sqlite3.c` `-E -P` | +0.01%, +0.31%, +0.61% | +0.46%, −0.57%, +0.80% | +0.14%, +0.39%, +0.30% | −0.18%, −0.58%, −0.04% | −0.23%, −0.01%, −0.37% |
| `sqlite3.c` `-fsyntax-only` | −0.16%, +0.02%, −0.24% | −0.26%, −0.06%, −0.34% | +0.16%, +0.08%, −0.08% | −0.03%, −0.13%, −0.43% | +0.15%, +0.15%, −0.30% |
| `sqlite3.c` `-c` | −0.21%, −0.26%, −0.23% | −0.15%, −0.32%, −0.15% | −0.36%, −0.32%, +0.32% | −0.55%, −0.41%, −0.11% | −0.38%, −0.37%, +0.34% |
| `main.c` `-E -P` | | | −0.06%, −0.15%, −0.09% | −1.04%, −0.68%, −0.75% | +0.03%, +0.10%, −0.03% |

So the merge alone (`head`), four arenas fewer but each table still with huge pages, was no faster than main; base pages
throughout (`headB`, `final`) took 38 of its 50 `madvise` calls away and most of the gain. Per process (`time-runs`'
`list` lines), `final`'s faults and peaks are `base`'s within a few: the empty `-fsyntax-only` 410 to 411 minor faults
and 11,724 to 11,744 KiB on both, `sqlite3.c`'s `-c` 5,338 to 5,339 faults and 293,928 to 293,992 KiB.

### Limitations

- One machine and kernel for the timings, and the lock was contended: batches waited for other sessions' runs between
  them, though none ran during one.
- `headB` is a one-line patch rather than a commit; `final`, which the PR carries, was measured on its own.
- The small inputs' user cycles read 0.5% to 2.5% over their floor on every head with the stacks and the cache among the
  unit's tables, the merge's too, at user instructions 0.15% below `base`'s; this record doesn't say why.
