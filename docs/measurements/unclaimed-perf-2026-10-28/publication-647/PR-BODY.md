The scheduled streaming benchmark pins its parallel rows to one CPU, making eight lanes contend and producing misleading numbers. This gives the step up to eight distinct allowed physical cores and selects its writer pair from that same set. The benchmark also clamps lanes to inherited affinity, rejects malformed CPU pairs, and prints `not run` for unavailable parallel rows without validating or collecting samples for them. Each split CI step is gated by the benchmarks its own commands run.

Fixes #647. The qualified change from main `4165454e` is merged with current main `321f5976`; the newly merged ISA test registrations and encoder paths are preserved. The PR changes benchmark configuration and reporting, with no compiler throughput speedup claim.

Validation on publication head `b645da36` (Clang 23.1.4, release build, separate `cores -n 2` runs):

- Full optimized 41-unit build passes; the built production source is `b9e06146`, with only documentation and workflow `if` gates changed afterward.
- `test-streaming --units 8`: 188 checks, zero failures, including all 22 CPU configuration cases.
- The exact workflow shell passes syntax checks and runs all five real benchmark variants on two distinct allowed physical cores (100 units, 32 functions, five runs); each existing executable and byte oracle passes.
- A one-CPU process requesting eight lanes selects one and explicitly skips the writer and parallel-direct rows.
- Newly merged `test-x86-target-selection` passes all baseline/v3/v4 policy, native-record and exact-twin checks.
- Call graph: 41 units, zero cycles beyond the three existing allowed cases, zero split variables.
- Corrected CI selector self-test: 1,133 checks, zero failures; whitespace check clean.

The compiler/test production patch retains the frozen change's stable patch ID. The publication workflow gates narrow the backend step to backend/unwind and the streaming step to streaming; the CPU-selection shell is identical to the frozen validated version.

[Frozen 9700X evidence and exact commands](https://github.com/buster14a/buster-performance/tree/4df43f7d7a685133b6beade655d9e9a306947081/docs/measurements/unclaimed-perf-2026-10-28/issue-647/target-README.md) cover `b1975e31`: eight successful locked invocations including one/two/eight-core placements, unavailable/malformed pairs, streaming's 188 checks, and the actual workflow command. Pure-main `4165454e` on one CPU reproduces 71.700 ms after the last function for nominal eight lanes versus 0.558 ms for one. Properly configured candidate two/eight-lane rows take 0.532/0.567 ms. This establishes the configuration correction on those frozen revisions; it is not a fresh timing qualification of the publication merge.

Private application against draft #678 was checked separately. Its hosted/scalar compatibility companion remains pending; no changes are made to that PR's branch here.

The CPU configuration tests and implementation are original project contributions, covered by the project license inventory.
