# Compound-literal review and main integration

Qualification of [Buster PR #561](https://github.com/buster14a/buster/pull/561)
after addressing [the compound-literal review](https://github.com/buster14a/buster/pull/561#discussion_r4388360963).

- Review-fix source: `03cb4d6441f1e0dc73af0c08047c86846e2ac502`.
- Matched main baseline: `fe4daf9b56d666d8e418dfeca22770e87b752440`.
- Merge integration: `9fa809ff32b8dad775316333cdc4f471f44d62b6`.
- The parent directory retains the initial `59a7aca5` qualification. This
  record covers the updated source and its newer compiler baseline.

## Change and regression coverage

A reached automatic compound-literal value now follows its declaration's
initializer plan, queuing each `CHECK_INIT_VALUE` node. The same helper handles
ordinary declaration initializers. These execution edges are outside the value
leaf's operand columns. Nested literals use the existing bounded worklist;
dead and unevaluated literals contribute no roots. Invalid plan metadata leaves
events deferred and invalidates the checked program.

The merge conflict in the driver preserves both x86 range reporting and main's
`CHECK_STAGE_CHECK_PROGRAM` clock mark. The diagnostic/reporting work remains
inside that checking-stage interval.

Eight new differential fixtures cover scalar, array, record and nested live
literals, an in-range literal, and dead, sizeof and short-circuited literals.
There are now 47 isolated Clang differential cases through both production
driver schedules, checking status, severity, complete messages and location.

`negative-control.sh` runs the four live forms against the saved pre-review
compiler, the fixed compiler and external local Clang 23.1.4. All four are
accepted by the pre-review binary and rejected by the fixed binary and Clang.
The source files, outputs, statuses and local binary hashes are retained here;
`negative-control.tsv` verifies those expected statuses. This is separate from
the complete checker run and is not a claim of an isolated compiler mutation.

## Manual qualification

The exact updated source was built with the existing `./build.sh`,
`BUSTER_DEBUG_INFO=0`, Clang 23.1.1 and warnings as errors on the Ryzen 7 9700X.
Every host build/test/measurement takes the existing shared lock separately.
`qualify.list` ran through the existing test runner with a budget of four CPUs.

| Check | Result |
| --- | --- |
| Optimized build | 41 sources, passed |
| `test-checker --seed 133` | 259,364 checks, 0 failures |
| `test-checker-driver --executable ./build/compiler` | 21,585 checks, 0 failures |
| `test-check-builtins-x86` | 5,607 checks, 0 failures |
| `test-checker-deferred` | 61 fixtures, 960 checks, 0 failures |
| `./build.sh check-call-graph` | 41 units, 23,834 functions, 142,592 calls, 0 unallowed cycles, 3 allowed cycles |

The four suites pass in one bounded runner invocation (18.4 s wall time),
recorded in `logs/qualification.log`. The local optimized build also passes;
its complete checker suite has the same four known Clang 23.1.4 fpclassify
oracle disagreements, while the new x86 cases pass. The hardware Clang 23.1.1
run passes in full. The local driver and component logs are retained separately.

`head-source.sha256` and `logs/source-check.log` verify all 487 tracked compiler
source/build files on the hardware checkout against the fixed commit.
`logs/receipt.txt` records the host, compiler, CPU-2 governor/EPP and binary/input
hashes. `source.patch` is the zero-context source difference against the matched
main baseline; apply it using `git apply --unidiff-zero` if needed.

## Matched cost screen

`measure.sh` runs on locked CPU 2. It uses the existing `time-runs` tool with
two warmups and eleven measured rounds over three fresh executable copies per
build, rotating order. `base-a` and `base-b` are the same main binary, an A/A
control. The generator adds 1,000 live compound literals whose range diagnostic
is explicitly ignored, so both compilers accept the same source while the fix
must traverse their runtime initializer plans. Other inputs are small ordinary
code, 1,000 valid calls, 1,000 dead range errors, and the same frozen SQLite
corpus as the initial campaign. Copies vary executable paths; they do not sweep
binary code placements.

All five inputs have 33 successful measured processes per build. Wall-time
changes use the tool's unrounded calculations; displayed medians are rounded.

| Input | Baseline wall, ms | Fix wall, ms | Change | A/A change | Change over copies |
| --- | ---: | ---: | ---: | ---: | ---: |
| Small | 0.794 | 0.803 | +1.17% | -0.01% | +0.38% to +2.14% |
| 1,000 valid calls | 5.974 | 5.980 | +0.11% | -0.19% | -1.08% to +0.67% |
| 1,000 dead range errors | 5.965 | 6.106 | +2.35% | +0.24% | +1.00% to +3.70% |
| 1,000 live compound literals, diagnostics ignored | 6.112 | 6.356 | +3.99% | +0.09% | +2.12% to +4.44% |
| Frozen SQLite | 127.907 | 127.656 | -0.20% | -0.43% | -0.48% to +0.29% |

The SQLite and valid-call ranges include zero change. The compound-literal
stress input adds 0.244 ms of median whole-driver work while resolving 1,000
live events through their initializer plans. It reports 65,029,894 median user
instructions against 63,962,405 for main, and peak RSS of 68,776–68,900 KiB
against 66,712–66,836 KiB. `summary.tsv` records instruction/cycle medians and
memory ranges for every build/input. The A/A control and copy variation limit
what these timings establish; no SQLite performance gain is claimed.

Baseline executable SHA-256:
`330e8061b3df40a9b23806fd01f88b91dd99e584fad09f6656c7de227de9bef0`.
Fixed executable SHA-256:
`9f4fc1d06801e807219cab864c6772f36a6b60e785507a692eab8f85ec990b77`.

Use `fixtures.c` to generate the four original input files and `measure.sh`
with a directory containing `base/build/compiler` and `head/build/compiler`.
Compile the generator locally, as this campaign did, or take the shared host
lock for its build and execution on the 9700X. The parent `summarize.c` reads
the copied process logs and requires 33 successful measured rows per build and
input, excluding warmups. It reports medians and peak-memory ranges.

This screens the available syntax-only driver. It does not establish a speed
gain, optimality of the scalar exceptional walk, generated-program performance,
multicore scaling, sanitizer acceptance or full source-corpus qualification.
Full GitHub CI is a separate check from these manual runs.
