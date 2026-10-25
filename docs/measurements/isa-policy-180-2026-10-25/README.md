# Generated ISA policy #180: October 25, 2026

Qualification record for [Buster PR #421](https://github.com/buster14a/buster/pull/421).
Corrected head `174c435` passes fresh optimized/sanitizer checks and hosted CI.
The controlled whole-compiler A/B campaign measured `6c72299`; a reviewed full-binary comparison
shows identical production code, data and layout at the corrected head, with
only test-only code and the build ID changed. Timings remain labelled with the
actually measured revision. Performance acceptance remains blocked on the user's
explicit approval of the recorded costs. PR #421 remains draft and unmerged;
issue #180 remains open.

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

At corrected head `174c435`, the manual optimized and full ASan/UBSan
`test-x86-target` commands both pass, now enforcing zero Tier0 refusals.
Both assembler cross-checks also pass. The optimized build takes 40.3 seconds;
the fully instrumented build takes 75.8 seconds. These are single build
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
| Existing focused compiler suites, pre-prefix revision `30e7bbc` | Encoder, semantics, assembler, Tier0 and Tier1 pipeline: all five pass in 7.9 seconds; corrected-head integrated CI separately passes all 79 commands |
| Manual nonrecursive policy, pre-prefix revision `30e7bbc` | 42 translation units, 25,690 functions, 150,638 calls, zero unapproved cycles; three existing allowed fuzz-generator cycles; final integrated CI graph recorded below |
| c-testsuite baseline/v3/v4, executed at `6c72299` | Each passes all 219 required programs; one explicit unsupported long-double case, zero failures; retained for unchanged production paths through the static boundary below |
| ELF auditor self-tests | Baseline/VEX/EVEX positives, ISA negatives, separated sections and malformed bounds pass |

These are manual 9700X checks, not workspace-host tests or hosted CI results.
Workspace checks are limited to source review, Git/source identities and
`git diff --check`. Hosted CI and performance receipts are recorded separately.

## Hosted CI

[Corrected-head 9700X run 40217751570](https://github.com/buster14a/buster/actions/runs/40217751570)
passes for `174c435539c3970558561e94b1f08445aa6d3c01`: **79 of 79 commands** in
52.9 seconds, zero failed or unstarted commands. Its
[measurement-storage check](https://github.com/buster14a/buster/actions/runs/40217751578)
also passes. The complete receipt is
[ci-174c435-run-40217751570.log](raw/ci-174c435-run-40217751570.log).
CI checks synthetic merge `aa775ff261381d5a4bac73630bb55e663cb63b4e`, combining
this head with main `bf774e7077e60e2c3ccba753a693eb332a740387`. The graph has 42
translation units, 26,282 functions, 154,841 calls, zero unapproved cycles and
three existing allowed fuzz-generator cycles. On this newer integration image,
the target test audits 1,955 Tier0 templates per profile and enforces zero
refusals. CI pins the external first-party performance fixtures to
`1c0523ac42bb2f33e212226cf94626ac942ee4d2`. This integration includes later work
from other owners; its benchmark observations are separate from the frozen
manual baseline/head comparisons.

The measured candidate's earlier
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
- Measured candidate: `6c722994e9dfccc9d6047235191d761376b6b3d1`, tree
  `3f6c4956fb6f369c220e889bfb179c80641d854f`. It adds only two equivalent
  first-character prechecks to the syntax whitelist. The original C experiment
  checks unchanged admission over all 8,352 forms and measures its benefit;
  full-image qualification is separate. No target legality or tuning changes.
- Corrected current candidate: `174c435539c3970558561e94b1f08445aa6d3c01`, tree
  `b9cc157b1ab5591ebdff8f989d5153c5645b9b7c`. Its only source delta from the
  measured candidate adds `&& refused == 0` to the policy-owned Tier0 fixture.
  Earlier executions observed zero refusals but did not enforce zero. The
  corrected test has fresh optimized, sanitizer and hosted CI passes. Production
  binary equality and the exact measurement-reuse boundary are recorded below.
- [Current baseline source/build input hashes](current-base-source-sha256.txt)
  and [measured candidate hashes](prefix-head-source-sha256.txt) identify the manual
  checkouts at the measured revision. The corrected head has its own
  [guard-head source manifest](raw/guard-head-source-sha256.txt), checked against
  both actual optimized and sanitizer source directories. The
  [pre-prefix hashes](release-head-source-sha256.txt),
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
- `sanitize-compiler.c` is an original C driver adapter for the corrected head's
  full sanitizer build. It appends the four recorded flags to every ordinary
  compile/link command and executes the absolute real Clang driver, retaining
  the repository build source list and linker choice. It adds no production
  dependency.

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
- Current `x86_target_selection_test.c`: `777745ec28a8acdfe28f714ba9fa2da9df325ec16d71af41e6e763d4263f8f23`.
- Measured `6c72299` selector test: `05d6658c4c2b499436606b8c34bf5c872a6a2d27b61fdcf0bd0f01444e917ee1`.
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
`guard-asan` contains the corrected head's fully instrumented build;
`prefix-asan` contains measured `6c72299`'s sanitizer build. `release-*` logs
record the pre-prefix candidate; `prefix-*` logs record measured `6c72299`;
`guard-*` logs record corrected `174c435` validation.
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
explicitly named measured candidate's `prefix-*` logs and results below. The
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

Reported retired work matches at four decimal places. These timing ranges describe the isolated C probe;
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
[the measured-prefix binary receipt](raw/prefix-binary-identities.txt) and
[corrected-head receipt](raw/guard-binary-identities.txt). The aligned
pre-prefix and earlier development loop disassemblies are
[retained](raw/release-table-alignment-disassembly.txt); this is not a
disassembly receipt for the measured prefix-head image.

## Corrected-head validation and evidence boundary

The old GitHub review thread identified a real coverage omission: matching
scalar/vector depth refusals were counted but could still let the audit pass.
The one-line correction now requires `refused == 0`; any refusal fails the
deterministic fixture. The
[thread](https://github.com/buster14a/buster/pull/421#discussion_r4370465273)
records the fix, independent review and fresh execution evidence and is resolved.

On the actual 9700X, fresh optimized and full ASan/UBSan `test-x86-target`
commands pass on `174c435`. At every baseline/v3/v4 profile they report 1,951
templates, 96 functions / 26,448 records and zero refusals with the assertion
enforced. Optimized and sanitizer `test-assembler --cross-check` each pass
1,873,323 checks. See `guard-head-*` and `guard-asan-*` raw logs, the
[current source manifest](raw/guard-head-source-sha256.txt) and both successful
source checks. All 42 sanitizer compile commands include the requested flags;
the original reviewed C adapter `sanitize-compiler.c` appends them to each
ordinary build command, including linking, without changing the source list.

The [binary receipt](raw/guard-binary-identities.txt) identifies the current
optimized image as SHA256
`59c036d826c90c9a6ba2f65956f4beb4efd432f19062704627c91f67c0d46ee2`
and ASan/UBSan image as
`0393cca6f24fa3fde8b1664ac842b3d4dab370e03961557ddcc164ccd7ed80e3`.
The optimized image is still 35,441,547 bytes, with unchanged text/data/BSS sizes.

Full-file static comparison with the measured image found exactly 1,195
differing bytes: 31 inside the build-ID payload, 1,164 inside the explicitly
invoked `run_x86_target_selection_tests` function. Every other byte matches.
Program headers, section headers and complete symbol tables match exactly;
all production instructions/data, addresses, mappings and unwind metadata are
identical. The test function is only reached by `test-x86-target` and is outside
the measured production commands. The source reviewer independently repeated
this static check on both actual binaries. See the
[scope/commands](raw/guard-binary-equivalence.txt),
[complete byte differences](raw/guard-vs-prefix.cmp.txt),
[program headers](raw/guard-program-headers.txt) and
[section headers](raw/guard-section-headers.txt).

The `6c72299` performance and three-profile c-testsuite receipts are retained as
evidence for these unchanged production paths, with their original measured or
executed revision labels. They are not new direct `174c435` timings or new
executions of the full three-profile corpus matrix. The changed test code and
consumers of binary identity lie outside that reuse boundary; corrected-test,
sanitizer and integration-CI validation are recorded separately above. No
performance approval follows from binary equivalence.

## Final whole-compiler measurements

Final comparison: frozen main `5863eeda` versus `6c72299`, using the complete
`current-base` and `prefix-head` binaries. Each row's independent processes
rotate tree order by round; each child takes the ordinary shared lock. The
startup and throughput comparisons below are complete; no command is left running
from this measurement campaign.

The [expanded startup comparison](raw/prefix-ab-startup-15rounds.log) completes
all 60 independently locked commands: 15 rotating rounds, two binaries, two
configurations. Every command succeeds. The one-table configuration fixes
`znver5`, selects only the explicit AVX-512 builder, performs 100 ms of
predefinitions before each sample and reports the median of 21 samples of one
table. This measures one eligibility-table operation after preceding work,
not complete process startup.

The assembler configuration fixes `x86-64-v4` and the mixed workload: 256
functions, 9,984 instructions, 153,295 source bytes. Each process reports one
initialization observation, including encoder and matcher initialization,
then scalar/vector stage medians from 21 interleaved warm passes. Initialization
is not a median of 21 initialization trials.

| Round | One-table baseline, ns | One-table head, ns | Assembler init baseline, ms | Assembler init head, ms |
| --- | ---: | ---: | ---: | ---: |
| 1 | 381 | 410 | 0.712 | 0.732 |
| 2 | 381 | 411 | 0.702 | 0.741 |
| 3 | 391 | 411 | 0.722 | 0.769 |
| 4 | 410 | 401 | 0.757 | 0.810 |
| 5 | 381 | 401 | 0.764 | 0.924 |
| 6 | 381 | 401 | 0.796 | 0.768 |
| 7 | 391 | 411 | 0.794 | 0.950 |
| 8 | 411 | 421 | 0.743 | 0.789 |
| 9 | 411 | 451 | 0.803 | 0.773 |
| 10 | 381 | 411 | 0.605 | 0.776 |
| 11 | 391 | 411 | 0.671 | 0.721 |
| 12 | 381 | 411 | 0.637 | 0.662 |
| 13 | 400 | 411 | 0.680 | 0.704 |
| 14 | 381 | 421 | 0.635 | 0.801 |
| 15 | 391 | 430 | 0.744 | 0.673 |

One-table medians: 391 → 411 ns (+20 ns, +5.115%); ranges of process medians
381–411 and 401–451 ns. Fourteen paired increases and one decrease give a median
paired increase of 20 ns; individual paired changes span -9 to +40 ns.
Median reported cycles rise 2,292 → 2,435 (+6.239%), with ranges 2,249–2,588
and 2,382–2,634. The ranges overlap; the paired direction and absolute cost are
retained rather than declaring the shift absent.

Assembler initialization medians: 0.722 → 0.769 ms (+47 microseconds, +6.510%).
The 15 individual observations span 0.605–0.803 and 0.662–0.950 ms; 12 paired
increases and three decreases give a median paired increase of 46 microseconds
and paired range -71 to +171 microseconds. These are one-time initialization
observations, separate from warm pass throughput. Every image reports the same
419,496-byte index, 16,816,496-byte work arena and 99,760-byte benchmark ELF.

| Warm assembler pass | Baseline median, ms (range of process medians) | Head median, ms (range of process medians) | Head elapsed change |
| --- | ---: | ---: | ---: |
| Scalar | 3.631 (3.586–3.686) | 3.580 (3.514–3.709) | -1.405% |
| Vector | 1.400 (1.386–1.451) | 1.398 (1.379–1.434) | -0.143% |

Each warm path has ten paired decreases and five increases. Both ranges overlap;
these observations do not establish a uniform assembler throughput gain.
The raw receipt retains every stage and total. Adding an initialization
observation to a warm-pass median would be a derived estimate, not a measured
cold end-to-end assembly, so no such sum is presented as an experiment.

The recorded one-table, assembler initialization and vector-backend increases
remain **unaccepted pending the user's explicit approval**. The candidate adds
verified legality coverage for current selector families and rejects unknown
forms, with stable consumer interfaces and unchanged table/record sizes. These
functional benefits are the proposed justification for considering the costs;
improvements in other measurements do not approve them. No performance limit
has been relaxed. Further source or integration changes need fresh qualification
against their own exact baseline/head images.

The [complete sustained table samples](raw/prefix-ab-steady-3rounds.log) use
the repository benchmark's fixed `znver5` target, three independently locked
processes per image and condition, each reporting the median of 21 samples of
10,000 tables.
The C-source scalar twin may be auto-vectorized by Clang. Each table cell below
is the median of the three process medians, followed by their full range;
elapsed changes compare those aggregate medians.

| Preceding predefinitions | Path | Baseline ns/table (range of process medians) | Head ns/table (range of process medians) | Head elapsed change |
| --- | --- | ---: | ---: | ---: |
| None | Scalar C source | 390.90 (388.40–391.07) | 386.18 (385.81–392.25) | -1.207% |
| None | Explicit AVX-512 | 306.75 (304.14–309.72) | 306.85 (305.90–314.08) | +0.033% |
| 100 ms | Scalar C source | 420.47 (420.05–421.97) | 416.34 (413.85–419.27) | -0.982% |
| 100 ms | Explicit AVX-512 | 407.12 (405.89–407.14) | 404.65 (403.24–407.79) | -0.607% |

The steady vector point estimate is slightly higher with overlapping ranges;
its three paired elapsed changes are +0.579%, +0.033% and +1.408%. The preceding-
work vector point estimate is lower, with one of three paired increases and
overlapping ranges. These observations do not establish a uniform throughput
gain or prove a small regression absent. Cycles and every sample remain in the
receipt. This is the complete compiler image, distinct from the isolated C
policy probe above. Performance acceptance remains pending.

The same completed three-round receipt includes `benchmark-backend`: every
image reports the same 2,008 functions, 262,874 typed entries, 303,116 records,
1,171,371 emitted bytes and 9,414 deferred entries. All six runs pass with
identical reported retired instruction counts per entry (two decimal places).

| Backend path | Baseline ns/entry (range of process medians) | Head ns/entry (range of process medians) | Head elapsed change | Instructions/entry, both images |
| --- | ---: | ---: | ---: | ---: |
| Vector | 14.32 (14.31–14.34) | 14.36 (14.35–14.36) | +0.279% | 169.31 |
| Scalar | 41.96 (41.89–41.99) | 41.84 (41.83–41.87) | -0.286% | 574.35 |
| Sizing | 1.13 (1.11–1.13) | 1.11 (1.11–1.13) | -1.770% | 12.65 |
| Encode | 0.89 (0.88–0.89) | 0.87 (0.86–0.88) | -2.247% | 17.78 |

The vector increase appears in all three paired elapsed comparisons
(+0.209%, +0.139%, +0.349%), with disjoint process-median ranges. Median cycles
per entry rise from 79.40 to 79.55 (+0.189%); the full six cycle observations
are 79.40/79.48/79.30 at baseline and 79.47/79.55/79.62 at head.
This small measured cost is explicitly unaccepted pending the user's approval.
Identical reported instruction counts and unchanged backend implementation sources do
not prove its cause. The other paths' timing decreases do not establish
uniform gains; their complete paired samples remain in the receipt.

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

The [short-file compile comparison](raw/prefix-ab-compile-5rounds.log) completes
five rounds per condition, 21 fresh processes per image per round, 420 successful
processes total. It compiles the frozen original `runtime.c` with
`--verify -march=x86-64 -c`; the second condition performs 100 ms of scalar work before
each child process. No observation is discarded.

| Round | Baseline normal, ms | Head normal, ms | Baseline after scalar, ms | Head after scalar, ms |
| --- | ---: | ---: | ---: | ---: |
| 1 | 2.724 | 2.782 | 2.666 | 2.712 |
| 2 | 2.690 | 2.691 | 2.877 | 2.695 |
| 3 | 2.684 | 2.681 | 2.706 | 2.674 |
| 4 | 2.742 | 2.763 | 2.655 | 2.670 |
| 5 | 2.697 | 2.696 | 3.234 | 2.746 |

Normal median of process medians: 2.697 → 2.696 ms (-0.037%), with process-median
ranges 2.684–2.742 and 2.681–2.782 ms. After the scalar control: 2.706 → 2.695 ms
(-0.407%), ranges 2.655–3.234 and 2.670–2.746 ms. Both conditions have mixed
paired changes and overlapping ranges; these observations do not establish a
compile-speed improvement. The individual-process ranges and all statuses are
retained in the raw receipt. In particular, the baseline 3.234 ms process median
after scalar work remains included rather than removed as an outlier.

## Generated program, code size and runtime

The frozen original unsigned-arithmetic program returns
`14213000051299467171`, matching Clang's baseline reference. Every baseline/v3/v4
baseline and pre-prefix executable ran successfully and matched that output.
Measured compiler `6c72299` was then used to rebuild each profile: every resulting object
and linked executable is byte-identical to the corresponding baseline and
pre-prefix output. See the
[pre-prefix identities](raw/release-runtime-object-identities.txt) and
[measured `6c72299` identities](raw/prefix-runtime-object-identities.txt).

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
produced by pre-prefix `30e7bbc`; measured `6c72299` emits the exact same bytes,
as its identity receipt establishes. These are not new `174c435` runtime
executions. No remeasurement of identical
program bytes is represented as a new experiment.

| Profile | Baseline median of process medians, ms | Head median of process medians, ms | Baseline range of process medians, ms | Head range of process medians, ms |
| --- | ---: | ---: | ---: | ---: |
| x86-64 | 2.029 | 2.032 | 2.029–2.031 | 2.031–2.034 |
| x86-64-v3 | 2.028 | 2.029 | 2.028–2.029 | 2.026–2.029 |
| x86-64-v4 | 2.029 | 2.029 | 2.028–2.029 | 2.028–2.029 |

The raw nine `release-runtime-ab-r*-*.log` files retain every observation and
zero-failure result. These are timings of byte-identical programs with small
process-timing variation, not an optimization claim or broad runtime acceptance.
The explicit SSE/VEX/EVEX native policy fixtures provide separate positive
execution and negative ISA-policy rejection coverage beyond this integer workload.

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

Reported retired work matches at four decimal places. The explicit-vector timing ranges overlap; these
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
