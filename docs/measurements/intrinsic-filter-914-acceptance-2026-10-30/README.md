# Current-head acceptance for Buster's intrinsic negative filter

This packet addresses the actual remaining criteria in [Buster #893](https://github.com/buster14a/buster/issues/893): lower user-cycle cost in intrinsic setup and its caller-attributed `memcmp`, with the pinned c-testsuite small-unit corpus checked. It follows [source #914](https://github.com/buster14a/buster/pull/914)'s current-main integration; it does not reuse historical standalone helper timings as acceptance evidence.

| Role | Source | Original executable SHA-256 |
| --- | --- | --- |
| Unfiltered current-main baseline | `d12fd5831f9c73bb7b30505da2ce9616e915143e` | `e0bbf2ced14fc4bb38c2073887b0fac5f8bf694789f8c9d71b726db8f292f7bf` |
| Filter candidate | `58b1191558fbef0b542cbe92b1e2da329f16d7b6` | `67d5039a94d367f1d8f9b61ace82fb0b9b0ad699d5360bb4979367c247d85c75` |

Both are ordinary unmodified ELF executables built with Clang 23.1.4, production `-O3 -march=znver5 -fwrapv -funsigned-char -fno-strict-aliasing`, no debug information, and Wild 0.11.0. Their exact compile arguments, symbol maps, hashes and licensing notices accompany the original binary archive. The candidate additively merges main; its only conflict was concurrent provenance insertions, both preserved. Its diff to the baseline retains exactly nine intended filter paths, +626/−1. Independent composition review found no introduced issue.

## Current correctness and certification

Candidate head `58b11915` passed [CI 41071125153](https://github.com/buster14a/buster/actions/runs/41071125153): both hosted complete-correctness configurations, baseline emulation, complete native vector correctness on Ryzen 7 9700X, and the qualification gate. Plain-PR fuzzing is intentionally skipped. Local supported-toolchain checks also pass: catalog 77,820; intrinsic types 1,354; x86 builtin rules 5,808; vector program fixtures 10,793; zero failures in each, with unavailable-feature native skips explicit. Generator reproduction is byte-identical; production assembly retains SIMD key mixing and no bitmap gather.

David [personally certified the original contributions through this exact head](https://github.com/buster14a/buster/pull/914#issuecomment-6525208438) under DCO 1.1 and the original/component-specific submission terms. No commit was rewritten or backdated. The new source integration is signed under the existing opted-in compiler policy; this performance packet does not invent a human sign-off.

## All 220 pinned small translation units

Both matched compilers passed the complete c-testsuite subset at commit `5c7275656d751de0e68b2d340a95b5681858ed07`: **220/220 each**, zero unsupported, failed or unrun cases. The same candidate harness and official Clang 23.1.4 oracle check scalar/vector executable byte identity, expected runtime output/status, object/readelf/link/run behavior and emitted symbols.

The timing campaign includes every pinned unit, from 26 through 17,179 source bytes, rather than selecting favorable cases. Existing `time-runs` collects three rounds plus one warm-up, one copy, both sources in rotating order, pinned to CPU 2 under the shared host lock. All **1,320 measured compiler processes** succeed; all 660 matched unit/round pairs have positive user PMU cycle/instruction counts. The strict original C aggregate rejects missing, duplicated, failed, uncounted, signed and overflowing records. Negative controls and raw per-file results are retained under `corpus/`.

| Round | Base total user cycles | Candidate total user cycles | Change | Base summed process wall ms | Candidate summed process wall ms |
| --- | ---: | ---: | ---: | ---: | ---: |
| 1 | 1,111,475,537 | 1,106,816,554 | −0.4192% | 403.760 | 371.841 |
| 2 | 1,107,081,843 | 1,101,995,234 | −0.4595% | 402.488 | 370.501 |
| 3 | 1,107,807,777 | 1,104,576,962 | −0.2916% | 398.128 | 370.827 |

Instructions fall about 0.2597% in each round. Per-unit three-sample median cycles are lower in 142 units and higher in 78, ranging from −5.6350% to +5.3604%; every row is retained. This is not a universal no-regression result. Summed process wall time falls 6.8573–7.9473%, but it is neither the batch's elapsed duration nor a change attributable solely to the filter. Printed wall values have one-microsecond precision. One copy and three rounds do not establish placement robustness or corpus-wide compiler throughput.

## Actual cycle profiles and the measured work boundary

The frozen SQLite compile uses the recorded input/predefines hashes and flags. Three independent profiles per source each contain **30 fresh successful compiler processes**. Source order reverses for pair two. Recording uses one `cycles:u` event, period 250,003, a 4,096-byte user-stack snapshot, measured compiler CPU 2 and recorder CPU 3, under the same exclusive host lock. These are **period-weighted sampled-cycle estimates**, not exact accumulated function counters; unsampled end residuals and sampling uncertainty remain.

Before `perf` starts recording, the command uses `env -i` with only `HOME=/home/david`, `PATH=/usr/bin:/bin`, `LC_ALL=C` and `LANG=C`. No inherited session environment, `BASH_ENV`, preload or credential variable reaches the recorded shell/compiler startup. Only six explicitly named safe captures are eligible for publication; old inherited-environment controls are excluded. A quiet credential-pattern gate is additional checking, not the basis of this minimal-environment guarantee.

The original third candidate capture lost 33 samples, reported both as LOST and LOST_SAMPLES for the same underlying loss. It is rejected; these forms are not summed to 66. Both sides of pair three are replaced with the same explicit one-MiB writer-buffer setting. The old loss-free baseline partner is also excluded to preserve protocol matching. No system limit or governor was changed, and retry selection is based on the loss gate, not the performance result.

`family-callsite-audit.txt` establishes equal work despite outlining:

- Baseline `check_input_intrinsic_initialize` contains the complete batched search, 11 static `memcmp` call sites, two `memset` call sites and the stack-failure path.
- Candidate initialization calls its outlined `check_input_intrinsic_lookup` at only two sites. The lookup contains all key/filter/search work, its two `memcmp` call sites and the stack-failure path. SIMD mixing is inlined there. The separately emitted filter test copy is not a production callee and is not counted.
- Direct family primary IPs therefore cover initialization and all catalog lookup/filter body work in each source. Caller-proven `memcmp` is reported separately. Other libc callees, nonuser/skid samples, empty/truncated chains and unknown coverage remain explicit. Their sum is not labeled the complete inclusive initializer interval.

The bounded original C reader joins the **unfiltered compiler primary-event stream**, its CFI chains and raw perf records by ordinal, PID/TID, IP, time and period. Timestamp-sorted COMM/MMAP2 metadata establishes sample-time compiler role and libc bias across `taskset`→compiler exec; pre-exec samples are excluded rather than assigned the final process role. Each profile must contain 30 distinct sampled compiler PID/TID pairs and the full six-profile grid must be present.

Every direct-family sample proves the actual ELF CFI CFA and saved return address against captured stack bytes and the displayed parent call site. A libc sample attributed to this family must additionally prove its CFI return to a family call site and the machine-code chain `E8` → PLT `FF25` → GOT relocation naming `memcmp`. This binds private libc IFUNC implementations by their real caller; no global `memcmp` count or symbol-name guess is used. The reader rejects target CFI/return/call failures, malformed captures and nonzero loss/throttle records. Raw/pretty event accounting and coverage sidecars are retained.

All six accepted profiles pass the raw loss/throttle gates and decode without stderr diagnostics. Every direct-family sample has a valid CFI/actual-return proof; every attributed `memcmp` has the exact machine-call/GOT proof. There are no user-primary/unwound-leaf mismatches or complex libc-from-family chains in the accepted grid.

| Pair | Base family samples | Candidate family samples | Base proven `memcmp` samples | Candidate proven `memcmp` samples | Family change | Proven `memcmp` change |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | 561 | 429 | 132 | 23 | −23.5294% | −82.5758% |
| 2 | 574 | 430 | 109 | 20 | −25.0871% | −81.6514% |
| 3, matched larger buffer | 561 | 427 | 124 | 23 | −23.8859% | −81.4516% |

| Pair | Base family estimated Mcycles/compile | Candidate family estimated Mcycles/compile | Base proven `memcmp` estimated Mcycles/compile | Candidate proven `memcmp` estimated Mcycles/compile | Combined targeted change |
| --- | ---: | ---: | ---: | ---: | ---: |
| 1 | 4.675 | 3.575 | 1.100 | 0.192 | −34.7763% |
| 2 | 4.783 | 3.583 | 0.908 | 0.167 | −34.1142% |
| 3 | 4.675 | 3.558 | 1.033 | 0.192 | −34.3066% |

The combined row is specifically direct initialization/lookup/filter body work plus its proven `memcmp` calls. It excludes other callees and is not a complete inclusive initializer interval. Other immediate libc-from-family samples range 18–25 per profile and are retained separately. Global unknown coverage includes 14–22 empty USER chains, 0–2 short libc chains and 175–190 nonuser/skid primary IPs per profile. None is silently reassigned to the target categories. These counts and the individual target proofs permit review of what was and was not attributed.

The repeated period-weighted estimates show the requested cycle reduction in both the equal-work function family and its actual `memcmp` callers. Sampling counts, three profiles and 90 fresh compiler processes per side, and the recorded controls support that bounded conclusion; they do not establish exact function counters, a complete inclusive interval, or arbitrary future-workload behavior.

## Offline decoder compatibility and binding

The original Wild ET_EXEC binary has different `PT_LOAD` virtual/file deltas. Perf/libdw's module lookup can re-report the same ET_EXEC file using `map.start − map.pgoff`, then reject its duplicate module for overlap and drop even valid leaf C frames. The source-specific offline adapter reuses only an already reported same-name, same-file ET_EXEC module containing its actual entry point. Other names, files, descriptors, ET_DYN modules and first registration delegate unchanged. It changes neither measured ELF bytes, original build-id notes, code, CFI nor raw perf records; modified decoder copies are not executed as compilers.

The original wrapper, controls and exact commands are retained. Its explanation cites the [pinned perf implementation](https://github.com/torvalds/linux/blob/f2effca1ef5d30b1ead61d74faea5e251f604a26/tools/perf/util/unwind-libdw.c). Reference upstream implementation and external runtime ELFs are not copied into this repository. Runtime package identity and exact libc/loader hashes identify the local CFI inputs; obtain matching bytes and verify them before reproduction.

Final decoder/wrapper/aggregate source, build commands, executable/shared-object identities and execution receipts are frozen before the final offline analysis pass. Current hashes are not represented as identities of earlier runs. `analysis/final-analysis-receipt.txt` records the fresh serial six-profile analysis, with all pre-analysis identities checked unchanged afterward; `bindings/corpus/execution-receipt.txt` binds the fresh complete 660-pair reaggregation and eight controls.

The [raw capture and measured-executable release](https://github.com/buster14a/buster-performance/releases/tag/intrinsic-filter-914-acceptance-2026-10-30-58b11915) contains exactly six accepted minimal-environment perf captures and the two original compiler executables with licensing notices and compile arguments, about 101 MiB compressed in total. `release-assets.sha256` is the explicit seven-asset whitelist. Old inherited-environment captures and both rejected third-pair files are absent. External runtime ELFs are not packaged. The repository retains compact target proofs, full control/coverage summaries, exact metadata and hashes instead of oversized binary blobs.

## Scope of acceptance

Independent source, measurement and final six-profile reader review found no remaining blocker in the recorded scope. The actual #893 criteria are satisfied at the measured head: intrinsic tables/objects retain scalar/vector identity, intrinsic/corpus correctness passes, user-cycle estimates for the equal-work family and its caller-proven `memcmp` fall on the 9700X, and every pinned c-testsuite small unit has been checked and timed. The source is suitable to leave draft, subject to the normal live repository preflight and merge review. This packet performs no PR merge and makes no universal whole-compiler speedup or no-regression claim.

Current main subsequently advanced to `6dec2ca0aee070ed8e523d3d79f0cd140598809d` by merging the separately qualified value-storage, label-capacity and LICM PRs. A clean prospective composition of this source head with that main produces tree `6f7d18df8a9d115c81b4e5ebfc18e757d894a097`; none of the nine filter paths or its catalog/name-initializer inputs is changed by that advancement. This is a static composition check, not a relabeling of the recorded `d12fd583`/`58b11915` timing as measurements of the prospective tree.

This decision uses only the bound actual-cycle and complete pinned-corpus packet here. The separately owned [historical #140 editorial correction](https://github.com/buster14a/buster-performance/pull/140#issuecomment-6525890686) preserves the missing historical standalone-helper binding caveat. This follow-up does not claim to repair that historical identity with newly observed or rebuilt helper hashes, and no historical standalone helper number is needed for the current decision.
