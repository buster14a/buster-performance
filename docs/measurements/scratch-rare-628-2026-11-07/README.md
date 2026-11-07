# The scratch after the reader, and the rare columns' pages (buster#628), 2026-11-07

This record holds the 9700X measurements of four variants of a follow-up to buster#1647. After buster#1647, the three
plateaus of `-c sqlite3.c`'s resident memory on the VM's peak-map build were:
- the reader's end, 255.9 MB;
- `static-data`'s end, 256.6 MB;
- the backend, 250.0 MB.

None of the variants is in buster: each raises the kernel's cycles, and buster#628 takes a change only where both the
peak and the system time fall. buster's `docs/compile-time.md` ("The scratch after the reader, and the rare columns'
pages") has the reasoning.

## Sources

All four are on [`fb2b4af1`](https://github.com/buster14a/buster/tree/fb2b4af1b93a2122add77ebb434916e21ba4ae6a),
buster#1647's commit, which the tree `cols` built. Their commits reached the host as git bundles and were never pushed.
`patches/` holds them as `git format-patch` made them, so that each tree's source is here.

| tree | commit | what |
| --- | --- | --- |
| `next1` | `ec47b7eb3794a5a2c7025951b7d71c9981203664` | the scratch given back (`arena_discard`) after the reader and after the common warnings, which pop it first (`patches/next/0001`) |
| `next2` | `f7f9f8de619c0ec6f56e7b212a1ebc6d2f561835` | `next1` with a reading in source order's rare columns in base pages, populated by one `MADV_POPULATE_READ` (`patches/next/0002`) |
| `exp4` | `3a999dd43117027300eda50e03a282af474afecb` | the rare columns alone, as in `next2` (`patches/exp4`) |
| `exp3` | `20a125edc3c45e9deafd9252db3abdc0306394ff` | the rare columns, with the scratch after the reader given back only past 96 bytes a token, and the common warnings' pop without a discard (`patches/exp3`) |

`receipts8.txt` and `receipts9.txt` have the host, kernel, CPU 2's governor and EPP, the transparent huge pages'
setting, clang's and perf's versions, every executable's SHA-256 and the input's. The input is the frozen corpus's
`sqlite3.c`, SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`, with the `compile_time` step's
options.

## Method

As in `file-columns-628-2026-11-07`: each tree built with `BUSTER_HOST_ARCH=znver5` under one hold of the lock
(`run/builds/`), then `ab-grants.sh` with **one grant of the lock per measured compiler process**, `taskset -c 2 perf
stat` of each compile with `--time-stages`, the order alternating by round.
- `chain8.sh` ran `cols` against `next2` (7 rounds, `run/ab8/`) and against `next1` (5, `run/ab8n1/`), then `next2`'s
  objects in five modes against `cols`' (`run/objects8/`).
- `chain9.sh` ran `cols` against `exp3` (7 rounds, `run/ab9/`) and against `exp4` (7, `run/ab9r/`), then `exp3`'s
  objects in the same five modes against `cols`' from `objects8/` (`run/objects9/`).

The five modes are `-Wall -Wextra`, `--scalar -Wall -Wextra`, `--lanes 8`, `--lanes 8 --deferred-bodies` and `-g`.
Each `.err` starts with `exclusive.sh`'s notice of whoever held the lock while the compile waited. Leaving those notices
out, as `chain9.sh`'s comparison does, every variant's diagnostics are `cols`' in every mode.

## Results

Every run completed under its own grant, and every object is the same bytes as `cols`'. Medians:

| tree against `cols` | rounds | peak RSS (KiB) | task clock (ms) | user cycles (M) | kernel cycles (M) | faults |
| --- | ---: | --- | --- | --- | --- | --- |
| `next2` | 7 | 258,208 → 239,876 | 124.43 → 125.19 | 601.80 → 589.29 | 87.64 → 104.94 | 5,845 → 6,483 |
| `next1` | 5 | 258,172 → 257,824 | 124.04 → 126.16 | 602.23 → 598.39 | 85.41 → 100.53 | 5,845 → 5,881 |
| `exp4` | 7 | 258,168 → 258,172 | 124.17 → 122.71 | 601.20 → 591.65 | 87.16 → 89.19 | 5,844 → 6,446 |
| `exp3` | 7 | 258,172 → 248,564 | 124.29 → 123.25 | 602.35 → 594.47 | 86.81 → 88.89 | 5,845 → 6,447 |

- **The whole scratch given back** (`next1`) costs 15 M kernel cycles. The stages after the reader push about 64 MB of
  the scratch again before `check_program` gives it back. They found those pages resident, and now fault them in again,
  from huge pages the kernel clears. The common warnings' discard does the same to the backend's pushes.
- **Giving back only the scratch past what they push** (`exp3`'s 96 bytes a token) costs nothing: `exp3`'s kernel
  cycles are `exp4`'s.
- **The rare columns in base pages, populated** (`exp4`) take `check-input` from 48.29 to 46.65 ms, with 9.5 M fewer
  user cycles. They add 2.0 M kernel cycles: the populate maps the zero page at the 5,985 pages that the reader only
  reads, and each of the 688 it writes faults.
- **`exp3`** lowers the peak by 9.6 MB, and the task clock by 1.0 ms, faster in each of the 7 rounds. The kernel's cycles
  are 2.4% more, so it isn't taken.

On the VM's peak-map build (huge pages), the rare columns' pages by column at the reader's end, in base pages without
the populate (reads map the zero page; written pages are exclusively mapped):

| column | pages | read | written |
| --- | ---: | ---: | ---: |
| `specifier_finishes` | 1,388 | 1,388 | 0 |
| `specifier_jobs` | 1,388 | 1,352 | 0 |
| `attribute_bases` | 1,388 | 220 | 0 |
| `vla_scope_ends` | 694 | 694 | 0 |
| `declaration_storage` | 695 | 674 | 1 |
| `declaration_bases` | 694 | 674 | 185 |
| `incomplete_array_types` | 694 | 644 | 141 |
| `builtins` | 348 | 348 | 34 |
| `declaration_flags` | 174 | 174 | 0 |
| `static_initializers` | 174 | 174 | 159 |
| `warning_suppressed` | 174 | 170 | 153 |
| `declaration_abis` | 175 | 110 | 1 |
| `selection_type_ends` | 694 | 14 | 0 |
| `vararg_types` | 695 | 14 | 13 |
| `builtin_type_ends` | 694 | 13 | 0 |
| `designator_valid` | 175 | 10 | 1 |

The reads that reach nearly every page are the expressions' walk's classes, which load `specifier_finishes` and
`builtins` at every token, and the reads at every declaration of the specifier jobs, storage and bases. A mark a token
of the columns' writes, as the reader's sparse marks are, would let those reads skip what nothing wrote. In base pages
the columns would then fault only where they are written, with no populate.
