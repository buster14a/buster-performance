# A small compile's anonymous faults and first commits (#1444, items 1 and 2), 2026-11-11

Evidence for the pull request from buster14a/buster's `claude/intelligent-euler-cn4nxx`, part of
[#1444](https://github.com/buster14a/buster/issues/1444): the fixed start of a small compile. This record covers items 1
(the arenas' first commits: `mprotect`, and the advice calls beside them) and 2 (anonymous page faults), following the
issue's design comment of 2026-11-08: a census on current `main`, then one packed table family (candidate A) and one
change that removes a reservation's transition call (candidate B), each measured against `main` with `main` again as
the A/A floor.

## Sources

| tree | what it is | measured as |
| --- | --- | --- |
| `base` | `main` at `92da7275dfad08e445cf82f86e8d019e9da8db78` (#1891's merge) | `shifts-base/compiler-{0,1088,2112,3136}` |
| `lanes` | base and `patches/lanes.patch`: the release walks only the file cache's reserved lanes | census only |
| `tls` | base and `patches/tls.patch`: `lanes`, and the test-path buffer shared by `main.c`'s units (an intermediate form: 9 copies left) | census only |
| `head` | base and `patches/head.patch`: `lanes`, one test-path buffer for the executable, and `MAP_STACK` reservations | `shifts-head/...` |
| `packed` | base and `patches/packed.patch`: `head`, and the type table's two arenas as one arena of tables (candidate A) | `shifts-packed/...` |
| `nostack` | base and `patches/nostack.patch`: head without `MAP_STACK` (the pull request's first two commits) | `shifts-nostack/...` |

The pull request's three commits differ from `patches/head.patch` only in comments, documentation, and one function's
name (`arena_release_maps_stack_base_pages`, renamed `arena_kernel_maps_stack_base_pages`). The patches are this
compiler's own source (Apache-2.0 WITH LLVM-exception; `lane.c`'s hunks under that file's MIT terms, as in buster's
`THIRD_PARTY_NOTICES.md`).

Each tree is a `git worktree` of a clone of buster14a/buster with its patch applied, built on the 9700X by
`scripts/build.sh` or `scripts/build-patch.sh` under the machine's lock:
`BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 taskset -c 0-7 ./build.sh shifts --config Release DIR main_unit_checker.c 0 1088 2112 3136`,
four placements of `main_unit_checker.c`'s code. `raw/hostinfo.txt` has every executable's SHA-256, the patches' and the
inputs'. `base-again` is base's four executables timed again: the A/A floor.

## Host

`raw/hostinfo.txt`: AMD Ryzen 7 9700X (8 cores, CPUs 0–9 and 11–15 online), Linux 6.18.50-2-lts, CPU 2 on the
`performance` governor and the others on `powersave` with `balance_performance`, transparent huge pages `always`
(defrag `madvise`), `vm.overcommit_memory` 0, clang 23.1.1, perf 7.2.9, strace 7.2, glibc 2.44.

Every build and measurement ran under the shared lock (`~/buster-fast-bench/exclusive.sh`), one script command per hold.
No log here keeps the lock's waiting notices, which would name other sessions. The timed processes are pinned to CPU 2
(`taskset -c 2`), where a compile's session starts no lane thread. The exceptions are `scripts/kstat2.sh`'s `-lanes`
controls and `scripts/ab-lanes.sh`, which run on every CPU and so start 8 lanes.

## Inputs

`inputs/`: `empty.c`; `tiny.c` (`int main(void){return 0;}`); `hello.c` (`#include <stdio.h>` and a `printf`); `medium.c`
(200 functions of a loop each) and `a.c` to `d.c` (four small units), the last five from
`lazy-lanes-1444-2026-11-11/inputs`. And the 9700X's frozen `sqlite3.c`
(`/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite`), with
`-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0`.

The controls: an empty file's `-fsyntax-only` and `-E -P`, `tiny.c`'s and `hello.c`'s `-c`, `medium.c`'s `-c`, the four
units' `-c` in one process, and `sqlite3.c`'s `-c`.

## Cache conditions

The inputs and executables are in the page cache: every executable is run before it is measured, and every input is
read by those runs. Every measured run is a fresh process.

- `time-runs` (`scripts/ab.sh`) runs fresh copies of each executable in a Williams design over the builds and
  placements. So each process starts right after another build's, a cold start for the caches, branch predictors and
  the executable's own page-cache folios.
- `perf stat -r` (`scripts/census.sh`, `scripts/kstat.sh`, `scripts/kstat2.sh`) runs one executable's processes back to
  back: warm.
- Faults, system calls and huge pages are counted on single processes or groups of 20.

## Runs

- `scripts/census.sh NAME` (`scripts/attribute.py`, `scripts/rusage.c`): for each control, `perf stat -r 200` (5 for
  `sqlite3.c`), `rusage` (wait4's medians over 200 processes: peak RSS, minor faults), `strace -f -c` of one process,
  `/proc/vmstat`'s `thp_fault_alloc` around 200 processes (5 for `sqlite3.c`), and, but for `sqlite3.c`, one process
  under `strace -f -k` (every `mmap`, `mprotect`, `madvise`, `munmap` and `brk`, with its call stack) and one under
  `perf record -e page-faults -c 1 -d`, both with the address space's randomization off (`setarch -R`), so that each
  fault is attributed to the mapping that holds it and to the code that made that mapping (`raw/census/NAME/`).
- `scripts/faults.sh p base head`: the same attribution over 20 processes of each control at each of the four
  placements (`raw/faults/`, summarized by `scripts/faults-summary.py` in `raw/faults-summary.txt`).
- `scripts/ab.sh r1 head packed` and `scripts/ab.sh r2 head packed`: two rounds of three `time-runs` processes over
  base, head, packed and base-again at four placements, from two fresh copies of each executable: the small controls,
  30 runs (3 warm-ups) of each slot; `medium.c` and the four units, 20 runs (2 warm-ups); `sqlite3.c`, 4 runs (1
  warm-up) of one copy (`raw/ab-r1-*.txt`, `raw/ab-r2-*.txt`).
- `scripts/kstat.sh r1 3 head packed`: `perf stat -r 300` (50 for `medium.c`) of each build's placement 0, three rounds
  in a rotating order (`raw/kstat/`, `raw/kstat-summary.txt`).
- `scripts/kstat2.sh r1 3 head`: the same at all four placements, `-r 200` (40, and 5 for `sqlite3.c`), with two
  unpinned controls, `tiny.c`'s `-c` and `sqlite3.c`'s `-c` on 8 lanes; the summary takes the median over the 12
  placements and rounds (`raw/kstat2/`, `raw/kstat2-summary.txt`).
- `scripts/map-stack.c`: whether a `MAP_STACK` mapping is `VM_NOHUGEPAGE` (`nh` in smaps) and whether `MADV_HUGEPAGE`
  replaces it, which it printed on the 9700X's 6.18.50 and on a cloud VM's 6.18.44.

- `scripts/campaign3.sh`: `nostack`'s build and census, `ab.sh r3 nostack head` and `kstat2.sh r2 3 nostack head`
  (`raw/ab-r3-*.txt`, `raw/kstat2-r2/`, `raw/kstat2-r2-summary.txt`).
- `scripts/ab-lanes.sh r1 nostack head`: `time-runs` on every CPU (`raw/ab-lanes-r1-*.txt`).

`scripts/campaign.sh`, `scripts/campaign2.sh` and `scripts/campaign3.sh` ran them in that order, and `ab-lanes.sh` last.
`scripts/kstat-round.sh` and `scripts/kstat2-round.sh` are the rounds the two `kstat` scripts wrote and ran.

## The census on `main`

An empty file's `-fsyntax-only` on `base` makes 110 system calls: 27 `mmap`, 25 `mprotect` (one of them the C
library's RELRO), 11 `madvise`, 2 `munmap` and 5 `brk`. By the code that made them (`raw/census/base/attribution-syntax.txt`):

- **`mprotect`, 24 first commits:**
  - 6 of the preparation's token columns (`pp_prepare_whole`): 3 in the unit's own columns and 3 in the file cache's
    lane 0;
  - 3 in `pp_initialize_once`, among them the preprocessor's two arenas of tables;
  - 2 each in `check_driver_command`, `parse_columns` and `type_initialize`;
  - 1 each in the intern table, the directories, the scratch, the cache's paths, the directive arrays, the parse
    tree's kernels, `check_input_run`, `check_driver_unit` and `check_program`.
- **`madvise`, 11 calls:**
  - 5 `MADV_NOHUGEPAGE` at a reservation: the preprocessor's 10 GB and 2.5 GB arenas of tables, its 64 GiB arena
    with 6 MB of base pages, and the file cache's two arenas with 4 MB;
  - 1 `MADV_NOHUGEPAGE` on the executable's `.bss`;
  - 5 `MADV_HUGEPAGE`: the output columns' four tables, and the intern table's huge pages.

Its faults, 338 a process at every placement (`raw/faults-summary.txt`):

| region | faults |
| --- | ---: |
| anonymous, the arenas | 172 |
| file-backed (`.text`, `.rodata`, `.bss`, `.data*`) | 113 |
| stack and vDSO | 26 |
| anonymous, the heap | 25 |
| other | 2 |

The arenas' 172, by the mapping and the code that faulted (`raw/census/base/attribution-syntax.txt`):

- **98 in the preprocessor's arena of tables (10 GB), on 63 pages.** `pp_release_file_columns` took 63 of them, on 32
  pages: after the run it walks every one of the file cache's 256 lanes' arenas (`FileCache.lanes`, 130 KB, among the
  unit's tables), reading each page (the zero page) and then writing it (a page of its own). The other 35 are the
  tables' first pages, one or two each.
- **29 in the intern table's arena, on 15 pages:** the predefined names and the predefines' identifiers, each page
  read before it is written.
- **14 in the preprocessor's 64 GiB arena, and 12 in the command's.**
- **A few in each of the others:** the parse columns 5 and 2, the session's 4, and 2, 2, 1 and 1 in the type tables,
  `check_input_run` and `check_program`.

The heap's 25 are the C library's start: 20 of them its clear of the executable's thread-local data, which a
`static _Thread_local char directory[4096]` in `test_paths.h`'s inline `oracle_temporary_directory` made 87 KB. Each of
the 19 objects that call it had a copy. Every thread clears that block as it starts, so a session's lanes clear it too.

Huge pages (`thp_fault_alloc`): 2 a process for the empty file's `-fsyntax-only`, `-E -P` and `tiny.c`'s `-c`, 7 for
`hello.c`'s, 136 for `sqlite3.c`'s (item 3 of #1444, not changed here).

`-E -P` makes 83 system calls (17 `mmap`, 18 `mprotect`, 11 `madvise`) and takes 188 faults, of which 35 in the
preprocessor's tables (no release walk: the run is the whole command), 29 in the intern table, 25 in the heap.
`tiny.c`'s `-c` makes 129 calls (30, 31, 12, 6 `munmap`) and 419 faults; `hello.c`'s 328 calls (34, 49, 24, 6) and 629
faults, 122 of them in the preprocessor's tables (63 the release walk) and 62 in the file cache's lane arenas.

## The changes

1. **The release walks only the reserved lanes (`lanes`).** `FileCache.lanes_reserved` has a bit for each lane whose
   arenas `file_cache_arenas` reserved, or tried to. `pp_release_file_columns` and `file_cache_release` visit those
   lanes alone, and the release clears the fields before `lanes`, now the struct's last member, as the other lanes are
   zero already. This removes the release walk's 63 faults and its loop over 768 arenas.
2. **One thread-local buffer for the temporary directory.** `main.c`'s unit defines `oracle_temporary_buffer` and every
   other object declares it, so the thread-local data is 5 KB rather than 87 KB. (`tls` is an intermediate form in
   which the benchmarks' own objects kept 8 copies; its census is kept, its timing wasn't measured.)
3. **Base pages by `MAP_STACK` (candidate B's mapping half).** Since Linux 6.7 a `MAP_STACK` mapping is
   `VM_NOHUGEPAGE` (`scripts/map-stack.c`). Where `arena_page_policy` finds such a kernel from uname's release, a
   reservation that took `MADV_NOHUGEPAGE` right after its `mmap` is mapped `MAP_STACK` instead and advises nothing:
   2 MB or more of base pages, a busy host's arena, or an arena of tables of 2 MB or more. Its huge pages are still
   advised `MADV_HUGEPAGE` by the first commit that reaches them, which replaces `VM_NOHUGEPAGE` there. This trades one
   `uname` a process for 5 to 10 `madvise` calls in the small controls and 12 in `sqlite3.c`. Each of those calls split the
   reservation's mapping and took the address space's lock for writing.

Candidate A, `packed`, is `head` with the type table's two arenas (`check_driver_unit`'s `type_arena` and `index_arena`,
#1444's item 6) laid out as one arena of tables, each a borrowed view of its table. Their sizes are known together, and
they are reserved and released together.

## Results: faults, system calls, huge pages, memory

Faults a process, median over the four placements (`raw/faults-summary.txt`, 20 processes of each):

| control | base | head | the arenas | the heap | file-backed |
| --- | ---: | ---: | --- | --- | --- |
| empty `-fsyntax-only` | 338 | 254 | 172 → 108 | 25 → 7 | 113 → 111 |
| empty `-E -P` | 188 | 168 | 82 → 81 | 25 → 7 | 67 → 66 |
| `tiny.c` `-c` | 419.5 | 337 | 193 → 129 | 25 → 7 | 157 → 154.5 |
| `hello.c` `-c` | 628.5 | 545.5 | 377 → 313 | 25 → 7 | 175.5 → 173 |

- **The anonymous faults are the same at every placement.** The preprocessor's tables went from 98 to 34 (122 to 58
  for `hello.c`), and the heap's from 25 to 7. Every other mapping's count is unchanged, the stack's included.
- **File-backed faults depend on the code's placement.** One of head's four placements took 17 to 25 fewer (94 for the
  empty `-fsyntax-only`); base's took 113 or 114 at every placement.
- **Under `perf stat` on 8 lanes, `tiny.c`'s `-c` went from 607 faults to 393** (`raw/kstat2-summary.txt`): each of
  the 7 lane threads also clears the thread-local data at its start.

System calls of one process (`strace -f -c`, `raw/census/*/syscalls-*.txt`):

| control | base: total, `mmap`, `mprotect`, `madvise`, `munmap` | head |
| --- | --- | --- |
| empty `-fsyntax-only` | 110: 27, 25, 11, 2 | 109: 27, 25, 6, 2, and 1 `uname` |
| empty `-E -P` | 83: 17, 18, 11, 0 | 82: 17, 18, 6, 0 |
| `tiny.c` `-c` | 129: 30, 31, 12, 6 | 127: 30, 31, 6, 6 |
| `hello.c` `-c` | 328: 34, 49, 24, 6 | 319: 34, 49, 14, 6 |
| `sqlite3.c` `-c` | 1,064: 42, 82, 44, 7 | 1,053: 42, 82, 32, 7 |

Head's empty-file counts also hold 3 more `openat`, `read` and `close` calls than 5 fewer `madvise` and one `uname` would
give. They are `sysconf`'s read of the CPUs online in `arena_host_busy`, which a process makes only when another task was
runnable as it started.

Huge pages (`thp_fault_alloc` over 200 processes; 5 for `sqlite3.c`): 400 and 400 for the empty file's
`-fsyntax-only`, its `-E -P` and `tiny.c`'s `-c`; 1,394 and 1,400 for `hello.c`'s; 680 and 680 for `sqlite3.c`'s. The
counter is system-wide, so `hello.c`'s 6 more are within what other processes allocate meanwhile.

Peak RSS (wait4's median over 200 processes, KB): the empty `-fsyntax-only` 10,480 → 10,236; `-E -P` 7,500 → 7,508;
`tiny.c` 13,808 → 13,492; `hello.c` 24,096 → 23,772; `sqlite3.c` 235,624 → 235,360.

## Results: time

`time-runs`, head against base, the median over 240 cold processes (160 for `medium.c` and the four units, 16 for
`sqlite3.c`), with base-again against base (the A/A floor) after the slash. `raw/ab-r1-*.txt`, `raw/ab-r2-*.txt` and
`raw/ab-r3-*.txt` hold the placements' and copies' ranges.

| control | wall, r1 | wall, r2 | wall, r3 | user cycles, r1 | r2 | r3 |
| --- | --- | --- | --- | --- | --- | --- |
| empty `-fsyntax-only` | −5.13% / −0.55% | −5.47% / −1.31% | −5.22% / −1.12% | −4.06% / +0.70% | −3.84% / +0.09% | −2.68% / −0.23% |
| empty `-E -P` | −2.93% / −1.20% | −3.30% / −1.97% | −2.77% / −1.57% | −0.89% / +0.24% | −0.47% / +0.56% | +0.37% / +0.72% |
| `tiny.c` `-c` | −4.44% / −0.34% | −4.94% / −2.71% | −4.77% / −1.37% | −1.79% / +0.77% | −2.13% / +0.08% | −1.76% / +0.19% |
| `hello.c` `-c` | −6.41% / −3.05% | −3.66% / −3.81% | −2.46% / −1.34% | −1.84% / −0.92% | −1.56% / −0.97% | −0.37% / −0.79% |
| `medium.c` `-c` | −2.55% / −1.03% | −2.56% / −2.46% | −2.82% / −2.19% | −0.63% / −0.02% | −0.48% / −0.06% | −0.56% / −0.52% |
| four units' `-c` | −0.57% / −0.18% | −2.32% / −2.06% | −2.12% / −2.05% | +0.01% / +0.25% | +0.27% / +0.18% | −0.02% / −0.65% |
| `sqlite3.c` `-c` | −0.13% / −0.26% | −0.10% / +0.08% | −0.17% / −0.15% | +0.09% / +0.01% | −0.21% / +0.04% | +0.03% / +0.17% |

- **The empty file's `-fsyntax-only` and `tiny.c`'s `-c` are faster beyond the floor in all three rounds:** 5.1% to
  5.5% and 4.4% to 4.9% of wall time, against a floor of 0.3% to 2.7%.
- **The empty `-E -P` gains 2.8% to 3.3% against a floor of 1.2% to 2.0%.** It has no release walk, so it gains only
  the thread-local clear and the advice.
- **`hello.c`'s gain is beyond its floor in r1 and r3 and within it in r2.** Its base-again's last placement was slow
  in every round (2.057, 1.999 and 2.007 ms against about 1.72 to 1.87 ms), which widens the floor. Warm, under
  `perf stat` below, it takes 2.9% less task clock against a floor of 0.
- **`medium.c`, the four units and `sqlite3.c` are within their floors: no regression.**

`perf stat` over the four placements and three rounds, warm (`raw/kstat2-summary.txt`; the floor within 0.3% for every
row here):

| control | task clock | user cycles | kernel cycles | kernel instructions | faults |
| --- | --- | --- | --- | --- | --- |
| empty `-fsyntax-only` | −9.4% | −10.1% | −7.5% | −11.2% | 338.5 → 254 |
| empty `-E -P` | 0.21 ms both | −3.9% | −3.7% | −4.9% | 188 → 168 |
| `tiny.c` `-c` | −6.8% | −6.3% | −6.2% | −7.6% | 419 → 336 |
| `hello.c` `-c` | −2.9% | −1.3% | −4.1% | −5.7% | 628.5 → 546 |
| `medium.c` `-c` | −2.3% | −1.2% | −4.4% | −5.7% | 709.5 → 627 |
| `tiny.c` `-c`, 8 lanes | −13.1% | −15.3% | −13.1% | −17.4% | 607 → 393 |
| `sqlite3.c` `-c`, 8 lanes | −0.04% (floor −0.26%) | −0.4% | −0.6% (floor −2.3%) | −1.2% | 10,030 → 9,818 |

The user-cycle share of the gain is the release walk's loop over 768 arenas (−9,000 user instructions, 1.65%) and its
cache misses, and the C library's clear of 72 KB less of thread-local data.

## Candidate A: the type table's two arenas as one arena of tables — doesn't pay

`packed` lays out `type_arena` (pushed whole by `type_initialize`, base pages throughout) and `index_arena` (whose index
doubles inside it, base pages to 4 MB) as the two tables of one arena of tables, each table a borrowed view. That is
one mapping and one commit where there were two of each.

- **Its system calls:** the empty file's `-fsyntax-only` makes 26 `mmap` and 24 `mprotect` (head: 27 and 25).
  `hello.c`'s `-c` makes 33 and 43 (34 and 49): the index's growth no longer commits as it goes, since the table is
  committed whole. `sqlite3.c`'s makes 41 and 73 (42 and 82).
- **Its time is head's within the noise.** Against base in r1 and r2:
  - wall: −4.56% and −6.46% for the empty `-fsyntax-only`; −2.99% and −6.15% for `tiny.c`; −6.60% and −6.37% for
    `hello.c`;
  - user cycles: −3.06% and −3.81%; −2.01% and −2.18%; −0.70% and −0.75%;
  - head, against base in the same rounds: wall −5.13% and −5.47%, −4.44% and −4.94%, −6.41% and −3.66%; user cycles
    −4.06% and −3.84%, −1.79% and −2.13%, −1.84% and −1.56%.
- **Warm at placement 0 (`raw/kstat-summary.txt`), packed took more kernel cycles than head** for every small control.
  Its code placement differs, which file-backed faults show: it took 168 faults to head's 156 for `-E -P`, which never
  reaches the type table.
- **It would change strict overcommit's charge.** An arena of tables commits its tables whole, so the index would be
  charged whole at the unit's start where commit charge is bounded: 128 MB for a unit of `sqlite3.c`'s size, which
  today commits the index as it grows.

One reservation fewer a unit is about 1.5 to 2 µs (#1444's item 6), below these controls' floor, and `packed` didn't
show it. It isn't kept. The other small exact regions of an empty compile (the session's 16 KB, `check_input_run`'s
sparse arena and `check_program`'s controls) don't share the type tables' lifetime, and the issue keeps them apart for
their own reasons (#572, #764, #847).

## Candidate B

The design's candidate B, a small exact region mapped writable from the start, would skip the region's first
`mprotect`. But the guard pages that keep its base pages off a writable neighbour's mapping are inaccessible pages of
the same mapping. A writable mapping can only skip that `mprotect` by giving them up, or by creating them with other
calls, which "replacing one protection call with two other syscalls is not a win" rules out. An empty compile has 5
such regions: the session's, the type table's two, `check_input_run`'s and `check_program`'s.

What change 3 does instead is the advice half of a reservation's transitions. `MAP_STACK` gives the mapping
`VM_NOHUGEPAGE` as it is made, before its first touch, with no call of its own and the same layout and guard pages.

## Change 3 alone: `MAP_STACK`

`nostack` is head without `lane.c`'s change: base and the pull request's first two commits (`patches/nostack.patch`).
`scripts/campaign3.sh` built it, took its census, and ran `ab.sh r3 nostack head` and `kstat2.sh r2 3 nostack head`.

- **System calls:** `nostack`'s `madvise` calls are base's, 11 for the empty file's `-fsyntax-only`. Its faults are
  head's within 3 (`raw/census/nostack/`, `raw/kstat2-r2-summary.txt`).
- **Time, warm, over the four placements and three rounds (`raw/kstat2-r2-summary.txt`; the floor within 0.4%):**

  | control | head | `nostack` |
  | --- | --- | --- |
  | empty `-fsyntax-only`, kernel cycles | −7.70% | −5.95% |
  | empty `-fsyntax-only`, task clock | −9.4% | −6.3% |
  | empty `-E -P`, kernel cycles | −3.69% | −2.54% |
  | `tiny.c` `-c`, kernel cycles | −5.65% | −4.57% |
  | `tiny.c` `-c`, task clock | −6.8% | −4.6% |
  | `hello.c` `-c`, kernel cycles | −4.53% | −3.55% |
  | `medium.c` `-c`, kernel cycles | −4.16% | −3.50% |

  Head's user cycles and instructions are `nostack`'s within 0.5%. The 5 `madvise` calls cost 1.0% to 1.8% of the
  small controls' kernel cycles, about 20,000 cycles or 4 µs.
- **Time, cold (`raw/ab-r3-small.txt`):** head against base −5.22%, −2.77%, −4.77% and −2.46% of wall time for the
  four small controls. `nostack` took −3.82%, −1.87%, −3.34% and −1.27%. The floor was −1.12%, −1.57%, −1.37% and −1.34%.
- **On 8 lanes, the two are the same:** `tiny.c`'s `-c`, unpinned, takes −12.8% kernel cycles with either.
  `sqlite3.c`'s `-c` on 8 lanes is within its noise: its kernel cycles over 20 processes a build ranged by ±3% in both
  rounds, the floor's too (head +2.89% and `nostack` −5.55% in r2, the floor +1.28%; head −0.60% in r1, the floor
  −2.30%), and its task clock moved by +0.66% and −0.04% against floors of +0.50% and −0.26%.

## On every CPU: lanes and several units

`scripts/ab-lanes.sh r1 nostack head`: `time-runs` with no `taskset`, so that each compile's session starts its 8
lanes, from fresh copies at the four placements (`raw/ab-lanes-r1-*.txt`). Against base, with base-again after the
slash:

| control | head, wall | `nostack`, wall | head, user cycles |
| --- | --- | --- | --- |
| `sqlite3.c` `-c` (40 runs) | −0.24% / −0.30% | −0.18% | +0.12% / +0.48% |
| `medium.c` `-c` | −4.06% / −1.00% | −3.37% | −1.04% / +0.01% |
| four units' `-c` | −4.26% / −0.05% | −0.33% | +0.94% / −0.53% |
| `tiny.c` `-c` | −5.75% / −1.98% | −6.07% | −6.55% / −0.27% |

`sqlite3.c` is unchanged. `tiny.c` on 8 lanes gains as much without `MAP_STACK`: most of its gain is the thread-local
clear that each of its 7 lane threads no longer makes. The four units on several lanes gain from `MAP_STACK` alone. A
units lane's arenas each start with 16 MB of base pages (its floor), so each of their reservations made an
`MADV_NOHUGEPAGE` call, and the lanes made them at once, against the address space's one lock. This is one round.

## What's left of items 1 and 2

After these changes, an empty file's `-fsyntax-only` still takes 108 faults in its arenas, 26 on the stack and 7 in the
heap (`raw/census/head/attribution-syntax.txt`):

- **34 in the preprocessor's arena of tables, on 30 pages.** These are the first page or two of each table a small
  unit touches. Most of those tables are sparse arrays sized to their id ranges: the design's candidate A rules them
  out for packing.
- **29 in the intern table's, on 15 pages.** Each page is read (the probe maps the zero page) before it is written (a
  page of its own). This is the design's section 5, a separate experiment.
- **14 and 12 in the preprocessor's and the command's 64 GiB arenas:** their first 64 KB.

Its 25 `mprotect` calls are all first commits: 24 arenas' and the C library's RELRO.

The 2 huge pages each small compile allocates are item 3 of #1444.

## Limitations

- **One host, one kernel (6.18.50), transparent huge pages `always`.** `MAP_STACK`'s `VM_NOHUGEPAGE` was checked on that
  kernel and a cloud VM's 6.18.44. On kernels before 6.7 the change takes the old path, which isn't measured here.
- **The cold `time-runs` floors are 0.2% to 3.8% of wall time, wider than some of the gains they bound.** `hello.c`
  and the unpinned runs are the closest to them. The warm `perf stat` floors are within 0.4% for the small controls.
- **`sqlite3.c` on 8 lanes, under `perf stat`, varies by ±3% in kernel cycles between rounds,** the floor's too. The
  cold `time-runs` on 8 lanes and pinned agree that it is unchanged.
- **Strict overcommit and a finite `RLIMIT_DATA` were not measured on the 9700X.** None of the kept changes touches
  commit charge: `MAP_STACK` changes no accounting, and the release walk and the buffer change none.
  `tests/arena/resources.c` passed without them on a cloud VM; the hosted CI runs it with them.
