# Generated ISA policy #180: October 25, 2026

Qualification record for [Buster PR #421](https://github.com/buster14a/buster/pull/421).
Functional qualification is complete. Final whole-compiler performance comparisons
are still running; performance acceptance remains pending.

## Independent scope and executed checks

The six `-march` profiles, CPUID/XCR0 resolver, target-sensitive predefines,
eleven bounded builtin queries, tuning separation, vector eligibility producer
and assembler guard already existed on main. This PR verifies those interfaces
and extends classification to the current selectors; it does not replace their
owners' completed work. There are 1,611 classified canonical forms out of 8,352;
6,741 remain explicitly unavailable even with every feature bit set.

The source change is limited to `x86_target_forms.c`, policy/selection test files,
the existing target test command, its three-line backend test include in
`main.c`, `docs/x86-target.md`, and two necessary-character prechecks in
`x86_match.c`'s existing VEX/EVEX syntax whitelist. That matcher slice was claimed
after #233's owner released it and #416 merged. No Tier0, Tier1 or preprocessor
implementation is edited. The existing Tier1 interface already consumes the shared eligibility
table. Tier0's production target-validation guard remains the explicit
[#136/#133 handoff](https://github.com/buster14a/buster/issues/136#issuecomment-6395663929);
[#423's owner](https://github.com/buster14a/buster/pull/423#issuecomment-6396342128)
has the new x87/FISTTP classification details and
[acknowledged adoption of the guards after this policy lands](https://github.com/buster14a/buster/pull/423#issuecomment-6397090502).
That owner confirms baseline truncation uses control-word changes around
FISTP, and enumerates the emitted baseline x87 forms. This is a concrete
integration handoff, not executed acceptance of that newer implementation by
this session. The
[#424 module-home integration note](https://github.com/buster14a/buster/pull/424#issuecomment-6396848156)
identifies the backend-only test entry point. Full builtin lowering (#148),
function target attributes (#147) and full c-testsuite/SQLite generation
acceptance (#145/#146) remain outside this claim. Issue #180 stays open.

At the frozen candidate, the manual optimized and full ASan/UBSan
`test-x86-target` commands both pass. The optimized build takes 40.9 seconds;
the fully instrumented build takes 71.4 seconds. These are single build
observations, not comparative build-throughput measurements. Checks include:

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
| Final optimized and sanitizer assembler cross-checks | Each passes 1,873,323 checks |
| Existing focused compiler suites, pre-prefix revision `30e7bbc` | Encoder, semantics, assembler, Tier0 and Tier1 pipeline: all five pass in 7.9 seconds; final integrated CI separately passes all 75 commands |
| Manual nonrecursive policy, pre-prefix revision `30e7bbc` | 42 translation units, 25,690 functions, 150,638 calls, zero unapproved cycles; three existing allowed fuzz-generator cycles; final integrated CI graph recorded below |
| c-testsuite baseline/v3/v4 | Each passes all 219 required programs; one explicit unsupported long-double case, zero failures |
| ELF auditor self-tests | Baseline/VEX/EVEX positives, ISA negatives, separated sections and malformed bounds pass |

These are manual 9700X checks, not workspace-host tests or hosted CI results.
Workspace checks are limited to source review, Git/source identities and
`git diff --check`. Hosted CI and performance receipts are recorded separately.

## Hosted CI

[Final 9700X run 40201651984](https://github.com/buster14a/buster/actions/runs/40201651984)
passed for PR head `6c722994e9dfccc9d6047235191d761376b6b3d1`:
75 of 75 test commands passed in 47.4 seconds. Its
[measurement-storage check](https://github.com/buster14a/buster/actions/runs/40201651999)
also passed. The full receipt is
[ci-6c72299-run-40201651984.log](raw/ci-6c72299-run-40201651984.log).
CI checked out synthetic merge `78c91f99b7166619294869ae4e36acef2d9be0ff`,
combining this head with main `b42309051f92bf5d1702b095c171d44ef46a6f08`.
Its graph contains 25,843 functions and 151,697 calls in 42 translation units,
zero unapproved cycles and three allowed fuzz-generator cycles. This integration
image includes other owners' newer changes; the manual A/B pair below uses the
frozen current-main baseline instead. The CI assembler benchmark is an
integration observation, not a controlled baseline/head comparison.

For completeness, the pre-prefix candidate's
[9700X run 40193482934](https://github.com/buster14a/buster/actions/runs/40193482934)
passed for PR head `30e7bbc860056779b0e9fa3f426565e1bc010ec4`:
74 of 74 test commands passed in 46.8 seconds, followed by the requested
assembler benchmark. The
[measurement-storage check](https://github.com/buster14a/buster/actions/runs/40193482838)
also passed. The complete decoded job receipt is retained as
[ci-30e7bbc-run-40193482934.log](raw/ci-30e7bbc-run-40193482934.log).

CI checked out synthetic merge `08b5b59c6807ab7472c2cc9064a6cfc4c822ff77`,
combining the PR head with then-main `d748ca959b3726593897fe7678169d1b2f91351c`.
That integration image includes other owners' later changes, unlike the manual
frozen-baseline pair. Its call graph contains 25,724 functions and 150,946 calls
in 42 units, with zero unapproved cycles and the same three allowed cycles.
Its benchmark values are CI observations, not substitutions for the controlled
baseline/head comparisons. CI pinned the external first-party performance
fixtures to `980ae7e87dfc709bda50d7d493ea3800d1411bcc`.

This is passing PR CI, not a merge or main-containment claim. The implementation
PR remains unmerged as requested.

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
- Pre-prefix candidate: `30e7bbc860056779b0e9fa3f426565e1bc010ec4`, tree
  `34b6f27af2d90b04293580e1321706b02a7097ce`. Its merge of current main is
  `e0b558f18491c40c950d74f12223a407e1c2117c`; subsequent commits correct a
  documentation count and calibrate the external assembler oracle's input,
  architectural-refusal diagnostics and GAS CPU-feature taxonomy. The final
  policy revision explicitly aligns the requirement array to 64 bytes, avoiding split
  cache-line loads as the surrounding compiler image changes.
- Final candidate: `6c722994e9dfccc9d6047235191d761376b6b3d1`, tree
  `3f6c4956fb6f369c220e889bfb179c80641d854f`. It adds only two equivalent
  first-character prechecks to the syntax whitelist. The original C experiment
  checks unchanged admission over all 8,352 forms and measures its benefit;
  full-image qualification is separate. No target legality or tuning changes.
- [Current baseline source/build input hashes](current-base-source-sha256.txt)
  and [final candidate hashes](prefix-head-source-sha256.txt) identify the manual
  checkouts. A post-commit tracked-source manifest matches the actual remote
  final sources exactly. The [pre-prefix hashes](release-head-source-sha256.txt),
  other source manifests and initial
  binary identities belong to their named development builds, not final
  qualification. The current-base/prefix-head pair is the final whole-compiler
  comparison; release-head is `30e7bbc` and qualified-head is the pre-alignment
  `2004c727` development build.
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
- `policy-store64.c` compares an eight-byte eligibility store against the
  existing masked byte store, with 434 unaligned/reference/sentinel checks.
  Three repeated measurements found it slower despite two fewer retired
  instructions per table. This experiment was rejected; production retains
  the existing algorithm and stores.
- `syntax-prefix.c` compares exact old/proposed syntax-whitelist functions over
  all 8,352 forms, checking unfiltered decisions and target-filtered table
  identity. Its three repeated measurements isolate the admission pass;
  full initialization and whole-compiler acceptance use the final binary.

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
- `x86_match.c`: `17a689e24e87873c73db5783401f18b1f0105ec2004d69c5105838c82ac32fdd`.
- Original instruction-count probe v2: `68ec66ee236dcfba2934a4e20ea97f707a3fc94870c98a223253709a5268bddb`.
- Original ELF auditor: `287a86aed79b1f77cd8be970fa936ec33f685b87f7c2eb167bd795a045e48537`.

Source review is distinct from executed validation. The early probe build
predates the requirement-table alignment and measures that development policy.
The final probe is rebuilt against aligned `30e7bbc` (`release-head`). Its three
included encoder/target/policy source files are byte-identical at final
`6c72299`; it includes neither `x86_match.c` nor the preprocessor/parser.
These are final policy-kernel inputs, not a final compiler image. Whole-compiler
measurements use the complete frozen `prefix-head` binary.

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

`current-base` and `prefix-head` name the final separately frozen checkouts.
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
`prefix-asan` contains the final fully instrumented build. `release-*` logs
record the pre-prefix candidate; `prefix-*` logs record the final candidate.
Substitute the frozen checkouts for these paths when reproducing. `ab` takes the ordinary lock
for each child and rotates tree order by round:

```sh
./build/compiler ab --rounds 15 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh \
  ../codex-180-20261025-current-base ../codex-180-20261025-prefix-head \
  -- benchmark-x86-target --only avx512 --after-predefines 100 --iterations 1 \
  -- benchmark-assembler
./build/compiler ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh \
  ../codex-180-20261025-current-base ../codex-180-20261025-prefix-head \
  -- benchmark-x86-target \
  -- benchmark-x86-target --after-predefines 100 \
  -- benchmark-backend
./build/compiler ab --rounds 5 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh \
  ../codex-180-20261025-current-base ../codex-180-20261025-prefix-head \
  -- time-runs --runs 21 --list --verify -march=x86-64 -c /EVIDENCE/harness/runtime.c -o /EVIDENCE/runtime-prefix-timed.o \
  -- time-runs --runs 21 --after-scalar 100 --list --verify -march=x86-64 -c /EVIDENCE/harness/runtime.c -o /EVIDENCE/runtime-prefix-timed.o
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
00204 (`long double`) is explicitly unsupported in this frozen pair. #136's
#423 later merged as `cb4133a5a7d44d046aecb9d30e408c5dc97dab91`; it is outside
the manual pair and does not change this pair's acceptance count.

The raw logs retain development failures: duplicate initializers, GCC macro
differences, the PEXTRW diagnostic and LEA's ignored-prefix warning. Their names
identify earlier builds. `head-5d7f071-target.log` and its sanitizer twin still
fail the LEA control and are not candidate acceptance. `current-head-build.log`
was superseded/interrupted, and `current-asan-build.log` was stopped while
waiting. The old `ab-target-3rounds.log` and `ab-end-to-end-5rounds.log` contain
only a first heading/lock wait, stopped when the baseline changed.
The f280e0f/88cc33c/609c482/2004c727/a233cdc receipts are development observations, including
partial A/B campaigns stopped when the oracle changed. Qualification uses the
explicitly named final candidate's `prefix-*` logs and results below. The
isolated policy probe retains its `release-*` name because its included sources
are identical at the final head, as explained above.

## Final isolated policy-kernel work and storage

The [final instruction-counter comparison](raw/release-ab-policy-instructions.log)
completed three independently locked processes per build on CPU 2, each with
21 rotating passes of 10,000 complete tables. Every read had positive,
unmultiplexed counters and a valid clock; scalar/vector tables matched.

| Path | Baseline instructions/table | Candidate instructions/table | Baseline ns/table range | Candidate ns/table range |
| --- | ---: | ---: | ---: | ---: |
| Scalar C source | 6,367.0219 | 6,367.0219 | 395.6562–406.8341 | 386.3156–392.8389 |
| Explicit AVX-512 | 6,803.0217 | 6,803.0217 | 314.4749–318.1929 | 298.9617–306.2655 |

Retired work is identical. These timing ranges describe the isolated C probe;
its code and data placement differ from the compiler executable. They do not
establish whole-compiler throughput or causal attribution to alignment.
The baseline probe's three included repository sources are byte-identical to
the frozen current-main inputs, as recorded in
[the source-equivalence receipt](raw/release-policy-baseline-source-equivalence.txt).
The candidate probe is rebuilt against aligned `30e7bbc`, whose included
encoder/target/policy sources are identical at final `6c72299`. It excludes the
two-line matcher slice.

Requirements remain 66,816 bytes, per-target eligibility 8,352 bytes and each
instruction 16 bytes. The final optimized compiler is 35,441,547 bytes versus
35,404,246 at baseline: +37,301 bytes (0.105%), principally added test/oracle
coverage. Exact executable hashes, text/data/BSS sizes and source hashes are in
[the final binary receipt](raw/prefix-binary-identities.txt). The aligned
pre-prefix and earlier development loop disassemblies are
[retained](raw/release-table-alignment-disassembly.txt); this is not a
disassembly receipt for the final prefix-head image.

## Final whole-compiler measurements

Final comparison: frozen main `5863eeda` versus `6c72299`, using the complete
`current-base` and `prefix-head` binaries. Each row's independent processes
rotate tree order by round; each child takes the ordinary shared lock. The
remaining startup, short-file and sustained-work comparisons are still running.

The [frozen SQLite checker comparison](raw/prefix-ab-sqlite-5rounds.log)
completed five rounds, 21 fresh processes per image per round, with zero failed
processes. These are checking-only runs, not SQLite code generation/runtime.

| Round | Baseline median, ms | Final head median, ms | Head elapsed change |
| --- | ---: | ---: | ---: |
| 1 | 149.972 | 149.383 | -0.393% |
| 2 | 150.028 | 149.006 | -0.681% |
| 3 | 150.045 | 148.906 | -0.759% |
| 4 | 150.160 | 149.162 | -0.665% |
| 5 | 150.160 | 148.953 | -0.804% |

Median of process medians: 150.045 → 149.006 ms (-0.692%). Baseline process
medians span 149.972–150.160 ms; head spans 148.906–149.383 ms. The individual
process observations overlap (baseline 149.136–152.469 ms; head
147.881–150.971 ms), and the raw receipt preserves every value. All five paired
process medians favor the candidate. This is a measured whole-image observation,
not attribution of the improvement to a specific source edit.

## Generated program, code size and runtime

The frozen original unsigned-arithmetic program returns
`14213000051299467171`, matching Clang's baseline reference. Every baseline/v3/v4
baseline and pre-prefix executable ran successfully and matched that output.
The final compiler was then used to rebuild each profile: every final object
and linked executable is byte-identical to the corresponding baseline and
pre-prefix output. See the
[pre-prefix identities](raw/release-runtime-object-identities.txt) and
[final identities](raw/prefix-runtime-object-identities.txt).

- Every object: SHA256 `698a969cba29381ba4d167b660b106b5e47e76eb2c706823c580e20543a6a845`.
- Every linked executable: SHA256 `4a81f4d5c91b7409b59f7343b520d0bd661e8270cfc4b5c8cb8bcdac84668259`.
- Buster-emitted object code: 161 bytes / 50 instructions, identical scalar and
  vector decoder records; all pass the configured ISA audit. FNV receipt
  `d384614d5b244074` is an additional diagnostic, not a cryptographic identity.
- Linked executable: text 1,253 bytes, data 468 bytes, BSS 1 byte. Foreign CRT
  code is outside the Buster instruction audit, as explained above.

Three independently locked paired runtime processes per profile run each image
21 times. Each process uses `time-runs --executable /usr/bin/env` with separate
baseline/head lists; those lists rotate within the process. Reported wall time
includes the common process/`env` dispatch cost. The timed head executable was
produced by pre-prefix `30e7bbc`; the final compiler emits the exact same bytes,
as the final identity receipt establishes. No remeasurement of identical
program bytes is represented as a new experiment.

| Profile | Baseline median of process medians, ms | Head median of process medians, ms | Baseline range, ms | Head range, ms |
| --- | ---: | ---: | ---: | ---: |
| x86-64 | 2.029 | 2.032 | 2.029–2.031 | 2.031–2.034 |
| x86-64-v3 | 2.028 | 2.029 | 2.028–2.029 | 2.026–2.029 |
| x86-64-v4 | 2.029 | 2.029 | 2.028–2.029 | 2.028–2.029 |

The raw nine `release-runtime-ab-r*-*.log` files retain every observation and
zero-failure result. These are timings of byte-identical programs with small
process-timing variation, not an optimization claim or broad runtime acceptance.
The explicit SSE/VEX/EVEX native policy fixtures provide separate positive and
negative ISA execution coverage beyond this integer workload.

## Measured bounded experiments

The syntax-whitelist prefilter was retained only after three same-process
comparisons, 21 rotating passes of 100 admission tables per comparison, with
unfiltered equality over all 8,352 forms and exact target-filtered table identity.
The [receipt](raw/prototype-syntax-prefix-ab.log) records these ns/table pairs:
37,632.29 → 33,471.39; 37,765.54 → 36,093.90; 37,441.73 → 35,773.51.
Retired instructions fall from 948,731.1800 to 815,198.1600 per admission table
(14.07%). This is the supported-name admission pass only; the full-image
startup gate includes roles/buckets and the other initialization work.

The eight-byte-store experiment was rejected. Across three comparisons of
21 rotating passes of 10,000 eligibility tables, the existing masked store
took 305.6724 / 304.9560 / 310.6297 ns versus 316.2492 / 311.2318 / 315.6791 ns
for the replacement. Each process passed all 434 unaligned/reference/sentinel
checks, and the replacement retired about two fewer instructions/table, but it
was slower in every comparison. The
[receipt](raw/prototype-store64-ab.log) and original C helper preserve that
negative result; production stores remain unchanged.

## Development policy-kernel work and storage

[Three independently locked processes per build](raw/ab-policy-instructions.log),
each measuring 21 rotating passes of 10,000 complete tables on CPU 2:

| Path | Baseline instructions/table | Candidate instructions/table | Baseline ns/table range | Candidate ns/table range |
| --- | ---: | ---: | ---: | ---: |
| Scalar C source | 6,367.0219 | 6,367.0219 | 394.0020–395.1272 | 390.5115–393.7266 |
| Explicit AVX-512 | 6,803.0217 | 6,803.0217 | 318.4884–324.1490 | 317.0277–322.7123 |

Retired work is identical. The explicit-vector timing ranges overlap; these
observations do not establish whole-compiler speed. Both tables retain their sizes: 66,816 bytes of requirements
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
