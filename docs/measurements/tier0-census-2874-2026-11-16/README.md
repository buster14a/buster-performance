# A census of Tier 0's row: the one-core path's step 4, first piece (buster#2874), 2026-11-16

The first piece of step 4 of
[buster#2850](https://github.com/buster14a/buster/issues/2850), asked by
[buster#2874](https://github.com/buster14a/buster/issues/2874) under
[its claim](https://github.com/buster14a/buster/issues/2874#issuecomment-6914011546).
#2850's budget gives "Tier 0 to the code's atoms, the object and the rest" 10
of its 73 cycles a token, 18 a typed entry, where the row took 78; nothing
said what Tier 0's 153 instructions a typed entry are. This is a count on Tier
0 as it is: no object's bytes change and no function of a compile does.

**Result.** In `-c sqlite3.c` the row is **117 cycles and 295 instructions a
typed entry, 64.7 cycles a token**, in user mode. Tier 0 itself is 70 of the
117 cycles (the selection 31, the records' emission 20, the stream's decode
and the homes and frame 9 each). The rest is after it: the driver's own loop
14, the unwind table 11, the atoms and relocations 7, branch sizing 6, the
encoder 4 and the object 4. A key of **eight bytes or fewer decides the
record sequence of 99.83%** of the three corpora's 684,495 entries with no
conflict (99.99%, 100% and 99.68% of each alone), from tables of 2,383 to
24,650 rows for 456 to 1,041 patterns; no entry needs an operand's value or a
type's identity. The encoder, branch sizing and the object are **8.3 cycles a
token** as they run in a compile and **6.3** at their own benchmarks' rates.

Against #2874's gate: the first line is **missed as written** (the issue's
eight parts hold 81.5% of the row's instructions, not 95%: the unwind table
and the emission's driver, which its list doesn't name, hold the rest), the
second and third are **met**, and neither of its two conditions refutes step
4's allocation. What the census adds to them is under "Reading it" below.

The command is buster's `measure-tier0-entries`
(`src/buster/compiler/tier0_entries_measure.c`), in the pull request of
buster's branch `claude/amazing-davinci-yehx28`; the page is buster's
`docs/one-core-path.md`, "Step 4's first piece"; the result against the gate
is on the issue.

## What was built

- **`measure-tier0-entries`** in buster: what a typed entry's records depend
  on (item 2). It is a measurement command; `scripts/symdiff.sh`,
  `scripts/codediff.sh` and `scripts/compare.sh` check that a compiler built
  with it runs the same code for a compile ("No compile changes" below).
- **The profiles' reduction**, here: `scripts/tools/brips.c` charges libc's
  samples to their callers by the samples' branch stacks, and
  `scripts/tools/parts.c` gives each sample to a part of the row by its
  inline chain and `scripts/parts.rules` (items 1 and 3).
- No change to Tier 0, the encoder, branch sizing or the object writer.

## How it was measured

- The 9700X (`benchpress`), CPU 2, every build and run under the host's lock,
  one hold a run (`scripts/lock.sh`; `scripts/queue.sh` runs a list of them
  with 20 s between two holds).
- `main` is buster main `3d0d56ed`, `./build.sh --config Release`
  (`scripts/build-label.sh`): every profile, timing and benchmark is this
  executable's. `census` is the pull request's commit `d200f53b` (main
  `3d0d56ed` with `measure-tier0-entries`), built the same way: the census's
  counts are this executable's, and it is compared with `main` below.
- The inputs are #2850's other records': the frozen `sqlite3.c`
  (`/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite`, with
  `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5
  -DSQLITE_ENABLE_RTREE`), Lua 5.4.8's 34 files and musl's 1,337 compiles
  (`scripts/corpora.sh`). A compile is `-c`, a process a file, its object
  written to `/dev/shm` (`scripts/compile-all.sh`).
- **An entry** is a typed entry of the functions `benchmark-backend-source`
  takes from the corpus (the ones `-c` lowers), and **a token** a
  preprocessed token of the corpus's compiles (`--time-stages`' count,
  `scripts/tokens.sh`). The divisors are in
  `results/main/tables/*-denominators.txt`.

### The row by part (items 1 and 3)

A Release compiler inlines Tier 0's passes into two functions of 58 KB and
143 KB, so a symbol says nothing of a pass. The parts are read from samples'
inline chains instead:

1. **Samples** (`scripts/profile.sh`, `scripts/profile-backend.sh`): `perf
   record -b -e EVENT:u -c PERIOD`, a record a run, the period two more each
   run (a deterministic compile sampled at one period gives the same
   instructions every run). The events are `cycles` (period 120,011),
   `instructions` (240,007), `ex_ret_brn_misp` (601) and
   `ls_dmnd_fills_from_sys.all` (2,003), user mode. A compile's profile is
   120 compiles of `sqlite3.c`, 40 passes over Lua's files or 10 over musl's.
2. **libc's samples go to their callers** (`scripts/tools/brips.c`). The
   compiler is linked statically, and a sample in `memcpy` says nothing of
   who copies. Each sample has its branch stack (the last 16 taken
   branches). On this machine the stack stops at the counter's overflow and
   the sampled address is some tens of instructions later, so a sample that
   lands early in `memcmp` has a stack that still ends in the caller, before
   the call: it is charged to the stack's newest target. A sample whose
   stack ends inside libc is charged to the newest call into it. A sample
   whose 16 branches are all a copy's own loop keeps libc's address;
   `scripts/libc-callers.sh` (gdb, a conditional breakpoint at each
   function's entry) says whose bytes those long calls are. The profiles ran
   twice: a first reduction had only the second rule, which leaves most
   short calls' samples in libc and can find an older call's caller, so its
   samples were not kept and `scripts/queue-profiles.txt` ran the 48
   profiles again.
3. **Each sampled address gets its inline chain** (`scripts/chains.sh`:
   `llvm-symbolizer -i` over the executable's debug information).
4. **A chain's part is its innermost function with a rule**
   (`scripts/tools/parts.c`, `scripts/parts.rules`): a helper inlined into a
   pass is the pass's, a pass inlined into its driver is its own. The rules
   name the issue's eight parts (`part`), what else the row runs (`rest`:
   the unwind table, the emission's driver, the static data's atoms), and
   what a compile runs outside the row (`out` and `far`: the lowering, Tier
   0's validation in `lower`, the front end, the process).
5. **The row** is the `part` and `rest` rows: what `-c` runs from a
   function's lowered typed stream to the object's bytes.
6. **In `benchmark-backend-source`** a profile holds the corpus's
   preparation too (it parses, checks and lowers every file once). Each
   profile has a control: the same command with `--only validate`, which
   prepares the same corpus and runs the validation's 21 passes in the timed
   passes' place. A part's count is the profile's less the control's, over
   20 runs of 21 passes (`scripts/reduce.sh`).

`scripts/reduce.sh` writes `results/main/tables`: for each corpus the
compile's parts an entry and a token, the benchmark's parts an entry, and the
same by function (`*-functions.txt`).

### What an entry's records depend on (item 2)

`measure-tier0-entries` (buster's `tier0_entries_measure.c`; its guide is
`docs/commands/tier0.md`, "The entries' census") compiles each function `-c`
lowers with `tier0_compile` as it is and counts, with no dump between:

- **A group** is an entry that makes records (its head) with the entries
  before it that it absorbs (a fused constant, local, pointer addition or
  compare). Every typed entry is in one group and counts with its absorber.
- **A group's pattern** is its record sequence with what is carried left
  out. For a head that takes a template: the template's content with the
  forms its records have after the immediates' choice, checked against the
  records Tier 0 made (the same count and forms). For a deferred head (a
  call, a copy, a division where its fixed registers are taken): the records
  themselves, each register named by its place from the head's depth. A
  template's constant, a symbol, a branch's target and a frame displacement
  are holes; a deferred head's own immediates (a count, a size) stay in its
  pattern.
- **A group's inputs** are 40 bytes a producer could write beside the head:
  its class; the kinds and classes of the three entries before it and which
  are jump targets; each one's value as a class by magnitude (zero, one,
  minus one, 8 bits, 32 bits, more), in 64 bits and in its own class's width;
  a pointer addition's element size as a SIB scale, whether its constant
  fits and its scaled constant's class; each named local's home (a register,
  a slot, an object); the two depths; the symbol's access; a call's counts
  of register and stack arguments, its flags and its result; a copy's bytes;
  the frame's kind. Three more are the fusion's own answers (its key's kind
  and class and its variant), offered only in the second count.
- **A key decides an entry** when every group with that key has one
  pattern: the gate's rule, so one odd group makes its whole key's entries
  undecided. The census also counts the entries whose pattern is their key's
  commonest: what a table with a way out for the rest would get right.
- **The search** is a head's kind at a time, the kind being the key's first
  byte: every set of up to four inputs, then the best set with the input
  that takes the most conflicts away. A figure past five bytes is the best
  of the sets tried, so a lower bound of what a key of that size decides.
  (The three corpora's calls together have 13,651 distinct samples, and
  their sets of four inputs are past the search's budget: three there.)
- Two counts: `keys=raw` over the 40 inputs, `keys=fused` with the fusion's
  three offered too. The gate is read on `keys=raw`.

`scripts/census.sh` ran it on each corpus (`--rows --list all`: a line a
kind, and every kind's keys at the gate's key with their patterns' forms) and
on the three as one population (`--next`).

## The row by part (item 1)

`-c sqlite3.c`, a typed entry (395,061 of them for 716,136 tokens, 0.55 a
token; 354,742 records). The last column is cycles a token.

| part | instructions | cycles | mispredicted | fills | cycles a token |
| --- | ---: | ---: | ---: | ---: | ---: |
| the stream's decode | 27.1 | 9.1 | 0.060 | 0.21 | 5.0 |
| the selection | 71.8 | 31.2 | 0.233 | 0.64 | 17.2 |
| the homes and the frame | 19.8 | 8.9 | 0.102 | 0.07 | 4.9 |
| the records' emission | 57.7 | 20.4 | 0.136 | 0.41 | 11.3 |
| the encoder | 13.6 | 4.3 | 0.015 | 0.06 | 2.4 |
| branch sizing | 12.6 | 6.4 | 0.030 | 0.23 | 3.5 |
| the atoms and relocations | 24.1 | 7.4 | 0.043 | 0.10 | 4.1 |
| the object's sections | 13.9 | 4.4 | 0.056 | 0.10 | 2.4 |
| the unwind table | 32.8 | 10.7 | 0.044 | 0.10 | 5.9 |
| the emission's driver | 19.0 | 13.6 | 0.064 | 0.36 | 7.5 |
| the static data's atoms | 2.8 | 0.9 | 0.005 | 0.01 | 0.5 |
| **the row** | **295.1** | **117.3** | **0.788** | **2.30** | **64.7** |

The first eight are the issue's parts: 240.5 instructions and 92.2 cycles,
**81.5% of the row's instructions** (78.6% of its cycles). The last three are
in the row and not in the issue's list: 18.5% of its instructions. Each
part's passes, with the same four counts (`results/main/tables/sqlite3-compile-entry.md`
has the mispredicted branches and the fills):

| part and pass | instructions | cycles |
| --- | ---: | ---: |
| **the stream's decode** | **27.1** | **9.1** |
| … the columns' room and the labels | 13.3 | 4.9 |
| … the values' predicates (P0) | 9.7 | 2.4 |
| … the depths (P4) | 4.2 | 1.8 |
| **the selection** | **71.8** | **31.2** |
| … fusion (P1 to P3) | 15.5 | 6.4 |
| … the templates' words (selection's gather) | 16.4 | 9.6 |
| … measuring: the homes' case, lengths, positions | 19.8 | 8.5 |
| … measuring: a deferred entry's records counted | 7.3 | 3.2 |
| … the immediates' forms: the requests chosen | 2.5 | 1.3 |
| … the immediates' forms: applied to the records | 10.2 | 2.3 |
| **the homes and the frame** | **19.8** | **8.9** |
| … the references' count | 3.7 | 1.8 |
| … the homes | 3.9 | 2.1 |
| … the frame's layout | 6.0 | 2.7 |
| … the prologue and the epilogue | 6.3 | 2.3 |
| **the records' emission** | **57.7** | **20.4** |
| … expansion: hole blocks, a permute and a store an entry | 37.5 | 12.9 |
| … the deferred entries' records (calls, division, copies) | 15.4 | 5.9 |
| … the output's arrays and the code's close | 4.9 | 1.7 |
| **the encoder** (`x86_encode`) | **13.6** | **4.3** |
| **branch sizing** | **12.6** | **6.4** |
| … the branch columns' check | 1.6 | 0.7 |
| … the records' lengths (`x86_measure`) | 6.7 | 3.2 |
| … `size_branches` | 4.3 | 2.5 |
| **the atoms and relocations** | **24.1** | **7.4** |
| … the symbols and their names | 4.8 | 2.8 |
| … the atoms and their fixups | 10.5 | 2.6 |
| … `link_check` | 8.8 | 2.0 |
| **the object's sections** | **13.9** | **4.4** |
| … `object_prepare` and `object_build` | 13.1 | 4.2 |
| … the driver's object: sections, the file | 0.8 | 0.3 |
| **the unwind table** | **32.8** | **10.7** |
| … the frames' events from Tier 0's code | 8.8 | 3.3 |
| … the rows resolved and checked | 19.1 | 5.9 |
| … the table written (`.eh_frame`) | 4.9 | 1.5 |
| **the emission's driver** | **19.0** | **13.6** |
| … the bodies' loop, the windows, what the merge keeps | 14.3 | 9.2 |
| … Tier 0's splice of `always_inline` callees | 1.4 | 0.6 |
| … the inline callees' table (`check_tier1_inline_table`) | 3.3 | 3.8 |
| **the static data's atoms** | **2.8** | **0.9** |

- **Tier 0 itself** (the first four parts) is 176.4 instructions and 69.7
  cycles an entry in a compile, 59% of the row's cycles. Its mispredicted
  branches are 0.53 an entry and its fills 1.34.
- **The deferred entries** (calls, copies, a division or a shift whose fixed
  registers are taken: 13,950 of the entries, 3.5%, nearly all calls) are
  counted in the selection and written in the emission by code of their own:
  22.7 instructions and 9.0 cycles an entry, 13% of Tier 0's. That is about
  640 instructions and 255 cycles a deferred entry.
- **Outside the row,** Tier 0's validation of the stream (`tier0_validate`,
  which `lower` runs) is 32.1 instructions and 13.9 cycles an entry more, and
  the lowering itself 386 and 157.
- **By the stage clock** (`--time-stages`, 21 runs, medians): `tier0` 5.36
  ms, `emit-setup` 1.15, `branch-sizing` 0.53, `encode` 0.39, `unwind` 0.49,
  `code-atoms` 0.35, `publish-data` 0.47, `object-build` 0.47 and
  `object-write` 0.17 are 9.38 ms of the compile's 122.1: 72.5 cycles a token
  at the compile's 5.54 GHz, with the kernel's time in them. The samples'
  row is 8.37 ms of user time. The issue's 78 was main `d96b2e73`'s sampled
  user cycles.

### The three corpora

Cycles (and instructions) a typed entry, in a compile:

| part | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| the stream's decode | 9.1 (27.1) | 17.7 (40.3) | 35.2 (39.7) |
| the selection | 31.2 (71.8) | 49.9 (86.7) | 88.7 (83.6) |
| the homes and the frame | 8.9 (19.8) | 22.6 (30.0) | 55.4 (24.7) |
| the records' emission | 20.4 (57.7) | 40.4 (71.4) | 98.2 (109.5) |
| the encoder | 4.3 (13.6) | 7.7 (17.5) | 14.1 (16.7) |
| branch sizing | 6.4 (12.6) | 12.9 (16.0) | 24.1 (12.4) |
| the atoms and relocations | 7.4 (24.1) | 19.2 (51.1) | 46.7 (34.9) |
| the object's sections | 4.4 (13.9) | 23.3 (27.5) | 91.4 (43.7) |
| the unwind table | 10.7 (32.8) | 34.6 (64.1) | 1.3 (0.4) |
| the emission's driver | 13.6 (19.0) | 41.0 (44.4) | 260.5 (130.6) |
| the static data's atoms | 0.9 (2.8) | 3.9 (4.9) | 16.2 (50.8) |
| **the row** | **117.3 (295.1)** | **273.1 (453.8)** | **731.7 (547.1)** |
| the issue's eight parts, of the row's instructions | 81.5% | 75.0% | 66.8% |
| the row, a token | 64.7 (162.8) | 42.8 (71.1) | 19.4 (14.5) |
| mispredicted branches and fills, an entry | 0.79 and 2.30 | 2.30 and 3.69 | 8.55 and 8.77 |

- **Lua** is 34 processes of 2,634 entries each, **musl** 1,337 of 150. A
  part's instructions an entry are close to `sqlite3.c`'s where the part
  works an entry; its cycles are two to six times as many, in a process
  whose code and tables are cold. Where a part works a file, both grow: the
  object is 13.7 thousand cycles a file of musl, the driver 38.9 thousand.
- **musl's objects have no unwind table**: its options have `-ffreestanding`,
  and the driver asks for the table only where the predefined macros say so
  (`predefines_unwind_tables`).
- **musl's long double code** runs the x87 values' transfers, a pass over a
  function's records: 41 of the emission's 110 instructions an entry.
  `sqlite3.c` has none. Its inline asm's bodies are 40 of the driver's 131.
- **A token** of musl is mostly a header's: 0.027 entries a token, where
  `sqlite3.c` has 0.55.

In `benchmark-backend-source`, a pass of Tier 0's vector path over the
corpus's functions and a pass of branch sizing and encoding (each profile
less its control's), cycles (and instructions) a typed entry:

| part | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| the stream's decode | 7.9 (25.5) | 11.1 (34.8) | 12.2 (38.2) |
| the selection | 30.2 (71.7) | 37.1 (85.8) | 36.5 (86.8) |
| the homes and the frame | 7.9 (17.7) | 12.7 (30.4) | 12.6 (29.9) |
| the records' emission | 19.1 (58.4) | 23.9 (70.0) | 36.8 (111.7) |
| **Tier 0's vector path** | **65.1 (173.2)** | **84.7 (220.9)** | **98.0 (266.6)** |
| mispredicted branches and fills | 0.47 and 0.97 | 0.61 and 0.81 | 0.77 and 1.00 |
| the encoder (its `encode` passes) | 3.6 (13.7) | 4.5 (16.7) | 4.8 (17.2) |
| branch sizing (its `encode` passes) | 5.1 (11.4) | 6.3 (13.9) | 6.4 (14.6) |

The benchmark's own counters read 64.9 cycles and 174.4 instructions an entry
on `sqlite3.c`, 86.0 and 221.8 on Lua, 99.1 and 269.9 on musl
(`results/main/backend-*.txt`): the profiles' parts sum to within 2% of
them. The issue's 153 instructions were an older main's.

## What an entry's records depend on (item 2)

| | `sqlite3.c` | Lua | musl | the three as one |
| --- | ---: | ---: | ---: | ---: |
| functions | 2,668 | 1,096 | 2,756 | 6,520 |
| typed entries | 395,061 | 89,543 | 199,891 | 684,495 |
| records | 354,742 | 91,332 | 204,155 | 650,229 |
| groups (an entry that makes records, with those it absorbs) | 266,182 | 64,499 | 143,206 | 473,887 |
| entries on a template | 96.47% | 94.74% | 93.88% | 95.48% |
| entries deferred by their kind (a call, a copy) | 3.47% | 5.22% | 6.02% | 4.45% |
| entries deferred by their depth | 0.06% | 0.04% | 0.08% | 0.06% |
| entries whose records aren't their template's | 0 | 0 | 0.02% | 0.01% |
| patterns | 700 | 456 | 827 | 1,041 |
| entries in a group that makes no record | 9.69% | 9.30% | 8.00% | 9.15% |
| **entries a key of 8 bytes or fewer decides** | **99.99%** | **100%** | **99.68%** | **99.83%** |
| those keys' rows | 5,906 | 2,383 | 13,361 | 24,650 |
| entries no key decides | 0 | 0 | 334 (0.17%) | 334 (0.05%) |
| rows with the fusion's key, class and variant offered | 2,633 | 1,509 | 10,783 | 18,548 |

The share of the entries a key of that many bytes decides with no conflict,
the head's kind being its first byte; in brackets, the share whose pattern is
their key's commonest:

| key bytes | sqlite3.c | Lua | musl | the three |
| ---: | ---: | ---: | ---: | ---: |
| 1 | 13.49 (60.76) | 11.48 (62.57) | 11.93 (52.24) | 11.94 (57.92) |
| 2 | 40.87 (85.58) | 46.64 (87.04) | 28.62 (79.09) | 23.48 (82.91) |
| 3 | 61.28 (94.96) | 73.42 (96.15) | 59.48 (92.60) | 55.17 (93.85) |
| 4 | 86.17 (98.95) | 93.60 (99.30) | 84.61 (97.96) | 77.69 (98.49) |
| 5 | 95.62 (99.76) | 98.55 (99.80) | 94.70 (99.42) | 93.49 (99.58) |
| 6 | 99.47 (99.94) | 99.77 (99.95) | 98.81 (99.74) | 97.51 (99.82) |
| 7 | 99.88 (99.99) | 99.95 (99.99) | 99.49 (99.84) | 99.54 (99.92) |
| 8 | 99.99 (100.00) | 100.00 (100.00) | 99.68 (99.90) | 99.83 (99.95) |

- **The gate's line:** 683,330 of the three corpora's 684,495 entries
  (99.83%) have a key of eight bytes or fewer with one pattern. 1,165 don't:
  831 are decided by a key of nine to twelve bytes, and no set of the 40
  inputs decides 334.
- **A short key with a way out** does nearly as well: the commonest pattern of
  a key of four bytes is the pattern of 98.5% of the entries, of five 99.6%.
- **The tables are not small, and a corpus's keys are mostly its own.** The
  keys of eight bytes or fewer have 5,906 rows on `sqlite3.c`, 2,383 on Lua
  and 13,361 on musl, and 24,650 on the three together: more than their sum,
  since the three need longer keys together than apart. The patterns do
  converge: 700, 456 and 827 alone, 1,041 together.
- **What decides,** as the share of the three corpora's entries that the
  gate's keys no longer decide without a family of inputs: the entry's own
  class 48.6%; the kinds, classes and labels of the entries before it 37.5%;
  a value's class by magnitude 32.6%; a depth 13.0%; a home's case 5.9%; a
  call's counts and flags 2.6%; the function's (a symbol's access, the
  result, the frame's kind) 2.6%.
- **Beside the template's own key:** 18.6% of the entries take their template
  by a home's case, 37.3% have an immediate whose form is chosen after
  selection, and 34.8% leave that choice with another form than the
  template's.
- **The entries no key decides** are musl's, 334:
  - 288 are long double values' (`fld; fld; faddp; fld` or `…; fstp`; a
    constant's three `mov`s). The x87 values' transfers rewrite an
    operation's records by what reads its value later, and a long double
    constant is three stores of its own bits. The inputs are the entries
    before the head: these need what comes after it, or 80 bits.
  - 44 are `X86` entries (one machine instruction each: `lock inc`,
    `bsf; mov`): their value is a row of the function's table of operations.
  - 2 are `alloca`s.
- **A wide input,** as the claim reads it (a value, a symbol or a table's row
  that the pattern changes with, where no bit says it): the 44 `X86` entries
  and the 52 long double constants, 0.014% of the entries.
- **One input was added after a first census.** That census left 682 of
  `sqlite3.c`'s pointer additions undecided: `p + 3` and `p + 20` of 8-byte
  elements have the same constant's class and the same element size, and
  their scaled constants take an 8-bit and a 32-bit immediate. With the
  scaled constant's class among the inputs (`product`) none is left, and a
  pointer addition's key is `kind, value, scale, fits-1, product, depth`.

`sqlite3.c`'s heads by their entries, with the key the gate counts for each
(`results/census/census-sqlite3.txt` has every kind and, under `list`, every
row of every kind's table with its pattern's forms):

| head | entries | groups | records | patterns | the gate's key | its rows | decided |
| --- | ---: | ---: | ---: | ---: | --- | ---: | ---: |
| `LOAD` | 62,323 | 25,278 | 25,278 | 27 | kind, class, class-2, scale-1, fits-2 | 111 | 100.00% |
| `LOCAL` | 56,185 | 56,185 | 56,200 | 10 | kind, class, home | 20 | 100.00% |
| `BRANCH_FALSE` | 48,595 | 15,553 | 31,106 | 9 | kind, class-2, kind-1, kind-3, value-2, home-3 | 60 | 100.00% |
| `DISCARD` | 32,904 | 27,119 | 0 | 1 | kind | 1 | 100.00% |
| `PTR_ADD` | 25,145 | 13,864 | 15,116 | 11 | kind, value, scale, fits-1, product, depth | 112 | 100.00% |
| `CONVERT` | 21,039 | 16,139 | 13,414 | 36 | kind, class, class-1, kind-1, labels | 517 | 100.00% |
| `CONST` | 15,291 | 15,291 | 15,367 | 6 | kind, class, value | 59 | 100.00% |
| `EQ` | 14,378 | 6,212 | 18,659 | 24 | kind, class-1, kind-1, kind-2, value-1, home-1, home-2, depth | 316 | 100.00% |
| `CALL` | 13,570 | 13,570 | 45,061 | 154 | kind, class, class-1, depth, call-integers, call-stack, call-flags, call-narrow | 444 | 99.78% |
| `STORE_LOCAL` | 13,432 | 10,808 | 13,435 | 23 | kind, class, kind-1, kind-2, value-1, home | 1,023 | 100.00% |
| `NE` | 11,750 | 5,648 | 16,969 | 23 | kind, class-1, kind-1, kind-2, value-1, home-1, home-2, depth | 218 | 100.00% |
| `SET_LOCAL` | 9,383 | 7,373 | 7,531 | 26 | kind, class, kind-1, kind-2, kind-3, value-1, home, home-1 | 1,014 | 100.00% |
| `ADD` | 9,298 | 5,139 | 5,142 | 14 | kind, class, kind-1, kind-2, value-1, narrow-3 | 455 | 100.00% |
| `STORE` | 7,681 | 7,681 | 15,290 | 6 | kind, class | 10 | 100.00% |
| `JUMP` | 6,715 | 6,715 | 6,715 | 1 | kind | 1 | 100.00% |
| `AND` | 5,940 | 3,065 | 3,068 | 11 | kind, class, narrow-1, fits-1, depth | 119 | 100.00% |
| `RETURN` | 5,304 | 5,304 | 2,728 | 10 | kind, class, last | 21 | 100.00% |
| `LOCAL_ADDRESS` | 4,452 | 4,452 | 4,452 | 1 | kind | 1 | 100.00% |
| `BRANCH_TRUE` | 4,173 | 1,323 | 2,646 | 14 | kind, class-2, kind-1, kind-3, value-2, home-3 | 44 | 100.00% |
| `JUMP_VALUE` | 4,049 | 4,049 | 4,049 | 1 | kind | 1 | 100.00% |

A name with `-1`, `-2` or `-3` is the entry that many before the head;
`value` is a value's class by magnitude, `narrow` the same in its own
class's width, `home` a local's home's case, `labels` which of the four are
jump targets (`tier0_census_input_names` in buster has all 43).

- **The fusion's variants** (`variant=` in the reports): 41% of `sqlite3.c`'s
  entries are heads that fuse nothing, 20% a head with its constant, 14% a
  pointer addition into a load or a store, and 10% a compare with a constant
  and its branch.

## What no table removes (item 3)

The encoder, branch sizing and the object, cycles a token and (in brackets) a
typed entry (`results/main/tables/item3.txt`, `scripts/item3.sh`):

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| **in a compile:** the encoder | 2.37 (4.29) | 1.21 (7.71) | 0.37 (14.11) |
| in a compile: branch sizing | 3.52 (6.37) | 2.03 (12.94) | 0.64 (24.08) |
| in a compile: the object | 2.45 (4.44) | 3.65 (23.29) | 2.43 (91.39) |
| **in a compile: the three** | **8.33 (15.10)** | **6.88 (43.94)** | **3.44 (129.57)** |
| in `benchmark-backend-source`: its `encode` and `sizing` rows | 5.13 (9.30) | 1.78 (11.37) | 0.30 (11.49) |
| **at their own rates:** the encoder | 1.64 (2.98) | 0.53 (3.39) | 0.09 (3.39) |
| at their own rates: branch sizing | 3.32 (6.01) | 1.07 (6.83) | 0.18 (6.84) |
| at their own rates: the object built | 1.36 (2.46) | 0.61 (3.88) | 0.15 (5.72) |
| **at their own rates: the three** | **6.32 (11.45)** | **2.21 (14.09)** | **0.42 (15.95)** |
| two more parts that write bytes, in a compile: the atoms and relocations | 4.09 (7.41) | 3.00 (19.17) | 1.24 (46.71) |
| … the unwind table | 5.90 (10.70) | 5.41 (34.56) | 0.03 (1.26) |
| in a compile: the five | 18.32 (33.21) | 15.30 (97.67) | 4.71 (177.55) |

- **The own rates** (`results/main/own-*.txt`, three runs each, medians):
  `benchmark-x86-encoder --fixups`' `x86_encode_16` 3.32 cycles an
  instruction (14.1 instructions; 3.07 without fixups, 3.36 right after 200 ms
  of the scalar loop); `benchmark-branch-sizing`'s `size_branches` on
  `tier0-mix`, the mix of `sqlite3.c`'s function sizes, 6.70 cycles a record
  (5.00 on functions of 250 records, 7.80 on functions of 40);
  `benchmark-object-writer`'s build 73,159 cycles an object of 165.5 KB
  written (12.85 GB/s, 5.05 ns a relocation).
- **Applied to** each corpus's records (`sqlite3.c` 354,742, Lua 91,332, musl
  204,155) and its objects' bytes (2,197,000 in 1 object, 785,160 in 34,
  2,584,568 in 1,336: `results/main/objects.txt`).
