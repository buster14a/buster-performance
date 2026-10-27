# Bounded automatic initializers, issue #598

On the shared Ryzen 7 9700X, large automatic strings and dense constant numeric
arrays now use a readonly image and one target-libc `memcpy`. Code and backend
records stay bounded while source reading, checking and data remain linear.
The signed `int[40000]` reproduction compiles **17.4% faster** without stage
instrumentation, emits **96 bytes of text instead of 680,026**, and runs
**9.36× faster** in the repeated-call experiment below. Small generated objects
are byte-identical. Tiny-input compiler peak RSS rises by about 2 MiB; the
diagnostic snapshot records an extra 2 MiB anonymous huge page.

## Identities and conditions

- Issue: <https://github.com/buster14a/buster/issues/598>.
- Baseline: `92c025e71856d13eb34247477c5294d2cead139e`.
- Candidate: `b5b679adc6e89f4fd2c8e27231c8e0841955960a`.
- Both release builds: `BUSTER_DEBUG_INFO=0 ./build.sh`, Clang 23.1.1,
  `/usr/bin/wild` linker. Filtered build receipts are in `qualification/`.
- `source-{base,head}-tree.txt` record Git objects; `source-{base,head}.sha256`
  record all tracked source bytes used by the builds. Subsequent evidence-link
  documentation edits in the source PR do not change these measured C sources.
- Compiler SHA-256: baseline
  `cde1420d71e3099dea0682350c4eab1b015873bef2ba2a1bf79a60e8c64e9da8`;
  candidate `663b29e29cd567dd358d0a73c4403dbd1e15504654a3fb14b23407bf02fc3815`.
- `raw/cpu.txt`, `raw/toolchain.txt`, `raw/binaries.sha256`,
  `raw/inputs.sha256` and `raw/int-inputs.sha256` retain identities.
- Every target build, qualification and measurement held
  `~/buster-fast-bench/exclusive.sh`. Timings were pinned with `taskset -c 2`;
  the first-party qualification runner used CPUs 0–7 and at most eight CPUs.
  The host was heavily queued; queue waiting is outside all recorded timings.
  No host settings were changed for this experiment.

## Inputs and method

The original C helpers and generated inputs are included. `generate.c` emits a
local string or an **unsigned** array; `generate_int.c` emits the signed-int
reproduction from the issue comment. Each function returns the selected element
using `i % N` so every runtime query is defined. This adds an index operation
relative to the comment's unchecked `a[i]`; the resulting baseline text size
therefore differs from that earlier EPYC report.

- `string-N`: **N total array bytes**, N−1 repeating nonzero `a`–`z` letters and
  the NUL terminator. Totals 129, 513, 2049, 8193 and 32769 also cover exactly
  128, 512, 2048, 8192 and 32768 letters plus their terminator.
- `list-N`: N unsigned-int elements, `(i * 7 + 1) % 65536`.
- `int-N`: N signed-int elements, `i * 7 + 1`, with no wrap at 65536. This is
  the supplemental reproduction of the issue's brace-list comment.

`compile.c` launches a fresh process with
`COMPILER --lanes 1 [--time-stages] -c INPUT -o OBJECT`. It discards one warmup
pair, then keeps 11 pairs with alternating baseline/candidate order. Wall time
includes process creation and output; CPU time, peak RSS and exit status remain
in the raw CSV records. Per-process stderr retains the stage records.

`runtime.c` / `runtime_int.c` first check **every element** against an independent
formula, calibrate each variant to at least 5 ms, then retain nine alternating
timed blocks, warming each variant before its block. The reported time is the
median nanoseconds per call, including the indirect call and index operation.
This is a warm repeated-call experiment, not a cold-cache or application result.
DSOs are linked with `clang -shared -Wl,-Bsymbolic-functions`: object-mode unwind
references require binding the definition locally in this harness.

`stats.sh` and `int.sh` use `benchmark-backend-source --only encode` only for
typed-entry/machine-record counts. `.sections` files are from `size -A` and
`.disasm.gz` files are losslessly compressed `objdump -dr` output. Backend
microbenchmark timings are not the whole-compile numbers in this report.

`summarize.c` excludes warmups and failed compiles from timing medians, preserves
failure counts, and uses **−1 for missing measurements**. The summary files can
be regenerated from their raw logs and sibling per-process log directory.

## Whole-compile results without stage clocks

Medians of 11 successful samples, milliseconds; peak RSS is the median process
maximum in KiB. The ranges are the observed sample min/max, not confidence
intervals. `raw/default.*` and `raw/int-default.*` retain the samples.

