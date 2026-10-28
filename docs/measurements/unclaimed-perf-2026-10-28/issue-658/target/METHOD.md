# Frozen 9700X method for #658

Host: existing `benchpress` 9700X, Linux 6.18.50-2-lts, Clang 23.1.1. Record
`preflight.log`, `lscpu.json`, and `host-readonly-policy.txt`. No host policy is
changed. Available RAM before this run was 57 GiB; disk had 380 GiB available.
Large tables are always compiled sequentially, never eight copies concurrently.

Remote campaign root: `/home/david/buster-fast-bench/unclaimed-perf-20261028`.
Source archive is exact `e056a4297c98c7ee3ef3c5c113834f63acbf448b`, retained in
private `issue658`; `SOURCE_COMMIT` records it. Native build uses `BUSTER_DEBUG_INFO=0`.

- Baseline `./base/build/compiler`: SHA-256
  `d4420d3786771dc3f9b851b6931bc8d8cdb7d01959b3213f4927821847fe871d`,
  source `bc1b486150850fe00bad1361a19f57d67706bb3b`.
- Candidate `./issue658/build/compiler`: SHA-256
  `364486cde01f315e964bf0ee58fb499b49865ea24ba7d3f0514748168465788c`.
- `shared-inputs.sha256` identifies the existing original C `samples` and
  `cohort` helpers and pinned SQLite/predefines. Both helper sources are retained
  in the parent's campaign; copies will accompany this evidence.

Every target build, test or benchmark uses `~/buster-fast-bench/exclusive.sh`
with `EXCLUSIVE_OWNER=codex-perf-658`, descriptive `EXCLUSIVE_TITLE`, and
`EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/658`. A lock covers
one bounded run. Other CI and benchmark owners can run between our invocations.

Correctness first: exact native `test-checker --seed 658`; native driver using
its own absolute executable path; `native_qa` with 100k/200k/400k/800k byte,
320k int, 100k zero/volatile/float, 129 widened negative unsigned and 129 invalid
literal cases. Each accepted case must produce byte-identical full baseline
and candidate objects and diagnostics. Candidate objects are linked with the
independent Clang-built C runtime oracle; each runs 1,025 index/value checks.
The invalid case must reject identically and produce no output.

Whole-process samples use this shape (MODE and COUNT vary):

```text
./samples 21 1 1 issue658/evidence658/MODECOUNT.c issue658/evidence658/perf-MODECOUNT ./cohort ./base/build/compiler ./issue658/build/compiler --lanes 1 -c issue658/evidence658/MODECOUNT.c -o @OUTPUT@
```

The existing C cohort helper pins each compiler process to physical CPU 2 and
waits for completion. Each sample compiles its full source and writes an actual
object. Timing includes startup, compilation, object creation/write, teardown,
and child scheduling/wait overhead. Writes use normal buffered filesystem I/O;
no durable-storage/fsync cost is claimed. `wait4` records user/system time,
peak process RSS, faults and context switches. Both compiler arguments and
source paths are identical. Source data is in the ordinary shared file cache;
no cache flushes or privileged changes are used. Array QA precedes timings.

All 21 samples per role are retained, including the first and all outliers.
Baseline/candidate order rotates each round. No failed samples are excluded.
The C summary reports medians/ranges, median and maximum peak RSS, aggregate
faults, and within-round throughput ratios. Each process's raw counters and
stderr stay in the cohort directory. Full emitted objects are retained and
validated against the baseline reference after each campaign.

Pinned ordinary SQLite control uses 21 rounds, one CPU-2 compiler per cohort,
the same helpers, and these exact compiler arguments:

```text
--lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -std=gnu17 --predefines corpus/gnu17-pinned-predefines.txt --clang-features --target=x86_64-linux-gnu -march=znver5 -nostdinc -isystem corpus/headers/usr/lib/clang/23/include -isystem corpus/headers/usr/local/include -isystem corpus/headers/usr/include -Icorpus/sqlite corpus/sqlite/sqlite3.c -o @OUTPUT@
```

An equal-binary SQLite A/A screen uses the baseline path in both roles. SQLite
and fallback controls are cost screens; a single image pair and A/A role-bias
screen do not establish a sub-percent general effect or rule out code-placement
noise. Large table improvements must also show the scaling and memory effect.
No few-nanoseconds-per-element result is claimed: reader token columns and
other front-end work remain.
