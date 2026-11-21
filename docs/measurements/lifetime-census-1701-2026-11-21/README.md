# #1701's lifetime census: which arena bytes a later stage still needs (2026-11-21)

Step 1 of [#1701's design](https://github.com/buster14a/buster/issues/1701#issuecomment-6720365474), under
[the claim](https://github.com/buster14a/buster/issues/1701#issuecomment-7067797811): for `-c sqlite3.c`, which of the
compile's arena memory is resident at each stage mark, and whether a later stage reads it, only writes it, or never
touches it. No compile change; the patch is an experiment and not for main.

## How

- **Source:** buster `bcb79bd638171eca64c3ab690a6d9a46cb353625` (main, 21 November) with [`census.patch`](census.patch)
  (`lane.c`, `c_check_clock.c`). Release build with CI's toolchain (LLVM 23.1.4), `-march=native`; executable SHA-256
  `7fc30862fb5fd655242dad71f69549003b22d8fc8ca0896e1cb625c2f10e74b7`.
- **Host:** a claude.ai cloud container (Intel Xeon, AVX-512), Linux 6.18.44, transparent huge pages `madvise`. What
  each stage pushes and touches doesn't depend on the host, but what is resident does: the 9700X's THP `always` makes
  a touched 2 MB stretch resident whole, so its figures read higher. No 9700X time was used.
- **Workload:** the frozen corpus's `sqlite3.c` (`0a409f16…`) with the 9700X job's `-D` options, `--lanes 1 -c`, and
  Ubuntu's glibc headers: 710,061 tokens where the 9700X's Arch headers give 716,136. The object is the same bytes with
  and without the census.
- **What the patch does** (`BUSTER_MEMORY_CENSUS=PATH`):
  - Every owned arena is followed in 64 KB granules over its pushed extent.
  - At each `check_clock_mark`, `mincore` counts each granule's resident pages.
  - From the `parse` mark to the `object-build` mark, each arena's whole extent is `PROT_NONE`. The `SIGSEGV` handler
    records each granule's first read and first write in each stage, by the fault's error code, and gives the granule
    back.
  - Pushes of 64 KB or more are recorded with their call sites, to name granules' owners.
  - `/proc/self/smaps` is copied at the `check-input` and `static-data` marks.
- **Caveats.**
  - A read-modify-write faults as a write, and only the first access to a granule in each stage is seen, so "read
    later" is a lower bound and "touched later" an upper bound.
  - `mincore` counts a page mapped to the zero page as resident; `smaps` doesn't. About 3 MB at the peak is that
    (170.2 MB of granules against 167.3 MB of arena mappings).
  - Liveness is by stage mark. A stage's own internal peak isn't seen.
  - The census itself raises the peak: the same executable without `BUSTER_MEMORY_CENSUS` peaks at 210,764 KB
    (`--time-stages`' `peak-rss-kb`, three runs), with it at 221,072 KB (two runs), 10.3 MB more (4.9%). The arena
    figures below are the census run's.
  - MB are 10^6 bytes throughout.

Reproduce: `git apply census.patch`, `./build.sh --config Release`, then
`BUSTER_MEMORY_CENSUS=$PWD/census.tsv build/compiler --lanes 1 -c <sqlite options> sqlite3.c -o unit.o`;
`python3 scripts/bounds.py census.tsv` and `python3 scripts/census.py census.tsv build/compiler 6,9`
([`census-bounds.txt`](census-bounds.txt), [`census-owners.txt`](census-owners.txt); raw tables in [`raw/`](raw)).

## Coverage

At the RSS peak (the `static-data` mark), `smaps` puts 226.4 MB resident:

| | MB |
| --- | ---: |
| the arenas | 167.3 |
| other anonymous memory (`.bss`, stack, heap) | 10.8 |
| the executable's file pages | 38.5 |
| `sqlite3.c`'s mapping | 9.5 |
| the headers' mappings | 0.3 |

- **The gate as written is missed:** it asked for 90% of resident bytes, and the arenas hold 74% (72% to 75% from the
  reader's end on).
- **Restated for fresh memory, it is met:** the arenas hold 94% of the anonymous memory (167.3 of 178.1 MB), the memory
  the kernel clears. The file-backed rest costs mapping, not clearing.

## Results

Arena bytes at each mark ([`census-bounds.txt`](census-bounds.txt)), MB:

| mark | resident | touched later | read later | only written later | never touched later |
| --- | ---: | ---: | ---: | ---: | ---: |
| parse | 48.2 | 42.0 | 24.0 | 17.9 | 6.3 |
| check-input | 151.7 | 91.3 | 62.9 | 28.4 | 60.4 |
| check-expressions | 167.9 | 113.4 | 85.0 | 28.4 | 54.5 |
| static-data (the peak) | 170.2 | 114.7 | 86.3 | 28.4 | 55.4 |
| check-program | 159.5 | 86.4 | 73.4 | 12.9 | 73.1 |
| lower (first window) | 155.6 | 78.4 | 73.4 | 5.1 | 77.1 |

- **Pages first touched in the arenas: 207.7 MB** (each granule's largest residency, summed). Their peak at a mark is
  170.2 MB. A later stage touches at most 114.7 MB and reads at most 86.3 MB of it at any mark.
- **The most a lifetime plan can save without windows is about 93 to 121 MB:** the arenas holding only what a later
  stage needs, at 86 to 115 MB instead of the 208 MB they touch. At #528's measured price, 25.7 M kernel cycles for
  115,280 KB of peak (about 0.22 M a megabyte), that is 21 to 27 M cycles: **29 to 38 cycles a token, 3.2 to 4.2% of
  the 9700X's 906**, main `325883abf`'s, the baseline of the newest locked record
  (`window-compile-2850-2026-11-21/46934f02a`).
- **At the peak, 55.4 MB is never touched again** (1.9% at the same price), and 83.8 MB is never read again (2.9%).
  That is between the claim's two lines: under 50 MB meant stop, over 100 MB meant go on to the design's step 2.
- **What the peak needs is live unit-wide data.** The 115 MB touched later is the graph's columns (19.4 MB, read up
  to the lowering), the parser's and preprocessor's tables (18.7 MB), the graph run's stream columns (10.4 MB and
  3.9 MB, last read by the lowering), the reader's output columns and sparse columns. Only windows (#2536) or smaller
  records (#2850) shrink that.

### Resident at the peak and never touched again, by owner

From [`census-owners.txt`](census-owners.txt), `static-data` mark, the largest. "Popped" is scratch given back with
its pages still resident; its line is in `c_check_input.c` at `bcb79bd`.

| owner | resident MB | never touched again MB |
| --- | ---: | ---: |
| popped: the reader's `traversal` columns (`c_check_input.c:17337`, 5 × slots × 4 bytes) | 14.2 | 11.3 |
| `arena_reserve_tables`: the preprocessor's and parser's tables | 18.7 | 7.8 |
| popped: `value_next` (`:17347`) | 3.1 | 3.1 |
| `check_const_storage` (`c_check_const_values.c:185`) | 4.1 | 2.9 |
| popped: `tag_completions` (`:17484`) | 2.9 | 2.9 |
| popped: `last_value`, `first_value` (`:17322`, `:17321`) | 5.7 | 5.6 |
| popped: `temporaries` (`:17503`), `sizes` (`:17344`) | 5.6 | 5.6 |
| `check_input_intrinsic_initialize`'s ids (`c_check_intrinsic_input.c:313`), never popped | 2.8 | 2.8 |
| `check_graph_column` (`c_checker.c:1109`) | 19.4 | 2.4 |

The reader's popped scratch is the largest dead family. At the peak 28 MB is only rewritten later (scratch reuse),
while the stages after the reader take about 18 MB of fresh pages (the arenas grow from 152 to 170 MB between the
reader's end and `static-data`).

## What it means

- **The fresh-memory row is mostly live data.** #1701's lifetime work (scratch boundaries, graph sizing, reuse
  policy) can reach about 2 to 4% of `-c sqlite3.c` on the 9700X, not the bulk of the kernel's 110 cycles a token.
  The rest falls with #2536's windows and #2850's smaller records.
- **The cheapest pieces, if anyone takes them:**
  - later stages' pushes taken from the reader's freed scratch instead of fresh arenas, which avoids the 18 MB of
    growth after the reader;
  - the intrinsic ids column, never touched after the reader, not kept;
  - the preprocessor's and parser's tables' dead third released at the parse's end.
  Each is under 1%.
