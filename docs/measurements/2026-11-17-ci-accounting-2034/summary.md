# CI phase and capacity accounting

Snapshot epoch: 1794906196. Observed 12 workflow runs, 12 attempts and 881 jobs. All outcomes and available attempts are retained.

Before/after split epoch: 1794873600 (run creation, not job completion). Cohorts are reported separately.
## Feedback, completion and consumption

One sample per workflow run, with every collected attempt charged to it. Quantiles use available observations across **all outcomes**, not just successful runs; `known / runs` exposes missing feedback and censored tails. p50 is the median and p95 is nearest rank.

First useful feedback is the first observed completed correctness/measurement step, or an actionable step/job failure. Checkout and successful setup alone do not count. Completion is the last allocated job's completion in a fully observed terminal latest attempt: a **job-completion proxy**, never the mutable run `updated_at`.

| Workflow | Event | Cohort | Metric | Known / runs | p50 (s) | p95 (s) |
| --- | --- | --- | --- | ---: | ---: | ---: |
| 9700x.yml | pr | before | first useful feedback | 2 / 2 | 50.0 | 73 |
| 9700x.yml | pr | before | completion proxy | 2 / 2 | 487.5 | 880 |
| 9700x.yml | pr | before | longest job queue wait | 2 / 2 | 2.5 | 3 |
| 9700x.yml | queue | before | first useful feedback | 1 / 1 | 18.0 | 18 |
| 9700x.yml | queue | before | completion proxy | 1 / 1 | 1762.0 | 1762 |
| 9700x.yml | queue | before | longest job queue wait | 1 / 1 | 3.0 | 3 |
| 9700x.yml | full | before | first useful feedback | 1 / 1 | 23.0 | 23 |
| 9700x.yml | full | before | completion proxy | 1 / 1 | 2730.0 | 2730 |
| 9700x.yml | full | before | longest job queue wait | 1 / 1 | 3.0 | 3 |
| 9700x.yml | queue | after | first useful feedback | 2 / 2 | 20.0 | 21 |
| 9700x.yml | queue | after | completion proxy | 2 / 2 | 1629.5 | 1707 |
| 9700x.yml | queue | after | longest job queue wait | 2 / 2 | 3.0 | 3 |
| 9700x.yml | pr | after | first useful feedback | 3 / 3 | 35.0 | 75 |
| 9700x.yml | pr | after | completion proxy | 3 / 3 | 845.0 | 946 |
| 9700x.yml | pr | after | longest job queue wait | 3 / 3 | 3.0 | 3 |
| 9700x.yml | targeted | after | first useful feedback | 1 / 1 | 35.0 | 35 |
| 9700x.yml | targeted | after | completion proxy | 1 / 1 | 280.0 | 280 |
| 9700x.yml | targeted | after | longest job queue wait | 1 / 1 | 3.0 | 3 |
| build.yml | pr | after | first useful feedback | 1 / 1 | 12.0 | 12 |
| build.yml | pr | after | completion proxy | 1 / 1 | 1924.0 | 1924 |
| build.yml | pr | after | longest job queue wait | 1 / 1 | 2.0 | 2 |
| ci-timings.yml | reporting | before | first useful feedback | 1 / 1 | 10.0 | 10 |
| ci-timings.yml | reporting | before | completion proxy | 1 / 1 | 782.0 | 782 |
| ci-timings.yml | reporting | before | longest job queue wait | 1 / 1 | 2.0 | 2 |

| Workflow | Event | Cohort | Runs | Attempts seen / expected | Complete resource records | Available runner-min | Hosted runner-min | Retry runner-min | Distinct head SHAs | Runner-min / sampled SHA |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 9700x.yml | pr | before | 2 | 2 / 2 | 2 / 2 | 76.517 | 76.517 | 0.000 | 2 | 38.258 |
| 9700x.yml | queue | before | 1 | 1 / 1 | 1 / 1 | 635.617 | 635.617 | 0.000 | 1 | 635.617 |
| 9700x.yml | full | before | 1 | 1 / 1 | 1 / 1 | 700.000 | 700.000 | 0.000 | 1 | 700.000 |
| 9700x.yml | queue | after | 2 | 2 / 2 | 2 / 2 | 1279.250 | 1279.250 | 0.000 | 2 | 639.625 |
| 9700x.yml | pr | after | 3 | 3 / 3 | 3 / 3 | 205.300 | 205.300 | 0.000 | 3 | 68.433 |
| 9700x.yml | targeted | after | 1 | 1 / 1 | 1 / 1 | 5.200 | 1.150 | 0.000 | 1 | 5.200 |
| build.yml | pr | after | 1 | 1 / 1 | 1 / 1 | 32.217 | 32.217 | 0.000 | 1 | 32.217 |
| ci-timings.yml | reporting | before | 1 | 1 / 1 | 1 / 1 | 12.950 | 12.950 | 0.000 | 1 | 12.950 |

