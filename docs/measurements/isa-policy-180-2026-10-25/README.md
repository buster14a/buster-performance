# Generated ISA policy #180: October 25, 2026

Qualification record for [Buster PR #421](https://github.com/buster14a/buster/pull/421).
Work is in progress; the final result tables and receipts are added after execution.

## Independent scope and executed checks

The six `-march` profiles, CPUID/XCR0 resolver, target-sensitive predefines,
eleven bounded builtin queries, tuning separation, vector eligibility producer
and assembler guard already existed on main. This PR verifies those interfaces
and extends classification to the current selectors; it does not replace their
owners' completed work. There are 1,611 classified canonical forms out of 8,352;
6,741 remain explicitly unavailable even with every feature bit set.

The source change is limited to `x86_target_forms.c`, policy/selection test files,
the existing target test command, its three-line backend test include in
`main.c`, and `docs/x86-target.md`. No Tier0, Tier1 or preprocessor implementation
is edited. The existing Tier1 interface already consumes the shared eligibility
table. Tier0's production target-validation guard remains the explicit
[#136/#133 handoff](https://github.com/buster14a/buster/issues/136#issuecomment-6395663929);
[#423's owner](https://github.com/buster14a/buster/pull/423#issuecomment-6396342128)
has the new x87/FISTTP classification details. The
[#424 module-home integration note](https://github.com/buster14a/buster/pull/424#issuecomment-6396848156)
identifies the backend-only test entry point. Full builtin lowering (#148),
function target attributes (#147) and full c-testsuite/SQLite generation
acceptance (#145/#146) remain outside this claim. Issue #180 stays open.

At the frozen candidate, the manual optimized and full ASan/UBSan
`test-x86-target` commands both pass. The optimized build takes 40.3 seconds;
the fully instrumented build takes 74.3 seconds. The required checks include:

| Check | Executed result |
| --- | --- |
| CPUID/XCR0 and native feature detection | Pass; native mask `0x1fffffffffffffff` on the actual 9700X |
| Raw form values | All 65,536 values at six profiles; 7,872 admitted random records |
| Scalar/vector eligibility matrix | 431 feature configurations over every row; first-failure negatives at six profiles |
| Independent minimum FMA features | 396 forms, 1,272 subset checks |
| Feature macros | 708 checks against installed Clang/GCC; recorded GCC exceptions |
| Complete Clang preambles | Zero differences across 26 option sets |
| Builtin queries, option order, invalid options, tuning | Pass |
| Tier0 at each baseline/v3/v4 profile | 1,951 compiled templates; 96 functions / 26,448 records; exact twins; zero depth refusals |
| Tier1 at each baseline/v3/v4 profile | 179,458 selection and 179,701 native-emission checks; both covers and allocation paths |
| Native SSE/VEX/EVEX kernels | 40/40/41 bytes, exact twin encoders, actual execution, lower-profile rejection before emission |
| GNU as architecture differential | 17,577 exact comparisons; 144 explicitly reported external-oracle coverage gaps |
| Existing focused compiler suites | Encoder, semantics, assembler, Tier0 and Tier1 pipeline: all five pass in 7.9 seconds |
| ELF auditor self-tests | Baseline/VEX/EVEX positives, ISA negatives, separated sections and malformed bounds pass |

These are manual 9700X checks, not workspace-host tests or hosted CI results.
Workspace checks are limited to source review, Git/source identities and
`git diff --check`. Hosted CI and performance receipts are recorded separately.

## Frozen sources and machine

- Initial current-main baseline: `19764052487c941cb88e8de391471daeffe39f05`.
- Implementation branch point: `1789f659332c2814ebfce5a782e3c4c3000a8956`.
- Main when the PR opened: `cefcb28d0457755f5ffea20e7ca80e782327ae19`.
- Both later main revisions have identical `src/` and `build.sh` to the initial
  baseline (`git diff --exit-code BASE MAIN -- src build.sh`). Their changes
  affect separate performance tooling and documentation.
- Frozen current-main baseline: `5863eeda331dacaa1371e1fe9ca1456e9d0039ca`,
  including #412's deferred preprocessor history. This landed during the campaign;
  the earlier baseline's pending performance runs were stopped before measuring.
- Candidate: `30e7bbc860056779b0e9fa3f426565e1bc010ec4`, tree
  `34b6f27af2d90b04293580e1321706b02a7097ce`. Its merge of current main is
  `e0b558f18491c40c950d74f12223a407e1c2117c`; subsequent commits correct a
  documentation count and calibrate the external assembler oracle's input,
  architectural-refusal diagnostics and GAS CPU-feature taxonomy. The final
  revision explicitly aligns the requirement array to 64 bytes, avoiding split
  cache-line loads as the surrounding compiler image changes.
- [Current baseline source/build input hashes](current-base-source-sha256.txt)
  and [candidate hashes](release-head-source-sha256.txt) identify the manual
  checkouts. The other source manifests and initial
  binary identities belong to their named development builds, not final
  qualification. The current-base/release-head pair is the final whole-compiler
  comparison; qualified-head is the pre-alignment `2004c727` development build.
- Actual machine: AMD Ryzen 7 9700X, Linux `6.18.50-2-lts`, Clang 23.1.1,
  GCC 16.2.1 (20260810), GNU Binutils 2.47. See the raw identity receipt.

Every build, test, benchmark and profiling command runs on `benchpress` through
`~/buster-fast-bench/exclusive.sh`, with an issue/PR title and link. The lock is
released per run, including each `ab` child, and existing CI/reservations are
preserved. Measurements pin CPU 2. No laptop or cloud VM build/test/performance
result is substituted for target evidence.

## Original C harnesses

- `profile-compiler.c` injects one explicit `-march` into c-testsuite's compiler
  invocation. `ISA180_COMPILER` names the absolute compiler executable;
  `ISA180_PROFILE` is `x86-64`, `x86-64-v3`, or `x86-64-v4`. All other arguments
  are passed directly, without a shell.
- `runtime.c` is a frozen, defined unsigned-arithmetic generated program. Its
  result is compared across profiles/revisions and with external Clang. It is
  a bounded synthetic runtime observation, not SQLite or broad program quality.
- `policy-instructions.c` is compiled unchanged against each checkout's source.
  It checks scalar/vector equality and measures retired user instructions and
  elapsed nanoseconds over 21 rotating passes of 10,000 complete table builds.
  Missing/multiplexed counters fail. The repository benchmark supplies separate
  cycles and sustained/after-lighter-work measurements; no external `perf stat`
  is nested around its hardware counters.
- `oracle-fixture.c` isolates the all-form GNU as syntax control, avoiding full
  compiler rebuilds while checking the fixture's canonical operands.
- `oracle-matrix.c` isolates the exact repository architecture-differential
  function. Its preamble supplies only output capture and initialization;
  its main supplies a temporary directory. The adjacent preamble/main files
  and the frozen function identify how this original C diagnostic was composed.
- `as-profile-preflight.c` is a diagnostic-only adapter used to investigate GAS's
  CPU model: `+sse3` does not include its separate internal FISTTP feature, and
  there is no `+fisttp` command-line extension. Nocona supplies it; removing
  MONITOR and adding each ABI level's other extensions gives the intended
  profiles. Final qualification uses the real assembler directly without this
  adapter. See GNU's [dependency table](https://gnu.googlesource.com/binutils-gdb/+/2abac9c95cc1852c25cf8d67322e0af10d688b8a/opcodes/i386-gen.c)
  and [FISTTP description](https://gnu.googlesource.com/binutils-gdb/+/master/opcodes/i386-opc.tbl).
- `audit-elf.c` audits nonempty executable ELF sections at their boundaries,
  with exact scalar/vector decoder records and configured ISA eligibility.
  Object code isolates Buster's emitted functions from foreign startup/library
  code. The earlier whole-segment diagnostic intentionally remains in the logs:
  inter-section padding is not necessarily a valid fallthrough instruction
  stream. The linked system CRT also contains unclassified ENDBR64 landing pads;
  they are not silently admitted by this policy. This is not a whole-process,
  loader, shared-library or reachable-control-flow conformance claim.

Example harness builds, each under its own ordinary host lock:

```sh
clang -O2 -Wall -Wextra -Werror profile-compiler.c -o profile-compiler
clang -O3 -march=native -no-pie -fwrapv -funsigned-char -fno-strict-aliasing \
  -Wall -Wextra -Werror -I/FROZEN_CHECKOUT/src policy-instructions.c -o policy-instructions
```

The harnesses and compiler changes are original C. Clang, GCC, GNU as and
c-testsuite are external oracles/inputs; no external implementation or fixture
corpus is incorporated into these harnesses. Included compiler sources retain
their existing component licenses.

## Qualification boundaries

Independent agent source review found and corrected GCC macro-policy differences,
missing independent FMA negative expectations, and fatal-diagnostic handling in
the GNU as oracle. It rechecked the main merge and approved canonical-form
normalization after the live GNU as control exposed an ignored LEA segment
prefix. Optional FS/GS prefixes have no separate ISA requirement; the oracle
validates every normalized record, and the raw-form/flagged-record tests remain.
Final reviewed SHA-256 values are:

- `x86_target_forms.c`: `190e2e7d38b82b2dfc68a4d4143f7ace8e81a99c1ee2798e33a093597b7c4d74`.
- `x86_target_policy_test.c`: `11a5962b22cb4f8eb82f1062c3db5e0a9c729313564ef30e2b0b89be83d7b079`.
- `x86_target_selection_test.c`: `05d6658c4c2b499436606b8c34bf5c872a6a2d27b61fdcf0bd0f01444e917ee1`.
- Original instruction-count probe v2: `68ec66ee236dcfba2934a4e20ea97f707a3fc94870c98a223253709a5268bddb`.
- Original ELF auditor: `287a86aed79b1f77cd8be970fa936ec33f685b87f7c2eb167bd795a045e48537`.

Source review is distinct from executed validation. The original probe predates
the final table alignment and measures the pre-alignment policy only. The final
probe is rebuilt against release-head; it does not include the changed
preprocessor/parser. Whole-compiler measurements use complete frozen binaries.

The reviewer checked Intel's architectural requirements and GNU's dual FMA/
AVX512F templates after the live differential exposed 144 packed EVEX XMM/YMM
FMA forms admitted by GAS 2.47 without AVX512VL. The policy still denies all
144; independent minimal-feature tests require F and VL for every affected row.
The oracle enumerates exactly these six form families and reports accepted
records as coverage gaps, separately from exact comparisons. Future GAS
rejections take the normal comparison. This does not certify those cases with
the external assembler. See [Intel SDM](https://cdrdv2-public.intel.com/868137/325462-089-sdm-vol-1-2abcd-3abcd-4.pdf)
and [GNU opcode templates](https://gnu.googlesource.com/binutils-gdb/+/master/opcodes/i386-opc.tbl).
The reviewer also found that GAS can label an internal tool failure as an
ordinary error; the parser explicitly rejects that diagnostic.

## Commands and log interpretation

`current-base` and `release-head` name the separately frozen checkouts.
Each command takes its own shared lock; `ab` itself stays outside the lock and
takes it for each child. Builds use `BUSTER_DEBUG_INFO=0 ./build.sh` and the
repository's ordinary Clang/Zen 5 flags. Full sanitizer builds append
`-O1 -fsanitize=address,undefined -fno-omit-frame-pointer -fno-sanitize-recover=all`
to every Clang compile/link, retaining the ordinary source list and linker.
Sanitizer tests set `ASAN_OPTIONS=detect_leaks=1:abort_on_error=1` and
`UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`.

Core commands:

```sh
./build/compiler test-x86-target
./build.sh check-call-graph
env ISA180_COMPILER=/FROZEN/build/compiler ISA180_PROFILE=x86-64 \
  ./build/compiler test-c-testsuite --compiler /EVIDENCE/profile-compiler \
  --cross-check --jobs 4 --subset tests/c-testsuite/subset.txt /C-TESTSUITE
./build/compiler --verify -march=x86-64 -o /EVIDENCE/runtime-current-base-x86-64 /EVIDENCE/harness/runtime.c
```

The final comparison commands run from `current-base`, with sibling frozen
checkouts. The actual host prefix is `~/buster-fast-bench/codex-180-20261025-`;
`release-asan` contains the separate fully instrumented build. Substitute the
frozen checkouts for these paths when reproducing. `ab` takes the ordinary lock
for each child and rotates tree order by round:

```sh
./build/compiler ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh \
  ../codex-180-20261025-current-base ../codex-180-20261025-release-head \
  -- benchmark-x86-target \
  -- benchmark-x86-target --after-predefines 100 \
  -- benchmark-x86-target --after-predefines 100 --iterations 1
./build/compiler ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh \
  ../codex-180-20261025-current-base ../codex-180-20261025-release-head \
  -- benchmark-backend -- benchmark-assembler
./build/compiler ab --rounds 5 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh \
  ../codex-180-20261025-current-base ../codex-180-20261025-release-head \
  -- time-runs --runs 21 --list --verify -march=x86-64 -c /EVIDENCE/harness/runtime.c -o /EVIDENCE/runtime-release-timed.o \
  -- time-runs --runs 21 --after-scalar 100 --list --verify -march=x86-64 -c /EVIDENCE/harness/runtime.c -o /EVIDENCE/runtime-release-timed.o
```

The frozen SQLite checker comparison uses five rounds of 21 fresh processes,
after successful status-zero preflights for both revisions. Its single list is
`-fsyntax-only -std=gnu17 -march=x86-64 -nostdinc`, with `-isystem` paths
`headers/usr/lib/clang/23/include`, `headers/usr/local/include` and
`headers/usr/include`, followed by `sqlite/sqlite3.c`, all rooted at
`/var/lib/buster-9700x/corpora/preprocessor-391e729af658`. It measures checking,
not complete SQLite code generation or execution. The raw log records every
expanded argument and every process status.

The c-testsuite checkout is pinned to `5c7275656d751de0e68b2d340a95b5681858ed07`;
the adapter repeats the exact command at baseline, v3 and v4 for both revisions.
`--cross-check` includes direct/scalar identity, execution and an object linked
with the system compiler. This baseline's supported subset has 219 programs;
00204 (`long double`) remains an explicit unsupported result owned by #136's
pending #423, which is not part of these frozen sources.

The raw logs retain development failures: duplicate initializers, GCC macro
differences, the PEXTRW diagnostic and LEA's ignored-prefix warning. Their names
identify earlier builds. `head-5d7f071-target.log` and its sanitizer twin still
fail the LEA control and are not candidate acceptance. `current-head-build.log`
was superseded/interrupted, and `current-asan-build.log` was stopped while
waiting. The old `ab-target-3rounds.log` and `ab-end-to-end-5rounds.log` contain
only a first heading/lock wait, stopped when the baseline changed.
The f280e0f/88cc33c/609c482/2004c727/a233cdc receipts are development observations, including
partial A/B campaigns stopped when the oracle changed. Qualification uses the
explicitly named final candidate's release logs and results below.

## Development policy-kernel work and storage

[Three independently locked processes per build](raw/ab-policy-instructions.log),
each measuring 21 rotating passes of 10,000 complete tables on CPU 2:

| Path | Baseline instructions/table | Candidate instructions/table | Baseline ns/table range | Candidate ns/table range |
| --- | ---: | ---: | ---: | ---: |
| Scalar C source | 6,367.0219 | 6,367.0219 | 394.0020–395.1272 | 390.5115–393.7266 |
| Explicit AVX-512 | 6,803.0217 | 6,803.0217 | 318.4884–324.1490 | 317.0277–322.7123 |

Retired work is identical. Timing ranges overlap; these observations do not
establish a speedup. Both tables retain their sizes: 66,816 bytes of requirements
and 8,352 bytes of per-target eligibility. The 16-byte instruction format is
unchanged. The scalar C source is allowed to be vectorized by Clang, matching
the repository's existing benchmark interpretation.

The reviewed probe was compiled against the initial frozen encoder/policy
sources. The final alignment changes those inputs; the preceding numbers are
retained as development evidence and are not final-image acceptance.
Whole-compiler timings use separately frozen compiler images.

The policy audit does not insert a configured-target validation guard into the
actively owned Tier0/source driver. That remains the explicit #136/#133 handoff.
Tier1 already accepts the shared eligibility table. Unclassified forms remain
unavailable even with every target feature set. Full target-sensitive builtin
lowering, function targets, complete c-testsuite and SQLite acceptance remain
outside this bounded policy slice. No performance regression is accepted by
this record; unresolved or unexecuted results must remain labelled as such.