| Input | Baseline ms | Candidate ms | Change | Baseline / candidate peak KiB |
| --- | ---: | ---: | ---: | ---: |
| string, 128 bytes | 1.486 | 1.497 | +0.7% | 22,060 / 24,016 |
| unsigned list, 32 elements | 1.495 | 1.496 | +0.1% | 22,084 / 24,000 |
| signed int, 32 elements | 1.505 | 1.514 | +0.6% | 22,124 / 24,064 |
| unsigned list, 512 elements | 1.781 | 1.686 | −5.3% | 28,568 / 28,264 |
| unsigned list, 40,000 elements | 19.479 | 15.290 | −21.5% | 141,200 / 122,992 |
| signed int, 40,000 elements | 18.676 | 15.428 | −17.4% | 137,544 / 125,072 |

For signed int[40000], the ranges are 18.459–18.762 ms baseline and
15.323–15.780 ms candidate. For string-128, they overlap substantially:
1.449–1.610 ms and 1.465–1.574 ms. These small differences do not establish a
small-case speedup or regression. The small-array native code and complete
object bytes are identical (`qualification/small-object-identity.txt`).
`default.sh` also checks that enabling stage clocks does not change object bytes.

The frozen SQLite whole-object control has a **small measured slowdown**:
145.195 → 146.469 ms (+0.88%), with observed ranges 143.948–145.726 and
146.063–147.233 ms. Peak RSS is 505,972 → 507,996 KiB. The preceding same-binary
A/A control is 145.056 → 145.348 ms (+0.20%); its individual pair ratios span
−0.76% to +1.46%. This control establishes no general compiler speedup: the
gain here belongs to programs that exercise the large-initializer producer.
`raw/sqlite-{aa,default}.{log,csv}` and their per-process logs retain all 11
pairs for each control. `sqlite.sh` records the frozen input, header paths,
preprocessor flags and deterministic environment; `raw/sqlite.sha256` pins
the source bytes. These runs compile the same source to an object, rather than
timing only the checker-corpus acceptance path. The resulting SQLite objects
are byte-identical, as recorded in `qualification/sqlite-object-size.txt`.

## Stages, generated size and runtime

Stage milliseconds are medians from the separately instrumented 11-pair runs.
Entries and records count the whole generated function, including the index
and return. Runtime is the median of nine samples in ns/call.

| Input / variant | lower ms | Tier 0 ms | encode ms | Entries | Records | Text B | Readonly B | Runtime ns |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| signed int[32], baseline | 0.025 | 0.005 | 0.002 | 246 | 158 | 790 | 0 | 6.281 |
| signed int[32], candidate | 0.023 | 0.006 | 0.001 | 246 | 158 | 790 | 0 | 6.281 |
| signed int[33], baseline | 0.025 | 0.005 | 0.002 | 194 | 125 | 601 | 0 | 6.935 |
| signed int[33], candidate | 0.023 | 0.005 | 0.001 | 14 | 23 | 96 | 132 | 2.380 |
| signed int[40000], baseline | 2.984 | 1.053 | 0.170 | 200,024 | 120,023 | 680,026 | 0 | 11,928.957 |
| signed int[40000], candidate | 0.886 | 0.016 | 0.002 | 14 | 23 | 96 | 160,000 | 1,275.092 |
| unsigned int[40000], baseline | 3.678 | 1.166 | 0.190 | 240,023 | 160,023 | 720,023 | 0 | 15,110.395 |
| unsigned int[40000], candidate | 0.839 | 0.016 | 0.002 | 13 | 23 | 96 | 160,000 | 1,785.358 |
| string-128, baseline | 0.020 | 0.004 | 0.002 | 166 | 127 | 666 | 0 | 5.344 |
| string-128, candidate | 0.019 | 0.005 | 0.001 | 166 | 127 | 666 | 0 | 5.363 |
| string-129, baseline | 0.021 | 0.005 | 0.002 | 114 | 94 | 471 | 0 | 5.870 |
| string-129, candidate | 0.019 | 0.005 | 0.001 | 14 | 24 | 100 | 129 | 2.741 |
| string-256, baseline | 0.021 | 0.005 | 0.002 | 184 | 152 | 827 | 0 | 10.466 |
| string-256, candidate | 0.019 | 0.005 | 0.001 | 14 | 24 | 100 | 256 | 2.427 |
| string-32769, candidate | 0.022 | 0.005 | 0.001 | 14 | 24 | 100 | 32,769 | 282.337 |

`raw/summary.csv` and `raw/int.csv` contain the entire series. Above the 128-byte
threshold, all measured candidate strings emit 100 bytes/14 entries/24 records;
all measured signed-int arrays emit 96 bytes/14 entries/23 records. The threshold
is payload **strictly greater than** 128 bytes. Total data stays linear in N.