- **In a compile the encoder is 4.8 cycles a record** on `sqlite3.c` where
  its benchmark has 3.3, and branch sizing 7.1 where its has 6.7: the
  records' lengths (`x86_measure`) and the columns' check are sizing's in a
  compile, and each function's records are new to the cache.
- **The object's own rate is its build's.** Its write is the kernel's time,
  which #2850's budget keeps in another row: at the benchmark's rates
  `sqlite3.c`'s object is 0.97 cycles a token written in place and 2.31
  written as a new file, and the stage clock has `object-write` at 0.17 ms
  (1.3 cycles a token). buster#2873's census has the object's write at 1.7
  cycles a token of kernel time.
- **A file's fixed work** is what musl's column shows: 129.6 cycles an entry
  for the three, 13.7 thousand cycles a file for the object alone.

## Against #2874's gate

| the gate's line | result |
| --- | --- |
| 95% of the row's instructions are in a part of item 1 | **missed as written**: 81.5% on `sqlite3.c`, 75.0% on Lua, 66.8% on musl |
| item 2's key decides 95% of the entries, with eight key bytes or fewer and no conflict | **met**: 99.83% of the three corpora's; 99.99%, 100% and 99.68% of each |
| item 3's parts are together at or under 10 cycles a token | **met**: 8.33 on `sqlite3.c` in a compile (6.88 on Lua, 3.44 on musl) |

