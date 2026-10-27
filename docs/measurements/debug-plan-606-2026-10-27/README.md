# Reusing DWARF preparation in the C producer (#606)

Source baseline: `buster14a/buster` main at
`92c025e71856d13eb34247477c5294d2cead139e`.
Changed compiler: `7a11079786fd55d46a55a59d1e6812b17eab2877`.

The C producer now validates and measures its unchanged DWARF input once,
retains a 160-byte stack plan, allocates the sections, and writes once. The
plan copies the unit descriptor, bases, sizes and scalar/vector choice. It
borrows the existing input slices and allocates no row or heap storage.
`debug_write` remains the defensive validate/measure/write entry point.

## Complete production compiles

All 144 measured fresh compiles, and 24 warm-ups, exit successfully. Every
round's complete object pairs are byte-identical, with and without `-g`,
including all DWARF sections and relocations. `measurement-identities.txt`
records their hashes and the frozen input identities.

Separate medians of 12 processes per version; percentages are medians of
matched head/base ratios, so they can differ from ratios of the displayed
time medians:

| Workload, `-g -c` | Base wall ms | Head wall ms | Paired change (observed range) | Median peak RSS KiB, base → head |
| --- | ---: | ---: | ---: | ---: |
| SQLite | 157.284 | 157.972 | +0.392% (−0.499% to +1.544%) | 524,826 → 524,854 |
| 32 long functions | 98.417 | 95.934 | −2.490% (−4.456% to −1.709%) | 500,454 → 500,446 |
| 16,384 small functions | 149.927 | 148.518 | −2.032% (−3.469% to +1.478%) | 593,912 → 593,810 |

The corresponding **no-debug controls** move by +0.680%, −2.211% and −2.031%.
SQLite is slightly slower in this production placement. The generated cases
improve similarly without debug information. **This comparison does not
establish a general complete-compile speedup attributable to the plan.** It
uses one code placement per source revision, and is not a multi-placement
campaign. RSS is essentially unchanged; full ranges are in
`production-summary.txt`. No result is discarded for its timing.

## Correctness qualification

On the approved 9700X, each command under its own shared-lock hold:

- Both full production builds pass, 41 translation units each.
- `test-debug --cross-check` passes the independent line decoder, planned
  writes, protected tails and refusal checks, plus GDB and perf consumers
  through GNU ld, the native writer, and GNU ld/lld from Buster objects, for
  one and two DWARF units.
- `test-check-debug --cross-check`: 2,534 checks, zero failures, including
  actual C debug executables and objects, debugger stepping and scalar/vector
  identity.
- `test-x86-encoder` passes all modes and scalar/vector comparisons.
- `./build.sh check-call-graph`: 41 translation units, 23,961 functions,
  143,409 calls, zero prohibited cycles, three existing allowed cycles.

Focused standalone tests also pass locally with Clang 23.1.4 and ASan/UBSan
at `-O1`, and with the production semantic flags at `-O3`. The new tests cover
all row tails through 129, empty units, unchanged failed plans, DWARF32 base
limits, every missing/short section and address column, base changes, exact
capacities at protected pages and retrying a plan. Four independent fault
variants are caught: omitting the base check, omitting address capacity checks,
writing fields before capacity preflight, and retaining incorrect sizes.
The optimized run and mutation logs are archived alongside the reproduction
harness. This is bounded debug-emitter qualification, not a new whole-language
or source-corpus acceptance claim.

## Method

The approved physical Ryzen 7 9700X, Clang 23.1.1. Every build, test and
measurement takes `~/buster-fast-bench/exclusive.sh` separately, with the
issue's owner/title/link. Measurements use CPU 2; its governor and EPP are
recorded in `host.txt`. No host settings are changed.

Both production executables use the unchanged `build.sh`, with
`BUSTER_DEBUG_INFO=0`: `-O3 -march=native -Isrc -fwrapv -funsigned-char
-fno-strict-aliasing -Wall -Werror`. Their bootstrap executable's own debug
information is omitted equally. The `-g` being measured is Buster's C option.

