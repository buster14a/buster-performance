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
- **Input:** the frozen corpus's `sqlite3.c` with the census's options (716,136 tokens).

**Status:** the census by column and step 1's counts are in. Step 1's tests and its longer A/B, on `sqlite3.c` and on
musl as one command, are still running; this file will say so when they're in.

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

**Faults by column** (`tables/faults-by-column.tsv`): **the arena from 4,169 to 3,076.**
- `sizeof_types` 654 to 318, `tag_types` 346 to 178.
- `declaration_flags` 170 to 1, `parameter_shapes` 162 to 8, `declaration_storage` 138 to 2.
- `static_initializers` 162 to 85, `incomplete_array_types` 136 to 92.
- The rest of the compile is unchanged at 2,733.

**A first A/B on CPU 2 as a whole** (`scripts/cpuwide-ab.sh`, 15 rounds in ABBA order, `raw/results/cpuwide1/`):
- every object is the same bytes;
- page faults 6,993 to 5,900;
- kernel cycles, median, 86.82 M to 85.87 M (means 86.63 M and 86.00 M without main's one outlier);
- user cycles unchanged, 596 M.

So a removed fault was worth about 600 to 900 kernel cycles, not the 2,060 a read fault and 3,131 a second fault that
the census's sampled attribution gave them. That fits `pagecost.c`'s 458 cycles a zero-page read fault in bulk: most
of the faults step 1 removes are reads, and only the zero writes were full faults.
