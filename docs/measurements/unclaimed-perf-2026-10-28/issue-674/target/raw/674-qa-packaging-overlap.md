# External packaging overlap and explicit replacement

The coordinator reported that a #664 results compression mistakenly ran outside
the shared lock on 2026-10-28 from **12:27:37.850 to 12:27:40.604 UTC**.
The interval came from the coordinator's packaging artifact timestamps.

The original single-worker balanced pass 1 was active. The retained
`674-qa-packaging-overlap-stat.txt` records the original birth and modification
times of its `children.tsv` files. `cohort.c` opens each file immediately before
the timed interval and closes it immediately after, so these bound the timed
cohort apart from negligible setup/finalization. Six cohorts overlap:

| Case | Role | Observed file lifetime, UTC |
| --- | --- | --- |
| 034 | candidate | 12:27:37.346592326–12:27:37.923035201 |
| 018 | baseline | 12:27:37.923035201–12:27:38.504453985 |
| 017 | baseline again | 12:27:38.504453985–12:27:39.084907420 |
| 011 | baseline again | 12:27:39.084907420–12:27:39.666965611 |
| 021 | baseline | 12:27:39.666965611–12:27:40.249143245 |
| 030 | baseline | 12:27:40.249143245–12:27:40.829080015 |

The original log, all samples and the original three-pass summary are retained.
No affected row was removed or changed. To preserve the exact predecessor and
case balance, the **entire** pass 1 is repeated through the shared lock, using
`674-qa-balanced-j1-r1-clean.log` and `results/674-qa-balanced-clean-j1/r001`.
The clean three-pass summary substitutes this explicitly designated replacement
for the overlapping pass. Both summaries must be disclosed together.

Eight-worker pass 1's timed cohorts start at 12:27:48.502460025 UTC, after the
reported compression interval. Pass 0 predates it and pass 2 follows it.

The coordinator subsequently reported four conservative possible windows:
11:46:01–11:46:10 and 12:06:56–12:07:12 UTC from the #658 owner, and
11:51:35–11:51:44 and 12:08:16–12:08:24 UTC from the #673 owner. Exact bounds
for those compressions are unavailable. None overlap the accepted #674
timings: all frozen-binary A/B/A/A finish by 11:09:11 UTC and all corrected
balanced runs begin after 12:17. The exploratory global-rotation runs around
11:57–11:58 are also outside these windows. Log file timestamps and the
full child-file birth/mtime receipt are retained in
`674-qa-timing-log-stat.txt` and `native/674-qa-all-cohort-stat.txt`.
