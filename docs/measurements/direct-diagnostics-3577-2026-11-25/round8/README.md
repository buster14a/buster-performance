# #3577 round 8: the warning families' checks

After the merge of main 86427a9f5 (0cc566335, round 7), buster#3597 added the checks a per-family probe sample found
main's direct path without: fourteen warning families (`-Wreturn-stack-address`, `-Warray-bounds`,
`-Waddress-of-packed-member`, `-Wsizeof-pointer-memaccess`, `-Wabsolute-value`, the pointer-to-int casts, ...) and
three layouts and values it computed wrong, up to fdadcc225. All three builds are the 9700X job's
(`BUSTER_HOST_ARCH=znver5 ./build.sh --config Release`), each under the lock; sqlite3.c's default `-c`, the job's flags
and the host's headers, pinned to CPU 2, 41 interleaved runs in one hold.

`scripts/m10.sh` (`results/m10.out`, `results/bp-m10.log`):

| | wall | user cycles | user instructions |
| --- | --- | --- | --- |
| main 86427a9f5 | 16.324 ms | 80.7 M | 211.8 M |
| 0cc566335 (round 7's merge) | 17.639 ms | 87.1 M | 232.0 M |
| fdadcc225 | 17.547 ms (+7.5%; -0.5% against the merge) | 87.2 M (+8.1%; +0.1%) | 232.1 M (+9.6%; +0.04%) |

The families' checks take about 0.1 M instructions and no measurable time on sqlite3.c: they sit in cold functions
behind tests the hot paths already make (a cast's class pair, a call's nonnull mark, a member's bit-field bytes, a
constant index's array count, `&` in a return's expression). The job's baseline step reads 232,097,439 instructions on
the head, +0.028% of the branch's file (232,033,429), so the file stays; main reads 211,772,924, +0.575% of its own.

sqlite3.c's object is byte-identical between the merge and the head (aef0e35896a7e863); main's differs by the atomic
intrinsics (round 7).
