# First-party native profiles and static Pages acceptance

This generation implements the first-party-only direction for Buster #384–#390.
Original captures, harnesses and receipts remain here. Website/reader/collector
source lives in Buster. No upstream implementation is a project dependency.
The independent trace processor below is an external qualification oracle only.

## Immutable identities and reproduction

- Capture/FP compiler source: Buster
  `d5aa12b67c129701919a40996bad97236039d858`.
- Matching binary SHA-256:
  `c53ba3994bc64025e7f3fdadadc62ddd2c40a224f5b5e4d65d80131a436400b3`.
- Input `src` Git tree: `9d90fc6760761687aae3a088ef7fdbbc0fb771cc`.
- Receipt/partition reader pin:
  `948b61ddca54c7551da9509a291bae8f667bbc3c`.
- Original adapter source pin:
  `787d729a0e1463e40bc437be2486de839200a515`.
- Frozen census input is the reviewed first-party v2 census of archive
  `d3453eb2099d1e4dcd9c997720fcf6e0d86b81ea`, not current archive completeness.
- Deterministic recipe timestamp: `2026-10-25T13:19:28Z`. Two independent runs
  of each original C producer reproduced identical bytes.

From a Buster checkout containing the reader pin and this performance checkout:

```sh
clang -std=c17 -D_GNU_SOURCE -O2 -Wall -Wextra -Werror -I BUSTER/tools/performance \
    partition.c -o /tmp/buster-partition
/tmp/buster-partition ../performance-first-party-2026-10-25/history/census \
    NEW_PARTITION_DIR 2026-10-25T13:19:28Z \
    948b61ddca54c7551da9509a291bae8f667bbc3c \
    787d729a0e1463e40bc437be2486de839200a515
clang -std=c17 -D_GNU_SOURCE -O2 -Wall -Wextra -Werror -I BUSTER/tools/performance \
    report.c -o /tmp/buster-profile-report
/tmp/buster-profile-report profile/captures NEW_PROFILE_DIR 2026-10-25T13:19:28Z \
    948b61ddca54c7551da9509a291bae8f667bbc3c \
    787d729a0e1463e40bc437be2486de839200a515
```

For the report reproduction, place the retained native `profile/capture.pftrace`
at `profile/captures/profiled-01/capture.pftrace` in a scratch copy; the immutable
artifact is retained once rather than duplicated. Use new output directories.
Every target-host build/test/conversion/execution must take its own approved
9700X `exclusive.sh` lock. Local browser/ASan checks are diagnostic/reader
qualification and are not new target-host performance measurements.

## Real capture and fidelity

The source is a real `benchmark-lexer src` execution on benchpress, Ryzen 7
9700X, Linux `6.18.50-2-lts`, CPU 2. The binary was built with Clang 23.1.1,
`BUSTER_DEBUG_INFO=0`, and the original build.sh plus
`-fno-omit-frame-pointer -mno-omit-leaf-frame-pointer`. The ephemeral `clang`
wrapper executed `/usr/bin/clang` with those two extra flags and all original
arguments. The build log is retained. Profiler and control use the same binary.

The original C collector calls Linux perf_event_open directly. Retained source
artifacts include exact event attributes, kernel records, output, original clock
reads and successful execution/resource receipts. No tracebox, unwinder library,
generated protobuf code, root service or system configuration change is used.

`9700x-first-party-import-01.json` records 871 samples / 5,702 frame occurrences,
232 symbolized unique frames, zero IP-only samples, zero reported lost records,
zero lost samples and zero throttles. Eight paired switch intervals retain
701,129,382 ns of observed running; one boundary edge remains unpaired. The
remaining leader time is not inferred to be idle. Unresolved library frames and
unproven complete unwinding remain explicit.

The native output uses Perfetto v58.2 StackSample with primary_weight and a
nanosecond descriptor. The original CPU-clock period is 1,000,000 ns per sample;
the total is 871,000,000 ns. It is statistical source weight, not actual function
invocations, instrumented duration or an exact user-only CPU-time sum. Source
CPU-clock periods may include work preceding a user-mode observation.

