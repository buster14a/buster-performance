# ABI dependency scheduling — #613, 2026-10-27

Source change: [buster#629](https://github.com/buster14a/buster/pull/629), for
[buster#613](https://github.com/buster14a/buster/issues/613).

The change replaces repeated pending-list scans with one resumable dependency
wait link per type. The normal scheduler takes O(types + members) work and
O(types) scratch. All records wait for their members; ready frontiers still use
the vector classifier, while singleton records of at most one member use its
scalar twin. Arrays and many-member records retain the vector fold even in a
singleton frontier. Allocation failure
retains the old scalar scan fallback, whose work can still be quadratic.
Source units without selected function bodies omit ABI allocation/classification.

## Source and provenance

- Baseline: Buster `92c025e71856d13eb34247477c5294d2cead139e`.
- Final snapshot: Buster `3a9c6ad7067cb072eec1325517d8ba55b89bec81`.
  Its production implementation is `407750cc72cbc973b321e96e02d2164ce0b555c2`;
  the final commit adds wide-chain coverage and revises the test watchdog.
- Initial qualification snapshot: `3c8bd6b03cbc156f5611f34f192cc0168caf51ef`.
  The second commit narrows the singleton scalar shortcut to records of at most
  one member, preserving vector folds for complex singletons.
- Both target builds use the repository's unmodified release command:
  `BUSTER_DEBUG_INFO=0 ./build.sh`, including `-O3 -march=native`, with the
  shared 9700X lock held separately for each build.
- `audit-generate.c` is retained byte for byte from buster-performance
  `7d25666880d5bbdce838bab7e0f79a31d70d4c78`,
  `docs/measurements/performance-audit-2026-10-27/generate.c`, under its retained
  Apache-2.0 WITH LLVM-exception notice. It supplies the issue's original chain.
- `generate.c` preserves that chain's declaration text and adds original
  independent-record, reverse-ID and 128-byte-chain controls. `body` adds an identity function
  passing and returning the terminal record by value, so classification has an
  actual ABI consumer; `empty` has only record declarations. Records are four
  bytes in `chain`, `reverse` and `wide`, and 128 bytes in `large-chain`.
  `wide` means a wide ready frontier of independent records. `large-chain`
  specifically measures the cutover from a broad frontier of wide records
  to dependency-ordered singleton frontiers, requested in source review.
- `dependency-driver.c` is an original entry point for the exact new in-tree
  regression fixtures. It includes the recorded Buster source; those sources'
  component notices and licenses continue to apply. No external implementation,
  fixture corpus, or generator dataset is imported into the compiler change.

## Reproduction

Export the two source revisions into sibling directories `base/` and `final/`,
then build each under the host's lock. From their common parent:

```sh
bash /path/to/this/evidence/run.sh /path/to/this/evidence
```

`run.sh` records hardware/toolchain and binary/input hashes. In this run, inputs
were prepared off-host with the same C generator (Clang 23.1.4, `-O2 -Wall
-Wextra -Werror`), uploaded and verified against their SHA-256 manifest. The
invocation set `BUSTER_613_PREPARED_INPUTS=1 BUSTER_613_KERNELS_SEPARATE=1`.
Kernel processes were independently queued with the same per-command lock,
three processes per build/state, with separate log files; their request order
rotates base/head by round. A fresh reproduction can use `run.sh` without those
environment overrides. Each measurement
command separately acquires `~/buster-fast-bench/exclusive.sh`; timing is pinned
to CPU 2, with its sibling CPU 10 offline. `time-runs` alternates the two
executables across three fresh copies each, five measured fresh processes plus
one warmup per copy and argument list, rotating the list order. All sizes
(2k/4k/8k/16k), shapes and consumer modes share one matched invocation. The
ordinary frozen-SQLite object compile is list 33 of that invocation, with its
predefines and header paths pinned to the workflow's frozen corpus. Kernel
classification runs use three alternating processes per build, separately for
sustained execution and samples preceded by 100 ms of scalar work.

## Correctness and limits

The dependency regressions cover empty and vector-tail counts, forward and
reverse type-ID order, duplicate/shared dependencies, resuming at successive
members, incomplete tags completed across two calls, and idempotent calls.
The final 131,072-record cases measure only classification CPU time, with a
five-CPU-second budget and a separate 60-second wall watchdog. Construction,
verification and descheduling are outside the CPU budget; smaller cases retain
incremental completion. This distinguishes the old scheduler's billions of
readiness visits without a short whole-child wall deadline. It is a regression
guard, not performance evidence. The expected record rows, storage and return
register are independent ABI expectations, rather than twin agreement alone.

Local screening used a Ryzen 9 7940HS and Clang 23.1.4. The exact new fixtures
pass ASan/UBSan (34 checks in the final snapshot). The initial snapshot's
wall-deadline mutation test fails both large-chain deadlines (2 of 30 checks)
when the baseline classifier is restored. The optimized
local initial build, default ABI/type suites and deferred-checker suite pass.
Its full checker reports 265,555 checks with four `fpclassify` execution-oracle
mismatches; this is a non-passing local suite, retained in `local-screen/checker.txt`.
These local results are separate from the target-host qualification and measurements.

The reviewed CPU-budget mutation is also discriminating: with only the
classifier restored from baseline, the final single forward-chain fixture
records **16.168 CPU seconds** in classification and exits 1 against its
five-CPU-second limit. `dependency-budget-driver.c` runs that one case, under
`cores -n 1`; its raw receipt is `local-screen/cpu-budget-mutant.txt`. The
current implementation passes all 34 fixtures under ASan/UBSan. These are test
robustness checks on the development host, not target-host speedup measurements.

The initial 9700X snapshot passed all eight commands in `qualify.list`, including
Clang/GCC native ABI calls, full source checking, production emission, Tier 0,
lane determinism and frozen SQLite. SQLite's 2,608 bodies have zero deferred
differences and its object symbols have no unexplained differences. The initial
compiler-source call graph reports 41 translation units, zero prohibited cycles
and zero split variables. Initial and final source manifests are retained
separately; every tracked file matched its exported source snapshot before build.

Synthetic scaling does not establish how frequently these graphs occur in real
projects. Instruction counts are separate from wall time. Executable copies do
not establish invariance to every linker placement. The scratch-exhaustion
fallback is preserved for correctness and has no linear-time performance claim.