The baseline fails **all 11 compiles** for string totals 512, 513, 2048, 2049,
8192, 8193, 32768 and 32769 with `code output capacity exhausted`. Those are
failure observations, not zero-time compiles, and no baseline runtime speedup
is claimed for them. For runtime only, `runtime.sh` substitutes a clearly
labelled **Clang -O0** control where the baseline cannot compile. At 32769 bytes,
Clang's control takes 272.302 ns versus candidate 282.337 ns; neither this nor
the other Clang comparisons establishes a general Clang advantage. Candidate
instrumented whole compile at that size is 1.791 ms.

## Memory, implementation boundaries and qualification

Small inputs have roughly 2 MiB higher peak RSS. `rss_probe.c` captures smaps at
process exit under a diagnostic preload; it is **not used in timing samples**.
The baseline's anonymous BSS mapping has 8,192 KiB of `AnonHugePages`, candidate
10,240 KiB. The BSS starts 16 KiB later and grows by 64 bytes in this executable
layout (`raw/{base,head}-sections.txt`). The snapshot accounts for the extra
huge page; it does not establish an input-independent allocator cost. The
measured peak-RSS increase remains a cost of these candidate binaries.

The constant plan is serialized in source order, preserving designated
overrides. Omitted trailing zero storage uses the existing bounded fill loop.
Mixed runtime plans keep ordered writes and pool only their individual large
literal parts. Volatile objects/parts, omitted volatile members, bit-fields,
address relocations, and sparse prefixes with more holes than payload keep
their existing lowering. Pools are prepared before function lanes and receive
deterministic symbols. This does not add content deduplication between plans.
The copy uses the target C runtime's ABI and implementation; it introduces no
wider generated ISA requirement. No standalone libc copy routine is imported.

The final candidate binary passed:

- Focused initializer semantic/native/Clang regressions: **645 checks**.
- Complete checker, including the focused fixtures: **267,766 checks**.
- Tier 0 native and Clang cross-checks: **234,706 checks**.
- Function-lane identity and resource rollback: **2,753 checks**.
- Driver in ordinary and lazy-header modes: **21,591 checks each**.
- Deferred checker: **1,096 checks**, 69 fixtures, no failures.
- Call graph: 41 TUs, 23,964 functions, 143,478 calls, no forbidden cycles or
  split variables; three explicitly allowed pre-existing cycles.
- Frozen SQLite semantic/symbol/deferred corpus: 2,608 bodies, no differences,
  no unexplained symbol differences, accepted by both Buster and Clang.
- Pinned c-testsuite `5c7275656d751de0e68b2d340a95b5681858ed07`: **220/220**,
  native/scalar/vector/object/Clang cross-checks.

The initial 10-command batch reports **9 passed / 1 failed** because the build
removed its downloaded c-testsuite directory. After fetching the exact pin,
the standalone rerun passed all 220; both receipts are retained. The batch must
not be described as initially green. The focused tests include threshold and
odd-tail strings through 32769 total bytes, embedded NUL/truncation, wide UCNs,
partial zeros, packed unaligned members with side effects, 64-byte alignment,
designator overrides, evaluated and `sizeof` compound literals, volatile and
sparse exclusions, matching scalar/vector images and bounded entry/code size.

## Reproduction and provenance

Place the archived baseline/candidate as `../base` and `../head` next to a copy
of this harness directory on the approved 9700X. From that directory, under the
shared lock and CPU affinity, run `setup.sh`, `round.sh`, `stats.sh`, `default.sh`
and `int.sh`. Save stdout for `round.sh` to `round.log` and for `int.sh` to
`int.log`; the signed-int summary reads the latter after the sampling. Then run
`./summarize round.log logs` (or the combined resumed log) and
`./summarize default.log logs-default`. Regenerate summaries before compressing
disassembly. The scripts record all command flags.

The first `round.sh` reached the DSO link with the unwind-locality flag missing;
all compile samples were complete. `runtime.sh` resumed just that phase with
`-Bsymbolic-functions`, then `stats.sh` completed. `raw/round.status` therefore
remains 1 and `raw/runtime.status`/`raw/stats.status` are 0. `raw/combined.log`
joins the original compile log and successful runtime log for summarization.

An earlier SQLite timing attempt passed Clang's `--no-default-config` to the
Buster driver, which rejects that option before reading input. All samples in
that invalid attempt failed and are excluded from the performance results;
`raw/discarded-sqlite-unsupported-option/` retains the records. Removing that
oracle-only option from the wrapper produced the successful A/A and A/B
whole-object controls above. This required no compiler source change.

All new helpers and fixtures are original material under Apache-2.0 WITH
LLVM-exception. Clang, binutils and glibc are external build/runtime/oracle tools;
their implementation is not incorporated. The frozen SQLite and c-testsuite
sources/headers are external qualification inputs, represented by pins/hashes
and result logs here, not vendored source. The source tree manifests identify
compiler inputs and do not import their contents or change their licenses.
