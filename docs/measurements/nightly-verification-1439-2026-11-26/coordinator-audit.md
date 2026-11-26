# Coordinator verification for buster #1439

Raw filenames in this detailed note are relative to `cycles/` after extracting `raw-evidence.tar.gz`.

## Scope and result

This continuation inspected the production coordinator after the fixes from November 6 through the completed November 26 window. The current source reference used for guide interpretation is `8e4d32879e17b7d9548cad54257a2f8461328366`. Collection completed 2026-11-26T08:53:39.082Z; times below are UTC (add one hour for Europe/Madrid throughout this November interval).

**The corrected coordinator completes its winter window without the pending-history crash, and never uses the continuation job in this sample. This does not establish a successful full snapshot or sustainable backlog capacity.** Those are distinct worker/ledger results.

The API creation-date cohort contains 184 coordinator runs: 183 scheduled runs and one manual main run. Of these, 117 succeeded, 61 were cancelled and six failed. All 61 cancelled runs contain zero jobs. They are pending workflow replacements, not evidence of cancelled active windows. Every observed run has attempt 1.

All 615 returned job records were retained. For each run, the number of returned jobs equals the API's `total_count`; no job-list page is missing. The 226 scheduled runs returned across three pages include other workflows; 183 match the observed coordinator workflow ID `405697113`. The manual main query returned one run and it also matches that workflow.

