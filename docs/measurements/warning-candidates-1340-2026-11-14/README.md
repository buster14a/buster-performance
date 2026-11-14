# Common-warning candidate scans, PR #2642

Measured 2026-11-14 on the locked Ryzen 7 9700X (`benchpress`, Linux 6.18.50-2-lts), CPU 2, Release, `BUSTER_HOST_ARCH=znver5`, `BUSTER_DEBUG_INFO=0`, clang 23.1.4. The exact Buster revisions are base `d2b1b238c2ec0dc4a13c981c1f2e9dad2990853f` and candidate `8b474c458fce5e8ed12a4e2777c9e62ebd8f88d8` ([PR #2642](https://github.com/buster14a/buster/pull/2642)). Binary SHA-256s and the frozen SQLite input hash are in each hold log. Builds, sampling, and `perf` ran through the shared lock. The candidate was an incremental rebuild after checkout; the build logs do not themselves capture the Git revisions at build time. `raw/post-campaign-source-receipt.txt` records the clean tree revisions and unchanged binary hashes after the campaigns, corroborating rather than independently proving build-time source identity. The campaign scripts invoke the shared lock; the hold logs retain process/load snapshots, and contain no admission message when the lock is immediately available. The input and its pinned headers/predefines remain in the external frozen corpus, not this record.

The final campaign made 31 pairs of whole `sqlite3.c -c --lanes 1` processes in alternating base/head order, with default warnings, `-w`, and `-Wall -Wextra`, in that order per binary. The commands are in `scripts/measure-final-2642.sh`, the build transcripts and raw stage logs in `raw/receipts.tar.gz`. Medians below are over processes; paired differences are medians of head minus base in corresponding rounds. Peak RSS is the compiler's approximate `VmHWM` in KiB, not the added index's size in isolation.

| mode | total ms base → head | check-program ms base → head | paired check-program delta ms | head faster in pairs | peak RSS KiB base → head |
| --- | ---: | ---: | ---: | ---: | ---: |
| default | 122.941 → 122.559 | 23.741 → 23.516 | −0.216 | 25/31 | 236868 → 236736 |
| -w | 109.821 → 109.817 | 10.797 → 10.850 | +0.085 | 7/31 | 236612 → 236480 |
| -Wall -Wextra | 141.645 → 141.531 | 40.655 → 40.587 | −0.092 | 19/31 | 271800 → 271668 |

For each mode, all 31 paired non-timing diagnostic streams matched after removing the instrumented timing and worker-budget records; all 186 object files had SHA-256 `67336df12ddec6c17a4032c70d010041c7549975ae0aa818fb68f26781d00078`. These are one workload's checks, not a replacement for correctness suites.

## Investigating `-w`

A separate 41-pair `-w`-only campaign, alternating order, measured total 110.033 → 109.980 ms (median paired difference +0.050 ms, candidate faster in 19/41), and check-program 10.856 → 10.881 ms (paired median +0.053 ms, faster in 18/41; pair differences ranged −1.430 to +1.878 ms). The total paired differences included a −27.204 ms outlier. Median peak RSS was 236612 → 236480 KiB, while one candidate run had a large RSS outlier. This independent run did not reproduce the original 7/31 ordering strength, and neither campaign establishes a material total-time effect. It does not establish the cause of the small phase differences; code layout or noise are possible, not demonstrated explanations. Successful `-w` compilation bypasses the common-warning driver.

Eleven additional paired `-w` runs under `perf stat` counted full-process user-mode instructions and cycles. Medians were 1,221,707,948 → 1,221,708,404 instructions (median paired difference −224; head lower in 6/11), and 524,419,485 → 524,397,528 cycles (paired median −755,863; head lower in 8/11). These count the entire compile, not just check-program; they do not isolate a phase-level cause. Raw per-run counters and logs, including outliers, are retained. The 9700X lock excludes other cooperating sessions but not unrelated work.

## Reproduction

The scripts expect `base/build/compiler` and `head/build/compiler` built from the exact revisions in adjacent trees, the corpus path `/var/lib/buster-9700x/corpora/preprocessor-391e729af658`, `~/buster-fast-bench/exclusive.sh`, `taskset`, and, for the counter run, `perf`. `build-base.log` and `build-final3.log` record the actual build. Run scripts individually on the named host; each holds the lock only for its own campaign. The archive contains the complete timing stderr, per-run perf counters, object checksums and hold snapshots, but not generated objects or the external corpus. No statistical confidence interval, cross-workload generalization, or hardware result for a later head is claimed.