- **The first line** names eight parts. Every instruction of the row is in a
  named part of the tables; three parts the issue's list doesn't have hold
  18.5% of `sqlite3.c`'s: the unwind table 11.1%, the emission's driver 6.4%,
  the static data's atoms 0.9%. With the unwind table as a ninth part the
  share is 92.6%, with the driver 99.0%. A compile's samples that no rule
  names are 0.3 instructions an entry of 3,431.
- **It refutes step 4's allocation if the selection needs wide inputs for
  more than a few percent of the entries** (5%, in the claim): it doesn't.
  0.17% of the three corpora's entries have no key of eight bytes; 0.05% have
  none at all, and 0.014% need a value or a table's row.
- **Or if the encoder, branch sizing and the object cost more than 10 cycles
  a token at their own benchmarks' rates**: they cost 6.32 on `sqlite3.c`.

## Reading it

What the counts say beyond the gate's lines, on `sqlite3.c`, in cycles a
token:

- **The row is 64.7, and Tier 0 is 38.4 of it.** A selection that cost
  nothing would leave 26.3: the driver 7.5, the unwind table 5.9, the atoms
  and relocations 4.1, branch sizing 3.5, the object 2.4, the encoder 2.4,
  the static data 0.5.
- **The 10 of the budget, less what no table removes, is 1.7 to 3.7**: 8.33
  as the three run in a compile, 6.32 at their own rates. The other parts of
  the row take 56.4 today (Tier 0's four 38.4, the driver 7.5, the unwind
  table 5.9, the atoms and relocations 4.1, the static data 0.5).
