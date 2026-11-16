# A census of a compile's kernel time and fresh memory (2026-11-16)

Evidence for [buster#2873](https://github.com/buster14a/buster/issues/2873), the first piece of step 5 of
[buster#2850](https://github.com/buster14a/buster/issues/2850) (the one-core path, "fresh memory and the fixed costs",
whose budget gives the kernel and the process's fixed costs 6 cycles a token). It counts the compile as it is: no
compile changes. Its four items are the issue's: the kernel's cycles by cause, fresh memory by owner, what a fresh page
costs on the 9700X by how it is taken, and the floor a compile must still take fresh with every arena reused or bounded
by a window.

- **Source:** buster `3d0d56ed75c5406bfe53c379f37f0d3f85bfc484` (main on 16 November), a clean clone (`src`) built on
  the host by `./build.sh --config Release` with the 9700X job's Clang 23.1.4 (`raw/build.log`). The executable's SHA-256
  is `206f4b13…` (`raw/env.txt`). It is static and not position-independent.
- **The census tree** (`census`, `raw/build-census.log`, `5640f3c5…`) is the same commit with `scripts/stage-laps.patch`,
  a patch this record keeps and buster doesn't merge: `--time-stages` also prints its laps' stages in time order as
  CLOCK_MONOTONIC times (`time-lap`), which `perf record -k mono` shares, so that every sample falls in its stage
  exactly. Without `--time-stages` it runs main's code. Every recorded compile ran it with `--time-stages`; the
  unrecorded totals ran `src`'s executable, but one line of section 1's.
- **Host:** the Ryzen 7 9700X (`benchpress`), Linux 6.18.50, transparent huge pages `always` (defrag `madvise`),
  `CONFIG_HZ=300`, perf 7.2.9, strace 7.2, gdb 18.1 (`raw/env.txt`).
- **Every run** was one hold of the machine's lock (`scripts/lock.sh`, whose hold line each run wrote to
  `raw/holds.txt` first), the compile pinned to CPU 2 (`performance`, its SMT sibling offline), perf on CPU 4. Each
  script writes the busiest processes and the load before and after its run (`raw/results/*/host.txt`).
- **Workload:** `-c` of the frozen corpus's `sqlite3.c` (SHA-256 `0a409f16…`) with the 9700X job's `compile_time`
  options, as the one-core record: 716,136 preprocessed tokens; the object, 2,197,000 bytes, to tmpfs
  (`/dev/shm`) over the previous run's.

## In short

- **The kernel takes 86.5 M cycles a compile, 120.8 a token**, counted on CPU 2 as a whole. A process's own counters
  (`perf stat`, procbench) see 79.8 M: on Linux 6.18 `do_exit` stops a task's perf events before `exit_mm`, so no
  per-task count holds the address space's teardown, with the exit helper or without it. The teardown is 5.1 M of it.
- **Item 1:** 81.9% of the compile's own kernel cycles are page faults, 57.9% the clearing of fresh 2 MB pages
  alone; then the teardown 5.6%, the arenas' own system calls 4.7%, the source's read 4.0% (the include search 2.2%,
  the source's populated mapping 1.8%), the object's write 1.4%, timer interrupts 1.2%, the start 0.7%, the rest of
  the exit 0.5%. **0.07% is in no named row.**
- **Item 2:** 305 MB first touched (7,074 faults) for a 231 MB peak. Seven owners hold 93%: the driver's scratch
  (96 MB), the driver's arena (80 MB), the driver's output arena (48 MB), the reader's sparse columns (16 MB, in base
  pages: 4,169 faults, 10.5 M cycles, three times a huge page's cost a megabyte), the parser's columns, the file cache's
  token arenas and the preprocessor's output (12 to 16 MB each). The owners' faults are the faults counted: 6,907 after
  the exec, less the census patch's own, against 6,902 by the unrecorded compile's own counter.
- **Item 3:** a fresh 4 KB page written costs 2,252 kernel cycles (576 K a MB), a fresh 2 MB page 461 K (230 K a MB);
  a file's page mapped with fault-around 178, populated 256, mapped alone 2,513; a page written to tmpfs over the last
  file 1,853. Freeing costs 409 a 4 KB page and 21 a 4 KB page's share of a 2 MB one.
- **Item 4:** the floor (the source's mapping, the object's write, the tables that outlive a window and one window,
  the stack, the start, the exit and its teardown) is **5.8 to 6.4 cycles a token at item 3's costs**, with every
  table packed in huge pages (the low end with the object written as it is made), and **10.3 to 12.5 at the costs the
  compile pays**, with base pages. Beside it, **5.2 to 6.7 cycles a token are neither fresh memory nor the start and
  exit**: the include search (2.6), the executable's own pages after its start (2.5), the arenas' reservations and
  commits (up to 1.5), timer ticks at the target's time (0.1).
- **Against the gate:** the first two lines are met; the third only at item 3's costs with the object written as it
  is made, by 0.2 cycles a token, and the kernel's time beside the floor is a budget's worth on its own. **Step 5's
  allocation of 6 cycles a token is refuted** by the issue's second condition, and by its first at the costs the
  compile pays.

## 1. Totals

`scripts/totals.sh` (procbench, `scripts/tools/procbench.c`: the whole-build record's harness, a child subreaper whose
counters, from each process's exec and inherited, are read once everything a run started has gone; 15 runs of each
compile line in 3 rotated rounds, 33 of the small ones; `raw/results/totals/`). Medians:

| command | wall ms | user cycles | kernel cycles | user instructions | page faults | peak KB |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `-c sqlite3.c` | 122.33 | 597.56 M | 79.83 M | 1,363.6 M | 6,902 | 236,212 |
| … with `BUSTER_EXIT_HELPER=0` | 122.91 | 596.48 M | 79.55 M | | 6,900 | 236,212 |
| … the object to btrfs | 122.78 | 598.65 M | 81.63 M | | 6,902 | 236,212 |
| … the census tree, no `--time-stages` | 122.61 | 597.55 M | 81.37 M | | 6,902 | 236,212 |
| `-fsyntax-only sqlite3.c` | 99.12 | 474.91 M | 73.84 M | | 6,495 | 236,208 |
| an empty file's `-c` | 0.385 | 0.51 M | 1.30 M | | 269 | 8,152 |
| `-dumpversion` | 0.081 | 0.06 M | 0.26 M | | 54 | 6,864 |
| `/usr/bin/true` | 0.109 | 0.19 M | 0.23 M | | 55 | 6,864 |

With the helper the last process ends 0.89 ms after the wait returns (`settle_ns`); its kernel cycles are the same
with it and without, because neither count holds the teardown (below). The census tree's executable here is its first
build (`3237d0c1…`, `raw/results/totals/host-*.txt`), which differs from the recorded compiles' only in how the patch
writes its report.

`scripts/cputotals.sh` counts CPU 2 as a whole (`perf stat -C 2`) over the same commands under `scripts/tools/waitall.c`
(a child subreaper that waits for the exit helper), 5 runs a round, 3 rounds (`raw/results/cputotals/`): the median of
the rounds' means.

| on CPU 2, under the harness | kernel cycles | user cycles | kernel instructions |
| --- | ---: | ---: | ---: |
| `-c sqlite3.c` | 87.23 M | 595.82 M | 48.64 M |
| … with `BUSTER_EXIT_HELPER=0` | 87.01 M | 596.97 M | 48.83 M |
| `-fsyntax-only` | 80.67 M | 474.59 M | 44.74 M |
| an empty file's `-c` | 2.87 M | 1.03 M | 4.95 M |
| `-dumpversion` | 1.11 M | 0.30 M | 1.94 M |
| `/usr/bin/true` | 0.95 M | 0.39 M | 1.62 M |

**The compile's kernel cycles are 86.5 M**: 87.23 M less the harness (0.95 M with `true` in the compile's place,
0.23 M of which is `true`'s own process by its task counters). That is 120.8 cycles a token. The issue's 86.3 M (120)
was a task's counters at `d96b2e73`; they read 79.8 M now, and the CPU's count adds what they never hold: the
teardown and the exec's first part.

**Why a task's counters miss the teardown.** Linux 6.18's `do_exit` calls `perf_event_exit_task` before `exit_mm`
("since sampling can touch `->mm`, make sure to stop everything before we tear it down"), so the address space's
teardown runs after the task's events have stopped, in the process's exit or, with the exit helper (buster#1444), in
the helper's. The recordings below see it only on the CPU (`perf record -C 2`): 5.1 M cycles, in the exit helper.

## 2. The kernel's cycles by cause (item 1)

### How

`scripts/cpuwide.sh`: 24 compiles by the census tree under `perf record -C 2 -k mono -d --data-page-size`, in 4 holds
of 6, without address-space randomization (`setarch -R`) under waitall: CPU 2's kernel cycles (`cpu/cycles/k`, period
100,003 + 2n, never throttled: `raw/results/cpuwide/throttle-*.txt`) with kernel call chains and the first user frame,
and every minor fault with its address and the size of the page it mapped, and every mapping's record
(`raw/results/cpuwide/`, the text trimmed to the harness's and the compile's processes: `scripts/trim.sh`).
`scripts/tools/kcensus.c` reads each compile's text with its report's laps and puts each sample:

- **in a phase and a stage:** before the exec it is the start; from the exec to the stage clock's start, the start;
  then the stage its time falls in; after the last lap, the exit, as is every sample of the exit helper. The parent's
  fork and wait, the harness's own commands and other tasks on CPU 2 are outside the compile.
- **in a cause:** the innermost way into the kernel on its stack (a fault inside a system call is a fault; a timer
  interrupt inside a fault is the interrupt); a system call by its `__x64_sys_` frame or its inner function, and by
  what its stack says it was for (a populated file mapping, the object's file on tmpfs). perf's own work on the stack
  (its events' output, its mmap records) and the stage clock's (its marks' `getrusage` and `/proc/self/status`, its
  report) are set apart wherever they are; so is the census patch's report buffer's `munmap`.
- **with its fault:** the minor-fault event is written as `handle_mm_fault` ends, so a sample on its way through it
  belongs to its thread's next fault event, and a sample past it to the last one. Each fault's address names its owner
  (section 3).

One of the 24 compiles found the host busy as it started (another session's work) and took base pages throughout, as
`arena_page_policy` gives a busy host (#672): 61,383 faults, 191 M kernel cycles of its own, 21.2 M of them the
teardown. It is reduced apart (`tables/cpuwide-busy-*`); the tables are the other 23's.

The recorded compile's own kernel cycles are 90.53 M (perf's own 3.80 M and the stage clock's 2.85 M set apart): the
recording costs the rest of the kernel about 4.6% more. The rows' cycles a token are the recorded rows scaled by
86.51 / 90.53 (`tables/rows.tsv`, made by `scripts/tools/krows.c`).

### By cause

| row | recorded cycles a compile | share | cycles a token |
| --- | ---: | ---: | ---: |
| page faults (by owner in section 3) | 74.12 M | 81.87% | 98.90 |
| the exit: the address space's teardown, in the exit helper | 5.10 M | 5.63% | 6.80 |
| the arenas' system calls: `munmap` | 2.45 M | 2.70% | 3.27 |
| the source's read: the include search | 1.96 M | 2.17% | 2.62 |
| the source's read: its mapping, populated | 1.64 M | 1.82% | 2.19 |
| the object's write | 1.25 M | 1.38% | 1.67 |
| timer interrupts | 1.10 M | 1.21% | 1.46 |
| the arenas' system calls: `madvise` | 0.67 M | 0.73% | 0.89 |
| the process's start, exec to the stage clock's start | 0.62 M | 0.69% | 0.83 |
| the arenas' system calls: `mprotect` | 0.61 M | 0.67% | 0.81 |
| the arenas' system calls: `mmap` | 0.48 M | 0.53% | 0.64 |
| the exit: the rest | 0.46 M | 0.51% | 0.62 |
| the arenas' system calls: `brk` | 0.01 M | 0.01% | 0.02 |
| in no named row | 0.06 M | 0.07% | 0.08 |
| **the compile's own** | **90.53 M** | **100%** | **120.80** |

In no named row: samples with no kernel frame that no fault just before explains (0.022 M), system calls no frame
names (0.017 M), and the rest (0.021 M). Outside the compile, per compile: the harness's own commands 1.24 M, the
parent's wait 0.27 M, other tasks on CPU 2 0.15 M, the parent's fork 0.03 M.

### The faults by kind

By the page each fault mapped and its mapping (`tables/cpuwide-fault-kinds.tsv`, where a fault some sample fell in
also has its handler's kind; a write over the zero page, `do_wp_page` or `do_huge_pmd_wp_page`, is 14 of the 4 KB
faults and 5 of the 2 MB ones):

| kind | faults | MB | cycles a compile | a fault | a MB |
| --- | ---: | ---: | ---: | ---: | ---: |
| a fresh 2 MB page | 139 | 278.0 | 55.01 M | 396 K | 198 K |
| a fresh 4 KB page | 6,739 | 26.3 | 17.42 M | 2,585 | 662 K |
| the executable's file pages (`do_read_fault`, `do_cow_fault`) | 196 | 0.8 | 2.14 M | 10.9 K | |

A 2 MB fault is 95.6% clearing (`clear_page_erms` under `folio_zero_user`), and its cost a megabyte is within a
seventh of item 3's. A fresh 4 KB page costs 3.3 times as much a megabyte. A fault of the executable's text maps up
to 16 of its pages (fault-around) for 10.9 K cycles, four times what the same fault costs item 3 with the page cache's
structures warm.

### By stage

`tables/cpuwide-stages.tsv`, the faults' rows with `tables/cpuwide-fault-mappings.tsv`'s counts (recorded cycles a
compile; the stages under 0.3 M left out):

| stage | faults' cycles | faults | MB first touched | system calls | other |
| --- | ---: | ---: | ---: | ---: | ---: |
| start | 0.41 M | 79 | 0.3 | 0.17 M | 0.03 M |
| setup | 0.79 M | 78 | 2.3 | 0.23 M | |
| preprocess | 7.76 M | 868 | 29.3 | 3.76 M | 0.10 M |
| parse | 17.50 M | 995 | 79.7 | 0.28 M | 0.08 M |
| check-input | 34.71 M | 4,369 | 126.9 | 2.23 M | 0.45 M |
| check-expressions | 5.56 M | 63 | 34.2 | 0.27 M | 0.08 M |
| check-declarations | 0.39 M | 4 | 2.0 | | |
| static-data | 0.37 M | 1 | 2.0 | | |
| check-program | 3.44 M | 24 | 16.1 | 0.40 M | 0.22 M |
| select | 0.40 M | 3 | 2.0 | 0.33 M | |
| lower | 1.02 M | 154 | 2.6 | 0.11 M | 0.12 M |
| tier0 | 1.14 M | 215 | 2.8 | 0.05 M | |
| emit-setup | 0.40 M | 5 | 2.0 | 0.09 M | |
| encode | 0.38 M | 7 | 2.0 | | |
| object-write | | | | 1.06 M | |
| exit | 0.04 M | 7 | 0.0 | 0.41 M | 5.10 M, the teardown |

The preprocessor's system calls are the source's read and the include search; `object-write` is the object's; the
exit's leave out the census patch's report buffer (0.34 M).

### The system calls

`scripts/counts.sh`: `strace -f -c` of one compile by `src` (no `--time-stages`; `raw/results/counts/strace-c.txt`, its
times strace's own) and the files it looked for (`strace-calls.txt`):

| call | calls | failed | for | recorded cycles a compile |
| --- | ---: | ---: | --- | ---: |
| `openat` | 374 | 207 | the include search's probes and opens, the object | 1.30 M |
| `close` | 167 | | | 0.20 M |
| `fstat` | 162 | | | 0.14 M |
| `pread64` | 148 | | the headers under the cache's read limit, into the file cache's arenas | 0.23 M |
| `mprotect` | 90 | | the arenas' commits | 0.61 M |
| `mmap` | 52 | | the compiler's 44 (section 3's 46 less the census patch's 2) and waitall's | 2.13 M |
| `madvise` | 32 | | huge pages advised; discards | 0.67 M |
| `newfstatat` | 11 | 2 | | 0.03 M |
| `munmap` | 7 | | arenas released before the exit (the reader's sparse columns, the program's controls, the preprocessor's output, the emission's columns, Tier 0's inline cache, the object's two) | 2.45 M |
| `getdents64` | 7 | | the include search's listings | 0.14 M |
| `brk` | 6 | | | 0.01 M |
| `pwrite64` | 1 | | the object, 2,197,000 bytes | 1.19 M |
| `clone3` | 1 | | the exit helper | 0.15 M |
| `close_range` | 1 | | the exit helper's start | |
| `execve` and the rest | 50 | 2 | the start, and waitall's own | |

The `mmap` row holds the source's populated mapping (1.64 M: 2,321 pages of `sqlite3.c` and 19 of 9 headers, 703
cycles a page, against item 3's 256 for the same file's pages with their structures warm; two thirds of its samples
are in `next_uptodate_folio`, walking the page cache) and the reservations (0.48 M). `munmap`'s cycles are the pages
it frees: the reader's sparse columns' 4,169 base pages are most of them. The object's file is opened without
`O_TRUNC`, written over the last object's pages with `pwrite` (2,227 cycles a page, scaled) and cut with `ftruncate`;
item 3's rows truncate first.

### The start and the exit

| the start: exec to the stage clock's start | recorded cycles |
| --- | ---: |
| 79 faults, 40 of them the executable's file pages | 0.41 M |
| `execve` (its part after the old image), `readlinkat`, `read`, `openat`, `madvise` | 0.17 M |
| the forked image's teardown in the exec | 0.04 M |
| **all** | **0.62 M** |

| the exit: the stage clock's last lap to the helper's end | recorded cycles |
| --- | ---: |
| the address space's teardown (`exit_mmap`, in the helper) | 5.10 M |
| `clone3` (the helper), `exit_group`, `exit`, `prctl`, `read` | 0.40 M |
| the rest | 0.06 M |
| **all** | **5.56 M** |

The start is 0.83 cycles a token and the exit without its teardown 0.62. The teardown frees what is mapped at the
end, most of it in huge pages, with its page tables and areas.

## 3. Fresh memory by owner (item 2)

### Whose pages

`scripts/maps.sh` traces the compile's mappings with their stacks (`strace -f -k`, `raw/results/maps/strace.txt`);
`scripts/tools/mapnames.c` names each of the compiler's 46 `mmap` calls by its first frame that is no allocator's, and
`scripts/label.sh` labels it by the source line its owner's stack reaches (`llvm-symbolizer`; `scripts/sites.txt`,
`tables/labels.txt`). The compiles run without address-space randomization and map the same addresses in the same
order, so kcensus times each reservation by its own mapping record in a recording (the first that starts where it
does: adjacent reservations merge into one area in the records) and gives each fault the latest reservation that
covers its address; the executable's segments, `.bss`, the stack and the heap by their mapping records. A first touch
inside a large `memset` or `memmove` is its caller's: `scripts/memsets.sh` records, under gdb on the same layout,
every call of 64 KB or more with its destination and caller (`raw/results/memsets/memsets.txt`, 102 calls). A DWARF
unwinding of every fault (`scripts/faults.sh`) unwound 101 of 7,050: the compiler's large frames leave the page at
the stack pointer untouched, which perf can't copy.

**Is it read again:** `scripts/reads.sh` records IBS op samples (12 compiles, one op in 400,009 + 2n dispatched, user
mode), each with its data address and whether it loaded or stored; a sample stands for its period's ops. "After" is
the stages after the last stage that first touches the owner (the emission's stages, which run a function at a time in
turn, as one). `scripts/tools/kowners.c` joins them (`tables/owners.tsv`).

| owner | its source line | MB | faults | cycles | a MB | first touched in | loads there, after | read until |
| --- | --- | ---: | ---: | ---: | ---: | --- | ---: | --- |
| the driver's scratch | `c_checker_driver.c:13772` | 96.1 | 64 | 20.14 M | 210 K | parse 64.1, check-input 30.0, check-program 2.0 | 28.1 M, 20.1 M | object-build |
| the driver's arena | `c_checker_driver.c:13771` | 80.0 | 41 | 16.87 M | 211 K | check-input 80.0 | 4.8 M, 12.6 M | tier0 |
| the reader's sparse columns | `c_check_input.c:17503` | 16.3 | 4,169 | 10.46 M | 642 K | check-input | 4.3 M, none sampled | check-input |
| the driver's output arena | `c_checker_driver.c:13773` | 48.1 | 40 | 8.11 M | 169 K | check-expressions 34.1, check-program 8.0, three 2.0 | 5.2 M, 3.1 M | publish-data |
| the parser's columns | `c_parser_impl.c:10926` | 15.7 | 945 | 4.14 M | 265 K | parse | 0.8 M, 11.2 M | tier0 |
| the file cache's arenas (the lexer's tokens) | `c_preprocessor.c:4036` | 15.4 | 368 | 3.80 M | 246 K | preprocess | 1.5 M, none | check-input |
| the preprocessor's output tokens | `c_preprocessor_impl.c:13737` | 12.2 | 70 | 2.59 M | 212 K | preprocess | 0.1 M, 0.3 M | check-input |
| the executable's text | | 0.5 | 122 | 1.30 M | | throughout | | |
| the program's controls | `c_check_program.c:5842` | 6.0 | 7 | 1.25 M | 208 K | check-program | 0.6 M, none | check-program |
| the object's output | `c_checker_driver.c:10054` | 4.0 | 14 | 0.77 M | 191 K | lower, tier0 | 2.3 M, 0.8 M | object-build |
| the preprocessor's tables | `c_preprocessor_impl.c:13790` | 0.9 | 225 | 0.72 M | 816 K | preprocess | 5.8 M, 0.5 M | check-input |
| the thread's scratch | `c_preprocessor_impl.c:13527` | 1.0 | 245 | 0.70 M | 727 K | preprocess 0.6, tier0 0.4 | 2.4 M, 0.2 M | object-build |
| the executable's read-only data | | 0.2 | 45 | 0.51 M | | throughout | | |
| the intern table | `c_intern.c:1003` | 2.1 | 33 | 0.48 M | 225 K | setup | 0.7 M, 0.5 M | check-program |
| the object's bytes | `c_checker_driver.c:10055` | 2.1 | 17 | 0.44 M | 213 K | tier0 | none sampled | |
| the type table | `c_checker_driver.c:12292` | 0.4 | 103 | 0.38 M | 940 K | type-table, check-input | 6.7 M, 1.1 M | publish-data |
| Tier 0's inline cache | `c_check_tier0_inline.c:50` | 2.0 | 1 | 0.37 M | 187 K | tier0 | none sampled | |
| the emission's columns and window | `c_check_program_emit.c:3842`, `:2696` | 0.9 | 209 | 0.58 M | | lower, tier0 | 7.1 M, 0.1 M | tier0 |
| the executable's data, `.bss`, stack, heap | | 0.4 | 96 | 0.55 M | | | | |
| 13 more owners | | 0.2 | 93 | 0.34 M | | | | |
| before the exec (the forked image) | | 0.1 | 24 | 0.06 M | | | | |
| the census patch's own | | 0.6 | 143 | | | | | |
| **all** | | **305.1** | **7,074** | **74.57 M** | | | | |

MB here are 2^20 bytes. The faults' cycles are 74.57 M where section 2's row of page faults has 74.12 M: section 2
counts the start's and the exit's faults (0.45 M) in their own rows.

- **Every fault has an owner, and they are the faults counted.** 7,074 a recorded compile; less the census patch's
  143 (its laps' log and report) and the 24 of the forked image before the exec, 6,907 against the 6,902 the
  unrecorded compile's own counter counts from its exec (section 1), 0.07% apart.
- **305 MB are first touched for a 231 MB peak**: the driver's scratch is discarded past the reader and touched again,
  and seven arenas are released before the exit.
- **The three driver arenas are 73% of the bytes and 60% of the faults' cycles.** The scratch is the parser's arrays
  (64 MB in parse: `parse_typedefs` 14 MB, `parse_vector_buffers_reserve` 10, `parse_brackets_avx512` 8, and the
  other kernels') and the reader's (30 MB in check-input, 16 of them `check_input_run`'s `memset`s); the arena is the
  reader's output (`check_input_expression_flush` 26 MB, `check_input_run`'s `memset` 10 MB); the output arena is the
  graph (`check_graph_run` 34 MB in check-expressions). `tables/cpuwide-fault-touchers.tsv` has every owner's
  first-touching functions.
- **What #1701 names is still where the memory is**: the reader's scratch at its end, the graph's room (34 MB, first
  touched by the graph run), the reader's output, the parser's token and tree columns (now 15.7 MB) and the
  preprocessor's output (12.2 MB). #628's outcome lists #1167's attributes column and declaration bits among its
  changes; the census doesn't see them apart from the driver arena's pages.
- **The reader's sparse columns cost the most a megabyte:** their arena is base pages throughout
  (`check_input_sparse_arena`), so its 16.3 MB come a 4 KB page at a time, 4,169 faults at 642 K cycles a MB, three
  times a huge page's, with no sampled load after the reader. The arena is released before the exit, and the release
  is most of the 2.45 M of `munmap`.
- **Read again, by IBS:** the parser's columns (11.2 M loads after parse, until Tier 0), the driver's arena and
  scratch (12.6 M and 20.1 M, until Tier 0 and the object), the output arena, the type table and the intern table are
  read in later stages; the reader's sparse columns, the file cache's tokens and the program's controls show no
  sampled load after the stages that write them. A sample stands for 400,009 ops, so "none" is fewer than about a
  million loads, not none.

## 4. What a fresh page costs (item 3)

`scripts/tools/pagecost.c`, `scripts/pagecost.sh` and `scripts/counts.sh`: each case in a fresh mapping or file,
measured on CPU 2 by its own counters (kernel and user cycles, faults), its set-up and clean-up outside the count
(but in the teardown cases); 9 repetitions, medians; anonymous cases of 256 MB, the file cases on the corpus's
`sqlite3.c` (9,507,037 bytes, 2,321 pages) and copies of it on tmpfs and btrfs (`raw/results/pagecost/`,
`raw/results/counts/pagecost-corpus.tsv`).

| how a page is taken | kernel cycles a 4 KB page | all cycles a 4 KB page | kernel cycles a MB |
| --- | ---: | ---: | ---: |
| an anonymous 4 KB page, first written | 2,252 | 2,786 | 576 K |
| … 16 MB at a time instead of 256 MB | 1,293 | 1,906 | 331 K |
| … first read (the zero page) | 458 | 1,143 | 117 K |
| … written after a read | 2,603 | 3,122 | 666 K |
| … under `MAP_POPULATE`, then written | 1,925 | 1,964 | 493 K |
| … under `MADV_POPULATE_WRITE`, then written | 2,075 | 2,115 | 531 K |
| an anonymous 2 MB page, first written (461 K a page) | 900 | 901 | 230 K |
| … 16 MB at a time | 152 | 153 | 39 K |
| … first read (the huge zero page) | 1.5 | 2.8 | 0.4 K |
| … under `MADV_POPULATE_WRITE` | 901 | 901 | 231 K |
| a file's page, mapped and read with fault-around (16 pages a fault) | 179 | 354 | 46 K |
| … the same page mapped alone (one page a fault), less the `mmap` and `munmap`, on tmpfs | 2,513 | | |
| … mapped with `MAP_POPULATE` (the compiler's way with a source) | 256 | 276 | 66 K |
| … read with `pread` into fresh huge pages | 598 | 599 | 153 K |
| … read with `pread` into pages already written | 410 | 410 | 105 K |
| a page written to a new file on tmpfs (`pwrite`, then `close`) | 1,448 | 1,449 | 371 K |
| … over the last file (`O_TRUNC`), as a compile's `-o` | 1,853 | 1,853 | 474 K |
| … a new file on btrfs | 2,458 | 2,458 | 629 K |
| … over the last file on btrfs | 5,937 | 5,937 | 1,520 K |
| a written 4 KB page unmapped | 409 | 409 | 105 K |
| a written 2 MB page unmapped | 21 | 21 | 5.4 K |
| a written 4 KB page discarded (`MADV_DONTNEED`) | 406 | 406 | 104 K |

The file rows are the corpus's own `sqlite3.c`, as the compiles find it, but the page mapped alone (copies on tmpfs
and btrfs: 2,513 and 2,030); a fresh copy on tmpfs costs the same (256 populated, 178 with fault-around). The compile
pays more for what it maps and faults in, because there the page cache's structures are cold (section 2: the source
703 cycles a page, the executable's text 10.9 K a fault, against 2,839 here).

## 5. The floor (item 4)

What a compile still takes from the kernel with every arena reused or bounded by a window (#2536). The tables that
outlive a window are an estimate: the intern table (2.1 MB first touched today), the type table with its index
(0.5 MB), the declarations' fact words of #2850's step 1 (18,260 lines, 4,740 rows and 2,229 slots: 0.95 MB) and the
object's code and data until written (2.2 MB), 5.75 MB; 3.55 MB if the object is written as it is made. A window's
working set is taken at 1 MB, once. Cycles a token, at item 3's costs and at the compile's own (section 2's, scaled to
an unrecorded compile: 671 cycles a source page, 2,227 an object page, 633 K a MB of 4 KB pages):

| part | MB | at item 3's costs | at the compile's own |
| --- | ---: | ---: | ---: |
| the source's mapping, populated (2,340 pages) | 9.1 | 0.84 | 2.19 |
| the object's write, over the last object on tmpfs (537 pages) | 2.1 | 1.39 | 1.67 |
| the tables that outlive a window, and a window's working set | 4.55 to 6.75 | 1.93 to 2.57: 3 or 4 whole 2 MB pages | 4.02 to 5.96: 4 KB pages |
| the stack | 0.15 | 0.12 | 0.23 |
| the start, exec to the stage clock's start | | 0.83 | 0.83 |
| the exit, but its teardown | | 0.62 | 0.62 |
| the teardown of the tables, the window and the stack | | 0.07 to 0.08 | 0.69 to 1.01 |
| **the floor** | | **5.79 to 6.45** | **10.25 to 12.51** |

The low ends have the object written as it is made; the high ends hold it. At item 3's costs every table and the
window are packed into whole huge pages, cleared at item 3's rate; at the compile's own they are in base pages, as the
reader's sparse columns are today, and the teardown at item 3's 409 cycles a page.

**Beside the floor, the kernel's time that no arena or window removes** (at the compile's own costs, cycles a token):

| part | cycles a token |
| --- | ---: |
| the include search: 374 opens (207 probes that fail), 167 closes, 162 `fstat`s, 148 `pread`s, 7 directory listings | 2.62 |
| the executable's own pages after its start: 177 faults of its text, read-only data and data | 2.51 |
| the arenas' reservations and commits: 46 `mmap`s and 90 `mprotect`s today | up to 1.46 |
| timer ticks, at the 1 GB/s target's 9.5 ms (1.46 at today's 122 ms) | 0.11 |
| **all** | **5.2 to 6.7** |

So the kernel's row, which the budget gives 6 cycles a token, is about 11 at the least on this input (the floor's low
end and the parts beside it) and 15 to 19 at the costs the compile pays today, where it is 121.

## 6. Against the gate

The gate as the claim restated it ([the claim](https://github.com/buster14a/buster/issues/2873#issuecomment-6913963879)):

- **95% of the kernel's cycles are in a row of item 1: met.** 99.93% of the compile's own kernel cycles are in a named
  row; 0.07% in none.
- **Item 2's rows sum to the faults counted: met.** Every fault of a recorded compile has an owner; less the census
  patch's own and the forked image's before the exec, 6,907 against the 6,902 an unrecorded compile's counter counts.
- **Item 4's floor is at or under 6 cycles a token, the start and exit included: met only at the best case.** 5.79 at
  item 3's costs with every table packed in huge pages and the object written as it is made, 6.45 with the object
  held; 10.3 to 12.5 at the costs the compile pays.

**What refutes step 5's allocation**, by the issue's two conditions:

- **"A large part of the kernel's time is neither fresh memory nor the fixed parts": yes.** The include search, the
  executable's own pages after the start and the arenas' reservations and commits are 5.2 to 6.7 cycles a token, about
  the whole budget's 6 on their own. Today they and the timer ticks are 8.1 of the 121.
- **"The floor is above 6 cycles a token": at the costs the compile pays, yes.** The source's mapping alone is 2.2
  cycles a token as the compile pays it, the object's write 1.7, the start and the exit without its teardown 1.4:
  5.3 before any table. The 6 holds only with item 3's warm-cache costs, every table in huge pages and the object
  written as it is made.

## Limits

- **One host, one day, one revision, one input.** `sqlite3.c` reads 157 headers and is 13.3 bytes a token; a unit that includes more pays more for the include search, a smaller unit more a token for every fixed part.
- **The recording costs the kernel about 4.6% more** than an unrecorded compile; the rows are scaled to the unrecorded
  86.5 M as a whole, not each by its own.
- **The census tree's patch** adds 143 faults and a report buffer, set apart, and its laps' log (0.1 MB) is among the
  owners' pages until set apart.
- **Faults' cycles are sampled**, at a period of 100,003 cycles: a 4 KB fault is about 2,400 cycles, so a single fault's
  cycles are not known, only an owner's or a kind's over 23 compiles.
- **IBS's loads are sampled** at one op in 400,009: an owner's "none sampled" is fewer than about a million loads.
- **The memsets under gdb** name the callers of the 102 calls of 64 KB or more; a first touch inside a smaller `memset`
  is the C library's in `tables/cpuwide-fault-touchers.tsv`.
- **The floor's tables are an estimate** from today's owners and #2850's step 1, not a design's measurement.
- **Item 3's costs are the kernel's with warm caches** for its page cache's structures; a compile pays two to four
  times as much for what it maps (section 4).

## Files

- `raw/env.txt`: the host, the tools and every identity; `raw/holds.txt`: each hold's line; `raw/build.log`,
  `raw/build-census.log`: the builds.
- `raw/results/totals/`, `cputotals/`: section 1. `cpuwide/`: the recordings (trimmed), their reports with the laps
  (`stages-N.txt`), and their hosts. `kernel/`: the same compiles recorded by task rather than by CPU, which miss the
  teardown (`tables/task-*`: 85.5 M of the compile's own, 7,074 faults). `maps/`: the strace and the owners'
  symbolization. `memsets/`, `reads/`, `faults/`, `counts/`, `pagecost/`, `probe.txt`: as above.
- `scripts/`: one script a run, each under `scripts/lock.sh`; `scripts/tables.sh` makes every table from the raw
  results with `scripts/tools/`'s reducers; `scripts/stage-laps.patch`, the census tree's patch.
- `scripts/tools/procbench.c` is the whole-build record's (`whole-build-672-2026-11-12`), unchanged.
- `tables/`: `rows.tsv` (section 2's rows), `owners.tsv` (section 3), and kcensus's tables of the CPU-wide recordings
  (`cpuwide-*`), the busy compile's (`cpuwide-busy-*`), the task recordings' (`task-*`) and IBS's (`reads-ops.tsv`).