Available resource totals include elapsed and step-only lower bounds; missing jobs/attempts are **not zero cost**. Retry work is the observed work of attempts greater than one, already included in the total. Per-SHA ratios describe the sampled head SHAs, not unobserved revisions or marginal change cost. Before/after cohorts must have comparable workflow/event/CPU coverage; bounded latest-run samples do not establish an arrival rate or a causal speedup.

| Workflow | Event | Cohort | Latest outcome | Runs |
| --- | --- | --- | --- | ---: |
| 9700x.yml | pr | before | success | 1 |
| 9700x.yml | pr | before | cancelled | 1 |
| 9700x.yml | queue | before | success | 1 |
| 9700x.yml | full | before | success | 1 |
| 9700x.yml | queue | after | success | 2 |
| 9700x.yml | pr | after | success | 2 |
| 9700x.yml | pr | after | cancelled | 1 |
| 9700x.yml | targeted | after | failure | 1 |
| build.yml | pr | after | success | 1 |
| ci-timings.yml | reporting | before | failure | 1 |

## Reconciled job phases

Each allocated job is partitioned once. Step spans are clipped to its observed execution interval; conflicting spans go to `overlap`. Missing steps and gaps go to `unclassified`. Skipped steps and unallocated/skipped jobs consume no reported execution. Setup/build is the sum of actual setup/build spans and does not depend on a native-test endpoint. `Compare`, `Time` and `Gauge` count with `Benchmark`, `Measure`, `Attribute`, `Profile` and the two Zen 5 sample reproduction steps.

Classification uses whole step names. A combined build-and-qualify step stays in one bucket; these are administrative phase groups, not instrumentation of commands inside a step. Unknown/new names remain unclassified.

| Runner class | Cohort | Observation | Jobs | Execution (s) | setup/build | correctness | measurement | uploads/reporting | other overhead | lock wait | unclassified | overlap | Residual (s) |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| hosted | before | complete interval | 214 | 85505 | 26834 | 54297 | 0 | 632 | 2188 | 0 | 1554 | 0 | 0 |
| hosted | after | complete interval | 268 | 91075 | 29718 | 56895 | 0 | 743 | 2755 | 0 | 964 | 0 | 0 |
| self-hosted | after | complete interval | 1 | 243 | 73 | 159 | 0 | 3 | 1 | 0 | 7 | 0 | 0 |

Unknown execution: 0 allocated/possibly allocated jobs. Unallocated/skipped jobs: 398. Missing step intervals: 0; unavailable step lists: 0; currently running step intervals: 0. These counts remain visible even when an available total reconciles.

Lock-log observations: wait 0 s in 0 jobs; hold 0 s in 0 jobs. A missing log/acquisition/release is unknown. Hold is an overlapping occupation metric, **not added** to execution phases. Whole-second logs and API timestamps can differ at the boundaries; the additive wait is clipped to the job.

## Observed runner classes and CPUs

CPU model comes from a job's log when available. Runner labels, CPU models and observed peak are not the account's configured concurrency limit. Unknown CPU/model/class stays explicit.

| Class | Labels | CPU model | Cohort | Jobs | Complete intervals | Available runner-min |
| --- | --- | --- | --- | ---: | ---: | ---: |
| hosted | ubuntu-26.04 | unknown | before | 214 | 214 | 1425.083 |
| hosted | ubuntu-26.04 | unknown | after | 267 | 267 | 1510.383 |
| self-hosted | self-hosted,Linux,X64,buster-zen5,ryzen-9700x | unknown | after | 1 | 1 | 4.050 |
| hosted | ubuntu-26.04 | AMD EPYC 9V45 96-Core Processor | after | 1 | 1 | 7.533 |

## Merge queue, discarded work and finite capacity

Queue fate and test outcome are independent. A successful candidate may still be live. `invalidated` requires a deleted/moved candidate branch **and** an observed commit not on main; an unreadable API gives `unknown`. Invalidated work is discarded validation (rebuild/drop), not proof that a failure caused a rebuild.

| Fate | Queue runs | Available hosted runner-min | Available total runner-min |
| --- | ---: | ---: | ---: |
| merged | 3 | 1914.867 | 1914.867 |

