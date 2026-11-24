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
  (event counters in a copy of the sources, for the counts below).

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
