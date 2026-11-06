# Multicore roadmap acceptance (#149)

This directory contains the reproducible campaign for
[Buster #149](https://github.com/buster14a/buster/issues/149). **It does not yet
contain a passing 9700X measurement record.** The hosted workflow qualifies the
tools with original stand-in fixtures; those runs are not compiler performance
evidence.

The implementation was audited against compiler commit
`d9442df0dde83b9701b6ff7487f8916641736a84`. The compiler's per-function and
multi-file machinery and its output-determinism tests already exist. This
campaign measures that machinery without replacing its scheduler or adding
instrumentation to its hot paths.

## Workloads

All three workloads run the real source driver with `-c`. A many-file sample is
one compiler process receiving every selected translation unit. Object output
and process startup/exit are included in whole-process time. Linking is covered
by the compiler's existing multicore correctness tests; it is not part of these
compile-only curves.

| Case | Inputs | Required outputs |
| --- | --- | --- |
| `sqlite` | Frozen SQLite 3.53.2 amalgamation and frozen system headers | `sqlite3.o` |
| `synth` | The pinned compiler's generator, seed 149, 512 files of 200 functions | All 512 objects |
| `musl` | Frozen Zig 0.14.1 musl 1.2.5 tree, with x86-64 replacements selected | All 1,309 selected C objects |

The musl case covers the ordinary C source cohort. Architecture assembly files
replace their generic C implementations but are not themselves compiled in this
C-only curve. CRT and dynamic-loader configurations are separate workloads and
are not silently included under incompatible ordinary-library flags. The
preparer records the selected sources and architecture replacements. It never
filters the inventory by whether Buster happened to produce an object.

`prepare.c` consumes the existing verified corpus from
`tools/ci/fetch-corpus.sh`; it does not download or incorporate upstream source.
The corpus identities are:

| Input | SHA-256 |
| --- | --- |
| `preprocessor-391e729af658-ci.tar.zst` | `ceb39bf938cd7a7469bbb53646c3318d0cbfdac4d37b6d05b183c4fd0b9898c2` |
| `MANIFESTS.sha256` | `391e729af6587355050881752558e790299cfe638c7dc7803bd028a8535ebcbd` |
| `sqlite/sqlite3.c` | `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d` |

The synthetic generator writes `unit_0.c` through `unit_511.c`; each includes
`stdio.h`, so its frozen header dependencies matter too. Record the generation
command, generator compiler identity and generated-file hashes. A filename/count
check alone cannot establish that the requested generator and seed were used.

## Running on Benchpress

Use an isolated task directory on the approved Ryzen 7 9700X, a clean checkout
of one explicitly selected compiler commit from `main`, and an exact reviewed
commit of this repository. Keep the same compiler executable and inputs for all
three cases. Read the compiler's `docs/commands/benchpress.md` and the host's
`~/buster-fast-bench/README-9700x.md` first.

The examples below assume these directories already contain the pinned
checkouts. Every shell command is one line. Replace the paths if the task
directory has a different name.

```sh
campaign="$HOME/buster-fast-bench/149-acceptance"
compiler_tree="$campaign/compiler"
performance_tree="$campaign/performance"
corpus="/var/lib/buster-9700x/corpora/preprocessor-391e729af658"
lock="$HOME/buster-fast-bench/exclusive.sh"
export EXCLUSIVE_OWNER="149-acceptance" EXCLUSIVE_TITLE="Multicore roadmap acceptance" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/149"
```

Build the compiler using its supported build script under the shared lock, and
retain the build command/output, actual Clang version, host target and relevant
CMake configuration. `znver5` is the host build target, independent of the
generated-code target recorded in each case's argument manifest.

```sh
cd "$compiler_tree" && BUSTER_HOST_ARCH=znver5 "$lock" ./build.sh --config Release > "$campaign/compiler-build.log" 2>&1
git -C "$compiler_tree" rev-parse HEAD > "$campaign/compiler-commit.txt"
git -C "$performance_tree" rev-parse HEAD > "$campaign/tools-commit.txt"
cp "$compiler_tree/build/compile_commands.json" "$campaign/compiler-compile-commands.json"
mkdir -p "$campaign/tools"
"$lock" clang -std=c17 -O2 -Wall -Wextra -Werror -fno-strict-aliasing "$performance_tree/docs/measurements/multicore-149/prepare.c" -o "$campaign/tools/prepare"
"$lock" clang -std=c17 -O2 -Wall -Wextra -Werror -fno-strict-aliasing "$performance_tree/docs/measurements/multicore-149/runner.c" -o "$campaign/tools/runner"
clang --version > "$campaign/tools-clang.txt"
sha256sum "$compiler_tree/build/compiler" "$campaign/tools/prepare" "$campaign/tools/runner" > "$campaign/binaries.sha256"
"$lock" "$campaign/tools/prepare" --self-test
"$lock" "$campaign/tools/runner" --self-test
"$lock" "$compiler_tree/build/compiler" test-check-units --generate "$campaign/synth" --units 512 --functions 200 --seed 149 > "$campaign/generate.log" 2>&1
"$lock" "$campaign/tools/prepare" --corpus "$corpus" --synth "$campaign/synth" --output "$campaign/cases"
```

Before collecting performance evidence, require the pinned compiler's hosted
and native correctness qualifications, including `tests/driver/multicore.c`.
Keep links to the exact revision's passing checks with the final report.

Invoke each runner **outside** an already-held lock. Its controller acquires
the shared lock separately for each compiler process by invoking its sample
helper through `exclusive.sh`. Lock acquisition is outside the timed region.
This lets waiting CI jobs take the host between samples. Do not wrap the whole
campaign in `exclusive.sh`, and do not call it from a hardware CI job that
already owns the job-hook lock.

```sh
"$campaign/tools/runner" --case "$campaign/cases/sqlite" --output "$campaign/results-sqlite" --compiler "$compiler_tree/build/compiler" --compiler-source "$compiler_tree" --lock "$lock" --runs 7 --cpus 0,1,2,3,4,5,6,7
"$campaign/tools/runner" --case "$campaign/cases/synth" --output "$campaign/results-synth" --compiler "$compiler_tree/build/compiler" --compiler-source "$compiler_tree" --lock "$lock" --runs 7 --cpus 0,1,2,3,4,5,6,7
"$campaign/tools/runner" --case "$campaign/cases/musl" --output "$campaign/results-musl" --compiler "$compiler_tree/build/compiler" --compiler-source "$compiler_tree" --lock "$lock" --runs 7 --cpus 0,1,2,3,4,5,6,7
```

The output directories must be new. Preserve a failed run's logs; fix or explain
the failure before starting a new complete case. Never discard failed files
from the musl manifest to make a curve pass.

## Measurement and correctness contract

For each case, the controller establishes a one-lane object reference, warms
each lane count, then rotates the order of counts 1 through 8 across repetitions.
The normal samples have no stage-clock instrumentation. Separate instrumented
processes retain the complete `--time-stages` reports and their own wall times;
their command-team receipts must match the requested count.

A separately labeled CPU-2-only one-lane control participates in the rotated
order too. With seven repetitions, a case contains 82 compiler processes: one
reference, nine warmups, 63 normal samples and nine stage-report processes.
The control is not an extra point in the primary 1–8 curve.

Every compile has a bounded lifetime and an individually checked exit status.
Every expected object must be freshly created, regular, nonempty, and
byte-identical to the one-lane reference. Comparisons and input hashing are
outside the timed region. A signal, timeout, failed compiler, missing or changed
object, malformed team receipt, or changed source/compiler identity fails the
case. A stable nonzero compiler exit is never a successful sample.

The raw records retain fork-to-reap wall time and `wait4` resources. These
include process creation and exit, not just the driver's stage total. The
summary reports variability alongside median speedup. Keep the individual
normal and instrumented samples; a median alone cannot show noise or drift.
The child setup immediately before `exec` (affinity verification, environment
normalization and log descriptors) is within that interval. Source verification
and warmups condition the filesystem/page cache; this is a warm-input campaign,
not a cold-storage latency experiment. Every compiler process still starts
fresh.

The compiler driver inherits the fixed CPU mask 0–7. The runner verifies that
these are eight distinct physical cores and records current topology and power
policy. **This is process affinity, not individual lane pinning**: the driver
passes no CPU list to `lane_session_run`, and workers may migrate within that
set. The command-team receipt proves team size, not worker utilization.

CPU 2 historically used the `performance` governor while other cores used a
different policy. Read the actual campaign receipts instead of copying that
historical assumption. Do not change governors, huge-page policy or idle
conditioning between lane counts. The runner's CPU-2 control is labeled
separately. Any additional idle or thermal experiment must also remain separate
from the primary curve.

## Serial share and speedup bounds

Do not calculate a generic serial fraction as `1 - lanes / total`. The
single-unit one-lane driver reports function work in `lower`, `tier0`,
`branch-sizing`, `encode` and other stages; multi-lane emission groups that work
under `lanes`. The many-unit driver groups the entire units phase under `lanes`
even for one lane.

For default single-unit `-c`, the conservative serial-stage sum is:

```text
setup + preprocess + parse + type-table + check-input + check-expressions
+ check-declarations + static-data + check-program + select + backend-setup
+ emit-setup + publish-data + object-build + object-write + release
+ lower.prepare
```

Count `lower.prepare` once; do not also count the entire `lower` stage. Omit
`lower.rest`, `code-atoms`, `debug` and `unwind` from this conservative sum,
because their rows mix function work and ordered work. For multi-unit `-c`,
the identifiable globally serial caller stages are `setup + release`.
Per-unit preprocessing and checking occur inside the parallel units phase.
Report `lanes-start` separately as startup overhead.

Divide the serial sum by its paired instrumented one-lane whole-process wall
time. This is a **serial-stage lower bound**, not proof that the rest of the
work is perfectly parallel. For a lower-bound fraction `s`, the corresponding
Amdahl-model upper bound at `N` lanes is `1 / (s + (1 - s) / N)` and its
asymptote is `1 / s`. State the assumption of unchanged work and execution cost;
frequency, caches, scheduling and memory contention can change those costs.

Keep the effective serial fraction fitted from normal-sample speedup `S_N`
separate: `(N / S_N - 1) / (N - 1)`. It includes overhead and machine effects.
Do not clamp negative values when observed speedup is superlinear.

Source-order body checking remains the production default at the audited
revision. Record that choice and link the compiler's current
`docs/function-lanes.md` decision. Any `--deferred-bodies` campaign is a
separately labeled comparison with its own references, not a replacement for
the default curve.

## Waiting policy

Retain the compiler's `lane.c` hash and build feature/target information. At the
audited revision, idle command workers and helper-board waiters use futex
sleep. Intra-round barriers try 128 pauses, then up to 1 ms of `MWAITX` (or
pauses when the build lacks that instruction), then futex sleep. Startup and
between-round parks are distinct from this bounded barrier spin.

This documents the implementation policy; it does not measure individual wait
durations or subsequent frequency changes. Context-switch counts and governor
receipts provide additional context. Any claim about observed waiting or
throttling needs a separate trace/control, outside the normal timing curve.

## Publishing the final record

Add a dated results directory here after the native run. Retain the case
manifests, source/header hashes, generator/build receipts, compiler commit and
binary hash, tool revision, exact commands, host receipts, all sample records,
stage logs and output-comparison results. Raw object files can be omitted from
Git if their reference hashes and successful complete-byte comparisons are
retained; keep the local originals until review.

The final report must show all three eight-point curves from the same compiler
and executable, output equality for every sample, observed variability,
serial-stage lower bounds/model bounds and the actual power/wait policy. Link
that immutable record from Buster's `docs/multicore-acceptance.md`. Passing tool
self-tests or a partial case does not close #149.

## Provenance

The C tools, their stand-in fixtures, this documentation and their hosted
qualification workflow are original project work under
`Apache-2.0 WITH LLVM-exception`. SQLite, musl and frozen system headers remain
external runtime inputs with their existing notices; no upstream source is
copied into this directory. Existing compiler and lane-module licenses remain
unchanged.
