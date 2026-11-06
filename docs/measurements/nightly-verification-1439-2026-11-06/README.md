<!-- SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception -->

# Nightly window verification: 2026-11-06

Verification of [buster #1439](https://github.com/buster14a/buster/issues/1439), following #1400, #1410 and #1422. This report separates measured results, failed acceptance criteria, and work still awaiting later cycles.

**Verdict:** the branch-token problem was resolved operationally, and all 26 admitted nightly hardware jobs stayed inside the intended window. The rollout is not fully accepted: both main coordinator window jobs crashed, historical workers repeatedly rejected the expanded window, the comprehensive snapshot failed a benchmark, and the backlog did not keep up with arrivals.

The coordinator crash is corrected in [buster PR #1506](https://github.com/buster14a/buster/pull/1506), with GitHub-hosted regression and dry-run results. Historical-window scheduling is tracked in [#1504](https://github.com/buster14a/buster/issues/1504), and static-host libc discovery in [#1505](https://github.com/buster14a/buster/issues/1505). This report freezes the pre-fix cycle. The coordinator correction was delivered separately in #1506; its effect on a subsequent enabled cycle remains unobserved.

The subsequent corrective PRs and their GitHub-hosted results are recorded in the separate [follow-up validation](followup-validation/README.md). Those checks do not replace production-cycle acceptance or native benchmark evidence.

## Frozen inputs and scope

- Ledger/report checkpoint: [buster-performance `affb8428e68e8defacbb0cfa4c5fe3993258b564`](https://github.com/buster14a/buster-performance/commit/affb8428e68e8defacbb0cfa4c5fe3993258b564), published by [coordinator 42183677391](https://github.com/buster14a/buster/actions/runs/42183677391) at 2026-11-06 07:54:28 UTC.
- Pinned measurement snapshot: [`0eca996a660548aff827c8b1d08789c413d6eba1`](https://github.com/buster14a/buster/commit/0eca996a660548aff827c8b1d08789c413d6eba1).
- Scope: 102 first-parent states from epoch `a98b996eee47442e8298b8a8a96be3a0b876f962` through that snapshot. Newer main commits are outside this cycle's pin.
- Intended hardware interval: **2026-11-06 01:00–07:00 UTC**, equivalent to **02:00–08:00 Europe/Madrid (CET)**.
- Timing sample cutoff: **2026-11-06 07:54:00 UTC**. This is an explicit historical cutoff, not a claim about whatever the latest 100 runs contain when a reader opens the report.
- The archived ledger is the coordinator's harvested record set, checked against job conclusions by its existing harvest logic. The audit did not independently download every coverage-record ZIP a second time.

The raw files and normalized observations accompanying this report retain the source identities and timestamp precision needed to recheck these results. Logs are evidence, never executable inputs.

## Acceptance results

| Requested check | Finding |
| --- | --- |
| Pin at or after 22:00 Madrid | **Pass.** Coordinator [42112798371](https://github.com/buster14a/buster/actions/runs/42112798371) pinned the snapshot at **2026-11-05 21:32:57 UTC / 22:32:57 Madrid**. |
| Branch token accepted; old refused states processed | **Pass operationally.** No token-rejection or branch-refusal warning appeared in the seven executed prepare/window jobs. All four named states completed. This verifies behavior, not the token's permission list or an isolated causal experiment on the workflows permission. |
| Snapshot comprehensive run first | **Order passed; completion failed.** [42140933052](https://github.com/buster14a/buster/actions/runs/42140933052) was the first admission, passed 125 native commands, then failed benchmark-floors. |
| Serial hardware admissions | **Pass.** All 26 actual nightly hook intervals are disjoint. |
| Hardware stays inside the window | **Pass.** First acquire 01:01:42.5629467 UTC; last release 05:37:27.5701772 UTC. All 26 intervals are wholly within 01:00–07:00 UTC. |
| Job length below six hours; no continuation | **Bounds passed, jobs failed.** The two principal window jobs lasted 1:26:21 and 4:06:01, both ending in a pending-record error. Every window-continued job was skipped. |
| Main-push hardware suppressed | **Pass for recorded executions.** All 33 post-#1422 push records in the checkpoint have hardware=skip. There are skipped named job/check entries; literal absence of every hardware-named check was not observed. |
| Post-merge states later measured; complete native coverage | **Not established.** The old backlog did not reach the newer states. Policy retention is not completed coverage. See the coverage section. |
| Dispatched-run records | **Pass for harvested records.** All 130 unique dispatched run/request pairs have final ledger outcomes: 19 preparations and 111 admission requests. |
| Backlog keeps up with arrivals | **Fail at the observed rate.** 25 completed backlog runs this night versus 43.0 arriving code states/day; 49 carried-over states. Post-fix steady capacity remains unmeasured. |
| Before/after queue and occupation | Reconstructed from API/job/hook evidence below, with distinct sampling populations and missing groups preserved. |

### Formerly refused states

| State | Hosted preparation | Successful nightly measurement |
| --- | --- | --- |
| `a98b996e` | [42113652826](https://github.com/buster14a/buster/actions/runs/42113652826) | [42153799671](https://github.com/buster14a/buster/actions/runs/42153799671) |
| `1c656097` | Reused the state's earlier successful plain hosted rows | [42154301928](https://github.com/buster14a/buster/actions/runs/42154301928) |
| `b4a5e33a` | [42113660706](https://github.com/buster14a/buster/actions/runs/42113660706) | [42157110057](https://github.com/buster14a/buster/actions/runs/42157110057) |
| `f969d112` | [42113667952](https://github.com/buster14a/buster/actions/runs/42113667952) | [42158677692](https://github.com/buster14a/buster/actions/runs/42158677692) |

## Requests, execution and coordinator failures

| Request class | Requests | Hardware admitted | Final outcome |
| --- | ---: | ---: | --- |
| Backlog preparation | 18 | 0 | Hosted preparation records |
| Snapshot preparation | 1 | 0 | blocked-hosted: six sanitizer rows failed, while plain rows passed |
| Backlog admission | 110 | 25 | 25 complete, 85 deferred |
| Snapshot admission | 1 | 1 | failed after native correctness |
| **Total** | **130** | **26** | **25 successful measurement completions** |

The generated report's **111 selected** counts admission requests. It does not mean 111 executions on the 9700X. The 85 deferrals consist of 50 requests for `a98b996e` and 35 for `a984aceb`.

The archived `raw/coordinator/coordinator-summary.json` field `unique_admitted_states: 27` likewise counts distinct states receiving admission requests. It includes deferred-only `a984aceb`; **26 distinct states actually acquired the hardware**. The raw file is retained unchanged as historical evidence.

| Coordinator | Window job, UTC | Result |
| --- | --- | --- |
| [42112798371](https://github.com/buster14a/buster/actions/runs/42112798371) | [01:00:12–02:26:33](https://github.com/buster14a/buster/actions/runs/42112798371/job/127640357507) | Exit 2 after 19 inherited preparations plus 46 admission requests |
| [42144194672](https://github.com/buster14a/buster/actions/runs/42144194672) | [02:29:26–06:35:27](https://github.com/buster14a/buster/actions/runs/42144194672/job/127672762827) | Exit 2 after 65 admission requests |
| [42156221075](https://github.com/buster14a/buster/actions/runs/42156221075) | [06:38:02–06:38:40](https://github.com/buster14a/buster/actions/runs/42156221075/job/127753427342) | Success; no more work fit |
| [42183677391](https://github.com/buster14a/buster/actions/runs/42183677391) | Window skipped; prepare/report at 07:53:43–07:54:33 | Published the checkpoint |

Both failed jobs reported `nightly: invalid pending dispatches, branches or refused branches`. The source capped pending input at 64 rows while the shell retained every request ever dispatched during that job. [PR #1506](https://github.com/buster14a/buster/pull/1506) validates every row, removes observed/expired pending entries, preserves unseen active requests, and atomically writes the compacted handoff. It keeps the active limit at 64 and retains the existing 600-second visibility grace.

The preparation phase had two transient HTTP 502 harvest warnings for run 41949347963; these were retried. They were not branch-token rejection warnings.

### Historical workers still enforce the old window

Each worker runs the workflow and tool at its immutable target SHA. Older targets therefore retain 04:00–07:00 Madrid even though the coordinator plans 02:00–08:00.

- [Evidence job 127669457597](https://github.com/buster14a/buster/actions/runs/42149637727/job/127669457597) rejected `a98b996e` at 02:20:39 UTC because it was before 04:00 Madrid.
- [Evidence job 127733945261](https://github.com/buster14a/buster/actions/runs/42169566173/job/127733945261) rejected `a984aceb` at 05:38:12 UTC because the job could not finish before 07:00 Madrid.
- A window-deferred state remains ready; the coordinator repeatedly picks that oldest state. The resulting request loop also exposed the lifetime pending-row limit.

[#1504](https://github.com/buster14a/buster/issues/1504) records two possible approaches: account for the historical worker's actual window and consider other eligible states meanwhile, or separately version a current worker that checks out historical source. This audit does not silently transplant workflows, rewrite historical targets, or invent manual overrides.

## Comprehensive snapshot failure

The [snapshot hardware log](https://github.com/buster14a/buster/actions/runs/42140933052/job/127640941460) reports a static build at 01:01:49 UTC and **125 passed, zero failed, zero skipped, zero not started** native commands at 01:05:12 UTC. At 01:12:05 UTC, benchmark-floors failed with `the calls on libc.so.6 failed (Success)`; later measurement steps were skipped. The [record job](https://github.com/buster14a/buster/actions/runs/42140933052/job/127645042489) correctly records coverage=full, outcome=failed.

Source diagnosis: floors_benchmark_libc discovers shared libc solely from /proc/self/maps. [#1431](https://github.com/buster14a/buster/pull/1431) introduced the static executable default; a static executable has no such mapped libc. The unchanged lookup returns false without setting errno. This explanation is inferred from the build log and exact source, not a new local benchmark. [#1505](https://github.com/buster14a/buster/issues/1505) tracks a correction that retains the benchmark.

The failed snapshot held the lock for about 623 seconds, versus 1,189 seconds for the successful November 5 snapshot. The shorter failed run is **not a performance improvement**: it terminated early.

## Native coverage and main pushes

The checkpoint contains 33 pushes since #1422's 13:40 UTC merge on November 5. All have hardware=skip; **17 outcomes are deferred and 16 are blocked-hosted**. Admission deferral and the final workflow outcome are different fields: sanitizer failures remain visible rather than being mislabeled deferred.

The first and last such push job lists were spot-checked: [42037894481](https://github.com/buster14a/buster/actions/runs/42037894481) and [42131306512](https://github.com/buster14a/buster/actions/runs/42131306512). Hardware execution and aggregate qualification were skipped. GitHub still exposes skipped jobs/checks with those names; the accurate statement is no hardware execution or successful hardware qualification.

Of these 33 pushed states, 26 are within this cycle's snapshot and seven are newer than the pin. None of the 26 has a completed measurement record in the checkpoint. The snapshot itself passed native correctness but failed its measurements; the other successful nightly jobs all belong to the historical backlog. The seven newer states properly belong to a later cycle.

The 102-state report has 48 complete, 49 ready, four blocked-hosted and one not-required. The documentation-only state `fad4ce7122a357ca8fd0d41c74deaddaee3df8f8` changes only docs/checker-layout-1175.md and is explicitly exempted by the existing planner. Consequently, a literal claim that every exact main SHA has completed native correctness would be inaccurate, independently of the pending backlog.

Every admitted nightly worker still runs the complete native inventory belonging to its own revision before measurements. The 25 successful historical workers ran 118 commands each except the last, which ran 119; the current snapshot ran 125. No inventory reduction was made by this audit or PR #1506. Retaining that rule does not prove already-completed coverage of all current main states.

## Capacity across the available cycles

| Published cycle report | First-parent states in scope | Completed nightly runs that cycle | Carried over | Oldest pending age | Arrival estimate |
| --- | ---: | ---: | ---: | ---: | ---: |
| [2026-11-05](https://github.com/buster14a/buster-performance/blob/affb8428e68e8defacbb0cfa4c5fe3993258b564/nightly/reports/2026-11-05.md) | 49 | 1 successful snapshot | 38 | 39.1 h | 39.9 code states/day |
| [2026-11-06](https://github.com/buster14a/buster-performance/blob/affb8428e68e8defacbb0cfa4c5fe3993258b564/nightly/reports/2026-11-06.md) | 102 | 25 backlog; snapshot failed | 49 | 42.9 h | 43.0 code states/day |

The generated mean of 13 completed per cycle is (1 + 25) / 2; it mixes two rollout cycles with different malfunctions. Even the newer night's 25 completions are below the 43/day arrival estimate. At that unchanged observed rate, the backlog would grow by about 18 code states/day; that is arithmetic under a fixed-rate assumption, not a forecast of a corrected system.

Carried-over states increased by 11: November 5 had 20 ready and 18 needing preparation; November 6 had 49 ready. The oldest changed from `a98b996e` to `a984aceb`, confirming real oldest-first progress, but that oldest outstanding state was still 42.9 hours old. Four blocked-hosted states are counted separately from the 49 carried-over ready states.

The 26 nightly lock intervals sum to **7,623.7852554 seconds (2 h 7 m 3.785 s)**. That is occupation by these nightly jobs, including the failed snapshot. It is not total machine utilization or proof that the remaining time was idle: PR jobs and agent sessions share the host. Neither the timeout bound nor a PR's targeted benchmark time should be substituted for measured nightly service time.

Post-fix steady capacity needs later enabled cycles with successful comprehensive snapshots and the historical-window mismatch resolved. The present evidence supports keeping the capacity alert.

## Queue and occupation before and after

The scheduled November 6 timing report was not available in the repository-run inventory checked by this audit. The statistics below were reconstructed with read-only API/job/log retrieval and the same definitions as [timings.sh](https://github.com/buster14a/buster/blob/0eca996a660548aff827c8b1d08789c413d6eba1/tools/ci/timings.sh) and timings.c: successful hardware jobs, complete latest-attempt job lists, median, nearest-rank p95, and hook wait/hold rounded to whole seconds. No missing timestamp or absent class becomes zero.

**The latest 100 at the frozen cutoff contain no PR timing sample.** They span runs [42144217065](https://github.com/buster14a/buster/actions/runs/42144217065) through [42175219140](https://github.com/buster14a/buster/actions/runs/42175219140), created 01:29:52–06:33:48 UTC. All are nightly backlog dispatches: 25 successful hardware jobs and 75 deferred requests. The snapshot and all PR/main-push classes are absent.

| Latest-100 nightly targeted metric | n | Median, s | p95, s |
| --- | ---: | ---: | ---: |
| Hardware queue | 25 | 1 | 2 |
| Execution | 25 | 292 | 422 |
| Runner hook | 25 | 1 | 1 |
| Lock wait | 25 | 1 | 1 |
| Lock hold | 25 | 286 | 415 |
| Setup/build | 25 | 49 | 50 |
| Native tests | 25 | 111 | 114 |
| Host occupation | 25 | 289 | 420 |
| Successful benchmark steps | 20 | 94 | 209 |

The benchmark-step row has n=20 because the existing extractor emits it only when at least one successful Benchmark, Measure or Attribute step exists. Host occupation runs from the first Verify benchmark host step to job completion; lock hold comes from the hooks' own acquire/release timestamps. These measures are close but not interchangeable.

### Supplemental PR cohort

To obtain a PR comparison without misrepresenting the latest-100 sample, the audit separately enumerated **all 201 PR-triggered 9700x.yml runs created from 2026-11-05 13:40 UTC through 2026-11-06 07:54 UTC**. All latest-attempt job lists were checked. There were 47 successful hardware jobs. The 150 non-success workflows contributed no successful hardware job: their hardware jobs were 103 skipped and 47 cancelled. Thus the cohort uses the same job-success filter as the timing script, including inspection of failed/cancelled workflows.

Baseline sources are the [November 4 timing report](https://github.com/buster14a/buster/actions/runs/41846130451/job/126630090535) and the [November 5 report posted to #1207](https://github.com/buster14a/buster/issues/1207#issuecomment-6662202415). The November 5 baseline was itself collected at 15:35 UTC from a rolling latest-100 sample; it is a congested baseline observation, not a clean non-overlapping experimental control. Values below are **median / p95 in seconds**.

| PR metric | November 4, n=52 | November 5, n=33 | Supplemental post-#1422 cohort, n=47 |
| --- | ---: | ---: | ---: |
| Hardware queue | 32.5 / 4314 | 767 / 4158 | **56 / 931** |
| Execution | 346 / 517 | Not reported in the cited baseline | 344 / 732 |
| Runner hook | 1 / 2 | 45 / 195 | 4 / 274 |
| Lock wait | Not measured | 45 / 195 | **4 / 274** |
| Lock hold | Not measured | 259 / 512 | 283 / 488 |
| Host occupation | 342.5 / 514 | Not reported in the cited baseline | **287 / 492** |

Against the congested November 5 observation, PR median queue fell about 92.7% and median lock wait about 91.1%. Median lock hold increased about 9.3%. Against November 4, host occupation was lower, but the queue median was higher and execution p95 increased. These are different workload/time cohorts and do not isolate #1422 as the sole cause.

Examples include [the first successful hardware job in the supplemental cohort](https://github.com/buster14a/buster/actions/runs/42040791975/job/127297372943), [the most recent](https://github.com/buster14a/buster/actions/runs/42141370286/job/127652723785), and [the longest execution](https://github.com/buster14a/buster/actions/runs/42120777547/job/127577236152): 1,194 seconds, of which 1,132 seconds were hook/lock waiting. The raw timestamp table contains all 47 jobs and their exact URLs.

The PR native-test and setup/build metrics have no samples under the script's current extraction definition, because the PR native correctness step is intentionally skipped. This does not mean a zero-cost build or establish absent hosted correctness.

### Main pushes and full snapshots

| Metric | November 4 | November 5 | Post-#1422 checkpoint |
| --- | ---: | ---: | --- |
| Main-push queue, median / p95 | 2 / 633 s, n=3 | 2783 / 4596 s, n=8 | No admitted hardware job among 33 recorded pushes; no per-job latency sample |
| Main-push host occupation, median / p95 | 285 / 342 s, n=3 | Not reported in the cited baseline | No hardware occupation by these deferred/skipped push jobs |
| Main-push lock wait, median / p95 | Not measured | 55 / 458 s, n=8 | No admitted hardware job |
| Main-push lock hold, median / p95 | Not measured | 257.5 / 461 s, n=8 | No admitted hardware job |
| Snapshot lock wait / hold | No comparable observation retained here | 3 / 1189 s, one successful snapshot | 1 / 623 s, one **failed** snapshot outside the latest-100 cohort |

The main-push hardware suppression is an observable change, while deferred native coverage remains outstanding. The failed snapshot must not be presented as a faster completed full run.

## Validation of the bounded fix

PR #1506 changes only tools/ci/nightly.c, tests/ci/nightly.sh and docs/commands/ci.md. An independent static review found no outstanding defect. The code keeps duplicate-admission protection while compacting stale/observed pending requests. Original project code and fixtures were added; no external implementation or generated corpus was imported.

The GitHub-hosted [nightly decisions/glue job](https://github.com/buster14a/buster/actions/runs/42190430421/job/127800801538) and [evidence/cache job](https://github.com/buster14a/buster/actions/runs/42190430377/job/127800802229) passed. Each ran the self-test with 163 checks and zero failures in optimized and AddressSanitizer/UndefinedBehaviorSanitizer builds, followed by the extended glue fixtures. The read-only coordinator dry run, selector, DCO hook/audit, guide-size and measurement-storage checks also passed. Broader PR CI is linked from the PR and may complete after this report.

The new regressions exercise 73 inherited rows, 70 observed requests, unseen hardware/preparation requests, queued-run protection, the 599/600-second boundary, future timestamps, malformed historical rows, invalid refs/options and 65 genuinely active requests. No local compiler build, test or performance run was performed.

## Evidence layout and reproduction

- [observations.tsv](observations.tsv): all 26 admitted nightly jobs, including the failed snapshot, and all 47 successful PR hardware jobs. It preserves exact hook timestamps, normalized durations and source job URLs.
- [metrics.json](metrics.json): final cohort definitions and summary statistics.
- [coverage-records.tsv](coverage-records.tsv): all 130 cycle request/run records.
- [timings-latest100.tsv](timings-latest100.tsv) and [timings-pr-after1422.tsv](timings-pr-after1422.tsv): headerless job-id/group/metric/seconds inputs accepted by the existing C timing reader. The failed snapshot is excluded from successful-job quantiles but retained in observations.
- [raw-evidence.tar.gz](raw-evidence.tar.gz): raw API run/job objects, hook excerpts, coordinator logs, snapshot failure/record evidence, ledger checkpoint, source-state paths, baseline excerpts, request manifest and audit notes.
- [SHA256SUMS](SHA256SUMS): hashes of the report and delivered evidence files. The extracted raw directory has its own SHA256SUMS.

Verify the outer files, extract the archive and verify the inner files with these single-line commands:

```sh
sha256sum -c SHA256SUMS
tar -xzf raw-evidence.tar.gz
(cd raw && sha256sum -c SHA256SUMS)
```

To regenerate the quantiles, use tools/ci/timings.c from Buster snapshot `0eca996a660548aff827c8b1d08789c413d6eba1` (Git blob `2fb20666859425777c550e72b7c9ef15f9d11964`). Its extraction companion tools/ci/timings.sh has blob `0225f2632573f150398ecee703e6f8d317b809ca`. Set BUSTER_CHECKOUT to that checkout; on a disposable reporting/hosted runner, the existing reader can be invoked with:

```sh
cc -std=c17 -O2 -Wall -Wextra -Werror -fno-strict-aliasing "$BUSTER_CHECKOUT/tools/ci/timings.c" -o /tmp/buster-ci-timings && /tmp/buster-ci-timings < timings-latest100.tsv
/tmp/buster-ci-timings < timings-pr-after1422.tsv
```

These are offline reporting commands, not benchmark commands. This audit reconstructed the calculations using read-only arithmetic and independently checked the retained long-format inputs; it did not run a local compiler build or timing executable. The raw timestamp observations, cohort enumerations and exact source identities are the basis of the comparison. API responses and workflow logs come from the owner's public repositories; no credentials, new external implementation, external benchmark input corpus or license change is introduced.

## Recheck and closure boundary

After the corrective changes are reviewed and merged, repeat the audit for subsequent enabled cycles: pin identity, token warnings, worker-specific admission windows, all actual hardware hook intervals, complete snapshot outcome, per-run records, new-main-state native coverage, carried-over/blocked counts, oldest pending age, arrivals and completions. Preserve the same timing definitions and distinguish absent classes from zero duration.

Issue #1439 should remain open while the comprehensive snapshot, effective window behavior, current-main coverage and sustained capacity remain unverified. An observation of failure is a completed audit finding; it is not a passing acceptance check.

---
Agent session: 01a1afff-6d1a-7609-84e2-3a5518fc904e (OpenAI session ID; no private session URL is exposed)
Model: OpenAI / GPT-6 Astra Pro

Parallel work in the same session: coordinator audit thread 01a1b001-6105-7220-b90b-10b4a4d03045; pending-fix thread 01a1b002-7af5-7477-afe6-a98aee9b5054. All use OpenAI / GPT-6 Astra Pro. Timing-audit attribution accompanies its retained source notes.

Publication and independent evidence review: session 01a1b01e-f9a7-752f-9ade-46286198507d, review thread 01a1b021-bdad-733f-ba54-b4cbc8135073; OpenAI / GPT-6 Astra Pro. No private session URL is exposed. The publication review checked the archive manifest, both timing cohorts and the exact hook intervals; it clarified the frozen-cycle boundary and the historical request-count label above without changing the raw evidence or reported measurements.
