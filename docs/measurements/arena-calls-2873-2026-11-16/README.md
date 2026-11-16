# The arenas' system calls: reservations taken together (2026-11-16)

Evidence for [buster#2873](https://github.com/buster14a/buster/issues/2873), the second piece of the kernel row's
allocation: the arenas' reservations, commits, advice and releases, which the census
([`kernel-census-musl-2873-2026-11-16`](../kernel-census-musl-2873-2026-11-16/README.md)) gave 0.58 M of a small
unit's 3.86 M kernel cycles. It also has the third piece's measurement: the kernel's cycles a token by system call
after both pieces (section 4).

- **Source:** buster main `1c6cc8ab5e778ab32078cbef17049c4814b30dca`. **A** is the first piece's pull request's head
  ([buster#2885](https://github.com/buster14a/buster/pull/2885); `head`, the executable `63045aa6…` of
  [`executable-pages-2873-2026-11-16`](../executable-pages-2873-2026-11-16/README.md)). **B** is that head with the
  second piece, built from three patches on main as the first record's trees were (`p2`, `1537f687…`). The second
  piece is not a pull request yet: it is a local branch of the session's (`p2-arenas`, six commits on #2885's head),
  since the session has one branch and #2885 is open.
- **Host, runs and A/B:** as the first record (`scripts/ab.sh` there): the 9700X, Linux 6.18.50, one hold of the lock
  a run, fresh copies of each executable, warm-ups, ABBA rounds, every compile on CPU 2 counted as a whole.
- **What the second piece does** (buster's `docs/arena-memory.md`, "Reservations taken together"): a reservation takes
  its mapping from one 16 TiB stretch mapped once, carved from the middle (upwards for the mappings that take huge
  pages, advised once; downwards for base pages and the tables); a commit takes an arena's base pages at once and then
  four times what is committed, where the kernel charges none and the thread has no pool; and a process's first 32
  small releases leave their arenas mapped for its exit.

## In short

- **A small compile's calls for its arenas go from 103 to 49** (`hello.c` by `strace`, in the session's container:
  `mmap` 36 → 5, `mprotect` 51 → 35, `madvise` 10 → 7, `munmap` 6 → 2, and 4 calls to read the commit policy once).
- **#2885's head against the second piece** (`tables/final-*.txt`):

  | | kernel cycles | paired | user cycles | paired |
  | --- | ---: | ---: | ---: | ---: |
  | `-c sqlite3.c`, 21 rounds | 83.95 → 83.25 M | −0.53 M (−0.63%), 14 of 21 | 593.3 → 595.1 M | +1.71 M (+0.29%), 5 of 21 lower |
  | musl, a unit a process, 5 rounds | 5,429.2 → 5,184.9 M | −244.3 M (−4.50%), 5 of 5 | 5,072.7 → 5,066.1 M | −0.10%, 3 of 5 |
  | musl as one command, 5 rounds | 994.1 → 997.8 M | +7.7 M (+0.77%), 0 of 5 | 2,801.3 → 2,787.1 M | −13.0 M (−0.46%), 5 of 5 |
  | an empty file's `-fsyntax-only` ×100, 11 rounds | 204.5 → 197.8 M | −3.40%, 10 of 11 | 58.6 → 58.4 M | −0.64% |
  | an empty file's `-E -P` ×100 | 169.5 → 168.2 M | −0.60%, 7 of 11 | 46.3 → 46.5 M | +0.79% |
  | `tiny.c`'s `-c` ×100 | 247.5 → 238.6 M | −4.76%, 10 of 11 | 81.2 → 80.6 M | −0.76% |
  | `hello.c`'s `-c` ×100 | 372.6 → 362.7 M | −2.81%, 10 of 11 | 357.7 → 356.9 M | −0.36% |

  The objects are the same bytes (`sqlite3.c`'s in 21 rounds of 21, the one command's in 5 of 5). The peaks are the
  same: `-c sqlite3.c` 241,592 KB against 241,656, an empty file's `-c` 13,864 against 13,780 (`tables/peak-*.txt`).
- **By the token:** musl a unit a process, 48 kernel cycles a token less (183,000 a unit of 4.06 M).
- **`sqlite3.c` gains nothing that these runs can show.** Its calls are few beside its pages. Its instructions are the
  same; its user cycles read 0.3% more in 16 of the 21 rounds above and 0.3% fewer in 13 of 21 by the compile's own
  counters (`tables/events-sqlite.txt`, eight events on six counters): the two builds' code is placed differently.
- **Musl as one command** reads 0.8% more kernel cycles in every round and 0.5% fewer user cycles in every round, 5.3 M
  fewer in all. One profile of each (`tables/kprof-*-command.txt`) shows no symbol apart.
- **The tests** of what the change touches pass on the second piece's build (`tables/tests.txt`: the first record's 24
  commands, each status 0).

