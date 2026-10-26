# Review follow-up: bounded scratch and intrinsic cache cost

For [buster #494](https://github.com/buster14a/buster/issues/494) and [PR #506](https://github.com/buster14a/buster/pull/506), 2026-10-26 on Ryzen 7 9700X, Linux 6.18.50-2-lts, Clang 23.1.1 and perf 7.2.9-1. Baseline `7e3782ada38379f972f244a5f6b89ed0b2d4ed4a`; reviewed candidate `5535b291d868765d0361a0044d2a13ff7ae6a4a4`. Both use `BUSTER_DEBUG_INFO=0 ./build.sh`; every build and process took the shared host lock independently, with measurement processes pinned to CPU 2. Binary, SQLite source and pinned predefines SHA-256 identities are in `sha256.txt`.

The same frozen SQLite command and environment as [the earlier six-pair campaign](../checker-intrinsics-494-2026-10-26/README.md) were used. Two paired rounds, baseline then candidate, succeeded with empty stdout. Perf CSVs and bash elapsed times are retained separately. Long lock waits and other work interrupted the campaign between individual runs; the pair count is small and the ordering is not randomized.

| | Baseline | Candidate |
|---|---:|---:|
| User instructions, two values | 1,690,248,142; 1,690,248,142 | 1,623,014,011; 1,623,014,017 |
| CPU task-clock | 146.94; 146.91 ms | 143.00; 145.62 ms |
| Elapsed, includes perf startup | 152; 152 ms | 148; 150 ms |

The candidate retired about 3.98% fewer user instructions in both pairs. The sample is too small to establish a reliable elapsed-time improvement.

To quantify the new scratch cost directly, a separate candidate build applied `instrumentation.patch`, which wraps the scratch `arena_push_array` and `memset` with `CLOCK_MONOTONIC_RAW` calls and prints the intern count, bytes and elapsed nanoseconds. Its binary hash is in `sha256.txt`. Three independently locked, CPU-2-pinned processes used the same source, options and environment as the paired runs, without perf. The raw logs include the wait notices and the instrumentation output; all commands succeeded. Each run reported 24,038 names and **96,152 bytes** of scratch touched; the measured allocation plus clear took **176,722, 176,952 and 163,817 ns**, respectively (median 176,722 ns). This includes the clock and allocation overhead and the clear's memory effects, not an isolated memset benchmark or a measurement of the process's total RSS. The baseline did not allocate this intrinsic cache for an intrinsic-free unit. The instrumentation changes the executable and can perturb code placement, so use the uninstrumented pairs for whole-compile comparison.

Under insufficient scratch the revised implementation searches earlier eligible tokens to deduplicate without allocation; this preserves success on no-hit units and can take quadratic time on that exceptional path. Exact hits still report the resource failure required for their tables. The 9700X `test-checker --seed 133` passed 253,695 checks and full PR CI passed at the candidate head.
