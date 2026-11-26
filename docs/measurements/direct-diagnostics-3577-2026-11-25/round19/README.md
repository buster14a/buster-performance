# Round 19: where the overhead is, two store-forwarding stalls, and what is left

[buster#3597](https://github.com/buster14a/buster/pull/3597) after the owner asked for the checks' overhead to go
(2026-11-26). Every build is the 9700X job's (`BUSTER_HOST_ARCH=znver5`, Release) under the host lock; the unit is the
job's sqlite3.c with the host's headers, pinned to CPU 2. main16 is main 1e1ca2dd6 (74eacd474's direct path, as
5ce76f08c's); m16 is the PR's merge of it (e53577ce1, round 18's e80068bdf code); p8 is c4085ccd2.

## The overhead is the compile stage (`scripts/bp-stages2.sh`, `results/stages2.txt`)

`--time-stages` (the direct path marks `preprocess` and `tier0`), 21 runs interleaved, main 5ce76f08c against round
18's head: preprocessing 6.427 against 6.525 ms (+0.10), the compile 8.024 against 9.267 ms (+1.24, +15.5%). Later
holds read the same: preprocessing within 0.05 to 0.15 ms of main's, the compile 1.1 to 1.2 ms over.

## Round 18's front-end reading was a throttled profile's

`perf_event_max_sample_rate` on the 9700X is 63,300 samples a second. Round 18's cycle profile (`cycles:u -c 20000`) and
an IBS op profile at `-c 8192` ran far above it; the kernel throttles such a record into bursts after each tick, and
two binaries' per-function shares skew between the compile's phases. That is where round 18's "`fast_pp_run_calls`
+1.66 M cycles at equal ops" came from (and an IBS reading of `fast_pp_skip_inactive` at -13 M ops). Unthrottled
records (`scripts/bp-prof-u.sh`: IBS op `-c 262144`, `cycles:u -c 100000`, 300 compiles an arm, sample counts compared,
not shares) put the delta in the compile's functions (`results/profiles/`, `results/deltas-*-p4.txt`).

The front end's counters themselves are real (`scripts/bp-fe.sh`, `results/bp-fe.out`, main against round 18's head):
op cache misses 11.24 to 14.67 M, ops from the x86 decoder 27.6 to 40.3 M, instruction cache fills from L2 2.72 to
4.13 M. But per function, cycles per op are main's within a few percent, so the extra cycles follow the extra ops.
IBS fetch (`scripts/bp-if.sh`, `results/if-sum.txt`) and IBS op with raw registers (`scripts/bp-io.sh`,
`results/io-sum.txt`) agree; load-store counters (`results/bp-ls.out`) show no rise in forwarding failures counted as
`ls_bad_status2.stli_other`.

## Two stores later loads couldn't take bytes from

A line-level scan (`scripts/stallscan.py`: lines whose text is unique in both files, more cycles at about the same
ops; `results/stallscan-p1.txt`, `results/stallscan-p4.txt`) found two of #3577's writes that later loads of the same
bytes waited on:

- The name push initialized its 32-byte value field by field, and Clang zeroed reg, op, lasting and seq_start with one
  byte-masked 32-byte store (`vmovdqu8` with an opmask), the only one in main's or the head's hot compile functions
  but the preprocessor's own vector code. `x86_load`'s first load in `fval_to_gp_full` went from 0.015 M cycles (main)
  to 0.564 M; written as four 8-byte words, 0.009 M (p1, `results/bp-p1.out`). The declarator's attribute loads in
  `fast_cc_compile_func` (0.24 and 0.22 M) fell with it.
- The 28-byte operator entry as a compound literal: a 2-byte store of `op` and an unaligned 8-byte store after it,
  which `fast_expr_reduce_top`'s 4-byte load of `op` and `extra` spans (0.73 to 0.82 M cycles at that test). Written as
  three 8-byte words and a 4-byte tail (`fast_expr_op_write`), 0.16 M (p4, `results/bp-p4.out`).

Two others didn't pay and were dropped: the declarator's result written in place (p2, 0.3 M cycles worse, the
attribute loads' waits came back) and the push as one 32-byte store (p5, 0.35 M worse, +0.39 M instructions). Padding
the expression context on the stack (`scripts/bp-pad.sh`) moved the compile by 0.15 to 0.3 M cycles between pads;
putting the preprocessor's scratch buffers back on main's 4 KiB phase (`scripts/bp-spad.sh`) by 0.06 M, about the
noise between two builds of the same code.

## The two fixes across placements (`scripts/bp-place.sh`, `results/bp-place.out`)

One build's placement moves this compile by 1 to 1.5% (the same bytes read 0.4 M cycles under m16 in one hold and
1.2 M over it in another, `results/bp-final.out`, `scripts/bp-check.sh`; fresh copies of a binary read as the old
ones, `scripts/bp-fresh.sh`). So m16 and p8 (c4085ccd2: the name push in words, its first by a table, and
`fast_expr_op_write`) were built at four placements of the checker's code (`BUSTER_CHECKER_OFFSET` 0, 1024, 2048
and 3072, all through `BUSTER_BUILD_DEFINES`) and run in rotation, rounds 2 and 3 of three, five runs each:

| offset | m16 | p8 |
| ---: | ---: | ---: |
| 0 | 82.73 M | 82.20 M |
| 1024 | 82.65 M | 82.19 M |
| 2048 | 82.90 M | 82.41 M |
| 3072 | 83.64 M | 82.13 M |
| mean | 82.98 M | 82.23 M |

p8 is lower at each placement, by 0.75 M cycles on average (0.9%), with 1.13 M fewer instructions (214.97 M to
213.84 M). The 9700X job's baseline step reads 213,838,215 on p8's default build, against main 1e1ca2dd6's 195.79 M.

## What is left

`measure-compile`, 21 runs interleaved (`results/bp-final.out`): p8 16.394 ms against main 1e1ca2dd6's 15.193 ms
(+7.9%), 82.5 M user cycles against 75.5 M (+9.3%), 213.8 M instructions against 195.8 M (+9.2%). By function
(`results/deltas-op-p4.txt`, `results/deltas-cyc-p4.txt`; p4 is p8's code), the extra 17.8 M ops lie in the
expression compiler (1.6 M, a name's push, an operator's push and the expression's end), the unary reduction (1.6 M),
the binary operators (2.3 M, 1.2 M of it the operand gate before main's own type dispatch), the declarators (1.3 M,
at no cycles), the specifiers (1.1 M), `fast_expr_reduce_top` (1.0 M), the statements (1.0 M), the file scope
(0.8 M), stores and calls (0.6 M each), the directives (0.7 M) and some forty functions of 0.1 to 0.3 M. Against
main's own cycles per op function by function, about 1.3 M cycles are left beyond what the extra ops cost at main's
rate, spread thin; the rest of the 6.8 M is the ops at main's rate.

Trimming sites took about 1 M instructions a batch in rounds 18 and 19. Parity with main isn't in reach that way:
it needs the checks to run differently (a value's class byte and a table's answer per operation, checked in main's
own type dispatch, or deferred to a pass over compact records), or main's direct path made faster elsewhere. Both are
the owner's call.