CLOCK_MONOTONIC is authoritative. Sequential MONOTONIC/BOOTTIME/REALTIME readings
and their read bracket are retained in clock-snapshot.json. Initial/final
scheduling state, task reuse, processes outside CPU 2/leader lifetime and actual
source/assembly content remain unavailable. Direct Superluminal package import
is unsupported. See Buster's profile capability matrix for exact view boundaries.

Independent oracle: Perfetto `v58.2-add693d8b`, source
`add693d8b338ba9599dbcbc3e300b1ab8c000897`, RPC API 14; binary SHA-256
`58042408e6cc861fb1a731c26bb082dc222285561eaa4e12a48a8b2b90dca7b9`.
It is deliberately outside both projects. The two independent-query CSVs agree
with original C and browser totals: 871 samples / 871,000,000 period ns; native
`[2652773000000000,2652773500000000)` selects 500 samples / 500,000,000 period ns.
No nonzero parser/clock/data-loss error statistic was reported.

## Separate collection overhead

Fourteen original receipts retain all profiled/unprofiled process identities.
Pair 1 is a retained capture/warmup pair, excluded from inference. Pairs 2–7
alternate unprofiled-first and profiled-first. Each fresh process has a separate
host lock; original command output and resource values remain once per execution.

`profile/collection-overhead.json` retains exact paired differences and a seeded
10,000-resample percentile interval over six independent pairs. Median observed
profiled-minus-unprofiled wall difference is -20,154,633 ns; the 95% interval is
[-31,951,394, 9,485,851] ns and includes zero. **A positive collection cost is not
resolved within this workload's run variability.** Negative apparent differences
are not an optimization claim or a general overhead bound. Inter-run thermal,
turbo and cache history are not controlled; wall brackets include launch/loader/
exit observation. CPU-resource source precision is microseconds; RSS is KiB.

## Frozen source drilldowns and browser checks

`history-partitioned/` holds 82 ordered JSONL parts with ordinary original Arrow
schema sidecars. Concatenation exactly reproduces the reviewed 8,831,330 source
bytes, SHA-256 `e4990dbcbdd5ffd610e64290275025be07911cf3a6ece3a70126eb1ee46fc2e0`.
All 19 families / 1,043 paths / 17,789 source rows / 191,789 cells remain covered.
Empty/planned/unsupported families acquire no timing rows. Family-only manifests
load independently; the site catalog/family overview does not eagerly load them.

Native ASan/UBSan checks: 11 profile assertions and 64 prefix safety probes.
Some complete native packet prefixes are valid smaller traces; exact resource
size/hash and successful source receipt identify the intended whole artifact.
The original partitioner and report producer also ran under ASan/UBSan.

`profile-browser-local.json` records 31 checks in actual Chromium 156: source
samples/periods, self/inclusive attribution, chronological ranges, thread/CPU,
native scheduling/instrumentation/counters/flow, exact values beyond binary64,
incremental dictionary epochs, malformed inputs and explicit missing capability
behavior. Heap fields are a process-reported snapshot, not peak or whole-browser
RSS. The real capture is target-host evidence; this browser ran locally.

The native source fixture remains explicitly synthetic. Its SQL reference range
`[1002000000,1007000000)` selects five samples; the separate browser interaction
`[1003000000,1007000000)` selects four. Eight total samples, leaf parse/check/
encode counts 4/2/2 and inclusive main/worker counts 6/2 agree. Native scheduling
contains 9,000,000 ns for CPU 2 / TID 100 and 3,000,000 ns for CPU 3 / TID 101.

`site-index.json` is a manually curated, data-only input for the original C
publisher. A deployed generation pins its exact reviewed evidence commit and
Buster source revision. Publication and actual deployed-browser/load acceptance
are separate receipts; a locally sealed artifact does not by itself close #390.

The [deployed generation receipt](DEPLOYMENT.md) records the live first-party
site, reproducible publication, final browser checks and scoped load/memory costs.
