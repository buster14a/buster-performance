<!-- SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception -->

# Nightly verification: November 7–26, 2026

Follow-up production verification for [buster #1439](https://github.com/buster14a/buster/issues/1439), continuing the [frozen November 6 audit](../nightly-verification-1439-2026-11-06/README.md).

**Verdict: the original coordinator fixes work in the observed winter cycles, but overall nightly acceptance still fails.** All 40 post-fix coordinator window invocations succeeded. Eight of the 20 daily snapshot admissions completed native correctness and full measurements; twelve were blocked, failed or interrupted. The latest seven cycles completed 155 distinct states, against an arrival estimate of 64.6 code states/day. The latest checkpoint still has 1,224 code states without completed targeted/full evidence.

The observations below are historical evidence, not a new hardware campaign. This session did not access the 9700X, dispatch a workflow, rerun a hardware job, alter a historical worker, or change coverage policy.

## Frozen sources and scope

- Compiler/source interpretation: [`8e4d32879e17b7d9548cad54257a2f8461328366`](https://github.com/buster14a/buster/tree/8e4d32879e17b7d9548cad54257a2f8461328366). The reporting-only follow-up is recorded separately below.
- Ledger and all 22 retained daily reports, November 5–26: [`bf8108aa9d8257f6dbe6049013f1832bd913c1e8`](https://github.com/buster14a/buster-performance/tree/bf8108aa9d8257f6dbe6049013f1832bd913c1e8/nightly), published **November 26 at 06:43:34 UTC / 07:43:34 Madrid** by [45758471286](https://github.com/buster14a/buster/actions/runs/45758471286). All 23 ledger/report files were checked against their Git blob identities.
- Corrected-cycle cohort: **November 7–26 inclusive, 20 calendar cycles**. The earlier November 6 failure remains in the original report; it is not counted as a corrected-cycle success.
- Coordinator API cohort: all 183 scheduled and one main-branch manual run created November 6–26, 184 runs and 615 jobs. The first November 6 coordinator was created November 5 and is retained separately as carry-in evidence.
- Hardware log scope: all eight successful post-fix full native-measurement jobs, the three latest failed snapshots, and **every one of the 40 November 26 hardware jobs**. This does not assert a hook-level audit of every hardware job on all 20 dates.
- Current latency baseline: [CI latency report 45672313603](https://github.com/buster14a/buster/actions/runs/45672313603), collected November 25 at **18:10:33 UTC**, source `09c3b79bab04f0e1b37afbef611a9e7f0937b055`. Its original artifact is retained and its published SHA-256 verified.

All stated window times use Europe/Madrid. In this winter cohort **02:00–08:00 Madrid is 01:00–07:00 UTC**. No DST transition falls within the post-fix cohort, so production fall-back continuation is not claimed as observed.

## Acceptance matrix

| Requirement | Verified result |
| --- | --- |
| Original corrective PRs landed | [#1506](https://github.com/buster14a/buster/pull/1506), [#1510](https://github.com/buster14a/buster/pull/1510) and [#1508](https://github.com/buster14a/buster/pull/1508) all merged November 6. The original audit publication, buster-performance #273, also merged. |
| Corrected coordinator completes within its job limit | **Pass for observed cycles.** All 40 non-skipped November 7–26 window invocations succeeded: 20 long coordinating jobs plus 20 short trailing rechecks. Maximum 20,186 s, or 5 h 36 min 26 s. Every continuation job was skipped. |
| Snapshot pin at/after 22:00 Madrid | **Pass for all 20 recorded pins.** Exact dates, SHAs and pin times are in `cycle-summary.tsv`. November 7 pinned at 22:02:36 the evening before; November 26 pinned at 00:40:05 that morning. |
| Previously refused branches and branch-token behavior | The November 6 audit already verified all four named formerly refused states completed. The retained November 7 and 26 prepare/window logs have no branch-token rejection warning. This is observed behavior, not a new token-permissions audit or causal experiment. |
| Snapshot admitted before backlog | The first corrected cycle and latest cycle logs dispatch the full snapshot first. November 7: one snapshot plus 22 backlog requests. November 26: one snapshot plus 39 backlog requests. Requests are not distinct-state completions. |
| Hardware serialization/window | **Pass for all 40 November 26 intervals and the eight successful snapshot intervals.** November 26 acquire/release pairs are disjoint and wholly within 01:00–07:00 UTC. |
| Successful later full snapshots | **Eight native/full-measurement admissions complete; twelve do not.** Exact native inventories and full job verdicts are verified below. These eight are not eight fully green hosted-diagnostic cycles. |
| Backlog keeps up with arrivals | **Fail.** Latest seven calendar cycles: 155 different completed states, 22.1/day including four snapshots; 151 backlog states, 21.6/day. Reported code-state arrivals: 64.6/day. Every retained daily report contains the capacity alert. |
| Every eligible main state has completed required evidence | **Fail.** 309 complete of 1,533 non-exempt states; 1,224 incomplete. Hosted merge-queue qualification and actual nightly completion are distinct. |
| Main-push policy | **Superseded explicitly.** The owner moved the full hosted contract to exact merge-queue candidates and removed main-push checks on November 10. The original main-push acceptance wording is historical. Nightly per-state obligations remain. |
| Completion deadline and missing-cycle/recovery observer | **Gap confirmed in inspected source.** Repeated schedules recover some coordinator API failures, but there is no independent expected-calendar-cycle observer. Filed as [#3627](https://github.com/buster14a/buster/issues/3627). External monitoring outside this repository was not inspected. |

## Daily full snapshot measurements

`complete` in this table means the admitted snapshot's native correctness and full measurements completed. Its deferred preparation run is separate: it performs hosted/sanitizer/fuzz diagnostics. Plain hosted qualification can admit measurement even if those broader diagnostics fail, under the existing policy.

**November 13 is an observed mixed result:** [preparation 43314889186](https://github.com/buster14a/buster/actions/runs/43314889186) is `blocked-hosted` with plain rows passing, while its native/full-measurement admission completed. Other `deferred` preparation rows are not independently an exhaustive successful-job receipt. `snapshot-preparations.tsv` retains every preparation and admission outcome; this report does not relabel them all green.

| Cycle | Exact pin prefix | Admitted snapshot | Native/full-measurement outcome | Independently checked native inventory |
| --- | --- | --- | --- | --- |
| Nov 7 | `f4272a467c00` | [42321791875](https://github.com/buster14a/buster/actions/runs/42321791875) | complete | 126/126 passed |
| Nov 8 | `94e166ec6cc8` | [42432525416](https://github.com/buster14a/buster/actions/runs/42432525416) | blocked-native | Ledger outcome; full log not reread here |
| Nov 9 | `595f06cde6f0` | [42543322471](https://github.com/buster14a/buster/actions/runs/42543322471) | blocked-native | Ledger outcome; already identified by #2029 |
| Nov 10 | `647340a44ae1` | [42732660559](https://github.com/buster14a/buster/actions/runs/42732660559) | blocked-native | Ledger outcome |
| Nov 11 | `495971161233` | [42935846494](https://github.com/buster14a/buster/actions/runs/42935846494) | blocked-native | Ledger outcome |
| Nov 12 | `0bad01948872` | [43131788329](https://github.com/buster14a/buster/actions/runs/43131788329) | interrupted | Ledger outcome |
| Nov 13 | `090b0faa8c59` | [43341714661](https://github.com/buster14a/buster/actions/runs/43341714661) | complete; hosted preparation blocked | 140/140 passed |
| Nov 14 | `013ceb613493` | [43538151259](https://github.com/buster14a/buster/actions/runs/43538151259) | complete | 141/141 passed |
| Nov 15 | `45cd9aec77c4` | [43661227560](https://github.com/buster14a/buster/actions/runs/43661227560) | interrupted | Ledger outcome |
| Nov 16 | `639e730ed3db` | [43783883267](https://github.com/buster14a/buster/actions/runs/43783883267) | failed | Ledger outcome |
| Nov 17 | `178c9e2606fb` | [43992356652](https://github.com/buster14a/buster/actions/runs/43992356652) | failed | Ledger outcome |
| Nov 18 | `bd197b2a6257` | [44212612100](https://github.com/buster14a/buster/actions/runs/44212612100) | failed | Ledger outcome |
| Nov 19 | `0c113feb16d9` | [44433733494](https://github.com/buster14a/buster/actions/runs/44433733494) | complete | 150/150 passed |
| Nov 20 | `903bf7ef4300` | [44650577795](https://github.com/buster14a/buster/actions/runs/44650577795) | complete | 150/150 passed |
| Nov 21 | `549613156796` | [44847654516](https://github.com/buster14a/buster/actions/runs/44847654516) | complete | 152/152 passed |
| Nov 22 | `fbef2d68dfc9` | [44969521006](https://github.com/buster14a/buster/actions/runs/44969521006) | complete | 154/154 passed |
| Nov 23 | `16ed0534fa45` | [45092455320](https://github.com/buster14a/buster/actions/runs/45092455320) | complete | 155/155 passed |
| Nov 24 | `b7d0b5edff73` | [45302644116](https://github.com/buster14a/buster/actions/runs/45302644116) | failed measurement | 165/165 passed; Zen 5 model check then failed |
| Nov 25 | `1c5287c369e4` | [45522673652](https://github.com/buster14a/buster/actions/runs/45522673652) | blocked-native | 165/166 passed; assembly sink failed |
| Nov 26 | `86427a9f58dd` | [45732894905](https://github.com/buster14a/buster/actions/runs/45732894905) | blocked-native | 166/167 passed; assembly sink failed |

Full SHAs, run attempts and the coverage/host/protocol fields are retained in the raw ledger and derived tables. All eight successful jobs show zero native failures, skips or commands not started; their full job conclusions and the floors benchmark steps are successful. This supplies the successful post-#1508 production evidence that the November 6 handoff lacked. It does not retroactively repair historical failed source revisions.

### Latest failures

- **November 24:** [native job 138138926142](https://github.com/buster14a/buster/actions/runs/45302644116/job/138138926142) passed 165 native commands, then the Zen 5 reproduction check reported **260 of 261 cases reproduce the table** and exited 1. Later measurements were skipped. This is a failed full measurement, despite successful native correctness.
- **November 25 and 26:** [job 138898382844](https://github.com/buster14a/buster/actions/runs/45522673652/job/138898382844) and [job 139619187369](https://github.com/buster14a/buster/actions/runs/45732894905/job/139619187369) fail `Test the assembly sink against GNU as`. Both report `relocation 0 of section 10 is wrong: offset 8, type 10, symbol 6`, twice, and **258 checks, 2 failures**. All 4,474 instruction forms / 8,948 records still compare successfully. The active [#1362 claim](https://github.com/buster14a/buster/issues/1362#issuecomment-7186883952) covers this assembly/relocation work; no overlapping implementation was started here. The assertion was added with #3548; that establishes lineage, not a new root-cause diagnosis.
- **November 26 backlog:** all 32 failed attempts fail `Benchmark the code certificates of the frozen SQLite source's functions`. A retained representative [job 139648055742](https://github.com/buster14a/buster/actions/runs/45741664611/job/139648055742) passed all 150 native commands, then reported `a function's code certificate refused it: no report`. This historical failure is already tracked in [#2870](https://github.com/buster14a/buster/issues/2870).

## Capacity and the coverage deficit

| Latest first-parent-state classification | States |
| --- | ---: |
| In scope through the pin | 1,611 |
| Documentation-only, not-required | 78 |
| Complete targeted/full evidence | 309 |
| Blocked-native | 624 |
| Blocked-hosted | 80 |
| Failed | 11 |
| Ready | 509 |
| In flight / preparing / needs preparation | 0 |

**1,224 of 1,533 non-exempt states remain without completed required measurements:** 509 ready plus **715 blocked or failed**. This is a native/measurement completion deficit, not proof that 1,224 states have no successful native test at all: some failed after native correctness. The report's carried-over count deliberately omits blocked/failed states and must not be read as the whole deficit.

The reported oldest ready/pending state is `dc58207037ab92f1ba052151e107bd8c61deb2f8`, **252.8 hours** old. Including blocked/failed states, the oldest outstanding code state is [`81d5c137bfa94b8b689bf6d65f91b461de9ae8ad`](https://github.com/buster14a/buster/commit/81d5c137bfa94b8b689bf6d65f91b461de9ae8ad), committed November 4 at 00:04:18 UTC, approximately **534.7 hours / 22.3 days** old at publication. Its [hosted preparation 41914936297](https://github.com/buster14a/buster/actions/runs/41914936297) failed. The six earlier in-scope first-parent states have complete records; its code changes exclude the documentation exception.

| Cohort | Admission requests | Completed distinct states | Important distinction |
| --- | ---: | ---: | --- |
| Nov 7–26, 20 calendar cycles | 933 | 261 | 8 full snapshots plus 253 targeted backlog states |
| Nov 20–26, 7 calendar cycles | 284 | 155 | 4 full snapshots plus 151 targeted backlog states |
| Nov 26 only | 40 | 7 | 1 failed full snapshot; 39 backlog attempts across 18 distinct states |

The seven-cycle outcomes reconcile to **155 complete, 95 blocked-native, 33 failed and one deferred**. Each successful record names a different run and state. All seven calendar dates have admissions and no run-attempt reruns inflate this sample. Historical states were retried in separate failed dispatches, which remain failed attempts rather than extra completions.

Thus the printed **22.1 complete admissions/cycle** equals 155/7 distinct states per calendar day in this particular sample. Backlog-only throughput is **21.6/day**. The arrival figure **64.6 code states/day** is the production report's estimate; its original complete state/path input was not archived, so the arrival classification was not independently regenerated. Keeping those rates fixed would imply about 42.5 more unresolved states per day. That is arithmetic, not a forecast or evidence that retries/old failures can be fixed merely by adding slots.

The generic capacity calculation can count repeated successful attempts and omit a calendar day with no admissions; neither affects these inspected seven dates. All 22 retained daily reports contain the capacity alert. Historical workers retain their source and outcomes: current fixes or a targeted success elsewhere do not justify silently marking them covered. #2029's [November 23 update](https://github.com/buster14a/buster/issues/2029#issuecomment-7112854365) leaves replaying historical revisions with fixed tests as an explicit maintainer decision.

## Hardware time and before/after comparison

Every November 26 hook interval lies within **01:02:22.7300603–06:36:50.3641329 UTC**, with no overlap. The forty intervals sum to **16,351.5595482 s = 4 h 32 min 31.56 s**, or **75.70% of the six-hour window** occupied by these jobs. This does not prove the remaining time was idle; other users share the machine.

| November 26 cohort | Executions | Distinct states | Exact total lock hold |
| --- | ---: | ---: | ---: |
| Successful backlog | 7 | 7 | 3,554.0231461 s |
| Failed backlog | 32 | 11 | 12,451.4544887 s — 3 h 27 min 31.45 s |
| Failed full snapshot | 1 | 1 | 346.0819134 s |
| Total | 40 | 19 | 16,351.5595482 s |

The queue metric is **hardware job start minus that job's creation**, not workflow creation. Lock wait starts at the runner's `job-started.sh` group and ends at `this job has the machine`; lock hold ends at `gave the machine back`. API execution/host-occupation spans are different overlapping metrics and are never added to lock hold. Quantiles below use the existing timing reader's integer-second inputs, median and nearest-rank p95; exact hook timestamps are retained separately.

| Successful nightly targeted jobs | n | Queue median / p95 | Lock wait median / p95 | Lock hold median / p95 |
| --- | ---: | ---: | ---: | ---: |
| Frozen Nov 6 latest-100 cohort | 25 | 1 / 2 s | 1 / 1 s | 286 / 415 s |
| Nov 26 complete backlog cohort | 7 | 1 / 2 s | 1 / 1 s | 491 / 575 s |

Queue and lock contention remain low in these cohorts, while the successful backlog service time is larger. The 205-second median-hold difference is **not an isolated compiler regression measurement**: the workload, native inventory, source age, selection and host software differ. All-outcome November 26 medians are queue 1 s, lock wait 1 s and lock hold 436.5 s. Failed jobs must remain in occupation totals, but must not be called faster successful runs.

The original before/after PR comparison remains in the [November 6 report](../nightly-verification-1439-2026-11-06/README.md#queue-and-occupation-before-and-after): the congested November 5 PR cohort had median hardware queue / lock wait **767 / 45 s**, versus **56 / 4 s** in its supplemental post-#1422 cohort. Their populations partially overlap and are observational, not a controlled causal comparison.

Current ordinary PRs and merge-queue candidates do not run the 9700X. Their nonexistent hardware latency distribution is **not applicable**, not zero seconds. The retained ledger has 685 queue records for 681 states: 681 deferred/skip records and four invalid records conservatively labeled admit. Both job pages for each exceptional run were checked; each Benchpress job was cancelled with no runner allocation and no steps. None provides evidence of hardware execution. The ledger excludes PR rows by design, so PR timing evidence comes from #2034's report.

### Current hosted feedback baseline from #2034

The retained [November 25 timing report](https://github.com/buster14a/buster/actions/runs/45672313603/job/139410820513) sampled the latest ten PR workflows created **15:53:58–18:03:51 UTC**. It retains seven successful, two failed and one partial workflow. These are hosted feedback/resource metrics, not replacements for the historical hardware-queue metric.

| Current `9700x.yml` PR metric | Available observations | Median | p95 |
| --- | ---: | ---: | ---: |
| First useful feedback | 10/10 | 29.5 s | 36 s |
| Completion proxy | 9/10 | 714 s | 797 s |
| Longest allocated job queue wait | 10/10 | 2.5 s | 4 s |

The collector's complete sample contains 143 runs, 143 attempts and 2,988 jobs across workflows/events. It has no before/after split and has incomplete reads, which remain explicitly unknown. Its last-ten main-push cohort is historical because main no longer has push checks. Account concurrency is not administratively established; do not turn available runner-minutes or historical cohorts into a claim about current account saturation. The exact ZIP, summary, collection settings and replay verification are retained below.

## Current policy and recovery

The [November 10 owner decision](https://github.com/buster14a/buster/issues/2029#issuecomment-6765050488) moved the full hosted contract to the exact merge-queue candidate and removed duplicate main-push checks. The latest report lists 681 merged states since the first queue candidate with no exact-candidate coverage gap. That hosted observation does not satisfy missing native measurements.

[#3525](https://github.com/buster14a/buster/pull/3525), merged November 24, permits a four-command `znver5` smoke on a backlog state only when its same SHA has successful repository queue qualification, Integration qualification and the explicit complete vector verdict. Incomplete evidence keeps the full native inventory. Snapshots and manual full dispatches always keep the full inventory. Therefore the original literal assertion that every main state repeats every native command on the 9700X has been superseded by this explicit evidence-based policy; the audit must record the mode and source instead of pretending no policy changed.

Five post-fix coordinators failed during daytime preparation while listing API runs: four HTTP 502 failures and one installation rate-limit HTTP 403. Each was followed by a successful scheduled coordinator. All 61 cancelled coordinators in the enumeration have zero jobs, consistent with pending replacement; they do not evidence active-window cancellation. The only manual main coordinator was dry-run. The detailed source-linked recovery table is retained in `coordinator-audit.md`.

The physical deadline remains **08:00 Madrid**. Multiple cron opportunities and handoff help a late coordinator recover existing state, but do not guarantee a full measurement by that deadline. Once an admitted snapshot fails or is interrupted, `snapshot_attempted` prevents another automatic full attempt in that cycle. The same-concurrency 08:17 report and the 08:37 latency report are not independent missing-calendar-cycle observers. No wholly absent date was found in the observed cohort; the absent-date gap is established from current source. [#3627](https://github.com/buster14a/buster/issues/3627) now tracks the bounded observer/deadline/recovery work without replacing the ledger or widening hardware hours.

## Reporting fix and remaining acceptance

The accompanying reporting-only change, [buster #3649](https://github.com/buster14a/buster/pull/3649), adds **Full snapshot measurement** to the existing nightly report. It names the exact target, pin/substitute distinction, run and attempt, recorded coverage and outcome. Only a harvested full/admitted/complete record can produce `complete`; targeted work, a green coordinator, or a newer unrecorded attempt cannot. Earlier failures and interruptions stay visible. It does not change planning, retries, windows, record format or hardware use. Exact source and validation are recorded in `validation.md`.

#1439 should remain open for unresolved production acceptance. This report completes the requested subsequent-cycle verification and updated capacity/before-after evidence; it does not make the failed criteria pass. Concrete remaining work is the current assembly failure with #1362's owner, the historical code-certificate blocker #2870, the backlog/replay/capacity decisions coordinated in #2029, and the missing-cycle observer #3627. A new successful source snapshot must actually run before it can be recorded as passed.

## Evidence layout and reproduction

- `cycle-summary.tsv`: all retained cycle totals, pin identity/time, outcomes and capacity lines.
- `snapshot-preparations.tsv`: all twenty full hosted preparations beside their snapshot admissions.
- `snapshot-native-inventories.tsv`: exact native command summaries and job links for the eight successful snapshots and three latest failures.
- `hardware-intervals.tsv`: all forty November 26 hardware jobs and exact hook observations.
- `metrics.json`, `successful-backlog-input.tsv`, `successful-backlog-summary.md`, `successful-full-input.tsv`, `successful-full-summary.md`: independently reviewed timing data and the existing C reader's outputs.
- `ledger-audit.md`, `coordinator-audit.md`, `recovery-audit.md`: detailed subtask methods and boundaries.
- `ci-timings-45672313603-1.zip`: original GitHub artifact (194 entries), SHA-256 `941b7690d65727b3b5be4362733009385b66e699745de637cd70ddaaf2d335e6`; `ci-timings-summary.md` is its original summary.
- `raw-evidence.tar.gz`: frozen ledger/reports and blob identities, source/issue/PR metadata, all coordinator job lists, representative full logs, worker job lists and line-numbered extracts, original timestamps, reviewed metrics and retrieval URLs. The archive has its own internal `SHA256SUMS`.
- `SHA256SUMS`: outer files; `validation.md`: exact code-test/replay/publication checks.

From a Buster checkout at the source pin, the existing reader can reproduce the successful hardware-cohort tables without any network or hardware work:

```sh
cc -std=c17 -O2 -Wall -Wextra -Werror -fno-strict-aliasing tools/ci/timings.c -o /tmp/nightly-audit-timings
/tmp/nightly-audit-timings < /path/to/successful-backlog-input.tsv
/tmp/nightly-audit-timings < /path/to/successful-full-input.tsv
```

To replay the current accounting artifact, extract the ZIP into a disposable directory and run the existing `CI_TIMINGS_REPLAY` mode (or feed its `facts.tsv` to `timings --accounting`). The collector/reader/JQ source blobs at `09c3b79...` exactly match those at this audit's `8e4d328...` pin. No extracted logs are executed. Verify the outer hashes, then the archive's internal hashes, before recomputing.

The original November 6 package is unchanged. New report prose and derived tables are original project work; GitHub records and logs retain their source provenance. No compiler implementation, external test corpus, package secret or signed download URL is imported.

---
Agent session: 6b07ef78-8230-83ed-a344-72666686206a (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6 Astra Pro
Contributing tasks: /root/ledger_audit, /root/cycle_audit, /root/recovery_audit (same parent session and model)
