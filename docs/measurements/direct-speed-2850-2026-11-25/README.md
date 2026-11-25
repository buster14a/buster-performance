# The direct path's speed, second profile (`c_direct`, buster#2850): branch records on the 9700X

Work of 2026-11-25 on buster's branch `claude/exciting-carson-r9uggb` (commits `f1339089`, `44b21d0f`,
`e9779107` on main `56490ed9`), after [the first record](../direct-speed-2850-2026-11-24/README.md). Its summary is in
buster's `docs/one-core-path.md`, "The second profile".

- **Host:** `benchpress` (Ryzen 7 9700X), every run under `~/buster-fast-bench/exclusive.sh`, CPU 2, the object on
  `/dev/shm`. The unit is the frozen `sqlite3.c` as the first record compiles it.
- **Builds:** the first record's harness (`direct_main.c` around `c_direct_try_compile`), built for znver5 in a cloud
  container with CI's clang 23.1.4 and shipped (`scripts/mkn.sh`), and the product built the same way
  (`scripts/build-products.sh`).
- **Scripts:** `ab.sh` and `ab-product.sh` (the A/B readings), `prof.sh` and `prof2.sh` (samples by line), `lbr.sh`
  (branch records: taken and mispredicted branches by address), `ibs.sh` (retired ops by line), `ev.sh` (any event by
  function and line), `ic.sh` (instruction-cache fills), `lbrmap.py` and `bucket.py` (addresses and lines to inlined
  functions).

## Result

`results/ab.txt` has every hold's rows.

| | main `56490ed9` | the branch | |
| --- | ---: | ---: | ---: |
| the product's `-c`, wall (21 rotated runs) | 17.45 ms | 16.63 ms | -4.7% |
| user cycles | 85.80 M | 82.93 M | -3.3% |
| kernel cycles | 10.83 M | 9.36 M | -13.6% |
| user instructions | 229.5 M | 227.2 M | -1.0% |
| mispredicted branches | 962 K | 939 K | -2.4% |
| the harness: lexing and preprocessing | 7.17 ms | 6.88 ms | -4.1% |
| the harness: parsing and generating code | 9.19 ms | 8.97 ms | -2.4% |
| the harness: writing the object | 0.280 ms | 0.142 ms | -49% |
| preprocessed tokens | 715,306 | 672,690 | -6.0% |
| the object | `ff67ee922b96b089` | the same | |

The first record's 6,201-unit corpus (`../direct-speed-2850-2026-11-24/scripts/equiv`) gives the same status,
diagnostics and object for every unit, 1,228 of them the direct path's. `test-direct` passes 12 of 12, the
c-testsuite's 220 programs pass `test-c-testsuite --cross-check`, and an ASan and UBSan build of the unit compiles
`sqlite3.c` to the same object. The compile's count moves by -1.642% (51,777,145 to 50,926,605).

## What the samples hid

