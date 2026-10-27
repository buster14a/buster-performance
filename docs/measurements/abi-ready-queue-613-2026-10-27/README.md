# Bounded ABI dependency scheduling — #613, 2026-10-27

Source: [buster#629](https://github.com/buster14a/buster/pull/629), for
[buster#613](https://github.com/buster14a/buster/issues/613).

The accepted implementation retains the existing scan and vector-frontier path
for at most 16 scans. It then walks by-value dependencies once on an explicit
stack, computes topological levels, and counting-sorts pending types into vector
frontiers. Wide records keep their existing early-classification shortcut.
Storage-sensitive zero-length arrays bypass the scan prefix, so readiness does
not repeatedly walk their transitive storage dependencies. Scheduling with
scratch is O(types + members); scratch exhaustion retains the original scalar
scan fallback, which has no linear-time claim. Units without selected function
bodies omit ABI allocation and classification.

The initial all-member wait-list implementation was rejected after a roughly
29% general ABI kernel regression on the 9700X. Its raw evidence remains in
`rejected-all-members/`; those timings are not results for the final source.

## Sources and provenance

- Baseline: Buster `92c025e71856d13eb34247477c5294d2cead139e`, directory `base/`.
- Final: Buster `6c82c8e3eb0b91729327616499c0ed8a853aac45`, directory `hybrid/`.
  All tracked source files matched `hybrid-source-sha256.txt` on the target.
- Rejected all-member snapshot: `3a9c6ad7067cb072eec1325517d8ba55b89bec81`,
  directory `final/` in the rejected run. Initial qualification also records
  `3c8bd6b03cbc156f5611f34f192cc0168caf51ef`. These are historical checks, not
  substitutes for qualification of the final source.
- Target builds use the unmodified release command `BUSTER_DEBUG_INFO=0
  ./build.sh`, including `-O3 -march=native`. Each build separately takes the
  shared 9700X lock. Baseline and final builds took 32.2 and 31.7 seconds.
- `audit-generate.c` is byte for byte from buster-performance
  `7d25666880d5bbdce838bab7e0f79a31d70d4c78`,
  `docs/measurements/performance-audit-2026-10-27/generate.c`, under its retained
  Apache-2.0 WITH LLVM-exception notice. It supplies the issue's original chain.
- Original `generate.c` preserves that chain's declaration text and adds
  independent records, reverse-ID chains and 128-byte chains. `body` adds an
  identity function passing and returning the terminal record by value; `empty`
  has only declarations. Records are four bytes for `chain`, `reverse` and
  `wide`; `large-chain` records are 128 bytes. `wide` means an independent ready
  frontier, not wide record storage. `large-chain` addresses the source review's
  request to measure wide by-value dependency chains.
- Original C entry points include the recorded compiler's in-tree tests and
  benchmark, under those sources' retained component notices and licenses.
  No outside implementation, corpus or generated dataset enters the compiler
  change. The ordinary SQLite control uses the existing frozen runner corpus.

## Method and reproduction

Export the baseline and final revisions into sibling `base/` and `hybrid/`
directories and build each under the host's shared lock. From their parent:

```sh
bash /path/to/this/evidence/run.sh /path/to/this/evidence
```

`run.sh` records hardware, compiler and binary/input hashes. Measurements use
the approved Ryzen 7 9700X, Clang 23.1.1, performance governor, CPU 2, with its
sibling CPU 10 offline. Each command acquires
`~/buster-fast-bench/exclusive.sh` separately; no lock surrounds a series.
Inputs were prepared off-host with the exact C generator (Clang 23.1.4,
`-O2 -Wall -Wextra -Werror`), uploaded and checked against the retained manifest.
The actual run set `BUSTER_613_PREPARED_INPUTS=1
BUSTER_613_KERNELS_SEPARATE=1`; both overrides can be omitted for reproduction.

One `time-runs` invocation alternates baseline/candidate fresh processes, across
three fresh executable copies, five measured runs and one warmup per copy and
argument list, with rotating list order. There are 15 measured samples per
build/case: 990 measured samples plus 198 warmups across 33 cases. Sizes are
2,000/4,000/8,000/16,000; shapes and modes map to list IDs as follows:

| Lists | Shape | Mode |
| --- | --- | --- |
| 1–4 | chain | empty |
| 5–8 | chain | body |
| 9–12 | reverse-ID chain | empty |
| 13–16 | reverse-ID chain | body |
| 17–20 | independent records | empty |
| 21–24 | independent records | body |
| 25–28 | 128-byte chain | empty |
| 29–32 | 128-byte chain | body |
| 33 | frozen SQLite | ordinary object compile |

Within each range, sizes ascend. SQLite uses the frozen predefines and header
paths in `run.sh`; production-driver arguments do not contain
`--no-default-config`. `summarize.c` requires exactly 15 measured samples for
every build/case, no duplicate/missing rows and status zero for every row. It
reports sample medians and wall-time min/max. A consistent nonzero exit is a
failure even if `time-runs` reports no deviations from its warmup status.
`verify.c` separately requires successful compiles and byte-identical objects
for all 33 cases, pinned to CPU 2 under a fresh lock.

General ABI kernels use three processes per version/state, 21 internal samples
per process, both sustained and after 100 ms of scalar work. Each process is
independently queued under the lock. Requests rotate version order by round;
shared lock acquisition may reorder execution, so these are not strict paired
wall-time observations. Logs include counters, branch misses and throttle.
Direct classification batches are retained as an unchanged-path control.

## Final measurements

All 990 measured processes exit zero; the strict reader accepts all 33 cases.
The separate object verifier passes all 33 cases: both compilers exit zero and
their objects are byte-identical, including SQLite.
Raw logs, hashes and derived CSVs are in `9700x/measurements/`. The following
are medians of the 15 fresh-process samples, in milliseconds:

| Records | Chain, empty: base → head | Chain with ABI consumer: base → head |
| ---: | ---: | ---: |
| 2,000 | 5.978 → 3.587 | 6.152 → 3.965 |
| 4,000 | 14.066 → 5.104 | 14.426 → 5.834 |
| 8,000 | 44.863 → 8.526 | 45.173 → 9.465 |
| 16,000 | 159.154 → 14.377 | 159.705 → 16.200 |

The 16k empty chain is 11.1× faster, with instructions falling from
5,838,986,384 to 185,672,052 (96.8% fewer). With a real ABI consumer it is
9.9× faster, with 5,839,059,581 → 220,729,205 instructions (96.2% fewer).
Its full wall range is 157.447–161.996 ms baseline and 16.050–16.310 ms head.
The reverse-ID 16k chain with a consumer is 160.116 → 18.782 ms (8.5×),
with 5,888,107,368 → 270,863,790 instructions. Startup and other compiler
stages are included, so these timings do not isolate scheduler cost.

Controls with an actual ABI consumer preserve broad and wide-record batching:

| Records | Independent records: base → head ms | 128-byte chain: base → head ms |
| ---: | ---: | ---: |
| 2,000 | 3.181 → 3.111 | 3.912 → 3.846 |
| 4,000 | 5.112 → 5.065 | 5.398 → 5.395 |
| 8,000 | 8.111 → 8.059 | 9.082 → 8.978 |
| 16,000 | 14.127 → 13.985 | 15.433 → 15.375 |

The 16k 128-byte-chain instruction counts are 191,385,306 → 191,361,410;
wall ranges overlap (15.223–15.686 and 15.173–15.542 ms). Independent 16k
records have 179,652,446 → 179,708,473 instructions. These results support
preserving the existing broad path, not a meaningful speedup for those paths.
Skipping ABI work also helps the independent empty control: 13.728 → 13.161 ms
and 179,579,416 → 164,946,922 instructions at 16k.

Frozen SQLite is 146.760 → 146.299 ms (−0.31%), with overlapping wall ranges
145.153–147.450 and 145.549–148.207 ms. Instructions are effectively unchanged:
1,549,208,991 → 1,549,204,422. This supports no ordinary-source throughput
claim. Median peak RSS increases 507,960 → 510,136 KiB (+2,176 KiB, 0.43%);
the 16k chain with a consumer also increases 135,728 → 137,768 KiB. This is
not a memory-reduction result.

For the general classification kernel, these are medians across three process
medians, with the range of those three medians in parentheses, in ns/type:

| Regime | Vector bytes | Base | Head |
| --- | ---: | ---: | ---: |
| sustained | 16 | 39.94 (39.91–40.29) | 40.17 (39.93–40.21) |
| sustained | 32 | 44.24 (43.96–44.46) | 44.40 (44.11–44.49) |
| sustained | 64 | 47.45 (47.11–47.62) | 47.57 (47.54–47.76) |
| after scalar | 16 | 40.32 (40.23–40.40) | 40.22 (40.12–40.30) |
| after scalar | 32 | 44.44 (44.41–44.54) | 44.34 (44.26–44.49) |
| after scalar | 64 | 47.59 (47.57–47.74) | 47.54 (47.53–47.85) |

The shallow graph remains on the original vector-frontier strategy. Scheduling
adds 9.11 instructions/type: 607.35 → 616.46 (16 bytes), 647.88 → 656.99
(32), and 710.85 → 719.96 (64), or 1.3–1.5%. Sustained wall medians rise
0.25–0.58%; after-scalar medians fall 0.11–0.25%, with overlapping ranges.
No general-kernel timing gain is claimed. Direct batch instruction counts are
unchanged at 729.45/614.09/549.12 for windows of 1/4/16 types. Counters and
throttle are retained in the raw logs and `kernels.csv`.

Build and run the strict readers from this record's directory:

```sh
clang -O2 -Wall -Wextra -Werror summarize.c -o summarize
./summarize 9700x/measurements/scaling.txt 33
clang -O2 -Wall -Wextra -Werror summarize-kernels.c -o summarize-kernels
./summarize-kernels 9700x/measurements/hybrid-kernel-*.log
```

Both return nonzero for invalid, duplicate or missing records. The same strict
scaling reader rejects the old failed SQLite campaign; its rejection receipt is
retained with that campaign.

## Correctness and regression guard

The final optimized 9700X build passes all eight commands in `qualify.list`:
cross-compiler ABI calls, types, full source checking, production emission,
deferred checking, Tier 0, lane determinism and frozen SQLite. The full checker
has 265,555 checks with zero failures; Tier 0 has 234,706; lanes have 2,749.
SQLite's 2,608 bodies have zero deferred differences and its object symbols
have no unexplained differences. The eight commands took 27.1 seconds wall and
80.7 seconds CPU under the lock. The source call graph has 41 translation units,
23,968 functions and 143,483 calls, zero prohibited cycles and zero split
variables. Raw logs are in `9700x/hybrid-*`.

All 46 dependency regressions pass under ASan/UBSan on the development host,
along with the independent ABI oracle, generated worlds, bit-field and
assignment tests (`local-screen/hybrid-oracle.txt`). Dependency fixtures cover
zero and 15/16/17, 31/32/33 vector/frontier boundaries, both ID orders,
duplicate/shared members, incomplete tags completed across calls, idempotence,
4,096-type 128-byte chains and 131,072-type deep chains. Independent expectations
check the rows, storage, stack and return register, beyond twin agreement.

The sanitizer entry point can be reproduced from the final compiler checkout
with `-Isrc` and this record's `abi-oracle-driver.c`, using Clang flags
`-O1 -march=native -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror
-ffunction-sections -fdata-sections -Wl,--gc-sections
-fsanitize=address,undefined -fno-sanitize=function -fno-omit-frame-pointer`.
The recorded run sets `ASAN_OPTIONS=detect_leaks=1:halt_on_error=1` and
`UBSAN_OPTIONS=halt_on_error=1`.

The deep cases measure only classification's `CLOCK_PROCESS_CPUTIME_ID` with a
five-CPU-second budget, separate from a 60-second child watchdog. Construction,
verification and descheduling are excluded from the CPU budget. Restoring only
the original classifier records 16.168 CPU seconds for the single forward-chain
fixture and exits 1; the receipt is `local-screen/cpu-budget-mutant.txt` and the
entry point is `dependency-budget-driver.c`. This is a discrimination/stability
check, not target performance evidence. Small cases retain incremental
completion. Initial whole-child five-second mutation receipts remain historical.

Local screening used Ryzen 9 7940HS and Clang 23.1.4. Initial optimized build,
default ABI/type and deferred-checker suites pass. The initial full checker
reports four `fpclassify` execution-oracle mismatches out of 265,555 checks;
`local-screen/checker.txt` is a non-passing local suite, separate from the
passing final target suite with Clang 23.1.1. No pre-existing-failure claim is
made without a same-host baseline reproduction.

Historical local dependency receipts name their snapshots as follows:
`dependency-sanitize.log` is `3c8bd6b`, `dependency-final-sanitize.log` is
`407750c`, and `dependency-reviewed-sanitize.log` is `3a9c6ad`. The old
`dependency-mutant.log` uses the initial fixtures with baseline classification;
the CPU-budget mutation uses the reviewed `3a9c6ad` fixture. Only
`hybrid-oracle.txt` records the final `6c82c8e3` sanitizer oracle run.

## Rejected experiment and harness correction

`rejected-all-members/` retains all-member scheduling's raw timings, kernels,
qualification and source manifest. Its general ABI kernel rose from about
40.6 to 52.4 ns/type for 16-byte vectors, with 607.35 to 675.88
instructions/type; 32/64-byte-vector kernels regressed similarly. This prompted
the bounded shallow prefix and restoration of early wide-record batching.

That rejected timing campaign also passed the production driver an unsupported
`--no-default-config` argument for SQLite: all SQLite measurements exited 1,
and the object verifier refused the case. These are harness failures, excluded
from performance and correctness acceptance. The complete raw log remains;
`accepted-shapes.txt/.csv` explicitly select its 32 successful synthetic cases
only. The final campaign corrects the arguments and must pass all 33 cases.

## Limits

Synthetic scaling does not establish how often these graphs occur in real
projects. Instruction counts are separate from wall time. Three executable
copies do not establish invariance to every linker placement. General kernel
results cover one generated workload and the measured frequency regimes.
The scratch-exhaustion fallback is preserved for correctness and can remain
quadratic. Manual qualification does not establish GitHub CI completion,
independent review approval or merge acceptance.
