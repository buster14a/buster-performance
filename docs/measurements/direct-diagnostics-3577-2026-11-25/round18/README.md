# Round 18: the checks a test at a time, and where the remaining cycles go

[buster#3597](https://github.com/buster14a/buster/pull/3597) after the owner asked for the checks' overhead to go (2026-11-26).
Every build is the 9700X job's (`BUSTER_HOST_ARCH=znver5`, Release) under the host lock; the unit is the job's
sqlite3.c with the host's headers, pinned to CPU 2; main is 5ce76f08c (74eacd474's direct path).

## Batches (`scripts/bp-opt.sh`: the baseline step, then 21 runs interleaved with main in one hold)

| head | what changed | instructions | user cycles | wall vs main |
| --- | --- | ---: | ---: | --- |
| 84324c2e5 (round 17) | | 218.73 M | 84.1 M | 16.644 vs 15.185 ms |
| b1 cc12821dc | binary, condition and conversion gates a test at a time | 217.59 M | 84.1 M | 16.725 vs 15.251 |
| b2 ec25663fd | questioned check's families one at a time, qualifier marks, subscripts, settled tables, unary and ternary out of `fast_expr_reduce_top` | 216.23 M | 83.7 M | 16.631 vs 15.160 |
| b3 0664dd750 | a pointer's common operators without the operand check, one test at a name's push | 216.57 M | 83.3 M | 16.511 vs 15.130 |
| b5 37788f87b (b4 with it) | a directive's newline first, #if operators' own questions; incomplete types, discarded values, pointer patterns as a test chain | 214.97 M | 82.9 M | 16.493 vs 15.180 |
| b6 35894e7ed | the statement frame in 32 bytes (dropped: no gain) | 215.06 M | 83.0 M | 16.482 vs 15.167 |

b5's code is the PR's e80068bdf (squashed). Each batch kept sqlite3.c's objects, every file's bail reason over `tests/`,
c-testsuite and musl, and all 41 probe sets identical.

## Where the remaining cycles go (`scripts/bp-cyc-now.sh`, `results/bp-cyc-now.out`)

perf stat, four events a run (no multiplexing), 15 runs, twice each:

| | main | head (b5) |
| --- | ---: | ---: |
| cycles | 75.03-75.10 M | 82.56-82.60 M |
| instructions | 195.79 M | 214.97 M |
| branch mispredictions | 0.958 M | 0.992 M |
| instruction cache misses (ic_tag_hit_miss) | 8.23-8.26 M | 11.17-11.18 M |
| frontend bound (PipelineL1, separate runs) | 40.8-41.4% of slots | 43.0-43.4% |

Of the head's extra slots about two thirds are the front end's and a third are retired ops: the checks' instructions
explain a third of their time, the code they add the rest. A cycle-weighted profile (`perf record -e cycles:u`, 200
compiles each, `results/cyc-*.txt`) puts 1.66 M extra cycles in `fast_pp_run_calls`, whose code is byte-identical
in size to main's and which retires the same ops (12.26 M against 12.22 M in the op profile, `results/ibs-now-*.txt`),
and more in other functions main's code alone runs (`fval_to_gp_full` +0.67 M at equal ops, `fast_pp_skip_inactive`
+0.49 M at fewer): placement and the instruction cache. The direct path's hot section (`.text.buster_checker`) is
130.5 KB in main and 140.1 KB in the head (`fast_cc_compile_func` +5.8 KB, `fast_cc_expr` +4.1 KB, the declarator's +3.4
KB), and the unary and ternary reductions b2 moved out of it (9.2 KB) now sit outside it.

Calls into the full functions #3609 split are main's (declarators 11,169 against 11,130, specifiers 7,673 against
7,670, conversions' full check 8,713 against main's 30,713): the extra cost is inside them, not more calls.
