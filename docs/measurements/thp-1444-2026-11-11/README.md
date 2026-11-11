# A small compile's transparent huge pages (#1444, item 3), 2026-11-11

Evidence for the pull request from buster14a/buster's `claude/small-compile-thp-1444`, part of
[#1444](https://github.com/buster14a/buster/issues/1444): the fixed start of a small compile. This record covers item 3,
transparent huge pages. It contains a census of where a compile takes huge pages on `main`, two arena changes and the
executable's text in huge pages. Each one was measured against `main`, with `main` again as the A/A floor.

## Sources

| tree | what it is | measured as |
| --- | --- | --- |
| `base` | `main` at `16d879b4481cae47aa1d9fea964784009836751e` (#2269's merge) | `shifts-base/compiler-{0,1088,2112,3136}` |
| `bss` | base and `patches/bss.patch`: `.bss` advised at `main_driver`'s start, with a static flag guarding the second call (the branch's first commit) | `shifts-bss/...` |
| `bss2` | base and `patches/bss2.patch`: `.bss` advised before any access, without the flag (the branch's code) | `shifts-bss2/...` |
| `intern` | `bss` and the intern table's buckets and spans in base pages (`arena_reserve_small`) | `shifts-intern/...` |
| `align` | base and `patches/align.patch`: the executable linked with `-z max-page-size=0x200000` | `shifts-align/...` |

`patches/bss2.patch` is the pull request's code: its first two commits together. The third commit changes only
`docs/arena-memory.md`. The patches are this compiler's own source (Apache-2.0 WITH LLVM-exception; `lane.c`'s hunks
under that file's MIT terms, as in buster's `THIRD_PARTY_NOTICES.md`).

Each tree is a `git worktree` with its patch applied, built on the 9700X by `scripts/build-tree.sh` under the machine's
lock: `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 taskset -c 0-7 ./build.sh shifts --config Release DIR
main_unit_checker.c 0 1088 2112 3136`, four placements of `main_unit_checker.c`'s code. `raw/hostinfo.txt` has the
SHA-256 of every executable, patch and input.

## Host

`raw/hostinfo.txt`: AMD Ryzen 7 9700X (CPUs 0–9 and 11–15 online), Linux 6.18.50-2-lts, transparent huge pages
`always` (defrag `madvise`), `vm.overcommit_memory` 0, CPU 2 on the `performance` governor, clang 23.1.1, perf 7.2.9,
strace 7.2, glibc 2.44. The executables live on btrfs.

Every build and measurement ran under the shared lock (`~/buster-fast-bench/exclusive.sh`), one script command per
hold. The lock's waiting notices, which name other sessions, are removed from the logs. Timed processes are pinned to
CPU 2.

## Inputs and controls

`inputs/` are the files of `start-faults-1444-2026-11-11`. The controls:

- an empty file's `-fsyntax-only` and `-E -P`;
- the `-c` of `tiny.c`, of `hello.c` (which includes `stdio.h`) and of `medium.c`;
- the `-c` of `a.c` to `d.c` in one process;
- the `-fsyntax-only` of buster's own `main.c` (`-march=native -Isrc -fwrapv -funsigned-char`, base's tree);
- the `-c` of the 9700X's frozen `sqlite3.c`, with `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0`.

## Method

- **Census** (`scripts/thp-census.sh NAME`, `raw/thp-NAME/`): `thp_fault_alloc` and `thp_fault_fallback` from
  `/proc/vmstat` over 100 runs (10 for `main.c`, 5 for `sqlite3.c`). One run is traced with `strace -k` and another
  with a kprobe on `do_huge_pmd_anonymous_page`, both with the address space's randomization off. `attribute.py` names
  the mapping of each probe hit. The kprobe fires on every attempt, most of which the kernel refuses: only
  `count-*.txt` counts allocations.
- **Allocations** (`scripts/thp-who.sh`, `raw/who-NAME/`): a kprobe on `vma_alloc_anon_folio_pmd`, the function that
  allocates an anonymous huge page, records the address of each one.
- **The `.bss` write** (`raw/pf-bss-syntax.txt`): `perf record -e page-faults -d` together with
  `syscalls:sys_enter_madvise`, on `bss`'s empty `-fsyntax-only`.
- **Timing** (`scripts/ab.sh`, `raw/ab-TAG-*.txt`): `time-runs` over each build's four placements, `--copies 2` (fresh
  copies of each executable), a Williams design over the slots, and base again as the floor.
