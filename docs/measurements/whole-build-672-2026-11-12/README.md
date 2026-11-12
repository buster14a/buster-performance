# Where a whole build's time goes beyond `-c`: `-g` and the link (2026-11-12)

[buster#672](https://github.com/buster14a/buster/issues/672)'s one-core designs rest on `-c` without debug
information and stop at the object file. This record measures the rest of a build: what `-g` adds to a compile, what
the link costs, and what the driver does besides (process start, the runtime's snapshot, dependency files), for whole
builds of three programs, and ranks each part by what the build would take without it. It is research: it designs
nothing and changes no compiler code.

- **Source:** buster `4c8c3c9c154640c2edb81271bcd5dc987f2cfa93` (main on 12 November), a clean clone built on the host
  by `./build.sh` (Release, `-O3 -march=native`, debug information), `raw/prepare/build.log`. The executable's SHA-256
  is `a327145a014348e91e3c35dcb1e1a21c59a6f8bad3f9ca30a81a85caa92fd84d`.
- **Host:** the Ryzen 7 9700X (`benchpress`), Linux 6.18.50, clang 23.1.1, tcc 0.9.28rc, GCC 16.2.1, lld 23.1.1,
  mold 3.0.0, GNU ld 2.47, perf 7.2.9. `env.txt` has the kernel, the CPUs, the governors, transparent huge pages, the
  file systems, the tools' versions and every script's, tool's and input's hash.
- **Every run** was one hold of the machine's lock (`scripts/lock.sh`), and each script writes the lock's own line for
  its hold first (`raw/*/holder.txt`). One-core figures are pinned to CPU 2, whose SMT sibling is offline and whose
  governor is `performance`, with the harness that waits for them on CPU 2 too; the others' governor is `powersave`.
- **A run** is a whole process, or a build's processes in turn, by `scripts/tools/procbench.c`: the wall time from the
  process's release to its `wait4`'s return, its user and kernel cycles and instructions (`perf_event_open`, from its
  exec, every thread and child), its peak resident set and page faults. The harness is a child subreaper, so what a
  command leaves behind as it exits (the driver's exit helper, mold's worker) is waited for and counted too. Every
  figure is a median; `tables/*.tsv` have the runs' counts, least and greatest.
- **The outputs** go to tmpfs (`/tmp`), over the files of the run before, as the linker design's numbers do; section 3
  has the tree's own file system (btrfs with zstd) beside it. The runtime's snapshot is in a cache directory of the
  record's own (`XDG_CACHE_HOME`), so that no other tree's compiler rewrites it between runs.
- **Another process computed on the host all day**, outside the lock and not this record's: section 4 and "Limits".

**The workloads**, all from the frozen corpus (`/var/lib/buster-9700x/corpora/preprocessor-391e729af658`) and the
repository's own tests:

- **`sqlite3.c`** (SQLite 3.53.2's amalgamation, 9,507,037 bytes) with the 9700X job's `compile_time` options, the
  one-core record's command: 716,136 preprocessed tokens. For `-g` on a compile.
- **SQLite's shell**, `shell.c` and `sqlite3.c` to the `sqlite3` executable, as `test-sqlite` builds it
  (`sqlite_test.c`'s `sqlite_test_shell_options`, `-lm`): 220,018 and 826,069 tokens. Every executable of this
  record ran `select 6*7, sqlite_version(), sqrt(2.0);` and printed `42|3.53.2|1.4142135623730952`
  (`raw/prepare/objects-runs.txt`).
- **musl 1.2.5** (the corpus's copy, Zig 0.14.1's): its 1,336 units as one command, the one-core record's selection
  (the first source of each base name), for `-g`; and its library as its Makefile selects its sources, 1,343 of them
  (27 in assembly), compiled and linked into a program, for a whole build.
- **synth's shape**: `test-check-units --generate`'s program of 512 units of 200 functions (62 MB of source), which
  calls libc, as one command to a 40 MB executable.

## 1. `-g` on a compile

### `sqlite3.c`

`scripts/run.sh sqlite-g 15` and `sqlite-g-refs 5` (`tables/sqlite-g.tsv`, `sqlite-g-refs.tsv`): `-c` and `-c -g` on
CPU 2, 15 runs of each for this compiler and tcc and 5 for clang and GCC.

| `-c sqlite3.c` | wall ms | with `-g` | `-g` adds | user cycles, M | kernel cycles, M | user instructions, M | peak MB | object bytes |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| buster | 124.5 | 157.7 | 33.2 ms, 26.7% | 601 → 777 | 84 → 90 | 1,347 → 1,722 | 231 → 262 | 2,332,024 → 4,857,704 |
| tcc, `-g` (stabs) | 42.6 | 48.4 | 5.8 ms, 13.6% | 219 → 250 | 16 → 16 | 538 → 624 | 13 → 16 | 2,154,594 → 3,902,556 |
| tcc, `-gdwarf` | 42.6 | 50.8 | 8.2 ms, 19.2% | 219 → 264 | 16 → 15 | 538 → 614 | 13 → 16 | → 4,176,093 |
| clang `-O0` | 575.6 | 868.1 | 292.5 ms, 50.8% | 3,075 → 4,650 | 85 → 134 | 6,646 → 9,135 | 187 → 249 | 1,611,328 → 3,126,856 |
| gcc `-O0` | 1,940.8 | 2,119.4 | 178.5 ms, 9.2% | 10,571 → 11,508 | 154 → 202 | 24,266 → 25,995 | 309 → 324 | 1,549,552 → 2,475,448 |

`-c` is 2.92 times tcc's time and `-c -g` 3.10 times tcc's `-gdwarf`; clang `-O0` takes 4.62 times as long as `-c`
and 5.50 times with `-g`. `-MD -MF` costs nothing that shows (124.57 against 124.53 ms, 0.1 M instructions), and
`-fsyntax-only` takes 102.1 ms, so the backend and the object are 22.4 ms of `-c`. On seven lanes (section 4), the
lanes the bodies' tokens pay for: 113.9 ms and 141.7 ms, 24.4% more, since the stage that holds `-g`'s cost runs on
one lane, after the others.

### By stage

`scripts/run.sh clocks-1 11`: the same compiles with `--time-stages`, 11 of each, each run's report kept
(`raw/clocks-1/`, `tables/clocks/clocks-1/ts-c.tsv` and `ts-c-g.tsv`), medians in ms; and
`scripts/stagecounters.sh 6`, the one-core record's method (six compiles of each under a leader-sampled group with
sample times, each sample put in the stage its time falls in, `tables/stages-c.tsv` and `stages-cg.tsv`), per compile.

| stage | `-c`, ms | `-c -g`, ms | `-g` adds, ms | user cycles added, M | user instructions added, M | mispredicted branches added |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `preprocess` | 9.281 | 10.466 | 1.185 | 5.4 | 20.9 | 5,550 |
| `lower` | 11.501 | 13.784 | 2.283 | 12.6 | 63.0 | 21,528 |
| `tier0` to `code-atoms` (the emission) | 8.560 | 9.802 | 1.242 | 7.5 | 23.5 | 253,569 |
| `debug` | 0.003 | 27.912 | 27.909 | 154.9 | 265.7 | 1,998,200 |
| `object-build`, `object-write` | 0.658 | 1.059 | 0.401 | 1.1 | 3.1 | |
| every other stage | 93.471 | 93.350 | −0.121 | −1.5 | −1.5 | |
| total | 123.474 | 156.373 | 32.899 | 180.0 | 374.6 | 2,284,626 |

- **85% of what `-g` adds is one stage**, `debug`: 27.9 ms, 155 M cycles at 1.7 instructions a cycle, and 2.0 M
  mispredicted branches, a third of the whole compile's 5.9 M.
- **The lowering** runs its copy that keeps each entry's token (`check_lower_drain_sources`, 30.9 M cycles where
  `check_lower_drain` takes 21.9 M), the emission checks and keeps the rows (`check_debug_rows_protocol`,
  `emission_metadata_check`), and the preprocessor keeps its expansion history (`pp_history_change`, and the paths that
  write it: 1.16 ms in `preprocess.main-loop`).

### Inside the `debug` stage

The samples whose time falls in `debug`, by function (`tables/stages-cg.tsv`, `## debug`), per compile:

| function | user cycles, M | instructions, M | mispredicted | what it does |
| --- | ---: | ---: | ---: | --- |
| `check_debug_value_range_indexed_clipped`, `check_debug_value_index`, `_walk`, `_pair`, `_variable` | 50.7 | 110.7 | 817,117 | each lexical block's range list and each local's location list, from the function's code spans |
| `check_program_statement_ends` | 20.2 | 26.2 | 423,959 | the unit's statement ends, derived again for the blocks' scopes |
| `check_debug_values_write` | 20.0 | 46.5 | 309,174 | the types', variables' and blocks' DIEs |
| `check_debug_lines`, `check_debug_span`, `check_debug_line_scalar`, `pp_line_of` | 21.8 | 10.9 | 138,307 | each row's token to its presumed line |
| `pp_diagnostic_lines` | 10.1 | 10.9 | 125,699 | the main file's line starts: two scans of its 9.5 MB, 120,691 fills from DRAM |
| `check_program_emit_timed` (its inlined part of the stage) | 8.9 | 7.8 | 13,511 | |
| `check_debug_build` | 7.3 | 18.6 | 50,565 | the functions, their files and kept rows |
| `memmove`, `memset` | 4.2 | 4.1 | 13,977 | |
| `debug_sections` (debug.c's own emission) | 1.2 | 4.4 | 14,220 | the line program, the address table, the unit's ranges |
| the rest | 10.6 | 25.7 | | |
| the stage | 155.0 | 265.8 | 1,998,703 | |

Three things in it are work done more than once, or for nothing a debugger reads:

- **The value DWARF is built twice.** `check_debug_values` calls `check_debug_values_write` once to measure the DIEs
  and fix their offsets and once to write them (`c_check_debug_values.c`), and each pass computes every range list
  and every location list again. The functions of the first and third rows are 70.7 M cycles for the two passes.
- **The statement ends are derived a second time.** The checker derives them for its own diagnostics in scratch
  memory that is gone by the emission, so `check_debug_values` calls `check_program_statement_ends` again: 20.2 M
  cycles here, and the largest single item of `-g`'s cost on musl (below), since it walks every token of the unit.
- **Every brace pair gets a lexical block.** The object holds 25,473 `DW_TAG_lexical_block` DIEs where clang's holds
  2,191 and GCC's 2,216 (below): each has a range list and, in an object, a relocation. `llvm-dwarfdump --verify`
  passes the object and warns of 10,480 lexical blocks that have no children at all.

### What the objects hold

`scripts/dwarfcensus.sh` (`raw/dwarfcensus/`): each compiler's `-c -g` object of `sqlite3.c` through `readelf` and
`llvm-dwarfdump`.

| | buster | clang `-O0` | gcc `-O0` | tcc `-gdwarf` |
| --- | ---: | ---: | ---: | ---: |
| debug sections, bytes | 1,406,458 | 1,160,713 | 413,535 (compressed) | 980,347 |
| `.debug_info`; `.debug_line`; lists | 625,370; 342,516; 416,874 | 376,164; 596,286; 259 | | 753,541; 129,731; 0 |
| relocations of the debug sections | 46,601 | 14,739 | 21,310 | 43,320 |
| … of `.debug_info` | 41,265 | 5 | 21,276 | 43,186 |
| subprograms; parameters; variables | 2,668; 12,070; 9,283 | 2,668; 7,334; 10,730 | 2,717; 7,413; 9,282 | 2,669; 8,096; 9,403 |
| lexical blocks | 25,473 | 2,191 | 2,216 | 18,174 |
| location list entries; line rows | 31,133; 59,847 | 0; 162,825 | 0; 93,523 | 0; 57,642 |
| `llvm-dwarfdump --verify` | no errors; 10,521 warnings | no errors | no errors | 9,084 errors |

- **The names are inline** (`DW_FORM_string`), so `.debug_info` is 1.7 times clang's, which shares them in
  `.debug_str`.
- **A relocation for every list.** A lexical block points at its range list and a local at its location list by a
  section offset (`DW_FORM_sec_offset`), which an object needs a relocation for: 41,265 of them in `.debug_info`,
  990,360 bytes of `.rela.debug_info`. clang's object has 5: its variables' locations are expressions on the frame
  base, valid wherever the frame is, and its addresses and strings are indices.
- **The rows are a third of clang's**, which has a row a column.

### musl

`scripts/run.sh musl-g 7` and `musl-g-refs 3` (`tables/musl-g.tsv`, `musl-g-refs.tsv`): the 1,336 units as one
command on one lane, CPU 2. tcc refuses the 68 units of `src/complex` (`_Complex`), so it and this compiler are also
timed on the other 1,268.

| one command, `-c` | wall ms | with `-g` | `-g` adds | user cycles, M | user instructions, M | objects, bytes |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| buster, 1,336 units | 1,046.5 | 1,104.2 | 57.6 ms, 5.5% | 4,747 → 5,084 | 12,766 → 13,057 | 2,624,496 → 11,855,936 |
| buster, 1,268 units | 981.8 | 1,045.7 | 64.0 ms, 6.5% | 4,464 → 4,817 | 11,982 → 12,361 | 2,520,064 → 11,435,920 |
| tcc, 1,268 units, `-g` (stabs) | 805.6 | 814.7 | 9.1 ms, 1.1% | 3,916 → 4,026 | 13,533 → 13,860 | 3,032,370 → 11,395,402 |
| tcc, 1,268 units, `-gdwarf` | 805.6 | 834.6 | 29.0 ms, 3.6% | 3,916 → 4,128 | 13,533 → 13,888 | → 14,027,134 |
| clang `-O0`, 1,336 units | 12,011 | 12,462 | 450 ms, 3.7% | 47,869 → 50,004 | 83,846 → 85,959 | 2,385,888 → 7,627,544 |

A many-unit command reports its units' stages as one, so the functions' names stand for `-g`'s work here
(`scripts/muslprofile.sh`, `tables/musl-c.tsv` and `musl-cg.tsv`, two profiled runs of each): of the 348 M user cycles
`-g` adds, `check_program_statement_ends` is 133 M (38%), `check_debug_values_write` 89 M, `check_debug_build` 61 M,
the lowering's copy with tokens 16 M more than the plain one, the range and location lists 15 M. musl's units are
headers for the most part (61% of their tokens are at file scope), and the first three walk the unit's tokens, its
declared types and its functions whatever the bodies hold.

## 2. Linking

### The shell's two objects, by each linker

`scripts/run.sh link-shell-1 21` (`tables/link-shell-1.tsv`): the same objects, `shell.o` and `sq.o` by this compiler
(990,496 and 2,770,960 bytes; with `-g` 1,685,448 and 5,744,720) and by clang `-O0` (712,744 and 1,937,640; with `-g`
1,189,064 and 3,725,280), linked as clang's driver links them (its lines, `raw/prepare/clang-dyn.txt` and
`clang-static.txt`): by `link-foreign` with those lines, by the driver (`compiler shell.o sq.o -lm`), and by lld, mold
and GNU ld, each on one thread on CPU 2. Each line runs twice in a row and its first run is left out, so that a run
follows its own command. Wall ms, 21 runs:

| objects, kind | `link-foreign` | the driver | lld | mold | GNU ld |
| --- | ---: | ---: | ---: | ---: | ---: |
| buster's, dynamic PIE | 1.60 | 1.58 | 8.55 | 4.62 | 13.94 |
| buster's, static | 3.48 | 3.60 | 13.86 | 11.76 | 31.70 |
| buster's `-g`, dynamic PIE | 3.81 | 3.75 | 10.02 | 5.67 | 16.92 |
| buster's `-g`, static | 5.91 | 6.01 | 15.28 | 13.04 | 36.95 |
| clang's, dynamic PIE | 1.59 | 1.43 | 8.05 | 4.40 | 12.73 |
| clang's, static | 3.26 | 3.30 | 12.90 | 11.37 | 29.89 |
| clang's `-g`, dynamic PIE | 1.84 | 1.69 | 9.66 | 5.69 | 16.39 |
| clang's `-g`, static | 3.73 | 3.89 | 14.85 | 12.91 | 47.93 |

The driver's link of the shell is 1.58 ms, 5.4 times less than lld's, 2.9 than mold's and 8.8 than GNU ld's, in
4.5 M user and 3.6 M kernel cycles (lld 32.9 M and 11.5 M). The one thing that stands out is its own `-g`: this
compiler's `-g` objects cost its linker 2.2 ms more than its plain ones, where clang's `-g` objects cost it
0.26 ms more than clang's plain ones.

### The link by phase

`link-foreign --time` on the same lines, 11 runs each (`tables/clocks/clocks-1/lft-*.tsv`), ms:

| phase | dynamic | dynamic, buster's `-g` | dynamic, clang's `-g` | static | static, buster's `-g` |
| --- | ---: | ---: | ---: | ---: | ---: |
| resolve (open, indices, headers, symbols, resolve) | 0.304 | 0.316 | 0.327 | 1.154 | 1.274 |
| convert: sections, names, relocations, check | 0.552 | 0.670 | 0.479 | 1.263 | 1.423 |
| convert: debug | 0.003 | 2.053 | 0.270 | 0.101 | 2.036 |
| write (count, dynamic, chunks) | 0.577 | 0.752 | 0.678 | 0.990 | 1.173 |
| release | 0.106 | 0.165 | 0.129 | 0.178 | 0.245 |
| the link | 1.574 | 3.981 | 1.933 | 3.717 | 6.194 |

`convert: debug` is where this compiler's own DWARF costs 2.05 ms and clang's 0.27 ms: the 53,000 relocations of the
two objects' debug sections against clang's 17,000, most of them the lists' section offsets.

The direct path (one command from sources) links in the driver's own stages, `--time-stages`' medians of 11 runs
(`tables/clocks/clocks-1/ts-s-*.tsv`), ms:

| stage | shell, dynamic | with `-g` | synth, dynamic | with `-g` |
| --- | ---: | ---: | ---: | ---: |
| `code-atoms`: the units' merge | 0.486 | 0.834 | 21.006 | 24.486 |
| `runtime`: the snapshot's open, and `-lm`'s import | 0.475 | 0.482 | 0.081 | 0.083 |
| `executable`: binding, `link_check`, the inputs | 0.400 | 0.391 | 4.982 | 5.225 |
| `write` | 0.769 | 1.280 | 12.586 | 24.021 |
| … its `chunks`; `count`; `dynamic` | 0.560; 0.103; 0.050 | 0.739; 0.215; 0.260 | 9.082; 1.268; 1.460 | 11.986; 5.089; 6.043 |
| the four | 2.130 | 2.987 | 38.655 | 53.815 |
| the build (`total`) | 184.955 | 232.644 | 1,819.388 | 2,120.946 |

A static shell from sources goes through the mixed path, since the direct path refuses `-static` with `-lm` (section
6): its link is the clock's `release` stage, 4.42 ms and 6.57 ms with `-g`, which is `link-foreign`'s static link
above. The clock has no stage of its own for it.

### musl's library

`scripts/run.sh musl-build-1 7` (`tables/musl-build-1.tsv`): the library's 1,343 sources in two commands (two pairs
of sources share a base name), then a link of the program (`scripts/inputs/musl_hello.c`), a start file and every
object of the library but two, 1,341 of them (2.6 MB; 11.8 MB with `-g`), with `libgcc.a`. What the driver doesn't
take is in section 6. Every linker's program prints `hello from musl: 0 7 0.333 42`. Wall ms, one thread, CPU 2:

| | `link-foreign` | lld | mold | GNU ld | `ar rcs` of the objects |
| --- | ---: | ---: | ---: | ---: | ---: |
| 1,341 objects, static | 5.33 | 9.51 | 6.35 | 33.15 | 84.4 |
| with `-g` | 11.00 | 16.14 | 11.28 | 54.11 | 94.3 |

`link-foreign`'s 5.07 ms by its own clock (`tables/clocks/musl-build-1/ml-lft.tsv`) are opening the 1,345 files
(2.26 ms), its release (1.20), the conversion (0.71) and the write (0.32): 9.4 M user and 19.4 M kernel cycles. With
`-g` the conversion's `debug` takes 3.26 ms of 10.57. The driver has no archiver: a build that ends in `libc.a` ends
in binutils' `ar`, 84 ms here, 16 times the link.

## 3. Whole builds

### SQLite's shell

`scripts/run.sh shell-1 11` and `shell-refs 3` (`tables/shell-1.tsv`, `shell-refs.tsv`), CPU 2. One command compiles
both units on one lane and links (the direct path); the steps are what a build tool runs, each source's `-c` and the
link of the two objects, and run in turn they take what they take alone (187.8 ms against 187.9).

| ms | dynamic | with `-g` | static | with `-g` |
| --- | ---: | ---: | ---: | ---: |
| **one command** | **185.0** | **232.8** | **187.9** | **237.3** |
| the rest: process start, setup, release and exit | 0.4 | 0.5 | 1.2 | 1.0 |
| preprocess to code: the two units (`lanes`) | 182.5 | 182.5 | 182.3 | 182.3 |
| the `-g` part | | 46.9 in the units, 0.9 in the link | | 47.5 in the units, 2.2 in the link |
| the link | 2.1 | 2.1 | 4.4 | 4.4 |
| dependency files (`-MD`) | under 0.1 | | | |
| **the steps** | **187.0** | **236.8** | **189.0** | **239.0** |
| `-c shell.c` | 39.8 | 48.9 | 39.8 | 48.9 |
| `-c sqlite3.c` | 145.7 | 184.2 | 145.7 | 184.2 |
| the link, by the driver | 1.6 | 3.7 | 3.6 | 6.0 |
| … by lld, mold, GNU ld instead | 8.6, 4.6, 13.9 | 10.0, 5.7, 16.9 | 13.9, 11.8, 31.7 | 15.3, 13.0, 37.0 |
| **clang `-O0`, one command, lld** | 870.5 | 1,292.8 | | |
| its two compiles; its link | 854.9; 15.5 | 1,278.5; 14.3 | | |
| **tcc**, its two compiles | 61.0 | 69.8 | | |

- **The link is 1% of the build**: 2.1 ms of 185.0 from sources, 1.6 of 187.0 from objects.
- **`-g` is 20% of a `-g` build**: 47.8 ms of 232.8, of which the two units' `debug` stages are 40.1 (7.7 and 32.4).
- **The whole build is 4.7 times faster than clang `-O0` with lld**, 5.6 times with `-g`, and takes 3.0 times tcc's
  two compiles (3.4 with `-g`); tcc's own link of the shell fails on this system (`raw/prepare/tcc-link.txt`).
- The one process holds 303 MB at its peak (313 with `-g`), the larger unit's `-c` 256 MB (289).

### musl's library and a program

`scripts/run.sh musl-build-1 7`, CPU 2, one lane: the build is the library's two commands and the link, in turn
(`scripts/muslseq.sh`).

| ms | plain | with `-g` |
| --- | ---: | ---: |
| **the build** | **1,062.9** | **1,127.3** |
| the library's 1,343 units, two commands | 1,046.2 + 6.8 | 1,104.1 + 7.4 |
| the `-g` part | | 58.5 in the units, 5.7 in the link |
| the link of 1,341 objects, `link-foreign` | 5.3 | 11.0 |
| an archive instead (`ar rcs`, binutils) | 84.4 | 94.3 |

### synth's shape

`scripts/run.sh synth-1 5` and `synth-clocks-1 5`, CPU 2, one lane, one command from 512 sources to the executable
(40,440,440 bytes; 65,902,808 with `-g`):

| ms | plain | with `-g` |
| --- | ---: | ---: |
| **the build** | **1,821.5** | **2,119.5** |
| the units (`lanes`) | 1,779.8 | 2,066.5 |
| the `-g` part | | 286.7 in the units, 15.2 in the link |
| the link: merge, runtime, binding, write | 38.7 | 38.7 |
| the same units' `-c` (512 objects written instead) | 1,786.0 | 2,071.3 |

The link is 2.1% of the build, and `-g` 14% of a `-g` build.

### What every command pays

`scripts/run.sh fixed 31`, `cold 11`, `helper 15` and `btrfs 7` (`tables/fixed.tsv`, `cold.tsv`, `helper.tsv`,
`btrfs.tsv`), CPU 2; each of `fixed`'s lines runs twice in a row, its first run left out.

| command | wall ms | user, kernel cycles, M | user instructions, M |
| --- | ---: | ---: | ---: |
| `/usr/bin/true` | 0.132 | 0.19, 0.27 | 0.14 |
| `compiler -dumpversion` | 0.126 | 0.09, 0.30 | 0.03 |
| an empty file's `-c` | 0.500 | 0.66, 1.37 | 0.84 |
| `hello.c`'s `-c` (it includes `stdio.h`) | 1.74 | 4.51, 3.96 | 8.51 |
| `hello.c` to a dynamic executable | 1.57 | 4.09, 3.43 | 8.64 |
| … to a static one | 2.35 | 6.97, 4.81 | 15.23 |
| `hello.o` to a dynamic executable (the mixed path) | 0.59 | 0.77, 1.88 | 0.85 |
| tcc: `hello.c` to an executable | 1.16 | 4.72, 1.29 | 9.34 |
| clang `-O0` with lld: `hello.c` to an executable | 20.4 | 75.4, 28.9 | 130.9 |

- **A link's fixed work is about 0.1 ms dynamic and 1.0 ms static**: by the clock, a hello world's `runtime`,
  `executable` and `write` are 0.061, 0.010 and 0.041 ms, and static 0.113, 0.620 and 0.244.
- **The static link is 3.3 times what it is warm.** `scripts/linkbench.sh` (`raw/linkbench/`) is the repository's
  `benchmark-link --only direct` on CPU 2, which links again and again in one process: its program of one worker in
  four units, as a static executable (741,600 bytes; the hello world's is 740,168), links in 0.294 ms (`open` 0.025,
  `begin` and `end` 0.136, `write` 0.134), where the fresh process above takes 0.977. In a fresh process the
  `executable` stage takes 103 page faults and the resident set grows 6.5 MB in it (the clock's own columns), for a
  program that keeps 0.74 MB of the runtime; the benchmark reports 25 to 48 faults and 3.1 to 3.2 MB a warm link.
  The clock doesn't say whose pages they are, the 8.7 MB snapshot's mapping or the binding's own arenas.
- **The runtime's snapshot saves a link 1.1 ms, a static one 3.8 ms.** With no snapshot to open (`cold`), `runtime`
  takes 1.199 ms where it takes 0.057, and static 3.907 where 0.095: the import, and the snapshot's write (3.3 MB
  and 8.7 MB). A compiler writes it once. The mixed path doesn't use it.
- **`-lm` costs a link 0.41 ms every time**: the shell's `runtime` stage is 0.475 ms where a hello world's is 0.061;
  the library's import isn't in the snapshot.
- **The exit helper** (buster#1444) doesn't show from the same CPU: with it and without (`BUSTER_EXIT_HELPER=0`),
  `-c sqlite3.c` takes 124.5 and 124.3 ms where the harness waits on CPU 2 too, and its work ends 3 µs after the wait
  returns. From CPU 5 (`helper`), the wait returns 0.84 ms before the address space is gone and the compile reads
  123.0 ms against 124.3.
- **btrfs or tmpfs**: `-c -g` 157.7 against 157.2 ms, the shell from sources 184.7 against 184.7, synth 1,826.6
  against 1,814.3. The writes are a file's `pwrite`s into the page cache either way.
- **A few commands of one or two milliseconds differ by 15% in cycles for the same instructions** (`hello.c`'s `-c`
  takes 4.51 M user cycles and its `-c -MD` 3.90 M, for 8.51 M and 8.54 M instructions): one placement each of the
  arguments and the stack. This record doesn't sweep placements; a small command's time here is good to that.

## 4. Eight cores

The lists of this section were written for CPUs 0 to 7 and eight lanes. The host's other process (see "Limits") sat
on one of those CPUs in most of their rounds, and the runs fall in two groups by it: the shell from sources in 139 or
168 ms, its link in 3 or 62 (`tables/shell-8.tsv`). So `scripts/clear.sh` ran each list again on the seven cores that
process was not on as the list began, with seven lanes or threads (`raw/*-clear/`; each `others.txt` says where it was
before and after), and the first table here is those runs': **seven lanes, each with a CPU**. What the first runs met
by accident, the second table measures on purpose.

### Whole builds on seven lanes

`clear.sh` on `sqlite-g-8` (15 runs), `clocks-8` and `shell-8` (11), `link-shell-8` (21), `musl-g-8` (15),
`musl-build-8`, `synth-8` and `synth-clocks-8` (7), and `run.sh shell-refs-8 5` for clang; medians, ms. `shell-8` ran
twice: that process moved onto one of the seven CPUs during the first run (`raw/shell-8-clear/`), so the table has
the second (`CLEAR_TAG=2`, `raw/shell-8-clear-2/`).

| | one lane, CPU 2 | seven lanes | seven lanes, `-g` | `-g` there |
| --- | ---: | ---: | ---: | ---: |
| `-c sqlite3.c` | 124.5 | 113.9 | 141.7 | 1.24 times |
| **SQLite's shell, one command**, dynamic | 185.0 | 139.7 | 172.9 | 1.24 |
| … static | 187.9 | 141.8 | 177.6 | 1.25 |
| … its units (`lanes`); its link, dynamic | 182.5; 2.1 | 136.4; 1.7 | 170.0; 2.4 | |
| its steps: `-c shell.c`; `-c sqlite3.c` | 39.8; 145.7 | 37.0; 132.2 | 44.7; 164.8 | |
| … the link of the two objects, by the driver; lld; mold | 1.6; 8.6; 4.6 | 2.3; 8.0; 5.2 | 4.0; 8.5; 5.5 | |
| … the steps in turn; the two compiles at once, then the link | 187.8 | 172.6; 142.1 | 214.6; 177.1 | |
| clang `-O0`: the two compiles at once, then lld | 870.5 in turn | 691.4 | 1,040.3 | 1.50 |
| **musl's 1,336 units, one command** | 1,046.5 | 221.5 | 229.2 | 1.03 |
| **musl's library and a program** | 1,062.9 | 234.8 | 250.2 | 1.07 |
| … the library's two commands; the link | 1,053.0; 5.3 | 226.1; 6.2 | 233.7; 11.7 | |
| … the link by lld; mold | 9.5; 6.3 | 9.8; 5.7 | 14.7; 7.5 | |
| **synth, one command** | 1,821.5 | 491.8 | 565.7 | 1.15 |
| … its units (`lanes`); its link | 1,779.8; 38.7 | 475.0; 18.3 | 547.2; 30.6 | |

- **The shell's build is its larger unit's.** `-c sqlite3.c` with the shell's options takes 132.2 ms on seven lanes
  and the whole build 139.7, 1.32 times less than on one lane: within a unit only the functions' emission runs on
  lanes, which is the all-core claim's subject on buster#672. The link is 1.7 ms of it.
- **`-g` costs a build on lanes what it costs on one**, 1.24 times: its `debug` stage runs on one lane after the
  others have finished, and is 23.8 ms of the 27.8 ms that `-g` adds to `-c sqlite3.c` there
  (`tables/clocks/clocks-8-clear/8ts-c-g.tsv`).
- **A link of this size gains nothing from lanes.** The two objects' link by the driver takes 2.28 ms on seven lanes
  against 1.58 on one (`link-foreign`, which takes the lanes its objects' bytes pay for, 1.93); lld's seven threads
  take 8.0 ms against one's 8.6, and mold's 5.2 against 4.6.
- **musl's units scale 4.7 times, synth's 3.7 times.** musl's link is 6.2 ms of a 234.8 ms build. mold on seven
  threads links musl's 1,341 objects sooner than `link-foreign` does, 5.7 against 6.2 ms and 7.5 against 11.7 with
  `-g`: the one link of this record that a system linker wins.

### A lane without a CPU

`scripts/clear.sh busy 11` and `clear.sh busy 11 busy` (`tables/busy-clear.tsv`, `busy-clear-busy.tsv`,
`tables/clocks/busy-clear*/`): the shell's links and builds on CPUs 1 to 7 with seven lanes or threads, alone, and
beside one process that computes on CPU 7 all the while (`tools/spin`). 11 runs of each; a link's line runs twice in a
row and its first run is left out. Wall ms, dynamic and static:

| | every lane a CPU | one CPU busy |
| --- | ---: | ---: |
| the link by the driver, `compiler shell.o sq.o -lm` (its session's 7 lanes) | 2.25, 4.33 | **63.1, 127.1** |
| … `--lanes 1` | 2.06, 4.33 | 2.12, 4.18 |
| … `--lanes 2` | 2.09, 3.86 | 2.07, 3.97 |
| `link-foreign`, the lanes its objects pay for (2) | 1.86, 3.56 | 1.89, 3.65 |
| `link-foreign --lanes 7` | 2.02, 3.82 | **62.8, 126.5** |
| lld, 7 threads | 7.99, 12.16 | 8.11, 11.79 |
| mold, 7 threads | 5.00, 8.37 | 5.09, 8.70 |
| **the shell from sources, one command** | 139.9, 143.6 | **173.2, 269.3** |
| … `--lanes 1` | 185.1, 187.6 | 187.8, 190.2 |
| `-c sqlite3.c` (the functions' lanes) | 131.8 | 136.4 |
| … `--lanes 1` | 145.0 | 146.6 |

The one command from sources, dynamic, by its clock (`z-s-dyn`), ms:

| stage | every lane a CPU | one CPU busy |
| --- | ---: | ---: |
| the units (`lanes`) | 136.9 | 141.2 |
| `code-atoms` | 0.47 | 14.31 |
| `runtime` | 0.45 | 0.46 |
| `executable` | 0.33 | 4.25 |
| `write` | 0.43 | 11.47 |
| … its `count`; `layout`; `symbols`; `dynamic`; `open`; `chunks` | 0.08; 0.03; 0.01; 0.02; 0.01; 0.28 | 4.06; 1.03; 1.01; 1.03; 1.00; 2.25 |
| the build (`total`) | 139.2 | 172.1 |

- **With one of its seven CPUs busy, the driver's link of the shell takes 28 times as long**: 63 ms where it takes
  2.3, and 127 where 4.3 static. The static build from sources is then slower on seven lanes than on one, 269 ms
  against 190.
- **It holds the other CPUs meanwhile**: 336 ms of user time for the 63 ms link (10.6 ms with a CPU a lane), 714 ms
  for the static one.
- **Every lane sync costs a millisecond.** A waiting lane holds its CPU in `mwaitx` for up to 1 ms
  (`BUSTER_LANE_WAIT_NANOSECONDS`, `lane.c`) before it sleeps, and the lane it waits for has no CPU to arrive on:
  the write's `layout`, `symbols`, `dynamic` and `open`, a sync each, are 1.0 ms each, and `link-foreign --lanes 7`'s
  resolve, convert and write take 26.5, 21.3 and 14.4 ms where they take 0.65, 0.55 and 0.34 (static, 89.8 ms to
  resolve). `lane.c` guards against lanes that outnumber the CPUs the process may run on
  (`lane_group_shares_cpus`); a CPU that another process computes on is the same shortage, and nothing counts it.
- **The driver's link takes lanes its work doesn't pay for.** `link-foreign` alone takes a lane per 3 MB of its
  objects (buster#594), two here, and doesn't change. The driver gives the same link every lane of its session
  (`check_driver_mixed_link`, `c_driver_mixed.c`: `run.driver.lanes = run.most`), which is `--lanes 7`'s row, and
  the direct path's merge, binding and write run on the session's lanes too.
- **A compile barely notices**: `-c sqlite3.c` goes from 131.8 to 136.4 ms, and the units of the one command from
  136.9 to 141.2. A unit syncs its lanes a few times; a link's phases sync at every step.
- **lld and mold don't change** with their threads a CPU short.
- **The first runs of this section were in that state**, with eight lanes on CPUs 0 to 7 and the other process on one
  of them in most rounds (`tables/shell-8.tsv`, medians): the one command 168.3 ms and 263.4 static, the link by
  the driver 62.0 and 126.1, the steps in turn 234.0, synth 529.8 where seven lanes with a CPU each take 491.8. A
  machine that is doing anything else is in it, and so is a build tool that runs several of these commands at once.

## 5. The ranking

Each cell is a part's time and, after it, the bound: the build's time over the build's time less the part's. `-g`'s
rows are the `-g` build's time over the plain build's. One lane on CPU 2, but for the last row.

| part | SQLite's shell, 185.0 ms | … static, 187.9 ms | musl's library and a program, 1,062.9 ms | synth, 1,821.5 ms | a hello world, 1.57 ms | … static, 2.35 ms |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| the units, preprocess to code: `-c`'s subject | 182.5 ms, 98.6% | 182.3, 97.0% | 1,053.0, 99.1% | 1,779.8, 97.7% | | |
| `-g` | 47.8, **1.26** | 49.5, **1.26** | 64.5, 1.06 | 298.0, 1.16 | 0.01, 1.01 | 0.04, 1.02 |
| … the units' `debug` stages alone | 40.1, **1.21** | | | | | |
| the link | 2.1, 1.012 | 4.4, 1.024 | 5.3, 1.005 | 38.7, 1.022 | 0.11, 1.08 | 0.98, **1.71** |
| … a `-g` build's | 3.0, 1.013 | 6.6, 1.028 | 11.0, 1.010 | 53.8, 1.026 | | |
| … `-lm`'s import, in it | 0.41, 1.002 | | | | | |
| process start, setup, release and exit | 0.4, 1.002 | 1.2, 1.006 | | | 0.13, 1.09 | |
| dependency files | under 0.1 | | | | | |
| a lane without a CPU: seven lanes and one of their CPUs busy, of 173.2 and 269.3 ms | 33.2, **1.24** | 125.7, **1.88** | | | | |

Ranked, with the issue filed for each:

1. **A lane without a CPU, 1.88 and 1.24.** With one of its seven CPUs busy, the shell's static build from sources
   takes 269.3 ms where it takes 143.6, and the dynamic one 173.2 where 139.9; the link of the two objects alone 28
   times as long. Section 4. buster#2545.
2. **A static hello world's link, 1.71.** 0.98 ms of a 2.35 ms build, where the same link warm in one process takes
   0.29 ms (`raw/linkbench/`: `benchmark-link`'s one worker in four units) and a dynamic hello world's 0.11 ms.
   Section 3. buster#2546.
3. **`-g`, 1.26.** 1.27 on `-c sqlite3.c`, 1.26 on the shell, 1.16 on synth, 1.06 on musl, and on seven lanes 1.24,
   1.15 and 1.07; 85% of it one stage on one lane. Sections 1 and 3. buster#2540, and its three concrete defects apart:
   the value DWARF built twice (buster#2542), the statement ends derived again (buster#2544), a lexical block for every
   brace pair (buster#2543).
4. **Everything else is under 1.03.** The driver's link is 1.005 to 1.024 of these builds (1.012 to 1.038 on seven
   lanes), process start and exit 1.002 to 1.006, `-lm`'s import 1.002; dependency files, the exit helper and the
   output's file system don't show. The first link of a new compiler pays the runtime's import and the snapshot's
   write once: 1.2 ms on the shell, 1.1 ms on a hello world (1.7 times that one build) and 3.8 ms on a static one.

Beside the ranking:

- **What a build doesn't use.** A system linker in the driver's place would make the shell's steps 1.04 (lld), 1.02
  (mold) and 1.07 (GNU ld) times as long on one thread, and static 1.05, 1.04 and 1.15. binutils' `ar` over musl's
  objects takes 84 ms, 1.08 of a build that ends in `libc.a`: the driver has no archiver.
- **A regression, not a part** (section 7): musl's `-c` is 1.07 times what it was a few hours before. buster#2547.
- **What stopped a build** (section 6): buster#2548 (`-static` with `-lm`), buster#2549 (`__tls_get_addr`), buster#2550
  (the assembler's displacement) and buster#2551 (`.type NAME,%function`).
- **Not ranked here:** the units themselves. Their one-core side (the node machine, buster#2524, and the lever
  outside it) and their all-core side are claimed on buster#672; this record's `-c` figures are for the bounds only.

## 6. What stopped a build

Not time, but where "as far as the driver takes it" ended. `scripts/defects.sh` has the smallest input of each
(`scripts/inputs/defects/`, `raw/defects/`), by this compiler and by the system's tools beside it.

- **`-static` with `-lm` is refused from sources.** `compiler -static shell.c sqlite3.c -lm`: "unsupported: static
  libraries: …/libm.a is an archive, which the direct path doesn't link yet". The same command with `/usr/lib/libm.a`
  in `-lm`'s place links (through the mixed path) and runs, as does `-static shell.o sq.o -lm`. buster#1470's fix
  moves a `-l` that finds an archive to the mixed path, and this command doesn't take that switch: its probe may
  look for the library without the command's `-static` and find `libm.so` (not traced).
- **`link-foreign` refuses a link that defines `__tls_get_addr`**, as a C library does: "unsupported symbol (TLS
  call)", for a definition alone as for musl's own plain call of it in `dl_iterate_phdr.c`; lld and GNU ld link it.
  The record's musl links leave `dl_iterate_phdr.o` and `__tls_get_addr.o` out, for every linker alike.
- **The assembler refuses a parenthesized displacement**, `mov %ax,(-1-2)(%rdi,%rdx)`: "unclosed address" (musl's
  `src/string/x86_64/memset.s`; GNU as assembles it to `66 89 44 17 fd`). The record's library takes the generic
  `memset.c` instead.
- **File-scope assembly with `.type NAME,%function` is refused**: "unsupported: file-scope assembly the assembler
  doesn't take" (musl's `crt_arch.h`, so `crt1.c`). `.weak`, `.hidden`, the instructions and a call of a C function
  of the unit are taken; the assembler's `.type` takes its type after an `@` alone (`assembler.c`), where GNU as
  also takes `%`. clang compiles the record's `crt1.o`.
- **No shared library from these objects**: the driver refuses `-fPIC` (buster#2101), and `link-foreign -shared` of
  the library's objects refuses their relocations, as it should.
- **`--time-stages` has no stage for the mixed path's link**: a link of objects reports its 2.1 ms as `release`.
- **musl's corpus copy lacks `memcpy` and `memmove`** (Zig supplies its own); `scripts/inputs/musl_missing.c` stands
  in for them. Not the compiler's.
- **tcc can't link on this system** ("libc_nonshared.a: section type conflict", "undefined symbol 'atexit'"), so it
  is timed on its compiles alone. Not the compiler's.

## 7. A regression met on the way

musl's `-c` here retires 12,766 M user instructions where the one-core record, at `d96b2e73` a few hours earlier the
same day, has 11,461 M for the same command: 11.4% more, 8.6% more user cycles, 1,046.5 against 980.0 ms. Function by
function against that record's profile (`raw/musl/work.tsv` there, `tables/musl-c.tsv` here), 1,092 M of the 1,291 M
are `strlen` (+366 M), `pp_prepared_directive` (+287 M), `printf`'s formatting (+278 M), `memcmp` (+55 M),
`strchrnul` (+35 M) and the warning's own functions. Between the two revisions, `8a401302`
(`-Wreserved-macro-identifier`, buster#2530) added `pp_reserved_macro_name` to every `#define` and `#undef`: for
each reserved name outside the command line's definitions it compares the name with 29 feature-test macros by
`strlen` and `memcmp`, then calls `pp_diagnose_group`, which formats the message and reads the command line's
warning options before it learns that the warning is off. `sqlite3.c` pays 8.6 M instructions for it (0.6%). No
build of the revisions between was made: the attribution is the profile's and the diff's, and not all of the cycles
need be this (buster#2532 has 4,496 M user cycles at `ecaf57b5`, two merges before buster#2530's).

## Limits

- **One host, one day, one revision.** Each table is `4c8c3c9c`'s on the 9700X; the lines of a list are run in turn,
  round by round, but tables taken in different holds are not an A/B of anything.
- **Another process computed on the host throughout** (`raw/stray.txt`): another session's orphan, started at 08:16
  UTC outside the lock, free to run on any CPU but the offline one. CPU 2's figures are medians of runs that agree
  within 1% (`tables/*.tsv`'s least and greatest), and the one-core record's `-c` is reproduced within 0.6%; a few
  runs are 20% slow (the greatest of `s-dyn-g`, of `q-static-g`). The eight-core lists are another matter (section
  4): their figures are of seven lanes on the seven cores it was not on, and no figure here is of eight free cores.
- **musl's command has two page states** (buster#2532's correction describes them): two of `m-c`'s seven runs took
  418,189 page faults and 30 to 60 ms more than the others' 343,106. The medians are of the commoner state, which is
  also the one-core record's (343,019 faults), so section 7 compares like with like; instructions don't depend on it.
- **Per-stage counters are sampled** at 100,003 cycles a sample, and a stage's boundary is known to about 0.3 ms.
- **musl's `-g` is attributed by function names**, not by stage.
- **The comparison with clang and GCC is of what each calls `-g`**: clang's rows carry columns and its strings are
  shared; this compiler's DWARF has location lists and a block for every brace pair; GCC's sections are compressed
  by its assembler. tcc's DWARF doesn't pass `llvm-dwarfdump --verify`.
- **The links are of small programs** (2.7 MB, 1.2 MB and 40 MB outputs). The linker design's own record has the
  links of larger generated programs by size.
- **`perf` counts what a process and its children run.** Where a kernel worker tears an address space down (a
  process of six threads or more, lane.c's note), that work is in no figure here.

## Files

- `env.txt`: the host and the identities. `raw/prepare/`: the tree's build, the lists of units, each prepared
  object's and executable's check, the linkers' lines, and what the driver refused.
- `scripts/`: `lock.sh` (the hold), `build.sh`, `prepare.sh` (the inputs), `lists.sh` (every list of commands),
  `run.sh` (one list under `tools/procbench`), `stagecounters.sh`, `muslprofile.sh`, `checks.sh` (`dwarfcensus.sh`,
  `defects.sh` and `sizes.sh` in one hold), `linkbench.sh`, `busy.sh` and `clear.sh` (section 4), `par.sh` and
  `muslseq.sh` (a build's steps), `queue.sh` (the holds in turn; `raw/queue.txt` has their order and times), `env.sh`,
  and the two that run anywhere: `trim.sh`, which cut `raw/` as this record keeps it, and `tables.sh`, which makes
  `tables/` from `raw/`. `scripts/tools/`: `procbench.c` (the harness, from
  `link-foreign-lanes-594-2026-10-27`'s), `medians.c`, `phasemedians.c`, `stagebuckets.c` (the one-core record's
  `stage_reduce.py` in C) and `spin.c`. `scripts/inputs/`: the record's own small programs.
- `raw/`: every run's output as written, by list: `runs.tsv` (a line a run), the captured reports of the clocks'
  lists, `holder.txt` (the lock's line of each hold) and `others.txt` (the busiest other processes before and after
  a run). `raw/lists/` has the lists as they ran. A list's first run on CPUs 0 to 7 is `raw/NAME/` and its run on
  the seven free cores `raw/NAME-clear/` (`busy-free` and `busy-busy` are the first runs of the pair that
  `busy-clear` and `busy-clear-busy` repeat on seven cores). `raw/stagecounters/*.samples.gz` and
  `raw/muslprofile/*.samples.gz` are `perf script`'s samples.
  `llvm-dwarfdump --verify`'s outputs are cut to their counts (`raw/dwarfcensus/*.verify.txt`).
- `tables/`: the reductions.
