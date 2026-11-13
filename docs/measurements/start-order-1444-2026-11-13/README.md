# A small compile's start, what was left of #1444 (2026-11-13)

Evidence for buster14a/buster#2687, from buster's branch `claude/wizardly-cori-mu2u95`, part of
[#1444](https://github.com/buster14a/buster/issues/1444): the fixed start of a small compile. It covers what the issue's
12 November hand-off left open:

- **item 3's leftovers:** `.bss` advised late for `check`, `parse` and file-first source commands, and `hello.c`'s
  other huge pages;
- **items 1 and 2's leftovers:** pages read before they are written;
- **item 4:** code layout, the `.text` faults.

## Sources

| build | what it is | patch |
| --- | --- | --- |
| `base` | `main` at `b7a95eedbe16fbd8434654f192f8f7aab76c56e5` (#2636's merge) | none |
| `first` | base and the `.bss` change (the branch's `5901c28b`) | `patches/first.patch` |
| `pop` | `first` and populating the intern table's buckets and the stack (`594f9bbc`, which `15f45baa` reverts) | `patches/pop.patch` |
| `head` | `pop` and the file cache's token columns (`a347e4a9`) | `patches/head.patch` |
| `fs` | base with `-ffunction-sections` alone (the experiment's CMake, no link script) | `patches/layout.patch` |
| `layout` | `fs` linked with the experiment's script and symbol order from `scripts/order-script.py` (`raw/order/`) | `patches/layout.patch` and `raw/order/` |
| `final` | `head` and the start order, as the branch's `1f86f333` (tree `b7a95eedb` + `patches/final.patch`) | `patches/final.patch` |
| `final2` | the pull request's head `15f45baa` (the start order, the `.bss` change and the columns; no populate) | `patches/final2.patch` |

`final.patch` and `final2.patch` are the branch's diffs against base but `docs/compile-time.md`, which the commits
add and no build reads. The patches are buster's own source (Apache-2.0 WITH LLVM-exception; `lane.c`'s hunks under that
file's MIT terms, as buster's `THIRD_PARTY_NOTICES.md` says).

Each build is a `git worktree` of buster at `b7a95eedb` with its patch applied, built on the 9700X by
`scripts/build-tree.sh` under the machine's lock: `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 taskset -c 0-7
./build.sh shifts --config Release DIR main_unit_checker.c 0 1088 2112 3136`, four placements of
`main_unit_checker.c`'s code. `raw/build-*.log` has each tree's commit, diff summary, build and the SHA-256 of its
executables; `raw/results/hostinfo.txt` has every executable's, patch's and input's.

## Host

`raw/results/hostinfo.txt`: AMD Ryzen 7 9700X (CPUs 0–9 and 11–15 online), Linux 6.18.50-2-lts, transparent huge pages
`always` (defrag `madvise`), `vm.overcommit_memory` 0, CPU 2 on the `performance` governor, clang 23.1.1, LLD 23.1.1,
perf 7.2.9, strace 7.2, glibc 2.44. The executables live on btrfs.

Every build and measurement ran under the shared lock (`~/buster-fast-bench/exclusive.sh`). Timed processes are pinned
to CPU 2. The holders' own lines, which `head -1 /var/lib/buster-9700x/owner` printed inside each hold, are in
`raw/results/kstat-*/holds.txt` and `raw/results/ab-*-holds.txt`. The lock's waiting notices, which name other
sessions, are removed from the logs by `scripts/keep_own_lines.py`, which keeps only the line shapes this record's
tools print.

## Inputs

`inputs/` are the files of `start-faults-1444-2026-11-11`: an empty file, `tiny.c` (one function), `hello.c`
(`stdio.h` and a `printf`), `medium.c` and `a.c` to `d.c`. The controls are:

- an empty file's `-fsyntax-only` and `-E -P`;
- the `-c` of `tiny.c`, option first and file first (`tiny.c -c`), of `hello.c` and of `medium.c`;
- `check` and `parse` of the empty file;
- the `-c` of `a.c` to `d.c` in one process;
- the `-fsyntax-only` of buster's own `main.c` (`-march=native -Isrc -fwrapv -funsigned-char`, base's tree);
- the `-c` of the 9700X's frozen `sqlite3.c`, with `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0`.

## Method

- **Census** (`scripts/census.sh` for base, then `scripts/census2.sh` with every measurement of a control in one hold;
  `raw/results/census-BUILD/`), placement 0:
  - `perf stat -r 200` (task clock, faults, user and kernel cycles, user instructions, iTLB misses);
  - `strace -c`;
  - `thp_fault_alloc` over 200 runs;
  - one run's page faults (`perf record -e page-faults -c 1 -d`), attributed by `scripts/attribute.py` to one
    `strace -k` run's mappings and to the executable's sections, both with randomization off;
  - one run's huge-page allocations (a kprobe on `vma_alloc_anon_folio_pmd`).
- **Base pages by stretch** (`scripts/base-pages.sh`, `scripts/stretches.py`, `raw/results/base-pages-base/`): each
  control in base pages (`BUSTER_HUGE_PAGES=0`) and by default; the pages each anonymous mapping touches in each 2 MB
  stretch, and which stretches its advice makes huge.
- **Hot code** (`scripts/hot.sh` and `scripts/hot2.sh`, `raw/results/hot-base/`): `perf record -b -e instructions:u -c
  4999` over 300 processes of the empty `-fsyntax-only` and 200 of each other small control, base's placement 0;
  `perf script -F ip,brstack` of each, gzipped, and the executable's `readelf -sW`. `scripts/layout.py` finds the
  functions they ran by address and counts windows; buster's `compiler start-order` wrote `cmake/BusterStartOrder.txt`
  from the same files.
- **Page costs** (`scripts/populate.c`, `raw/results/populate.txt`): fresh `MADV_NOHUGEPAGE` mappings of 32 and 128
  pages touched by a write, by a read then a write, after `MADV_POPULATE_WRITE`, and every 8th page by
  `process_madvise` or by a write; median ns per page.
- **Warm timing** (`scripts/kstat.sh`, `raw/results/kstat-TAG/`, summarized by `scripts/kstat-summary.py`): `perf stat
  -r 300` (150 for `hello.c`) of placement 0 of each build and of base again, 4 rounds in rotated order, one hold per
  round; `statuses.txt` has every invocation's exit status.
- **Cold timing** (`scripts/ab.sh`, `raw/results/ab-TAG-*.txt`): buster's `time-runs` over each build's four
  placements, `--copies 2`, a Williams design over the slots, base again as the A/A floor; 30 runs of the small
  controls, 20 of the medium ones and 4 of the large ones per slot. One hold per group of controls.

## Results

### The census on `main`

`raw/results/census-base/`. Faults by region (`attribution-*.txt`):

| control | faults | `.text` | anonymous | stack | `.rodata` | `.bss` | huge pages |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| empty `-fsyntax-only` | 262 | 67 | 106 | 27 | 20 | 18 | 1 |
| empty `-E -P` | 171 | 29 | 81 | 14 | 13 | 13 | 1 |
| `tiny.c -c` | 353 | 103 | 130 | 37 | 27 | 20 | 1 |
| `tiny.c -c`, file first | 370 | 112 | 130 | 39 | 34 | 19 | 2 |
| `hello.c -c` | 562 | 114 | 314 | 38 | 29 | 19 | 6 |
| `check` | 273 | 73 | 106 | 28 | 25 | 18 | 2 |
| `parse` | 190 | 33 | 95 | 14 | 15 | 12 | 2 |

`.text` is the largest single region of every control. The intern table's 15 base pages take 29 faults (read, then
written). The kprobe (`who-attribution-*.txt`) names each huge page:
- the intern table's buckets, in every control;
- `.bss` for the file-first command, `check` and `parse`;
- for `hello.c`, also two in the file cache's arenas, two in `check_driver_command`'s and one in the controls arena
  (`check_program`).

### The `.bss` change: kept

`raw/results/census-first/`: the file-first `tiny.c`, `check` and `parse` take 1 huge page instead of 2. In one
`perf stat -r 200` each, their kernel cycles fall 8.5% (1.78 → 1.63 M), 6.9% and 8.0%. A file-first `tiny.c` then takes
the faults (357) and time (0.44 ms) of an option-first one. The other controls are unchanged.

### The token columns: kept

`raw/results/base-pages-base/stretches-hello-0.txt`: in base pages, two of the file cache's five arenas (its four-byte
token columns, `stdio.h`'s 18,000 tokens) touch 16 pages of their 64 KB base and 2 pages of their first huge-page
stretch, which by default each take a huge page cleared whole. With 256 KB of base pages, `hello.c` takes 4 huge pages
instead of 6 (`census-head/thp-hello.txt`). Of its other four:
- `check_driver_command`'s two arenas touch 79 pages of each stretch, about what a huge page costs to clear: left;
- the intern table's and the controls arena's (#572): left as #2347 measured and as the issue says.

### Populating pages: not kept

`raw/results/populate.txt`, per page: a write fault 288–294 ns, a read then a write 544 ns, `MADV_POPULATE_WRITE`
172 ns, `process_madvise` of scattered pages 228–258 ns against 273–333 ns of faults.

`pop` populates the intern table's buckets at their layout and the 120 KB of stack below `main_driver`. Against
`first`, with `first` again as the floor:
- **Warm** (`raw/results/kstat-pop/`, 4 rounds): 36 to 42 fewer page faults, and 1.8% to 4.8% fewer user cycles but
  0.5% to 2.5% more kernel cycles (`hello.c`: +0.1% and −0.1%). Task clock moves 0 to −0.6%, within the floor. perf
  counts page-fault events; the kernel counts populated pages in rusage's minor faults instead, so `time-runs` shows
  more "minor faults" for `pop`.
- **Cold** (`raw/results/ab-pop-*.txt`): the small controls' wall times move −0.6% to +0.4%, the floor's −1.0% to −1.6%;
  the medium and large ones are within the floor.

The populating calls cost about what the faults they replace did, and the stack's 120 KB held pages a compile doesn't
reach. The branch reverts it (`15f45baa`; its message quotes 3 of the 4 warm rounds). The stack below 120 KB (the
refine passes' frames, about 200 KB down) is outside the mapping a new process starts with.

### The start order: kept

`raw/results/hot-base/` through `scripts/layout.py`: the functions each control ran, and the 64 KB windows they
touch.

| control | functions | KB | windows as laid out | in the checker's section | elsewhere | elsewhere, packed |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| empty `-fsyntax-only` | 185 | 693 | 52 | 18 | 34 | 5 |
| empty `-E -P` | 181 | 329 | 27 | 0 | 27 | 6 |
| `tiny.c -c` | 360 | 2,028 | 94 | 50 | 44 | 9 |
| `hello.c -c` | 532 | 2,576 | 106 | 60 | 46 | 13 |

All four together ran 668 functions: 482 local functions of `main.c`'s units (2.6 MB) and 186 by name (99 KB),
`cmake/BusterStartOrder.txt`.

`-ffunction-sections` alone (`fs`) measured as base in the census, with `.text` 6 KB longer. The experiment (`layout`)
put 805 KB before `.text`. Its `.text` faults fell 67 → 44 (empty `-fsyntax-only`), 29 → 12 (`-E -P`), 103 → 70
(`tiny.c`) and 114 → 80 (`hello.c`), with 17% to 32% fewer iTLB misses.

`final`, the branch's mechanism, by region (`census-final/`): `.text` and `.text.buster_start` 67 → 45 + 10, 29 →
12 + 8, 103 → 75 + 12 and 114 → 81 + 12. In each of `final`'s placements, the padding is inside `.text.buster_start`,
before `main_unit_checker.c`'s first function, which grows by the shift (`raw/results/final-shift-check.txt`).

### The pull request's head against `main`

`final2` is the pull request's head, `15f45baa`: the start order, the `.bss` change and the columns. Base again is the
floor.

**Cold** (`raw/results/ab-main2-*.txt`), wall time and user cycles against base:

| control | wall | over placements | floor | user cycles | over placements | floor |
| --- | ---: | --- | ---: | ---: | --- | ---: |
| empty `-fsyntax-only` | −4.71% | −10.39% to −1.74% | −0.55% | −3.80% | −6.59% to −1.42% | −0.19% |
| empty `-E -P` | −4.09% | −10.30% to −0.72% | −1.04% | −4.67% | −6.06% to −1.85% | +0.02% |
| `tiny.c -c` | −4.08% | −16.00% to +2.02% | −0.72% | −3.01% | −5.66% to −1.52% | −0.01% |
| `tiny.c -c`, file first | −8.67% | −18.60% to −4.24% | −0.43% | −4.46% | −7.16% to −1.80% | −0.19% |
| `hello.c -c` | −5.80% | −12.10% to −3.13% | −1.47% | −1.40% | −2.39% to −0.62% | −0.64% |
| `medium.c -c` | −1.40% | −8.21% to +2.36% | −0.86% | −0.22% | −0.76% to +0.96% | −0.16% |
| `a.c` to `d.c` | −1.19% | −8.70% to +2.11% | −1.03% | +0.01% | −2.37% to +1.45% | +0.24% |
| `main.c -fsyntax-only` | −0.14% | −0.42% to +0.33% | +0.13% | −0.20% | −0.47% to +0.03% | +0.07% |
| `sqlite3.c -c` | +0.50% | −0.66% to +1.20% | +0.17% | +0.29% | −0.37% to +0.35% | +0.09% |

`sqlite3.c`'s range overlaps the floor's (−1.17% to +0.87%), and the earlier campaign measured `final` at +0.37%
against a floor of +0.41%.

**Warm** (`raw/results/kstat-main2/`, 4 rounds, every invocation exited 0; the floor is within ±1.6%):

| control | task clock | page faults | user cycles | kernel cycles | iTLB misses |
| --- | ---: | --- | ---: | ---: | ---: |
| empty `-fsyntax-only` | −5.56% | 266 → 251 | −5.81% | −5.05% | −19.66% |
| empty `-E -P` | −4.55% | 173 → 163 | −6.74% | −3.43% | −33.49% |
| `tiny.c -c` | −3.45% | 353 → 336 | −3.83% | −4.19% | −18.07% |
| `tiny.c -c`, file first | −11.17% | 370 → 337 | −6.70% | −12.35% | −20.12% |
| `hello.c -c` | −5.95% | 562 → 544 | −2.32% | −11.08% | −23.70% |

**Faults by region** (`raw/results/census-final2/`), `.text` plus `.text.buster_start` against base's `.text`:
- empty `-fsyntax-only` 44 + 10 against 67;
- `-E -P` 12 + 8 against 29;
- `tiny.c` 72 + 12 against 103;
- `hello.c` 78 + 12 against 114;
- `check` 51 + 10 against 73;
- `parse` 16 + 8 against 33.

Huge pages: 1 for every small control but `hello.c`'s 4.

### Timing: base, head and final

`raw/results/ab-main-*.txt` (cold, wall time and user cycles against base). Base's first placement ran slow, so the
floor reads −1.7% to −3.5%.

| control | head | final | final over placements | floor | final, user cycles | floor, user cycles |
| --- | ---: | ---: | --- | ---: | ---: | ---: |
| empty `-fsyntax-only` | −0.23% | −6.25% | −16.03% to −3.43% | −2.57% | −4.60% | +0.37% |
| empty `-E -P` | −0.92% | −5.71% | −12.01% to −3.44% | −1.74% | −6.76% | +0.17% |
| `tiny.c -c` | −0.51% | −4.77% | −18.51% to +1.64% | −2.78% | −2.21% | +1.08% |
| `tiny.c -c`, file first | −6.43% | −10.81% | −22.41% to −6.43% | −3.52% | −5.03% | +0.06% |
| `hello.c -c` | −4.57% | −7.38% | −13.25% to −5.45% | −2.50% | −1.55% | −0.61% |
| `medium.c -c` | −0.04% | −1.61% | −7.67% to +0.74% | −0.84% | −0.44% | −0.00% |
| `a.c` to `d.c` | −0.09% | −2.82% | −8.97% to +0.85% | −0.81% | −1.60% | −0.28% |
| `main.c -fsyntax-only` | −0.02% | −0.05% | −0.68% to +0.20% | −0.11% | −0.14% | −0.15% |
| `sqlite3.c -c` | +0.01% | +0.37% | −0.62% to +1.46% | +0.41% | +0.02% | −0.09% |

`raw/results/kstat-main/` (warm, 4 rounds, against base; every invocation exited 0). The floor is within ±1% but for
the file-first and `hello.c` faults' +0.6%:

| control | task clock, head / final | faults, base → final | iTLB misses, final | kernel cycles, head / final |
| --- | --- | --- | --- | --- |
| empty `-fsyntax-only` | −3.2% / −3.2% | 265 → 217 | −19.0% | −2.8% / −3.5% |
| empty `-E -P` | −4.6% / −4.6% | 171 → 121 | −32.9% | −2.7% / −1.7% |
| `tiny.c -c` | −3.5% / −3.5% | 356 → 302 | −16.7% | −3.7% / −2.9% |
| `tiny.c -c`, file first | −10.8% / −9.7% | 370 → 302 | −19.0% | −12.3% / −11.2% |
| `hello.c -c` | −6.2% / −6.6% | 562 → 504 | −21.9% | −11.1% / −10.3% |

### One executable's page cache is not another's

`head`'s placement 0 took 4 `.rodata` faults for `tiny.c`, against 27 for base's and final's, and accesses every
compile makes (`main_information`'s option table) were among the missing ones. btrfs can hold an executable in large
folios, which a fault maps whole, and how a file's pages land depends on how it was written. So the warm `perf stat`
of one executable per build mixes a build's code with its file's page cache. The cold `time-runs` runs 8 files per
build, 2 copies at each of 4 placements, so its comparison is the one to read. In the warm rounds, head's lower fault
count for the empty files was its file's: `kstat-pop` measured `pop` alone at 0 to −0.8%.

## Not covered

- **The checker's own section:** 18 of the empty file's windows and 60 of `hello.c`'s. It is one section of each
  unit, which the linker can't reorder.
- **`check_driver_command`'s two huge pages in `hello.c`.**
- **The preprocessor tables' first pages** (30 of them, one fault each), and the arenas' first commits.
- **Executable text in huge pages:** David's host decision, as #2347's record says.
