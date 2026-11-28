# The direct path's redesign (buster#2850): what was measured for it on the 9700X

The owner asked on 2026-11-28 for a redesign that makes buster's direct path (`c_direct`, the default for a plain
`-c` of one C file) "in the order of GB/s faster", on one core if it can be. The design is
[buster's `docs/direct-path-redesign.md`](https://github.com/buster14a/buster/blob/main/docs/direct-path-redesign.md)
and [buster#2850](https://github.com/buster14a/buster/issues/2850) has its claim. This record is what was measured
for it: where today's compile spends its cycles, the generator compiled with no code made, a prototype of the front
as two passes, and that prototype on several cores.

- **Host:** `benchpress` (Ryzen 7 9700X), every run under `~/buster-fast-bench/exclusive.sh` by itself, pinned to
  CPU 2 unless a run pins its own lanes or workers. The lock's lines that name other sessions are removed from the
  files.
- **Unit:** the frozen `sqlite3.c` (9,507,037 bytes) with the corpus's headers and predefines and the 9700X job's
  options (`-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`).
- **buster:** main `cc7d4ffb`.
- **Builds:** in a cloud container with CI's clang 23.1.4, `-march=znver5 -O3`, static, and shipped. The harness is
  [the generator's record's](../direct-generator-3581-2026-11-25) `direct_main.c` around `c_direct.c` with the
  product's flags (`scripts/mk.sh`), changed here to answer the driver's feature queries from a table
  (`scripts/features.txt`) and to read hardware counters at each stage's mark (`--counters`). Its object for the unit
  is the product's (`2,056,632` bytes, the same hash).
- **Units of time:** the host's TSC runs at 3.793 GHz (2,509,862 ticks in 661,772 ns) and a busy core at 5.50 GHz,
  so a tick is 1.45 cycles. Counters are user mode's.

## Today's compile

`scripts/bp-gen.sh`, two turns; `results/gen-main-{1,2}.out`. 31 compiles in a process; medians.

| stage | ms | cycles | instructions | mispredicted | L1D read misses | no op from the front end |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| lexing and preprocessing | 6.48 | 32.43 M | 91.48 M | 382 K | 369 K | 7.32 M cycles |
| parsing and generating code | 9.00 | 48.64 M | 119.02 M | 608 K | 226 K | 17.45 M |
| the object's write | 0.15 | 0.10 M | 0.29 M | | | |
| a compile | 15.97 | 81.19 M | 210.82 M | 991 K | | 24.80 M |

`perf stat` around the process (`results/main-1.csv`, `main-41.csv`; the difference of 41 compiles and 1, over 40):
81.00 M user cycles and 6.71 M kernel cycles a compile; a process's first compile 82.87 M and 10.69 M.

**The stages' parts** are from `patches/c_direct-instrumentation.diff` built with `-DBUSTER_DIRECT_TIMERS`: the TSC
read where the front changes what it is doing (`fast_pp_drain`, the directives, the macro stops, the skip, the
expansions, a file that is not the main one), and around `fast_cc_expr` and the three calls of
`fast_cc_compile_func`. The build is 3% to 4% slower (`results/gen-timers-{1,2}.out`: 33.7 M and 50.1 M cycles for
the two stages, medians of 15 compiles). `results/timers.out` is its first run. Shares of a stage's ticks, applied to the stage's cycles
(`scripts/budget.py` does the arithmetic):

| | share | M cycles |
| --- | ---: | ---: |
| the front: the main file's text | 39.6% | 12.85 |
| its directive lines (6,798 read) | 9.2% | 3.00 |
| its macro stops (12,946) | 8.0% | 2.60 |
| its skipped groups (1,915) | 6.5% | 2.11 |
| its tokens by the scalar lexer (670) | 0.5% | 0.17 |
| the expansions | 12.1% | 3.93 |
| a file that is not the main one: 157 headers (697,372 bytes), the predefines (473 lines) | 24.0% | 7.78 |
| the generator: expressions (47,009; 352,614 tokens; 1,071,411 bytes of code) | 66.9% | 32.53 |
| the rest of the bodies (2,675 bodies, 526,309 tokens in all) | 21.7% | 10.55 |
| the file scope | 11.4% | 5.56 |

The front's ticks are wall time: its 6.5 ms hold the kernel's time for the headers' files as well as the 5.9 ms of
its user cycles.

`results/bodies-timers-{1,2}.txt` has a line a body (its first token, its tokens, its ticks, its code's bytes): a
median of 76 tokens, a mean of 197, the largest 23,634 tokens and 4.0% of the bodies' ticks; the 16 largest hold
16%, the 256 largest 51%. A token costs 74 ticks in bodies under 50 tokens and 47 in those over 5,000.

`results/census-sqlite3.txt` (the text's bytes and raw tokens, `census/bytes.c`), `results/dump-counts.txt` and
`results/oracle-stats.txt` (the stream) have the counts the design quotes.

## The generator with no code made

`c_direct` compiles a dead branch through `eval_only`: its expressions are read, typed and checked, and no code is
made for them. `-DBUSTER_DIRECT_NOCODE` (the same patch) starts every body so, and lets pass the 94 refusals that
follow from it (a placeholder value has no constant, so a check that asks for one refuses: the first is "a cast
between a pointer and a smaller integer"). One body of 2,675 is not compiled (a deferred inline function: with no code made, nothing
refers to it), and 0.1% of the tokens with it. `results/gen-nocode-{1,2}.out`, against the timers' build of the same turn:

| the generator | as it is | no code for expressions | |
| --- | ---: | ---: | ---: |
| cycles | 50.01 M | 34.63 M | 69.2% |
| instructions | 125.03 M | 92.60 M | 74.1% |
| mispredicted branches | 607 K | 427 K | 70.4% |
| cycles with no op from the front end | 17.38 M | 10.67 M | 61.4% |
| expressions, ticks | 23.04 M | 13.33 M | 57.9% |
| the rest of the bodies, ticks | 7.46 M | 6.65 M | 89.2% |
| the file scope, ticks | 3.89 M | 3.83 M | 98.4% |
| code | 1,254,526 bytes | 131,204 | |

Applied to the product's 48.64 M: reading 33.68 M (expressions 18.82 M, 53 cycles a token; the rest of the bodies
9.41 M; the file scope 5.47 M) and making code 14.96 M (13.71 M of it the expressions').

**By function** (`scripts/bp-genprof.sh`; `results/gen-{main,nocode}-symbols.txt`, cycles sampled, 41 compiles, and
`-bm-` for mispredicted branches). Share of each build's own user cycles, as cycles a compile:

| | as it is (81.2 M) | no code (68.2 M) |
| --- | ---: | ---: |
| `fast_cc_expr`, the expressions' token loop | 15.9%, 12.9 M | 19.6%, 13.3 M |
| `fast_cc_compile_func`, the statements' loop | 9.2%, 7.5 M | 8.5%, 5.8 M |
| `fast_expr_finish_call` | 4.9%, 4.0 M | 2.2%, 1.5 M |
| `fval_emit_binary` | 3.2%, 2.6 M | 1.4%, 0.9 M |
| `fval_to_gp_full`, `fval_store`, `fval_convert_full` | 6.3%, 5.1 M | 0.5% |
| `fast_cc_parse_declarator_full`, `fast_cc_parse_decl_specs_full` | 3.8%, 3.1 M | 4.5%, 3.0 M |
| `fast_expr_reduce_top`, `fast_expr_reduce_unary` | 2.6%, 2.1 M | 2.9%, 1.9 M |
| the front: `fast_pp_drain`, `fast_pp_lex_window`, `fast_pp_run_calls`, `fast_pp_skip_inactive` | 27.3%, 22.2 M | 33.9%, 23.1 M |

The two token loops are 20 M cycles of the compile whether code is made or not.

## The front as two passes: the prototype

`prototype/`, about 4,100 lines of C that this record's session wrote; the kinds' numbers, the lexer's tables and
the number rules are restated from buster's `c_direct_lex.c`.

- `ref.h`: a scalar reference: each byte's mode (code, comment, a literal's opening quote, its tail), the directive
  lines, one token.
- `scan.h`: **pass A.** Two words a block of 64 bytes (comment bytes, literal tails) and the list of the `#` that
  start directive lines. Block comments by an add that carries a set to its reset; in the blocks that have a quote,
  an apostrophe, a backslash, a `#` or a `//` outside block comments (12%), line comments by the same add, escaped
  bytes by two adds, strings and character constants by carry-less multiplies; a block whose checks fail (0.47%) by a
  scalar machine. `scan_chunk` and `scan_join` are the scan by chunks.
- `lex.h`: the raw tokens of a window from the masks, on a grid of 64 bytes.
- `table.h`: the names: two slots a cache line, a name of up to 16 bytes inline, the token an occurrence emits in
  the slot. `table_v.h`: the same with versions and slots made by compare-and-exchange.
- `oracle.h`: the recording. `-DBUSTER_DIRECT_DUMP` in the patch makes `c_direct` write its stream (kinds, data),
  each token's place in the main file's text, its identifiers and the macros' bindings in order; from them the
  events: where the text stops being its own tokens (a directive line, a macro's call), which tokens follow, and
  where the text goes on.
- `front.c`: the sequential front. `front_par.c`: the same on lanes. Both take each event's tokens and bindings from
  the recording, make everything else themselves, and check their stream against the recording's: every kind, the
  names by a bijection of the two tables' ids, the integers' values. Literals' pool indexes are not made.
- `scan_test.c`: pass A against the reference, on files and on random texts, and the scan by chunks against the
  single scan.

**Checked.** Both fronts: `SAME as the recording` in every run here (673,391 tokens; 207,612 names and 42,797 values
compared). Pass A against the reference, and the scan in 2, 3, 5, 8 and 13 chunks against the single scan
(`results/scan-check.txt`, run in the cloud container): `sqlite3.c`; 6,000 files of the frozen corpus (156,000
guessed chunks, 12 of them scanned again, 1,030 `#` decided at a join); two million random texts made of the bytes
the scan decides on (52 million chunks, 6.0 million scanned again, 367 thousand `#` decided at a join). None
differs. Four million random texts more passed the single scan's check before the chunks' was written.

**One core** (`scripts/bp-batch.sh`, `bp-ab.sh`, `bp-sizes.sh`; 51 rounds a run, medians):

| | file | cycles | instructions | mispredicted |
| --- | --- | ---: | ---: | ---: |
| the first build that matched the recording | `front-first.out` | 19.98 M | 53.9 M | 232 K |
| the scan's common blocks in a loop of their own; the names' loop with no call, its arrays one region, misses set aside (`patches/front-names-one-loop.diff` gives this build from `front.c`) | `ab.out`, `front-v3` | 16.71 M | 53.5 M | 116 K |
| ... a chunk's keys and buckets first, each bucket's line asked for: `front.c` | `ab.out`, `front-v4`; `par.out`, `sequential` | **16.19 M to 16.25 M** | 57.0 M | 123 K |
| pass A alone | the same | 3.53 M | | |
| a table of 1 MB (`TABLE_BUCKET_BITS` 14) | `sizes.out`, `front-b14` | 17.14 M | 58.5 M | 139 K |
| a table of 0.5 MB (13) | `front-b13` | 19.53 M | 65.6 M | 175 K |

Its cycles by function (`results/front-symbols.txt`; a round there has pass A twice, once alone): of the front's
16.2 M, `scan_blocks` 22%, `front_names` 35% (22 cycles each of 257,242 names), `lex_window` 18% (40 cycles a block of
the text it reads), `front_emit` 8%, `front_numbers` 8%, the misses' and long names' lookups 3%, `front_event` 2%.

What it stands beside in today's compile is the main file's text with its skipped groups and scalar tokens:
15.1 M cycles. The prototype's 16.2 M has in it the events' copies (101,770 tokens, 0.3 M cycles by the profile)
and the bindings (0.8 M cycles, measured apart on one lane below).

**On lanes** (`scripts/bp-par.sh`; `results/par.out`). Each lane on a core of its own (`--cpus`), 4 scan chunks and
16 tasks a lane, 51 runs; the wall time is from the first lane's start to the stream complete in one array, with the
other lanes' threads made inside it unless the row says kept.

| lanes | wall | GB/s of source | bindings and scans | join and cut | tasks | copies | tasks' work, summed |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | 3.434 ms | 2.77 | 0.808 ms | 0.012 | 2.572 | 0.041 | 2.572 ms |
| 2 | 1.822 ms | 5.22 | 0.444 | 0.012 | 1.338 | 0.027 | 2.639 |
| 4 | 0.970 ms, 0.969 | 9.80 | 0.224 | 0.013 | 0.712 | 0.020 | 2.770 |
| 6 | 0.728 ms | 13.06 | | | | | |
| 8 | 0.662 ms, 0.663 | 14.37 | 0.198 | 0.015 | 0.418 | 0.031 | 3.270 |
| 8, threads kept | 0.600 ms | 15.86 | | | | | |
| 15, every thread | 0.679 ms | 13.99 | | | | | |
| `front.c` | 2.946 ms | 3.23 | | | | | |

No chunk's guess was wrong and no `#` was left to the join; 38 of the 257,242 lookups went by a name's list of
bindings (145 of the unit's names are bound more than once). `results/par2.out` is `front_par` built from the
sources as they are here (the chunks' scan and join moved from `front_par.c` to `scan.h` after `par.out`'s runs,
for `scan_test.c`; no other change): 0.662 ms on eight lanes again.

## Eight compiles at once

`scripts/bp-scale.sh`; `results/scale.out`. N copies of the harness at once, each on a core of its own, 30 compiles
each:

| workers | a compile, median | the batch | GB/s |
| ---: | ---: | ---: | ---: |
| 1 | 16.03 ms | 30 in 0.487 s | 0.59 |
| 2 | 16.74 ms | 60 in 0.529 s | 1.08 |
| 4 | 19.49 ms | 120 in 0.580 s | 1.97 |
| 8 | 25.08 ms | 240 in 0.754 s | 3.03 |
| 8, again | 23.2 ms | 240 in 0.688 s | 3.31 |
| 15, every thread | 22.1 to 38.0 ms | 450 in 1.117 s | 3.83 |

A compile beside seven others takes 1.45 to 1.56 times its time alone.

## Running it again

`scripts/mk.sh NAME [TREE]` builds the harness around a tree's `c_direct.c` (`EXTRA_FLAGS` for the patch's macros);
`prototype/*.c` build alone (`clang -O3 -march=znver5 -static front.c`, `front_par.c -lpthread`). The recording is
made by the harness built with `-DBUSTER_DIRECT_DUMP` and `BUSTER_DIRECT_DUMP_DIR` set; `front DUMP SOURCE ROUNDS`
and `front_par DUMP SOURCE ROUNDS LANES [--cpus A,B,...] [--warm]` read it. The `bp-*.sh` scripts are what ran on
the host, from a directory in `/tmp` with the binaries beside them.
