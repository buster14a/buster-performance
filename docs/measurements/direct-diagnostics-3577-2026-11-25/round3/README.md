# #3577 round 3: the check cost after merging main 67a1324ac

buster#3597 (#3577) merged main 67a1324ac (#3592's inline asm, atomics and `-MD` on the direct path, #3600's and
#3603's raw strings, #3585's window lexer block, #3612, #3605) as ec0d8a792, which also adds `-Wdangling-else`'s
check (musl's `fork.c`, which #3592's asm brings to the direct path). No step of round 2 changed.

sqlite3.c's default `-c` on the 9700X, as round 2 measured it: the 9700X job's flags and the host's headers, pinned
to CPU 2, both builds Release builds made on the host, each under the lock (`scripts/m3.sh`), then
`measure-compile --runs 41` interleaved in one hold (`results/m3.out`, the script's log `results/m3.log`).

| | wall | user cycles | user instructions |
| --- | --- | --- | --- |
| main 67a1324ac | 16.414 ms | 80.9 M | 220.1 M |
| PR head ec0d8a792 | 17.525 ms (+6.8%) | 87.0 M (+7.5%) | 239.7 M (+8.9%) |

Round 2's pair, main 09c3b79b and ffa96d65a: 80.9 M and 87.0 M cycles, 220.4 M and 238.9 M instructions. The
merge left the cycles where they were. Both objects are round 2's (main ceeade73..., the PR 3a4e6320...), both
from the direct path (`buster direct` in `.comment`).