- **Kernel cycles** (`scripts/kstat.sh`, `raw/kstat-bss2/`, `raw/kstat-bss2-summary.txt`): `perf stat -r 300` (150
  for `hello.c`) of placement 0 of base, `bss2` and base again, 4 rounds in a rotating order, one round per hold.
- **Text** (`scripts/text.sh`, `scripts/text-prepare.sh`, `scripts/tmpfs.sh`, `scripts/collapse.c`): `collapse` maps
  an executable's `R E` segment from its whole 2 MB boundaries and calls `MADV_COLLAPSE` on it, so that the page cache
  holds its text as 2 MB folios.

## Results

### Where the huge pages are, on `main`

| control | huge pages per run |
| --- | --- |
| empty `-fsyntax-only` | 2 |
| empty `-E -P` | 2 |
| `tiny.c -c` | 2 |
| `hello.c -c` | 7 |
| `main.c -fsyntax-only` | 602 |
| `sqlite3.c -c` | 136 |

`raw/who-base/`: every small compile allocates these two.

1. **One in `.bss`, at `0x4f43000`.** It holds `arena_stack_base_pages`, which `arena_page_policy` writes at the top of
   `main_driver`. That write came before `main_source_command` advised `.bss` `MADV_NOHUGEPAGE`. The stretch is 2 MB
   of 220 MB of tests' and benchmarks' statics, of which a compile uses one page.
2. **One in the intern table's arena (`check_driver_flow`, `intern_initialize`).** Its 1 MB of buckets reach past the
   arena's 64 KB of base pages.

`hello.c`'s other five are in the file cache's, the driver's and the checker's arenas (`raw/thp-base/attribution-hello.txt`).

### The `.bss` page: kept

`bss` moved the advice to `main_driver`'s start, but `raw/thp-bss/` still counts 2 huge pages per run. The cause is in
`raw/pf-bss-syntax.txt`. The flag that guarded the second call is a static in the same 2 MB, and testing it before the
advice is a read fault. With transparent huge pages `always`, that read maps the huge zero page over the 2 MB. The
write after the advice then replaces the zero page with a huge page of its own: the advice doesn't undo a touch before
it.

`bss2` advises before any read or write of `.bss`. `main_driver` tells `main_source_command` that it has advised, so no
flag is needed. `raw/thp-bss2/`: 1 huge page per small compile, 6 for `hello.c`. `raw/who-bss2/syntax.txt` keeps only
the intern table's.

`raw/kstat-bss2-summary.txt` gives the means of the 4 rounds' means, with base again as the floor:

| control | task clock | kernel cycles | faults | floor's task clock | floor's kernel cycles |
| --- | --- | --- | --- | --- | --- |
| empty `-fsyntax-only` | −4.92% | −6.94% | +1 | −0.82% | −0.22% |
| empty `-E -P` | −8.05% | −8.58% | +3 | +1.15% | +0.57% |
| `tiny.c -c` | −4.65% | −5.42% | +1 | −0.58% | −0.36% |
| `hello.c -c` | −1.86% | −2.71% | +1 | 0.00% | +0.65% |

User cycles are unchanged (within ±0.5%). Each control's 4 `bss2` rounds lie below all of base's and base again's in
kernel cycles. The 2 MB clear becomes one or a few base-page faults.

`raw/ab-bss2-*.txt`, `time-runs` from cold starts, wall time against base:

| control | `bss2` | over placements | floor | floor over placements |
| --- | --- | --- | --- | --- |
| empty `-fsyntax-only` | −3.10% | −5.51% to −2.35% | −0.16% | −1.56% to +2.05% |
| empty `-E -P` | −5.09% | −10.99% to +1.15% | −1.95% | −7.36% to +5.09% |
| `tiny.c -c` | −3.19% | −9.86% to +5.19% | −1.07% | −7.35% to +7.01% |
| `hello.c -c` | −1.45% | −5.82% to +1.70% | −0.28% | −3.90% to +13.24% |
| `medium.c -c` | −1.27% | −5.06% to +2.38% | +0.04% | −1.48% to +3.32% |
| `a.c` to `d.c` | −1.91% | −4.25% to +2.21% | −1.41% | −3.60% to +3.04% |
| `main.c` | −0.15% | −0.31% to +0.13% | +0.04% | −0.34% to +0.47% |
| `sqlite3.c` | +0.99% | −2.14% to +1.40% | +0.22% | −1.59% to +1.42% |

