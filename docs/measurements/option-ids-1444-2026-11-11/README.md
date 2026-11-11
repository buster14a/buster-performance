# Option IDs and feature indices for a compile's start (#1444's item 5), 2026-11-11

Evidence for the pull request from buster14a/buster's `claude/awesome-volta-43z617`, item 5 of
[#1444](https://github.com/buster14a/buster/issues/1444) ("Option matching"): a small compile's fixed start.

On main, the loops that read a compile's arguments compared each argument with `strcmp` against one spelling after
another (`main_information`, `main_preprocessing`, `check_driver_command`, `check_request_scan` with
`check_request_codegen_option` and the `-f`/`-m` admission lists, `pp_parse_options` with `predefines_option` and
`pp_take_family`, `pp_option_takes_value`). Resolving the target then looked fixed feature names up in
`predefines_features` by binary search, each probe a `strlen` and a `memcmp` call (`predefines_target`,
`predefines_apply`, `predefines_text`, `-march=native`'s host detection). The change has two commits:

- **The option IDs** (`400f53ca`): `c_option_table.c` lists the 514 spellings those loops match whole or through an
  argument's first `=`, sorted, each with a canonical ID; each loop looks an argument up once (binary search) and
  compares IDs. `exact == C_OPTION_X` holds exactly where `strcmp(argument, "x") == 0` did, and `joined ==
  C_OPTION_X_EQ` where `strncmp(argument, "x=", ...) == 0` did, so the loops keep their order of tests.
- **The feature indices** (`4fcb6738`): the generator writes `PredefinesFeatureIndex` after the feature table, and
  the compiler's own code names a feature by its index instead of looking its name up.

## Sources

| tree | revision | executables |
| --- | --- | --- |
| `base` | `92da7275dfad08e445cf82f86e8d019e9da8db78` (main when the branch was cut, #1891's merge) | `shifts-base/compiler-{0,1088,2112,3136}` |
| `head` | `4fcb67386ce14c640838a466fd748fa32c8a1a29` (both commits) | `shifts-head/compiler-{0,1088,2112,3136}` |

Each tree is a `git worktree` of the session's clone of buster14a/buster (`scripts/setup.sh`), built on the 9700X by
`scripts/build.sh` under the machine's lock, one hold per tree:
`BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 taskset -c 0-7 ./build.sh shifts --config Release DIR main_unit_checker.c 0 1088 2112 3136`,
four placements of `main_unit_checker.c`'s code. `raw/build-base.log` and `raw/build-head.log` are the builds' logs,
and `raw/hostinfo.txt` has every executable's SHA-256. `base-again` is base's four executables timed again, the A/A
floor.

## Host

`raw/hostinfo.txt`: AMD Ryzen 7 9700X (8 cores, CPUs 0–9 and 11–15 online), Linux 6.18.50-2-lts, CPU 2 on the
`performance` governor and the others on `powersave` with `balance_performance`, transparent huge pages `always`,
clang 23.1.1, perf 7.2.9, glibc 2.44. Every build and measurement ran under the shared lock
(`~/buster-fast-bench/exclusive.sh`), one script's command per hold, pinned to CPU 2 (`taskset -c 2`) as #1444's
records are.

## Inputs

`inputs/`: `empty.c`; `tiny.c` (`int main(void){return 0;}`); `hello.c` (`#include <stdio.h>` and a `printf`); and the
9700X's frozen `sqlite3.c` (`/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite`), with
`-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -I...`. `inputs/spellings.txt` is the option table's spellings,
the differential check's input.

## Runs

- `scripts/run.sh r1` and `r2`: two `time-runs` processes per round (whole fresh processes from two fresh copies of each
  executable, in a Williams design's order over base, head and base-again at four placements): the small units, 40
  runs (3 warm-ups) of each slot (`raw/ab-small-r{1,2}.txt`); `sqlite3.c`'s object, 11 runs (1 warm-up), one copy
  (`raw/ab-sqlite-r{1,2}.txt`).
- `scripts/run-native.sh r1`: the same for `-march=native` (`raw/ab-native-r1.txt`), whose host detection the
  feature indices change.
- `scripts/counts.sh r1`: `perf stat -r` (300, 200 or 10 processes) of base's and head's placement-0 executables, two
  rounds each (`raw/perf-*`).
- `scripts/callgrind.sh` on the cloud container (`raw/container.txt`: 4 CPUs of an Intel Xeon, clang 23.1.6,
  Valgrind 3.22): Callgrind's instructions and each string function's calls by caller (`scripts/strcalls.py`,
  through the functions' IFUNC stubs), for base, the option IDs alone (`400f53ca`'s code) and the head
  (`raw/callgrind/`). Valgrind runs no AVX-512 instruction and the head's ID sets compile to AVX-512 compares, so these
  three are baseline-ISA builds (`BUSTER_HOST_ARCH=x86-64`), unbaked: they build their tables at the start, about 7.4 M
  instructions more than the 9700X's executables run.
- `scripts/optdiff.c` on the container: a differential check of base and head (native builds), comparing exit status,
  standard output, standard error and `-o`'s file byte for byte. Each spelling of the table gives 5 to 7 forms (alone,
  with a separate value, one byte more, one less, `=1`, and for a `=` spelling the values `1`, `native` and `none`),
  each in 11 command templates that reach every loop (`-E -P`, `-E -dM`, `-M`, `-fsyntax-only` before and after,
  `-c`, the information probes, as `-o`'s value, past `--`); then random command lines of one to four forms. `--time-stages`'s
  report, which times the run, is compared with its digits masked (in `r2`; `r1`'s 8 differences are those reports).

## Results

**Instructions** (`time-runs`, user instructions, every placement and copy within 10 of each other):

| input | base | head | change |
| --- | ---: | ---: | ---: |
| empty `-fsyntax-only` | 548,660 | 478,408 | −70,252 (−12.8%) |
| empty `-E -P` | 509,085 | 435,790 | −73,295 (−14.4%) |
| `tiny.c` `-c` | 637,623 | 559,165 | −78,458 (−12.3%) |
| `hello.c` `-c` | 7,549,153 | 7,470,664 | −78,489 (−1.0%) |
| `sqlite3.c` `-c` | 1,233,807,540 | 1,233,697,312 | −110,228 (−0.009%) |
| empty `-fsyntax-only -march=native` | 823,772 | 552,295 | −271,477 (−33.0%) |
| `tiny.c` `-c -march=native` | 881,838 | 624,677 | −257,161 (−29.2%) |

**Whole processes, one at a time** (`time-runs`, medians over placements and copies; the range over placements;
base-again is the A/A floor):

| input | wall base → head | head vs base | floor | user cycles head vs base | floor |
| --- | --- | --- | --- | --- | --- |
| empty `-fsyntax-only`, r1 | 0.546 → 0.527 ms | −3.48% (−8.62% to −1.12%) | −1.03% | −5.47% (−6.73% to −3.94%) | +0.21% |
| empty `-fsyntax-only`, r2 | 0.549 → 0.528 ms | −3.90% (−11.14% to −0.90%) | −1.65% | −6.21% (−7.65% to −4.21%) | −0.67% |
| empty `-E -P`, r1 | 0.391 → 0.374 ms | −4.36% (−8.88% to −1.10%) | −1.13% | −8.09% (−9.58% to −5.85%) | +0.05% |
| empty `-E -P`, r2 | 0.388 → 0.373 ms | −3.89% (−11.51% to −1.51%) | −1.15% | −8.24% (−9.63% to −7.18%) | −0.44% |
| `tiny.c` `-c`, r1 | 0.809 → 0.780 ms | −3.62% (−10.96% to +0.99%) | −1.27% | −4.39% (−5.49% to −3.33%) | −0.57% |
| `tiny.c` `-c`, r2 | 0.811 → 0.784 ms | −3.27% (−12.87% to +1.38%) | −1.96% | −4.19% (−5.12% to −3.56%) | −0.56% |
| `hello.c` `-c`, r1 | 1.770 → 1.738 ms | −1.81% (−10.57% to +5.54%) | −1.36% | −1.78% (−2.44% to −0.99%) | −0.86% |
| `hello.c` `-c`, r2 | 1.747 → 1.720 ms | −1.55% (−9.88% to +2.18%) | −1.48% | −1.36% (−2.04% to −0.72%) | −1.09% |
| `sqlite3.c` `-c`, r1 | 114.372 → 114.315 ms | −0.05% (−0.43% to +0.46%) | +0.05% | +0.07% (−0.34% to +0.35%) | +0.28% |
| `sqlite3.c` `-c`, r2 | 114.414 → 114.412 ms | −0.00% (−0.33% to +0.60%) | −0.14% | +0.05% (−0.26% to +0.65%) | −0.05% |
| `-fsyntax-only -march=native` | 0.621 → 0.548 ms | −11.66% (−16.03% to −8.09%) | −1.44% | −23.55% (−24.62% to −22.18%) | −0.84% |
| `-c -march=native` | 0.866 → 0.788 ms | −8.97% (−15.79% to −4.31%) | −1.92% | −15.26% (−15.80% to −14.78%) | −0.44% |

Base's first placement, the design's first slot, runs slower than its others in every list of both rounds (0.590 ms
against 0.538 to 0.549 for an empty `-fsyntax-only` in r2), and base-again's doesn't: against base-again, the head
takes 2.2% less wall time for an empty `-fsyntax-only`, 2.9% for `-E -P`, 1.4% for `tiny.c` and 0.1% for `hello.c`
(r2), at about the floor's size; with `-march=native`, 10.5% and 7.2% less. The user cycles fall beyond the floor at
every placement for every small input.

**perf stat** of placement 0 (`raw/perf-*`, two rounds of 300 processes, 200 for `hello.c` and 10 for `sqlite3.c`):
user instructions 547,898 → 479,141 for an empty `-fsyntax-only`, 506,714 → 436,462 for `-E -P`, 635,841 → 559,899 for
`tiny.c`, 819,735 → 553,034 with `-march=native`; user cycles 0.468 → 0.428 M, 0.312 → 0.275 M, 0.712 → 0.659 M and
0.703 → 0.473 M; elapsed 0.473 → 0.457 ms, 0.338 → 0.328 ms, 0.612 → 0.610 ms and 0.533 → 0.470 ms. Page faults
339 → 334, 188 → 186, 418 → 418 and 345 → 339 to 354.

**String-function calls** (`raw/callgrind/`, the container's baseline-ISA builds; base → option IDs → head), a
one-line `-c`:

| caller | `strcmp` | `strncmp` | `memcmp` | `strlen` |
| --- | --- | --- | --- | --- |
| `pp_parse_options_inputs` | 205 → 1 → 1 | 20 → 0 → 0 | | 13 → 2 → 2 |
| `predefines_resolve` | 380 → 0 → 0 | | 30 → 30 → 0 | 30 → 30 → 0 |
| `check_driver_command` | 128 → 0 → 0 | 20 → 0 → 0 | | |
| `main_information` | 69 → 0 → 0 | 9 → 0 → 0 | | |
| `main_preprocessing` | 54 → 0 → 0 | | | 0 → 2 → 2 |
| `pp_take_family` | 41 → 0 → 0 | 9 → 0 → 0 | | |
| `check_request_codegen_option` | 36 → 0 → 0 | 26 → 0 → 0 | | 26 → 0 → 0 |
| `check_request_scan` | 30 → 0 → 0 | 6 → 0 → 0 | | |
| `predefines_starts` | | 25 → 0 → 0 | | 25 → 0 → 0 |
| `predefines_target` | 7 → 7 → 0 | | 531 → 531 → 0 | 621 → 621 → 1 |
| `predefines_apply` | | | 285 → 285 → 0 | 325 → 325 → 0 |
| `pp_predefines` | | | 114 → 114 → 0 | 158 → 158 → 28 |
| `check_input_target_supported` | | | 12 → 12 → 0 | 12 → 12 → 0 |

In all, `strcmp` 951 → 9 → 2, `strncmp` 189 → 74 → 74 (the 74 left are `getenv`'s) and `memcmp` 2,469 → 2,469 →
1,497 (the intern table's 1,475 left). Instructions there (`raw/callgrind/totals.txt`): 7,979,930 → 7,954,433 →
7,883,457 for a one-line `-c`, 7,583,183 → 7,565,889 → 7,494,330 for an empty `-fsyntax-only`, and 8,188,315 →
8,144,419 → 7,830,058 with `-march=native`: the feature indices take about three quarters of the saving, and nearly all
of `-march=native`'s.

**Byte-identical behaviour** (`raw/optdiff-r2.txt`, head `4fcb6738`): 2,703 forms in 11 templates, 29,733 command
lines, and 5,000 random command lines: 0 differences in status, output, errors or `-o`'s file. `raw/optdiff-r1.txt`,
the option IDs alone, has 8 differences, all `--time-stages` reports, whose times differ from run to run, and 0 in
3,000 random lines.

## Limitations

- Each result is from one machine, kernel and toolchain. The wall times of the small units differ by about the A/A
  floor's size against base-again; the instructions and user cycles are the effect's measure.
- The Callgrind counts come from the container's baseline-ISA builds, unbaked, and its glibc; their per-caller
  attribution is exact, but their totals include the tables' start-up construction that the 9700X's baked executables
  don't run. The option-IDs executable was built from the working tree that became `400f53ca`, before its tests and
  comments were added.
- The differential check covers the table's spellings, their neighbours and their combinations through the command
  templates above, not every possible argument; in-repo, `test-checker --requests` checks the lookup against a linear
  scan and every option form against main's output.
