# #3577 round 11: the stale punctuator data's fix

buster#3597's 90b98b4fa: the window's emitter (`fast_pp_emit_window`) writes no punctuator's data, and a macro name
that stopped its block had its id written into its slot first, so where the expansion was empty the next token, a
punctuator, kept that id; the branch's -Wparentheses-equality and self-comparison checks read it, quiet where the full
pipeline warns (`if (EMPTY (x == y))`, `s EMPTY .a == s.a`). The fix clears the slot on the macro path and marks an
identity wrapper's `(` (sqlite's `ALWAYS(X)`) as its body's. Built as the 9700X job builds (`BUSTER_HOST_ARCH=znver5
./build.sh --config Release`) under the lock, in round 10's spare tree, against round 10's builds of main 86427a9f5
and 42eb39945; sqlite3.c's default `-c` with the job's flags and the host's headers, pinned to CPU 2, in one hold: the
job's instructions' baseline step on each, then 41 interleaved runs (`scripts/m12.sh`, `results/m12.out`,
`results/bp-m12.log`).

| | wall | user cycles | user instructions | the baseline step |
| --- | --- | --- | --- | --- |
| main 86427a9f5 | 16.346 ms | 80.8 M | 211.8 M | 211,772,915 |
| 42eb39945 | 17.666 ms (+8.1%) | 87.8 M (+8.7%) | 232.6 M (+9.8%) | 232,609,710 |
| 90b98b4fa (the fix) | 17.607 ms (+7.7%) | 87.5 M (+8.3%) | 232.6 M (+9.8%) | 232,622,865 |

The fix costs 13,155 instructions (+0.006%), a store at each macro name the window stops at: CI's count profile (the
corpus's headers, not the host's) has 15,140 calls of `fast_pp_window_macro` in a compile of sqlite3.c. It costs no
measurable time: 0.059 ms less than 42eb39945, inside both arms' spread (17.459 to 17.791 ms against 17.539 to
17.907 ms).
sqlite3.c's object is byte-identical between 42eb39945 and the fix (aef0e35896a7e863); main's differs by the atomic
intrinsics (round 7).

The branch's `tools/ci/compile-instructions.txt` holds 232,033,429; the fix reads +0.254% of it, inside the 0.5% band.
