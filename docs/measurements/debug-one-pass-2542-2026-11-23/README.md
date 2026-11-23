# -g's value DWARF written once (buster#2542, 2026-11-23)

The rest of buster#2542 on the Ryzen 7 9700X (`benchpress`): `check_debug_values_write` no longer runs once to measure
and once to write. The types' DIEs are measured alone, which fixes their offsets; every other DIE and list is written
once into sections that grow; and the references to abstract instances written later are patched at the end. buster#3379's
list memo (`debug-lists-2540-2026-11-23`) goes with the measuring pass.

Release builds by `./build.sh --config Release` with the 9700X's staged clang 23.1.4. Every step ran under its own hold
of `~/buster-fast-bench/exclusive.sh` (`scripts/piece.sh`, `scripts/profs.sh`). `exclusive.sh` reported no other busy
process at any hold (`raw/piece.txt`).

- **Before:** buster `1dac15847055ba722d2b3d90ec3a4dff0c20a8fa` (main, 23 November), the base the change was rebased on.
- **After:** `80eed8df5bab8c6e331f0c762c10a2513440625d`, the head of buster#3434, merged as `7d78a5732baef096a2dcedccb26a0aa3adb711ef`.
- **Inputs:** the frozen corpus `/var/lib/buster-9700x/corpora/preprocessor-391e729af658` (SQLite 3.53.2 amalgamation and
  shell, musl's units), as in `debug-lists-2540-2026-11-23`.

## The bytes

`scripts/compare.sh` compiles with both compilers, by default and with `--tier1`, and compares byte for byte:

- `sqlite3.c` and `shell.c` objects (`-g -c`)
- the shell's executable at one lane and at seven
- every musl unit's `-g -c` object

| options | identical | different | main failed (skipped) |
| --- | ---: | ---: | ---: |
| default | 1,483 | 0 | 45 |
| `--tier1` | 1,483 | 0 | 45 |

With `--tier1`, `sqlite3.o` has 18,113 `DW_TAG_inlined_subroutine` entries and `shell.o` 1,996. These include
instances whose callee is defined after its caller, which take the new patch. The shell runs and prints
`42|3.53.2|1.4142135623730952` (`raw/compare-*.txt`).

## Times (medians of 7, ms; `--time-stages`, one lane, CPU 2)

`scripts/units.sh` (`raw/p2-*-u`):

| | before | after | |
| --- | ---: | ---: | --- |
| `-c -g sqlite3.c`, `debug` stage | 16.583 | 15.602 | −0.98 (−5.9%) |
| `-c -g sqlite3.c`, total | 157.824 | 156.997 | |
| `-c sqlite3.c`, total | 133.202 | 133.314 | (no `-g`: unchanged) |
| `-c -g shell.c`, `debug` stage | 3.685 | 3.477 | −0.21 (−5.6%) |
| `-c -g shell.c`, total | 41.948 | 41.843 | |

The seven runs don't overlap:

- **`sqlite3.c`'s `debug` stage:** 16.379 to 16.787 before, against 15.408 to 15.770 after. The exception is one
  disturbed run after, at 16.728, whose total was 200.9 ms.
- **`shell.c`'s:** 3.663 to 3.696 before, against 3.457 to 3.539 after.

`scripts/stages.sh` (`raw/p2-*-s`): SQLite's shell built from both sources into an executable. These totals mix the
link and lanes, and the plain builds moved by as much as the change.

| | before | after |
| --- | ---: | ---: |
| one lane, `-g` | 210.721 | 209.580 |
| one lane, plain | 183.054 | 183.862 |
| seven lanes, `-g` | 159.677 | 159.251 |
| seven lanes, plain | 142.154 | 142.685 |

## Where the time went

`scripts/prof.sh` (`raw/p2-*-prof`) runs `perf record` at 20 kHz on CPU 2 over five `-c -g sqlite3.c`. Each file
holds the top of the report, and `debug-functions-g.txt` holds every `check_debug` function. The two builds inline
differently:

- **Before:** `check_debug_values` was inlined into `check_debug_build`.
- **After:** `check_debug_values_write` and `check_debug_body_ends` are inlined into `check_debug_values`.

So the comparison is of sums. The values writer and its setup are `check_debug_build` (which held them before) plus
the `check_debug_value*`, `check_debug_values*`, `check_debug_body_ends` and `check_debug_inline*` functions. Their
share of the compile's samples:

| | before | after |
| --- | ---: | ---: |
| writer, setup, lists | 5.10% | 4.51% |
| of which the spans' index and the indexed lists (`check_debug_value_index`, `_range_indexed_clipped`) | 1.17% | 1.27% |
| the line rows (`check_debug_lines`, `_rows_protocol`, `_span`, `_line_scalar`, `_source`, `_name_key`) | 1.65% | 1.72% |

The drop of 0.59 points of a 157 ms compile is about 0.93 ms, the `debug` stage's 0.98. The lists were computed once
already, since buster#3379, and they cost the same. What went is the second walk of the types, declarations, bodies and
inline instances, and the memo's copy. The room checks (`check_debug_value_room`, 0.02%) and the copies of the
sections into the output arena (`memcpy`, 0.04%) cost little.

## What is left in `debug`

Of the 15.6 ms:

- **The line rows**, about 1.7% of the compile.
- **The spans' index and the location and range lists**, about 1.3%. Each function's index is built once, but every
  list walks its tree.
- **The single walk itself**, in `check_debug_values`.

`clear_page_erms` (8.7%, the kernel clearing fresh pages) is the same before and after.