`compile_benchmark.c` uses `compile_run.c` to fork/exec each complete command
and wait with `wait4`. The wall interval includes fork/exec, initialization,
input processing, emission, object output, cleanup and waiting. It records
peak resident memory, user/system time, faults and exit status for every
fresh process. It does not subtract a launch floor. The parent is pinned to
CPU 2 and each child inherits that affinity; `--lanes 1` fixes the worker count.
The recorded launcher was built once on the local 7940HS with Clang 23.1.4,
`-O2 -Wall -Werror`, and glibc 2.44, then copied to the 9700X and reused for
both compiler versions. `launcher-build.txt` records its effective driver
command and binary hash. Both production compilers were built on the 9700X
with Clang 23.1.1. The launcher's work is common measurement overhead.

One run starts two warm-up rounds (negative round numbers), followed by 12
measured rounds. Each round runs baseline `-c`, baseline `-g -c`, changed `-c`
and changed `-g -c`, rotating the starting position through all four. Input
paths and working directory are common, output path lengths match. File
caches are warm. Every round compares both pairs of complete object files,
byte for byte, and fails on any difference or nonzero child status. Separate
stage-clock runs use `--time-stages` and are reported separately from the
uninstrumented production comparisons.

Workloads:

- SQLite 3.53.2, frozen amalgamation SHA-256
  `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`,
  compiled with `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0
  -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`, as the existing speedtest1
  compile experiment. The external SQLite source is not redistributed here.
- `generate 32 2048`: 32 functions with 2,048 unsigned assignment statements
  on distinct source lines per function.
- `generate 16384 4`: 16,384 small externally visible functions with four
  statements each. The generator is original project material.

`summarize.c` excludes negative warm-up rounds, reports separate medians of
baseline and changed process time and RSS, and the median and observed range
of matched changed/baseline time ratios. These observed ranges are not
confidence intervals. The no-debug runs are controls for compiler code
placement and unrelated work.

## Traversal attribution

The two `profile-*.patch` files apply to the changed source (`patch -p2` from
the source root). This separate measurement build adds timing and row/call
counters around `debug_validate`, sizing `debug_sections`, and writing
`debug_sections`. It times `check_debug_build` as a whole too. Its residual
includes source-line mapping, retained-row construction, allocations and
descriptor work; those costs are not assigned to duplicate DWARF scans.

`BUSTER_606_COMPARE=1` tells the benchmark to run both variants from this
one instrumented executable. Its baseline-labelled children receive
`BUSTER_606_OLD=1`, restoring the former two-call C integration; changed-labelled
children leave it unset and use the plan. The former-flow control uses the
refactored defensive wrapper, so it is attribution of duplicate traversals,
not a substitute for comparing the two production source revisions. The
environment entry also differs between those children. Counters and timing
are absent from the submitted compiler.

The `profile-606` columns are: flow, functions, retained rows, raw rows,
whole-build nanoseconds, then calls/rows/nanoseconds for validation, sizing,
and writing. Stage logs separately report subsequent `object-build` and
`object-write` time. Instrumentation overhead stays in these diagnostic runs.

Every measured `-g` attribution process verifies **two validations, two sizing
traversals and one write before**, and **one validation, one sizing traversal
and one write with the plan**. `profile_report.c` checks calls and actual rows
for each traversal and requires identical function/raw/retained row counts
across the two flows:

| Workload | Functions | Raw source rows | Retained rows per traversal |
| --- | ---: | ---: | ---: |
| SQLite | 2,668 | 256,335 | 57,207 |
| Long functions | 32 | 262,208 | 65,600 |
| Small functions | 16,384 | 294,912 | 98,304 |

Thus validation and sizing each visit half as many retained rows; writing
visits the same rows. The source-to-line mapping and raw-row construction are
separate costs. Four measured processes per flow, medians in milliseconds:

