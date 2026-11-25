# The direct path's code generator: census and its common cases (buster#3581)

[buster#3581](https://github.com/buster14a/buster/issues/3581): the direct path's code generator (`c_direct_cc.c`,
`c_direct_types.c`'s declaration parser, `c_direct_x86.c`) was half of `sqlite3.c`'s compile and had had no
redesign. This record has the census the issue asked for first, what it says about the design question, and the
steps that were built, each timed on the 9700X. Work of 2026-11-25 on buster's branch `claude/inspiring-lamport-hape45`
(commits `f4176488`, `d3bef42a` on main `20f3573e`).

- **Host:** `benchpress` (Ryzen 7 9700X), every run under `~/buster-fast-bench/exclusive.sh`, CPU 2, the object on
  `/dev/shm`. The unit is the frozen `sqlite3.c` as the earlier records compile it
  ([direct-speed-2850-2026-11-24](../direct-speed-2850-2026-11-24/README.md)).
- **Builds:** the earlier records' harness (`scripts/direct_main.c` around `c_direct_try_compile`, 20 compiles a
  process, stage medians), built for znver5 in a cloud container with CI's clang 23.1.4 (`scripts/mk.sh`) and shipped;
  the products built on the 9700X as its job builds them (`BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0`).
- **Scripts:** `scripts/ab.sh` (rotated rounds of the harness, one hold), `scripts/ab-product.sh` (the product's `-c`,
  a process a run), `scripts/build-tree.sh` and `scripts/measure-instr.sh` (the job's build and its instruction
  baseline's step), `scripts/prof.sh`, `scripts/ibs.sh` and `scripts/lines.sh` (samples, precise retired ops by
  function and line), `scripts/census/` (the counters: `census.diff` is the whole patch to main's sources, `patch.py`,
  `dump.c` and `c_direct_census.h` its first pieces).

## Result

| 9700X, `sqlite3.c` | main `20f3573e` | the branch | |
| --- | ---: | ---: | ---: |
| the product's `-c`, wall (21 rotated runs, a process each) | 16.420 ms | **15.600 ms** | -5.0% |
| user cycles | 81.39 M | **76.94 M** | -5.5% |
| user instructions | 221.07 M | **206.82 M** | -6.4% |
| mispredicted branches | 976 K | 955 K | -2.1% |
| parsing and generating code, the harness's stage (3 placements each, 11 rotated rounds) | 8.584 / 8.614 / 8.653 ms | **8.003 / 7.947 / 7.892 ms** | -7.7% (medians) |
| lexing and preprocessing, the same | 6.929 / 6.950 / 6.944 ms | 6.956 / 6.981 / 6.950 ms | |
| the object | `f558aaf503fcb186` | the same | |

`results/product.txt` and `results/ab-final-placements.txt` have the rows. The placements are each side's sources with
a 16- and a 48-byte function of `nop`s ahead of `FastArena` in `c_direct_lex.c`.

- **Objects:** the earlier record's corpus (`../direct-speed-2850-2026-11-24/scripts/equiv`: buster's `tests/`,
  c-testsuite, Lua 5.4.8, musl 1.2.5, `sqlite3.c` and `shell.c` in 14 configurations) gives the same status, stderr and
  object for all 6,201 units with main's compiler and the branch's; 1,196 take the direct path. `test-direct` passes
  19 of 19; `check-call-graph` finds no cycle; the harness built with ASan and UBSan compiles `sqlite3.c` to the same
  object.
- **The compile's count** (`tools/ci/compile-count.sh check`): 46,561,456 at main, 41,467,637 at the branch, -10.939%,
  stated in `tools/ci/compile-count/inspiring-lamport-hape45.txt`.
- **The 9700X job's instruction baseline** (`measure-compile --instructions-baseline`, the job's step on the job's
  build): main reads 220,903,319, already 4.3% under `tools/ci/compile-instructions.txt`'s 230,887,792 (merges since
  #2850 moved it without writing it); the branch reads 206,648,848 and writes it there.

## The census

Counters in a copy of the sources (`scripts/census/`), one compile of `sqlite3.c`; the object is unchanged.
`census/counts.txt` and `census/counts-extra.txt` have every number.

- **Expressions:** 46,973 calls of `fast_cc_expr`: 26,422 statements whose value is discarded, 12,540 conditions, 8,011
  values. 352,883 iterations of its token loop, 7.5 an expression; a third of the expressions have three tokens or
  fewer. 96,929 operands are identifiers: 82,179 locals, 13,623 functions, 1,123 objects.
