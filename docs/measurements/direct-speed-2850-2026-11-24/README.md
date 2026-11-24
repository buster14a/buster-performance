# The direct path's speed (`c_direct`, buster#2850): profile and redesigns on the 9700X

The direct path is the fused lexer-to-ELF compiler of buster#3566 (`src/buster/compiler/c_direct*.c`), which a plain
`-c` of one C file takes. This record has its profile on main `dd503f2a1` and, below it, each redesign's readings.

- **Host:** `benchpress` (Ryzen 7 9700X, Linux 6.18.50-2-lts), every run under `~/buster-fast-bench/exclusive.sh`,
  pinned to CPU 2, transparent huge pages `always`, the object written to `/dev/shm`.
- **Unit:** the frozen `sqlite3.c` (9,507,037 bytes) with the corpus's headers and predefines, as
  `tools/ci/compile-count.sh count` compiles it (`--lanes 1 -std=gnu17 -nostdinc ... -c`).
- **Builds:** `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --config Release` on the host (clang 23.1.4),
  and `scripts/direct_main.c`, a harness around `c_direct_try_compile` built with the unit's own flags, which
  repeats the compile in one process and times its stages. The harness's object is the product's, byte for byte.
- **Scripts:** `scripts/build-tree.sh` (a tree's product and harness), `scripts/measure.sh` (wall, counters, stages,
  samples), `scripts/characterize.sh` (Zen 5's pipeline accounting and event samples), `scripts/patch_stats.py`
  (event counters in a copy of the sources, for the counts below), `scripts/ab.sh` and `scripts/ab-product.sh` (the
  steps' A/B readings), `scripts/funcs.sh` and `scripts/lines.sh` (events by function and by source line),
  `scripts/equiv/` (every corpus unit's object by two compilers).

## Result: buster#3580 against main `1c5287c3`

Both built on the 9700X by `scripts/build-tree.sh`; `steps/ab.txt` has the rows.

| | main `1c5287c3` | the branch `b3e9576d` | |
| --- | ---: | ---: | ---: |
| the product's `-c`, wall (21 rotated runs, one compile a process) | 18.75 ms | 17.71 ms | -5.5% |
| user cycles | 92.53 M | 87.07 M | -5.9% |
| kernel cycles | 11.15 M | 11.07 M | |
| user instructions | 231.3 M | 234.3 M | +1.3% |
| mispredicted branches | 1.082 M | 0.959 M | -11.4% |
| lexing and preprocessing (the harness's stage, 11 rotated rounds) | 8.408 ms | 7.554 ms | -10.2% |
| parsing and generating code | 9.183 ms | 9.192 ms | +0.1% |
| the object | `ff67ee922b96b089` | the same | |

The instructions rise while the time falls: a block of the window's lexer runs the same instructions whatever its
tokens are, where the loop it replaces ran fewer and mispredicted more.

## Baseline: main `dd503f2a1`

`baseline/` has every file. Per compile, unless said otherwise.

### The whole compile

| | |
| --- | ---: |
| wall, the product (15 runs) | 18.25 ms |
| user cycles | 93.7 M |
| kernel cycles | 12.7 M |
| user instructions | 234.6 M |
| branches, mispredicted | 39.5 M, 1.11 M |
| first-level data misses | 545 K |
| page faults | 450 |
| preprocessed tokens | 715,306 |
| object | 2,056,840 bytes (1,253,483 of code) |

That is 131 user cycles and 328 instructions a token, at 2.50 instructions a cycle.

### By stage (`baseline/stages.txt`, the harness, 15 compiles in one process)

| stage | ms |
| --- | ---: |
| setup | 0.06 |
| lex and preprocess | 8.49 |
| parse and generate code | 9.27 |
| write the object | 0.27 |
| release | 0.03 |
| total | 18.12 |

### Where the pipeline's slots go (`baseline/uarch/`, user mode, 40 compiles a reading)

Zen 5 dispatches 8 ops a cycle: 730 M slots a compile.

| | share of slots |
| --- | ---: |
| retired ops | 28.2% |
| no op from the front end | 43.0% (latency 30.3, bandwidth 13.6) |
| ops dispatched and flushed (mispredicted paths) | 14.4% |
| backend stalls | 13.8% (memory 10.9, CPU 2.4) |

- **The front end starves the core.** 15.5% of op-cache fetches miss, 8.7% of instruction-cache fetches miss, 29.2 M
  of 324 M ops come through the x86 decoders, and the first-level instruction cache takes 2.1 M fills from L2. The
  op queue is empty in 28 M of 91 M cycles. The direct path's code is 246 KB, and the code generator's hot
  functions alone are about 100 KB (`fast_cc_compile_func` 20.8 KB, `fast_cc_expr` 14.9 KB, `fval_emit_binary`
  12.4 KB, ...), against a 32 KB instruction cache.
- **Mispredicted branches:** 1.07 M (2.6% of 41.4 M), 1.5 a token. 887 K are conditional directions, 196 K are
  indirect (22% of the 885 K indirect branches), 143 K unconditional (the branch target buffer). 105 M of 312 M
  dispatched ops never retire.
- **Loads that wait on stores.** 956 K loads a compile fail store-to-load forwarding (`ls_bad_status2.stli_other`),
  and retirement waits on an incomplete load in 21.3 M cycles, though only 355 K loads miss the first-level cache.
  The hottest lines of `fast_cc_expr` are copies of a 40-byte `FastVal` just written a field at a time
  (`c_direct_cc.c:4880`, `5116`, `4775`: 18% of the function's cycles); `fast_lex_one` returns its 8-byte token the
  same way.
- **Memory is not the limit.** 730 K first-level fills a compile, 635 K of them from L2, 50 K from L3 and 8.7 K
  from DRAM (the source, which the prefetchers stream). 7.4 K first-level TLB misses.
- **Vector lanes.** 8.7 M of 207 M retired ops are 512-bit (4.2%), and 43% of those are the lexer's chunk loop's.
  The rest of the compile is scalar.

### By function (`baseline/uarch/by-*.txt`)

| function | cycles | mispredicts | forwarding failures |
| --- | ---: | ---: | ---: |
| `fast_pp_drain` (the lexer's loop) | 22.9% | 23.4% | 12.6% |
| `fast_cc_expr` | 14.2% | 14.5% | 19.3% |
| `fast_lex_one` | 8.5% | 7.7% | 18.9% |
| `fast_cc_compile_func` | 5.7% | 6.2% | 5.6% |
| `fast_expr_reduce_top` | 4.9% | 4.7% | 4.9% |
| `fast_pp_try_expand_ex` | 4.2% | 2.1% | 5.2% |
| `fast_pp_skip_inactive` | 3.7% | 5.4% | |
| `fast_ident_intern` | 3.3% | 3.1% | 2.7% |
| `fval_to_gp` | 3.2% | 3.3% | 1.7% |
| `fval_emit_call` | 3.1% | 3.6% | |
| `fast_cc_parse_decl_specs` | 3.0% | 3.0% | 3.4% |
| `fval_convert` | 2.3% | 2.4% | 1.6% |

The lexer and preprocessor are 47% of the user cycles and the parser and code generator 50%.

### What the lexer's loop does with its lanes (`baseline/counts/sqlite3-counts.txt`)

Counted by `scripts/patch_stats.py`'s counters in a cloud container (counts, not times; the object is unchanged).

- **The file:** 3.46 MB of its 9.5 MB are in inactive `#if` groups (2,677 of them), 3.37 MB are comments in active
  text, and the chunk loop commits tokens from 3.13 MB.
- **Occupancy:** 109,200 iterations of the 64-byte loop. 67,641 commit tokens, and take 46.3 of the 64 bytes they
  load (72%) and 10.7 tokens each; a fifth stop at or before byte 32. 39,070 only reach a comment, a directive or
  a literal. 27,339 are cut back at byte 63 to a token boundary.
- **Identifiers:** 240,106 in the loop; the 16-byte cache answers 95% of the lookups and `fast_ident_intern`
  37,562.
- **Macros:** 12,597 one-token object macros replaced in place, 7,477 calls whose arguments are skipped (`assert`,
  `testcase`), and 6,106 general expansions, which with their nested ones put 175,357 of the 715,306 output tokens
  through the expansion stack, a token an iteration.
- **The scalar lexer:** 100,534 calls of `fast_lex_one` (13,519 directives, 5,757 of them `#define`, and the general
  expansions' arguments), at 78 cycles a call.
- **Records' members:** 32,692 lookups over 21.9 members on average, 1.9 loads of 16 lanes each.

### The code generator's events

354,682 iterations of `fast_cc_expr`'s token loop in 46,950 expressions (37 cycles of the function's own an
iteration), 104,082 of the statement loop's, 55,147 reductions, 130,318 `fval_to_gp`, 115,593 `fval_convert`,
13,688 calls (207 cycles of `fval_emit_call`'s own each), 20,287 declaration specifiers (135 cycles each), 2,668
functions.

### The kernel (`baseline/uarch/by-kernel-cycles.txt`, `userkernel.csv`)

9.2 M cycles inside the harness's compile and 12.7 M for the product's process. Clearing fresh pages is 17%
(the arenas reach 21 MB), mapping the source's pages 19% (`next_uptodate_folio`, `filemap_map_pages`,
`folio_add_file_rmap_ptes`), unmapping 7%, path lookups for the include search 4%, and replacing the old object's
pages 6%.

## The steps

`steps/ab.txt` has each hold's rows and what each build is, `steps/functions.txt` the cycles, instructions,
mispredicted branches and forwarding failures by function after four of the steps, `steps/w2-lines/` the same by
source line after the first window lexer, and `steps/counts.txt` the counts quoted below. User cycles a compile, the
harness; the stage is lexing and preprocessing.

| step | commit | user cycles | stage ms | what |
| --- | --- | ---: | ---: | --- |
| main `dd503f2a1` | | 91.3 M | 8.46 | |
| tokens stored whole | `b5f3c255` | 89.8 to 90.2 M | | `fast_lex_one` built its token a field at a time in the caller's memory, which the caller then loaded whole: 240 K loads a compile that could not forward |
| window lexer, fixed blocks | `88428280` | 88.0 M | 7.94 | raw tokens a window at a time, 64 bytes a block, carries across a block's end |
| specifiers in place | `131f60aa` | 87.7 to 88.1 M | 7.95 | two struct copies removed from the declaration parser |
| the masks' skipper | `2456c401` | 86.6 M | 7.72 | inactive groups: 47,323 blocks with 20,623 events, where every `#`, `/` and quote was one |
| one class table, marked tokens | `64417534` | 85.2 M | 7.54 | ten compares a block to one lookup and bit tests; no block lexed twice; nothing read back from the window |
| tested at every offset | `b3e9576d` | 85.6 to 85.9 M | 7.55 | two carries removed, two bugs fixed (below) |

The code generator's stage reads between 9.09 and 9.33 ms across these builds though no step after `131f60aa` touches
it (its code lands at other addresses), and one binary read 85.19 M and 86.41 M user cycles in two holds, all of the
difference in that stage. The lexing stage repeats to 0.01 ms; it is what the lexer's steps are judged by.

### The first window lexer was not faster

The first cut (`w1`, 91.24 M) kept the old loop's stride: each block started where the last whole token of the block
before ended, so every block's first load waited for the block before, and a block cut at byte 63 lexed that token
twice. Its counters: 23.7 K windows, 130 K blocks at 94 cycles, 1.15 mispredicted branches a block. Blocks of exactly
64 bytes with the open token carried (`w2`) removed the dependency.

## What a load can forward from on Zen 5 (`stlf/`)

`stlf/stlf.c` runs a value through a store and a load of chosen widths and offsets; `stlf/stlf-run.txt` and
`stlf-run2.txt` are the 9700X's tables (cycles an iteration of the loop, and `ls_bad_status2.stli_other` an iteration).

- A general-register store and a load of the same size at the same address: 3 cycles for the whole loop (the load
  is renamed). A narrower load from it: 9.
- A 16- or 32-byte store to a 1-, 4- or 8-byte load anywhere in it, also across a cache line: forwards (14 cycles).
- A 64-byte store to a narrow load: forwards (16) unless the load straddles byte 32, or **the store crosses a cache
  line and the load is in the part in the second line** (20 to 26, one failure an iteration).
- Stores of 1, 4 and 8 bytes and then one load of 8, 16, 32 or 64 bytes over them: always fails, 18 to 25 cycles
  against 3 to 5.

The window's lexer stored its tokens with unaligned 64-byte stores and read the last one back in the next block (two
failures a block, `steps/w2-lines/stlf.lines.txt`); it now carries that token's index and first byte in registers.
What `perf` still counts there (90 K a compile) are the 64-byte loads of the text whose low 12 address bits match a
store to the window still in flight, which the counter takes for a conflict.

## Measured and not kept

- **A profile-guided build** (`pgo` in `steps/ab.txt`: the harness built with `-fprofile-use` from a profile of the
  same compile): 84.13 M against 88.04 M user cycles (-4.4%), instructions -11.5%, the code generator's stage 9.24 to
  8.58 ms and the lexer's unchanged. That is what placing and inlining the direct path's code by its real profile
  gives; the 43% of slots without an op from the front end are mispredicted paths' refills and the length of a
  token's way through the code, not its placement. `-O2`, `-Os`, `-O1`, `-fno-inline`, 64-byte function alignment, an
  inline threshold of 50 and no loop unrolling on the unit were each no faster than `-O3`.
- **Copying a `FastVal` a field at a time** at the value stack's 28 copy sites (`s1`): the loads that fail to forward
  fell from 750 K to 390 K a compile and the compile rose from 88.3 M to 89.3 M cycles, with 6.7 M more instructions.
  `perf` puts 22% of `fast_cc_expr`'s cycle samples on those copies because a load that waits holds the head of the
  reorder buffer, but nothing waits for the copy's result. Removing two copies outright (`s2`) gave what there was.
- **Directive lines lexed inside the window**, with `#define`, `#undef` and `#endif` not ending it (`d1`): 20.8 K
  windows a compile became 6.3 K and the lexing stage stayed at 7.56 ms. A directive's cost is its reader's and its
  handler's (60.5 K reader calls for 13.3 K directives), not the start of a window; the reader's fall-backs to
  `fast_lex_one` doubled (a comment after a directive's last token).

## Checked

- **Objects.** `scripts/equiv/run.sh` compiles 6,201 units with the driver's default `-c` (buster's `tests/`,
  c-testsuite, Lua 5.4.8, musl 1.2.5 with its own flags, `sqlite3.c` and `shell.c` in 14 configurations); 1,228 of
  them take the direct path. Against main `1c5287c3` 6,200 objects are identical. The other is `sqlite3.c` with
  `-DSQLITE_ENABLE_FTS5`, which main miscompiles: its 64-byte loop lexed the sign of an exponent as an operator, so
  FTS5's `1e-6` was `1e - 6` (-5.0).
- **The skipper against the function it replaces** (`scripts/skipfuzz.c`): 3 M random and assembled texts, each from
  a line's start and from inside a line, give the same directive, position and line number.
- **The lexer at every offset** (`test-direct`, in the repository): 103 token sequences at 131 offsets between six
  separators, with an inactive group. It found two bugs the corpus did not: a literal's prefix that ended at a block's
  last byte was not seen as a prefix (`u8"x"` at 2 of 131 offsets, in `64417534`), and `+++++` across a block's end
  lost a `+` once the pair's carry was removed. `scripts/lexer-faults.py` seeds 35 single-line faults; all fail the
  test (9 of the first 19 passed it while the cases were shifted together and not each by itself).

- **Sanitizers.** An ASan and UBSan build of the compiler (`BUSTER_SANITIZER=address`) passes `test-direct` and gives
  the Release build's result on 6,196 of the 6,201 units; MSan and TSan builds of the unit pass `test-direct`. The
  other five stop in code this branch does not touch, on main as on the branch: a division overflow in
  `fast_pp_apply_op` (`tests/checker/integer-extension-sources/0004.c`, the SIGFPE of buster#3577), a stack buffer
  overflow in `fast_cc_write_static_scalar` (`c_direct_cc.c:1017`, a `memcpy` of a 16-byte scalar from an 8-byte
  local, `tests/checker/programs/int128-bit-fields/int128-bit-fields.c`), and a NaN and a -1.5 converted to integers
  in the constant evaluator (`c_direct_cc.c:535` and `:536`, three of `tests/driver/warnings/default-warning/`).
  Reported on buster#3577.
- **The compile's count** (`tools/ci/compile-count.sh check`): 51,454,094 on main `1c5287c3`, 51,760,591 on the branch,
  +0.595%, stated as +0.60 in `tools/ci/compile-count/modest-einstein-tx5wvj.txt`. The count is how many times each
  region runs: a block of the window's lexer runs all of its regions whatever its tokens are.
- `repro/` has three small programs for what the profile's reading turned up in main's direct path: the exponent's
  sign, a character with no token kind passed as whitespace, and `__DATE__` and `__TIME__` as constants.

## What is left

By share of the compile's user cycles after the branch (`steps/functions.txt`, `final`): `fast_cc_expr` 14.3%,
`fast_pp_drain` 12.2% (the emitter's identifier lookups, a quarter of it; the expansion stack's loop, a token an
iteration), `fast_pp_lex_window` 8.4%, `fast_cc_compile_func` 5.7%, `fast_pp_read_tok` 4.7%, `fast_expr_reduce_top`
4.4%, `fast_pp_try_expand_ex` 4.4%, `fast_ident_intern` 3.7%, `fval_emit_call` 3.4%, `fast_cc_parse_declarator` 3.2%.

- Identifiers of more than 16 bytes go to `fast_ident_intern` every time (21.5 K calls, about 80 cycles each: four
  dependent loads); the 16-byte cache answers 95% of the rest but its hit is followed by a second load for the
  macro's bit.
- The reader serves a directive's and an argument's tokens one at a time (94 K calls a compile), each with a scan of
  the gap before it.
- The code generator is 9.2 ms of 17.1 and was not redesigned: its cost is a mispredicted branch every 230
  instructions and a token's path through about 100 KB of code. A profile-guided build is worth 7% there.
- The kernel's 9 to 11 M cycles a compile: clearing fresh pages 17%, mapping the source's pages 19%, unmapping 7%,
  path lookups 4%, the object's pages 6%.
