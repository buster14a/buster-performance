# #3577 rounds 13 to 15: the checks' cost against the merge queue's tip, by family

The merge queue held #3609 (the direct path's code generator: one-token specifiers, plain declarators, constant
conversions and the value layer's common cases without the full functions), #3606 (a file's mapping kept for the
compile) and #3604; their tip 8e4d32879 is main to be. buster#3597's branch merged with it locally (c6f3d8122, not
pushed while the queue runs) keeps every check: its object for sqlite3.c is the branch's (aef0e35896a7e863), and the
per-file bail reasons over `tests/`, c-testsuite and musl, and all 41 probe sets, are 6cb9d699e's exactly. All builds
are the 9700X job's (`BUSTER_HOST_ARCH=znver5`, Release), each under the lock; the unit is the job's sqlite3.c with
the host's headers, pinned to CPU 2.

## Round 13: the merge against the queue's tip (`scripts/m14.sh`, `results/m14.out`)

| | wall (41 interleaved) | user cycles | user instructions (the baseline step) |
| --- | --- | --- | --- |
| the queue's tip 8e4d32879 | 15.263 ms | 76.3 M | 196,796,789 |
| the merge with main's `__has_*` answers (main's tokens) | 16.639 ms (+9.0%) | 83.7 M | 219,129,694 (+11.35%) |
| the merge c6f3d8122 | 16.700 ms (+9.4%) | 83.9 M (+10.0%) | 219,280,915 (+11.43%) |

#3609 took 15.0 M instructions out of main's compile; the branch kept 13.3 M of them, so its checks now cost
22.3 M (against 20.8 M before the queue): where a fast path meets a check (a constant's conversion, a typedef's use
flags) the full function still runs.

## Round 14: each family switched off (`scripts/m15.sh`, `scripts/abl4.py`, `patches/abl-*.patch`)

Each variant is the merge with main's answers and one family's tests made opaque (`cc->pos == UINT32_MAX`) or its
stores dropped, measurement only; each compiles sqlite3.c to the answers build's object (db98657ecfac3ffb). `layout`
is the queue's tip with FastVal padded to the branch's 32 bytes and FastExprOp to its 28 (its object is the tip's).

| switched off | user instructions | the family's cost |
| --- | --- | --- |
| (the answers build) | 219,129,685 | |
| the binary operators' gate and its out-of-line check | 215,222,673 | 3.91 M |
| the out-of-line check alone (`fast_cc_binary_operands_quiet` never called) | 216,549,814 | 2.58 M |
| the identifier push's marks (purity, an enumerator's enum, the -Wunsequenced identity; round 15) | 217,545,142 | 1.58 M |
| conditions and discarded values | 217,559,674 | 1.57 M |
| the implicit conversion's non-pointer checks | 218,195,248 | 0.93 M |
| -Wunsequenced's counting and the expression's end | 218,419,834 | 0.71 M |
| unary operands and precedence | 218,655,562 | 0.47 M |
| layout: main's code with the branch's FastVal and FastExprOp sizes | 197,299,970 against 196,797,374 | 0.50 M |

(`results/m15.out`'s `push` and `allexpr` rows ran the previous variant's binary: their builds failed on unused
variables; `ops`, the operator's token dropped, made the direct path bail. Round 15 measured `push` again.)

These are 9.7 M of the 22.3 M.

## Round 15: where the rest goes (`scripts/m16.sh`, `results/ibs16-*.txt`)

IBS op samples (`ibs_op/cnt_ctl=1,swfilt=1/u -c 250000`) of 200 compiles each of the queue's tip and the answers build,
scaled to each one's instructions (the deltas add up to the measured 22.32 M):

| function | the tip | the answers build | delta |
| --- | ---: | ---: | ---: |
| fast_cc_expr (the expression compiler) | 26.08 M | 29.43 M | +3.35 M |
| fast_expr_reduce_top | 4.27 M | 7.38 M | +3.11 M |
| fval_emit_binary | 6.26 M | 8.13 M | +1.87 M |
| fast_cc_binary_operands_quiet (new) | 0 | 1.82 M | +1.82 M |
| fast_cc_parse_declarator_full | 4.92 M | 6.51 M | +1.59 M |
| fast_cc_parse_decl_specs_full | 2.40 M | 3.55 M | +1.15 M |
| fast_cc_compile_func | 15.39 M | 16.34 M | +0.96 M |
| fast_cc_compile_unit | 2.13 M | 2.89 M | +0.77 M |
| fast_cc_write_static_scalar | 0.33 M | 1.05 M | +0.72 M |
| fast_cc_binary_questioned (new) | 0 | 0.68 M | +0.68 M |
| fval_branch | 1.83 M | 2.48 M | +0.65 M |
| ftype_make_ptr | 0.02 M | 0.55 M | +0.53 M |
| fast_pp_finish_directive (new) | 0 | 0.50 M | +0.50 M |
| fast_pp_apply_op | 0.22 M | 0.66 M | +0.44 M |

and about forty more of 0.1 to 0.4 M each: the implicit conversion's full check, `#define`'s, the macro calls', the
number and character literals' spellings, the calls', the static constants', the attributes', the redeclarations'.

## What it says

No family is the cost: the largest is 3.9 M of 22.3 M, and the rest is a tail. Each check runs at each name,
operator, conversion, declarator and directive, and computes its whole condition there. Its floor, a byte of class
kept with each value and a table's answer per operation, is a few instructions an operation: sqlite3.c's 98 K name
pushes, 27 K binary operators, 62 K implicit conversions, 47 K expressions and 43 K declarators put it near 1 M at
three instructions each, against 22.3 M now. Reaching it means rewriting the checks as tables over precomputed
classes, not trimming them.