- **Their shapes** (token kinds, identifiers by symbol kind; `census/counts.txt`'s end): 8,686 distinct. The 13 most
  common (`L = int`, `L -> m = int`, `L == int` as a condition, `F ( L )`, ...) are 35% of the expressions and the 120
  most common 59%. By time (`census/shape-ticks.txt`, `rdtsc` around each call, in the container) the 120 hold about a
  quarter of the function's time: the cost is in the long tail.
- **The value layer:** `fval_convert` 115,616 calls, 82,391 of them to the value's own type, which changes nothing but
  qualifiers, and 10,761 an integer constant to another integer type; `fval_to_gp` 130,318, 42,925 of them a value
  already in a register; `fast_cc_check_implicit_conv` 61,669, 30,956 without a pointer on either side;
  `fval_spill_one` 61,078, 50,310 of them a value with no register to spill; `fval_flush_flags` 30,412, finding
  flags 7 times; `fval_alloc_gp_avoid` 72,735, never finding the pool full.
- **Declarations** (`census/declarations.txt`): 20,310 specifier lists, 12,525 of one token (a scalar keyword or a
  typedef's name), and 18,143 parameters' specifiers, 15,024 of one token; 23,217 declarators, 11,675 a name after at
  most two plain stars; 49,954 `fast_cc_is_type_start` questions.
- **Statements:** 104,082 iterations of the statement loop; by first token 27,470 identifiers, 12,823 blocks, 10,964
  `if`, 7,858 empty statements, 4,338 `return`.

## Where the ops went

Precise retired-op samples (AMD IBS, `scripts/ibs.sh`, `results/ibs/`) at main put the value layer at 44% of the
generator's ops: `fval_convert` 4.2% of the compile's, `fval_to_gp` 4.1%, `fval_emit_call` 3.9%, `fval_emit_binary`
2.9%, `fval_store` 1.7%, `fast_cc_check_implicit_conv` 1.6%, `ftype_decay` 1.2% (a `static inline` function the
compiler kept out of line). A quarter of `fval_convert`'s and `fval_to_gp`'s ops were their entry and exit lines: the
rare cases (128-bit integers, bit-fields, flags, floats) made each of them save every register it might use, and the
common case, which does a compare or nothing, paid for that on each call.

## The steps

Each step's object is `f558aaf503fcb186`. The stage is parsing and generating code, the harness's median; each hold
has main beside the steps it timed (`results/ab-holds-*.txt`).

| step | what | instructions | stage ms (main in the same hold) |
| --- | --- | ---: | ---: |
| main `20f3573e` | | 220.96 M | |
| s1 | `fval_convert` to the same type, `fval_to_gp` of a register, the implicit conversion's check without a pointer, `fval_spill_one` of a value without a register, `ftype_decay` of a type that doesn't decay, a free register from the pool: each inline, the full function out of line | 212.86 M | 8.387 (8.597) |
| s2 | the inline paths forced inline; `fval_to_gp`'s loads (a constant, a slot, an object through a register) in a lean function, its rare kinds in a cold one | 211.56 M | 8.225 (8.619) |
| s3 | `fval_flush_flags` a leaf scan; `fast_cc_is_type_start`'s keywords a bit test inline; `__attribute__`'s absence tested inline | 209.19 M | 7.980 (8.576) |
| s4 | specifiers of one token and declarators of a plain name answered without the full parsers | 206.34 M | 7.915 (8.592) |
| s5 | an integer constant converted to another integer folded in a small function | 206.10 M | 7.878 (8.588) |
| s7 | the statement loop reads a statement's first token once | 206.71 M | 7.907 (8.607; s5 7.959) |

Steps s5 and s7 are each within the 1% that a build's placement moves this stage; s1 to s4 are not. Kept as a whole,
the three placements of each side above read -7.7%.

## Measured and not kept

- **`fast_expr_reduce_top` split** (s6): binary operators and assignments, 45,000 of its 55,000 reductions, through a
  lean dispatcher and the rest through the full function. 7.873 ms against s5's 7.878, with 0.2 M more cycles:
  dropped.

## The design question

The issue asked whether a body's expressions can be typed and selected in rounds before any bytes are emitted. The
census answers the cheapest form of it: selecting by an expression's whole shape reaches the head of the shape
distribution, and the head is about a quarter of the expressions' time, so a by-shape selector, which keeps the
general path for the rest and pays to recognize every expression, has a ceiling of a few percent of the stage. It was
not built. A typing pass in rounds would need records the one-pass generator doesn't have and a second walk to emit;
the decisions it would batch (a value's kind and type at each operator) are now a compare and a field write inline.
The front's emitter, rebuilt the same way as a branch-free resolve pass and an ordered event loop, lost 0.9 ms
([direct-speed-2850-2026-11-25](../direct-speed-2850-2026-11-25/README.md)).

What paid is what the census says is common: 82,000 conversions to a value's own type, 43,000 registers taken,
31,000 checks without a pointer, 50,000 spills of nothing, 27,500 one-token specifiers and 11,700 plain declarators
are each a few ops inline, and the full functions, with the registers they save, run for the rest.

## What is left

By IBS's share of the compile's ops after s3 (`results/ibs/s3-by-function.txt`): `fast_cc_expr` 12.7% (its token
loop: the loop's tests, the operand's record, the operator's dispatch), `fast_cc_compile_func` 6.7%, `fval_emit_call`
4.5% (four passes over the arguments), `fval_to_gp_full` 3.6%, `fast_cc_parse_declarator` 3.6%, `fval_emit_binary`
3.0%, `fval_store` 2.2%, `fast_expr_reduce_top` 2.2%. The compile still mispredicts 940 K branches, about 18 M of its
76 M cycles, most of them a token's and a value's kind; a profile-guided build was worth 7% of this stage in the first
record. Code changes that would also make the code better (a store of a constant, `L = 1;`, goes through a register
because the statement's value is kept) change the object and were out of this work's scope.
