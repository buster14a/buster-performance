# #447 offline weighted body-cost prototype: rejected

Frozen compiler input: `e7f89091648f68940b595aadd648841c1ffc3ec5`.
This is a **local Zen 4 / Clang 23.1.4 experiment**, not a 9700X result,
release-compiler throughput measurement, adaptive-lane improvement or completion
of #447. No production source or lane/copy policy was changed.

## Decision and bounded results

The first nonnegative per-kind least-squares fit reduced training error but
generalized worse than token count on every held-out group. It is rejected.
No weights were quantized, no threshold was refitted, no additional training
round was sought, and no native-host timing campaign was requested.

| Dataset | Bodies | Token model RMSE (ns) | Weighted model RMSE (ns) | Token absolute error / total observed walk | Weighted absolute error / total observed walk |
| --- | ---: | ---: | ---: | ---: | ---: |
| Six training c-testsuite units | 124 | 2,133.188 | 960.606 | 0.657209 | 0.295394 |
| Four disjoint c-testsuite units | 15 | 132,378.397 | 1,853,103.915 | 1.607942 | 20.223397 |
| Held-out SQLite | 2,674 | 16,426.781 | 64,338.836 | 0.627750 | 2.880444 |
| Five held-out musl source units | 24 | 4,525.350 | 11,573.966 | 1.783480 | 4.658440 |

Both models have a nonnegative fixed per-body term. The baseline uses token
count; the candidate has 83 nonnegative parser-kind coefficients. The baseline
is the initial feasible point of the weighted problem. Exactly the same frozen
training rows and resulting coefficients were used for all three held-out
groups; `fitted-weights.txt` byte-matches each fit's coefficients. The algorithm
is deterministic 2,000 sweeps of coordinate descent, with no regularization,
hyperparameter search or selection using held-out labels. This is one rejected
prototype, not evidence that every possible weighted model must fail.

The six training units were `00001`, `00056`, `00140`, `00169`, `00182`,
`00204`; the four held-out units were `00131`, `00200`, `00213`, `00215`.
The partition was chosen before observing these labels and splits complete
translation units. Tiny/related bodies and correlated features limit
identifiability; the lower training residual alone is not useful evidence.

## Method and scope

`prepare_profile.c` makes two source copies outside the compiler repository.
Its guarded exact edits of `c_check_deferred.c` add one per-body timestamp
field and save `walk_end - walk_begin`, using the clock calls already present
in the deferred benchmark. They do not add a clock inside the measured walk.
The main copy owns shared module definitions in one translation unit, owns the
canonical target tables, includes the instrumented deferred copy and leaves
the original driver unreferenced. Linker section GC discards unused commands.

`profile.c` preprocesses/parses each input once, runs nine **one-lane**
readings, releases the deferred state after each, and retains all raw per-body
walk samples in stderr logs. It emits their medians and exact 83-kind body
histograms in TSV; histogram collection happens after all timed readings.
Every histogram sum is checked against its inclusive body range. Every input
merged on every pass. These labels exclude reader copies, position setup,
result retention, undo, merge, and phases after the reader. They are not
whole-reader or whole-process times. The adapter's layout is instrumented;
its local labels do not establish release-head performance.

The c-testsuite and SQLite/musl profiling campaigns each ran in a separate
`cores -n 1` grant. They were not a quiet dedicated-host campaign. The local
profiler build also used one core. Failed build attempts are retained in
`profile-build.log` (missing include path) and `profile-build-2.log` (strict-C
dialect missing GNU/POSIX declarations). `profile-build-3.log` is the successful
GNU17 build. No failed body sample was dropped or replaced. `pilot-213.*`
is the initial five-body setup probe, excluded from fitting.

The fitter's exact-known-weights oracle and restart-from-token oracle pass
ASan/UBSan. Its command rejects short headers and inconsistent histogram sums
with status 1, with raw logs retained. No full compiler correctness or
sanitizer qualification is implied by these narrow adapter/tool checks.

## Inputs and provenance

All new tools, model implementation and adapter edits are original C under
`Apache-2.0 WITH LLVM-exception`. Compiler source copies retain project
notices. Corpora are runtime inputs; none of their C implementation is vendored
here. `inputs.sha256` records the exact selected source files and SQLite
predefines; `inputs-README.txt` preserves the frozen bundle's provenance.

- c-testsuite: clean checkout `5c7275656d751de0e68b2d340a95b5681858ed07`,
  selected `tests/single-exec` units. Their existing upstream origin/license
  metadata stays with that external checkout.
- SQLite: frozen **3.53.2** amalgamation, verified from both `sqlite3.c`
  (`SQLITE_VERSION` at line 470) and `sqlite3.h` (line 149), version number
  3053002. An earlier prose label of 3.53.4 was wrong for this hash; the
  actual source/header version takes precedence. Source SHA-256
  `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`;
  pinned predefines SHA-256
  `a39036d8215977b5a205f7fd3c4e7dfe6576b58eaa76a7bb0b0e214a164e8d33`.
  This current-adapter preprocessing produces 2,674 bodies; do not treat it
  as the historical A2/B2 2,608-body input/configuration.
- musl source: Zig 0.14.1-vendored musl 1.2.5 at Zig
  `d03a147ea0a590ca711b3db07106effc559b0fc6`, with its patches and frozen
  generated-header overlay, **not pristine upstream musl**. Selected source
  units: `wmemcpy`, `memcmp`, `abs`, `isalpha`, `fabs`; included header bodies
  contribute to the 24 labels. Original input manifests are retained, with
  the external paths/provenance they actually describe. This small local
  probe does not satisfy #447's real-libc 9700X timing requirement.

`host-*`, `SOURCE_COMMIT`, `tool-source-identities.sha256`, `COMMANDS.md` and
the exact generated copies retain source, executable, host and method identity.
The unmodified shared e7 release binary is separately owned by the root
campaign: SHA-256 `523ceb8df0435c089e10ba78dbc8e08be8062d7a2f10d96f4c3bbd734006865a`.
It was not rebuilt or used as though it were the instrumented profiler.

## Historical acceptance inventory

The local historical reference is an unmodified checkout of
`buster-performance` commit `e4ae6019ed75575d49f9e75fba752820a1da9050`,
folder `docs/measurements/deferred-lane-costs-113-2026-10-27`. The focused public
record keeps its unchanged README and B2 summary (the converter's input), and
links the complete immutable record rather than duplicating every old log.
Its provenance and original notices remain applicable. Historical Python/shell
scripts were not executed or rewritten for this C experiment.

`absolute.c` reconstructs 86 main/branch B2 summary rows by multiplying
rounded ns/token by token count. `absolute-B2.tsv` explicitly includes the
rounding bound ±0.005 × tokens ns. These are derived approximate medians,
not new measurements or recovered unrounded samples. The original historical
record contains no peak/retained RSS series and no real-libc timing workload.
The compiler's companion design inventory records these still-open gates.

An initial converter invocation used an incorrect column count and returned
`rows=0 valid=no`; it was corrected to the actual 24-column published format.
An initial strict-C compile also placed a system header before its POSIX
feature macro and failed. Those setup failures are not successful conversions;
the final conversion is explicitly the 86-row result. No historical raw log
was changed to make the converter pass.

#697 item 3 remains an owned dependency. The current API retains state memory,
but no production multiread caller exists; test rereads and the same-unit
`--warm` benchmark do not satisfy that prerequisite. Active items 1, 2 and 4,
including the cold rule and copy refit, remain with their existing owner.
Item 4 subsequently merged as #719 at
`16d5c61704eae82a0c40607771b5f3dc0f207d97`, outside the frozen e7 experiment.