- **The unwind table costs as much as the encoder and branch sizing
  together** (10.7 cycles an entry against 10.7, and 32.8 instructions
  against 26.1), and the budget's row has no line for it.
- **An entry's records are a table's answer on bytes**, as the design asks:
  with no conflict for 99.8%, and for 98.5% from the commonest pattern of a
  key of four bytes. It is a table of thousands of rows, though, that a
  corpus doesn't close: the answer is Tier 0's own rules (its fusion makes a
  three-byte key by lane arithmetic today, 6.4 cycles an entry, and the
  templates' words are a gather on it, 9.6), not rows learned from inputs.
- **The deferred entries are where an entry costs most**: 3.5% of the
  entries, 13% of Tier 0's cycles, about 255 cycles each. A call's records
  are decided by bytes too: its class and the class before it, its depth,
  its counts of register and stack arguments, its flags and which arguments
  are narrow decide 99.8% of `sqlite3.c`'s calls, 154 patterns in 444 rows.
- **A tenth of the entries are in groups that make no record** (a discard, a
  return the epilogue covers), and a third are absorbed by another's
  template; each still passes the decode and the fusion.

## No compile changes

`census` (buster `d200f53b`: main `3d0d56ed` and the command) against `main`
(`3d0d56ed`), both Release:

- **Every function a compile runs is the same code.** By size, the only text
  symbols that differ are `main_command` (the commands' dispatch, one more
  name), `run_checker_tests` and the new command's and its tests' own
  (`results/census/symdiff.txt`). By instruction, with addresses left out,
  the same: of 8,106,510 instructions the functions with a line in one
  executable alone are those (`results/census/codediff.txt`).
- **`-c sqlite3.c`, whole processes** (`scripts/compare.sh`: three fresh
  copies of each executable, 7 runs a copy, base, head and base again in a
  Williams order, twice; medians):

  | | base | head | base again |
  | --- | ---: | ---: | ---: |
  | wall, ms | 122.908 | 123.048 (+0.11%) | 122.909 (+0.00%) |
  | user cycles, M | 595.055 | 596.591 (+0.26%) | 596.431 (+0.23%) |
  | instructions | 1,363,597,447 | 1,363,596,553 | 1,363,597,451 |
  | wall, ms (second round) | 122.808 | 122.966 (+0.13%) | 122.785 (-0.02%) |
  | user cycles, M (second round) | 594.971 | 596.319 (+0.23%) | 595.393 (+0.07%) |
  | instructions (second round) | 1,363,597,448 | 1,363,596,517 | 1,363,597,450 |

  Head is within what the base's own repeat moves by, over copies: wall
  -0.17% to +0.31% against base where base again is -0.20% to +0.47%. It
  retires about 900 fewer instructions of 1.36 billion (0.00007%), outside
  any function the comparison found different: the dispatch's compares and
  libc's string functions on names at other addresses.

## A by-product: a compare's value is tested again

The census's keys show a conditional branch's group as three entries, the two
before the branch being `CONST 0` and `NE`, and the entry before those a
compare: the lowering tests a condition's value against zero, so Tier 0's
fusion of "a compare before a branch" meets the `!= 0`, and the compare's own
value is made first. `if (a < b)` is `cmp; setl; movzx; test; je`.
`scripts/shapes.sh` counts that sequence in the objects `main` wrote
(`results/main/shapes.txt`):

| | instructions | conditional branches | of them a compare tested again | instructions more than `cmp; jCC` |
| --- | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 354,742 | 16,876 | 8,915 (52.8%) | 26,745 (7.5%) |
| Lua | 91,332 | 3,057 | 1,549 (50.7%) | 4,647 (5.1%) |
| musl | 204,187 | 8,734 | 4,768 (54.6%) | 14,304 (7.0%) |

Each site is also two entries of the stream (17,830 of `sqlite3.c`'s 395,061,
4.5%). It changes objects' bytes, so it is no part of this census: it is
filed as an issue of its own, linked from #2874's result.

## Limits

- **The parts are samples**, not counters: 120 compiles of `sqlite3.c` are
  about 600,000 cycle samples, 45,000 of them in the row; a sub-part of 1
  cycle an entry has about 400. `results/main/tables/totals.txt` has the
  samples' sums against `perf stat`'s counts of the same compiles.
- **A sample's part is its innermost function with a rule.** A helper shared
  by two passes and inlined in both is each pass's where it runs; one
  compiled out of line has a rule of its own (`^NAME`). The rules are the
  record's reading of Tier 0's passes, `scripts/parts.rules`, and
  `*-functions.txt` lists each part's functions.
- **The row is user mode.** #2850's budget counts the kernel's time in a row
  of its own, and step 5's census (buster#2873) has it by cause; the object's
  write and its pages are there.
- **libc's long calls** (16 or more iterations of a copy's loop) keep libc's
  address: they are the `libc` rows of the tables and not in the row. By the
  bytes asked for (`results/main/libc-callers.txt`), the row's callers have
  under 3% of them.
