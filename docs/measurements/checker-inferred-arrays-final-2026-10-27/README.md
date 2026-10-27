# An inferred array's walk at #555's final head: its cost to checking, 2026-10-27

Branch `claude/checker-inferred-arrays` (buster14a/buster, #555) counts the elements of an array whose size its
initializer gives from each element's type (`check_init_root_type`, `c_check_initializer.c`). After nine review rounds
the walk takes binary and logical operators' operands, casts' types, both arms and the condition of a `?:`, a vector's
lanes, and extension vectors' `!` and swizzles. [The previous record](../checker-inferred-arrays-reviews-2026-10-27/README.md)
measured `2c083b8c`; this one measures the final head, three ways:

| Measure | main `51bf882b` | head `be3e7ec1` | change |
| --- | --- | --- | --- |
| `-fsyntax-only` of `sqlite3.c`, user instructions | 1,591,793,356 | 1,591,475,974 | -317,382 (-0.020%) |
| `-fsyntax-only` of `sqlite3.c`, user cycles, one executable per tree | 652.2 M | 656.4 M | +0.65% |
| the same over six code placements, three rounds | 652.7, 650.7, 652.4 M | | -0.13%, +0.16%, +0.11% |
| main's executables again, over the placements | | | +0.06%, +0.10%, -0.08% |
| the same's wall time over the placements | 142.9, 142.6, 142.7 ms | | -0.21%, +0.09%, +0.13% (main again -0.06%, +0.06%, -0.16%) |
| generated arrays, sizes written (`walk/sized.c`), instructions | 1,075,659,588 | 1,075,385,202 | -0.026% |
| generated arrays, sizes written, cycles | 399.0 M | 402.6 M | +0.9% |
| generated arrays, sizes inferred (`walk/inferred.c`), instructions | 1,105,883,873, 2,000 diagnostics | 1,125,234,555, none | |
| generated arrays, sizes inferred, cycles | 392.4 M | 395.8 M | |

**The walk's cost.** `walk/walk_arrays.c` writes 2,000 functions, each with four arrays of four to eight elements
(48,000 in all) of GNU vectors, extension vectors and structs, whose elements are the walk's cases: operators' values,
casts, conditionals, lanes, logic and swizzles. It writes the same arrays with their sizes written (`sized`), so that the
difference between the two files' checking, on one executable, is the inference's. On the head the inferred file runs
49,849,353 more instructions than the sized one, 1,039 per element, 4.6% of checking the file. Its cycles are 1.7% fewer
than the sized file's, so the instructions are the measure here. On main the inferred file runs 30.2 million more
instructions than the sized one and reports 2,000 diagnostics: main's walk miscounts those arrays, which the branch
fixes, so main's inferred row isn't the same work as the head's.

**The cycles.** One executable per tree put the head's checking of `sqlite3.c` at +0.65% cycles with fewer
instructions, and the sized file, which the walk never reaches, at +0.9%. Over six placements of the checker's unit and
what follows it, three copies each, the head is within 0.16% of main in every round, as main's own executables are of
themselves (`ab_placements.log`).

On the 9700X the head passes `test-checker` against clang 23.1.1, 255,205 checks with 0 failures (`test_checker.log`).

## Trees

| Name | Commit | What it is |
| --- | --- | --- |
| `base` | [`51bf882b`](https://github.com/buster14a/buster/tree/51bf882b) | main, the branch's base: the first record's build of it |
| `head` | [`be3e7ec1`](https://github.com/buster14a/buster/tree/be3e7ec1) | the branch after its review rounds |

Each tree was `git archive` of its commit, sent by tar into an empty directory; `source-base.sha256` and
`source-head.sha256` hold the SHA-256 of each of its files, and `inputs.sha256` the executables', the inputs' (the
generated files among them) and the host's kernel and clang. The base's executable is the first record's, hard links of
its directory; the placements' step rebuilt it, byte for byte the same executable as `inputs.sha256` and the previous
record's hold. The head was built with `BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh` (`build_head.log`), the
placements' copies with `./build.sh shifts` (`shifts_*.log`; `shifts.sha256`: twelve executables, all different).

Host: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, CPU 2 at the performance governor. Each build and each run
took the shared lock on its own (`EXCLUSIVE_OWNER=claude-126`); the lock's waiting messages, which name other sessions'
runs, are removed from the logs, which leaves those of runs that printed nothing empty.

## Method

`abI.sh` ran it (`abI.log`), with [#475's record](../char-signedness-475-2026-10-26/README.md)'s inputs and options:
the preprocessor oracle's frozen `sqlite/sqlite3.c` with the pinned gnu17 predefines, `--clang-features`,
`-march=znver5 -std=gnu17 -nostdinc` and the corpus's system directories, `SOURCE_DATE_EPOCH=1792454400`,
`CPATH`/`C_INCLUDE_PATH` unset; the generated files with the same target and system directories:

- the generated files: `cc -std=c17 -O2 -o walk_arrays walk/walk_arrays.c`, then `walk_arrays 2000 > inferred.c` and
  `walk_arrays 2000 sized > sized.c` (`clang -std=gnu17 -fsyntax-only -Werror` accepts both);
- the head's `test-checker`;
- each tree's `-fsyntax-only` of each file once (`drive_*.log` and `walk_*.log`: status 0, and the diagnostics of main's
  inferred file);
- three rounds, each tree in turn, of `perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2` of each
  file's `-fsyntax-only` (`perf.log`);
- `placements.sh` (`placements.log`), as `docs/profiling.md`'s "Builds over their code's placements and copies" has it:
  each tree at shifts of 0, 688, 1376, 2064, 2752 and 3440 bytes of `main_unit_checker.c`'s code and what follows it,
  and `ab --rounds 3 --cpu 2` of `time-runs --runs 3 --copies 3` of `sqlite3.c`'s `-fsyntax-only` over main's six, the
  head's six and main's six again.

## Limits

The generated arrays are one shape of the walk's input, and a walk over a few thousand elements is a small share of a
real program's checking: `sqlite3.c` has inferred arrays of records but none of vectors.
