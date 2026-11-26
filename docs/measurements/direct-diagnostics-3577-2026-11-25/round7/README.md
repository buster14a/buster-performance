# #3577 round 7: after merging main 86427a9f5

buster#3597 merged main 86427a9f5 (#3620: glibc's assert, `__PRETTY_FUNCTION__` printed as clang prints it, ceil and
floor) as 0cc566335. Both builds are the 9700X job's (`BUSTER_HOST_ARCH=znver5 ./build.sh --config Release`), each
under the lock; sqlite3.c's default `-c`, the job's flags and the host's headers, pinned to CPU 2, 41 interleaved runs
in one hold. The head was shipped to the 9700X as a git bundle.

`scripts/m9.sh` (`results/m9.out`, `results/bp-m9.log`):

| | wall | user cycles | user instructions |
| --- | --- | --- | --- |
| main 86427a9f5 | 16.322 ms | 80.6 M | 211.8 M |
| 0cc566335 | 17.615 ms (+7.9%) | 87.0 M (+7.9%) | 232.0 M (+9.5%) |

The job's baseline step reads 232,021,365 instructions on the merge, -0.005% of the branch's file (232,033,429, written
in round 6), so the file stays. Main reads 211,772,948, +0.575% of its own file (210,562,407): past its band.

Round 6's merge (678d8a7e2) ran 88.8 M cycles at the same 232.0 M instructions; this layout runs 87.0 M. The cycles
follow the hot code's placement, as round 6 found.

Both objects are the direct path's. The head's differs from main's in 21 functions, all sqlite's atomic loads and stores
(`AtomicLoad`, `AtomicStore`): main's direct path answers `__has_extension(c_atomic)` 0 where its full pipeline answers
1, so main's direct compile takes `SQLITE_ATOMIC_INTRINSICS` 0; the branch's direct path answers as the full pipeline.
The head's object is byte-identical to the branch's before the merge (a4baf6405).
