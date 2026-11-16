# The kernel census on musl, a unit a process and as one command (2026-11-16)

Evidence for [buster#2873](https://github.com/buster14a/buster/issues/2873), the census's second piece. It applies the
same attribution as [`kernel-census-2873-2026-11-16`](../kernel-census-2873-2026-11-16/README.md) (`sqlite3.c`, one
large unit) to many small units, for the design of the kernel row's allocation that the issue says follows from the
census. It counts the compile as it is: no compile changes and no patch (no stage laps).

- **Source:** buster `dbf591b9b65322261376df10c190be685390466a`, main on 16 November and #2876's merge (only
  documentation has changed since `3d0d56ed`). A clean clone was built on the host by `./build.sh --config Release`
  (`raw/build.log`). The executable is byte for byte the census's: SHA-256 `206f4b13…` (`raw/raw-sha256.txt`).
- **Host and runs:** as the census. The 9700X, Linux 6.18.50, transparent huge pages `always`. Every run is one hold of
  the lock (`scripts/lock.sh`, `raw/holds.txt`), with the compiles on CPU 2 and perf on CPU 4. The load and the busiest
  processes before and after each run are in `raw/results/musl/host.txt`.
- **Workload:** the frozen corpus's musl, with the one-core record's selection (the first source of each base name,
  1,336 units) and options (`one-core-design-672-2026-11-12`'s `scripts/musl.sh`; `scripts/musl-common.sh`). That is
  1,464,170 bytes of source and **5,039,639 preprocessed tokens** by each unit's own `--time-stages` count
  (`scripts/musl-tokens.sh`, `raw/results/musl/tokens.tsv`), 3,772 a unit.
- **Two ways to run them** (`scripts/musl-loop.sh`):
  - **A unit a process,** one after another, as a build tool runs them on one core. Each runs under `waitall`, a child
    subreaper that waits for the exit helper.
  - **As one command** on one lane, as in the one-core record's "musl as one command". It pays a process's fixed costs
    once.
  - A third run puts `/usr/bin/true` in each compile's place; it measures the first way's harness.

## In short

- **A unit a process, the kernel takes 1,022 cycles a token,** 3.86 M a unit. That is about as much as the compiles'
  own user time: 5.15 G kernel cycles for the 1,336 units against 5.0 to 5.3 G user cycles (the totals' rounds, less
  the harness).
- **As one command, the kernel takes 212.5 cycles a token,** 1.07 G for all 1,336 units: a fifth as much. The user's
  cycles also differ, 2.91 G against 5.0 to 5.3 G; this census does not attribute them.
- **A unit a process, by cause, in cycles a token:**
  - fresh memory: 313;
  - the address space's teardown: 191, plus 33 more deferred to `ksoftirqd` (RCU freeing of page tables and slabs);
  - the arenas' system calls: 149;
  - the executable's own pages after the start: 123;
  - the start: 99, a third of it the executable's pages;
  - the include search: 64;
  - the rest of the exit: 41;
  - the stack: 19;
  - the object's write: 9;
  - timer ticks: 8.
  - 0.4% is in no named row.
- **As one command, by cause, in cycles a token:**
  - fresh memory: 108;
  - the arena pool's discards between units (`madvise`): 70;
  - the include search: 19.5;
  - the objects' writes: 8.4;
  - timer ticks: 3.8;
  - the process's start, exit and teardown together: 1.4.
- **What a process costs:** a unit as its own process pays 3.05 M kernel cycles more than inside the one command:
  - 2.19 M for the start, the exit and its teardown, the executable's own pages, and the arenas' reservations and
    commits (`mmap`, `mprotect`, `munmap`);
  - 0.59 M for fresh memory: a new process clears its pages again, 1.26 M with its discards against the command's 0.67 M;
  - 0.17 M for the include search;
  - 0.07 M for the stack;
  - 0.03 M for the rest;
  - plus 0.13 M deferred to `ksoftirqd`.
- **The gate's lines:**
  - 99.6% (a unit a process) and 99.3% (as one command) of the compile's kernel cycles are in a named row.
  - Every fault has an owner. The faults a unit after the exec (598.7) match what an unrecorded unit's own counter
    counts (593.5), 0.9% apart.

## 1. Totals

Two scripts count CPU 2 as a whole (`perf stat -C 2`):

- `scripts/musl-totals.sh` runs the three ways in turn, three rounds (`raw/results/musl/totals-*.csv`).
- `scripts/musl-faults.sh` runs two more passes of a unit a process. It counts minor faults beside page faults, and
  reads `/proc/vmstat`'s huge-page counters around each pass (`faults-*.csv`, `faults-vmstat.txt`).

| on CPU 2 | kernel cycles | user cycles | page faults |
| --- | ---: | ---: | ---: |
| a unit a process, the totals' rounds | 6,785 M; 6,978 M; 7,023 M | 5,740 M; 6,003 M; 6,016 M | 1.38 M; 1.94 M; 1.94 M |
| a unit a process, `musl-faults.sh`'s passes | 6,621 M; 6,630 M | | 1.02 M; 1.02 M |
| `true` in each compile's place (the harness) | 1,502 M to 1,513 M | 705 M | 0.30 M |
| as one command | 1,096 M to 1,107 M | 2,907 M to 2,913 M | 0.33 M |

- **The passes are clean.** The page-fault and minor-fault counters agree (1,022,071 both in the first pass). The two
  passes took 6,130 and 6,141 huge pages, 4.6 a unit, with no fallback.
- **The totals' rounds took more faults, with up to 6% more kernel cycles.** A unit that finds the host busy as it
  starts (runnable tasks at least a quarter of the CPUs online; `arena_page_policy`, #672) gives every arena base pages,
  at about twice the faults. In the recording, 15 of the 1,336 units took no huge page, with a median of 1,304 faults
  against 589. At that excess, about 500 units in the first round and nearly all in the other two did. The rounds ran
  a minute after the build, with the one-minute load at 1.55 to 1.93; the recording ran at 1.28 to 1.39. The passes
  and the recording are the reference.
- **The compile's own kernel cycles** come from the recording's split (below) at the passes' 6,625 M: 3.86 M a unit,
  1,022 cycles a token. Taking the harness measured with `true` from the passes instead (6,625 M less 1,507 M, plus
  `true`'s own 0.23 M a process by its task counters) gives 4.06 M a unit, 1,077 a token.

## 2. The kernel's cycles by cause

`scripts/musl-cpuwide.sh` is the census's recording, over a unit a process (`script-0.txt.gz`) and over the one
command (`script-command-1.txt.gz`). It runs `perf record -C 2 -k mono -d --data-page-size` with:

- the kernel's cycles, with kernel call chains, at a period of 100,003 cycles;
- every minor fault, with its address and page size;
- every mapping's record.

Nothing was throttled or lost (`throttle-*.txt`).

`scripts/tools/kcensus.c --units` reads a recording of many compiles:

- a compile starts at its `waitall`'s fork;
- its start runs from its exec to its first reservation of 64 GiB, the driver's first arena, which the stage clock
  precedes;
- its exit is everything after its process's exit record, and its helper.

`scripts/tools/krows.c` builds the rows. A compile without laps has no phase that holds the exit's calls, so krows
places them by name:

- the exit's: the helper's `clone3` and `close_range`, `exit_group`, `exit`;
- the object's: `ftruncate`, `pwrite64`;
- the setup's.

Cycles a token are the recorded rows scaled to the unrecorded runs: the passes' mean for a unit a process (scale
0.966), and the rounds' median for the one command (scale 1.008). The rows are in `tables/musl-rows.tsv` and
`musl-command-rows.tsv`.

| row | a unit a process: recorded cycles a unit | cycles a token | as one command: recorded cycles | cycles a token |
| --- | ---: | ---: | ---: | ---: |
| page faults after the start | 1.777 M | 455.2 | 540.1 M | 108.0 |
| … fresh memory: the arenas and the rest of the anonymous pages | 1.222 M | 313.0 | 537.5 M | 107.5 |
| … the executable's own pages | 0.479 M | 122.8 | 2.3 M | 0.5 |
| … the stack and `[vvar]`, `[heap]` | 0.075 M | 19.2 | 0.3 M | 0.1 |
| the exit: the address space's teardown | 0.746 M | 191.1 | 5.8 M | 1.2 |
| … and its deferred part on `ksoftirqd` (outside the compile's processes) | 0.129 M | 33.0 | | |
| the process's start, exec to the first arena | 0.387 M | 99.2 | 1.0 M | 0.2 |
| … of it, the executable's pages | 0.129 M | 33.0 | 0.5 M | 0.1 |
| the source's read: the include search | 0.249 M | 63.7 | 97.4 M | 19.5 |
| the arenas' system calls: `mprotect`, `munmap`, `mmap`, `madvise`, `brk` | 0.580 M | 148.8 | 350.0 M | 70.0 |
| … of it `madvise`, the pool's discards between units | 0.081 M | 20.8 | 348.1 M | 69.6 |
| the exit: the rest (the helper's start, `exit_group`, `exit`) | 0.162 M | 41.5 | 0.4 M | 0.1 |
| the object's write | 0.033 M | 8.6 | 41.9 M | 8.4 |
| timer interrupts | 0.032 M | 8.2 | 19.1 M | 3.8 |
| the source's mapping, the setup's calls, diagnostics | 0.008 M | 2.3 | 0.2 M | 0.0 |
| in no named row | 0.015 M | 3.9 | 6.9 M | 1.4 |
| **the compile's own** | **3.991 M** | **1,022.4** | **1,062.9 M** | **212.5** |

The faults' parts are `tables/musl-fault-mappings.tsv.gz`'s, by owner and phase. The executable's pages that the exit
touches (0.006 M a unit) are in the exit's rest. Outside the compile, a unit a process:

- `waitall` and the loop's `bash`: 1.0 M a unit;
- `ksoftirqd/2`: 0.13 M a unit, in `tlb_remove_table_rcu` and `rcu_free_sheaf`, which free the teardown's page tables
  and slabs after a grace period;
- the parent's wait and fork.

**The faults by kind,** a unit a process (`tables/musl-fault-kinds.tsv`):

- **Fresh 2 MB pages:** 4.6 a unit at 97 K cycles each, and 0.2 more written after a read, at 164 K. The census's
  `sqlite3.c` paid 395 K. A small process gets back huge pages that are still warm in the caches, as the page-cost
  program's 16 MB case did (78 K).
- **Fresh 4 KB pages:** 452 a unit, at 1,869 cycles each.
- **The executable's file pages:** 166 faults a unit, at about 3.5 K cycles each. A fault that finds a page in the
  page cache maps the pages around it too, and its cost lands on that first fault. A unit's process walks the same page
  cache as the one before it, and pays a third of `sqlite3.c`'s 10.9 K.

## 3. Fresh memory by owner

A unit's reservations come in the same order as `sqlite3.c`'s: the first 21 in 1,321 of the 1,336 units, and the rest
as far as the 34th in most (`tables/musl-mappings.tsv.gz`). kcensus names each reservation by its order (`an arena:
reservation N`). `scripts/reservation-labels.tsv`, the census's labels in its main build's order, names them, through
`scripts/tools/kowners.c`'s relabelling (`tables/musl-owners.tsv`). The owners count every fault, from the start's to
the exit's. A unit a process, per unit:

| owner | faults | MB | cycles |
| --- | ---: | ---: | ---: |
| the executable's text | 97.6 | 0.38 | 0.332 M |
| the driver's arena | 4.7 | 2.81 | 0.153 M |
| the preprocessor's tables | 60.8 | 0.24 | 0.152 M |
| the executable's read-only data | 42.0 | 0.16 | 0.149 M |
| the intern table | 38.5 | 2.12 | 0.144 M |
| the reader's sparse columns | 57.3 | 0.92 | 0.138 M |
| the driver's scratch | 18.4 | 2.06 | 0.124 M |
| the file cache's arenas | 46.3 | 0.18 | 0.101 M |
| the driver's output arena | 11.5 | 1.67 | 0.089 M |
| the executable's data | 25.8 | 0.10 | 0.087 M |
| the stack | 36.0 | 0.14 | 0.075 M |
| the executable's `.bss` | 21.0 | 0.08 | 0.046 M |
| the type table, the parser's columns, the program's controls | 51.5 | 0.66 | 0.119 M |
| before the exec (the forked image) | 24.0 | 0.09 | 0.036 M |
| 31 more owners | 87.4 | 0.37 | 0.220 M |
| **all** | **622.8** | **11.99** | **1.964 M** |

- **The executable's own pages are the largest owner of a unit's faults:** 186 faults and 0.61 M cycles for its text,
  read-only data, data and `.bss`, paid again by every process.
- **Every fault has an owner, and they are the faults counted.** There are 622.8 faults a unit, 598.7 after the exec.
  Each unit's own counter, unrecorded, counts 593.5 (`scripts/musl-taskfaults.sh`, `raw/results/musl/taskfaults.csv`,
  `perf stat` a unit from its exec), 0.9% apart.
- **As one command,** 278,533 faults first touch 1,541 MB, 1.15 MB a unit. The arena pool (#1128) keeps each lane's
  arenas between units, but discards their pages (`MADV_DONTNEED`). Every unit faults its pages in again, and the
  discards cost 70 cycles a token besides. The one command's reservations come in another order and keep their numbers
  (`tables/musl-command-owners.tsv`).

## Limits

- **One host, one day, one revision, one input,** as the census. musl's units are small (3,772 tokens on average) and
  include a few headers each.
- **The recording costs the kernel about 3.5% more** (a unit a process) and 0.8% less (as one command) than the
  unrecorded runs. The rows are scaled as a whole.
- **The harness is the recording's own:** `waitall` and a `bash` loop on CPU 2, outside the compile's rows. A build
  tool's own costs differ.
- **Reservations are named by their order.** The order holds for the first 21 in 1,321 units and as far as the 34th in
  most. The 15 units that took no huge page, and the units with more reservations, are named by order alone.
- **A unit that finds the host busy** takes base pages throughout, as #672 has it. The unrecorded rounds had more of
  them than the recording.

## Files

- `raw/results/musl/`:
  - the totals (`totals-*`) and the passes (`faults-*`);
  - the per-unit counts (`taskfaults.csv`) and the tokens (`tokens.tsv`);
  - the recordings' text (`script-0.txt.gz`, `script-command-1.txt.gz`), with their errors and the host's state.
- `raw/holds.txt`, `raw/build.log`, `raw/raw-sha256.txt`.
- `scripts/`:
  - one script a run (`musl-*.sh`), the loop and the common selection;
  - `scripts/tables.sh`, which makes every table from the raw results;
  - `scripts/tools/`: kcensus with `--units`, kowners with relabelling, krows placing calls by name, and waitall.
- `tables/`:
  - kcensus's tables, a unit a process (`musl-*`) and as one command (`musl-command-*`);
  - the rows (`musl-rows.tsv`, `musl-command-rows.tsv`);
  - the owners (`musl-owners.tsv`, `musl-command-owners.tsv`).
