# Unused libgcc_s cost, #489

This qualifies the remaining performance item of [Buster #489](https://github.com/buster14a/buster/issues/489), after #511 added the library and the initial paired record demonstrated a no-import regression. It compares the historical #483 runtime, the immediate baseline, and the completed change on the physical Ryzen 7 9700X.

## Source and machine

| Role | Buster source | Remote directory |
| --- | --- | --- |
| Historical, #511 merge base including #483 | `e04462c12f1ce25c70e41e8aa4acf48f4d7c4004` | `libgcc-s-489-main` |
| Immediate baseline | `8fcf19cee49cdc54e53602b67dc94ad70ec7eb6c` | `codex-489-base` |
| Qualified change | `3760045a47afcfbca174feb7dc0b4c387fef9f84` | `codex-489-handoff` |

The historical compiler and its source manifest match [the original record](https://github.com/buster14a/buster-performance/tree/ff9d360bb9e06daa449ba5f8f7c8e3f38ca92264/docs/measurements/libgcc-s-489-2026-10-27). The other source trees match the accompanying manifests. `identity.txt` records the compiler and runtime-library hashes and host/tool versions: Linux 6.18.50-2-lts, Clang/LLD 23.1.1, GCC 16.2.1, Wild 0.10.0, transparent huge pages enabled. Each build used `BUSTER_DEBUG_INFO=0 ./build.sh`, `-O3 -march=native` and the repository's other pinned build flags.

## Method

`harness/handoff-campaign.sh` runs the three binaries in three rounds, historical/current/head, head/current/historical, historical/current/head. Each invocation separately takes `exclusive.sh`, releasing it before the next invocation; CI and other sessions may run between samples. The complete path uses:

```sh
./build/compiler benchmark-link --only direct --kinds dynamic,shared --directory DIR --cache CACHE
```

It measures runtime loading, `bind_begin`, `bind_end` plus `dynamic_inputs`, and the writer separately, then sums them. The benchmark pins its lane to CPU 2 and checks the generated executables. Default workloads have 1, 2,000 and 102,400 workers. Raw stdout is under `qualified/REMOTE-DIRECTORY/handoff-campaign/logs/link-{1,2,3}.log`.

Afterwards, each binary runs one supplementary `benchmark-snapshot` (all four runtime kinds), `benchmark-bind --functions 1,2000`, and a 41-process hello-world compilation sample after five warmups, all pinned to CPU 2. These are separately identified `*-extra.log`: their internal medians and instruction counts supplement the three-round complete-link comparison; they are not three independent microbenchmark repetitions. `harness/hello.c` is the original hello-world input. Reproduction uses the directory names above below `~/buster-fast-bench`, the existing shared `exclusive.sh`, and that input copied to `~/buster-fast-bench/libgcc-s-489-hello.c`.

## Results

The complete-link values below are the median of the three process medians, with their full range in brackets, in microseconds.

| Workload | Historical #483 | Immediate baseline | Qualified change |
| --- | ---: | ---: | ---: |
| 1-worker PIE | 21.4 [21.4–22.0] | 22.6 [22.5–22.8] | 21.2 [21.0–21.4] |
| 1-worker shared | 60.5 [56.9–79.3] | 63.5 [63.0–64.0] | 60.7 [57.9–71.6] |
| 2,000-worker PIE | 139.4 [139.3–141.5] | 143.7 [142.0–143.9] | 142.9 [140.8–144.4] |
| 2,000-worker shared | 1,038.4 [1,034.6–1,056.0] | 1,043.5 [1,038.7–1,054.9] | 1,035.3 [1,034.7–1,065.8] |
| 102,400-worker PIE | 11,391.1 [11,377.0–11,534.8] | 11,443.0 [11,234.9–11,535.7] | 11,424.3 [11,289.5–11,428.5] |
| 102,400-worker shared | 27,765.9 [27,679.3–28,211.0] | 28,182.3 [27,989.7–28,285.2] | 28,248.9 [27,713.8–28,314.5] |

For the tiny PIE that exposed the fixed runtime cost, every final round is at or below its paired historical total. Cached runtime loading is 11.0–11.4 us versus 11.4–12.0 us historically and 12.3–12.6 us immediately before the fix. The writer's count phase is back to 1.0 us, versus 1.1 us in the immediate baseline.

For the tiny shared library, loading is 10.5–10.8 us versus 11.0–11.5 us historically. Its binding-plus-input phase is 0.7–0.8 us versus 0.6 us historically; summing the printed loading, begin and end phases still gives 11.9–12.2 us versus 12.3–12.8 us. Shared total wall time is dominated by the close/write phase, which varies widely. The larger-output totals likewise support no general linker speedup claim; the 2,000-worker PIE and large shared totals remain above the historical binary's medians, with much of that difference already present in the immediate baseline. The following control isolates the runtime choices within one executable.

The supplementary snapshot sample reports the following file sizes and cached-open medians (bytes / us). Each cell is one process's internal median, not three independent repetitions.

| Runtime | Historical #483 | Immediate baseline | Qualified change |
| --- | ---: | ---: | ---: |
| Dynamic PIE | 3,282,344 / 11.77 | 3,286,696 / 13.14 | 3,286,568 / 11.43 |
| Shared library | 3,280,832 / 11.12 | 3,285,312 / 12.22 | 3,285,120 / 10.93 |
| Static | 8,711,948 / 25.92 | 8,711,948 / 24.17 | 8,711,948 / 25.76 |
| Static PIE | 8,711,180 / 24.20 | 8,711,180 / 26.35 | 8,711,116 / 23.95 |

The qualified dynamic and shared snapshots retain 45 extra global names versus the historical catalog and record 23 and 20 probes respectively, including four deferred probes each. An ordinary load therefore checks 19 and 16 paths, versus the historical 20 and 17; static PIE also loses the duplicate begin-object check, while static keeps its separate `crtbeginT.o` check. Snapshot format 8 does not grow the probe structure: the deferred flag occupies existing padding.

The supplementary `bind_end` results are us / retired instructions. Its imported runtime does not include cached-open work; these are one process per binary with internal medians, so they do not establish a separate wall-time speedup for every row.

| Binding workload/path | Historical #483 | Immediate baseline | Qualified change |
| --- | ---: | ---: | ---: |
| 1-worker PIE, vector | 0.32 / 7,233 | 0.36 / 9,152 | 0.34 / 6,738 |
| 1-worker PIE, exact | 0.29 / 7,584 | 0.32 / 9,503 | 0.30 / 7,089 |
| 1-worker shared, vector | 0.32 / 6,617 | 0.35 / 8,237 | 0.30 / 6,275 |
| 1-worker shared, exact | 0.28 / 7,388 | 0.31 / 9,008 | 0.27 / 7,046 |
| 2,000-worker PIE, vector | 0.83 / 17,338 | 0.86 / 19,257 | 0.82 / 16,853 |
| 2,000-worker shared, vector | 1.12 / 22,121 | 1.14 / 23,741 | 1.10 / 21,779 |

The two new as-needed passes together use fewer instructions than the historical single pass. The tiny PIE's individual supplementary wall median is slightly above historical; the repeated complete-link comparison above, including loading, binding and writer handoff, is the budget evidence. Raw output also includes static kinds, exact 2,000-worker binding and explicitly named `-lm` cases.

The 41-process whole-driver sample is observational: historical / immediate / qualified medians are 2.405 / 2.267 / 2.241 ms, with peak RSS 31,504 / 29,584 / 30,500 KB and minor faults 569 / 558 / 541. Every process succeeded. The qualified binary retires 22,890,341 instructions versus the immediate baseline's 22,893,959 (the historical timer did not report instructions). The qualified sample's peak RSS is 916 KB above the immediate baseline and 1,004 KB below historical. It establishes no whole-driver memory improvement over the immediate baseline; executable layout and the earlier huge-page finding remain separate from the direct-link runtime/binding cost. All three samples are single campaigns with internal 41-process medians, not three independent paired driver repetitions.

## One executable, two runtime configurations

`harness/qualification.patch` applies to the qualified source. The private measurement build keeps one executable and selects its imported runtime configuration with `BUSTER_GCC_S_489_CONTROL`, evaluated during cache construction. The caches are separate, so this environment lookup is outside the timed cached opens.

The control omits the GCC DSO catalogue, restores the duplicate `crtbeginS.o` probe, and uses #483's scalar loader cleanup with its per-import version scans. The candidate uses the shipping decisions. Both retain the current snapshot format and all unrelated modern linker code. The benchmark has no named libraries or GCC references, matching the baseline helper's scope. `controlled-campaign.sh` first verifies 20 probes/3,387 global names in the control and 23 probes/3,432 names in the candidate, then runs the same complete-link command over every default workload. Each invocation separately takes the shared lock.

The control build's executable SHA-256 is `0947f153dab0f8b37e70e8013406142e87d15efb47f482f0d1c67d5edea2f5f9` (`control/build.log`). Its snapshot medians are 11.62 / 11.53 us for cached open and 4.61 / 4.52 us for warm one-worker binding (control / candidate). These are one process per configuration with internal medians; they support removal of the runtime/binding cost without attributing unrelated historical-code or executable-layout changes to the GCC catalog.

One complete control/candidate pair was used as an attribution diagnostic after the three-round acceptance comparison was already complete:

| Workload | Same-executable control | Same-executable candidate |
| --- | ---: | ---: |
| 1-worker PIE | 21.8 us | 21.2 us |
| 1-worker shared | 57.6 us | 57.7 us |
| 2,000-worker PIE | 142.8 us | 140.8 us |
| 2,000-worker shared | 1,047.1 us | 1,041.4 us |
| 102,400-worker PIE | 11,396.9 us | 11,155.7 us |
| 102,400-worker shared | 26,066.2 us | 26,439.5 us |

The tiny PIE loses the fixed cost with the same executable layout; the tiny shared runtime load falls from 11.1 to 10.8 us, with begin/end unchanged at 0.7/0.6 us. Its extra 0.1 us total is in writing. The large shared total remains higher in this pair: its count phase is 2,642.9 / 2,643.7 us and symbols 340.2 / 340.5 us, while chunks are 12,068.7 / 12,356.6 us and finish 8,772.4 / 8,925.7 us. Individual phase medians should not be summed into a causal decomposition. This diagnostic supports removal of the fixed unused-library cost; one pair does not prove equality of the large-output case or a general linker speedup.

The initial harness scheduled three pairs. After the first complete pair agreed with the fixed-cost conclusion, the remaining queued diagnostic repetitions were withdrawn; no result from them is included. `control/campaign-run.log` records the four completed invocations. The published harness defaults to that one pair; `BUSTER_GCC_S_489_ROUNDS=3` reproduces the initial longer schedule, alternating order in round two. This diagnostic does not replace or enlarge the three independent primary rounds.

## Correctness and file checks

The final build passed all eight validation commands in `validation/final-logs/tests.log`: snapshot, binding with cross-check, import with cross-check, dynamic PIE/shared-library tests with cross-check, C driver, call-graph check, retained snapshot fixtures, and traced file checks. These include native unwinder and split-stack execution and both binding paths.

The final traces show zero `libgcc_s.so.1` checks for a cached ordinary link and four for an unwinder link. The selected `crtbeginS.o` is checked once, rather than twice. Changed and newly installed optional paths do not invalidate an unrelated load, but dependent imports, undefined names (including permitted shared-library names), and named-library version needs request a snapshot discard/re-import. Weak-only references remain unbound. The dynamic-input tests independently derive library need from bound strong references and forced dependencies and reject an unused GCC library or version catalog. The high-index writer fixture still tests sparse library indices above 255.

`harness/probe-check-handoff.sh` also compares the ordinary and unwinder outputs with the preceding `f4dd5962` implementation: both executables are byte-for-byte unchanged by omitting the unused writer catalog. Reproducing that check first requires building the `f4dd5962` tree in `codex-489-final` and running `harness/probe-check-final.sh` there to produce the two reference outputs; its scripts and manifest are included. Build and run each validation step through the shared lock as the harnesses do.

## Review coverage and final test-build smoke

Review of the implementation requested explicit coverage of the forced-retention route: a needed named library has an unversioned strong `_Unwind_Backtrace` reference, no covering `DT_NEEDED`, and no version need. Test-only commit `e65a6f3e3827e1125719451d62e60125d217c71a` adds that case for loaded stale PIE/shared snapshots and both binding paths. It verifies no deferred check at `bind_begin`, the GCC need and snapshot retry at `bind_end`, then successful retention after discard/re-import. It also compares `Bind.gcc_s_needed` in the common cross-path oracle.

All four affected checks passed on the physical 9700X: `test-snapshot`, `test-bind --cross-check`, retained `test-snapshot --keep --functions 1`, and `build.sh check-call-graph`. Each snapshot run reports 130 deferred-probe checks per runtime kind, with no failures. With the build-identity capture, the runner reports five commands passed in 8.5 s. `review-validation/tests.log`, its build/run receipts and `harness/manifest-e65a6f3e.sha256` pin that validation. The executable SHA-256 is `57653a3d38e29952b9fb5847f3d265e04337e4968ff70354b6667a902d601fbc`.

The production runtime, binding, snapshot and writer sources are unchanged from the three-round implementation pin `3760045a`. Because additional test code can change executable layout, `harness/review-link-smoke.sh` ran one isolated default complete-link invocation on the new test build, with all generated outputs validated:

| Workload | Review test-build smoke |
| --- | ---: |
| 1-worker PIE | 21.4 us |
| 1-worker shared | 57.8 us |
| 2,000-worker PIE | 143.6 us |
| 2,000-worker shared | 1,039.6 us |
| 102,400-worker PIE | 11,236.1 us |
| 102,400-worker shared | 26,919.3 us |

The tiny PIE matches the historical median, with cached open 11.4 us, begin/end 0.8/0.6 us and writer count 1.0 us. This is one build-layout smoke sample, not three new independent acceptance rounds; it does not replace the primary comparison or support a general larger-link speedup. The whole-driver/RSS figures above refer to `3760045a` and were not remeasured for the test-only change. Full required hardware CI and maintainer review are separate from these targeted checks.

## Earlier trials and limits

`initial/` preserves the first deferred-probe/range-classification trial (`7c269d8f`), which still validated the selected GCC begin object twice. Its complete-link samples did not establish the historical budget, so it was not accepted. The second trial, `f4dd5962/`, adds startup-path reuse and meets the loading/binding budget but still passes an unused GCC catalog to the writer. The qualified source additionally publishes binding's as-needed decision to exclude that catalog before allocating/copying writer inputs.

Shared-library close/write times vary with the filesystem; the raw phase breakdowns retain those variations. These results establish the tested runtime/binding and complete-link costs on this host. The historical and immediate-baseline compilers also differ in unrelated frontend work; whole-driver differences across those two pins cannot be attributed to this fix. The separate `.bss`/transparent-huge-page diagnosis from the original record is not reclassified as a libgcc_s cost.

All implementation, fixtures and new run glue are original project work; the campaign adapts the commands in the pinned original measurement record. System GCC/glibc files and GNU ld/lld/readelf/strace are external inputs/oracles. No runtime binaries, archives or snapshots are included. Published captures omit `.stderr` and all shared-lock holder messages so other sessions' private information is excluded.
