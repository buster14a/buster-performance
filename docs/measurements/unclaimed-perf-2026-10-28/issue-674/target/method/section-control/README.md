# Actual checker-section placement and predecessor controls

These are measurement tools outside the compiler repository. They qualify the
frozen `bc1b486150850fe00bad1361a19f57d67706bb3b` baseline against sparse #674
`7274e1bc47dfa60c80a584bc01f270af5a7d420b`. They do not qualify later integration
heads. `placement_samples_rotation.c` and `placement_stats_rotation.c` are the
superseded, exploratory controller/reader and must not establish acceptance.

`capture-build.sh` differs from the original build script only by the
post-link object-copy hook in `capture-build.patch`. The native, unmodified
links reproduce both original binary hashes. `section_variants.c` relinks
those captured objects with 0, 688, 1376, 2064, 2752 or 3440 bytes before the
actual `.text.buster_checker` input section. It restores the original 4096-byte
section alignment. Ordinary executable padding may leave this hot section
unchanged, so `check_symbols.c` independently requires the intended shifts
and unchanged sizes for four hot symbols in all twelve variants. The raw
`nm` and `readelf` receipts are retained.

The corrected `placement_samples.c` uses these three roles:

| Role | Source | Purpose |
| --- | --- | --- |
| 0 | baseline | baseline distribution |
| 1 | candidate | candidate distribution |
| 2 | baseline again | identical-source role/copy floor |

Each pass creates 36 fresh executable copies: six placements, two copies and
three roles. All executable paths have equal length and copies are checked
byte for byte. The `rNNN/{warm,prim,case}NNN` result paths also have equal
length across roles. Every copy first performs a predeclared one-file warmup
with `--verify`; its output must match the frozen reference. One untimed,
full-size primer then establishes the predecessor role for the timed cycle.

The timed cycle is `0,0,1,0,2,1,1,2,2`, repeated four times; roles are rotated
by pass number. Its nine cyclic edges contain all nine ordered
predecessor/current role pairs. Each occurs four times in every pass.
For each role, placement `p` and copy `c`, the required predecessor in pass
`r` is `(p+c+r+role)%3`. Within each of these lists, a fixed, recorded seed
shuffles cases. Thus every role/placement/copy follows each predecessor once
over three passes. This controls actual preceding work; merely rotating a
36-slot list would preserve most role adjacency and is insufficient.

Each pass has 36 timed cohorts. Run passes 0, 1 and 2 separately for each
worker count, through the shared exclusive wrapper. Use one worker/four
tasks or eight workers/32 tasks. `cohort.c` pins processes to physical CPUs,
creates real objects, records every child and includes compiler process
creation and waiting in wall time. It runs all compiler stages, including
both the reader producing summaries and the graph consuming them. No stage
timer is substituted for end-to-end throughput.

From the target campaign root, the controller arguments are:

```text
./674-qa-method/placement_samples_balanced PASS JOBS TASKS \
  corpus/sqlite/sqlite3.c results/674-qa-balanced-jJOBS ./cohort \
  674-qa-variants/base 674-qa-variants/head \
  results/674-j1/r000-role0/output-0000.o -- \
  --lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 \
  -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -std=gnu17 \
  --predefines corpus/gnu17-pinned-predefines.txt --clang-features \
  --target=x86_64-linux-gnu -march=znver5 -nostdinc \
  -isystem corpus/headers/usr/lib/clang/23/include \
  -isystem corpus/headers/usr/local/include \
  -isystem corpus/headers/usr/include -Icorpus/sqlite \
  corpus/sqlite/sqlite3.c -o @OUTPUT@
```

`placement_stats.c` accepts the three raw pass logs for one worker count. It
checks unique, complete rows; expected predecessor counts and per-copy
predecessor coverage; consistent jobs/tasks/source; finite rates and fault
counts; and all reported failures and byte-check failures. It reports pooled
medians and **unpaired** ranges across all placement and copy medians.
Pairing equal offsets across builds would conceal layout uncertainty.
Role 2 supplies the same-source floor. All successful samples, including
page faults and outliers, remain in the distributions. Object manifests
independently check every timed output afterward.

The positive mock emits all 108 rows and passes these gates. Negative
controls cover an incorrect reference object, an incorrect primer order and
mixed cohort job counts. No performance interpretation is made from mock
data. Final native conclusions belong in the target evidence report.