All sampled queue work / observed merged candidates: 638.289 hosted runner-min per merge (3 observed merges). This window ratio includes discarded work and retries; incomplete or unmatched cohorts make it a lower-bound accounting ratio, not an isolated candidate cost.

Potential supersession: 2 cancelled older PR runs have newer same-PR/workflow observations, consuming 59.817 available runner-min. Cancellation cause is not in the Actions snapshot, so **confirmed superseded waste is unknown**. Failure-attributed rebuild work is also unknown without queue lifecycle evidence; discarded candidate work and observed retry work are reported separately above.

Observed peak simultaneous hosted jobs: **64**, a lower bound on capacity exercised by this bounded repository sample, not the organization/account limit.

Actual configured account hosted concurrency: **unknown**. Published plan defaults and observed runner peaks are not an administrator's record. Supply the verified limit and its dated source before recommending numeric admission changes.

For `C_available` eligible runner slots, `W` hosted runner-minutes per candidate, `T` candidate critical-path/completion minutes, and `K` in-flight candidates, a necessary ceiling is `min(60*C_available/W, 60*K/T)` candidates/hour. Stability requires arrival rate below that ceiling **with headroom**. `C_available` must subtract simultaneous PR, nightly, preparation, reporting and other-repository demand; this latest-run sample is not an exhaustive account utilization window. Per-workflow `max-parallel` does not reserve account slots.

The 3 fully observed terminal candidates with known runner classes average W = 638.289 hosted runner-min and T = 27.894 min (all outcomes). The corresponding **sample-based upper-bound model**, not a safe admission setting, is `min(0.0940 * C_available, 2.1510 * K)` candidates/hour. Successful and failed candidates can have very different work; rerun this comparison by matched cohort before tuning.

Rebuild sensitivity: if a failed entry invalidates `d` later entries, budget the failed entry's consumed work **plus** the measured work discarded by those `d` entries and the replacement validations. `0 <= d <= K-1` bounds concurrent downstream exposure; do not multiply observed successful work by an invented failure rate. Keep integration concurrency bounded, choose shard fan-out jointly with account headroom and feedback latency, and admit optional preparation only within the residual budget using existing controls. This report changes no validation, cancellation, coalescing or coverage policy.

## Run receipts and critical-path indicators

The last completing job and the longest observed job help locate bottlenecks; neither proves the dependency DAG's critical path. `Any runner` is the union of observed allocated job intervals across attempts, so it does not double-count concurrent jobs. Where every interval is known, wall time = any-runner occupation + outside-execution time; the latter includes admission, dependency waits and retry gaps and is not all runner queueing.

