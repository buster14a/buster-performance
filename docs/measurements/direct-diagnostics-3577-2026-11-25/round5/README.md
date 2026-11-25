# #3577 round 5: the cost of the comparison checks

buster#3597's commit for the comparisons the full pipeline's -Wtautological-compare and -Wstring-compare report
(self-comparisons, two arrays, pointer bounds, string literals), built and measured locally as ce3814343 and pushed as
b0c1a2815 with the baseline below (the same code). `scripts/m6.sh` builds it as the 9700X job builds
(`BUSTER_HOST_ARCH=znver5 ./build.sh --config Release`) in the work tree, under the lock, then in one hold runs the job's
instructions' baseline step on it and `measure-compile --runs 41` against the previous head (bc300ab5a's code, round 4's
head tree) and main 38483c5ba (round 4's base tree). sqlite3.c's default `-c`, the job's flags and the host's headers,
pinned to CPU 2.

| | wall | user cycles | user instructions |
| --- | --- | --- | --- |
| main 38483c5ba | 16.257 ms | 80.6 M | 211.7 M |
| previous head (bc300ab5a) | 17.379 ms | 86.4 M | 230.7 M |
| with the comparison checks (ce3814343) | 17.354 ms | 86.4 M | 231.8 M |

The checks take 1.1 M instructions and no cycles; sqlite3.c's object is the same before and after them (aef0e358...).
The baseline step reads 231,816,687 instructions (+0.493% of the 230,680,515 written before), which the commit writes
in tools/ci/compile-instructions.txt.

`results/m6.out` is the hold's output, `results/bp-m6.log` the script's log.
