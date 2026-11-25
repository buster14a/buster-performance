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
- **The hash table's start** (`step1/results/ab-groups.txt`, `builds-ab-groups.txt`): the one-process loop below
  showed `fast_ident_grow` at 2.1% of musl's units' cycles from 16 groups (three growths under a unit's 3,000 to
  4,000 names). From 64 groups (`s1g64`, the choice) the six-header unit takes 3.79 M user cycles where it took 3.89 M
  (`s1h`, the pull request's first head), and musl's build 1,532.5 ms where it took 1,543.7; 128 groups read the same.
- **Seeded faults:** 22 of 22 found by `test-direct` (`step1/faults`), on the first head and on the 64 groups' head.
- **The pull request's final head** (`s1i`, [buster#3593](https://github.com/buster14a/buster/pull/3593) at
  `4a563c27`; `step1/results/ab-s1i.txt`, `builds-ab-s1i.txt`, `stages-s1i.txt`), against main in the same holds: one
  function 0.76 to 0.27 ms (3.49 M to 0.79 M kernel cycles), `stdio.h` and a `printf` 1.19 to 0.68, the six-header
  unit 1.82 to 1.33, `wcwidth.c` 0.99 to 0.47, `sqlite3.c` 17.58 and 17.61 (its preprocess stage 7.324 against main's
  7.346, 7.319 and 7.334); musl's build 1,789.3 to 1,534.9 ms, Lua's 85.61 to 80.91. The corpus's 7,556 units are the
  same again (`step1/equiv/s1i.verdict`).

## The ceiling of a compiler that stays (`resident/`)

What a process a unit costs the direct path, measured without building anything: `scripts/resident.c` is a harness
around `c_direct_try_compile` that compiles a list of units in one process, each with fresh arenas as the driver
would call it (`scripts/resident.sh`, `resident-prof.sh`; step 1's code in both columns). musl's 663 units that the
direct path takes, CPU 2:

| | wall ms | a unit | user cycles | kernel cycles | page faults |
| --- | ---: | ---: | ---: | ---: | ---: |
| a process a unit (the product) | 312.6 | 0.471 ms | 849.9 M | 867.1 M | 168,039 |
| one process, nothing kept between units | 163.9 | 0.247 ms | 572.0 M | 335.4 M | 83,842 |
| one process, 663 empty units | 39.9 | 0.060 ms | 119 M | 101 M | 43,808 |

- **The process is half of a unit's cost** after step 1: 1.9 times from one process alone.
- **Inside the one process, a unit is its preprocessing:** 135 of the 166 ms are the preprocess stage, 16 ms the
  parse and code generation (1,880,204 tokens, 2,836 a unit), 6 ms the arenas' start and 6 ms their release.
- **A fifth of that is before the unit's first byte:** an empty unit costs 0.060 ms, 0.041 of it the predefines' 413
  lines lexed and defined again, the rest two mappings made and released and 66 page faults.
- **A header is system calls:** a unit makes 65 `access` calls, 51 of which fail (the include search asks each
  directory in turn), and opens, maps and unmaps 17 files; `lock_vma_under_rcu`, `__d_lookup_rcu` and the page
  fault's entry lead the kernel's symbols. The kernel is 37% of the loop's cycles.

So a compiler that stays (several units a command, or a server a build) is worth 1.9 times on such a build before it
keeps anything, and what it could keep is most of the rest: the predefines' state (16% of the loop), the arenas'
pages (the 12 ms of start and release, and 126 faults a unit), and the headers' files or tokens (most of the 108 ms
of preprocessing that is not the predefines). None of that is built.

## What a unit that leaves the direct path costs (`bail/`)

`scripts/bail.sh` splits musl's 1,336 units by `-std=gnu99` into the 663 the direct path takes and the 673 that leave
it, and times each group's build by default and by `--no-direct`, a process a unit, 5 rotated rounds on CPU 2 (step 1's
code, `s1i`):