| Workload | Whole `check_debug_build`, old → plan | Validation | Sizing | Writing |
| --- | ---: | ---: | ---: | ---: |
| SQLite | 6.445 → 6.315 | 0.093 → 0.053 | 0.164 → 0.085 | 0.131 → 0.131 |
| Long functions | 2.577 → 2.539 | 0.049 → 0.024 | 0.079 → 0.040 | 0.073 → 0.073 |
| Small functions | 4.828 → 4.587 | 0.116 → 0.059 | 0.377 → 0.188 | 0.416 → 0.419 |

The residual (mapping, retained-row construction, allocations and descriptor
work) is 6.060 → 6.047 ms for SQLite, 2.376 → 2.401 ms for long functions, and
3.917 → 3.913 ms for small functions. The eliminated scans save only about
0.04–0.24 ms in this debug-building boundary, much less than the complete
process's timing spread and code-placement changes above.

Subsequent object-building/output medians are recorded separately in
`profile-summary.txt`: SQLite 0.456/0.533 → 0.457/0.519 ms, long functions
0.034/0.199 → 0.033/0.202 ms, and small functions 0.439/0.771 → 0.442/0.769 ms.
All instrumented objects also match the corresponding production objects
byte for byte (`profile-objects.sha256`).

The one-executable complete-process ratios still have observed ranges that
cross parity for every `-g` workload; see `profile-process-summary.txt`.
This diagnostic run establishes removed traversals and their local cost,
not a general end-to-end throughput improvement. No retained structure grows
with the input; the plan is 160 stack bytes and adds no heap allocation.

## Reproduction

Arrange the frozen source trees as `base/` and `head/`, and the instrumented
copy as `prof/`, under one directory on the approved host. Copy the helpers
there; create `inputs/`, with `sqlite.c` as the frozen amalgamation above.
Build each compiler under its own lock hold. Under another lock hold:

```sh
clang -O2 -Wall -Werror compile_run.c -o compile_run
clang -O2 -Wall -Werror compile_benchmark.c -o compile_benchmark
clang -O2 -Wall -Werror generate.c -o generate
./generate 32 2048 > inputs/lines.c
./generate 16384 4 > inputs/small.c
```

For each workload (`sqlite`, `lines`, `small`), take one separate lock hold
for `taskset -c 2 ./compile_benchmark WORKLOAD 12 no`, saving its TSV stdout.
For stage clocks, use `WORKLOAD 3 yes` in a separate run. For attribution,
use `env BUSTER_606_COMPARE=1 taskset -c 2 ./compile_benchmark WORKLOAD 4 yes`.
No lock is held while waiting between these runs.

The standalone `plan_sanitize.c` uses the unit-test prefix in
`debug_tests.inc`, extracted from the changed repository's `debug_test.c`
from `debug_test_leb` through the function before `debug_test_write_file`,
plus `BUSTER_DEBUG_TEST_BYTES`. In a scratch directory containing a `buster`
symlink to the changed source, compile it with `-O1 -g -march=native -fwrapv
-funsigned-char -fno-strict-aliasing -Wall -Werror
-fsanitize=address,undefined`. `mutate.sh` changes four properties independently
and requires each modified binary to fail. The recorded optimized standalone
run uses `-O3` with the same semantic flags and no sanitizers.

## Provenance and log handling

Implementation, workload generator, measurement helpers and instrumentation
are original repository work under Apache-2.0 WITH LLVM-exception. The test
prefix is extracted from the changed compiler revision above; it incorporates
no external test implementation. SQLite is an external runtime input, pinned
by hash and not copied into this evidence. Clang, GDB, GNU binutils,
llvm-dwarfdump and perf run externally as compilers or consumers.

Shared-lock diagnostics are not published: they can contain other sessions'
links and commands. Test and measurement logs are captured inside the locked
command; outer lock output is kept separate. Build summaries retain only the
build script's own `build.sh:` lines. Generated objects and executables are
not committed; their hashes and byte comparisons supply artifact identities.
