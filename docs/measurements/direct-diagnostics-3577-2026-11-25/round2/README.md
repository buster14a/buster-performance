# #3577 round 2: the direct path's check cost on sqlite3.c

buster#3597 (#3577) after its merge of main 09c3b79b (PR head 19e85f76b), and three commits that cut the
direct path's check cost: ebe4809de (`-Wunsequenced` without a log on the common path, register tests ahead of
two calls), 862edd16e (the expression context's scalars before its stacks; a symbol in 64 bytes) and ffa96d65a
(an expression compiled again for `-Wunsequenced` that declares anything bails; no timing change).

Every number is sqlite3.c's default `-c` on the 9700X, as the 9700X job compiles it (`-DSQLITE_OMIT_LOAD_EXTENSION
-DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`, the host's headers), pinned to CPU 2, every
build a Release build made on the host under the lock, each hold one run of a script under `scripts/`.
`measure-compile` medians, interleaved; base is main 09c3b79b, head the PR head 19e85f76b, work a patch on 19e85f76b
(`patches/`).

## Final

`scripts/final8.sh`, 41 runs (`results/final8.out`):

| | wall | user cycles | user instructions |
| --- | --- | --- | --- |
| main 09c3b79b | 16.318 ms | 80.9 M | 220.4 M |
| PR head 19e85f76b | 17.650 ms (+8.2%) | 88.1 M (+8.9%) | 243.9 M (+10.7%) |
| PR head ffa96d65a | 17.534 ms (+7.5%) | 87.0 M (+7.5%) | 238.9 M (+8.4%) |

The two PR heads write the same object (3a4e6320...); main's differs (ceeade73...), as the PR body says, because
the direct path now answers `__has_*` as the full pipeline does.

## Steps (11 runs each, one hold with base and head; `scripts/abl3.sh`)

| variant (patch) | user cycles | user instructions | head, base in that hold |
| --- | --- | --- | --- |
| no `-Wunsequenced` bookkeeping at all, an ablation (`abl3-seq`) | 86.4 M | 239.4 M | 88.0 M / 80.9 M |
| lazy log, run-time flag (`step1-lazy`) | 88.1 M | 242.0 M | 87.9 M / 80.9 M |
| lazy log, cold out-of-line bodies (`step3-lazy2`) | 88.6 M | 242.7 M | 88.2 M / 80.9 M |
| + integer comparison and own-type conversion gates (`step3-all`) | 87.7 M | 240.9 M | 88.0 M / 81.0 M |
| + the body compiled twice, a constant LOGGING (`step4-spec`, ebe4809de) | 87.8 M | 239.0 M | 88.2 M / 81.2 M |
| that with main's `__has_*` answers (`step4-answers`, measurement only) | 87.4 M | 238.9 M | 88.1 M / 80.9 M |
| + FastExprCtx's scalars first (`step5-layout`) | 87.0 M | 238.9 M | 88.3 M / 81.2 M |
| + FastSym in 64 bytes (`step6-sym`, 862edd16e) | 87.2 M | 238.9 M | 88.0 M / 80.9 M |

Hold-to-hold noise is about ±0.4 M cycles; compare a variant with the head and base of its own hold.

- The `-Wunsequenced` log on every name, operator and modification cost 4.5 M instructions and 1.6 M cycles (the
  ablation). Without it on the common path, only 790 expressions a compile look further than the end's shortcuts and
  140 are compiled again for the log (coverage counts, the corpus's sqlite3.c).
- Main's answers to `__has_*` (the input difference) are worth 0.1 M instructions and about 0.4 M cycles.
- FastVal's growth to 32 bytes made FastExprCtx's vstack 4096 bytes: vsp, arg_sp and the flags behind it shared
  vstack[0]'s 4 KiB offset. Reordering them took 0.8 to 1.3 M cycles with no instruction change.

## What the rest waits on

`scripts/ctr7.sh` (`results/ctr7.out`, `perf stat -r 21`, two rounds each, ffa96d65a as work):

| per compile | main | PR head |
| --- | --- | --- |
| user cycles | 82.0 M | 87.9 M |
| L1 instruction cache misses | 7.28 M | 9.41 M (+29%) |
| L2 accesses for code | 2.65 M | 4.27 M (+61%) |
| retired branch mispredictions | 0.947 M | 0.975 M |
| L1 data misses (data accesses in L2) | 0.766 M | 0.802 M |
| store-to-load forwarding failures (`ls_bad_status2.stli_other`) | 0.519 M | 0.563 M |
| L2 TLB misses (code), dTLB load misses | ~60, ~2.8 K | ~70, ~2.6 K |

`scripts/icm.sh` samples the misses by function (`results/icm-*.txt`, `results/l2i-*.txt`): fast_cc_expr +0.45 M,
fast_cc_compile_func +0.24 M, fast_expr_reduce_top +0.17 M, and functions this PR left unchanged (fval_to_gp,
fast_pp_drain, fast_pp_read_tok) too. The direct path's compiler functions are 233 KB against main's 170 KB
(`scripts/fnbytes.py` attributes a function's bytes to source functions): the checks' conditions inline in the hot
functions, not their bail blocks, which are out of line. The remaining cost is code footprint.

Correction (2026-11-26, round 10): the instructions a cycle are the same on both sides (main 09c3b79b 220.4 M in
80.9 M, 2.72; ffa96d65a 238.9 M in 87.0 M, 2.75, the PR's Cost table), so the added instructions run at the compile's
own rate and the cycles follow the instruction count. The footprint shows in the instruction cache's misses above, but
not in the rate: the remaining cost is the checks' instructions, not their layout.

`results/cyc7-*.txt` and `results/cyc8-*.txt` are IBS cycle profiles (`cnt_ctl=0`) of step4-spec and ffa96d65a
against main; `results/ibs3-*`, `ibs5-*` IBS op profiles of 19e85f76b and step3-all. `scripts/linedelta.py` maps
their lines through `git diff` (its BASE, R and file names are edited per comparison).
