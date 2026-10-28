# Fail-closed DF/UMC qualification receipts

This bounded follow-up to [performance #49](https://github.com/buster14a/buster-performance/issues/49) reproduces the published finite DF/UMC disagreement and adds original offline C tooling for CPU, recorded PMU/catalog exposure, reported duty, scope, units and arithmetic checks. **There is no reviewed client event/unit allowlist yet: the tool always rejects physical-bandwidth acceptance.** Its conditional arithmetic does not resolve the vendor mapping.

No hardware collection, host setting change, vendor installation, uProf license acceptance, or target access occurred. Historical collector/evidence bytes are unchanged. Implementation and tests started at performance main `dc37955dea61a6eb07bd86f222c96c5ad979cefa`. Publication advances the branch to current main `fe69c3e919cd0b1d849a89b4f43a054311f00b41`, with the same frozen input and tool-source bytes; it contains only this new issue folder and does not inherit the compiler batch or [profile-reader PR #65](https://github.com/buster14a/buster-performance/pull/65).

## Reproduction before implementation

The initial reproduction used the original publication's stat streams, before policy implementation. Their bytes match publication commit `e2377fd2d3d01e8c89efc8b68e7b2acc3444e7bd`. The original Buster revision is `92c025e71856d13eb34247477c5294d2cead139e`. [Input identities](raw/fixture-identities.json) bind the CPU/catalog/workload/stat/error inputs; the [initial reproduction](raw/initial-reproduction.json) retains the independent calculations.

| Control stream | DF printed MB/s | Same-stream UMC read MB/s, conditional | Same-stream UMC write MB/s, conditional | DF / same-direction UMC |
|---|---:|---:|---:|---:|
| Read metric | 85,075.956450 | 31,654.565246 | 19,430.601804 | 2.687636232 |
| Write metric | 0.008409 | 31,553.060998 | 19,372.279044 | 0.000000434074 |

Each stream contains its DF direction, both read/write counters from both UMC instances, and `duration_time`. The calculations use **only that stream's** counters and times. They never pair DF reads from one execution with UMC counts from another or add different executions into a traffic budget.

Conditional UMC arithmetic exactly reproduces the published `64 * (UMC0 + UMC1) / 1e6 / seconds`, separately for reads and writes. Its denominator is the maximum of the four UMC `event-runtime` values: 3.202164608 seconds in the read control and 3.211793630 seconds in the write control. That 64-byte assumption is preserved for reproduction; the public-document research below does not independently validate it for this client. It must not be promoted to newly verified physical bandwidth.

The DF expressions sum twelve channel aliases on this two-controller client. The read result also exceeds the original investigation's dual-channel DDR5-5200 theoretical 83.2 GB/s ceiling. Those are qualification warnings, not proof of which driver, table, expression, hardware selection or applicability rule caused the discrepancy. The gate does not infer validity from a ratio near one or use the ceiling as a substitute for event semantics.

The [archived command](../microarchitecture-9700x-2026-10-27/method/df-umc-check.sh) runs one DF metric plus four UMC events in a single `perf stat -a -C 0-7 -j --metric-no-group` execution around 64 successful full SQLite compilations, using eight one-lane processes. These are system-wide uncore observations, not inherently compiler-only counters. A shared benchmark lock does not remove background traffic or prove identical hardware counting scopes.

## Exact-client vendor boundary

The issue's decimal family/model `26/68` means **Family 1Ah, Model 44h**, stepping 0. It must not be confused with Model 68h or Models 50h–57h.

AMD's public [PPR 57896 archive](https://www.amd.com/content/dam/amd/en/documents/processor-tech-docs/programmer-references/57896.zip), revision 3.00, August 28, 2024, covers Model 44h Revision B0. Its printed pages 118, 231 and 237 were visually checked. It describes CPUID UMC/DF counter discovery and the control register fields: DF has a 15-bit event selector and 12-bit unit mask; UMC has an 8-bit selector, read/write mask at bits 9:8, and enable bit 31. Mask 1 suppresses writes; mask 2 suppresses reads. UMC bits 30:10 are reserved in this revision.

The inspected public revision does **not** establish the DF DRAM selectors/unit table, the meaning of UMC selector `0xA`, or an unconditional 64 bytes per CAS rule. Matching control-register structure does not validate an event's meaning. The captured perf catalog's names, descriptions and expressions are provenance for what perf exposed, not independent AMD validation of those selections.

AMD PMC document [69163](https://docs.amd.com/api/khub/documents/eVy1a6TkWTouOo3krvItTA/content), revision 1.00, December 12, 2025, describes CAS selector `0xA` and request-size filters for **Models 50h–57h**. It cannot fill Model 44h's gap: the relevant additional filter positions are reserved in the inspected Model 44h document. No encoding or byte conversion is transferred from that different model.

The [uProf 5.3 supported-platform list](https://docs.amd.com/r/en-US/57368-uProf-user-guide/13.2.-Supported-Platforms) and [hardware-counter list](https://docs.amd.com/r/en-US/57368-uProf-user-guide/13.3.-Supported-Hardware-Counters) give tool-support context. They do not establish the requested raw event semantics. Its [limitations](https://docs.amd.com/r/en-US/57368-uProf-user-guide/13.7.-Limitations) warn about some Family 1A outbound/xGMI metrics; that warning does not identify this issue's cause. The server-only note in the EPYC Pcm metric section is not generalized into a claim that every client UMC interface is unsupported.

[Vendor findings and document identities](raw/vendor-findings.json) record exact scope, links, revision and hashes. The public ZIP SHA-256 is `5ffaa95d1d4438afa79f8fb025f712efb29bfcbb0d0711d85df60c5151da7288`; its PDF is `643cae09d0bdae788ab090c0c4185168482b424e79f9feeced3f14c6de1817e5`. The archive/PDF remain scratch research inputs and are not incorporated into Git. No claim is made that every possible public or restricted AMD document was exhausted.

## Machine-readable qualification contract

[method/uncore_preflight.c](method/uncore_preflight.c) consumes preserved metadata and counter files. It is an **offline evidence preflight**, not live PMU discovery or a collector. New consumers must invoke it explicitly; archived collectors and reports are not rewired. [raw/final-preflight.json](raw/final-preflight.json) is the final complete receipt, with exit **1**, empty stderr, and `accepted: false`.

It checks:

- Exact recorded vendor, architecture, SKU string, decimal family/model/stepping; absent, mismatched or duplicate identity fields cannot match the policy.
- Both UMC instances' expected names and `event=0xa,rdwrmask=1/2` encodings, all twelve DF direction aliases and their published encodings, and both complete metric expressions/scale units. Missing or changed catalog entries reject comparison qualification. This proves recorded exposure consistency, not current sysfs availability, CPUID active-controller masks, or vendor event applicability.
- Seventeen unique rows per control: four UMC events, twelve expected DF direction events, one software duration event, and exactly one correctly named MB/s metric attached to a DF event. Unsupported, absent, malformed or unusable values remain explicit.
- Reported 100% on required PMU rows, positive usable runtimes, correct empty count units, the duration event's known empty-unit/runtime-1 format, a complete error-free workload record, its expected direction/CPU cohort, and consistent byte/task counts.
- PMU runtime spread, raw duration count and workload wall time agree within an explicit **1% sanity envelope**. This is a conservative policy for these long frozen controls, not a universal perf timing guarantee or proof of simultaneity. The actual `perf stat` collector command and bound input provenance establish the historical association. A self-consistent forged stream is outside this trusted-evidence boundary.
- The printed DF metric agrees with its same-stream counter arithmetic to absolute `1e-6 MB/s`, matching its printed precision. A changed metric owner, unit, denominator or population cannot silently qualify a comparison.

The software `duration_time` raw value is nanoseconds in the inspected perf 7.2.9 source. [`rdclock()`](https://github.com/gregkh/linux/blob/5fce161649b4d779d1b76d9fcd52dc77779774b8/tools/perf/util/time-utils.h#L43) supplies nanoseconds, [the tool PMU](https://github.com/gregkh/linux/blob/5fce161649b4d779d1b76d9fcd52dc77779774b8/tools/perf/util/tool_pmu.c#L660) counts those deltas, and [metric evaluation](https://github.com/gregkh/linux/blob/5fce161649b4d779d1b76d9fcd52dc77779774b8/tools/perf/util/stat-shadow.c#L107) converts them to seconds. [raw/perf-duration-provenance.json](raw/perf-duration-provenance.json) records that source attribution. This is consistent with the historical package version; it is not binary-to-source attestation of the original recorder.

`pcnt-running` is preserved as a **reported percentage**, not an independently available enabled/running tuple. `reported_full` means the formatted value is exactly 100; it is not additional proof of exact hardware duty. Exact decimal checks prevent a fractional count or a value just below 100 from becoming an integer/full duty merely because conversion to double rounds it. Qualifying count/duty syntax is nonnegative fixed decimal; exponents remain observed values but do not qualify. Counter integers and sums must fit the exact double-integer range. Raw scalars remain available even when comparison arithmetic cannot be used.

Each observation keeps orthogonal measurement, duty, applicability and acceptance facets:

| Observation | Retained state |
|---|---|
| Finite DF metric with reported 100% duty | `finite`, `reported_full`, applicability `unvalidated`, accepted false |
| Genuine measured zero | `measured_zero`, finite value 0 |
| `<not supported>` / `<not counted>` | `unsupported` / `not_counted`, finite value null |
| Missing field / JSON null | `missing` / `null`, finite value null |
| Quoted NaN/Infinity / numeric range failure | `nonfinite` / `out_of_range` or `invalid`, never zero |
| Zero ratio denominator | Ratio null, explicit `zero_denominator` |
| Empty stat output plus LLC collection failure | Empty input, separate `collector_reported_unsupported_event` log evidence |

The final receipt includes the original generic backend unsupported event, remote-latency zero counters with NaN metric, and empty generic LLC stream plus its exact failure-log bytes. These are separate observations; no missing row is synthesized as zero. Failure-log bytes are hex-encoded without guessing their text encoding. Additional observations never acquire semantic acceptance.

All acceptance fields remain false because the current program contains **no verified client event/unit allowlist**, and accepts no input flag that can declare one. `qualified_comparison_inputs: true` permits only the explicitly conditional arithmetic in its enclosing object. It must not be consumed as `accepted_for_physical_bandwidth`, which remains false. The UMC conversion and DF mapping need authoritative exact-client validation or separately reviewed calibration evidence before this policy can gain an accepting path. The originating discrepancy remains unassigned, and #49's vendor qualification portion remains open.

## Build and replay

A Linux GCC/Clang-compatible C11 compiler, libc and libm are sufficient. The code has no imported parser, implementation or dependency. From this folder, use an external scratch directory:

```sh
cc -std=c11 -O2 -g -Wall -Wextra -Werror method/json.c method/uncore_preflight.c -lm -o /scratch/uncore_preflight
cc -std=c11 -O2 -g -Wall -Wextra -Werror method/json.c method/preflight_test.c -lm -o /scratch/preflight_test
cc -std=c11 -O2 -g -Wall -Wextra -Werror method/json.c method/json_test.c -lm -o /scratch/json_test
cd /scratch
./json_test
./preflight_test /scratch/uncore_preflight /absolute/performance/docs/measurements/microarchitecture-9700x-2026-10-27
```

Replay the frozen control with paths beneath that historical measurement directory:

```sh
cd /absolute/performance/docs/measurements/microarchitecture-9700x-2026-10-27
/scratch/uncore_preflight \
  --cpu hardware/9700x-lscpu.json --catalog hardware/9700x-perf-list-uncore.json \
  --read raw/9700x/df-umc-read.perf.json --read-work raw/9700x/df-umc-read.work.json \
  --write raw/9700x/df-umc-write.perf.json --write-work raw/9700x/df-umc-write.work.json \
  --observe raw/9700x/metric-isolated-010.perf.json \
  --observe raw/9700x/metric-isolated-074.perf.json \
  --observe raw/9700x/metric-isolated-075.perf.json \
  --failure-log raw/9700x/metric-isolated-075.log > /scratch/receipt.json
```

Use `cores -n 2` with a task title/link around each local build, test and replay on the shared workstation, as all runs here did. Exit 1 means the completed receipt is rejected/unvalidated; exit 2 means invalid invocation or detected output failure. There is currently no exit-0 accepting path. Input-file/JSON failures are represented explicitly in the rejected receipt. Missing or incomplete JSON output never qualifies evidence.

Inputs are bounded stable regular files, at most 16 MiB each. Counter streams retain at most 256 roots and reject comparison qualification beyond that bound. The strict original [JSON module](method/json.h) bounds depth, strings, numeric magnitude and tokens; rejects malformed/truncated syntax, duplicate decoded keys and invalid UTF-8/escapes/surrogates; and preserves explicit null and quoted status strings. At most 16 additional observation streams and 16 failure logs are allowed; failure logs are bounded to 64 KiB.

Optimized and ASan/UBSan JSON checks pass **1,866/1,866**. Policy controls pass **425/425** in both modes (sanitized policy/parser tools, optimized test driver). They cover the frozen rates, CPU/PMU/encoding/expression mismatches, absent/unsupported/nonfinite/null/zero data, precision traps, missing/partial/excess duty, timing/unit/owner/scope errors, independent read/write roles, malformed/truncated/duplicate data, missing files and nonblocking FIFO rejection. Independent static reviews found and corrected the decimal-rounding, metric-owner, interval and duration-unit gaps before this freeze. [raw/tests/](raw/tests/) retains actual counts and logs; [raw/review.txt](raw/review.txt) records review scope and limits.

[RAW-SHA256SUMS](RAW-SHA256SUMS) identifies all committed receipts; [source/tool identities](raw/source-and-tool-identities.txt) and [commands](raw/commands.json) identify the local validation. The code and original reports use Apache-2.0 WITH LLVM-exception. AMD/Linux documentation was consulted as specification/provenance only; no implementation source, vendor PDF, perf executable, or license-gated tool is incorporated.
