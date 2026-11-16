# The reader's arena of rare columns: a census by column, and its reads gated (2026-11-16)

Evidence for [buster#1167](https://github.com/buster14a/buster/issues/1167): the claim is comment 6917198165, and the
census with the gate restated is 6917438068. [#2873's census](../kernel-census-2873-2026-11-16/README.md) found the
reader's arena of rare columns (`check_input_sparse_arena`, `c_check_input.c`) the costliest fresh memory a megabyte in
`-c sqlite3.c`: 16.3 MB in 4,169 base-page faults. This record says which columns take those faults, and measures a
change that gates their reads.

- **Source:** buster main `dbf591b9b65322261376df10c190be685390466a`, cloned on the host from the census's tree
  (`../2873-claude/src`). Every tree is that revision with the patches named.
- **Host and runs:** the 9700X, Linux 6.18.50, CPU 2. Each run is one hold of the lock (`scripts/lock.sh`,
  `raw/holds.txt`).
- **Input:** the frozen corpus's `sqlite3.c` with the census's options (716,136 tokens), and musl's 1,336 units as one
  command (the one-core record's selection and options, `scripts/musl-common.sh`).

**In short:**
- Step 1 (buster#2880) takes `-c sqlite3.c`'s faults in the arena from 4,169 to 3,076.
- Paired over 31 rounds, it saves 1.74 M kernel cycles and 1.98 M cycles in all.
- Every object is the same bytes, and the tests pass on both paths.
- **The restated gate, half of the arena's 6.70 M that isn't the binding table's, is not met.** A removed fault was
  worth about 1,600 cycles, not the census's sampled 2,000 to 3,100: most were zero-page reads. What remains is the
  first writes of entries spread over token-indexed columns.

## 1. The census by column

`scripts/columns.patch` is a record-only patch, not merged. With `BUSTER_1167_COLUMNS` set, `check_input_run` writes
each column's address and the arena's bounds; with `BUSTER_1167_DUMP` set too, it writes the arena's bytes at the
reading's end. Two ways of counting:

- **`scripts/columns.sh` and `scripts/tools/sparsecols.c`:** from the dump, each column's entries and the 4 KB pages that
  hold one (`tables/sqlite-columns.tsv`, `raw/results/census/`). The arena is 197 MB pushed, all of it base pages in a
  compile. 2,959 pages hold an entry.
- **`scripts/colfaults.sh` and `scripts/tools/faultcols.c`:** every minor fault of the same compile, with its address
  (`perf record -e minor-faults -c 1 -d`), placed in its column (`raw/results/colfaults-*/`). On main this counts
  **4,169 faults in the arena**, the census's number exactly, and 2,733 in the rest of the compile.

Faults by column on main, with the dump's pages beside them:

| column | faults | pages holding an entry | entries |
| --- | ---: | ---: | ---: |
| the binding table's eleven columns | 1,329 | 1,324 | 1.17 M: 600 to 3,000 a page |
| `sizeof_types` | 654 | 327 | 945 |
| `tag_types` | 346 | 173 | 971 |
| `declaration_bases` | 193 | 192 | 360 |
| `declaration_specifiers` | 185 | 185 | 360 |
| `tag_ends` | 174 | 174 | 971 |
| `declaration_flags` | 170 | 0 | 0 |
| `warning_suppressed` | 170 | 152 | 5,141 |
| `parameter_shapes` | 162 | 7 | 49 |
| `static_initializers` | 162 | 82 | 209 |
| `initializer_finish_next` | 146 | 146 | 249 |
| `declaration_storage` | 138 | 1 | 1 |
| `incomplete_array_types` | 136 | 85 | 128 |
| 18 more columns | 204 | | |

Three kinds of fault:

- **The binding table is a third of the arena and is dense data:** its event columns' used prefixes are full pages.
- **Memos that a walk reads before it writes:** `sizeof_types` and `tag_types` fault each page twice, once on the read
  (the zero page) and once on the write.
- **Columns read, or written zero, where nothing else writes:** `declaration_flags` by the identifiers' vector gather,
  `declaration_storage` by the visibility's read, `parameter_shapes`, `static_initializers` and
  `incomplete_array_types` by writes of zero.

## 2. Step 1: the reads gated, the writes only where they change

The change is buster commit `127e7425` on `claude/brave-noether-7nafoa` (`scripts/step1.patch` is its diff):
- The identifiers' and the flush's vector gathers, and the plain reads of the rare columns, test the rare marks that
  writes already set (`BUSTER_CHECK_RARE`; `check_input_rare_lanes` for sixteen lanes).
- `static_initializers`, `incomplete_array_types` and `parameter_shapes` are written only where they change.
- The memos `sizeof_types` and `tag_types`, and `parameter_shapes`, join the rare columns, whose writers all claim.

**Faults by column** (`scripts/colfaults.sh` on main and on step 1 with `columns.patch`, `tables/faults-by-column.tsv`):
**the arena from 4,169 to 3,076.**
- `sizeof_types` 654 to 318, `tag_types` 346 to 178.
- `declaration_flags` 170 to 1, `parameter_shapes` 162 to 8, `declaration_storage` 138 to 2.
- `static_initializers` 162 to 85, `incomplete_array_types` 136 to 92.
- The rest of the compile is unchanged at 2,733.

## 3. Measured

On CPU 2 as a whole (`perf stat -C 2`, the exit's teardown included), each compile under `waitall`, A and B in ABBA
order, one hold a run:

| `-c sqlite3.c` (`scripts/cpuwide-ab.sh`, `raw/results/cpuwide2/`, 31 rounds) | main | step 1 |
| --- | ---: | ---: |
| page faults | 6,992 | 5,874 |
| kernel cycles, median [quartiles] | 86.71 M [86.10, 87.36] | 84.98 M [84.23, 85.67] |
| user cycles, median | 596.7 M | 597.1 M |

**Paired by round (step 1 less main), median [quartiles]:**
- kernel −1.74 M [−2.18, −1.52];
- user +0.09 M [−1.03, +1.99];
- all −1.98 M [−2.63, −0.67].

Every object is the same bytes. An earlier 15-round run (`cpuwide1`) read −0.95 M kernel at the median.

| musl as one command (`scripts/musl-ab.sh`, `raw/results/musl1/`, 7 rounds) | main | step 1 |
| --- | ---: | ---: |
| page faults | 278,604 | 275,753 |
| kernel cycles, median | 999.3 M | 993.1 M |
| user cycles, median | 2,824.8 M | 2,825.8 M |

All 1,336 objects are the same bytes in every round.

**Peak resident set** (`scripts/peak-ab.sh`, `scripts/tools/peakrss.c`: `wait4`'s `ru_maxrss`, 7 rounds):
- From fresh copies of both executables (`peak2`): main 236,204 KB, step 1 235,792 KB.
- The first run (`peak1`, the build trees' own executables) read 236,208 against 240,536 KB. The whole 4.3 MB was at
  the compile's start (`--time-stages`' `peak-rss-start-kb`: 1,908 against 5,688 KB): the executable's page-cache
  state, a fresh build's against an older one's, not the change.

So a removed fault was worth about 1,600 kernel cycles (1.74 M for 1,093). That is fewer than the 2,060 a read fault
and 3,131 a second fault that #2873's census's sampled attribution gave them, and more than `pagecost.c`'s 458 for a
zero-page read fault in bulk. Of what step 1 removes, about 280 are writes of zero, full faults:
`parameter_shapes` 154, `static_initializers` 77 and `incomplete_array_types` 44. About 810 are reads: of
`declaration_flags`, `declaration_storage` and the memos' first reads.

## 4. Tests

`scripts/tests.sh`, each command in one hold of the lock, from the tree's root (`raw/results/tests/`):
- **The native build:** `test-checker --seed 133` parts 1 to 8, `test-checker-deferred`, `test-check-units` and
  `test-checker-driver --in-process` parts 1 to 8 pass.
  - With the host's own clang (23.1.1, `/usr/bin/clang`), driver parts 2 to 5 each fail 4 checks of the clang
    reference, which expects CI's 23.1.4 (`system-clang-failures/`).
  - With CI's clang first on `PATH` (the build's toolchain), they pass (`tests-dev-clang.txt`).
- **The `x86-64` build** (`HOST_ARCH=x86-64 scripts/build-tree.sh`): the same set passes (`tests-devx.txt`). Its
  readers take the scalar paths, where `check_input_rare_verify` checks that every 64 bytes of the rare columns holding
  other than zeros has a write's mark, the moved columns' among them.

## 5. Against the gate

The gate as restated on buster#1167 (comment 6917438068):

- **The arena's faults and kernel cycles down by at least half of the 6.70 M that isn't the binding table's,
  3.35 M: not met.**
  - Faults: 1,093 of the 2,840 that aren't the binding table's, 38%.
  - Kernel cycles: 1.74 M, 52% of the line.
  - What remains is the first writes of entries spread over token-indexed columns: `sizeof_types` 318 pages for 945
    entries, `declaration_bases` and `declaration_specifiers` about 186 each for 360, `tag_types` and `tag_ends` about
    175 each for 971, `initializer_finish_next` 146 for 249.
  - Moving them takes columns keyed by entry (#1166's sparse columns) or pairs that share a line. Both change the
    deferred reader's TypeId columns (`c_check_deferred.c`), and #2536's windows would bound them anyway.
- **The compile's cycles lower: met.** All cycles −1.98 M, paired.
- **Peak RSS no higher: met.** 412 KB lower, from fresh copies.
- **Objects and diagnostics byte for byte on both paths: met.** Every object is the same, and the tests pass on the
  native and `x86-64` builds.

## Files

- `scripts/`:
  - the census (`columns.patch`, `columns.sh`, `colfaults.sh`);
  - the builds (`build-tree.sh`);
  - the A/Bs (`quick-ab.sh`, `cpuwide-ab.sh`, `musl-ab.sh`, `peak-ab.sh`) and the tests (`tests.sh`);
  - step 1's diff (`step1.patch`).
- `scripts/tools/`: `sparsecols.c`, `faultcols.c`, `peakrss.c`, `waitall.c`.
- `raw/results/`: the census (`census`, `colfaults-*`), the A/Bs (`quick1`, `cpuwide1`, `cpuwide2`, `musl1`, `peak1`,
  `peak2`) and the tests.
- `raw/holds.txt` and the builds' last lines (`raw/build-*.tail.txt`).
- `tables/`: `sqlite-columns.tsv` (the dump by column) and `faults-by-column.tsv` (main against step 1).
