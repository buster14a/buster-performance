# Round 17: #3577 with #3596's expression-end cut kept

[buster#3597](https://github.com/buster14a/buster/pull/3597)'s head 8d6538f67 (pushed as 84324c2e5, the same code; the
CI files alone differ) against main 5ce76f08c on the 9700X, `benchpress`, as round 16 ran (`bp-m12.sh`: both trees built
as the 9700X job builds, under the lock; the baseline step and `measure-compile`'s 41 interleaved runs in one hold).
`bp-m12.out` is the script's whole output.

The merge of #3596 had kept this branch's copy of an expression's final value and its release of a discarded one,
which #3596 dropped: the release clears register bits of the expression's own context, which ends there. CI's count of
sqlite3.c showed main lose 47,767 regions in `fval_release`, 42,121 and 5,215 in its register tests and 26,422 in
`fast_cc_expr` that the head kept; the head now reads the value in place and drops the release (-1.260% to -1.513%
against main a508b743b in CI's count).

| | wall | user cycles | user instructions |
| --- | --- | --- | --- |
| main 5ce76f08c | 15.185 ms | 75.3 M | 195.8 M |
| head 8d6538f67 | 16.644 ms (+9.6%) | 84.1 M (+11.7%) | 218.7 M (+11.7%) |

The baseline step reads 218,727,570 instructions on the head (round 16's merge: 218,808,126), so the Release build
had already optimized most of the dead release away: the cut is 80,556 instructions. Main reads 195,788,802 (-0.494% of
its own `tools/ci/compile-instructions.txt`). The head's object is byte-identical to round 16's.

Against round 13, #3596 took 1,008 K instructions out of main's compile and 553 K out of the head's. CI's region counts
match main's savings function by function but for the release, so the remaining 455 K are the Release build's code
generation, not counted work; this round doesn't attribute them. Between rounds 16 and 17, main's medians moved by
-0.7% wall at the same instructions, which sizes the hold-to-hold noise.
