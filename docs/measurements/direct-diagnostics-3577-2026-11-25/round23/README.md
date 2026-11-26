# Round 23: a misaligned zeroing that costs nothing, the remaining checks by function, and a fast path that pays

[buster#3597](https://github.com/buster14a/buster/pull/3597)'s head eeee61ef8 against main 1e1ca2dd6, after round 22
put the checks' conditions at 3.09 M cycles and the rest at 3.49 M (2026-11-26). Builds are the 9700X job's
(`BUSTER_HOST_ARCH=znver5`, Release) under the host lock; sqlite3.c with the host's headers, `taskset -c 2`.

## r1: the declarations zero their records in 32-byte stores (`patches/r1.patch`, `scripts/bp-r1sweep.sh`)

Round 22's microbenchmark found that Zen 5 refuses to forward a 64-byte store that isn't 32-byte aligned to some loads
in the next cache line, and the head's 88-byte declarator result is zeroed by two such stores right before its fields
are read (`dr.attr.asm_label_len` at every stack alignment, `asm_label` at two of four, `aligned` at one). r1 puts
`__attribute__((target("prefer-256-bit")))` on the declaration functions (`fast_cc_compile_func`, `compile_unit`,
`parse_declarator_full`, `parse_decl_specs_full`, `parse_typename`, `parse_scalar_or_tag_specs_full`, `init_local`,
`init_static`): no 64-byte store is left in them. Over eight placements that move the code's alignment
(`results/r1sweep.txt`, rounds 2 and 3):

| arm | cycles | instructions | refused forwards |
| --- | ---: | ---: | ---: |
| main | 77.04 M | 195.79 M | 425 K |
| head | 83.31 M | 212.54 M | 305 K |
| r1 | 83.56 M | 212.69 M | 264 K |

41 K fewer refused forwards and no time saved (this hold read main 1.5 M cycles higher than round 22's; the arms are
compared within it). The cycles those lines showed are mispredicts' landings (below), not the stores.

## Mispredicts (`scripts/bp-misp.sh`, `results/misp.txt`, `results/pm-*.txt`)

Main 959 K mispredicted branches a compile, the head 990 K (+31 K, with 1.5 M more branches). Sampled every 2,000, the
head's extra ones lie in `fast_cc_compile_func` (+20 K), `fast_cc_expr` (+15 K) and the preprocessor (+22 K, which
the head's correct `__has_*` answers give more headers to read), against the unary reduction's split from
`fast_expr_reduce_top` (-2 K net) and the declarator (-7 K). In `fast_cc_compile_func` the mispredict samples and the
cycle samples peak at the same instructions (the symbol bind's first load, 4.7% of the function's mispredicts and 4.0%
of its cycles): the "stalls" after the declarator are the landings of mispredicted branches on the declaration's
path. At 15 to 20 cycles each, the head's 31 K are about 0.5 M of its 6.3 M extra cycles.

## c_direct_cc.c's remaining checks by function (`scripts/abl-fn.py`, `scripts/abl-fn-make.sh`, `scripts/bp-fnarms.sh`)

Each arm gates the bail `if`s this branch added in one group of functions (A1's excluded) behind an opaque test;
sqlite3.c's object stays the head's. Instructions saved against the head's 212.535 M (`results/fnarms.txt`):

| group | sites | instructions saved |
| --- | ---: | ---: |
| `fast_cc_compile_unit` (file-scope declarations, the unit's end) | 19 | 0.718 M |
| conversions, casts, constant folds and the rest | 21 | 0.451 M |
| the expression compiler's own (not A1's) | 22 | 0.449 M |
| `fval_emit_call` (counts, library and nonnull calls, arguments) | 10 | 0.424 M |
| `fval_emit_binary`, `fval_store`, `++`/`--`, compound assignment, branches | 16 | 0.404 M |
| `fast_cc_compile_func` | 33 | 0.282 M |
| the reductions | 20 | 0.250 M |
| `init_local`, `init_static` | 17 | 0.000 M |

No group holds a large share: about 20 instructions a call or declaration each.

## r2: a narrow operand against an in-range constant takes no operand check (`patches/r2.patch`)

Of sqlite3.c's 2,594 calls of `fast_cc_binary_operands_quiet` (most of which call `fast_cc_binary_questioned`), 1,900
are one shape: a narrow integer by value (`p->flags == 3` with a u8 member) against a plain integer constant. Every
family the two checks ask of that shape is quiet when the constant is in the narrow type's range and nothing else is
marked; `fast_cc_narrow_constant_quiet` answers it in the gate. 0.706 M instructions fewer (211.829 M), with every
file's result and bail reason over `tests/`, c-testsuite and musl, the probes, sqlite3.c's object (both
configurations), ASan with UBSan and MSan unchanged.

Over eight placements (`scripts/bp-r2sweep.sh`, `results/r2sweep.txt`, rounds 2 and 3):

| arm | cycles | instructions |
| --- | ---: | ---: |
| main | 75.44 M | 195.790 M |
| head | 82.09 M | 212.535 M |
| r2 | 81.74 M | 211.829 M |

0.35 M cycles fewer on average (lower at five of the eight placements; the median difference 0.17 M), about what its
instructions cost at the compile's rate. The gate (`results/r2-gate.log`), the sanitizers
(`results/r2-sanitizers.log`) and CI's count (`results/r2-count.log`: -0.836% against main) agree. buster#3597 now
runs +8.35% cycles and +8.19% instructions over main.
