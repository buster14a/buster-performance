# The direct path in a real build: which units reach it, and what a small unit pays (`c_direct`, buster#2850)

Measured on 2026-11-25 at buster main `56490ed9`, for the question "where is more compile throughput, using the
direct path?". Every earlier record of the direct path measures one unit, the 9.5 MB `sqlite3.c`, by a bare `-c`.
This one measures what a build does: many small units, a process each, with the options builds pass.

- **Host:** `benchpress` (Ryzen 7 9700X), every run under `~/buster-fast-bench/exclusive.sh`, CPU 2, objects on
  `/dev/shm`. Transparent huge pages `always`, defrag `madvise`.
- **Build:** `BUSTER_HOST_ARCH=znver5 ./build.sh --config Release` on the host.
- **Which path wrote an object:** the direct path's objects have `buster direct` in `.comment`.

## What a small unit pays (`scripts/fixed.sh`, `results/fixed-1.txt`)

One process a unit, medians of 15 rounds. `default` is the product as it is. `nothp` is `BUSTER_HUGE_PAGES=0` (the
process takes base pages). `busy` is `BUSTER_TEST_HOST_BUSY=1` (the arenas advised base pages). `nodirect` is
`--no-direct`. `exit` is a static program that returns 0.

| unit | policy | wall ms | user cycles | kernel cycles | page faults |
| --- | --- | ---: | ---: | ---: | ---: |
| `exit` | | 0.06 to 0.09 | 0.11 to 0.17 M | 0.19 to 0.30 M | 27 |
| one function | default | 0.85 | 0.59 M | 4.08 M | 84 |
| | nothp | 0.31 | 0.65 M | 1.03 M | 359 |
| | nodirect | 0.67 | 1.68 M | 2.00 M | 254 |
| `stdio.h` and a `printf` | default | 1.27 | 2.01 M | 5.03 M | 123 |
| | nothp | 0.67 | 1.91 M | 1.77 M | 424 |
| | nodirect | 1.61 | 5.20 M | 3.66 M | 453 |
| six standard headers and a `main` | default | 1.89 | 3.95 M | 6.45 M | 199 |
| | nothp | 1.28 | 3.85 M | 3.24 M | 545 |
| | nodirect | 3.11 | 11.26 M | 5.88 M | 699 |
| musl's `wcwidth.c` | default | 1.02 | 1.40 M | 4.23 M | 95 |
| | nothp | 0.49 | 1.40 M | 1.27 M | 398 |
| | nodirect | 1.55 | 3.95 M | 4.56 M | 458 |
| `sqlite3.c` | default | 17.68 | 85.70 M | 12.15 M | 386 |
| | nothp | 17.98 | 87.40 M | 12.21 M | 2,829 |
| | nodirect | 111.65 | 544.48 M | 74.49 M | 4,776 |

- **A one-function unit spends 3.0 M of its 4.7 M cycles clearing huge pages.** The direct path carves about 55
  tables of fixed capacity out of one 32 MiB mapping. A small unit writes the first page of each, which touches most
  of the mapping's 2 MB regions, and the kernel clears 2 MB for each (`clear_page_erms` is 37.6% of the samples of
  the process in `results/prof-fixed-1.txt`). With base pages the same unit takes 0.31 ms where it took 0.85.