| | wall ms | user cycles | kernel cycles | user instructions |
| --- | ---: | ---: | ---: | ---: |
| the 663 taken, direct | 304.4 | 824.0 M | 847.2 M | 2,244 M |
| the 663 taken, `--no-direct` | 654.7 | 1,991.9 M | 1,618.0 M | 4,246 M |
| the 673 that leave, by default | 1,186.8 | 4,050.4 M | 2,496.0 M | 10,040 M |
| the 673 that leave, `--no-direct` | 902.9 | 3,038.8 M | 1,945.2 M | 7,130 M |
| all 1,336 by `-std=c99` (none taken) | 1,557.9 | 5,026.3 M | 3,567.0 M | 11,378 M |
| all 1,336 by `-std=gnu99` | 1,489.4 | 4,875.6 M | 3,340.5 M | 12,282 M |

- **A unit that leaves costs 0.42 ms more than one that never tried**, 284 ms over the 673: 1.5 M user and 0.8 M
  kernel cycles and 4.3 M instructions a unit. That is as much as the whole direct compile of a unit it takes (0.46 ms).
- **So the 673 take back 284 of the 350 ms the 663 save,** and musl's build is 4.4% faster by `gnu99` than by `c99`
  where it could be 22.5% faster (304 + 903 = 1,207 ms) if leaving cost nothing.
- **Leaving can't be made early:** the direct path preprocesses the whole unit before it compiles any of it, and
  preprocessing is 82% of its time on these units (the one-process loop above). 366 of the 657 bails in the compile
  come at 90% or more of the unit's tokens, and the 260 for inline assembly in a header's `static inline` function
  come when the function is compiled, after the unit's own functions. What would pay is fewer units that leave.

**What they leave for** (`bail/musl-gnu99-bails.tsv`, `scripts/experiment-bail-trace.patch`, `scripts/bail-census-one.sh`):

| construct | units |
| --- | ---: |
| inline assembly: `__syscallN` in `arch/x86_64/syscall_arch.h` (214), `__get_tp` (21), others (25) | 260 |
| `weak_alias(old, new)`: `extern __typeof(old) new __attribute__((__weak__, __alias__(#old)))` | 180 |
| a type: `long double`, `_Complex`, `__int128` in a definition, a call's argument or an initializer | 187 |
| a pragma | 13 |
| other | 33 |

## What the constructs are worth: an emulation (`emul/`)

Before building any of them: musl's headers with the constructs replaced by what the direct path already compiles
(`scripts/emul-overlays.py` writes the overlays from the frozen corpus; `scripts/emul.sh` times musl's 1,336 units by its
own `-std=c99`, a process a unit, 5 rotated rounds, with step 4's compiler `s4b`, which takes `-std=c99`):

| overlay | units direct | wall ms | user cycles | kernel cycles |
| --- | ---: | ---: | ---: | ---: |
| none | 663 | 1,509.6 | 4,959 M | 3,350 M |
| `weak_alias` a plain declaration | 783 | 1,415.9 (-6.2%) | 4,625 M | 3,177 M |
| `__syscallN` and `__get_tp` calls, not inline assembly | 889 | 1,268.5 (-16.0%) | 4,046 M | 2,933 M |
| both | 1,040 | 1,126.6 (-25.4%) | 3,547 M | 2,654 M |

Three units fail to compile with the `weak_alias` overlay (1,333 objects): its declaration conflicts with theirs. The
local census (`scripts/emul-census.sh`) agrees: 663, 783, 889 and 1,040 units direct; with both, 296 still leave, 187
of them for a type.

So inline assembly of the syscall wrappers' shape (a fixed template, register constraints, `register ... __asm__("r10")`
variables) and `weak_alias` (`__typeof` of a declared name, the `alias` attribute) would take musl's build from
1,559.5 ms at main to about 1,127: 28%, most of it from units that stop paying for both paths.

## Step 4: strict `-std=`, `-w` and the comma rule ([buster#3592](https://github.com/buster14a/buster/issues/3592))

