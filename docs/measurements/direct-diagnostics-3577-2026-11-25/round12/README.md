# #3577 round 12: the memaccess comparison's fix

buster#3597's 6cb9d699e: `fast_cc_same_tokens`, which asks whether `sizeof`'s operand in a memset, memcpy or kin is
the expression of a pointer argument, compared inner parentheses by kind and data; the full pipeline compares the two
without any parentheses, so `memset(s->buf, 0, sizeof((s)->buf))`, and a macro's `(` (data 1) on either side, were
quiet where it warns. It now skips every parenthesis. Built as the 9700X job builds (`BUSTER_HOST_ARCH=znver5
./build.sh --config Release`) under the lock in round 11's `work` tree, against round 11's builds of 90b98b4fa (`mid`)
and main 86427a9f5 (`base`); sqlite3.c's default `-c` with the job's flags and the host's headers, pinned to CPU 2, in
one hold: the job's instructions' baseline step on each, then 41 interleaved runs (`scripts/m13.sh`,
`results/m13.out`, `results/bp-m13.log`).

| | wall | user cycles | user instructions | the baseline step |
| --- | --- | --- | --- | --- |
| main 86427a9f5 | 16.242 ms | 80.6 M | 211.8 M | 211,772,367 |
| 90b98b4fa | 17.591 ms (+8.3%) | 87.5 M (+8.6%) | 232.6 M (+9.8%) | 232,622,864 |
| 6cb9d699e (the fix) | 17.538 ms (+8.0%) | 87.4 M (+8.4%) | 232.6 M (+9.8%) | 232,621,219 |

The comparison runs only at a memaccess call with a `sizeof` argument, and the fix reads 1,645 instructions fewer than
90b98b4fa and 0.053 ms less, inside both arms' spread (17.374 to 17.712 ms against 17.478 to 17.792 ms): no
measurable cost. sqlite3.c's object is byte-identical between the two (aef0e35896a7e863); main's differs by the atomic
intrinsics (round 7).

The branch's `tools/ci/compile-instructions.txt` holds 232,033,429; the fix reads +0.253% of it, inside the 0.5% band.