The first November 6 coordinator, [42112798371](https://github.com/buster14a/buster/actions/runs/42112798371), was created on November 5 and therefore falls outside this creation-date cohort. Its run and five-job metadata are retained separately as carry-in evidence. It is the first of the two original pending-history failures documented by the previous audit. It is not silently counted as a post-fix success.

## Window and continuation behavior

Within the creation-date cohort, 42 `Measure inside the window` jobs ran: 41 succeeded and the November 6 second coordinator window failed. The November 6 trailing recheck succeeded after the failed run, but is not evidence that its snapshot passed.

For the **20 corrected cycles, November 7–26**, all **40** non-skipped window invocations succeeded: one long coordinating window and one short trailing recheck each day. The 20 long jobs are listed below. The longest lasted **20,186 seconds (5 h 36 min 26 s)**, below six hours. Every continuation job in the entire cohort was skipped. All long window start/end job timestamps are inside 01:00–07:00 UTC; these are coordinator job boundaries, not worker lock-hook boundaries.

| Cycle | Main window run / job | Start UTC | End UTC | Seconds | Result |
| --- | --- | --- | --- | ---: | --- |
| 2026-11-07 | [42291560228](https://github.com/buster14a/buster/actions/runs/42291560228/job/128247124802) | 01:00:16 | 06:36:40 | 20184 | success |
| 2026-11-08 | [42405796926](https://github.com/buster14a/buster/actions/runs/42405796926/job/128583629239) | 01:00:13 | 06:35:51 | 20138 | success |
| 2026-11-09 | [42515476975](https://github.com/buster14a/buster/actions/runs/42515476975/job/128922421018) | 01:00:12 | 06:35:43 | 20131 | success |
| 2026-11-10 | [42722948570](https://github.com/buster14a/buster/actions/runs/42722948570/job/129553850852) | 01:00:14 | 06:35:06 | 20092 | success |
| 2026-11-11 | [42903248110](https://github.com/buster14a/buster/actions/runs/42903248110/job/130245048374) | 01:00:14 | 06:35:22 | 20108 | success |
| 2026-11-12 | [43106647350](https://github.com/buster14a/buster/actions/runs/43106647350/job/130896159992) | 01:00:25 | 06:36:15 | 20150 | success |
| 2026-11-13 | [43313968590](https://github.com/buster14a/buster/actions/runs/43313968590/job/131610682616) | 01:00:18 | 06:36:39 | 20181 | success |
| 2026-11-14 | [43510227217](https://github.com/buster14a/buster/actions/runs/43510227217/job/132270980040) | 01:00:18 | 06:35:13 | 20095 | success |
| 2026-11-15 | [43634412925](https://github.com/buster14a/buster/actions/runs/43634412925/job/132649938824) | 01:00:17 | 06:36:36 | 20179 | success |
| 2026-11-16 | [43757413939](https://github.com/buster14a/buster/actions/runs/43757413939/job/133026356926) | 01:00:17 | 06:36:20 | 20163 | success |
| 2026-11-17 | [43981619657](https://github.com/buster14a/buster/actions/runs/43981619657/job/133735105021) | 01:00:13 | 06:35:29 | 20116 | success |
| 2026-11-18 | [44193911547](https://github.com/buster14a/buster/actions/runs/44193911547/job/134493679633) | 01:00:13 | 06:36:31 | 20178 | success |
| 2026-11-19 | [44412660555](https://github.com/buster14a/buster/actions/runs/44412660555/job/135256471055) | 01:00:18 | 06:36:18 | 20160 | success |
| 2026-11-20 | [44630455254](https://github.com/buster14a/buster/actions/runs/44630455254/job/136003145717) | 01:00:17 | 06:36:04 | 20147 | success |
| 2026-11-21 | [44827141954](https://github.com/buster14a/buster/actions/runs/44827141954/job/136670613287) | 01:00:21 | 06:36:47 | 20186 | success |
| 2026-11-22 | [44948556966](https://github.com/buster14a/buster/actions/runs/44948556966/job/137045451670) | 01:00:16 | 06:35:40 | 20124 | success |
| 2026-11-23 | [45069531920](https://github.com/buster14a/buster/actions/runs/45069531920/job/137423514226) | 01:00:15 | 06:36:35 | 20180 | success |
| 2026-11-24 | [45247627546](https://github.com/buster14a/buster/actions/runs/45247627546/job/138135399427) | 01:00:18 | 06:35:18 | 20100 | success |
| 2026-11-25 | [45513326481](https://github.com/buster14a/buster/actions/runs/45513326481/job/138897379914) | 01:00:17 | 06:36:01 | 20144 | success |
| 2026-11-26 | [45722352694](https://github.com/buster14a/buster/actions/runs/45722352694/job/139618329875) | 01:00:12 | 06:36:15 | 20163 | success |

The compact `coordinator-runs.tsv` also lists every trailing recheck and every daytime prepare/report invocation, with exact source SHAs. Skipped jobs occasionally have GitHub completion timestamps one second earlier than their start timestamps; they are excluded from duration arithmetic.

### First corrected cycle, November 7

[Prepare job 128146791229](https://github.com/buster14a/buster/actions/runs/42291560228/job/128146791229) waited until the opening of the pin interval, then pinned `f4272a467c00a3ed01571fa814366f7e30653625` at **2026-11-06 21:02:36 UTC / 22:02:36 Madrid**. It dispatched snapshot preparation request `20261107.42291560228.1.defer`.

[Window job 128247124802](https://github.com/buster14a/buster/actions/runs/42291560228/job/128247124802) admitted that snapshot first at **01:02:18 UTC**, request `20261107.42291560228.10001.admit`, resolving to worker run [42321791875](https://github.com/buster14a/buster/actions/runs/42321791875). Its entire log contains **one snapshot and 22 backlog admission requests**. The last backlog request was at 06:28:23 UTC; planning stopped at 06:36:35 with “no more hardware work fits before 08:00.” The job completed successfully at 06:36:40. No branch-token rejection warning is present in these two retained logs.

Admission requests are not distinct states, hardware executions, or completed measurements. The ledger and individual worker records determine those outcomes.

### Latest completed cycle, November 26

[Prepare job 139584912877](https://github.com/buster14a/buster/actions/runs/45722352694/job/139584912877) pinned `86427a9f58dd361b17823ce5d29efb20f5d2d712` at **2026-11-25 23:40:05 UTC / November 26 00:40:05 Madrid**. This is after the 22:00 Madrid minimum. The snapshot preparation request is `20261126.45722352694.1.defer`.

[Window job 139618329875](https://github.com/buster14a/buster/actions/runs/45722352694/job/139618329875) admitted that snapshot first at **01:01:43 UTC**, request `20261126.45722352694.10001.admit`, resolving to worker run [45732894905](https://github.com/buster14a/buster/actions/runs/45732894905). The coordinator issued **one snapshot and 39 backlog admission requests**, then stopped at 06:36:11 because a worker remained in flight and no further work fit before 08:00 Madrid. The coordinator job completed at 06:36:15.

The retained preparation and window logs repeatedly warn that capacity is insufficient: the preparation began with 527 pending states, approximately 65 arriving per day and a 252–253 hour oldest pending state. At the end of the main window the log reports 509 pending, 64.6 arriving per day versus 22.1 completed per cycle, and oldest pending age 253 hours. These are the coordinator's live reported values at those timestamps; the frozen ledger report is authoritative for final cycle reconciliation.

A coordinator success is compatible with a blocked-native snapshot. The parent audit must use the worker's record rather than treating run 45722352694 or its trailing recheck as snapshot success.

## Preparation failures and observed subsequent recovery

The five failures after the original November 6 crash all occurred in the daytime `Prepare the cycle` job while listing GitHub runs. Four were HTTP 502 server errors and one was an installation API rate limit (HTTP 403). Their window and continuation jobs were skipped. The next scheduled coordinator in each case succeeded:

| Failure date | Failed run / job | Observed error | Next scheduled success |
| --- | --- | --- | --- |
| 2026-11-10 | [42803698466](https://github.com/buster14a/buster/actions/runs/42803698466/job/129788620323) | HTTP 502 GitHub server error | [42819685118](https://github.com/buster14a/buster/actions/runs/42819685118) at 2026-11-10T12:54:05Z |
| 2026-11-11 | [43047975642](https://github.com/buster14a/buster/actions/runs/43047975642/job/130618315105) | HTTP 403 installation API rate limit | [43106647350](https://github.com/buster14a/buster/actions/runs/43106647350) at 2026-11-11T21:50:57Z |
| 2026-11-16 | [43853355055](https://github.com/buster14a/buster/actions/runs/43853355055/job/133253066609) | HTTP 502 GitHub server error | [43872228487](https://github.com/buster14a/buster/actions/runs/43872228487) at 2026-11-16T13:03:55Z |
| 2026-11-17 | [44131439390](https://github.com/buster14a/buster/actions/runs/44131439390/job/134211168386) | HTTP 502 GitHub server error | [44193911547](https://github.com/buster14a/buster/actions/runs/44193911547) at 2026-11-17T22:50:29Z |
| 2026-11-23 | [45202637684](https://github.com/buster14a/buster/actions/runs/45202637684/job/137791797465) | HTTP 502 GitHub server error | [45247627546](https://github.com/buster14a/buster/actions/runs/45247627546) at 2026-11-23T19:18:53Z |

This demonstrates subsequent-schedule recovery for these observed API failures. It does not establish recovery from a wholly dropped schedule, nor successful recovery of a failed comprehensive snapshot.

## Report and manual phases

The workflow names its daytime publication job `Prepare the cycle`; a separate job named “report” is not expected. For example, [run 45588185577, prepare job 139116722853](https://github.com/buster14a/buster/actions/runs/45588185577/job/139116722853), ran on November 25 at 09:47 UTC with `MODE: true`, reported that the window had closed, and published `nightly/reports/2026-11-25.md`. Both window jobs were skipped.

The only manual main coordinator run in this cohort, [43492575157](https://github.com/buster14a/buster/actions/runs/43492575157), was a **dry run**: its [prepare log](https://github.com/buster14a/buster/actions/runs/43492575157/job/132118925357) records `MODE: false`, the command's `dry-run` selection, no pin before 22:00, and publication of the next cycle's report. Its window jobs were skipped. It is not counted as a manual hardware recovery.

## Retained evidence and limits

- `provenance.json` records every collection endpoint, the run filters, source guide ref, sample log/job links and limitations.
- `coordinator-runs.tsv` is the full creation-date run inventory with prepare/window/continuation outcomes and job durations.
- `coordinator-jobs-index.json` preserves all job identities and timestamps; `jobs/RUN_ID.json` contains every raw job object and step list returned.
- The three scheduled-run JSON pages and the one manual-main page preserve run refs, events, attempts and conclusions, including the other scheduled workflows needed to reconcile pagination.
- The two `baseline-*.json` files preserve the separate November 6 carry-in run.
- Decoded preparation/window logs are retained for the first corrected cycle and latest completed cycle, all five later failed preparations, one daytime report and the sole manual main dry run.

This subtask made only read-only GitHub calls. It did not access the 9700X, dispatch or rerun workflows, or change any CI policy. It does not infer worker ownership intervals from coordinator timestamps, mark failed or incomplete snapshots as passed, or infer exact-state correctness coverage from the coordinator's success.

---
Agent contribution: /root/cycle_audit in parent session 6b07ef78-8230-83ed-a344-72666686206a (OpenAI; no separate share URL is exposed).
Model: OpenAI / GPT-6 Astra Pro
