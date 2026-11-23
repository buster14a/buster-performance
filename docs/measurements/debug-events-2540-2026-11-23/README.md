# -g's debug stage: sweeps over events, not tokens (buster#2540, 2026-11-23)

What `-g` adds to SQLite's shell build, and to `-c -g` of its two units, on the Ryzen 7 9700X (`benchpress`),
Release builds by `./build.sh --config Release` with the 9700X's staged clang 23.1.4, every run under
`~/buster-fast-bench/exclusive.sh`.

- **Before:** buster `a891cc0588d75f1f3067bb641ff650afeb05bfa7` (main, 22 November).
- **After:** the same with buster#2540's change (branch `claude/2540-debug-lanes`, commit `5d47763c0da438db0455193d5e47993f383eee92`), which lists the
  unit's declarations, block openings and file-scope roots 16 tokens at a time and visits only those in
  `check_debug_values`' sweeps.
- **Inputs:** the frozen corpus `/var/lib/buster-9700x/corpora/preprocessor-391e729af658`: SQLite 3.53.2's
  `sqlite3.c` and `shell.c` with `test-sqlite`'s shell options (`scripts/units.sh`), and for the byte comparison
  musl 1.2.5's units with the corpus's options.

## Scripts

- `scripts/units.sh TREE TAG RUNS`: `-c` and `-c -g` of each unit, `--lanes 1 --time-stages`, pinned to CPU 2
  (`raw/main-u`, `raw/new-u`, 7 runs each; `load-*.txt` and `ps-*.txt` before and after).
- `scripts/stages.sh TREE TAG RUNS`: the shell, `shell.c` and `sqlite3.c` to an executable, with and without
  `-g`, `--lanes 1` on CPU 2 and `--lanes 7` on CPUs 1-7 (`raw/main-s`, `raw/new-s`, 7 runs each).
- `scripts/prof.sh`: `perf record` of five `-c -g sqlite3.c` (`raw/*-prof/report-*.txt`).
- `scripts/compare.sh OLD NEW`: both compilers' `-g` outputs byte for byte (`raw/compare-and-checks.txt`).
- `scripts/med.sh`: the medians below.

## Results (medians of 7, ms)

| | before | after | |
| --- | ---: | ---: | --- |
| `-c -g sqlite3.c`, `debug` stage | 28.408 | 21.852 | −6.56 |
| `-c -g sqlite3.c`, total | 168.722 | 161.366 | (plain: 132.098 / 131.480) |
| `-c -g shell.c`, `debug` stage | 6.150 | 4.705 | −1.45 |
| `-c -g shell.c`, total | 44.402 | 42.921 | (plain: 36.869 / 36.831) |
| the shell, one lane, `-g` | 224.838 | 216.707 | (plain: 182.484 / 182.339) |
| the shell, seven lanes, `-g` | 169.903 | 162.794 | (plain: 140.366 / 139.632) |

What `-g` adds to the shell's build: one lane 42.4 → 34.4 ms; seven lanes 29.5 → 23.2 ms.

**The bytes:** 1,483 outputs equal (both units' objects, the shell at one and seven lanes, every musl unit both
compile; 45 musl units neither compiles), and the shell prints `42|3.53.2|1.4142135623730952`. `test-check-debug
--cross-check` (4,082 checks), `test-streaming --cross-check` (200, with perf), `test-debug --cross-check` and
`check-call-graph` pass with the new compiler there.

## What is left in `debug` (`raw/new-prof/report-g.txt`, share of five compiles' cycles)

`check_debug_lines` and `pp_diagnostic_lines`, `check_debug_span` (rows' lines: gathers in the history-run and
line-start binary searches) 3.0%; the range and location lists (`check_debug_value_range_indexed_clipped`,
`check_debug_value_index`, walk, pair) 2.3%; `check_debug_body_ends` 1.2%; `check_debug_values_write` 0.95%;
`check_debug_build` 1.2%.
