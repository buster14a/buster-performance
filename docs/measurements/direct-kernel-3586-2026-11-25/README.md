# The direct path's kernel cycles (`c_direct`, buster#3586)

Work of 2026-11-25 for [buster#3586](https://github.com/buster14a/buster/issues/3586): where the kernel's cycles of
the direct path's `-c` go, and what removed some of them. The change is
[buster#3606](https://github.com/buster14a/buster/pull/3606) on main `20f3573e` (`patches/change.patch`).

- **Host:** `benchpress` (Ryzen 7 9700X, Linux 6.18.50), every run under `~/buster-fast-bench/exclusive.sh`, CPU 2,
  objects on `/dev/shm`. Transparent huge pages `always`, defrag `madvise`.
- **Builds:** `BUSTER_HOST_ARCH=znver5 ./build.sh --config Release` on the host, main and main with each patch
  (`scripts/build-variant.sh`), each followed by `test-direct`.
- **The units:** the frozen corpus's `sqlite3.c` as the earlier direct-path records compile it; a one-function unit
  (`add`), `stdio.h` and a `printf` (`hello`), seven standard headers and a `main` (`six`), musl's `wcwidth.c`.

## Where the kernel's cycles went at main (`scripts/prof.sh`, `results/prof-main`)

`perf record -e cycles:k -g` of 40 compiles of `sqlite3.c`, the compiler's own process (its exit helper's samples are
a few hundredths of a percent: the task's counters stop before its address space is torn down). Inclusive shares:

| | share of the process's kernel cycles |
| --- | ---: |
| huge pages' first touch (`do_huge_pmd_anonymous_page`, 19.3% `clear_page_erms`) | 21.3% |
| `munmap` of the source's and headers' mappings, as each file ends | 14.2% |
| the object's `writev` (a copy into the page cache) | 13.7% |
| RCU's frees in softirq (page tables, VMAs, files) | 7.9% |
| `mmap` of the files (3.0% their `MAP_POPULATE`) | 6.3% |
| `access` and `openat`: the include search's path walks | 7.6% |

One compile made 1,729 system calls (`strace-c.txt`): 614 `access` (401 failed), 216 `openat`, 216 `mmap`, 212
`munmap`, 213 `fstat`, 216 `close`. It opened 155 files 216 times: headers with no guard (glibc's
`<bits/mathcalls-narrow.h>` 13 times, clang's `<stddef.h>` 11) were mapped and unmapped at each include. Each lookup
walked the whole absolute path, ten components in this corpus, and a found file was walked twice (`access`, then
`open`).

## The arenas: 22.4 MB cleared for 8.2 MB written (`scripts/map.sh`, `patches/arena-map.patch`)

A throwaway build records each allocation and, after the compile, reads with `mincore` which 4 KB pages of the arenas
were touched, by allocation and by 2 MB region. With base pages (`results/arena-map-base-pages.txt`) the 32 MiB
arena's bump extent is 22.4 MB and its compile writes 2,007 pages, 8.2 MB, touching all 11 of its 2 MB regions (17 to
475 pages each); with huge pages (`arena-map-huge-pages.txt`) all 22.4 MB are resident, so the kernel clears 22 MB.
The scratch arena writes 23 pages.

The cause is the tables' fixed capacities: 42 tables sized for any accepted unit, each written from its start
(`sqlite3.c`: `out_data` 659 of 1,025 pages, `.text` 308 of 641, the symbols 94 of 769, `macro_toks` 33 of 257).
Simulated on these readings, no order of the tables touches fewer than 9 regions (20,000 random orders), and moving
the long-tailed tables to mappings of their own touches 10 to 12. With base pages for the regions under ~120 pages (a
fault each at about 1,500 cycles against a huge page's ~180,000), this layout would save about 0.4 M cycles by that
estimate. The clearing shrinks only with tables sized by what a unit writes, growing when full; not done here.

## What changed (`patches/change.patch`)

- **A file's mapping is kept for the compile** (`FastFileRecord` in the persistent arena, found from the guard table's
  entry by its path). A header included again is pushed from that mapping with no system call, and no file is unmapped
  as it ends. `fast_pp_release_files` unmaps them, and closes the directories' descriptors, when the compile bails out
  (the full pipeline runs next in the process) or its caller asks for its memory back (`release`); a terminal command
  leaves them to its exit, as it leaves its arenas, which the exit helper (#1444) tears down.
- **The include search looks up a name from its directory's descriptor** (`open(dir, O_PATH | O_DIRECTORY)`, by the
  first search of each directory): one `openat(dirfd, name)` walks the name alone, and its descriptor is the one the
  file is mapped from, where `access` and `open` each walked the whole path. `__has_include` asks with `faccessat`.
- `fast_pp_init` still clears `FastPP` (`patches/files-no-memset.patch` left it to the arena's zero pages: faults
  rose, `hello` 188 to 216, since the hashed tables are then read before they are written, two faults a page). The
  record holds the mapping, not the guard entry, whose 16 bytes would have been 32 (`files-wide-entries.patch`: 8 more
  pages of `FastPP` cleared by every unit, `add` 156 to 163 faults).

After it a compile of `sqlite3.c` makes 1,051 system calls: 550 `openat` (395 failed), 151 `mmap`, 148 `fstat`, 151
`close`, no `access` or `munmap` (`results/prof-change/strace-c.txt`).

## Result (`scripts/ab.sh`, `results/ab-4-change.txt`)

31 rounds, the builds' order rotating by round, medians. Each run is counted twice: by the process's own counters
(`perf stat` of the command), and by CPU 2's while the record kernel-census-2873-2026-11-16's `waitall` waits for the
command and the exit helper it leaves, so that work moved to the exit is counted (`cpu-k`).

| unit | wall, main | change | kernel cycles, process | change | kernel cycles, CPU 2 | change | faults |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| `add` | 0.30 ms | 0.29 ms | 0.92 M | 0.85 M | 1.84 M | 1.80 M | 156, 155 |
| `hello` | 0.65 ms | 0.58 ms | 1.59 M | 1.20 M | 2.57 M | 2.27 M (-11.5%) | 188, 187 |
| `six` | 1.66 ms | 1.42 ms | 3.26 M | 1.96 M | 4.35 M | 3.18 M (-27.0%) | 289, 285 |
| `wcwidth.c` | 0.39 ms | 0.37 ms | 1.06 M | 0.98 M | 2.04 M | 1.99 M | 183, 185 |
| `sqlite3.c` | 16.64 ms | 16.16 ms (-2.9%) | 10.02 M | 7.81 M (-22%) | 11.62 M | 9.88 M (-15.0%) | 92, 94 |

User cycles move by under 1% either way, and user instructions by +0.03% to +0.26%. Every object is main's. Earlier
holds (`ab-1-keep-files.txt`, 15 rounds) split the two parts on `sqlite3.c` (`keep.patch`, `files.patch`): kept
mappings, with a found file opened once by its whole path, took the CPU's kernel cycles 11.44 M to 10.41 M, and the
directories' descriptors to 9.87 M.

After the change the process's kernel cycles on `sqlite3.c` are 32% huge pages' first touch, 14% the object's
`writev`, 8% `mmap`, 8% `openat`, 8% RCU's frees (`results/prof-change/k-children.txt`).

## Checks

- `test-direct`: 20 of 20 on each build, the new case (`c_direct_test_kept_files`) among them: a header with no guard,
  past a search directory that does not exist, included twice and mapped once by a compile that keeps its arenas, and
  neither mapped nor holding a descriptor after one that releases them or bails out.
- The corpus (`scripts/equiv`, the 7,556 units of buster-performance `direct-speed-2850-2026-11-24`'s list, inputs
  where this host keeps them, plus musl by `-std=gnu99`): main and the change give each unit the same status,
  diagnostics, object and path (`results/equiv`: 1,860 of them the direct path's; `change.tsv` is both builds' rows).
