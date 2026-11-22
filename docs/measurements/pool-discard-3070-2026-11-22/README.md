# The arena pool's releases between a command's units (2026-11-22)

Evidence for [buster#3070](https://github.com/buster14a/buster/issues/3070)'s step 1 ("warm lanes", item 5), and for
the part of [buster#1213](https://github.com/buster14a/buster/issues/1213) a lane's own per-unit releases cause. Three
versions of one change were built and measured: two that keep a released arena's pages, cleared in place, both
rejected on these numbers, and a third that frees them as main does, but only within the arena's writable prefix,
which is the pull request.

- **Source:** buster main `e20c6ff98e3af23012ef36d7e9578e87bb4249a4` (the merge of #3274). Built `./build.sh --config
  Release` on the 9700X under the lock (`scripts/build9700.sh`), one tree for main (`bin/base`) and one for each
  version, `scripts/patch/` and the pull request applied to the same commit.
- **Hosts:**
  - The 9700X (Linux 6.18.50, transparent huge pages `always`): every figure below. Each round of
    `scripts/measure.sh` is one hold of the lock, the builds in an order that rotates by round; `perf stat` user and
    kernel cycles, user instructions, page faults. No other busy process was listed at any hold
    (`results/*/exclusive.txt`).
  - The cloud container (Xeon, 4 vCPUs under KVM, Linux 6.18.44, transparent huge pages off for the compiler as on any
    virtual machine): the censuses of what a release holds, the correctness checks, and the first ranking only.
- **Workloads,** from `scripts/measure.sh`, on CPU 2 for one lane and CPUs 2 to 5 for four:
  - `empty`: 1,336 empty files with musl's options, one `-c --lanes 1` command (#3070's step-1 gate: 135 M cycles).
  - `musl1`, `musl4`: musl's 1,336 units (the frozen corpus `preprocessor-391e729af658`, one source per base name, the
    one-core record's options), one command, one lane and four.
  - `lua1`: Lua 5.4.8's 34 `src/*.c`, `-std=gnu99 -O2 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX`, one lane.

## In short

- **What a release costs on main.** A units lane's unit releases about 14 (empty) to 20 (musl's mean) arenas into the
  lane's pool. Each release discards its whole mapping with `MADV_DONTNEED`, up to 64 GB, so that the next user finds
  zeros. The kernel walks the page tables of each touched gigabyte of it a 2 MB entry at a time: `unmap_page_range` is
  19.8% of the empty units' cycles, `__cond_resched` 3.6% and TLB flushes 2.4% (`results/profiles.txt`). The arenas
  hold little: 720 KB resident in all at musl's mean, the preprocessor's 9.6 GB of tables 88 KB of it for an empty unit
  (the container's census, below).
- **Keeping the pages, cleared, loses.** v1 found the pages that hold anything with `PAGEMAP_SCAN` and cleared them in
  place: faults fell from 266 thousand to 11 thousand on musl's command, but its cycles rose 17% on one lane and 23%
  on four. v2 limited the scan to the writable prefix and kept only arenas of base pages: still 9% and 15% more. Once
  kept, a page is present whether or not the next unit writes it, so each release clears every page any earlier unit
  touched, not those the last one wrote: v2's `memset` took 332 M user instructions on musl's command, several times
  what clearing the 720 KB a unit leaves resident on main would.
- **Freeing the writable prefix alone wins, modestly.** v3, the pull request, discards the pages of the prefix the
  arena committed, past which none can be: the arena's commit, or, where a copy of it committed further, the end of the
  last writable mapping in it, which one `PROCMAP_QUERY` (Linux 6.11) answers from the kernel's tree of mappings. On
  the empty units, the kernel's cycles fall 12.7% and all cycles 7.9%, lower in each of 7 rounds; musl's on four lanes
  the kernel's 4.1% (7 of 7) and all 1.1% (5 of 7); musl's on one lane and Lua's are within the rounds' spread. The
  faults are main's: v3 changes what a release walks, not what the next unit faults in.
- **What is left of an empty unit's kernel time** is mostly the preprocessor's tables arena, which v3 can't shorten
  (its 9.6 GB are writable whole: 89 thousand ticks a release, `results/micro/walk.txt`), the faults (46 a unit), and
  the source's and object's files. The user cycles (194 M for 1,336 units) are mostly the predefines', which #3070's
  root image takes out.

## 1. What a release holds (container, an experiment patch printing each release)

The released arena's resident pages, by `PAGEMAP_SCAN` before its discard, over a `-c --lanes 1` command (the
experiment's print isn't kept; v1's patch has the scan it used):

| | releases | resident at release, MB in all | per release: median, p90, p99, most |
| --- | ---: | ---: | --- |
| musl's 1,336 units, arenas | 19,392 | 437.0 | 8 KB, 96 KB, 196 KB, 1.16 MB |
| musl's 1,336 units, arenas of tables | 6,552 | 522.8 | 56 KB, 188 KB, 296 KB, 1.44 MB |
| Lua's 34 units, arenas | 454 | 19.1 | 8 KB, 132 KB, 424 KB, 892 KB |
| Lua's 34 units, arenas of tables | 136 | 25.6 | 160 KB, 324 KB, 660 KB, 736 KB |

An empty unit's 14 releases: mappings of 17 GB (2), 64 GB (5), 4 GB (2), 9.6 GB (the preprocessor's tables), 532 KB
and 204 KB (tables), and three of a few pages; 176 KB resident in all, 88 KB of it the 9.6 GB tables'.

## 2. The kernel's calls (9700X, `scripts/walk.c`, `results/micro/walk.txt`)

TSC ticks a call, medians of 2,001, on CPU 2: a 64 GB `PROT_NONE` mapping whose first 16 MB are writable and four of
its pages written, as a pooled arena is; then a 10 GB writable mapping with a page written in each of its gigabytes,
as the preprocessor's tables are.

| call | ticks |
| --- | ---: |
| `madvise(MADV_DONTNEED)` of the whole 64 GB | 5,472 |
| the same of its 16 MB writable prefix | 2,356 |
| `PAGEMAP_SCAN` of the whole 64 GB | 15,769 |
| the same of its 16 MB | 1,824 |
| `PROCMAP_QUERY` (the writable mapping at or after an address) | 342 |
| four faults after a discard | 3,914 |
| the tables: `madvise` of 10 GB | 88,730 |
| the tables: `PAGEMAP_SCAN` of 10 GB | 123,804 |

## 3. The three versions (9700X, `results/tables.txt`)

Medians of the rounds, M cycles; each version against main in the same holds of the lock. Paired by round, the median
change of all cycles and in how many rounds the version was lower.

| version | empty | musl, one lane | musl, four lanes | Lua, one lane |
| --- | --- | --- | --- | --- |
| v1: clear every resident page of the mapping (5 rounds) | +26.7% (0 of 5) | +16.8% (0 of 5) | +22.5% (0 of 5) | +3.2% (0 of 5) |
| v2: the same within the writable prefix, arenas of base pages only (5) | -11.7% (5 of 5) | +9.3% (0 of 5) | +15.1% (0 of 5) | +3.1% (0 of 5) |
| v3: free the writable prefix (7) | -7.9% (7 of 7) | -0.6% (5 of 7) | -1.1% (5 of 7) | -0.1% (4 of 7) |

v3's medians:

| | user | kernel | all | user instructions | faults |
| --- | ---: | ---: | ---: | ---: | ---: |
| empty, main | 194.7 | 287.7 | 481.1 | 518.5 | 61,780 |
| empty, v3 | 194.2 | 251.5 | 445.1 | 521.3 | 61,781 |
| musl one lane, main | 2,687.3 | 903.9 | 3,591.2 | 6,636.1 | 266,199 |
| musl one lane, v3 | 2,705.2 | 856.8 | 3,568.3 | 6,639.4 | 266,198 |
| musl four lanes, main | 3,066.6 | 1,540.1 | 4,606.1 | 6,765.0 | 272,600 |
| musl four lanes, v3 | 3,074.5 | 1,474.8 | 4,554.3 | 6,768.8 | 273,000 |
| Lua one lane, main | 311.5 | 59.8 | 371.6 | 764.4 | 15,715 |
| Lua one lane, v3 | 311.7 | 59.5 | 372.1 | 764.5 | 15,715 |

Kernel cycles paired by round: empty -12.7% (7 of 7 lower), musl four lanes -4.1% (7 of 7), one lane -4.6% (6 of 7).
The user cycles' +0.3% to +0.5% on musl are within what two builds of the same code read apart on musl's units
(buster#2942: up to 0.8%); the user instructions differ by 0.05%.

## 4. Why v1 and v2 lost (`results/profiles.txt`)

- **v1, the kernel:** `pagemap_scan_pte_hole` is 51.8% of the empty units' cycles, `pagemap_scan_pmd_entry` 7.9% and
  `walk_pgd_range` 7.7%. A scan of the whole mapping walks the same 2 MB entries as main's discard, at three times its
  cost a release (section 2).
- **v1 and v2, the user side:** `__memset_avx512_unaligned_erms` is 17.4% of v1's musl command (main: 1.9%) and 4.7% of
  v2's user instructions (369 M more than main's). A kept page stays present, so the next release clears it again
  whether or not anything wrote it: the pages any earlier unit touched, not those the last one did. Telling them apart
  takes dirty bits (userfaultfd's asynchronous write-protect or soft-dirty, each a fault on a page's first write after a
  release, and the latter a walk of the whole process's page tables to reset), or a bound the arena's own record can't
  give, since a push through a copy of an arena moves the copy's peak and commit, not the arena's.
- **Huge pages, an inference not checked in the kernel's source:** the 9700X's transparent huge pages are `always`, so
  a read of an arena's untouched huge pages maps the kernel's huge zero page. v1 cleared every present page the scan
  didn't report `PFNZERO`; if the scan reports only the 4 KB zero page so, each such read cost v1 a 2 MB clear, which
  then stayed present and was cleared again at every release. v1's `memset` (17.4% of musl's cycles, against v2's 4.7%
  of its instructions with huge pages freed) fits that; v2 freed any huge page instead.

## Correctness (container)

Each version, against main's objects: musl's 1,336 and Lua's 34 objects and diagnostics (Lua with `-Wall -Wextra`) the
same bytes on one lane and on four; `test-lanes`; `test-check-units` (1,489 checks, among them `--poison-arenas`,
`--units-memory=1` and the reservations' failures, with no descriptor left open); `tests/arena/resources.c` as the
hosted job builds it. v3's fault round: three mutants of `arena_pool_writable` (no query past the arena's commit; the
commit, not the whole mapping, without the query; nothing freed), each caught by `test-lanes`, the first two by its new
checks alone.

## Reproducing

```sh
# On the 9700X, in ~/buster-fast-bench/3070-claude: trees base/ (main) and head/ (main and a patch), each built with
scripts/build9700.sh TREE
cp base/build/compiler bin/base; cp head/build/compiler bin/v3
scripts/measure.sh 7 results/piece1-v3 base=$PWD/bin/base v3=$PWD/bin/v3   # takes the lock each round
python3 -I scripts/table.py results/piece1-v3; python3 -I scripts/paired.py results/piece1-v3 base v3
# The profiles: scripts/profile.sh BINARY OUT (empty units and musl, cycles), scripts/profile3.sh OUT NAME=BINARY...
# (musl, user instructions), each under exclusive.sh. The calls' costs: cc -O2 -o walk scripts/walk.c; taskset -c 2 ./walk
```

`scripts/measure.sh` expects `empty/` (1,336 empty `e<N>.c` files, `scripts/setup9700.sh`) and Lua 5.4.8's sources in
`lua/` beside it.
