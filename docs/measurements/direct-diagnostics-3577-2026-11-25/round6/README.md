# #3577 round 6: after merging main 7efd3657e, and a placement's 2 M cycles

buster#3597 merged main 7efd3657e (#3619: HUGE_VAL's builtins, `__PRETTY_FUNCTION__` leaving the direct path) as
678d8a7e2, pushed as a4baf6405 with the baseline below (the same code), after two fixes: 090e78d03 (an uninitialized
comparison position MSan reported) and 4591e50da (a dead branch's use counting for -Wundefined-internal). Every build is
the 9700X job's (`BUSTER_HOST_ARCH=znver5 ./build.sh --config Release`), each under the lock; sqlite3.c's default `-c`,
the job's flags and the host's headers, pinned to CPU 2, 41 interleaved runs in one hold.

`scripts/m7.sh` (`results/m7.out`): main 7efd3657e and the merge, with the job's baseline step on each.

| | wall | user cycles | user instructions |
| --- | --- | --- | --- |
| main 7efd3657e | 16.302 ms | 80.3 M | 211.7 M |
| 678d8a7e2 | 17.978 ms (+10.3%) | 88.8 M (+10.6%) | 232.0 M (+9.6%) |

The baseline step reads 232,033,429 on the merge (written in a4baf6405) and 211,719,867 on main, +0.550% of main's own
file.

`scripts/m8.sh` (`results/m8.out`): where the head's cycles moved, the four in one hold.

| | wall | user cycles | user instructions |
| --- | --- | --- | --- |
| main 7efd3657e | 16.252 ms | 80.3 M | 211.7 M |
| b0c1a2815 (round 5's head) | 17.520 ms | 86.8 M | 231.8 M |
| 4591e50da (+ the two fixes) | 17.509 ms | 86.9 M | 232.0 M |
| 678d8a7e2 (+ main's #3619) | 17.880 ms | 88.9 M | 232.0 M |

The fixes take nothing. The merge takes 2.0 M cycles at the same instructions: main's additions to the expression
compiler moved the hot code, whose set is past the 32 KB L1I (round 2's counters), and the same work runs 2.3% slower
in the new layout. One placement can't size the checks' cost to better than that; a sweep of padded placements per arm
(buster-performance `ident-lookup-3583-2026-11-25/scripts/mkpad.sh`'s method) would.
