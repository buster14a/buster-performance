# Packed-member address diagnostic, #507

This record accompanies [Buster #512](https://github.com/buster14a/buster/pull/512)
for [#507](https://github.com/buster14a/buster/issues/507). The change implements
the default `-Waddress-of-packed-member` warning, its alignment/cast rules,
builtin contexts, source locations and diagnostic pragmas. Its original probes
compare complete messages and presumed line/column pairs with external Clang.

## Sources and machines

- Reference: Buster `af7ae9e2b5335da3a25337c452a4e57cc67db0df`.
- Candidate source: Buster `4fa50ac2b2e75f9dbce70306660c59d11ea6b298`.
- The candidate includes main's CI-timeout update, with no source overlay in
  any measured directory. `source-identity.txt` records the build-input objects.
- The candidate contains main `e04462c12f1ce25c70e41e8aa4acf48f4d7c4004`.
  Between that main and the reference, production checker code is unchanged;
  the other changes are x87 tests and documentation. Different executable
  placement remains a limitation of this comparison.
- Qualification and timings: Ryzen 7 9700X, Linux 6.18.50-2-lts, Clang 23.1.1,
  normal `build.sh`, `BUSTER_DEBUG_INFO=0`, its automatic wild linker selection.
  Each build and test command takes `~/buster-fast-bench/exclusive.sh`. Timing
  uses CPU 2, with the same lock taken separately for each `ab` run.
- Local diagnostic checks: Ryzen 9 7940HS, Clang 23.1.4. Those measurements are
  not used for target-host performance conclusions.

The candidate's `git archive HEAD build.sh src tests` SHA-256 is
`bcae064e8f021f4ef64a3a8442fabc6e93f8a41f0999627b6af3d6da9f6713fd`;
the reference archive's is
`16905193fea947480407776b27a151092667e1cf06779727a2a2578cf72e956d`.
Archives are unpacked into separate directories, with no source overlay during
a build or run. Binary and input SHA-256s accompany the final logs.

## Validation

`tests.list` runs the type suite, checker suite (seed 507), production driver
suite, deferred-reader suite and a small packed-local-record corpus with four
deferred lanes. `packed-corpus.c` is an original integration fixture.

The driver includes 102 original Clang differential cases and independent
guarded-tail and allocation-exhaustion checks. Direct interval tests cover all
counts 0–129, independently computing membership for empty, nested, overlapping
and cancelling intervals across the 16-lane boundaries, with protected tails.
The zero-match allocation test gives both arenas zero capacity and requires an
unused packed declaration plus an ordinary address to consume neither storage
nor scratch. The differential oracle runs separately;
each source case then runs through the scalar and vector source paths, through
both the internal driver and the real executable when `--executable` is given.
The cases cover explicit and implicit casts, builtin calls, nested and anonymous
records, long typedef names, generic/choose selections, unevaluated and unchosen
operands, source locations, suppressed diagnostics and promotion to errors.

The local broad checker run has four failures in the existing fpclassify
effect-order oracle. The unchanged reference reproduces all four, with the
same values, under Clang 23.1.4. The local driver results and
the reference reproduction are retained separately. This observation does not
turn the local broad checker result into a pass.

The selected candidate's local build and production driver suite passed:
**20,986 checks, 0 failures**, including all 102 differential cases.
`local-final-build.log` and `local-final-driver.log` cover the selected head.
`local-final-checker.log` is **253,545 checks, 4 failures**, all four matching
the unchanged local reference reproduction. `local-final-contexts.log`/`.tsv`
cover `packed-contexts.c` with two deferred
lanes: Clang and checker accepted, no resource failures, and zero acceptance,
diagnostic, scalar/vector or deferred differences. This input combines builtin
calls with `sizeof`, `typeof`, a VLA bound, and chosen/unchosen selections.

The selected source passed every target-host command in
`9700x-final-qualification.log` (five commands, four at once, 13.1 seconds):

| Target-host suite | Result |
| --- | --- |
| Types, packed layouts | Passed, no failed checks |
| Checker, seed 507 | 253,545 checks, 0 failures |
| Driver, real executable | 20,986 checks, 0 failures |
| Deferred source readers | 56 fixtures, 891 checks, 0 failures |
| Packed-local corpus, four lanes | 1 file, 3 bodies, zero acceptance/diagnostic/path/deferred differences |

The target's Clang 23.1.1 oracle does not reproduce the four local
Clang 23.1.4 effect-order failures.

## Cost screen

Build `generate.c` with a C17 compiler and run `generate DIRECTORY 2048`.
It produces five original inputs of 2,048 functions:

1. `plain.c`: ordinary member addresses, without any packed attribute.
2. `packed-suppressed.c`: packed member addresses converted to `void *`.
3. `packed-warning.c`: packed member addresses retaining their `int *` type.
4. `packed-locals.c`: an anonymous packed static local in every function.
5. `packed-unused.c`: an unused packed tag plus ordinary `&local` expressions,
   with zero packed-member warnings. This is the adversarial review case.

Use `-w -fsyntax-only -std=gnu17` for each: the screen includes witness
collection and consuming-context analysis while excluding terminal output.
The local-record input also exercises the cached tag/source/typedef handoff;
formatting a diagnostic must not scan every preceding token for each address.
The zero-match input exercises exact witness sizing and delayed context
allocation: unrelated addresses must not reserve retained diagnostic records.
The frozen SQLite source is an additional real-source check, with its frozen
system headers. Accepted-input status must be zero before timings are used.

`ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh BASE HEAD --
time-runs --runs 7 --warmups 2 --list ...` rotates the two builds across three
process rounds. `time-runs` rotates inputs within each round and retains every
process status, wall time, CPU time, peak RSS and page-fault count. It checks
status stability, not source acceptance; both properties are inspected here.

`9700x-final-ab.log` contains all six successful timing blocks. Every one of
the **252 measured invocations exited 0**; all 36 per-input summaries contain
seven samples, and no timing block reports a failed process. `summary.tsv`
retains the wall-median ranges and measured RSS ranges as well as these values.

Wall values below are the median of the three per-round seven-sample medians.
RSS values are the median of the 21 measured process peaks. Positive
differences mean more time or memory. These are descriptive results from
three rotating rounds, not confidence intervals or improvement claims.

| Input | Baseline ms | Candidate ms | Wall difference | Baseline peak KB | Candidate peak KB | RSS difference |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| plain | 6.200 | 6.046 | -2.5% | 66,640 | 67,620 | +1.5% |
| packed-suppressed | 5.722 | 5.797 | +1.3% | 66,628 | 67,596 | +1.5% |
| packed-warning | 5.691 | 5.765 | +1.3% | 66,644 | 67,632 | +1.5% |
| packed-locals | 9.709 | 10.644 | +9.6% | 102,268 | 107,932 | +5.5% |
| packed-unused | 5.533 | 5.481 | -0.9% | 62,564 | 63,520 | +1.5% |
| SQLite | 145.859 | 145.775 | -0.1% | 596,512 | 597,256 | +0.1% |

The adversarial zero-match case has no diagnostic arena allocation, but its
whole-process peak RSS still rises by 956 KB (1.5%). Its measured ranges are
62,488–62,604 KB on the reference and 63,352–63,544 KB on the candidate.
The plain control has a similar 980 KB (1.5%) median increase. This screen
does not separate code-page placement and other fixed process costs, and
does not claim zero process overhead. The zero-capacity arena test directly
checks the absence of record/context allocation for unrelated addresses.

The anonymous-local case exposes a real feature cost: preparing 2,048
anonymous diagnostic names, source history and conversion witnesses costs
9.6% wall time and 5.5% peak RSS in this input, even with terminal output
disabled. The small plain/SQLite timing differences cannot establish an
improvement; executable placement remains a limitation. These measurements
do not establish native-code performance or full compiler/corpus acceptance.

The initial `pilot-ab-rejected-arguments.log` is incomplete and **not a valid
SQLite measurement**: its fourth input used `--no-default-config`, which the
production driver refuses before checking source. That pilot was stopped and
is excluded from all conclusions.

This is a bounded feature-cost screen, not a performance improvement claim,
a full-compilation benchmark, or an acceptance result for every C construct.

## Provenance

The generator, integration fixture and differential source probes are original
project material under Apache-2.0 WITH LLVM-exception. Clang runs externally;
LLVM's `SemaChecking.cpp`, `SemaExpr.cpp` and `AST/Expr.cpp` at `llvmorg-23.1.3` were behavior
references. No LLVM implementation or external corpus source is imported.
SQLite and frozen system headers remain external runtime inputs.

## Current-main integration, 2026-10-27

Compiler head `bdcfc89b95805dfbc049b2911837f41ab61c1d92` integrates main
`2bc55bfd` and preserves both the packed-member warning and the newly landed
loop-hint diagnostics. The two packed-warning implementation files are
byte-identical to `4fa50ac2`; two additional original Clang probes check warning
retention and conversion suppression inside a rejected annotated loop.
The packed-specific differential set now has **104 cases**.

The immutable integration source archive (`git archive HEAD build.sh src tests`)
has SHA-256 `c67f5edcce378151444de0531f0f7148caec91a64fe6f42c47a3d68bb42eb94d`.
Its source tree is `e925888d4740d9f96393e22a30fcbc32d3376e96`, its build-script
blob is `9909122edfe1459305d8dc0efabd49805939f025`, and its tests tree is
`3cd54ce65e008b233b57380837afb2e070e14c3f`. Binary/toolchain identity is in
`integration-bdcfc89b-identities.txt`; no source directory was overlaid.

`integration-bdcfc89b-9700x.log` records all five suites passing in 13.5 seconds:

| Integration suite | Result |
| --- | --- |
| Types, packed layouts | Passed, no failed checks |
| Checker, seed 507 | 254,584 checks, 0 failures |
| Driver, real executable | 21,559 checks, 0 failures |
| Deferred source readers | 61 fixtures, 960 checks, 0 failures |
| Packed-local corpus, four lanes | 1 file, 3 bodies, zero differences |

The corresponding local build/driver logs also pass. The local broad checker
is 254,584 checks with the same four recorded Clang 23.1.4 fpclassify oracle
failures and the same values, with no additional failures.

The cost table above remains a measurement of **4fa50ac2**, before the
independent changes newly landed on main. The whole integrated compiler's
performance was not separately remeasured; those numbers are not an
exact-head performance claim for this integration.