- **Lua's and musl's compiles are a process a file.** A part's cost an entry
  holds its work a file there (musl has 150 entries a file), and the first
  run of each pass in a new process.
- **The census's keys are found on these corpora.** A key that decides every
  entry here is the smallest set of the 40 inputs with no conflict on
  684,495 entries; it is not derived from Tier 0's rules, and another corpus
  can bring a group that conflicts. Past five bytes a figure is the best of
  the sets the search tried.
- **A pattern is the census's reading of "the record sequence"**: forms,
  operands by role, and the immediates' chosen forms, with a template's
  constants, symbols, branch targets and frame displacements as holes. A displacement's
  width (8 or 32 bits) is the encoder's choice from its value and is not in
  a pattern.
- **Item 3's own rates** are each benchmark's rate on its own input, applied
  to the corpus's records and bytes: the encoder's on 16,384 mixed
  instructions, branch sizing's on its `tier0-mix` functions, the object
  writer's on 64 objects of 165 KB.

## Files

- `scripts/`: every runner (each takes the lock itself, a hold a run),
  `parts.rules`, and `tools/brips.c` and `tools/parts.c`, the two reducers.
  `queue-main.txt`, `queue-profiles.txt` and `queue-census.txt` are the lists
  `queue.sh` ran. On the 9700X the scripts sit in one directory with
  `results/` in it (`~/buster-fast-bench/2874-claude`); `item3.sh`,
  `stages-table.sh` and `totals.sh` read the results and run here too.
- `results/main/`: the profiles' logs, `profiles.tar.xz` (every profile's
  samples by address, `*.ips`, and `chains.txt`, the addresses' inline
  chains: what `scripts/reduce.sh` reads), `tables/` (what it writes),
  `stat-*.txt` (`perf stat`), `stages-*.txt` (the stage clock, 21 runs),
  `backend-*.txt` (`benchmark-backend-source`), `own-*.txt` (the three own
  benchmarks, three runs each), `objects.txt`, `shapes.txt`,
  `libc-callers.txt` and `libc-calls.txt`, `transparent.txt`.
- `results/census/`: the census's four reports, and the comparison with
  `main`: `symdiff.txt`, `codediff.txt`, `compile-1.txt`, `compile-2.txt`.
