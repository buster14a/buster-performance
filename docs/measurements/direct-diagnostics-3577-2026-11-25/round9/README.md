# #3577 round 9: where the checks' 20 M instructions go

buster#3597's head fdadcc225 (the warning families of round 8) against main 86427a9f5, on sqlite3.c's default `-c`
on the 9700X. To compare the checks alone, the head answers `__has_builtin` and `__has_attribute` as main does and
everything else 0, as main's direct path does (`patches/answers-fdadcc225.patch`, measurement only). It then compiles
main's tokens: the two objects' `.text`, `.data`, `.rodata`, `.bss`, `.strtab` and `.symtab` are byte-identical
(`results/ans.out`). Both trees are the 9700X job's builds (`BUSTER_HOST_ARCH=znver5`, Release, debug information
on), each built under the lock. In one hold: `measure-compile --runs 21` interleaved, then IBS op samples
(`ibs_op/cnt_ctl=1,swfilt=1/u -c 250000`) of 200 compiles each, pinned to CPU 2 (`scripts/ibs9.sh`).

| | wall | user cycles | user instructions | peak RSS (wait4) |
| --- | --- | --- | --- | --- |
| main 86427a9f5 | 16.350 ms | 80.7 M | 211.8 M | 36.4 MB |
| fdadcc225 with main's answers | 17.729 ms (+8.4%) | 88.0 M (+9.0%) | 231.9 M (+9.5%) | 55.0 MB |

The checks take 20.2 M instructions. The IBS samples put 19.95 M of them on functions
(`results/ibs9-base.txt`, `results/ibs9-head.txt`, scaled to each tree's instructions); the largest:

| function | main | head | delta |
| --- | ---: | ---: | ---: |
| fast_cc_expr (the expression compiler, inlined loop) | 25.7 M | 29.3 M | +3.5 M |
| fast_expr_reduce_top | 4.1 M | 7.1 M | +3.0 M |
| fast_cc_parse_decl_specs | 3.8 M | 5.8 M | +2.0 M |
| fval_emit_binary | 5.8 M | 7.6 M | +1.9 M |
| fast_cc_binary_operands_quiet (new) | 0 | 1.8 M | +1.8 M |
| fast_cc_parse_declarator | 6.7 M | 8.3 M | +1.6 M |
| fast_cc_compile_func | 13.9 M | 15.3 M | +1.4 M |
| fast_cc_parse_scalar_or_tag_specs | 2.2 M | 3.2 M | +1.0 M |
| fast_cc_binary_questioned (new) | 0 | 0.6 M | +0.6 M |
| fast_cc_write_static_scalar | 0.4 M | 1.0 M | +0.6 M |
| fast_cc_compile_unit | 1.8 M | 2.4 M | +0.6 M |
| fval_branch | 2.0 M | 2.5 M | +0.5 M |
| fast_cc_eval_static_const | 0.7 M | 1.2 M | +0.5 M |
| fast_pp_finish_directive (new) | 0 | 0.5 M | +0.5 M |
| fast_pp_handle_define | 2.0 M | 2.4 M | +0.4 M |
| ftype_decay (inlined in the head) | 2.6 M | 0 | -2.6 M |

`scripts/linedelta9.py` maps the head's lines through the diff and adds them up by source function
(`results/linedelta9-functions.txt`). The expression compiler's body (fast_cc_expr_compile) takes 6.8 M, spread over
about 40 lines of 0.05 to 0.6 M each: a name's push (its use flags, a library function's marks, an enumerator's
enum, the value's identity, about 2.5 M together), an operator's push keeping its token (0.6 M), a statement's
discarded value (0.4 M), a subscript's operand checks (0.3 M). The binary operators' operand classes and questioned
comparisons take 4.4 M (fval_emit_binary's gate 2.4 M, the two new functions 2.0 M), the declarations' specifiers
and declarators 2.7 M, and the rest sits on 20-odd sites of 0.1 to 0.6 M each.

No site holds a large share. Sixteen source functions hold 80% of the delta, and within them it is spread thin:
80% of the lines' positive deltas (42.1 M gross, against the inlining moves' negatives) lie on 504 lines, the largest
0.67 M (0.3% of the compile; `scripts/linedelta9.py` with every line kept). Trimming them one at a time (round 2
took 5 M that way) can't bring the compile back to main's; what remains is the checks' per-name, per-operator and
per-declarator work itself. A structural lever (the checks in a pass of
their own over the tokens, or a vector pre-pass that rules out most names and operators at once) would need its
ceiling measured by emulation before it is built.

The cycles: 7.3 M more, at the compile's own rate (231.9 M instructions in 88.0 M cycles, 2.64 a cycle, against
main's 211.8 M in 80.7 M, 2.62), so they follow the instruction count. (Corrected 2026-11-26: this paragraph first
gave round 2's reading, the added code's footprint past the 32 KB L1I, which shows in the instruction cache's misses
but not in the rate; see round 2's correction.) The peak RSS difference is the same as round 1's, file-backed pages the
checks' code and tables touch, at the same 421 minor faults.
