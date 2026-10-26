# ISA policy optimization follow-up — issue 180 / PR 421

This campaign completes the independent optimization and bounded qualification
at the frozen revisions below. It follows the user's request to optimize the
previously unaccepted costs. Remaining costs are explicitly unapproved, and
PR 421 remains draft/unmerged. The [earlier qualification](../isa-policy-180-2026-10-25/README.md)
is historical; no old observation is relabelled as a new run.

## Revisions and ownership

- Previous reviewed PR head: `174c435539c3970558561e94b1f08445aa6d3c01`.
- Current optimized head: `ad08d9404663412c5de544653b8a81dee2261ddb`,
  tree `7c5346c97194747b3c775731f534a5a9a1e29160`.
- New current-main comparison frozen at `55141e0a19e8143a76e72ae1593fd99b0d4b2c32`,
  tree `1f16b7d4f5cbcea6c91a6ea26ad4d36d01b3d19e`.
- Unoptimized integration control: `07483d67ea99cca1e45ab844180cb764c302d8e4`,
  tree `d09086c65d58173d8980d4eed4201ce5fbf37ba9`. The only merge conflict
  preserved both the backend-only ISA selection-test include and main's new
  `ir_stack_test.c` include.
- Branch: `codex/180-isa-policy-completion`; one writer.
- [Bounded claim](https://github.com/buster14a/buster/issues/180#issuecomment-6411403881):
  policy construction and matcher initialization, owned tests/documentation.
  Tier 0/Tier 1/preprocessor producers and hot encoder implementation remain with
  their existing owners. No integration or merge ownership is taken.
  The [default-initializer extension](https://github.com/buster14a/buster/issues/180#issuecomment-6414514647)
  permits guarded FS-to-GS template reuse, with existing storage and encoding
  loops unchanged. The previous encoder claim was released; no other active
  producer's files were taken over.

## Measurement protocol

All compilation, execution, tests and measurements use the approved Ryzen 7
9700X, through the ordinary shared `~/buster-fast-bench/exclusive.sh` once per
run. CPU 2 is used for timings. No lock bypass, reservation, competing campaign
or CI cancellation is used. Local actions are source/Git/static binary
inspection only. [Host identity](raw/host-lscpu.txt) is a read-only query.
The owner also requested consulting the new local queue. We read
`~/llm-memory/projects/buster-fast/laptop-cores-queue.md` and the installed
`~/dev/scripts/cores`: local multicore work must take FIFO physical-core slots,
leaving the interactive reservation. This does not replace the 9700X lock.
No local compiler execution or multicore campaign was used here.

The isolated development C helpers include the frozen `174c435` encoder/policy/matcher
sources from `~/buster-fast-bench/codex-180-20261025-guard-head/src`.
Each helper is compiled with Clang using `-std=gnu17 -O3 -march=native -fwrapv
-fno-strict-aliasing`, and run under `taskset -c 2`. They rotate variants for
21 passes, require positive elapsed time and hardware instruction counts,
reject unavailable/multiplexed counters, and fail on any output mismatch.

These are warm, isolated probes. Counts include amortized timing/control
overhead. They do not establish compiler startup, whole-process throughput,
generated-program runtime, or current-main acceptance. Those require the final
compiler image and separate controls.

The published `policy-compact.c` and `template-gs-reuse.c` mirrors remove only
trailing whitespace or an extra final blank line. Their exact executed source
bytes are retained in `raw/policy-compact-as-executed.c.txt` (SHA256
`cd5d1c2a103087ee8da21d084b7d4a7fc427421d97af48fcdebd7b34e7d0273a`)
and `raw/template-gs-reuse-as-executed.c.txt` (SHA256
`9416d88557a164a1a18f702eafba202e804c8715fb3849029f6e37c081fa2c68`).
The raw snapshots, rather than the cosmetically normalized mirrors, bind the
executed-source claims. No result is represented as a rerun of the mirrors.

## Development decisions

- Single marker comparison: first screen `304.3609 -> 317.5726 ns/table`
  despite `6803.0219 -> 5760.0217` reported instructions/table.
  **Rejected**, never adopted in production. The original helper/receipt
  remain in `policy-marker.c` / `raw/marker-r1.log`. Its offset output and
  sentinels pass, but its plain byte array does not guarantee SIMD
  misalignment; the receipt's “unaligned” label is too strong. Later helpers
  and the production test explicitly align the array to 64 bytes before +1.
- Delayed operand roles: all 434 full-index comparisons pass in each of three
  independently locked processes. Each compares all 419,496 output bytes
  including unused entries and padding. Pairs are
  `50.59060 -> 47.84865`, `51.11859 -> 41.32752`,
  `51.45992 -> 40.80765` microseconds/init; reported instructions/init
  `1214088.2100 -> 1104158.1700`. This measures the three-line move alone;
  that warm experiment alone did not establish final-image acceptance.
- `policy-kernels-screen.c` preserves the actually executed source of
  `raw/kernels-r1.log` before its alignment correction. Its XOR variant is
  neutral/slower; sign-mask is promising but not retained yet.
- `matcher-cached-syntax.c` measures syntax reuse **plus** delayed roles,
  against the original initializer. It cannot by itself isolate the cache's
  incremental benefit.
- `policy-batch.c` screens combined 32/64-row masks and exact full stores,
  with the original bounded eight-row masked tail.

The final vector representation uses a constant 32-bit requirement projection,
16 rows per batch, with the original 64-bit scalar reference retained. One row
source expands into both tables and compile-time representability assertions.
The vector working set is 33,408 bytes rather than 66,816; combined requirement
data is 100,224 bytes, not half the total storage. The selected compact prototype
passes 8,352 row round trips and 868 scalar/unaligned/sentinel comparisons per
process. Original/vector ns/table pairs are 308.7401/134.2979,
305.9299/134.4142 and 305.7445/133.5866; reported instructions/table are
6803.0231/2802.0228. Its runtime projection fill is outside timing. Actual
production uses constant data and requires the separate image measurements.

The combined syntax-cache/delayed-role pairs are 51.94053/29.40826,
54.29274/30.41245 and 58.26028/31.99983 microseconds/init; instructions/init are
1214088.21/776585.17. Every process compares all 434 full 419,496-byte indexes.
The cache alone is not isolated by these combined results.

`policy-batch.c` measured 331.41/331.36 ns for 32/64-row packing versus 303.96
for the original. `policy-sparse.c` measured 312.72/349.19 for zero-first/sparse
stores versus 304.38. Neither was retained. Fewer instructions did not justify
slower elapsed time.

## Actual-image development screens

The first [complete current-main comparison](raw/ab-initial-3rounds.log) uses
`55141e0` versus `7caccb6`, three rounds, per-child locks and CPU 2. Conditioned
single-table medians are 400/420/411 versus 160/160/160 ns (median 411 to 160,
61.07% lower). These include timing overhead. The 100 ms of predefines work
before each of 21 samples is outside its table timer. Assembler init is .694/.784/.706 versus .816/.840/.780 ms
(median .706 to .816, 15.58% higher); that cost is unaccepted. Warm assembler
and backend observations remain in the raw log and do not prove neutrality.

The two default template spans are separated by a 2 MiB fixup bias. The
[symbol census](raw/template-layout.txt) shows the baseline assembler table at
`0x5408c80`, compact image at `0x5103600`, with storage extent `0x387880`.
The live relative ranges are `[0x40,0x187840)` and `[0x200040,0x387840)`.
They intersect two 2 MiB address regions in the baseline and three in the compact
image; the middle region is shared, so the latter is not four. The host's THP
setting is `always`. Address geometry alone does not establish physical huge-page
backing, causal startup cost, or peak residency.

- `e45630b46edb4984073c5e1d973b14738625987d` tried static 2 MiB alignment.
  The [ordinary installed Wild rejected it](raw/aligned-build.log),
  `Unsupported alignment 0x200000`. No executable was produced. The subsequent
  [three-tree screen](raw/ab-alignment-screen-3rounds.log) was mistakenly
  launched after that failed build: it has six missing-executable failures.
  Only its 551/7c controls ran. It is a failed campaign, not alignment timing
  evidence. Their median peak RSS is about 14,804 versus 16,864 KiB.
- `39635600e7a98af12e09c8a69460c905b9d56673` used one reusable aligned
  allocation per initialized unit. The [build passes](raw/allocated-build.log),
  but [three controlled rounds](raw/ab-allocated-screen-3rounds.log) reject it:
  init .765/.748/.603 versus .833/.836/.665 ms; sizing 12.62 to 12.66 and encoding
  17.78 to 17.84 reported instructions/entry. Fresh-process wall medians are
  1.380/1.393/1.385 versus 1.388/1.393/1.387 ms; median peaks 14,800/14,792/14,792
  versus 15,440/15,456/15,484 KiB. All 126 processes and 18 AB runs succeed.
  Rejected; no allocator or changed pointer enters the retained production code.
  The source-reviewed `template-storage-experiment.c` fixture belongs to
  unmeasured test-preparation head `88c3909`. It was not executed and
  does not qualify `3963560`. It is archived as an unretained experiment.

## Default-template reuse

`template-gs-reuse.c` compares every byte of two 3,700,864-byte storage regions,
poisoning gaps and padding before each of all five encoder modes. The default 64-bit
candidate builds base+FS, copies FS to GS, and patches the optional prefix in
both byte halves. Other modes keep the direct builder. Two independently
locked warm processes each pass five full-region comparisons and 21 rotating
passes of 25 initializations/sample:

| Process | Original ns/init | Reuse ns/init | Original instructions/init | Reuse instructions/init |
| --- | ---: | ---: | ---: | ---: |
| [1](raw/gs-reuse-r1.log) | 418119.4800 | 297298.8800 | 14243277.2400 | 9567270.1200 |
| [2](raw/gs-reuse-r2.log) | 420714.7600 | 301183.3600 | 14243277.2400 | 9567270.1200 |

This is an unguarded current-table prototype, not qualification of the final
guarded image. Production mirrors the FWAIT predicate exactly, verifies the
expected 0x64 in both byte halves before replacing it with 0x65, and falls back
to direct GS building otherwise. The continuous policy-owned test independently
builds all 25,056 raw forms and compares both original and fixup entries:
50,112 complete 64-byte comparisons, including unavailable/fallback forms.
No new allocation, changed table storage, mode change or hot-loop edit is retained.

## Current-head correctness and integration

The ordinary installed-Wild [optimized build](raw/gs-final-build.log) passes:
42 sources, 27.7 s, `BUSTER_DEBUG_INFO=0` with the repository's normal flags.
The baseline build takes 27.3 s in one observation. These single build times
are provenance, not comparative throughput acceptance.

[Current target checks](raw/gs-final-target.log) pass the 50,112 template entries,
513 policy configurations, all 65,536 encoded form values at six profiles,
7,872 admitted random records, 396 independent FMA forms/1,272 subset checks,
708 Clang/GCC feature-macro checks and actual native CPUID/XCR0. Live features
are `0x1fffffffffffffff`, Zen 5 detected. The 434 cached-admission configurations
agree with the uncached syntax predicate and full 64-bit scalar policy.

At baseline/v3/v4, each Tier 0 consumer audits 1,956 compiled templates and
96 functions/26,448 records, exact twins with zero depth refusals. Each Tier 1
profile passes 179,458 selection and 179,701 native-emission checks using both
covers/allocators. Native SSE/VEX/EVEX cases produce 40/40/41 bytes. VEX/EVEX
reject lower profiles; SSE is the baseline positive. All 26 complete Clang preambles match; bounded queries, option
order and tuning checks pass. GAS contributes 17,577 comparisons and 144
separately reported AVX512VL/FMA oracle gaps; the policy negatives still apply.

The [assembler cross-check](raw/gs-final-assembler.log) passes 1,873,795 checks,
zero failures, including GCC 16.2.1/Clang 23.1.1 at O0/O2, Intel/AT&T, ordinary
and separate sections, object comparison, execution and unwind.
The [recursion/state gate](raw/gs-final-call-graph.log) covers 42 units,
23,997 functions and 140,816 calls: zero unallowed cycles, three existing
allowed cycles and zero split variables.

The actual production compactness guard also has a fresh final-source
[positive control](raw/final-projection-positive.log) and
[negative overlay](raw/final-projection-negative.log), with exact commands and
captured exit codes in [the receipt](raw/final-projection-receipt.txt). Appending a known BF16
requirement to NONE fails compilation at the production assertion
`target requirement cannot be compacted: NONE`; positive exit 0, negative exit 1.
These execute against `ad08d94`. The earlier d84add4 diagnostic logs remain
historical; their missing command/status metadata is not relied on here.

Hosted CI remains distinct from the frozen manual pair. The development
[bed1ef6 run 40297372937](raw/ci-bed1ef6-run-40297372937.log) passed 80 of 81
commands; its state gate failed on seven split-state variables. The #424 owner's explicit handoff required the
entire target test in BACKEND; d84add4 applies that missed one-line routing.
[7caccb6 run 40299775512](raw/ci-7caccb6-run-40299775512.log) then passed 81/81,
55.0 s, on synthetic merge `8c7f8574` with main `85306065`. These are historical checks.

Current-head [run 40314222680](raw/ci-ad08d94-run-40314222680.log), job
121542705874, passes all 82 commands in 55.5 s, zero failed/not started.
Its synthetic merge is `697dd13b00c3ac724e77e6bbee3e74ce790f855f`, combining
head `ad08d94` with main `343c1d049b2ed4d51d4aad912ac0e51ac77eb09a`.
The hosted recursion/state gate has 24,193 functions/142,438 calls, zero
unallowed cycles, three existing allowed cycles and zero split variables.
Measurement-storage run 40314222772 also passes. CI benchmarks are integration
observations, separate from the frozen manual paired measurements.

The [full ASan/UBSan build](raw/gs-asan-build.log) passes all 42 units in
50.4 s. The [saved compile fragments](raw/gs-asan-compile-commands.json) each
include `-O1 -fsanitize=address,undefined -fno-omit-frame-pointer
-fno-sanitize-recover=all`, appended after ordinary flags. Fresh
[target checks](raw/gs-asan-target.log) and
[assembler cross-check](raw/gs-asan-assembler.log) both pass, including all
50,112 template entries and 1,873,795 assembler checks. Runs enable
`ASAN_OPTIONS=detect_leaks=1:abort_on_error=1` and
`UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1`; no sanitizer/leak error
occurs. The external Clang/GCC oracles use their ordinary, uninstrumented tools.

## Final frozen-image performance

All following comparisons use the actual `55141e0`/`ad08d94` images with
identical ordinary build flags, per-child exclusive locks and CPU 2. No
development prototype timing is substituted for these results.

The [15-round comparison](raw/ab-gs-final-table-assembler-15rounds.log) completes
60 runs with zero failures. Each table process reports the median of 21
single-table samples after 100 ms of predefines work outside each timer.
Each assembler process reports one cold initializer and 21 interleaved warm
passes on 256 functions/9,984 instructions/153,295 source bytes.
Table/warm statistics aggregate process medians; initialization aggregates one
cold observation per process.

| Metric | Main median (range) | Head median (range) | Change | Paired decreases/increases |
| --- | ---: | ---: | ---: | ---: |
| One vector table, ns | 411 (391–430) | 160 (151–161) | -61.071% | 15/0 |
| Cold assembler initialization, ms | .666 (.594–.764) | .587 (.519–.724) | -11.862% | 11/4 |
| Warm scalar assembly, ms | 3.641 (3.593–3.789) | 3.691 (3.675–3.906) | **+1.373%** | 1/14 |
| Warm vector assembly, ms | 1.469 (1.452–1.515) | 1.464 (1.454–1.486) | -.340% | 10/5 |

Initialization and warm-path ranges overlap. Initialization improves in the
aggregate, not uniformly. Warm vector observations do not establish a uniform
gain. The scalar reference path's repeated increases are **unaccepted**.
Every assembler case retains the 419,496-byte index, 17,503,712-byte arena and
76,064-byte emitted ELF. Cold initialization is not added to a warm-pass median
and presented as a measured end-to-end run.

The [three-round sustained/backend comparison](raw/ab-gs-final-hot-3rounds.log)
completes 18 runs, zero failures. Each sustained table process uses 21 samples
of 10,000 tables. Vector table medians are 314.74 to 130.70 ns without conditioning
and 409.26 to 128.80 ns after predefines. The scalar source remains independently
checked and is not the new compact vector algorithm.

The backend workload is 2,008 functions, 262,874 typed entries, 303,116 records,
1,171,371 bytes and 9,414 deferred entries at both revisions. Median ns/entry:

| Path | Main | Head | Change |
| --- | ---: | ---: | ---: |
| Vector selection | 14.44 | 14.37 | -.485% |
| Scalar selection | 42.14 | 42.13 | -.024% |
| Sizing | 1.11 | 1.11 | 0% |
| Encoding | .89 | .87 | -2.247% |

The reported retired instructions/entry remain 170.04/572.46/12.62/17.78 at
both images, at the benchmark's two-decimal precision. This is not a proof of
bit-identical instruction counts or broad compiler neutrality.
The separately built [instruction-counter controls](raw/final-policy-instructions-3rounds.log)
rotate image order over three pairs. Every process checks scalar/vector table
identity. Scalar counts are 6367.0219 instructions/table at both revisions;
vector counts are 6803.0217 to 2802.0215. These include amortized harness overhead.
The pinned original C helper reports full-reference size 66,816 bytes; the
additional 33,408-byte compact table is accounted for separately above.

The [whole-process comparison](raw/ab-gs-final-whole-5rounds.log) completes all
40 runs and 840 status-zero fresh child processes (five rounds, 21 children per
image/configuration), after [four successful preflights](raw/final-whole-preflight.log).
The unsigned-arithmetic source and frozen SQLite inputs are unchanged.

| Whole-process configuration | Main median ms (process-median range) | Head median ms (process-median range) | Change | Main/head median peak KiB |
| --- | ---: | ---: | ---: | ---: |
| Assemble one function | 1.371 (1.367–1.380) | 1.281 (1.277–1.283) | -6.565% | 14,792 /15,568 |
| Compile short C to object, verify twins | 2.682 (2.664–2.710) | 2.595 (2.591–2.630) | -3.244% | 37,712 /36,732 |
| Same compile after 100 ms scalar work | 2.672 (2.661–2.745) | 2.579 (2.576–2.644) | -3.481% | 37,704 /36,728 |
| Frozen SQLite, checking only | 148.152 (148.050–148.287) | 148.414 (148.303–148.832) | **+.177%** | 597,228 /596,208 |

All five paired process medians decrease for one-function assembly and each
short-compile condition; all five SQLite process-median pairs increase.
Individual child ranges overlap. The SQLite cost, one-function peak increase
of 776 KiB (+5.246%) and consistent minor-fault increases are **unaccepted**.
Other improvements do not approve these costs. Median minor
faults change 172→185 for one-function assembly, 518→534 for each short-compile
condition and 1427→1443 for SQLite; all major-fault counts are zero.
This SQLite run is syntax/semantic checking, not complete SQLite code
generation, execution or acceptance. The scalar conditioning is outside each
child's timer. All raw child observations, user/system times and extrema remain
available; these small synthetic compile results do not establish broad
whole-program throughput gains.


## Final binary footprint

The locked [binary/section/symbol census](raw/final-binary-footprint.txt)
records the actual images and Clang 23.1.1, GCC 16.2.1 and binutils 2.47:

| Bytes | Main | Head | Difference |
| --- | ---: | ---: | ---: |
| Executable file | 33,216,210 | 33,765,532 | +549,322 |
| .text | 18,346,470 | 18,775,797 | +429,327 |
| .rodata | 3,289,984 | 3,339,390 | +49,406 |
| .data.rel.ro | 10,813,744 | 10,855,904 | +42,160 |
| .bss | 240,239,521 | 236,591,009 | -3,648,512 |

This includes compiler, test and benchmark code and Clang's layout/inlining
choices; it does not attribute all growth to a production hot loop. The file
and code/data growth is disclosed for approval, not silently accepted.
The .bss size is zero-fill virtual extent, not resident memory; it does not
contradict the separately measured one-function peak RSS increase.
Default template-storage symbols decrease from 25 to 24 after the coordinated
backend test routing. Each storage symbol remains 3,700,864 bytes.

Named requirement arrays total **400,896 bytes in both actual binaries**:
main retains six full 64-bit arrays; head retains three full 64-bit plus six compact 32-bit
arrays. Clang eliminates unused scalar arrays in vector-only units. The
logical pair of tables still totals 100,224 bytes where both are retained;
this census does not turn that pair into a smaller representation.
The final assembler storage is at `0x5104700`, still intersecting three 2 MiB
address regions. Address geometry alone does not establish physical backing.

- Main executable SHA256: `7c42b3f7edd0d7a078a727880a399a1b667f74d97f9538c0089c81c41c1a632b`.
- Head executable SHA256: `85dbc678e2d93d2ea17deff82553a8f933a1a2a04a5dcc6943c93e0dd7543e69`.
- [Final source hashes and tree](final-source-sha256.txt) bind the implementation
  and tests to `ad08d94`.

The [read-only mapping diagnostic](raw/final-init-mappings.log) starts each
actual image under GDB and stops at `x86_match_initialize`, after encoder
initialization and before matcher writes. Both backtraces identify the
assembler command; `/proc` records tracing-stop state and the matching
TracerPid. The C observer finds exactly one matching inferior and reports
success after flushing its output. No debugger timing is used as performance
evidence.

| At that stop, KiB | Main | Head |
| --- | ---: | ---: |
| RSS of anonymous mapping containing the default templates | 4,096 | 6,144 |
| AnonHugePages of that mapping | 4,096 | 6,144 |
| Entire inferior VmRSS | 8,432 | 10,620 |
| Entire inferior RssAnon | 4,252 | 6,300 |
| Entire inferior RssFile | 4,180 | 4,320 |

This observes an additional 2 MiB of anonymous huge-page backing at that
specific point, consistent with the address-region geometry. It does not
attribute an elapsed-time percentage or substitute for the separately measured
whole-process peak RSS. No host THP, linker or allocator setting was changed.


## Frozen source corpus and generated programs

The [six source-corpus runs](raw/final-corpus-six-profiles.log) use c-testsuite
commit `5c7275656d751de0e68b2d340a95b5681858ed07` and the unchanged frozen subset.
Baseline/v3/v4 on both images each pass **220/220**, with zero unsupported,
failed or not-run cases. `--cross-check` compares direct/scalar output, executes
the programs and checks linking through the system compiler. The pinned
`profile-compiler.c` adapter injects one explicit ISA; raw commands record the
exact compiler path/profile for each invocation. These are fresh compile/
execution results, not an assertion that every emitted corpus object received
a complete external ISA audit.

The [final generated builds](raw/final-generated-build.log) compile the frozen
original unsigned-arithmetic program with `--verify` into both objects and
executables at baseline/v3/v4 for each image, and compile a fresh Clang
reference. The [validation suite](raw/final-generated-validation.log) passes:

- All six Buster executables return `14213000051299467171`, matching Clang.
- All six objects have SHA256
  `cf0bc0708b9f00a4319c6d8701ac79c2fb9aaf0affa66ee8c6683176bfefa47d`.
- All six executables have SHA256
  `4a81f4d5c91b7409b59f7343b520d0bd661e8270cfc4b5c8cb8bcdac84668259`.
- Every object's executable section is 161 bytes/50 instructions. Independent
  scalar/vector decoder records agree and every record passes the configured
  ISA/operand check. The supplementary FNV receipt is `d384614d5b244074`.
- The audit's self-test covers baseline/VEX/EVEX positives, lower-profile
  negatives, section gaps, truncated headers and invalid ranges.
- Each linked executable has text/data/BSS of 1,253/468/1 bytes. GNU size's
  object “text” of 167 includes six bytes of non-executable read-only data;
  it is not 167 instruction bytes.

The audit includes Buster-produced executable ELF sections. The linked CRT and
system-library code is foreign code outside that instruction audit. The
separate native SSE/VEX/EVEX policy fixtures force instructions at the three
levels; this integer runtime program alone does not exercise optional SIMD.

**Runtime evidence reuse is explicit.** The linked-executable SHA is identical
to the programs already timed on the approved host in the
[pinned historical report](https://github.com/buster14a/buster-performance/tree/85541498e98b254582c143bef3b5af49c098e611/docs/measurements/isa-policy-180-2026-10-25#generated-program-code-size-and-runtime).
That campaign has three paired processes per profile, each image run 21 times:
baseline process-median medians 2.029/2.032 ms, v3 2.028/2.029 ms, and v4
2.029/2.029 ms. Those observations are historical timings of these exact
program bytes, **not fresh ad08d94 timings**. Fresh generation, decoder audits
and executions above establish the identity boundary. There is no generated
program code change to time; repeating identical images would add process/
machine variation rather than qualify a new instruction stream. No runtime
speedup or broad runtime neutrality is inferred from the old timing samples.

## Commands, helper provenance and scope

All compiler builds use the repository's ordinary command:

```sh
BUSTER_DEBUG_INFO=0 EXCLUSIVE_OWNER=codex-180-opt ~/buster-fast-bench/exclusive.sh ./build.sh
```

The sanitizer C adapter appends the four recorded flags; all 42 compile entries
are saved. The actual host directories are
`/home/david/buster-fast-bench/codex-180-opt-20261026-main`,
`...-gs-final` and `...-gs-asan`. The source archives are exact Git trees,
with no source mutation after their build. Each functional command takes its
own ordinary lock; the generated-output validation is one bounded fixture suite.

The final paired controller is the baseline compiler, invoked outside an
outer lock so each child acquires it independently:

```sh
./build/compiler ab --rounds 15 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh \
  ../codex-180-opt-20261026-main ../codex-180-opt-20261026-gs-final \
  -- benchmark-x86-target --only avx512 --after-predefines 100 --iterations 1 \
  -- benchmark-assembler
```

The other AB raw headers preserve every expanded configuration and argument.
The hot campaign uses three rounds of plain/conditioned `benchmark-x86-target`
and `benchmark-backend`. The whole-process campaign uses five rounds of
`time-runs --runs 21`: one-function assembly, verified C object compilation
plain/after 100 ms scalar conditioning, and frozen SQLite checking with its
three pinned header directories. No lock spans that campaign.

The final original C helpers reuse the sources at evidence commit
`85541498e98b254582c143bef3b5af49c098e611`: `policy-instructions.c`,
`audit-elf.c`, `profile-compiler.c`, `sanitize-compiler.c` and `runtime.c`.
Counter/audit helpers use `clang -std=gnu17 -O3 -march=native -fwrapv
-funsigned-char -fno-strict-aliasing -Wall -Wextra -Werror -I FROZEN/src`;
the counter helper is built separately against each revision, the audit helper
against final source. The profile/sanitizer adapters and original
`snapshot-inferior.c` use `-std=gnu17 -O2 -Wall -Wextra -Werror`.
All helper builds and all executions use the approved host's lock.
No Python, imported implementation or new dependency was introduced.

## Independent source review

A separate read-only reviewer checked the marker equivalence, reserved bits,
complete syntax-cache key, delayed-role side effects, complete-index comparison,
mask concatenation order, bounds, tails and counter failure handling.
The alignment coverage finding is fixed in the current kernel helper and
production reserved-bit/sentinel test.
The retained compact projection, per-row compile-time guard, exact canonical
row extraction and guarded FS/GS initializer received independent source
review, including the full-entry oracle for ordinary and fixup copies.
The same reviewer checked all completed final-image statistics, command/status
receipts, sanitizer compile entries, current CI, corpus and footprint census.
The closing review also verified all generated-object/image identities and
fresh executions, the linked-image boundary for historical runtime reuse,
both stopped-inferior mapping receipts and whitespace-only prototype mirrors
against their exact archived source snapshots. No actionable source or
evidence correctness finding remains.
This is source/evidence review; the reviewer ran no compiler or measurements
and supplied no formal GitHub approval or performance exception.

For classified requirement `K | R`, `K=1ULL<<63` and `R&K=0`,
`((K|R) & (~features|K)) == K` iff `R & ~features == 0`.
Unknown zero rows always fail. Target reserved bits cannot change this result.
The scalar reference is unchanged. Syntax reuse compares every input read by
`x86_match_supported`: spelling pointer, family, vector length and encoding;
different pointers recompute even if their string contents are equal.

For mask packing, the second unpack argument supplies the low bits; the final
mask bit `8*j+k` represents lane `k` of group `j`.
The existing 8352-form count exercises a 32-row remainder of batch 64, but no
tail smaller than eight rows. That generic tail has source review rather than
execution coverage in this fixed-count probe.

## Acceptance status and ownership handoff

The original table, initialization and vector-backend costs are replaced by
the new frozen-current-main measurements above. Those paths now improve in
the reported comparisons. This does not approve the remaining costs:

- Warm scalar assembler reference: +1.373%, with 14/15 process pairs rising.
- SQLite checking: +.177%, with all five process-median pairs rising.
- One-function peak RSS: +776 KiB (+5.246%); minor faults rise consistently
  in the tested whole-process configurations.
- Executable +549,322 bytes (+1.654%), including .text +429,327 (+2.340%)
  and the disclosed read-only/data growth. The .bss virtual extent decreases;
  that is separate from measured RSS.

The proposed justification for considering these costs is concrete: this slice
adds fail-closed classification for current selector families and independent
negative coverage, keeps exact scalar references and all 16-byte records, and
reduces the measured table/startup/short-compile costs. That rationale is a
proposal, not the user's explicit approval. Other improvements do not approve
a regression. No existing acceptance threshold or tolerance is relaxed.
**PR 421 stays draft and unmerged until remaining costs are fixed or explicitly
approved.** No formal source-review approval or performance exception is claimed.

The production configured-target guard for Tier 0 and its C producer remains
with #136/#133. Existing stable interfaces remain:

* `x86_target_forms(&target, allowed)` builds X86_FORM_COUNT eligibility bytes once.
* `x86_target_validate(allowed, records, count)` returns the first invalid/
  unsupported record or count; use it at the final external/selector boundary.

Tier 1 already consumes the shared table. The independent Tier 0 tests do not
replace its production guard. Full builtin lowering (#148), function targets
(#147) and the new vector/intrinsic producer claim
[#136 comment 6414744497](https://github.com/buster14a/buster/issues/136#issuecomment-6414744497)
remain with their existing owners. All 6,741 unclassified canonical forms stay
denied, including on native; future families require explicit rows, feature
projection extension where needed and independent negative tests. This slice
does not close #180 or take integration/merge ownership.

All requested independent source changes and bounded validation are complete.
The closing handoff records the final evidence commit, review status and claim
release on #180 and #421. No compiler work was run locally, no new dependency
was added and no shared-host reservation or benchmark remains active.