## 1. What the calls cost, and what didn't work

The census gave the arenas' calls 0.58 M kernel cycles a unit. By `perf record -g -C 2 -e cycles:k` of musl's units,
a process each (`scripts/ksys.sh`, `tables/ksys-head-musl.txt`): `mprotect` is 283,000 cycles a unit at #2885's head
(5,500 a call), the reservations' `mmap`s about 73,000, `munmap` 165,000, most of it the pages it frees.

**Four stretches, each carved from its start** (the first build: `tables/four-regions-*.txt`): musl a unit a process
−88.4 M (−1.64%), and musl as one command **+49.5 M (+4.98%)**, 0 of 5.

- **On a thread with a pool, larger commits cost more than they save.** The pool keeps what its arenas committed, so
  their commits are few (0.15 a unit). Its releases discard each arena's pages (`MADV_DONTNEED`), which frees the page
  tables of every whole 2 MB they cover (Linux 6.13): with larger commits each unit built them again (`free_pte`,
  `pmd_install`, `___free_pages` in `tables/kprof-p2.txt` against `kprof-head.txt`). Larger commits are now for
  threads without a pool.
- **Stretches apart cost every exit and unmap.** One stretch for each set of `mmap` flags, 8 TiB apart, put a small
  unit's arenas under seven of the kernel's third-level page tables where their own mappings, which the kernel places
  one below the other, had been under three. `unmap_page_range` and `free_pgd_range`, which scan those, took 15,900
  and 7,900 cycles a unit more (`tables/kprof-p2-musl.txt` against `kprof-head-musl.txt`), a third of what the fewer
  calls saved. Now one stretch whose two halves are carved from the middle.

**Before the kept releases** (`tables/before-kept-*.txt`): musl a unit a process −206.2 M (−3.79%), 5 of 5;
`sqlite3.c` −1.32 M (−1.57%), 14 of 21; one command +6.4 M (+0.65%).

## 2. Leaving released arenas to the exit

An experiment on one executable (`scripts/exp-release.sh`, `huge-p2x.patch`: a variable makes every release without a
pool leave its arena mapped), both sides on one copy, the variable's name one letter apart on the other side so that
the environments are of one size (`tables/keep-*.txt`):

| | kernel cycles | user cycles |
| --- | ---: | ---: |
| musl, a unit a process, 9 rounds | −118.0 M (−2.25%), 9 of 9 | −0.17%, 8 of 9 |
| `-c sqlite3.c`, 21 rounds | −0.19 M, 11 of 21 | 0.00% |
| `hello.c`'s `-c` ×100, 11 rounds | −8.6 M (−2.35%), 11 of 11 | −0.40%, 11 of 11 |

The change keeps only arenas that pushed no more than 1 MiB, and only a process's first 32.

## 3. Not done: reservations writable from the start

