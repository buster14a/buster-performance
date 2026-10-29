# x86 semantics' consumers and the form choice on real code, Buster #221

Compiler branch: `claude/solve-221-05ee06` of buster14a/buster, for
[this claim on #221](https://github.com/buster14a/buster/issues/221#issuecomment-6479179650).

The branch puts #221's consumers on its shared rules (Tier 0's computed immediates and the assembler's matcher), covers
every form Tier 0's emitter writes (the x87's, `shld` and `shrd`, the AVX and AVX-512 moves, `vpxord`, `vzeroupper`,
`stmxcsr`, `pushw`'s immediates), changes how the vector resolver looks up and finishes its records, and times the
form choice on Tier 0's own requests. This record measures what that costs and gains on the 9700X: the tables, the
effects and choice loops, the choice on `sqlite3.c`'s functions, `-c` of `sqlite3.c`, and SQLite's speedtest1 with and
without the choices that change the instruction sequence.

## Sources and host

Each tree is a `git archive` of its commit (`trees.txt`), extracted into a fresh directory on the 9700X and built
there by `BUSTER_DEBUG_INFO=0 ./build.sh`, as the 9700X job builds (`logs/build-*.log`, each with the executable's
SHA-256 in `logs/all.out`):

- **main:** `9bb5060ebe347de5c7a0a92ba325a7b14a567788`, the branch's merge base after main was merged in;
- **head:** `cff7bc98934a9e84b12a648325a7378769932c2c`, the measured head: the branch's first two commits
  (`c2885004`, `ec22ef11`), main merged (`e22170c9`), and the fix that keeps `x86_semantics_row` for the units that
  still use it;
- **nosub:** the head with `patches/nosub.patch`: the form choice builds no candidate of another instruction (xor,
  `test r, r`, the narrower test, inc and dec), only the encodings of the same instruction (imm8, the accumulator's
  form, `mov r32` for movabs);
- **final:** `ecb3fcfd64d8a365fa5c88a468787ba40f00cb12`, the head with two commits more: #180's table classifying Tier
  0's 128- and 256-bit `vmovdqu64` and `vpxord` forms (`f1ef2153`), which the assembler's matcher reads (C's inline
  assembly initializes it once per unit with asm statements, as `sqlite3.c` has) and Tier 1's selector, and the scalar
  twin's x87 and vzeroupper resources from a table (`ecb3fcfd`), which no command here but `benchmark-x86-semantics`
  runs.

The first head, `c2885004`, was measured before the effects loop's regression was found: its
`benchmark-x86-semantics` logs against `ba379033` (main then) are in `c2885004/`.

The effects loop's variants are `benchmark-x86-semantics`'s translation unit (`x86_semantics_benchmark.c`, which
includes `x86_semantics.c`, `x86_64_encoder.c` and `branch_sizing_generate.c`) built alone with `patches/variant-main.c`
by `clang -O3 -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing` (`scripts/variants.sh`, its `build`):

- **main:** `ba379033`'s sources, whose benchmark unit is `9bb5060e`'s (`git diff` of the unit's dependencies is
  empty);
- **mainwide:** main with `patches/mainwide.patch`, its effects records looked up by form number;
- **old:** `c2885004`, the first head;
- **head:** `ec22ef11`, whose benchmark unit is `cff7bc98`'s but for `x86_semantics_row`'s `unused` attribute;
- **headgpr:** the head with `patches/headgpr.patch`, its rare lanes counted in a general register;
- **headtable:** the head with `patches/headtable.patch`, the scalar twin's x87 and vzeroupper resources from a table
  (the final head builds the same table's values through macros);
- **final** and **finalmask** (a second series, `scripts/variants2.sh`): `ecb3fcfd`, and it with
  `patches/finalmask.patch`, whose records with an opmask are rare lanes too, so that `known` takes no `vptestnmq`.

The host's receipt (`logs/receipt.txt`): the AMD Ryzen 7 9700X, its kernel, clang, perf, CPU 2's governor and energy
preference, every executable's and object's SHA-256, and the inputs' hashes.

## Method

Every build, test and measurement took the host's lock (`~/buster-fast-bench/exclusive.sh`) for itself: a build, a
suite, or one round of a measurement (`scripts/`). Each measurement is pinned to CPU 2. Rounds run the trees in an
order alternating by round (or rotating, for the variants). The lock's waiting messages, which name other sessions'
and CI jobs' commands and links, are left out of the logs: each locked log starts at its command's first line, and the
scripts' own outputs (`logs/all.out`, `logs/variants2.out`, `logs/final.out`) keep only the lines the scripts print
(`scripts/clean_logs.py`). The order of the scripts: `all.sh` (`build.sh`, then `build2.sh` after a first attempt's
build stopped at a warning, `tests.sh`, `variants.sh`, `sem.sh`, `backend.sh`, `compile.sh`, `speedtest.sh`),
`variants2.sh` beside it, then `final.sh`.

- **Suites** (`tests.sh`): the head's `test-x86-semantics` with and without `--cross-check`, `test-assembler
  --cross-check` and `test-tier0`, each timed by bash's `time` (`logs/tests/`).
- **`benchmark-x86-semantics`** (`sem.sh`): five rounds, each one hold running both trees: the full run, then the
  effects and choice loops alone (`--only`), back to back and after 200 ms of their scalar twins (`logs/sem/`).
- **The effects loop's variants** (`variants.sh`, `variants2.sh`): one hold builds them; then five rounds, each one
  hold running every variant's loop alone (`--only effects-avx512`), back to back and after 200 ms of the scalar twin,
  and main's, the head's and headtable's scalar twin alone (`--only effects-scalar`) (`logs/variants/`,
  `logs/variants2/`).
- **`benchmark-backend-source`** (`backend.sh`) on the 9700X job's frozen `sqlite3.c` with its options: three rounds,
  each one hold running both trees, then the head's choice alone after 200 ms of its scalar twin (`logs/backend/`).
- **`-c` of `sqlite3.c`** (`compile.sh`) with the 9700X job's compile-time options (measure-compile's: `-c
  -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite
  $sqlite/sqlite3.c`): five rounds, each one hold of `perf stat -r 11 -e task-clock,cycles:u,instructions:u` per tree
  (`logs/compile/`).
- **speedtest1** (`speedtest.sh`), #136's harness: SQLite 3.53.2's `sqlite3.c` and `test/speedtest1.c`, each `-c`'d by
  the head and by nosub with `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5
  -DSQLITE_ENABLE_RTREE`, linked by `cc`; one hold builds both, checks their verification hashes and records `size`
  and the hashes; then three holds of five rounds each, every round a fresh database on tmpfs for each build in an
  order alternating by round, with `test/speedtest.tcl`'s options at `--size 5`; then one hold of `perf stat`
  (`logs/speedtest/`).
- **The final head** (`final.sh`): one hold builds it; three rounds of the same `-c` by main and the final head, each
  run's status logged; one hold of `benchmark-x86-semantics` by each (`logs/final/`).

## Results

### The head's suites

All passed (`logs/tests/`): `test-x86-semantics --cross-check` in 0.218 s and without it in 0.195 s,
`test-assembler --cross-check` (1,890,554 checks) in 2.159 s and `test-tier0` (7,185,799 checks) in 2.142 s. At the
head, the semantics harness lists 9 covered forms it doesn't execute: the 8 VL forms that #180's table left
unclassified, which the final head classifies, and `endbr64`.

### `benchmark-x86-semantics`, main against the head

Medians of five rounds, per request or record (`logs/sem/`); the effects on -O0's shape, -O2's within 1%:

| Path | Main | Head | Head alone (`--only`) | Head after 200 ms of the scalar twin |
| --- | ---: | ---: | ---: | ---: |
| choose, scalar | 48.75 cycles | 49.30 cycles | | |
| choose, AVX-512 | 3.32 cycles | 3.32 cycles | 3.32 cycles | 3.33 cycles |
| effects, scalar | 49.63 cycles (164.63 instructions) | 49.04 cycles (189.88) | | |
| effects, AVX-512 | 5.84 cycles (31.38 instructions) | 5.45 cycles (23.63) | 5.44 cycles | 5.45 cycles |
| `x86_encode` of the same records | 3.25 cycles | 3.26 cycles | | |

The scalar choice's code and instructions are main's: its 1% is placement. `x86_semantics_initialize` takes 45,852
cycles (8.3 µs) against main's 37,636 (6.8 µs), and the tables hold 712 covered forms against 612, with the lookup
by form number's 65,536 bytes besides.

### The effects loop's variants

`--only effects-avx512`, five processes each in a rotating order, medians of their medians in cycles per record
(-O0's shape, -O2's), with each loop's instructions and IPC (`logs/variants/`, `logs/variants2/`):

| Loop | Back to back | After 200 ms of the scalar twin | Instructions | IPC |
| --- | ---: | ---: | ---: | ---: |
| main | 5.85, 5.90 | 5.83, 5.88 | 31.38 | 5.36 |
| mainwide | 5.24, 5.30 | 5.24, 5.32 | 23.25 | 4.43 |
| old (the first head) | 7.11, 7.12 | 7.03, 7.10 | 35.66 | 5.02 |
| headgpr | 5.53, 5.61 | 5.55, 5.63 | 23.88 | 4.32 |
| head | 5.44, 5.49 | 5.44, 5.52 | 23.63 | 4.35 |
| headtable | 5.45, 5.49 | 5.45, 5.52 | 23.63 | 4.33 |
| final (second series) | 5.42, 5.50 | 5.45, 5.50 | 23.63 | 4.36 |
| finalmask (second series) | 5.45, 5.54 | 5.47, 5.52 | 24.13 | 4.42 |

The scalar twin alone (`--only effects-scalar`): main 48.81 and 48.28 cycles per record at 164.63 instructions, the
head 47.97 and 47.51 at 189.88, headtable 46.74 and 46.27 at 178.99. The final head's full run gives its scalar twin
49.70 cycles at 178.99 instructions beside the vector loop's 5.43 (`logs/final/sem-final.log`), in the full run's
interleaved state, as main's 49.68 beside it.

### `benchmark-backend-source` on `sqlite3.c`

2,602 functions, 396,872 typed entries, 364,035 records and 1,226,628 bytes of code on both trees. Cycles per typed
entry, the range over three processes, with the instructions per entry (`logs/backend/`):

| Variant | Main | Head |
| --- | ---: | ---: |
| `vector` | 65.58–65.93 (152.43) | 64.48–64.72 (152.82) |
| `scalar` | 178.71–179.30 (531.76) | 176.16–176.31 (528.81) |
| `sizing` | 5.30–5.50 (11.37) | 5.46–5.59 (11.37) |
| `encode` | 3.82–3.84 (14.16) | 3.96–3.98 (14.17) |
| `validate` | 12.72–12.75 (30.03) | 12.87–12.93 (30.09) |
| `validate-scalar` | 45.93–46.20 (129.52) | 46.17–46.92 (129.58) |
| `choose` | | 1.74–1.88 (3.32) |
| `choose-scalar` | | 7.70–7.74 (20.10) |

The choice at the head: 71,198 requests (0.179 per entry); 3.31% kept their template's form, 44.01% took another
encoding of the instruction, 52.69% another instruction; their records' 450,190 bytes became 234,542, 14.95% of the
code they would make with each template's widest form. Alone after 200 ms of its scalar twin, the choice takes 1.42
to 1.51 cycles per entry. Sizing, encoding and validation run main's code at the same instructions; their cycles move
by up to 3.6% with the executables' layout.

### `-c` of `sqlite3.c`

Means of `perf stat -r 11`, medians of five rounds, the range in brackets (`logs/compile/`):

| | Main | Head |
| --- | ---: | ---: |
| user-space instructions | 1,260,248,956 | 1,260,407,943 |
| user-space cycles | 585.62 M (585.40–586.85) | 586.05 M (585.54–587.98) |
| task clock | 123.71 ms (123.64–123.94) | 123.87 ms (123.69–124.05) |

Both write the same object (SHA-256 `9048dda4…`, `logs/receipt.txt`): the shared rule makes Tier 0's hand-picked
choices. The head runs 158,987 more instructions (+0.013%), most of them the frame immediates' calls of
`x86_immediate_encodes` (the backend's +0.39 per entry, 155 thousand); its cycles and time are within main's spread.

The final head, three rounds against main in their own holds (`logs/final/`, every run's status 0): 1,260,426,555
instructions against 1,260,248,954, 585.89 M cycles against 586.34 M (585.66–587.08 against 586.20–586.51), 123.68 ms
against 123.78 ms, the same object again. Its 18,612 instructions more than the head's are the inline-assembly
matcher's index (`check_asm_matches`, once per unit), which takes the 8 forms `f1ef2153` classifies.

### speedtest1, with and without the substitutions

Both builds give the verification hash `a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739` (`logs/speedtest/`):

| | Head | nosub |
| --- | ---: | ---: |
| `sqlite3.o`'s `.text` | 1,559,506 bytes | 1,625,410 bytes |
| `speedtest1.o`'s `.text` | 86,175 bytes | 87,419 bytes |
| the executable's `.text` | 1,689,765 bytes | 1,756,917 bytes |
| run time, the second run of each round (7 and 8 runs) | 256.67 ms | 257.80 ms |
| run time, the fastest of 15 | 256.03 ms | 257.02 ms |
| user-space instructions (`perf stat`, one run) | 5,685,892,126 | 5,685,942,544 |
| user-space cycles (the same run) | 1,320,044,703 | 1,329,035,278 |

The substitutions take 4.1% out of `sqlite3.o`'s code, in as many instructions, and the program runs 0.4% to 0.7%
faster with them. The first run of each round, after the lock's other holders, is the slower one whichever build it
is (`runs.txt`: 257.8 to 280.8 ms).

## Limitations

- One machine and one file of each corpus: the frozen `sqlite3.c` for `-c` and the backend, SQLite 3.53.2's for
  speedtest1.
- The variants are the benchmark's unit built alone, whose code lands elsewhere than in `build/compiler`; each
  comparison among them is of builds of one unit by one command.
- speedtest1's instructions and cycles are one `perf stat` run of each build. Its timed rounds' first runs follow the
  lock's other holders and run slower, whichever build they are: the table compares the second runs.
- The lock serializes the runs, but between holds other sessions and CI jobs used the machine; a round's trees ran
  within one hold.
- The final head's `-c` is three rounds, against the head's five.
