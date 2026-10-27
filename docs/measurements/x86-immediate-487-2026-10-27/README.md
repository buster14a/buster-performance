# X86 immediate diagnostic qualification, 2026-10-27

Evidence for [Buster #487](https://github.com/buster14a/buster/issues/487) and
[source PR #561](https://github.com/buster14a/buster/pull/561).

The compound-literal correction and subsequent main merge are qualified in
the [latest-main record](review-latest/README.md). The later tests-only
[`-w` review follow-up](review-quiet/README.md) adds explicit command-line
suppression coverage without changing the diagnostic implementation.
The [first review-fix record](review-fe4daf9b/README.md) retains its complete
five-input screen. The results below describe the initial `59a7aca5` source.

Reachable out-of-range x86 builtin immediates become default-error warning
events in the driver. A checked control/expression walk resolves dead and
unevaluated calls before lowering. Prototype ICE, rounding, SAE and scale
constraints retain their hard-error behavior. This is a correctness change;
the measurements below screen its cost and establish no performance gain.

## Identities and method

- Baseline: `ad408cf2ec956860833db81e4333c5faa78390fe`.
- Fix: `59a7aca598299dff2754a38b34e9efcfc5382f27`.
- Main advanced to `78ec3f8a8716cd0a8427caa621acc13c33847135` during qualification.
  That integration changes CI admission, tools and documentation only;
  `git diff --exit-code ad408cf2 78ec3f8a -- src build.sh` passes. The compiler
  and build sources of the measured baseline therefore also describe that main.
- AMD Ryzen 7 9700X, Clang 23.1.1, Linux/x86-64. Optimized `./build.sh` builds
  with `BUSTER_DEBUG_INFO=0`: `-O3 -march=native -Isrc -fwrapv -funsigned-char
  -fno-strict-aliasing -Wall -Werror` and the build's existing Wild linker.
- Every build/test/measurement command took the existing shared 9700X lock
  separately. Timings ran on CPU 2, with its governor and EPP both performance.
  `logs/receipt.txt` records CPU/kernel/tool identities and binary/input hashes.
- Baseline binary SHA-256:
  `51a8f4c1f801af538b157857d37374e5b13070bcf6ae16b4a01b7b0452fe8f12`.
  Fix binary SHA-256:
  `b09b8d5a5153b96ce9404703b7351a7fba9f54328c6480edc8af78128be24d0a`.
- `head-source.sha256` and `logs/source-check.log` verify every tracked compiler
  source and `build.sh` in the remote fix checkout against the source commit.
  `source.patch` and `source-tree.txt` retain the changed source identities.
- `measure.sh` runs the fix's existing `time-runs` tool: 2 warmups, 11 measured
  rounds, 3 fresh executable copies per build, rotating order. `base-a` and
  `base-b` are the same baseline binary, an A/A control. Each build/workload has
  33 measured processes. All process statuses are zero, with no failed processes.
  Copies vary the executable path; these are not a sweep of binary code placements.

The small input has one ordinary arithmetic function. `fixtures.c` also
generates 1,000 functions with valid x86 immediates and 1,000 with out-of-range
calls inside `if (0)`. Both compilers must accept all three files. SQLite is
the frozen preprocessor-391e729af658 corpus's amalgamation, SHA-256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`;
its system include paths and exact driver arguments are retained in the logs.
No external corpus or header implementation is incorporated here.

## Whole-driver cost screen

Medians of the 33 measured processes, using the ordinary vector-selected
`-fsyntax-only` driver. Changes/ranges below are the existing tool's unrounded
calculations; displayed medians are rounded to three decimal places.

| Input | Baseline wall, ms | Fix wall, ms | Fix/base-a | Base-b/base-a A/A | Fix/base-a over copies |
| --- | ---: | ---: | ---: | ---: | ---: |
| Small | 0.797 | 0.796 | -0.07% | -1.74% | -2.20% to +0.43% |
| 1,000 valid builtin calls | 6.174 | 6.251 | +1.25% | +0.48% | -0.11% to +2.40% |
| 1,000 dead out-of-range calls | 6.060 | 6.264 | +3.37% | +0.57% | +2.46% to +4.43% |
| Frozen SQLite | 142.705 | 142.761 | +0.04% | +0.01% | -0.31% to +0.41% |

The SQLite wall-time spread includes zero change; these samples establish no
whole-driver speed change. The valid-builtin timing also overlaps zero across
copies. The dead-call stress case exposes an additional 0.204 ms of median
whole-driver work for resolving the 1,000 pending events.

| Input | Baseline instructions | Fix instructions | Baseline peak RSS range, KiB | Fix peak RSS range, KiB |
| --- | ---: | ---: | ---: | ---: |
| Small | 1,463,807 | 1,464,641 | 15,968–16,196 | 16,072–16,272 |
| 1,000 valid builtin calls | 67,721,728 | 67,831,573 | 66,320–66,436 | 66,304–66,500 |
| 1,000 dead out-of-range calls | 67,764,113 | 68,455,451 | 66,312–66,436 | 68,364–68,556 |
| Frozen SQLite | 1,584,032,356 | 1,584,836,911 | 596,048–596,236 | 596,168–596,288 |

The dead-call input allocates diagnostic reachability scratch and shows about
2 MiB more peak resident memory. No reachability worklist is allocated without
a deferred range event. Its dependent-edge traversal is scalar and cold; the
existing checker kernels and their scalar/vector twins remain the production
paths. This screen does not prove an optimal traversal or compare a new SIMD
reachability implementation. It does not measure generated-program speed,
multicore scaling or an isolated after-scalar SIMD state.

## Correctness qualification

On the locked 9700X, with the exact fix source and binary above:

| Command | Result |
| --- | --- |
| `./build.sh` with `BUSTER_DEBUG_INFO=0` | 41 sources, warnings as errors, passed |
| `./build/compiler test-checker --seed 133` | 256,160 checks, 0 failures |
| `./build/compiler test-checker-driver --executable ./build/compiler` | 21,566 checks, 0 failures |
| `./build/compiler test-check-builtins-x86` | 5,607 checks, 0 failures |
| `./build/compiler test-checker-deferred` | 61 fixtures, 960 checks, 576 merged, 6,252 bodies read apart, 0 failures |
| `./build.sh check-call-graph` | 41 units, 23,464 functions, 140,223 calls, 0 unallowed cycles, 3 allowed cycles |

`test-checker` includes 39 isolated differential source fixtures through both
production driver schedules. They compare status, severity, complete range
messages and presumed line/column locations with external Clang. They cover the
issue's 512-bit example, negative and valid immediates, live/dead branches,
returns, goto, loops, break/continue, switch dispatch/fallthrough, short-circuit
and conditional expressions, sizeof/alignof, initializer and call roots,
statement expressions, pragma warning/ignore/push/pop, and hard ICE errors in
dead or unevaluated source. Scratch-exhaustion cases preserve deferred events
and the caller's scratch prefix; resolved/in-range events need no second walk.

Local Clang 23.1.4 builds pass. The complete local checker run reports the four
known fpclassify executable-oracle disagreements; its x86 fixtures pass. The
9700X's Clang 23.1.1 passes the complete suite. Local logs retain these failures
without relabeling that run successful. Direct local driver probes also verify
the issue example errors by default and is silent with `-w`.

Additional probes found existing source-adapter gaps outside these fixtures:
an intrinsic in `typeof` is refused, and Clang diagnoses an out-of-range builtin
in an unselected `__builtin_choose_expr` arm that the checker accepts.
The latter is tracked in [#562](https://github.com/buster14a/buster/issues/562).
These results do not claim complete GNU intrinsic-query diagnostic coverage,
sanitizer/fuzzer acceptance or full compiler/source-corpus qualification.

## Reproduction

Use the two source revisions and the same frozen corpus on the approved host.
Build each through `exclusive.sh` separately. The generator and summarizer
were built locally for this record. If regenerating on the 9700X, take its
shared lock for each command; the measurement script takes it per workload:

```sh
~/buster-fast-bench/exclusive.sh cc -std=c17 -O2 -Wall -Wextra -Werror fixtures.c -o fixtures
~/buster-fast-bench/exclusive.sh ./fixtures /home/david/buster-fast-bench/issue-487
bash measure.sh /home/david/buster-fast-bench/issue-487
~/buster-fast-bench/exclusive.sh cc -std=c17 -O2 -Wall -Wextra -Werror summarize.c -o summarize
./summarize logs/small-times.log logs/valid-times.log logs/dead-times.log logs/sqlite-times.log > summary.tsv
```

The measurement directory must contain `base/build/compiler` and
`head/build/compiler`. The last command is a read-only analysis of copied logs;
`summarize.c` independently verifies 33 successful process rows per build and
reports instruction/cycle medians and resident-memory ranges. Raw process
samples, build/test logs and source receipts are in `logs/`.
