# #658 native results

Frozen candidate `e056a4297c98c7ee3ef3c5c113834f63acbf448b` passed the native
checker (392,250 checks, zero failures), driver (21,639/0), nine full-object and
diagnostic comparisons, 9,225 independent runtime index/value checks, and an
identical malformed-literal rejection. All 378 objects from the timing
campaigns matched their complete baseline object. `all-objects.sha256` records
399 total objects, including the separate correctness and stage runs.

The method, exact identities and flags are in `METHOD.md`. These are 21 rotated
fresh-process pairs on CPU 2, normal object output, matching native release
builds, THP `always`, governor `performance`, and ordinary warm file cache.
No host settings changed. Every sample and outlier is retained. All campaigns
had zero failed compiles and zero major faults.

| Original C workload | Baseline median wall | Candidate median wall | Baseline median peak RSS | Candidate median peak RSS | Baseline / candidate wall |
| --- | ---: | ---: | ---: | ---: | ---: |
| 100k byte literals | 32.526 ms | 14.036 ms | 218,804 KiB | 153,072 KiB | 2.32 |
| 200k byte literals | 60.841 ms | 23.290 ms | 366,120 KiB | 231,500 KiB | 2.61 |
| 400k byte literals | 116.856 ms | 41.305 ms | 654,848 KiB | 382,240 KiB | 2.83 |
| 800k byte literals | 225.070 ms | 75.507 ms | 1,215,356 KiB | 645,824 KiB | 2.98 |
| 320k int literals | 98.429 ms | 40.837 ms | 552,732 KiB | 337,484 KiB | 2.41 |
| 100k volatile bytes (fallback) | 32.443 ms | 32.553 ms | 218,828 KiB | 218,720 KiB | 1.00 |
| 100k floats (fallback) | 35.634 ms | 35.681 ms | 219,072 KiB | 218,960 KiB | 1.00 |
| Ordinary pinned SQLite control | 144.168 ms | 142.846 ms | 517,112 KiB | 510,992 KiB | 1.01 |

All 21 within-round pairs favored the candidate for each of the five eligible
table workloads. At 800k, median user time fell from 176.269 to 49.043 ms and
system time from 46.544 to 26.155 ms. Maximum observed peak RSS was 1,215,448
versus 645,912 KiB. The largest uninstrumented workload still costs about
94 ns/element end to end, so the issue's few-nanoseconds aspiration is not met.

Volatile and float median wall differences were +0.34% and +0.13%, with paired
median throughput differences of -0.088% and -0.077%, and 10/21 positive pairs
each. These single-image differences are a cost screen, not an established
fallback change. No fallback speedup is claimed.

The equal-binary SQLite A/A roles differed by -0.028% median throughput. The
SQLite candidate observation is +0.925% throughput, paired median +0.799%,
18/21 positive pairs. Its full wall ranges are retained: baseline 143.582 to
153.123 ms; candidate 141.986 to 164.964 ms. This is an ordinary-workload cost
screen, not a qualified sub-percent or general speedup claim. Code-placement
experiments have not been performed for that small timing observation.

The independent 800k stage diagnostic (five rounds, one warmup) reports 75.655
versus 223.273 ms, with the stage clock's measured median overhead 0.121 ms
(0.16%). Its default/instrumented objects also match. Check-input remains
45.945 ms (61.2% of the instrumented span), parse 15.276 ms (20.3%), and the
check-input stage adds 402,316 KiB peak RSS. Reader columns and other front-end
work therefore remain material; this bounded integer-table path is only part
of the broader issue.

Raw `perf-*.log`, `summary-*.txt`, `children.tsv`, per-process stderr and complete
objects are retained. `table-timing-objects.log` verifies 294 array timing
objects; `control-objects.log` verifies 84 SQLite objects. Original C helpers
and source/input hashes accompany them. No PR, push, issue closure or external
status comment was made by this agent.

Packaging audit: two target snapshots were compressed without the shared lock,
which was a process mistake. Conservative windows are 11:46:01–11:46:10 and
12:06:56–12:07:12 UTC on 2026-10-28. `contamination-audit.txt`, produced by the
retained original C `cohort_windows.c` from target nanosecond `children.tsv`
timestamps, shows no overlap for any of the 378 timing cohorts with these,
the reported #673 windows, or the parent's 12:27 packaging window. The stage
diagnostic completed at 11:48:38 UTC and also has no overlap. No result was
discarded or replaced. All later target packaging and hashing take the lock.
