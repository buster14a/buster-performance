# Integrated current-e7 full-compilation throughput

| Concurrent workers | Source MB/s, median [minimum, maximum] | Median max-child RSS, KiB | Median of cohort-mean user+system ms/child | User IPC |
| ---: | ---: | ---: | ---: | ---: |
| 1 | 76.094 [69.325, 76.267] | 377,156 | 124.565 | 2.111 |
| 2 | 126.356 [126.293, 127.003] | 377,120 | 150.098 | 1.849 |
| 4 | 190.779 [189.263, 194.059] | 377,152 | 198.364 | 1.487 |
| 8 | 226.458 [226.156, 228.485] | 377,156 | 332.491 | 0.968 |
| 15 | 224.446 [218.114, 225.441] | 377,156 | 606.268 | 0.503 |

These are five rotating rounds on **Ryzen 7 9700X**, frozen compiler source
[`e7f89091648f68940b595aadd648841c1ffc3ec5`](https://github.com/buster14a/buster/tree/e7f89091648f68940b595aadd648841c1ffc3ec5),
**official Clang 23.1.4**, native host ISA, `BUSTER_DEBUG_INFO=1` (the normal
O3 build with debug information). Every child uses one compiler lane and
compiles the same **9,507,037-byte SQLite 3.53.2** input to a real object.
All **600 compilations passed**. All **25 retained cohort objects** have the
same hash, ELF-header receipts and passing 173-row / `d15437170bc02c7d` smoke
results. User instructions remain about **129.237 per source byte**.

The highest observed median is **226.458 MB/s on eight workers**; 15 workers
do not add throughput in this run. Major faults are **nonzero**, up to
**28 per cohort**, with no established cause. RSS above is a median of five
cohort **maximum single-child** values, not aggregate or simultaneous peak
memory. This is an integrated current-source observation: **no causal
comparison to historical `92c025e7`, no additive attribution of PR gains,
no physical-traffic claim, and no entirely-memory-warm or fault-free claim**.
**#672's 1 GB/s objective remains open.**

## What this evidence supports

The unchanged [original C method](method/microarch.c) measures fresh full
compilations, four tasks per worker, with real object writes. Five rounds
rotate the 1/2/4/8/15 worker configurations. The timed cohorts ran under the
shared exclusive lock from **19:19:06 to 19:19:36 UTC on 2026-10-28**. No
frequency, CPU, memory, permission or host setting was changed for this run.
All five values remain in each range, including the 69.325 MB/s single-worker
observation; no sample was discarded or replaced.

Timed wall includes the method's launch/orchestration and per-child counter
attachment, not just time inside compiler routines. Child rusage covers the
complete child lifetime, including pre-exec setup, loader and libraries;
user counters start at exec and include the executed child workload's loader,
libraries and inherited work. They are not compiler-only instruction counts.
For the CPU column, each cohort first computes `(sum user + system)/tasks`;
the table then takes the median of those five **cohort means**, rather than
the median of individual child times.

The measured native executable is SHA-256
`06132c96872df0d3ffa910c0c7ef7814f0547deb4f40209840bcba1c63f1947e`.
Its [build identity](target/build-inputs.sha256),
[tool identity](target/official-tool.sha256),
[build script](target/stage-build.sh), [CPU metadata](target/cpu.txt),
[kernel](target/kernel.txt), [header-file hashes](target/frozen-header-files.sha256)
and [pre-measurement identity check](target/measurement-identity-check.log)
are retained. The executable itself stays target-only; large-payload
availability is explicit in [COLLECTION.md](COLLECTION.md).

The [official correctness run](target/native-qa.log) passes **4/4 commands
in 22.0 seconds**: checker **497,021/0**, deferred reader **80 fixtures /
1,423 checks / 0 failures**, calling-convention cross-check, and frozen SQLite
object/smoke control. These controls are distinct from the throughput sample.
All 25 retained object SHA-256 values are
`cb578161715c2ecf83659069957077739447d8eccb7be54953faeb30990d9755`
([receipt](target/object-validation.log)). The per-cohort [scratch records](target/scratch/)
retain every child log, all 600 child resource/status rows, 25 ELF-header
reports and 25 smoke outputs.

The original C [validator](analysis/throughput_summary.c) independently checks
the complete 25-cohort grid, unique labels/CPU IDs, successful statuses,
expected bytes, aggregate/child time and resource alignment, and actual
recorded CPU selections. It returns **0**, with no conditional counter rows
([status](analysis/throughput-status.txt), [log](analysis/throughput-validation.log)).
Every row reports **zero counter errors and 100.00000% minimum coverage**,
with positive instructions/cycles. Thus the normalized user instruction/cycle
and IPC values qualify under its stated coverage rule; counts are unscaled.
The raw retired-op field is retained without asserting that the event's
meaning has been qualified. Physical DRAM traffic remains unavailable pending
performance #49's event-selector/unit validation.

See [the detailed observation](analysis/OBSERVATION.md) for all counter and
fault ranges and [the raw report](analysis/throughput-report.tsv) for every
cohort/child value. The input JSONL hash is
`f6322af204cb215b9bd706a228788e149bd3f87842a6b3e811fb7b6a5f010d51`.

## Limits that remain part of the result

- This is one fixed input and one short five-round run, not a broad-corpus
  conclusion or independent code-placement variants. Scaling does not identify
  a bandwidth, cache, paging, scheduler or frequency cause.
- Major faults range from 0 on the one-worker cohorts to 13–28 on the
  15-worker cohorts. The maximum is `suite-throughput-r3-j15`, JSONL line 17.
  These faults remain included. After-run metadata records 60,682 MiB
  available memory, 42 MiB system-wide swap used and THP `[always]`; none
  identifies an individual child's page state or fault cause.
- CPU 10 was offline. The actual selected 15-worker list is
  `0,1,2,3,4,5,6,7,8,9,11,12,13,14,15`; one worker uses CPU 2, while the
  2/4/8-worker lists are `0..jobs-1`. Raw lists and every child's selected CPU
  are retained. Numeric uniqueness supplements, not replaces, host topology.
- The local synthetic tool fixtures pass **34/0** optimized and **34/0**
  under ASan/UBSan. They validate the offline reader, not compiler throughput.
  Their bounded receipts and exact C source are included in this record;
  their generated payloads remain local with hashes and reproduction commands.

## Setup records kept separate

The initial **unlocked, quarantined** build at **18:39:38–18:40:26 UTC**,
SHA-256 `76ef91dadb9e902b0745345412147058d166f35f9bb27962feaff8c5dea7a7f6`,
is **not** this measured image. Its quoting/continuation failure, recorded CI #714
overlap and subsequent overwrite refusal remain in [setup dispositions](COLLECTION.md#setup-and-negative-dispositions)
and the unmodified [receipts](receipts/). The earlier locked **Clang 23.1.1**
build retains its four checker `fpclassify` oracle failures and 3/4-command
result; it supplied no throughput samples here. The later official 23.1.4
image's successful 22-second 4/4 QA and throughput data stand separately.

This record contains text evidence, original methods/analysis and input
identity records. It contains no compiler modification or new dependency.
[PROVENANCE.md](PROVENANCE.md) records source/license reuse.
[REVIEW_HANDOFF.md](REVIEW_HANDOFF.md) states the single review focus and the
approved evidence-publication scope and readiness.
