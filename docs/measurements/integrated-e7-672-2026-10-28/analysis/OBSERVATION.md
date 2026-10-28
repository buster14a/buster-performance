# Current-e7 throughput observation

Frozen compiler source: `e7f89091648f68940b595aadd648841c1ffc3ec5`.
AMD Ryzen 7 9700X, official Clang 23.1.4 build/oracle. The unchanged historical
`method/microarch.c` ran five rotating rounds of 1/2/4/8/15 concurrent workers,
four fresh full compilations per worker, one compiler lane per child, with
real object writes. The 25 cohorts span 2026-10-28 19:19:06–19:19:36 UTC.
This is an integrated current-source observation, **not a causal comparison
to `92c025e7` or an additive attribution of individual PR gains**.

## Results

Source throughput is decimal MB/s for the same 9,507,037-byte input. Every
entry below is the median of five cohort values; the throughput range retains
all five values, including the low 69.325 MB/s single-worker cohort.

| Workers | Source MB/s, median [min, max] | Max child RSS, KiB | User+system ms per child | User instructions/source byte | User cycles/source byte | User IPC |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | 76.094 [69.325, 76.267] | 377,156 | 124.565 | 129.237 | 61.225 | 2.111 |
| 2 | 126.356 [126.293, 127.003] | 377,120 | 150.098 | 129.237 | 69.912 | 1.849 |
| 4 | 190.779 [189.263, 194.059] | 377,152 | 198.364 | 129.237 | 86.908 | 1.487 |
| 8 | 226.458 [226.156, 228.485] | 377,156 | 332.491 | 129.237 | 133.577 | 0.968 |
| 15 | 224.446 [218.114, 225.441] | 377,156 | 606.268 | 129.237 | 257.069 | 0.503 |

RSS is each cohort's **maximum single-child** RSS, then summarized across
rounds. It is neither simultaneous total peak nor summed RSS. CPU time per
child is `(sum of child user + system time) / tasks`, then summarized across
rounds. Counter values are unscaled user counts normalized to completed source
bytes; IPC is the cohort's summed instructions divided by summed cycles.
Full ranges, separate user/system times, every cohort and all 600 individual
child rows are in `throughput-report.tsv`.

Eight workers have the highest observed median. Fifteen workers do not add
throughput in this run. User instructions per source byte stay nearly
unchanged while cycles per source byte rise and user IPC falls. These are
observations of this concurrency grid; they do not identify a physical
bandwidth, cache, paging, scheduler or frequency cause.

### Faults and resources

| Workers | Major faults per cohort, range | Median of cohort mean minor faults per child |
| ---: | ---: | ---: |
| 1 | 0–0 | 2,092.25 |
| 2 | 0–4 | 2,197.625 |
| 4 | 1–4 | 2,132.25 |
| 8 | 3–11 | 2,140.34375 |
| 15 | 13–28 | 2,168.45 |

**Major faults are nonzero.** The maximum is **28** at
`suite-throughput-r3-j15` (JSONL line 17), including the exact sum of its child
receipts. The earlier quick count of 25 is not the final maximum. No cause is
established; no sample was removed, and this is not described as fault-free
or entirely memory-warm.

The recorded **after-run** memory state is 63,901 MiB total / 60,682 MiB
available, with 42 MiB of swap used system-wide. THP's recorded enabled policy
is `[always]`. Those observations do not identify which child pages were huge,
which process owns swap, or what caused a cohort's faults. CPU 10 was offline;
15 logical CPUs were online. The retained metadata is descriptive, not an
intervention or a guarantee about state throughout the timed interval.

## Validation

`throughput-summary` exited **0**. `throughput-validation.log` is empty.

- Exactly 25 distinct cohorts cover all five rounds and worker counts.
  Tasks equal workers × 4: 600 children in total, with unique task/PID records
  per cohort and every reported CPU used. All child statuses are zero.
- Every child reports **2,341,360 emitted bytes**. All aggregate output,
  completed-source bytes, fault/context-switch counts, maximum child RSS,
  user and system times match the individual receipts, within the stated
  print-precision bound for times. JSON-derived rates agree with raw fields.
- Reported CPU lists are `[2]`, `[0,1]`, `[0,1,2,3]`, `[0,1,2,3,4,5,6,7]`,
  and `[0,1,2,3,4,5,6,7,8,9,11,12,13,14,15]` at 1/2/4/8/15 workers,
  respectively. Their lengths and uniqueness match every round; every child
  receipt names one of its cohort's CPUs. This verifies recorded selections,
  alongside the unchanged method's affinity behavior, rather than replacing
  the retained topology/host provenance with a numeric-ID assumption.
- All 25 rows have zero counter errors and **reported 100.00000% minimum
  enabled/running coverage**, with positive instruction/cycle totals. The
  validator therefore permits the normalized instruction/cycle and IPC
  columns. Raw branch/miss/retired-op fields remain in the report; scheduling
  alone does not qualify the generic raw retired-op event's semantics.
- The root's object validation receipt lists all 25 retained objects with
  the same SHA-256
  `cb578161715c2ecf83659069957077739447d8eccb7be54953faeb30990d9755`;
  its ELF checks and frozen SQLite smoke control report **173 rows**, digest
  `d15437170bc02c7d`. These are separate correctness controls, not throughput
  samples or a claim to test every possible SQLite behavior.

Raw JSONL SHA-256:
`f6322af204cb215b9bd706a228788e149bd3f87842a6b3e811fb7b6a5f010d51`.
Report SHA-256:
`c4dd4009daa8d0e6f2eb6e839464eeb7b74414031a0e8dafc80ec3e9df7acd3f`.
The root retains the complete raw archive (decoded 105,697,280 bytes), SHA-256
`8757d17b9e1b094d59b60c2d20dcc2f9550d4f0d2381a9347265212f83f805f1`,
full binaries, identity receipts and 781 frozen header-file hashes. The archive
identity is the root's supplied receipt; this helper did not repackage it.
Nothing in this subtask has been published or committed.

## Limits

Five rotated rounds in one short run are observations on this exact build,
input, affinity and host state. They are not independent code-placement
variants, a historical paired A/B experiment, or evidence assigning gains to
particular merged changes. MB/s measures full compilation of this one input,
including process/setup and real object writes under the unchanged method;
it does not establish a broad-corpus throughput result. Nonzero faults remain
part of the measurements. Physical DRAM traffic remains unavailable pending
performance #49's selector/event/unit qualification; no traffic or bandwidth
ceiling is inferred from source bytes, faults, RSS, counters or scaling.
