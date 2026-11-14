# Correctness validation for the bounded SSA implementation

This record accompanies [Buster PR 2666](https://github.com/buster14a/buster/pull/2666).
The final published source is commit `0e5fbf7651d51126a415228fc61ba11b31fe6883`,
tree `2a80adeaf85163fc66f776e494dd359a2cdf5a08`. The README identifies the baseline,
the earlier implementation snapshot, and how to reproduce both snapshots from
the retained patches. This file distinguishes them rather than attributing all
runs to the final commit.

The per-case final resource and integrated-test logs are concatenated verbatim,
under headings with their original filenames, in `final-runs.log`. The analogous
baseline and first-candidate resource/execution logs are in `baseline-runs.log`
and `candidate-runs.log`. The tables below name the original records; the
standalone and additional parent-validation logs are separate files.

## Final source

| Check | Result | Record |
| --- | --- | --- |
| Native standalone SSA core, O3, seed 7439, 150 generated CFGs | 9,975 checks, zero failures | `final-native-o3.log` |
| Native standalone SSA core with AddressSanitizer and UndefinedBehaviorSanitizer, seed 7439, 150 generated CFGs | 9,975 checks, zero failures | `final-native-sanitizer.log` |
| Integrated Release SSA core, default seed 134 and count 100 | 7,804 checks, zero failures | `final-test-ssa.log` |
| Integrated Release SSA IR, default configuration | 3,854 checks, zero failures | `final-test-ssa-ir.log` |
| Three small generated source families | All typed, memory-IR, promoted-IR and strict native execution comparisons pass | `final-exec.log` |
| Source scoped-loop series, 1k through 16k | Both promotion paths and verification pass; compile-only | `final-source-loops-*.log` |
| Strict native compilation: loops 8k, MAX 4k, nested MAX 200 at depth 10 | All complete; objects identical to earlier implementation | `final-loops-8000.log`, `final-max-4000.log`, `final-nested-200-10.log`, object identity record |

The full compiler uses `BUSTER_HOST_ARCH=x86-64`; a request for its vector route
uses the scalar host fallback. The standalone tests use Clang 23.1.4 with
`-march=native` on the AVX-512-capable Xeon recorded in `host.txt`, enabling
`BUSTER_HOST_VECTOR=1` and exercising the actual scalar and vector kernels.
`standalone-binary-sha256.txt` identifies the two final standalone executables.

The sanitizer run used
`ASAN_OPTIONS=detect_leaks=0:abort_on_error=1 UBSAN_OPTIONS=halt_on_error=1`.
LeakSanitizer cannot operate under this environment's ptrace restrictions.
AddressSanitizer and UndefinedBehaviorSanitizer remained enabled.

The low-level regression suite covers forced bounded and automatically selected
paths, scalar/vector equality, guarded input tails, invalid inputs, rollback,
verifier mutations, and cross-local irreducible cycles. Its fixed-scratch cases
include 65,536 blocks and 65,536 unused locals in 32 MiB; 8,192 blocks and 256
live-through locals in 16 MiB; and 2,048 independent scoped loops in 16 MiB.
These cases include independent verification. Source locations and exact
assertions are in the published `src/buster/compiler/ssa_test.c`.

For standalone reproduction, use `ssa_core_main.c` as the translation unit and
add `-Isrc/buster/compiler` while working in the Buster source checkout. Its
includes are Buster's own implementation and tests; no compiler sources are
copied into this harness. A reproduction recipe for a native sanitizer build is:

```sh
clang -O1 -g -march=native -fwrapv -funsigned-char \
  -fno-strict-aliasing -fno-omit-frame-pointer -fsanitize=address,undefined \
  -Wall -Werror -Wno-unused-function -Wno-psabi -pthread \
  -Isrc -Isrc/buster/compiler PATH_TO_EVIDENCE/ssa_core_main.c -o test-ssa-sanitized
ASAN_OPTIONS=detect_leaks=0:abort_on_error=1 UBSAN_OPTIONS=halt_on_error=1 \
  ./test-ssa-sanitized --seed 7439 --count 150
```

Use Clang 23.1.4; `-march=native` requires a suitable host for actual vector
coverage. The above is a portable-path reproduction recipe, not a claim that
its output binary must have the same hash as the recorded build.

The recorded O3 test was built from the inspected assembly itself. With paths
shortened, its commands were:

```sh
clang -O3 -g -march=native -Isrc -Isrc/buster/compiler \
  -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror \
  -Wno-unused-function -Wno-psabi -fno-stack-protector -pthread \
  -S -fverbose-asm main_current.c -o ssa-audit-cached-native.s
clang -pthread ssa-audit-cached-native.s -o ssa-audit-cached-native
./ssa-audit-cached-native --seed 7439 --count 150
```

`main_current.c` has the same executable tokens as `ssa_core_main.c`; the latter
adds only a license/provenance header for publication. Assembly inspection
confirmed that the bounded renaming path emits SIMD instructions and that the
cache adjustment removed the repeated structure-field reloads identified in the
audited loops. This is an assembly check, not a throughput measurement.

## Earlier implementation, before final pointer/count caching

The additional integration and corpus checks below used the first implementation
snapshot, `34e696ebd6667f285d720a72a4c8e1d733c92b96`. The final adjustment caches
provably stable pointers and counts in `ssa_bounded.c`; the full change is retained
as `final-cache-only.patch`. It does not change the SSA representation or algorithm.

```sh
COMPILER test-ssa --seed 7439 --count 150
COMPILER test-ssa-ir --seed 7439 --count 32
COMPILER test-ssa-source --typed --lifetimes --tier1 --generate 48 --seed 7439
COMPILER test-tier1-cfg
COMPILER test-tier1-pipeline
```

| Check | Result | Record |
| --- | --- | --- |
| Integrated core | 9,975 checks, zero failures | `candidate-integrated-core.log` |
| Integrated IR | 7,214 checks, zero failures | `candidate-ir.log` |
| Generated source execution | 48 programs, 288 functions, 1,391,920 IR instructions; all comparisons pass, no Tier 0 fallback | `candidate-generated-source.log` |
| Tier 1 CFG | 109,519 checks, zero failures | `candidate-cfg.log` |
| Tier 1 pipeline | 7,323 checks, two subprocess-reaping fixture failures, reproduced on untouched baseline | `candidate-pipeline.log`, `baseline-pipeline.log` |
| SQLite SSA promotion and verification | 2,602 functions, 608,559 instructions, 10,007 phis per path; zero failures | `candidate-sqlite.log` |

The pipeline failures are precisely `private subreaper collects the command,
child and detached grandchild` and `setsid grandchild is also killed and reaped`.
The baseline and candidate logs contain the same failures and totals. The other
checks, including 2,176 native results, complete. This is not recorded as a clean
pipeline pass, nor as a new SSA regression.

SQLite was an external runtime input already present in the workspace. It is
not incorporated into this evidence or the compiler changes. The tested input
is SQLite 3.53.2, source ID
`2026-06-03 19:12:13 d6e03d8c777cfa2d35e3b60d8ec3e0187f3e9f99d8e2ee9cac695fd6fcdf1a24`,
with file SHA-256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`.
The completed command supplied the installed compiler and system include paths:

```sh
COMPILER test-ssa-source --lifetimes \
  -isystem LLVM_23_1_4/lib/clang/23/include \
  -isystem /usr/include/x86_64-linux-gnu -isystem /usr/include sqlite3.c
```

An initial attempt without those include paths stopped at missing `stdarg.h`.
The retained `candidate-sqlite.log` is the successful run with the include paths.
SQLite was not executed or passed through native allocation in this check.

## Limits and provenance

These are cloud correctness and resource diagnostics, not approved 9700X timing
measurements. No throughput improvement is claimed. Each resource case is a
single run; the RSS guard, incomplete cases, and the remaining whole-process
allocator growth are explained in the README.

The generator, runner, standalone entry point, report, and new compiler changes
are original work for this task. The baseline/compiler patch contains only
changes to the project's own sources. No third-party implementation or corpus
source is incorporated. The compiler PR's DCO audit and whitespace check passed.
Hosted CI has its own evolving status in the linked PR and is not represented
by the local test logs.

Agent session: `6af760d4-f694-8191-9722-cf9411924056` (OpenAI session ID; no share URL
is exposed). Contributing tasks: `/root`, `/root/ssa_audit`, `/root/ssa_verifier`,
`/root/ssa_validation`. Model: OpenAI / GPT-6 Astra Pro.