`-std=c99`, `c11`, `c17` and `c23` (and `-trigraphs`, `-fno-asm`) and `-w` alone take the direct path. What the strict
modes change for it, as clang and the full pipeline have them: a unit with a trigraph leaves (any `??` and one of
`= ( / ) ' < ! > -` in any file it reads, scanned 64 bytes a step); `asm`, and `typeof` before C23, are identifiers; `G()`
of `#define G(...) g(0, ## __VA_ARGS__)` keeps its comma; and a `main` that doesn't return `int` leaves. Two changes for
every mode came with the comma rule: `F(x,)` keeps the comma of `, ## __VA_ARGS__` (the direct path dropped it, so
`f(x,)` compiled as `f(x)`), and a comma before a variadic argument with tokens pastes nothing (the direct path left the
unit as an invalid paste). That last one let `__VA_ARGS__ ## __VA_ARGS__` of a comma reach a parser that took `, ,` at
file scope, so a declarator without a name (`int , x;`, `int x, ;`, `int (*)(void);`, `[1]`) now leaves too, as the full
pipeline's error.

**Musl's own build** (`strict/builds-c99-s4b.txt`, 5 rotated rounds, `-std=c99`, a process a unit): main 1,559.5 ms,
step 1's code 1,560.6 (no unit taken), step 4's 1,517.3 (663 taken, -2.7%). The objects of the 663 are those the same
compiler writes by `-std=gnu99` (the build's hash `c220221770db` in both). By `gnu99` and for Lua nothing moved
(`strict/builds-gnu-s4b.txt`).

**The corpus against main** (`step4/equiv`: the 7,556 units of the first record's corpus): the same status, diagnostics
and object for every unit but 666: musl's 664 units by `-std=c99` now direct (each object the one `gnu99` writes),
`sqlite3.c` by `-w` now direct, and `tests/preprocessor/cases/0306.c` (`[1]` at file scope) now the full pipeline's
error where main's direct path compiled it.

**The preprocessor against the full one** (`scripts/ppeq-run.sh`, `step4/ppeq`): each unit compiled as written and as
the full preprocessor's `-E -P` text under the same name, by `-std=gnu17`, `-std=c17` and `-std=c23` (musl by `gnu99` and
`c99`). Where both are the direct path's, the objects are the same for every unit but four or five preprocessor cases
in each mode: `#if` arithmetic and queries where the direct path disagrees with clang in every mode, on main too
(`tests/preprocessor/cases/0202.c` a `char16_t` literal's sign, `0308.c` shifts by 64 or more, `0359.c`
`__has_attribute(ext_vector_type)`, `0126.c` raw strings in `__has_warning` under GNU's modes, `0203.c` `u8''` in C23).

## Step 1 after #3594 (`merge/`)

[buster#3594](https://github.com/buster14a/buster/pull/3594) merged first and replaced the two identifier lookups with
one. Step 1's pull request was merged with it (`8d15cd21`): the growing cache read by that lookup, one hash for every
name length as a macro. Against the new main `f74b0b28`, built on the host (`merge/ab-merge.txt`, 21 rounds;
`merge/builds-ab-merge.txt`, 7 rounds):

| | main `f74b0b28` | the merge `s1m` | `s1n` (main's short-name hash) |
| --- | ---: | ---: | ---: |
| one function | 0.77 ms | 0.27 ms | 0.27 ms |
| musl's `wcwidth.c` | 0.92 ms | 0.40 ms | 0.39 ms |
| `sqlite3.c` | 16.78 ms, 217.18 M instructions | 16.73 ms, 220.69 M | 16.57 ms, 219.14 M (`ab-s1n.txt`, its own hold) |
| musl's 1,336 units by `gnu99` | 1,753.6 ms | 1,493.5 ms (-14.8%) | |
| Lua's 34 units | 83.41 ms | 79.61 ms (-4.6%) | |

The merge's objects are main's for every unit of the 7,556-unit corpus (`merge/equiv-merge.verdict`). Its one hash
mixes a short name's length in, which #3594's skipped: 3.5 M instructions on `sqlite3.c` for the same time. `s1n`
keeps #3594's hash up to eight bytes (+1.96 M against main); it follows in the next pull request, since the queue held
the branch. Step 4 on top of it differs from main `f74b0b28` on the same 666 units as before
(`step4/equiv/next.paths`, `next.nonmusl`, `next.musl`); `sqlite3.c` by `-w` writes the object it writes without.

## Step 4 on #3595's fix (`step4r/`)

Step 4 was rebased onto buster#3598, the fix for buster#3595's symbols. It is now `3b9a11794` (the short-name hash) and
`cbc28ee2e` (the language modes). `compiler-sym2` (the fix) and `compiler-s4r` (step 4 on it) were both built on the
host. Each line below is one hold, rotated by round:
- `builds-c99-s4r.txt`: musl by `-std=c99`, 5 rounds;
- `builds-gnu-s4r.txt`: Lua and musl by `gnu99`, 5 rounds;
- `ab-s4r.txt`: the small units and `sqlite3.c`, 11 rounds;
- `stages-s4r.txt`: `sqlite3.c`'s stages, 11 rounds.

| | the fix | step 4 |
| --- | ---: | ---: |
| musl's 1,336 units by `-std=c99` | 1,559.19 ms, 0 direct | 1,502.18 ms, 663 direct (-3.7%) |
| musl's 1,336 units by `gnu99` | 1,495.73 ms | 1,495.52 ms |
| Lua's 34 units | 79.44 ms | 79.71 ms |
| `sqlite3.c` | 16.87 ms, 221.07 M instructions | 16.78 ms, 219.71 M |
| one function, `stdio.h` and a `printf` | 0.24, 0.62 ms | 0.24, 0.63 ms |

- **musl by `-std=c99`:** its 663 direct objects are those `gnu99` writes (the build's hash `c220221770db` in both).
- **The `-std=c99` gain is small.** The units that try the direct path and leave pay for it: 673 of them, at
  ~0.42 ms each (`bail/`), against the 663 that gain. Steps 6a and 6b turn leavers into direct units.
- **`sqlite3.c`'s instructions drop by 1.36 M.** That is the short-name hash, against the one hash of every length.
- **Faults:** the step's two seeded faults that had failed to build were rewritten and are found
  (`faults-rerun.txt`); the other 29 are in `faults-round.txt`.

**The corpus against the fix** (`equiv-against-fix.txt`, `equiv-changed-units.tsv`):
- the same 666 units change as against main before:
  - musl's 664 by `-std=c99` become direct;
  - `sqlite3.c` by `-w` becomes direct;
  - `tests/preprocessor/cases/0306.c` becomes the full pipeline's error;
- 74 of the 664 lose the full pipeline's `-Wshift-op-parentheses` from musl's `endian.h`, which the direct path drops
  in every mode, `gnu99` included (buster#3577).

**The symbols against `--no-direct`** (`symbols-summary.txt`, `symbols-kinds-new-direct.txt`): 646 of the 664 have the
full pipeline's symbols. The other 18, and `sqlite3.c` by `-w`, differ only in the kinds buster#3595 leaves:
- a dead `isdigit`;
- `memset` and `memmove`;
- `.data` rather than `.bss`;
- `fabs`.

## Step 6a: GNU's alias attribute, musl's `weak_alias` (`alias6a/`)

A file-scope declaration with `alias("target")` is defined at the unit's end where its target is, as `weak_alias(old, new)`
writes it: `extern __typeof(old) new __attribute__((__weak__, __alias__("old")))`. `typeof(name)` of a declared name is its
type. Measured at `a2d8e3087`, on step 4; the final commit `390a1a986` removes three redundant checks and adds tests,
with the same status, diagnostics and object for every corpus unit. `compiler-s4r` and `compiler-a6` were both built on
the host:

| | step 4 | 6a |
| --- | ---: | ---: |
| musl by `-std=c99`, 5 rounds | 1,501.73 ms, 663 direct | 1,398.24 ms, 784 direct (-6.9%) |
| musl by `gnu99`, 5 rounds | 1,495.85 ms | 1,393.60 ms (-6.8%) |
| Lua's 34 units | 79.78 ms | 79.35 ms |
| `sqlite3.c`, 11 rounds | 16.79 ms, 219.71 M instructions | 16.72 ms, 220.28 M |

**Objects:** Lua's and `sqlite3.c`'s are the same.

**The corpus against step 4** (`equiv-against-step4.txt`, `equiv-changed-units.tsv`): 121 musl units become direct in
each mode, and two test sources (`attributes/0053.c` and `weak-alias-common/attribute.c`). 8 of the musl units (4 in
each mode) lose the full pipeline's warnings, which the direct path drops in every mode (buster#3577):
- `-Wshift-op-parentheses` from `endian.h`;
- `-Wstring-plus-int` in `syslog.c`.

**Caught on the way:** the first build took three test sources the full pipeline rejects:
- `attributes/0054.c` and `0055.c`: an alias, then a definition of its name;
- `0057.c`: two aliases of one name.

It also took `programs/alias-late-attributes/source-text.c`, an attribute after an alias, which the full pipeline warns
of. An alias is a definition, so any later declaration of its name now leaves the direct path (`FastSym.is_alias`).

**The symbols against `--no-direct`** (`symbols-summary.txt`, `symbols-kinds-new-direct.txt`): of the 242 new direct
musl units, 206 have the full pipeline's symbols, and the two test sources do too. The other 36 differ only as
buster#3595 leaves:
- `.data` rather than `.bss`, the alias with its target;
- a dead `isdigit`;
- `memset`.

**Seeded faults** (`faults.py`, `faults-1.txt`, `faults-2.txt`): 31 single-line faults in the new code, each run
against `test-direct`.
- **26 found at once.**
- **One more found** once the count of alias attributes, which refuses an alias anywhere a declaration doesn't record
  it, had tests of its own: a member, a parameter, a block's `static` and automatic objects, a typedef.
- **Three survived because their checks were redundant with that count,** and are gone: the explicit bails for an
  alias on a definition and on an initialized object, and an object-symbol test that repeats `target->defined`.
- **One is equivalent:** an empty operand, which the target's lookup refuses as it refuses any name no declaration has.

## buster#3602's head: #3599's fix, and the pull request against `main` (`pr3602/`)

buster#3602 carries step 4, step 6a and the fix of buster#3599 (a declaration without a type specifier, or with
misplaced storage classes, leaves the direct path), on `main` 20f3573e. Each variant is `main`'s tree and one patch,
built on the host by `build-variant.sh` (Release, znver5); `job-*.sh` are the runs, each measurement under the lock on
its own:
- `main20f`: `main` at 20f3573e;
- `a6`: step 4 and step 6a, as their section above;
- `pr3599`: with the fix's first form, buster 659019c7, which asks every token of a declaration's specifiers for a
  storage class by one test of a bit ahead of the loop's comparisons;
- `pr3599v2`: with its second form, buster 13afbd97, a branch of its own for each storage class's keyword and a byte
  of bits for what the specifiers wrote. buster#3602's head, d8b2c301, adds only a test's bound.

**The first form's cost** (`results/ab-pr3599v2.txt`, 21 rounds of `sqlite3.c`, a process each, CPU 2):

| | `main20f` | `a6` | `pr3599` | `pr3599v2` |
| --- | ---: | ---: | ---: | ---: |
| wall | 16.76 ms | 16.60 ms | 16.80 ms | 16.66 ms |
| user instructions | 221.07 M | 220.28 M | 222.05 M | 220.55 M |

The first form put a test of every token ahead of a chain of comparisons of one token, and clang's Release build no
longer compiled that chain as it had; its checks also read seven fields a declaration. musl's `-std=c99` build
(`results/builds-c99-pr3599v2.txt`): 11,630.8 M instructions at `a6`, 11,669.3 M with the first form, 11,639.2 M with
the second. The objects are the same in every variant.

**The pull request against `main`** (`results/builds-c99-final.txt`, `results/builds-gnu-pr3599v2.txt`; 5 rounds):

| | `main20f` | `pr3599v2` |
| --- | ---: | ---: |
| musl's 1,336 units by `-std=c99` | 1,572.04 ms, 0 direct | 1,413.30 ms, 784 direct |
| musl's 1,336 units by `gnu99` | 1,497.44 ms, 663 direct | 1,393.75 ms, 784 direct |
| Lua's 34 units | 79.85 ms | 79.42 ms |

`results/ab-pr3599.txt` and `results/builds-*-pr3599.txt` are the first form's own run, against `main20f` and `a6`.

## buster#3607: raw string literals, a directive's literals, and step 6b (`pr3607/`)

buster#3607 carries the fix of buster#3600 and buster#3603 (raw string literals leave the direct path, and the rest of
a directive's line is lexed for its literals) and #3592's step 6b (musl's `syscall` and thread-pointer asm). The
variants are built as #3602's section says, each against `pr3599v2` (#3602's head):
- `pr3600`, `pr3600b`, `pr3600c`, `pr3600d`: the fix's four forms. `pr3600` scans for raw prefixes in every block
  of a skipped group; `pr3600b` tests the mode inside that loop; `pr3600c` compiles the loop once for each mode;
  `pr3600d`, buster a29b4d2a, also splits `fast_pp_skip_to_eol` into an inline test of a directive's newline and an
  out-of-line rest;
- `asm6b`, `asm6c`, `asm6d`: step 6b on the second, third and fourth forms. `asm6d` is buster#3607's head, 1c221b32.

**The fix's forms** (musl's 1,336 units by `-std=c99`, a mode without raw strings, 5 rounds; `sqlite3.c` 21 rounds):

| | `pr3599v2` | `pr3600` | `pr3600b` | `pr3600c` | `pr3600d` |
| --- | ---: | ---: | ---: | ---: | ---: |
| musl `c99`, user instructions | 11,639 M | 11,691 M | 11,697 M | 11,664 M | 11,581 M |
| `sqlite3.c`, user instructions | 220.55 M | 221.62 M | 222.14 M | 222.09 M | 221.51 M |

Each form's column is against its own run's `pr3599v2`, within 0.01% of each other. Testing the mode in the loop
(`pr3600b`) saved nothing. Compiling the loop once for each mode (`pr3600c`) took half the cost out. Splitting the
line's skip (`pr3600d`) took the rest: its literals had made `fast_pp_skip_to_eol` save seven registers on every call,
after nearly every directive, and most directives now pay an inline test of their newline. `sqlite3.c`, in a GNU
mode, keeps 0.43% of its instructions for the raw strings its skipped groups are scanned for, at the same wall time.

**The pull request** (`results/ab-pr3600d.txt`, `results/builds-*-pr3600d.txt`):

| | `pr3599v2` | `pr3600d` | `asm6d` |
| --- | ---: | ---: | ---: |
| musl's units by `-std=c99` | 1,398.49 ms, 784 direct | 1,404.68 ms | 1,104.23 ms, 1,042 direct |
| musl's units by `gnu99` | 1,393.98 ms | 1,399.81 ms | 1,099.05 ms |
| Lua's 34 units | 79.57 ms | 80.15 ms | 79.63 ms |
| `sqlite3.c` | 16.73 ms | 16.72 ms | 16.69 ms |

Step 6b's 258 more direct units in each mode take musl's build from 11,639 M user instructions to 9,028 M by `c99`.
Its objects are the same as `pr3599v2`'s except those 258 units', and Lua's and `sqlite3.c`'s are the same throughout.

## #3592's dependency files: `-MD` and its kin on the direct path, and `-H` off it (`pr-md/`)

The change (buster `ec374d4e` and `4db3a75d`, on #3607's head `ecb3d69a`; rebased on `main` as `def779dd` and `235f5a11`, in buster#3615) lets `-MD`, `-MMD`, `-MF`, `-MT`, `-MQ`
and `-MP` take the direct path, with the full pipeline's rule, and keeps `-H` off it (buster#3612). The variants are
built as #3602's section says:
- `asm6d`: #3607's head before its MemorySanitizer fix (`1c221b32`, which `ecb3d69a` changes only in a test's `#if`);
- `md1`: the change (`md1.patch`, the diff from `main` `f74b0b28` to buster `5f9d07fd`, the change before its rebase
  on `ecb3d69a`);
- `md2`: `md1` with the functions that only a unit collecting records runs marked `cold, noinline` (`md2.patch`, the
  pull request's code);
- `pad48`: `asm6d` with a function of 48 nops ahead of the lexer's code (`pad48.patch`): a placement change alone.

**With `-MD`** (`results/ab-md1-deps.txt`, `results/builds-*-md1-deps.txt`; `ab.sh` takes `AB_FLAGS` and
`builds-ab.sh` `DEP_FLAGS` for it, each unit's rule beside its object):

| | `asm6d` | `md1` |
| --- | ---: | ---: |
| musl's 1,336 units by `-std=c99` | 1,593.87 ms, 0 direct | 1,144.46 ms, 1,042 direct (-28.2%) |
| their user instructions | 11,392 M | 9,059 M |
| Lua's 34 units | 128.55 ms, 0 direct | 81.03 ms, 29 direct (-37.0%) |
| `sqlite3.c` | 111.73 ms | 16.99 ms (6.6 times) |
| `six.c` (six libc headers) | 3.20 ms | 1.44 ms |

The 1,336 rules of musl's build hash alike in both columns (`33f84b352492`), and so do Lua's 34 (`0c2de19b395e`).

**Without** (`results/ab-md1.txt`, `results/builds-*-md1.txt`): the objects are the same.

| | `asm6d` | `md1` |
| --- | ---: | ---: |
| musl's units by `-std=c99` | 1,104.93 ms, 9,028.3 M instructions, 473,543 faults | 1,115.13 ms, 9,034.0 M, 478,042 |
| Lua's 34 units | 79.78 ms | 79.78 ms |
| `sqlite3.c` | 16.82 ms, 221.41 M instructions | 16.90 ms, 221.81 M |

`sqlite3.c`'s 0.18% more instructions are the headers it now reads (glibc's `<bits/statx.h>` and
`<bits/unistd_ext.h>` include `<linux/stat.h>` and `<linux/close_range.h>` once `__has_include` is defined). The
musl build's 0.9% is mostly kernel cycles: page faults, 3.4 more a unit by these medians. `faults-by-map.sh`, a
`hello.c` compile under `perf trace -F all` three times each, counts 183 to 185 faults for `asm6d` and 185 to 186
for `md1`, the one more in the executable's code (30 pages to 31). `md2` and `pad48` tell the change's cost from its
code's placement (`results/*-md2.txt`; musl 7 rounds, the units 21):

| without `-MD` | `asm6d` | `pad48` | `md1` | `md2` |
| --- | ---: | ---: | ---: | ---: |
| musl's units by `-std=c99` | 1,103.79 ms | 1,107.47 ms | 1,107.95 ms | 1,107.11 ms |
| their page faults | 473,903 | 474,465 | 476,560 | 475,401 |
| Lua's 34 units | 79.67 ms | 79.86 ms | 79.86 ms | 79.61 ms |
| `sqlite3.c` | 16.70 ms | 16.72 ms | 16.79 ms | 16.80 ms |

A placement change alone (`pad48`) moves musl's build as much as the change does: the change's own cost there is its
5.7 M more instructions (0.06%), the tests it adds where files are opened, skipped and probed. `sqlite3.c`'s 0.5% is its
0.18% more instructions, the headers clang reads too, and their pages. With `-MD`, `md2` against `md1`: musl
1,142.56 ms against 1,145.13 ms, `sqlite3.c` 16.91 against 16.86 ms (`results/*-md2-deps.txt`). The pull request has
`md2`'s attributes (buster `ec374d4e`, rebased as `def779dd`).

**Correctness, outside the 9700X** (`corpus/`, `faults/`, `compile-count.log`):
- `corpus/run.sh` compiles each unit of the 7,556-unit corpus by the default driver and by `--no-direct` in five option
  sets (`-MD`; `-MMD`; `-MD -MP` with `-MF`, `-MT` and `-MQ`; `-MMD -MP -MF`; `-MD -MP -MF` from the source's own
  directory). Every rule is the same, byte for byte, wherever both compile (`rules.summary`, `rules.tsv.xz`). 190 test
  sources have another status by the two paths in every set, and in plain `-c` (`plain.sh`) the same at #3607's head
  as at the change (`status-plain-*.txt`): #3577's. Before `__has_include` was defined, 12 test sources and `sqlite3.c`'s
  `-MD` rules missed glibc's `<linux/stat.h>` and its headers (`run1-before-has-include.summary`).
- Plain `-c` of the corpus by the change: every unit's status, diagnostics and object are #3607's head's
  (`objects.summary`, `objects.tsv.xz`, against `final2` of that head).
- `faults/`: 39 faults seeded in the change, each built with `test-direct` alone (`round1.py`, `round2.py`); 37 found,
  the 2 left equivalent (the device compare, with one device under the test's files; a bail for a guard entry without
  a record, which no reading makes).
- `compile-count.log`: CI's compile count, +0.125% against #3607's head.

## #3592's step 6c: musl's atomics' inline asm (`pr-md/`, `atom1`)

Step 6c (buster `f467f06b`, in buster#3615 after the `-MD` step) takes the thirteen asm shapes of musl's
`arch/x86_64/atomic_arch.h` and the empty templates of `explicit_bzero` and `__libc_start_main`. `atom1.patch` is the
diff from `main` `f74b0b28` to it, built on the host as the other variants are.

**The census** (`atomics/`): `bails-c99-md.tsv` is each of musl's units that leave the direct path by `-std=c99` at
the `-MD` step's head, with its first bail (`experiment-bail-trace.patch`'s trace): 294, of which 59 leave at an asm
statement (31 at `a_cas`). `bails-c99-asm-skipped.tsv` is the same census by a build whose asm parser skips every
statement: 235 leave, so the 59 leave for asm alone. 58 take the direct path with step 6c; `__unmapself.c` leaves at
`CRTJMP`'s jump.

**Against `md2`** (`results/*-atom1.txt`; musl and Lua 7 rounds, the units 21):

| | `md2` | `atom1` |
| --- | ---: | ---: |
| musl's 1,336 units by `-std=c99` | 1,117.77 ms, 1,042 direct | 1,009.81 ms, 1,100 direct (-9.7%) |
| their user instructions | 9,033.9 M | 8,098.8 M |
| musl's units by `gnu99` | 1,100.53 ms | 998.16 ms (-9.3%) |
| Lua's 34 units | 79.46 ms | 79.61 ms |
| `sqlite3.c` | 16.92 ms, 221.81 M instructions | 16.98 ms, 221.73 M |

Lua's and `sqlite3.c`'s objects are the same. The 58 units save 1.86 ms of build each, more than step 6b's 1.14: they
are larger (thread functions).

**Correctness:** `atomics/objects.summary` and `objects-vs-md.txt` are the corpus's objects by step 6c against the
`-MD` step's (`equiv/run.sh`): 117 units change path, full to direct, with the same status (58 of musl's in each mode
and `asm-hlt-body.c`); `pthread_cancel.c` loses a `-Wdeprecated-non-prototype` warning, as #3577 has the direct path
do. `faults-round1.py` and `faults-round2.py` seed 46 faults in step 6c, each built with `test-direct` alone: the second
round reruns the first's survivors after the test was extended; 44 of 45 found, one equivalent, and one that the code
became.
