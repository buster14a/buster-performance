# Integer struct literal-table recovery for #1383

Recovery of direction 3 of [buster#1383](https://github.com/buster14a/buster/issues/1383):
fully braced arrays of structs with ordinary integer members. Floating members
remain on the ordinary path. This is not a closeout of the whole issue.

## Frozen sources and method

- Base: Buster `872cb8fe34b5b009698ccd1a81688f4a94f1e3ee`.
- Candidate: Buster `3750707e6c687d75144f58d864bef1495ac4464d`.
- Original commits preserved in candidate history: `5937ce5f` and `a6b05edc`.
- Host: physical Ryzen 7 9700X (`benchpress`), Linux/x86-64, under its shared
  `exclusive.sh` lock. Both compilers use the same installed Clang and
  `BUSTER_HOST_ARCH=znver5 ./build.sh --jobs 8`, with Release's normal debug
  information. Exact CPU/toolchain and executable hashes are in `receipt.txt`.
- Each timed child is pinned to CPU 2 and runs `compiler -c -o /dev/null INPUT`.
  The C harness measures a fresh child's complete wall time with
  `CLOCK_MONOTONIC`, and its own peak RSS with `wait4`.
- One warmup per executable/input (round 0), followed by five recorded runs.
  Revision launch order alternates each round. The raw TSV retains warmups, exit
  statuses, minor/major faults and peak RSS in KiB.
- One executable layout per revision. Large-table changes establish this
  workload's improvement; small control differences do not establish a
  general compiler speedup or a layout-independent regression.

The old record filler treated member offsets in bits as byte offsets. Most
records therefore failed its bounds check and silently retained ordinary
planning. Recovery divides those offsets by eight, checks the byte bounds and
payload size, and reports token-column allocation failure as a resource failure.
The permanent regressions now require compact selection and compare complete
initializer bytes with the ordinary graph, rather than permitting fallback to
make a native execution test pass.

## Results

All 48 child processes exited successfully: eight warmups and forty recorded
runs, five per revision/input. Both target tables use about 70% less peak RSS.
The flat and floating-member controls are essentially unchanged in these builds.

| Input | Base median ms | Candidate median ms | Ratio of medians | Base / candidate median RSS (MiB) |
| --- | ---: | ---: | ---: | ---: |
| file250000.c | 647.255 | 108.939 | 5.94× | 1601.68 / 481.43 |
| local250000.c | 651.320 | 114.679 | 5.68× | 1601.68 / 481.42 |
| flat1000000.c | 58.119 | 58.029 | 1.00× | 346.08 / 346.11 |
| float50000.c | 63.259 | 63.270 | 1.00× | 221.05 / 220.95 |

| Input | Base wall range (ms) | Candidate wall range (ms) | Paired base/candidate ratio range |
| --- | ---: | ---: | ---: |
| file250000.c | 644.594–650.531 | 107.156–118.004 | 5.46–6.04× |
| local250000.c | 648.391–673.009 | 112.948–115.327 | 5.65–5.86× |
| flat1000000.c | 57.758–61.535 | 57.752–58.366 | 0.99–1.05× |
| float50000.c | 62.888–64.372 | 62.791–63.933 | 0.99–1.01× |

The first file-scope candidate warmup took 204.718 ms and 402.93 MiB, versus
108.939 ms and 481.43 MiB in the recorded-run medians. Its 131,209 minor faults
fell to roughly 1,675 per recorded run. This cold/warm allocation difference is
why round 0 remains visible but is excluded from the summaries. The five pairs
are repeats of one layout, not independent layout samples or a confidence interval.

Every one of the four complete ELF objects is identical between base and candidate,
and between scalar and vector compilation: sixteen emitted objects in all.
`object-proof.sha256` pins both binaries and the four generated inputs;
`fixture-object-hashes.txt` retains the individual object digests. The separately
run proof was reused after the timed trials only after its input hashes matched.

## Inputs and reproduction

`measure_struct_tables.c` is original project C. Its deterministic xorshift32
generator starts from state 1. `file250000.c` and `local250000.c` contain 250,000
records of `int`, `unsigned char`, `long` and `short`: one million scalar values,
with natural interior/tail padding. The latter declares a block-scope static.
The unchanged flat control contains one million unsigned values. The ordinary
floating-member control contains 50,000 two-member records.

`prepare.sh` builds the helper and generates those sources under one hardware
lock. Freeze the two executables as `bin/base` and `bin/head`. `measure.sh` takes
the shared lock for each measured child, warms and alternates them, and runs `verify_objects.sh`
as a separate locked correctness suite to compare complete emitted objects
between revisions and scalar/vector modes.
Fixture and object hashes are retained instead of multi-megabyte generated
sources and objects. Regenerate inputs with the exact archived helper.

For reproduction, create `base/` and `final/` checkouts at the frozen revisions in
`~/buster-fast-bench/1383-struct-codex`, build them under the shared lock as above,
run `exclusive.sh bash prepare.sh` there with the lock's owner/title/link
environment, then run `bash measure.sh` with the archived scripts alongside it.
The target-table runs used `measure-serial.sh`; remaining runs were prequeued
independently by `measure.sh` to avoid repeated gaps behind long builds. Each
process still acquires and releases the shared lock itself. All missing warmups
finish before the next batch is queued. `runs/*.start` records actual start times
for that portion; TSV rows are retained in launch order. The object comparison
may run separately and is reused only when both binaries and all four input
hashes still match its proof.

## Validation

`validate.sh` runs the full checker with seed 133, deferred checking,
translation-unit checking and all four driver partitions, taking and releasing
the hardware lock per command on `715bc7d4`. Its first checker run exposed fifteen
fixture-adapter failures: each of five native sources also initialized a local
pointer, while the byte comparator requires exactly one initializer plan, and
each source runs through three paths. The test-only `3750707e` uses a pointer
assignment instead. `verify_final.sh` reruns the full checker on that revision.
Detailed logs and the campaigns' exit statuses are retained alongside this
report. The permanent tests include scalar/vector
compact selection, ordinary-graph byte equivalence, packed/aligned layouts,
incomplete and oversized outer bounds, threshold tails, block statics,
unsupported-member and grammar fallback, protected output, scratch rollback,
and deferred replay/forced fallback. Existing native tests compare execution
with external Clang builds.

| Native suite | Source | Checks | Failures |
| --- | --- | ---: | ---: |
| Full checker, seed 133 | `3750707e` | 805,037 | 0 |
| Deferred checker | `715bc7d4` | 3,400 | 0 |
| Translation units | `715bc7d4` | 2,376 | 0 |
| Driver, all four partitions | `715bc7d4` | 72,581 | 0 |

The physical host's compiler/oracle is Clang 23.1.1. All eight hosted PR
correctness shards, using CI's Clang 23.1.4, also passed at `3750707e` in
[run 42393218297](https://github.com/buster14a/buster/actions/runs/42393218297).
That run was for the draft PR and did not admit its hardware job; it is not a
ready-state hardware/aggregate acceptance result. Sanitizer and fuzz acceptance
remain separate from the checks recorded here.

Lock-wait owner notices are omitted from archived logs to leave out unrelated
sessions' details. Test output and measured rows are otherwise retained.

The source, harness and fixtures are original project material under
Apache-2.0 WITH LLVM-exception. Clang runs externally as a tool/oracle. No
third-party implementation or fixture corpus is incorporated. No private
agent transcript or raw debugger/perf capture is included.
