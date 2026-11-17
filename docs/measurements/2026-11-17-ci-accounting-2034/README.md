# CI phase accounting: bounded live evidence for #2034

This capture validates the new accounting against **12 actual completed workflow runs and 881 raw jobs**. The independent interval audit reconciles **176,823 runner-seconds** exactly: 176,580 hosted and 243 self-hosted. All 12 sampled runs have complete resource and job-completion records; phase residuals are zero. The observed peak is **64 simultaneous hosted jobs**. The account's configured hosted concurrency remains **unknown**.

Implementation: [buster PR #2904](https://github.com/buster14a/buster/pull/2904), pinned source commit [5fc216c16ec86707a5a5e93325dc902a7b56734d](https://github.com/buster14a/buster/commit/5fc216c16ec86707a5a5e93325dc902a7b56734d).

The evidence supports completing the reporting changes and retaining the existing admission controls while an administrator records the actual eligible runner limits. It does not justify increasing queue admission or claiming a CI speedup.

## What this sample represents

This is a purposive, bounded illustrative sample assembled from saved read-only GitHub API responses. It includes successful and cancelled PR runs, successful merge candidates, one successful deferred dispatch, a failed targeted nightly admission, a Build run, and a failed timing report. All selected runs have one attempt. It is not random, exhaustive, an account-wide utilization window, or a causal experiment.

The split is **2026-11-17T00:00:00Z**, based on run creation. The runs span different revisions, outcomes, and workflows. In particular, the earlier cancelled PR stopped after 95 seconds while the later cancelled PR stopped after 590 seconds. Their different resource costs do not by themselves show a regression. Only one sampled hosted job has retained CPU evidence, so CPU coverage is not matched across the two cohorts.

No workflows were dispatched, rerun, or cancelled for this capture. No benchmark hardware was used by this audit. The self-hosted seconds below are observations of a pre-existing completed job.

## Before and after, with denominators

Quantiles include every selected outcome in each row. p50 is the median; p95 is nearest rank, which is simply the maximum in these small cohorts. First useful feedback means the first completed correctness or measurement step, or an actionable failure. In most selected integration runs it is an early CI glue fixture check; it is not completion of the compiler test suite. Completion is the last allocated job endpoint in the fully observed terminal attempt, not the run's mutable `updated_at`.

| Workflow / event | Cohort | Runs and outcomes | Feedback p50 / p95 (s) | Completion p50 / p95 (s) | Hosted runner-min, total | Hosted runner-min / sampled SHA |
| --- | --- | --- | ---: | ---: | ---: | ---: |
| Integration PR | Before | 2: 1 success, 1 cancelled | 50 / 73 | 487.5 / 880 | 76.517 | 38.258 |
| Integration PR | After | 3: 2 success, 1 cancelled | 35 / 75 | 845 / 946 | 205.300 | 68.433 |
| Merge queue | Before | 1 success | 18 / 18 | 1762 / 1762 | 635.617 | 635.617 |
| Merge queue | After | 2 successes | 20 / 21 | 1629.5 / 1707 | 1279.250 | 639.625 |

The successful deferred dispatch consumed 700.000 hosted runner-minutes and completed in 2730 seconds. The Build run consumed 32.217 hosted runner-minutes and completed in 1924 seconds. The failed timing report consumed 12.950 hosted runner-minutes and completed in 782 seconds. The failed targeted admission consumed 5.200 runner-minutes, of which 1.150 were hosted, and completed in 280 seconds. These are separate workload observations, not like-for-like before/after pairs.

Every selected run has known feedback and completion under the declared contract. The full tables, exact run links, outcomes, observed queue waits, and critical-path indicators are in [summary.md](summary.md); independent per-job arithmetic is in [independent-checks.json](independent-checks.json).

## Conservation and phase coverage

| Runner class / cohort | Allocated jobs | Execution (s) | Setup/build | Correctness | Measurement | Upload/reporting | Other overhead | Lock wait | Unclassified | Overlap | Residual |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Hosted / before | 214 | 85505 | 26834 | 54297 | 0 | 632 | 2188 | 0 | 1554 | 0 | 0 |
| Hosted / after | 268 | 91075 | 29718 | 56895 | 0 | 743 | 2755 | 0 | 964 | 0 | 0 |
| Self-hosted / after | 1 | 243 | 73 | 159 | 0 | 3 | 1 | 0 | 7 | 0 | 0 |

There are 483 allocated jobs and 398 unallocated/skipped jobs. All allocated intervals in this selected sample are complete. Raw step intervals cover 175,227 seconds; uncovered gaps account for 1,596 seconds. The larger phase `unclassified` total also includes steps whose names do not match a phase family. There are no missing timed step intervals or unavailable step lists in these particular inputs.

This live sample contains no executed `Compare` or `Time` measurement intervals and no retained complete hardware lock acquisition/release log. Measurement-family and lock-overlay coverage therefore comes from the implementation's deterministic fixtures, not an invented live observation. Zero observed lock markers does not mean zero actual lock wait or hold. The successful deferred dispatch skipped the native measurement job.

The independent audit does not call production accounting functions. It selects assigned jobs from positive raw `runner_id` values, checks terminal job intervals, sums `completed_at - started_at`, clips valid non-skipped step intervals to each job, and unions them by sorted endpoints. It separately unions all allocated job intervals for each run, computes completion from the latest allocated endpoint minus original run creation, and checks wall time equals occupied union plus outside-execution time. A sweep with end events before start events at equal timestamps verifies hosted overlap. The audit compares those results to every run receipt and every class/cohort phase row. Individually reviewed raw step endpoints verify the reported feedback values. [verification.md](verification.md) records the result.

Two concrete issues found during live review were corrected before this capture: explicitly null, never-allocated cancelled jobs were being treated as unknown allocation, and a malformed step endpoint outside a known job interval could affect first feedback. The cancelled PR now has its correct 590-second completion and complete resource denominator.

## Capacity and queue interpretation

The three selected queue commits were observed on `main` through retained compare responses. Their total hosted work is 1914.867 runner-minutes, or **638.289 per observed merged candidate**. Average completion is **27.894 minutes**. All three passed. This sample contains no failed or invalidated queue candidate, so it cannot estimate a failure probability or failure-induced rebuild rate.

For eligible available slots `C_available` and simultaneous queue candidates `K`, these observations give the conditional upper-bound model:

```text
candidate throughput <= min(0.0940 * C_available, 2.1510 * K) per hour
```

This is a necessary resource/completion ceiling, not a safe admission recommendation. `C_available` must subtract simultaneous PR, nightly, preparation, reporting, and other-repository demand. The observed active queue ruleset has `max_entries_to_build = 4` and `max_entries_to_merge = 1`; its raw response is retained. Keep those controls and the existing cancellation/coalescing policies while establishing actual headroom. Per-workflow `max-parallel` limits local fan-out; it does not reserve account slots.

The observed 64-job peak occurred at **2026-11-17T00:24:11Z**: 62 jobs from queue run 43987166748, one job from deferred dispatch 43982345178, and one Build job from 43984672220. It proves that this much hosted concurrency was exercised by the selected repository runs, not the configured account ceiling or exhaustive account occupancy.

Two cancelled older PR runs have later same-PR/workflow evidence and consumed **59.817 runner-minutes**. Their fate is `superseded-possible`; cancellation cause is not present in the snapshot. Confirmed superseded waste is unknown. Observed retry work is zero because all selected runs have one attempt; that is not a repository-wide retry rate. Failure-attributed rebuild work is also unknown. A failed entry can invalidate later work, but a defensible sensitivity model must separately budget failed-entry work, discarded downstream work, and replacement validations, with at most `K - 1` concurrently downstream entries.

### Actual limits and CPU evidence

No dated administrative record of the actual configured hosted limit was accessible. The historical “roughly 360” figure in [the #1430 discussion](https://github.com/buster14a/buster/issues/1430#issuecomment-6849061037) is an agent-authored estimate, not an owner or administrator's capacity record. The #2031 follow-up and relevant PR discussions did not supply such a record either. Published plan defaults and observed peaks must not be substituted for it.

GitHub documents the administrator view under Settings → Actions → Runners → GitHub-hosted runners → All jobs usage in [Viewing current jobs](https://docs.github.com/en/actions/how-tos/manage-runners/github-hosted-runners/view-current-jobs). Record the applicable standard/larger-runner class limits, timestamp, scope, and source, then pass the verified capacity and evidence source to the collector. [Actions limits](https://docs.github.com/en/actions/reference/limits) describes defaults and support-adjustable limits. The [hosted-runners REST limits endpoint](https://docs.github.com/en/rest/actions/hosted-runners) concerns public-IP quotas and does not establish the standard hosted concurrency limit.

The retained log excerpt for [job 133904051095](https://github.com/buster14a/buster/actions/runs/44043517475/job/133904051095) reports `AMD EPYC 9V45 96-Core Processor` and four available CPUs. The model string describes the processor model; it is not a claim that the job received 96 CPUs. Other sampled CPU models remain unknown.

## Reporting reliability and existing backlog ownership

The earlier [timing report run 43918005798](https://github.com/buster14a/buster/actions/runs/43918005798) failed after its collection command encountered HTTP 502; the old summary step was skipped. The retained log excerpt supports this observation. Bounded retries, partial-response retention, unavailable-response notes, and an always-visible summary directly address that failure mode.

Main backlog reporting remains owned by [#1439](https://github.com/buster14a/buster/issues/1439) and the existing nightly ledger. The retained [2026-11-17 report](https://github.com/buster14a/buster-performance/blob/nightly-ledger/nightly/reports/2026-11-17.md) reports 386 carried states, with the oldest 133.8 hours old as of that cycle; it also reports 89.7 code-state arrivals/day over seven days and 0.3 completions/cycle over seven cycles. Those are the ledger's observations at its cycle time, not extrapolated to this capture. Prior verification is linked from [performance PR #273](https://github.com/buster14a/buster-performance/pull/273). No second ledger is created here.

## Provenance and offline reproduction

Extract the accompanying archive in this directory:

```sh
sha256sum -c archive-SHA256SUMS
tar -xzf capture.tar.gz
sha256sum -c raw-SHA256SUMS
bash reproduce.sh /absolute/path/to/buster-checkout-with-2034
```

Replay uses the repository's Bash/jq collector and C engine. It makes no network requests. It needs a C17 compiler, Bash, jq, and the ordinary utilities used by the collector. The temporary independent analysis program is not part of the published package or production implementation; its algorithm and numeric receipts are retained above.

The archive preserves `raw/`, `replay/`, and the unchanged collector `output/`. **Only `raw/` contains original retained response contents.** Workflow/event/window files under `replay/` are derived projections of the selected actual run metadata, not original responses to the endpoint strings printed by the replay request ledger. Empty projected lists mean no selected run, not no actual workflow runs. The replay's list `total_count` explicitly states that the population is unknown. Collector “latest” wording applies only to these replay inputs. The appended sample-design note in published `facts.tsv` and `summary.md` makes this limitation explicit.

Additional job-page requests used the run-jobs API's default latest filter; some initial audit pages explicitly used `filter=all`. Every retained run and job has `run_attempt = 1`, so the byte-identical pages represent the same one complete attempt when replayed under attempt-1 filenames. The [workflow jobs API](https://docs.github.com/en/rest/actions/workflow-jobs) documents the filter distinction. The nightly Markdown is original retained text; its replay contents envelope is derived. The replay CPU marker is derived from the retained timestamped log excerpt. Compare responses are later ancestry observations against mutable main, not queue lifecycle records.

Exact identities and sources are recorded in:

- [source-manifest.json](source-manifest.json): every selected run ID, original metadata file, job page files, split, and source caveats.
- [replay-provenance.json](replay-provenance.json): every derived list, copied job page, compare response, and marker mapping.
- [raw-SHA256SUMS](raw-SHA256SUMS): exact SHA-256 of each of the 37 retained original files.
- [implementation-SHA256SUMS](implementation-SHA256SUMS) and [implementation-base.txt](implementation-base.txt): exact C/collector source hashes and checkout base used for the report. The report was generated while the source change was a working tree; the same source is now pinned by commit `5fc216c16ec86707a5a5e93325dc902a7b56734d` above.
- `facts.tsv` (inside [capture.tar.gz](capture.tar.gz)), [summary.md](summary.md), and [verification.md](verification.md): normalized facts, C report, and independent reconciliation receipt.

The hosted [CI latency test run 44052716760, job 133934243727](https://github.com/buster14a/buster/actions/runs/44052716760/job/133934243727) passed at 09:08 UTC. It ran 355 total C self-test checks, including 50 accounting checks, and a separate 50-check accounting sanitizer run with ASan, UBSan, and default leak detection; collector fixtures also passed. The fixtures cover outcomes, all attempts, incomplete API pages, reversed unallocated timestamps, retries, measurement families, lock overlays, resource conservation, and network-free replay. Those fixture checks are distinct from this selected live capture. The parent implementation task verified the captured source files are byte-identical to the published commit.