Cycle and branch-miss samples by line put every function at the same share of cycles, instructions and mispredicted
branches (the first record's "the profile is flat"). Two precise sources say otherwise:

- **Branch records** (`lbr.sh`, `results/branches-e1.txt`, `branches-e7.txt`): of 550 K sampled taken branches 34 K
  were mispredicted, and **20 branch addresses hold half of them**, 70 hold 71%. A record is 11.6 branches a compile
  (the emitter's test for a name of more than 16 bytes is taken 14.9 K times a compile and has 1,282 records).
  Records are of taken branches only, about 40% of the compile's 960 K mispredicted ones.
- **IBS** (`ibs.sh`, `results/base/ibs.txt`): retired ops by line. `fast_expr_reduce_top` has 2.1% of the ops and
  5.2% of the cycle samples; `fval_convert` 4.3% and 2.4%.

Per compile, the largest taken-and-mispredicted branches on main (`branches-e1.txt`, records x 11.6):

| branch | mispredicted |
| --- | ---: |
| `fast_cc_expr`: the dispatch on the token after an operand (a jump table) | 25 K |
| `fast_pp_emit_window`: the name is a macro | 19 K |
| `fast_pp_emit_window`: the token is no identifier | 19 K |
| `fast_skip_block_comment`: the block that ends the comment | 17 K |
| `fast_pp_emit_window`: the name is longer than 16 bytes | 13 K |
| `fast_cc_expr`: the symbol's kind (fixed: 13 K) | 13 K |
| `fast_cc_expr`: an expression's first token is an identifier (two sites) | 22 K |
| `fast_cc_compile_func`: a label's and a statement's kind (four sites) | 23 K |
| `fval_to_gp`: the value's kind | 10 K |
| the cache's miss in `fast_ident_lookup_16` | 7 K |
| `fast_pp_lex_window`: a block with a byte that needs a decision | 7 K |
| `fval_emit_call`: an argument is a constant | 7 K |

## What a mispredicted branch and an instruction cost

From steps whose objects are the same: the symbol's kind without a branch (hold 2) took 19.8 K mispredicted branches
away and 0.37 M cycles with 1.5 M more instructions: **19 cycles a mispredicted branch** after the instructions'
0.3 cycles each. 960 K mispredicted branches are 18 M of the compile's 84 M cycles.

## The steps

| step | user cycles | what |
| --- | ---: | --- |
| main `56490ed9` | 84.0 M | |
| operands in place (e1) | 83.5 M | `fast_expr_reduce_top` copied both 40-byte operands into locals |
| the symbol's kind without a branch (e2) | 83.1 M | two tables and two masks; -19.8 K mispredicted branches |
| glibc's `assert` (e4) | 82.3 M | the test asked for five body tokens of six: 5,327 asserts through two expansion frames each; -42,616 tokens |
| `FastVal` without padding (e5) | 81.8 M | its last word was written with a narrow store and loaded whole |
| a binary operator's result in place (e6) | 81.8 M | -71 K forwarding failures, no cycle |
| the object in place, `MAP_POPULATE`, missing paths (e7) | 81.6 M user, 8.9 to 7.6 M kernel | see below |

**The kernel** (`results/e6/cycles_k.txt` before, `e7/cycles_k.txt` after): replacing the old object's pages
(`find_lock_entries`, `filemap_remove_folio`, `free_unref_folios`, `folios_put_refs`: 16% of the kernel's cycles)
goes with `O_TRUNC`; `next_uptodate_folio` (10%, a fault each sixteen pages of the source) goes with `MAP_POPULATE`;
`__d_lookup_rcu` and the permission checks fall with the include search's failed `access()` calls. What is left is
clearing the arenas' pages (27% of 7.6 M: ten huge pages for 20 MB of buffers whose caps are larger than their use),
the object's 512 page writes, and unmapping.

## Measured and not kept

- **The emitter as a pass without branches and a loop of events** (hold 3, `scripts/rejected-emitter-by-lists.c`):
  every token of a window resolved first into window-parallel kinds, data and an event byte (an identifier's id from
  the cache with no branch on the hit, a number of one to four digits by arithmetic), then the events (a missed or
  long name, a macro, a literal, a scalar token) in order, and the runs between them copied to the output. +10.7 M
  instructions, +26 K mispredicted branches, the lexing stage 7.19 to 8.11 ms. sqlite3.c has 69 K events for 240 K
  identifiers, their dispatch is less predictable than the old loop's four biased branches, and a window's tokens
  are resolved before its macros are known, so skipped arguments are resolved for nothing.
- **Block comments four blocks a step** (hold 8): one branch for "the comment ends in these 256 bytes" and a
  selection of the block. +3.6 M instructions, -4 K mispredicted branches, +0.8 M cycles.
- **Results in place for forwarding** (hold 6): 52% of `fast_expr_reduce_top`'s cycle samples were on the load of the
  result `fval_emit_binary` had just written (64% after the padding's fix). In place: no cycle. A pile of samples is
  where retirement waits.
- **Flags on the unit** (hold 9): `-mllvm -x86-cmov-converter=false` -0.36% (the spread between two builds of one
  tree is 0.02 to 0.3%), `-fno-jump-tables` +0.9%.
- **Not built:** parsing a file-scope prototype at its first use (2,242 never referenced, 43,659 tokens): it would
  accept an invalid prototype silently.

## What is left

931 K mispredicted branches (17.7 M cycles) and 227 M instructions. The mispredicted branches are a one-token-at-a-time
parser's dispatches on kinds, which no restructuring of the loops removed without adding more instructions than it
saved. Further: fewer tokens through both stages; the first record's profile-guided build (-4.4%); the two stages on
two threads (a wall-clock gain the pinned gauges would not show).