| Run | Cohort | Outcome / fate | Complete resources | Available runner-min | Feedback (s) | Completion proxy (s) | Any runner (s) | Outside execution (s) | Last completing job | Longest observed job |
| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | --- | --- |
| [43964063203](https://github.com/buster14a/buster/actions/runs/43964063203) | before | cancelled / superseded-possible | yes | 3.017 | 27 | 95 | 88 | 7 | [133639537346](https://github.com/buster14a/buster/actions/runs/43964063203/job/133639537346) Coverage record | [133638734968](https://github.com/buster14a/buster/actions/runs/43964063203/job/133638734968) CI glue fixtures (70 s) |
| [43964225841](https://github.com/buster14a/buster/actions/runs/43964225841) | before | success / na | yes | 73.500 | 73 | 880 | 832 | 48 | [133647583362](https://github.com/buster14a/buster/actions/runs/43964225841/job/133647583362) Coverage record | [133640471314](https://github.com/buster14a/buster/actions/runs/43964225841/job/133640471314) Tests on Ubuntu 26.04 (vector, none, O3) / Vector draw 1, candidate 4 (Clang 23, none, O3) (707 s) |
| [43968796098](https://github.com/buster14a/buster/actions/runs/43968796098) | before | success / merged | yes | 635.617 | 18 | 1762 | 1755 | 7 | [133671205192](https://github.com/buster14a/buster/actions/runs/43968796098/job/133671205192) Coverage record | [133655877256](https://github.com/buster14a/buster/actions/runs/43968796098/job/133655877256) Tests on Ubuntu 26.04 (vector, none address thread memory, O3) / Vector draw 1, candidate 11 (Clang 23, none address thread memory, O3) (1364 s) |
| [43982345178](https://github.com/buster14a/buster/actions/runs/43982345178) | before | success / na | yes | 700.000 | 23 | 2730 | 2719 | 11 | [133722834059](https://github.com/buster14a/buster/actions/runs/43982345178/job/133722834059) Coverage record | [133703896246](https://github.com/buster14a/buster/actions/runs/43982345178/job/133703896246) Tests on Ubuntu 26.04 (x86-64, none, O3) / SQLite's full Tcl suite by both tiers against clang's (Clang 23, x86-64, none) (2432 s) |
| [43987166748](https://github.com/buster14a/buster/actions/runs/43987166748) | after | success / merged | yes | 645.467 | 21 | 1552 | 1545 | 7 | [133729940765](https://github.com/buster14a/buster/actions/runs/43987166748/job/133729940765) Coverage record | [133718711036](https://github.com/buster14a/buster/actions/runs/43987166748/job/133718711036) Tests on Ubuntu 26.04 (vector, none address thread memory, O3) / Vector draw 1, candidate 16 (Clang 23, none address thread memory, O3) (1410 s) |
| [43994599478](https://github.com/buster14a/buster/actions/runs/43994599478) | after | success / na | yes | 72.983 | 35 | 845 | 832 | 13 | [133749329764](https://github.com/buster14a/buster/actions/runs/43994599478/job/133749329764) Coverage record | [133743972977](https://github.com/buster14a/buster/actions/runs/43994599478/job/133743972977) Tests on Ubuntu 26.04 (vector, none, O3) / Vector draw 1, candidate 2 (Clang 23, none, O3) (724 s) |
| [44022415745](https://github.com/buster14a/buster/actions/runs/44022415745) | after | cancelled / superseded-possible | yes | 56.800 | 33 | 590 | 579 | 11 | [133838459676](https://github.com/buster14a/buster/actions/runs/44022415745/job/133838459676) Coverage record | [133835255358](https://github.com/buster14a/buster/actions/runs/44022415745/job/133835255358) Tests on Ubuntu 26.04 (vector, none, O3) / Vector draw 1, candidate 9 (Clang 23, none, O3) (482 s) |
| [44023518517](https://github.com/buster14a/buster/actions/runs/44023518517) | after | success / na | yes | 75.517 | 75 | 946 | 894 | 52 | [133844224296](https://github.com/buster14a/buster/actions/runs/44023518517/job/133844224296) Coverage record | [133839079828](https://github.com/buster14a/buster/actions/runs/44023518517/job/133839079828) Tests on Ubuntu 26.04 (vector, none, O3) / Vector draw 1, candidate 6 (Clang 23, none, O3) (792 s) |
| [44032126732](https://github.com/buster14a/buster/actions/runs/44032126732) | after | failure / na | yes | 5.200 | 35 | 280 | 273 | 7 | [133868093476](https://github.com/buster14a/buster/actions/runs/44032126732/job/133868093476) Coverage record | [133866452967](https://github.com/buster14a/buster/actions/runs/44032126732/job/133866452967) Native tests and benchmarks on Benchpress (Ryzen 7 9700X) (243 s) |
| [44043517475](https://github.com/buster14a/buster/actions/runs/44043517475) | after | success / merged | yes | 633.783 | 19 | 1707 | 1700 | 7 | [133916815118](https://github.com/buster14a/buster/actions/runs/44043517475/job/133916815118) Coverage record | [133904053246](https://github.com/buster14a/buster/actions/runs/44043517475/job/133904053246) Tests on Ubuntu 26.04 (vector, none address thread memory, O3) / Vector draw 1, candidate 5 (Clang 23, none address thread memory, O3) (1527 s) |
| [43984672220](https://github.com/buster14a/buster/actions/runs/43984672220) | after | success / na | yes | 32.217 | 12 | 1924 | 1922 | 2 | [133709641614](https://github.com/buster14a/buster/actions/runs/43984672220/job/133709641614) Fresh, incremental, failed and switched builds (Clang 23, native) | [133709641614](https://github.com/buster14a/buster/actions/runs/43984672220/job/133709641614) Fresh, incremental, failed and switched builds (Clang 23, native) (1922 s) |
| [43918005798](https://github.com/buster14a/buster/actions/runs/43918005798) | before | failure / na | yes | 12.950 | 10 | 782 | 777 | 5 | [133477419198](https://github.com/buster14a/buster/actions/runs/43918005798/job/133477419198) report | [133477419198](https://github.com/buster14a/buster/actions/runs/43918005798/job/133477419198) report (768 s) |

## Collection limits and existing backlog reporting

The collector's raw API responses and normalized facts preserve the sampled run links, attempts, cohorts and incomplete reads. A missing/expired/unreadable page or log is unknown, never a successful zero. The report reader refuses malformed, duplicate or over-capacity facts instead of silently truncating.

- 9700x.yml/pull\_request/before: Sample: latest 2 of unknown; derived illustrative subset, not an API population count runs returned, limit 100, created filter - to 2026-11-16T23:59:59Z; jobs and attempts have their own completeness flags.
- 9700x.yml/pull\_request/after: Sample: latest 3 of unknown; derived illustrative subset, not an API population count runs returned, limit 100, created filter 2026-11-17T00:00:00Z to -; jobs and attempts have their own completeness flags.
- 9700x.yml/merge\_group/before: Sample: latest 1 of unknown; derived illustrative subset, not an API population count runs returned, limit 100, created filter - to 2026-11-16T23:59:59Z; jobs and attempts have their own completeness flags.
- 9700x.yml/merge\_group/after: Sample: latest 2 of unknown; derived illustrative subset, not an API population count runs returned, limit 100, created filter 2026-11-17T00:00:00Z to -; jobs and attempts have their own completeness flags.
- 9700x.yml/workflow\_dispatch/before: Sample: latest 1 of unknown; derived illustrative subset, not an API population count runs returned, limit 100, created filter - to 2026-11-16T23:59:59Z; jobs and attempts have their own completeness flags.
- 9700x.yml/workflow\_dispatch/after: Sample: latest 1 of unknown; derived illustrative subset, not an API population count runs returned, limit 100, created filter 2026-11-17T00:00:00Z to -; jobs and attempts have their own completeness flags.
- 9700x.yml/schedule/before: Sample: latest 0 of unknown; derived illustrative subset, not an API population count runs returned, limit 100, created filter - to 2026-11-16T23:59:59Z; jobs and attempts have their own completeness flags.
- 9700x.yml/schedule/after: Sample: latest 0 of unknown; derived illustrative subset, not an API population count runs returned, limit 100, created filter 2026-11-17T00:00:00Z to -; jobs and attempts have their own completeness flags.
- 9700x.yml/push/before: Sample: latest 0 of unknown; derived illustrative subset, not an API population count runs returned, limit 100, created filter - to 2026-11-16T23:59:59Z; jobs and attempts have their own completeness flags.
- 9700x.yml/push/after: Sample: latest 0 of unknown; derived illustrative subset, not an API population count runs returned, limit 100, created filter 2026-11-17T00:00:00Z to -; jobs and attempts have their own completeness flags.
- build.yml/all/before: Sample: latest 0 of unknown; derived illustrative subset, not an API population count runs returned, limit 100, created filter - to 2026-11-16T23:59:59Z; jobs and attempts have their own completeness flags.
- build.yml/all/after: Sample: latest 1 of unknown; derived illustrative subset, not an API population count runs returned, limit 100, created filter 2026-11-17T00:00:00Z to -; jobs and attempts have their own completeness flags.
- ci-timings.yml/all/before: Sample: latest 1 of unknown; derived illustrative subset, not an API population count runs returned, limit 100, created filter - to 2026-11-16T23:59:59Z; jobs and attempts have their own completeness flags.
- ci-timings.yml/all/after: Sample: latest 0 of unknown; derived illustrative subset, not an API population count runs returned, limit 100, created filter 2026-11-17T00:00:00Z to -; jobs and attempts have their own completeness flags.
- nightly: Existing #1439 report, as of cycle 2026-11-17: https://github.com/buster14a/buster-performance/blob/nightly-ledger/nightly/reports/2026-11-17.md
- nightly: Carried over: 386 states; the oldest is \`d90075350630d027886cd5a244d2edb48c7d39ce\`, committed 133.8 hours ago.
- nightly: Capacity: 89.7 code states a day arrived over the last 7.0 days; 0.3 completed per cycle over 7 cycles.
- collection: At most 100 runs per workflow/event/time window; all reported conclusions retained. API attempts 0/600, unavailable responses 0; log reads 0/24. Unread CPU/lock values remain unknown.
- sample-design: This is a purposive 12-run illustrative replay. Run-list files are derived projections of retained actual metadata, not original workflow-list responses. Empty projections do not mean no actual runs. Raw responses and projection provenance are retained. Latest/count phrases in collector notes describe replay inputs only; no population, arrival-rate, or causal before/after claim is made.

Main backlog age and coverage remain owned by [#1439](https://github.com/buster14a/buster/issues/1439) and the [existing nightly ledger reports](https://github.com/buster14a/buster-performance/tree/nightly-ledger/nightly/reports). This is not another nightly ledger. Main pushes currently run no checks; historical main-push observations remain a separate cohort.
