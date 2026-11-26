# #3577 round 10: five more fixes, and what the head costs now

buster#3597 after round 9 added fourteen commits' checks up to 286591467 (`-Wfortify-source`, four gaps a flag sweep
found, three attributes, printf's formats), then five fixes: a `long *` and a `long long *` made incompatible
(45b38c807), a checked inline body's long double taken without code (0f75bdc1c), a mode attribute's type
(3487cf210), arrays of unknown size completed exactly and as copies (7bbb52f26), and an attribute after a bit-field's
width (42eb39945). All three trees are the 9700X job's builds (`BUSTER_HOST_ARCH=znver5 ./build.sh --config
Release`), each under the lock; sqlite3.c's default `-c` with the job's flags and the host's headers, pinned to CPU 2,
in one hold: the job's instructions' baseline step on each, then 41 interleaved runs (`scripts/m11.sh`,
`results/m11.out`, `results/bp-m11.log`).

| | wall | user cycles | user instructions | the baseline step |
| --- | --- | --- | --- | --- |
| main 86427a9f5 | 16.274 ms | 80.7 M | 211.8 M | 211,772,908 |
| 286591467 (before the five) | 17.676 ms (+8.6%) | 88.0 M (+9.0%) | 232.8 M (+9.9%) | 232,755,299 |
| 42eb39945 | 17.608 ms (+8.2%) | 87.7 M (+8.7%) | 232.6 M (+9.8%) | 232,609,709 |

The five fixes cost nothing measurable: against 286591467 the head is 0.068 ms faster (-0.4%, within the runs'
spread) and 145,590 instructions fewer (-0.06%). Their tests sit in branches only the shapes they take reach (an
unsupported type's, a mode attribute's, an incomplete array's, a bit-field width's next token), and sqlite3.c's
object is byte-identical between 286591467 and the head (aef0e35896a7e863); main's differs by the atomic intrinsics
(round 7). The commits between round 8's fdadcc225 (232,097,439 there, the same build) and 286591467 took 0.66 M
instructions (+0.28%), which this round doesn't split among them (printf's formats are read at each call of the four
functions, `-Wfortify-source`'s pre-filters at each call of a copy).

The branch's `tools/ci/compile-instructions.txt` holds 232,033,429; the head reads +0.248% of it, inside the 0.5% band.
Main reads +0.575% of main's own file (210,562,407), as in round 8.

The cycles follow the instruction count, as round 9 found once its explanation was corrected: 2.65 instructions a
cycle on the head against 2.62 on main.