Mapping each reservation readable and writable from the start (`MAP_NORESERVE`) would need no commit at all, and take
the remaining 35 `mprotect` calls of a small unit. A core dump walks every written anonymous mapping whole, page by
page, mapped or not: a compile's 1.1 TiB of reservations (`sqlite3.c`: 34 of them, 17 of 64 GiB) would make each
crash take a minute or more. The tables (12.5 GB, committed whole since buster#1128) are already walked so. Not
measured here.

## 4. The third piece's measurement: what is left, by system call

`scripts/rows.sh`, `scripts/rows.py`, `tables/rows.txt`: `perf record -g -C 2 -e cycles:k -c 100003` of 20 compiles of
`sqlite3.c`, and of musl's units, a process each, for main, #2885's head and the second piece; inclusive cycles of
each system call's entry, of the page fault's and of the exit's, by the token. One run each, so a row is good to a few
percent of itself. Musl's rows are less the same loop with `/usr/bin/true` in the compiler's place, which also takes
off what `true` itself costs a process (its own start, its dynamic linking, its exit): they are low by that, and the
`mmap` row can't be read there.

| kernel cycles a token | `sqlite3.c` main | #2885 | second piece | musl a unit a process, main | #2885 | second piece |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| page faults | 97.95 | 95.85 | 95.42 | 453.0 | 353.6 | 354.3 |
| the exit (the teardown, in the helper) | 7.74 | 6.33 | 6.46 | 209.3 | 146.0 | 153.9 |
| `munmap` | 3.85 | 3.79 | 3.80 | 43.3 | 44.6 | 30.8 |
| `mprotect` | 1.04 | 0.96 | 1.00 | 71.4 | 69.5 | 58.3 |
| `madvise` | 1.05 | 1.18 | 0.82 | 19.8 | 20.2 | 12.7 |
| `mmap` (with the source's populated mapping) | 1.23 | 1.35 | 1.33 | | | |
| `openat` | 1.66 | 1.77 | 1.86 | 48.0 | 47.5 | 48.0 |
| `read`, `pread64` | 0.84 | 0.81 | 0.73 | 12.6 | 13.5 | 12.3 |
| `newfstatat`, `fstat`, `access`, `readlinkat`, `close`, `getdents64` | 0.60 | 0.47 | 0.52 | 13.5 | 13.3 | 13.8 |
| `pwrite64`, `ftruncate` | 1.26 | 1.26 | 1.04 | 3.6 | 4.0 | 3.5 |
| `execve` | 0.79 | 0.76 | 0.80 | 23.2 | 24.3 | 25.2 |
| `clone3`, the helper's start | 0.23 | 0.30 | 0.28 | 34.7 | 35.7 | 33.7 |
| timer and other interrupts | 2.41 | 2.24 | 2.32 | 8.9 | 7.9 | 6.4 |
| **all kernel cycles on the CPU** | **122.25** | **118.76** | **117.72** | **1,034.2** | **870.5** | **816.9** |

- **What the two pieces took:** 4.5 cycles a token of `sqlite3.c`'s 122.3 and 217 of a small unit's 1,034.
- **What is left that is not memory** (the faults, the teardown, the unmaps' pages), on `sqlite3.c`: the files, about
  5.5 (the include search's `openat` 1.9 and the calls around it 1.3, the source's mapping 1.3, the object's write
  1.0); the timer's interrupts 2.3; the commits and advice 1.8; the start and the helper's 1.1.
- **On a small unit the include search is the largest row left that is a call:** 48 cycles a token in `openat`, 37 of
  a unit's 54 opens being probes that fail (the census). Then `mprotect` 58, the helper's start and the fork 34, the
  start 25.

## Files

- `scripts/`: `series-p2.sh`, `final-p2.sh` (the build, the A/Bs, the tests, the peaks), `exp-release.sh` and
  `huge-p2x.patch` (section 2), `huge-p2a.patch` (the four stretches' build), `kprof.sh` and `ksys.sh` (the kernel by
  symbol, flat and inclusive), `rows.sh`, `rows-all.sh` and `rows.py` (section 4), `events.sh` (the compile's own
  counters). The rest are the first record's (`ab.sh`, `build-tree.sh`, `regen.sh`, `order.sh`, `tests.sh`,
  `peak.sh`, `lock.sh`, `tools/`).
- `raw/results.tar.xz`: every run's counts (`results` the final build's, `results-b` before the kept releases with
  the experiment's, `results-a` the four stretches'), the profiles and the tests' outputs; `raw/*.out`, `raw/*.log`:
  the builds' and the series' logs.
- `tables/`: `abstat`'s table of each A/B, the profiles, the rows, the events, the peaks and the tests' statuses.
