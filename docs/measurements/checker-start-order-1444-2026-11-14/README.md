# A small compile's start: the checker's section, first commits and table pages (#1444), 2026-11-14

Evidence for buster14a/buster's pull request from `claude/keen-noether-7hjf07`, part of
[#1444](https://github.com/buster14a/buster/issues/1444): the fixed start of a small compile. It covers what the issue's
14 November release comment left open, as claimed in
[comment 6875893132](https://github.com/buster14a/buster/issues/1444#issuecomment-6875893132):

1. **the checker's own section**, `.text.buster_checker`, which the start order of buster14a/buster#2687 couldn't
   reorder (one section of each unit): kept, as the parallel split's `--first` and a start list sampled again;
2. **the preprocessor tables' first pages:** measured, not pursued;
3. **the arenas' first commits:** measured, not pursued.

## Sources

| build | what it is |
| --- | --- |
| `base` | `main` at `389d25b91a8bbc6faba040125be2ccad51b6815d` |
| `mid` | the branch's `9cb325741ceb42e61db8833c6624f6ddbc1ee0ec` (the split's `--first` and `start-order`'s grouping) with `main`'s `cmake/BusterStartOrder.txt` |
| `head` | `9cb32574` itself: the 2026-11-13 samples' list regrouped by command |
| `head2` | the branch's `1a3050a3145db39b5290d42ca5a1fae72a7f8a3e`: the list sampled again (below) |

The pull request's head adds documentation, comments and a build-regression check to `head2`'s tree; no build reads them.

Each build is a `git worktree` of buster at its revision, built on the 9700X by `scripts/build-tree.sh` under the
machine's lock: `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 taskset -c 0-7 ./build.sh shifts --config Release DIR
main_unit_checker.c 0 1088 2112 3136`, four placements of `main_unit_checker.c`'s code, with CI's toolchain (Clang
23.1.4 and its lld; `raw/build-*.log`, which also has the SHA-256 of each executable). The shifts move units' `.text`,
not the page-aligned `.text.buster_checker`: every placement has the checker's section at the same offset in a page.

## Host

`raw/results/hostinfo.txt`: AMD Ryzen 7 9700X (CPUs 0–9 and 11–15 online), Linux 6.18.50-2-lts, transparent huge pages
`always` (defrag `madvise`), `vm.overcommit_memory` 0, CPU 2 on the `performance` governor, perf 7.2.9. The executables
live on btrfs. Every build and measurement ran under the shared lock (`~/buster-fast-bench/exclusive.sh`); the holder
lines each hold printed are in `raw/results/*holds.txt` and `raw/results/*/holds.txt`. `scripts/keep_own_lines.py` removed
the lock's waiting notices, which name other sessions, from the logs. Timed processes are pinned to CPU 2.

## Inputs

`inputs/` are the files of `start-order-1444-2026-11-13`: an empty file, `tiny.c` (one function), `hello.c` (`stdio.h`
and a `printf`), `medium.c` and `a.c` to `d.c`. The controls are an empty file's `-fsyntax-only` and `-E -P`, the `-c`
of `tiny.c` (option first and file first), of `hello.c` and of `medium.c`, `check` and `parse` of the empty file, the
`-c` of `a.c` to `d.c` in one process, the `-fsyntax-only` of buster's own `main.c` and the `-c` of the 9700X's frozen
`sqlite3.c` (`-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0`).

## Method

- **Census** (`scripts/census.sh`, `raw/results/census-BUILD/`), placement 0, one hold per control: `perf stat -r 200`,
  one run's page faults (`perf record -e page-faults -c 1 -d`) attributed by `scripts/attribute.py` to one `strace -k`
  run's mappings and to the executable's sections (randomization off). `scripts/checker-faults.py` splits the faults in
  `.text` into the checker's section and the rest, by the section's functions in `base`'s joined checker object
  (`raw/results/checker-native-symbols-base.txt.gz`, `readelf -sW` of its `native.o`).
- **Samples** (`scripts/hot.sh`, `raw/results/hot-base/`): `base`'s placement 0, 300 processes of each of the empty
  file's `-fsyntax-only` and `-E -P`, `tiny.c`'s `-c` and `hello.c`'s `-c`, each under a `perf record -b -e
  instructions:u -c PERIOD` of its own, the i-th with a period of 4999 + 2i; `perf script -F ip,brstack` of them, and
  the executable's `readelf -sW`. buster's `compiler start-order` wrote `head2`'s list from them.
- **Simulation** (`scripts/simulate-windows.py`): the 64 KB windows the list's functions would touch, packed in a list's
  order, from samples, by region.
- **Cold timing** (`scripts/ab.sh`, `raw/results/ab-TAG-*.txt`): buster's `time-runs` over each build's four
  placements, `--copies 2`, a Williams design over the slots, `base` again as the A/A floor; 30 runs of the small
  controls, 20 of the medium ones and 4 of the large ones per slot. One hold per group of controls.
- **Warm timing** (`scripts/kstat.sh`, `raw/results/kstat-TAG/`, summarized by `scripts/kstat-summary.py`): `perf stat
  -r 300` (150 for `hello.c`) of placement 0 of each build and of `base` again, 4 rounds in rotated order, one hold per
  round; `statuses.txt` has every invocation's exit status.
- **First commits** (`scripts/commit.c`, `raw/results/commit.txt`): three runs, one hold, pinned to CPU 2.

## Results

### The checker's section

**Why the link couldn't place it.** `main.c` puts the checker's own code in `.text.buster_checker` with `#pragma clang
section` (#502), which `-ffunction-sections` doesn't split: in the checker's joined object it is one section of 2,161
functions, 5.4 MB on the 9700X. On `main`, an empty file's `-fsyntax-only` took 31 of its 57 code faults there, `hello.c`'s `-c` 64 of
94.

**The change.** Release's parallel split (`tools/codegen/split.c --first`) moves each function the start list names that
the unit defines in a named section before that section's first unlisted function, in the list's order, before it plans
the parts. `head2` puts 269 functions, 1.95 MB, first in the checker's section.

**The list's order.** The split follows the list's order, which the 2026-11-13 list had by address. `compiler
start-order` now groups the functions by the first sample file that ran each, smallest command first:

- **Simulation** (`scripts/simulate-windows.py` over `start-order-1444-2026-11-13`'s samples and `main`'s list, the
  section's sampled windows for the empty file, `tiny.c` and `hello.c`): 18, 50 and 60 as laid out (that record's
  `layout.py`); 15, 29 and 30 with the list's functions first in address order; 7, 23 and 30 grouped by command.
- **Measured** (`mid` and `head`, the 2026-11-13 samples' list): the empty file's checker faults fell 31 → 28 → 25 only.
  Its faults landed on functions the list didn't name at all (`check_driver_typo_errors`,
  `check_common_candidates_build`, `check_musttail_run_limited`) or named in a later command's group
  (`check_driver_classify`, `parse_brackets_avx512`).

**The samples.** A compile is deterministic. Under one sampling period, every process is sampled at about the same
instructions, so the short functions those samples miss stay unsampled in all 300 processes. `scripts/hot.sh` gives each
process its own period, 4999 + 2i. The empty file's own samples then named 304 functions, against 185 from the
2026-11-13 samples. The union of the four commands' samples barely changed (665 lines against 668), but each command's
group is now nearly complete. `head2`'s list is written from these samples, on `main`.

**Faults in the executable's code** (`raw/results/census-*/`, `scripts/checker-faults.py`; placement 0, one run each),
`base` → `head2`:

| control | all faults | code | checker's section | other `.text` | `.text.buster_start` | iTLB misses |
| --- | --- | --- | --- | --- | --- | --- |
| empty `-fsyntax-only` | 259 → 236 | 57 → 35 | 31 → 14 | 17 → 14 | 9 → 7 | 364 → 315 |
| empty `-E -P` | 167 → 165 | 22 → 21 | 0 | 15 → 14 | 7 → 7 | 144 → 149 |
| `tiny.c -c` | 336 → 301 | 85 → 50 | 57 → 26 | 17 → 14 | 11 → 10 | 776 → 680 |
| `hello.c -c` | 549 → 515 | 94 → 61 | 64 → 35 | 18 → 14 | 12 → 12 | 1,119 → 1,023 |
| `check` | 271 → 250 | 63 → 43 | 31 → 14 | 23 → 22 | 9 → 7 | 376 → 331 |
| `parse` | 186 → 186 | 24 → 26 | 0 | 17 → 19 | 7 → 7 | 227 → 221 |

`mid` and `head` are in the same directory: the empty file's code faults 54 and 51, `hello.c`'s 76 and 76.

**Cold timing** (`raw/results/ab-main2-*.txt`): wall time and user cycles against `base`. Base timed again is the floor.
Placement 0 of every build ran slower than the others, as in the earlier records.

| control | `head2` wall | over placements | floor | `head2` user cycles | over placements | floor |
| --- | ---: | --- | ---: | ---: | --- | ---: |
| empty `-fsyntax-only` | −8.29% | −16.07% to +2.18% | −2.45% | −2.71% | −3.81% to −1.86% | −0.05% |
| empty `-E -P` | −1.18% | −8.50% to +8.14% | −1.79% | +2.52% | +1.30% to +3.81% | +0.77% |
| `tiny.c -c` | −9.37% | −20.95% to +5.99% | −3.19% | −2.74% | −4.54% to −1.43% | +0.36% |
| `tiny.c -c`, file first | −8.94% | −19.52% to +4.96% | −2.10% | −3.54% | −5.62% to −1.93% | −0.40% |
| `hello.c -c` | −4.06% | −11.27% to +3.44% | −1.49% | −1.25% | −1.61% to −0.85% | −1.20% |
| `medium.c -c` | −1.57% | −7.75% to +4.25% | −0.15% | −0.61% | −1.72% to +0.36% | +0.21% |
| `a.c` to `d.c` | −0.59% | −7.79% to +6.63% | −0.42% | −0.43% | −1.58% to +0.90% | −0.40% |
| `main.c -fsyntax-only` | +0.05% | −0.12% to +0.52% | −0.07% | +0.01% | −0.26% to +0.52% | −0.04% |
| `sqlite3.c -c` | +0.75% | −1.28% to +1.53% | −0.37% | +0.08% | −0.14% to +0.29% | −0.35% |

The same runs timed `head`: −3.00%, −0.93%, −4.54%, −4.13% and −2.36% wall for the five small controls.

`sqlite3.c`'s 4 runs a slot read +0.75%, so `raw/results/ab-sqlite.txt` timed it alone, 16 runs a slot. There `head2`
read −0.05% wall against a floor of −0.07%, and +0.01% user cycles against +0.03%. Round 1 (`raw/results/ab-main-*.txt`:
`base`, `mid`, `head` and the floor) read `head` +0.37% and +0.09% on it, `main.c` +0.08% and +0.08%.

**Warm timing** (`raw/results/kstat-main2/`, 4 rounds, every invocation exited 0), `head2` against `base`, with the
floor's change in brackets:

| control | task clock | user cycles | kernel cycles | iTLB misses |
| --- | --- | --- | --- | --- |
| empty `-fsyntax-only` | −4.42% (−1.77%) | −3.23% (−1.07%) | −2.59% (−1.24%) | −13.26% (+0.07%) |
| empty `-E -P` | +2.63% (0.00%) | −0.02% (−0.12%) | +2.08% (−0.78%) | +3.81% (−0.17%) |
| `tiny.c -c` | −1.92% (0.00%) | −2.25% (+0.29%) | −2.77% (−0.92%) | −11.91% (−0.06%) |
| `tiny.c -c`, file first | −3.18% (−0.64%) | −2.59% (+0.08%) | −3.42% (−0.38%) | −11.91% (0.00%) |
| `hello.c -c` | −1.11% (−0.45%) | −0.26% (−0.11%) | −2.08% (−0.72%) | −7.87% (−0.17%) |

The warm rounds read one executable per build, so their page faults follow that file's page cache, which btrfs can hold in
large folios. `base`'s empty `-E -P` took 157 faults here against 167 in its census, so its kernel cycles aren't
comparable across builds. The cold runs, over two fresh copies of each placement, are the ones to read.

**`-E -P`.** It runs no checker code. Its own functions come after the empty `-fsyntax-only`'s group now, past the
parser's, and its iTLB misses rose 3.8%. Its wall time stays within the floor cold, and its user cycles rose 2.5% cold
against a floor of 0.8% but not warm.

### The preprocessor tables' first pages: not pursued

Every small control takes the same 34 faults on 30 pages of the preprocessor's arena of tables (`pp_initialize_once`'s
10 GB mapping; `hello.c` 58 on 54). Each is the first page of one table that the predefines and the empty unit
touch, by the function that first writes each: `pp_prepared_directive` 6 pages, `pp_add_directory` 4, `pp_copy_line` 4,
`pp_lookup_path` 3 (5 faults) and others. The tables
are id-indexed arrays sized by `BUSTER_PP_MAX_FILES`, `_MACROS`, `_ITEMS` and the intern table's id limit. The
2026-11-08 design excludes those from packing: "Sparse huge-capacity ID arrays are not small fixed tables merely because
this run touches few cells".

At this host's page costs (`start-order-1444-2026-11-13`'s `populate.txt`: a write fault 290 ns, a read then a write 544
ns, a scattered page populated by `process_madvise` about 230 ns), the 34 faults cost about 10 µs, 3% of the empty
file's 0.29 ms. Populating the 30 pages in one call would save about 3 µs. That is within the floors above, as was the
earlier record's populate of the intern table's pages.

### The arenas' first commits: not pursued

`raw/results/commit.txt`, `scripts/commit.c` (median ns of 4,000 iterations, three runs): reserving 64 GiB `PROT_NONE`
costs 261–291 ns. Its first commit by `mprotect` of 64 KB brings that to 511–591 ns, so the `mprotect` costs 250–300 ns.
The issue's 1.5 µs a commit was measured in an earlier address-space state.

A writable `MAP_STACK` reservation, which needs no `mprotect` and is base pages from its mapping, costs 370 ns. A
`MAP_FIXED` remap of the first 64 KB costs 702–792 ns. Writing the 16 pages costs 5.6 µs either way.

An empty file's `-fsyntax-only` makes 26 `mprotect` calls (`raw/results/census-base/attribution-syntax.txt`), about 7 µs
of 0.29 ms. The cheapest form the design allows saves about 0.2 µs for each arena that could use it. That is under 5 µs
even if all 26 could, which is below the floor. The large reservations can't: a writable 64 GiB mapping is charged
under strict overcommit and counted by `RLIMIT_DATA`.

## Not covered

- **Develop's parts and Release's single compiles** (`BUSTER_BUILD_DEFINES`, `BUSTER_PGO`) keep the checker's section in
  source order. So do `BUSTER_CHECKER_OFFSET`'s builds, so this record couldn't sample the moved hot loops at other
  offsets in a page. The large controls' floors above bound that effect.
- **`hello.c`'s `.text.buster_start`** stayed at 12 windows: its group is the list's last and largest.
- **`check_driver_command`'s two huge pages in `hello.c`** (break-even, `start-order-1444-2026-11-13`), **the serial
  `stdio.h` case's idle core** (host scheduling) and **executable text in huge pages** (David's host decision).