The empty `-fsyntax-only`'s range lies wholly outside the floor's. The others' medians agree, but their ranges overlap
the floor's: cold-start wall times vary more than `perf stat`'s warm runs. The `wait4` peak falls by 2 MB, for example
10,380 KiB to 8,332 KiB in an empty `-fsyntax-only` (`raw/ab-bss2-small.txt`).

`raw/tests-bss2.txt` has the fast checks on `bss2`: `test-lanes`, `test-check-lanes`, and `main.c`'s `-fsyntax-only
-Wall -Werror` pass, as do a `BUSTER_HUGE_PAGES=0` compile and `parse`. `test-checker-driver --part 1/4` fails 4
checks on base as on `bss2`: the interrupt handlers' probes against clang's objects ("nothing ran"; the 9700X's clang is
23.1.1, where the test expects 23.1.4).

Not covered: `check` and `parse`, and a source command whose first argument is a file, still advise `.bss` after
`arena_page_policy` and take that page.

### The intern table in base pages: rejected

`intern` reserves the record arena with its buckets and spans (1.3 MB) in base pages, which removes the second huge
page (`raw/thp-intern/`). But an empty file's predefined names touch nearly every page of the buckets, so the clear of
one huge page becomes about 450 faults. Against base (`raw/ab-arenas-*.txt`), the floor is within ±2.4%:

| control | faults | wall time | user cycles |
| --- | --- | --- | --- |
| empty `-fsyntax-only` | 275 → 726 | +22.06% | +25.91% |
| empty `-E -P` | 187 → 634 | +26.37% | +36.65% |
| `tiny.c -c` | | +14.47% | +13.75% |
| `medium.c -c` | | +5.66% | +2.99% |

`main.c` and `sqlite3.c` are unchanged. This agrees with the issue's earlier finding that a smaller first table doesn't
pay. The intern table's huge page is the cheapest way to hold its buckets.

### The executable's text in huge pages: not kept, because btrfs refuses the collapse

`align` puts the executable's segments on 2 MB boundaries in file and memory, so its text can be mapped by whole huge
pages. `collapse` asks the kernel to hold that text as 2 MB folios in the page cache. Later processes then map those
folios whole.

- **btrfs, where the 9700X's executables live:** `MADV_COLLAPSE` returns `EAGAIN` after 7 to 9 ms
  (`raw/text-prepare.txt`, `raw/text-a1/collapse.txt`), on fresh copies and on copies written back long before. So
  `raw/ab-text-*.txt` compared two sets of plain copies, both with 274 faults. Their differences, up to 17%, are the
  files' placement (#509), not huge pages. That campaign measures nothing about huge pages.
- **tmpfs (`/tmp`):** the collapse succeeds, in 3.4 to 3.9 ms the first time and 23 µs once the text is already
  collapsed (`raw/tmpfs-align/collapse.txt`). `perf stat` over 4 alternating rounds (`raw/tmpfs-align/`), plain against
  collapsed:

| control | faults | iTLB misses | elapsed |
| --- | --- | --- | --- |
| empty `-fsyntax-only` | 259 → 222 | 403 → 125 | 0.443 → 0.411 ms (−7%) |
| `hello.c -c` | 553 → 470 | 1,409 → 277 | 1.480 → 1.345 ms (−9%) |

So text in huge pages would pay about 7–9% of a small compile, in iTLB misses and text faults. But no mechanism in the
compiler gets it on this host:

- The collapse fails on btrfs.
- Repeating it in every process would cost 23 µs, about 5% of an empty compile, even where it succeeds.
- An executable on tmpfs is a deployment choice, not the compiler's.

`khugepaged` doesn't collapse a process that lives for half a millisecond. A filesystem whose page cache can hold 2 MB
folios of an executable would make the gain reachable, and `align.patch` would then be needed.

### Not tried

- Delaying an arena's `MADV_HUGEPAGE` until it has grown past a threshold. Of a small compile's two huge pages, one was
  the `.bss` page and the other is the intern table's, which pays as a huge page (above). Whether `hello.c`'s other
  five (the file cache's, the driver's and the checker's arenas) would pay as base pages is left open.
- Copying the hot text into anonymous huge pages at start: it costs at least one 2 MB clear and copy per process per
  huge page, more than the iTLB misses it saves.