- **With base pages the kernel is still most of it:** 359 faults for one function, about 330 of them the arenas'
  (the 384 KB identifier cache and the 160 KB hash table are written at hashed places, and each table's first page).
- **The user side of an empty unit is the predefines:** `fast_pp_handle_define`, `fast_pp_read_tok`,
  `fast_ident_intern`, `fast_pp_lex_window`, `fast_lex_number` and `strtod` lead the user symbols: about 400
  `#define` lines are lexed and defined in every process.
- **A header costs the kernel about as much as it costs the compiler:** six standard headers add
  2.2 M kernel cycles and 3.2 M user cycles to the one-function unit.
- `sqlite3.c` is the one unit here for which huge pages pay, by 2%.

## Which options reach the direct path (`scripts/flags.sh`, `results/flags.txt`)

A one-function unit, by `-c` and one option. The decision is the driver's (`direct_eligible`), not the host's.

| direct | full pipeline | refused by the driver |
| --- | --- | --- |
| no option, `-O0` to `-O3`, `-Os`, `-fPIC`, `-pipe`, `-D`, `-std=gnu99`, `-std=gnu11`, `-std=gnu17`, `-std=c23`, `-fwrapv`, `-funsigned-char`, `-fno-common`, `-fno-strict-aliasing`, `-fomit-frame-pointer`, `-fno-asynchronous-unwind-tables`, `-pthread` | `-g`, `-Wall`, `-Wextra`, `-w`, any `-W...`, `-MD -MF`, `-std=c89`, `-std=gnu89`, `-ansi`, `-std=c99`, `-std=c11`, `-std=c17`, `-pedantic`, `-fno-omit-frame-pointer`, `-fvisibility=hidden`, `-fstack-protector-strong`, `-fno-builtin` | `-ffunction-sections`, `-fexcess-precision=standard`, `-frounding-math`, `-fno-plt`, `-flto` |

`-MD` is what CMake, Meson and automake pass for every unit, and `-Wall` and `-g` what most projects add. A strict
`-std=c99`, `c11` or `c17` is refused because it turns trigraphs on, whether or not the unit has a `??`.

## Two builds, a process a unit (`scripts/builds.sh`, `scripts/builds-lua.sh`)

A loop of one compiler process a unit on CPU 2, `perf stat` around the loop, medians (5 rounds musl, 9 Lua).

| build | units on the direct path | wall ms | user cycles | kernel cycles |
| --- | ---: | ---: | ---: | ---: |
| Lua 5.4.8 with its Makefile's `-std=gnu99 -O2 -Wall -Wextra` | 0 of 34 | 131.1 | 506.7 M | 218.6 M |
| the same without `-Wall -Wextra` | 29 of 34 | 85.1 | 284.0 M | 186.0 M |
| the same, `BUSTER_HUGE_PAGES=0` | 29 of 34 | 81.7 | 292.7 M | 158.2 M |
| musl's 1,336 units with its `-std=c99` | 0 | 1,561.0 | 5,028 M | 3,580 M |
| the same with `-std=gnu99` | 663 | 1,761.7 | 5,103 M | 4,620 M |
| the same, `BUSTER_HUGE_PAGES=0` | 663 | 1,713.4 | 5,354 M | 4,095 M |

- **Lua's own flags keep every unit off the direct path.** Without the two warning options the build is 1.54 times
  faster, and 40% of what is left is the kernel.
- **musl's own `-std=c99` keeps every unit off it, and admitting them (`gnu99`) makes the build 13% slower:** 673 of
  the units leave the direct path after it has run (`results/musl-gnu99-bail-reasons.txt`: 269 for a token it does
  not compile in a body, 180 and 94 for a type, mostly `long double` and `_Complex`), and the 663 it takes pay the
  huge pages. A musl unit is 6.4 M cycles a process, 42% of them the kernel's.

The Lua loop used the host's own system headers: the frozen corpus's glibc headers have no `bits/stdio.h`, which
`-O2` includes. `results/lua-paths.txt` and `results/musl-gnu99-paths.txt` (from a cloud container, the same
decisions) name each unit's path and, with `scripts/experiment-trace.patch`, the reason it left the direct path.

## What follows from it

For one large unit the direct path is 6.3 times the full pipeline. For a build of small units it is between 0.9 and
1.5 times, because of three things that the large unit hides:

1. **Fixed cost a process:** huge pages (3 M cycles), then page faults on tables written at their first page or at
   hashed places (0.8 M), then the predefines (about 0.4 M).
2. **Reach by options:** `-MD`, `-Wall`, `-g` and a strict `-std=` are what builds pass.
3. **Reach by constructs:** a unit that leaves the direct path pays for both paths.

## Step 1: a small unit's start ([buster#3592](https://github.com/buster14a/buster/issues/3592))

A unit whose main file is under 1 MiB takes base pages for both arenas, and its identifier tables start small (the
hash table at 16 groups, the cache at 2,048 slots) and grow with the names. `step1/` has the readings; the builds
are `scripts/build-variant.sh`'s (main `56490ed9` and patches from `step1/patches`, built on the host in one tree).

| a process a unit, CPU 2, 21 rotated runs (`scripts/ab.sh`, `step1/results/ab-s1g.txt`) | main | `s1g` | |
| --- | ---: | ---: | ---: |
| an empty unit | 0.74 ms, 3.37 M kernel cycles | 0.28 ms, 0.88 M | 2.6 times |
| one function | 0.76 ms, 3.54 M | 0.27 ms, 0.79 M | 2.8 times |
| `stdio.h` and a `printf` | 1.19 ms, 4.45 M | 0.68 ms, 1.71 M | 1.75 times |
| six standard headers and a `main` | 1.83 ms, 5.96 M | 1.35 ms, 3.33 M | 1.36 times |
| musl's `wcwidth.c` | 0.99 ms, 3.95 M | 0.47 ms, 1.10 M | 2.1 times |
| `sqlite3.c` | 17.61 ms | 17.62 ms | |

| a build, a process a unit, 7 rotated rounds (`scripts/builds-ab.sh`, `step1/results/builds-ab-s1g.txt`) | main | `s1g` | |
| --- | ---: | ---: | ---: |
| musl's 1,336 units by `-std=gnu99` (663 direct) | 1,764.4 ms, 5,106 M user, 4,621 M kernel | 1,521.2 ms, 4,983 M, 3,408 M | -13.8% |
| Lua's 34 units without `-Wall -Wextra` (29 direct) | 85.49 ms, 284.7 M, 186.9 M | 81.66 ms, 293.0 M, 157.8 M | -4.5% |

- **Objects:** each unit's hash is the same in both columns, the two builds' objects hash the same together, and a
  7,556-unit corpus (the tests, the c-testsuite, Lua, musl by `c99` and by `gnu99`, SQLite in fourteen option sets;
  1,892 units the direct path's) gives the same status, diagnostics and object for every unit (`step1/equiv`).
- **`sqlite3.c`'s stages** (`scripts/stages.sh`, `step1/results/stages-pad.txt`, 21 rounds of `--time-stages`): the
  preprocess stage reads 7.351, 7.328 and 7.325 ms for main and two copies of it with 16 and 48 bytes of padding
  ahead of the lexer's code, and 7.340, 7.333 and 7.328 for the change and its two padded copies. `s1f`, the same
  code as `s1g` before its tests were added, read 7.453 there: one placement moves the stage 1.6%, the change none.
- **The cache's growth point** (`step1/results/ab-load.txt`, `builds-ab-load.txt`): grown at as many names as slots
  (`s1`), at twice (`s1l2`) and at four times (`s1l4`, the choice). The six-header unit: 4.14 M user and 3.27 M
  kernel cycles, 4.08 M and 3.10 M, 4.04 M and 3.03 M.
- **What is left of a one-function unit** (`step1/results/faults-by-s1-add.txt`): the process's own start is 0.10 to
  0.13 ms and 42 page faults (`--version`); the compile adds 108 faults, a fifth of them the predefines' tokens.
  The six-header unit makes 992 system calls, most of them the include search's (`faults-by-s1-six.txt`).
- **Lua's user cycles rise** (284.7 M to 293.0 M) with base pages, and its kernel cycles fall more.
- **Seeded faults:** 22 of 22 found by `test-direct` (`step1/faults`).
