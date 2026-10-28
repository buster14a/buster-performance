Diagnostic-heavy compilations currently send the location, severity, message and newline through separate unbuffered stderr writes. This assembles a diagnostic, its include stack and attached notes before publishing one logical write. A 2 KiB stack buffer handles ordinary messages; checked scratch growth handles longer ones, and allocation failure flushes the complete prefix and resumes direct rendering without truncation. Custom `FILE*` sinks and stdout sequencing retain their existing behavior.

Fixes #636. This branch ports only the diagnostic change onto main `321f5976`; it includes no other performance candidates.

Validation on publication head `600262cb` (Clang 23.1.4, release build, separate `cores -n 2` runs):

- Full optimized 41-unit build passes.
- `test-preprocessor --clang --jobs 2` passes, including 90 diagnostic buffer boundary/growth/unavailable-scratch/ordering cases and 3,000 C17/C23 differential fuzz cases with zero differences or missing results.
- `test-checker-driver --executable ./build/compiler`: 21,648 checks, zero failures.
- CI selector self-test: 1,131 checks, zero failures; whitespace check clean.

The production patch is identical to the frozen change (stable patch ID), and the diagnostic-history implementation also matches the validated integrated `d3c1d45d` contract. The final commit only adds the evidence link; the built production source is `43b92c12`.

[Frozen 9700X evidence and reproduction records](https://github.com/buster14a/buster-performance/tree/4df43f7d7a685133b6beade655d9e9a306947081/docs/measurements/unclaimed-perf-2026-10-28/issue-636/target) compare candidate `60ff4b25` with base `bc1b4861`, using the shared lock and CPU 2. For file and pipe sinks, 4,000 warning/overflow diagnostics fall from 16,000 to 4,000 writes; 3,999 redefinitions with notes fall from 23,994 to 3,999. All captured stdout, stderr and objects match exactly. File-sink wall medians are 11.104→5.270 ms for warnings, 15.529→5.748 ms for redefinitions and 16.299→10.514 ms for overflow; pipe results are in the record. Silent startup comparisons are within the A/A control variation.

Those measurements describe the frozen revisions, not the current-main port. The record retains the later interference audit and excludes uncertain orientation samples from acceptance. PR #678's hosted/scalar compatibility companion remains pending separately; this PR adds no scalar shim changes.

The implementation and regression fixtures are original project contributions; external compilers were used only as oracles.
