# #1439 source and recovery audit — 2026-11-26

Raw filenames in this detailed note are relative to `recovery/` after extracting `raw-evidence.tar.gz`. Its source findings precede the reporting fix described in `validation.md`.

Audited repository: `buster14a/buster`, ID 1421805693.
Source pin: `8e4d32879e17b7d9548cad54257a2f8461328366`.
Work was read-only: local source inspection and GitHub issue/PR retrieval. No workflow dispatch, hardware access, or compiler test/benchmark run.

## Findings

### Current coverage contract

The per-first-parent-state backlog obligation remains. Each eligible code state needs change-relevant targeted measurements; native correctness precedes measurement. Documentation-only states are explicitly not required. A daily pinned snapshot additionally needs full coverage (all benchmarks, isolated campaigns and oracle-cache audit). A targeted success cannot substitute for a daily full snapshot.

Source: [docs/ci.md lines 1164–1183](https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/docs/ci.md#L1164-L1183). `nightly_fold` sets `full_this_cycle` only for a complete full-coverage snapshot record with an admitted request for this cycle; previous dates' full runs do not satisfy it ([nightly.c lines 2353–2365](https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/tools/ci/nightly.c#L2353-L2365)).

The old acceptance request about main-push checks must be interpreted historically. The owner's November 10 decision explicitly superseded it: no checks on main pushes; the exact candidate gets the full hosted merge-queue contract, and main's own native/measurement coverage remains the nightly snapshot plus per-state backlog. See [decision](https://github.com/buster14a/buster/issues/2029#issuecomment-6765050488) and current [command guide](https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/docs/commands/ci.md#L7-L22). The later verification must not call removal of main-push duplicate checks a regression against obsolete policy.

Native correctness also changed through merged [#3525](https://github.com/buster14a/buster/pull/3525), merged November 24 at 10:18:59 UTC, commit `70f06ccb90d7e7e6e10add49504e22b699c80995`. A backlog worker can choose the four-command smoke of its measured `znver5` binary only when its own exact SHA has a successful merge-group source, successful Integration qualification and exactly one successful explicit vector verdict for all four configurations. Missing/incomplete evidence or plain-only qualification keeps the full inventory. The snapshot and manual full run always keep the full native inventory. See [docs/ci.md lines 1213–1236](https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/docs/ci.md#L1213-L1236). This is a documented evidence-based replacement, so report the native mode/source explicitly instead of asserting that every state still ran the entire old native suite on the 9700X.

### Current physical deadline and scheduler recovery

The ordinary hardware window remains 02:00–08:00 Europe/Madrid, with DST resolved by the tz database and a 22:00 earliest pin. Defaults reserve 1,500 seconds for backlog dispatch-to-completion and 1,920 for snapshot dispatch-to-completion. The jobs themselves have 20/25 minute limits and the post-lock guard reserves another five minutes.

Sources:
- [nightly.c constants](https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/tools/ci/nightly.c#L84-L97), [default bounds](https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/tools/ci/nightly.c#L5000-L5016)
- [worker guard and timeout](https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/.github/workflows/9700x.yml#L479-L560)
- [time/continuation policy](https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/docs/ci.md#L1380-L1418)

Late scheduling is mitigated by nine cron opportunities at 16:07, 18:07, 20:07, 22:07, 00:07, 02:07, 04:07, 05:37 and 08:17 Madrid. They share the `nightly-backfill-main` concurrency group, never cancelling the active main coordinator; only the latest pending run is retained. A prepare job may wait up to 5h55m for the window. A later coordinator recovers run records, the ledger and pin and can continue ordinary remaining work; a run starting after the cutoff harvests/reports but admits no ordinary hardware work. The fall-back-night continuation is a separate job after 345 minutes, with a 355-minute per-job timeout. These are opportunities and bounds, not a guaranteed successful complete snapshot by 08:00.

Sources: [workflow triggers/concurrency](https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/.github/workflows/nightly-backfill.yml#L10-L63), [prepare/window jobs](https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/.github/workflows/nightly-backfill.yml#L111-L166), [glue handoff](https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/tools/ci/nightly.sh#L798-L854).

Current fail-safe mechanisms remain valuable:
- A partial/failed first run listing stops the job; later listing failures make no plan and retry.
- Missing pending handoff refuses to plan, preserving duplicate-dispatch protection.
- An admitted run older than the two-hour lease is cancelled by a subsequent plan.
- A failed publication warns and retains the artifact; it does not prevent the window job's handoff.
- Historical workers' own literal windows are intersected with the current window.
- Failed states remain blocked/failed rather than silently covered.

### Demonstrated cycle-observation and recovery gap

In the inspected repository source, there is no explicit durable success/failure verdict for every expected calendar cycle and no independent observer that establishes a missing full cycle by the deadline. External monitoring or notifications outside this repository were not inspected and are not asserted absent:

1. `nightly_plan` works on the current civil-time cycle. After noon, the cycle refers to the coming night. It does not enumerate missing past calendar dates. If all opportunities for a date were dropped or the coordinator never pinned, no missing-date row is synthesized or alerted.
2. The daily snapshot is attempted once. Any non-deferred admitted snapshot record sets `snapshot_attempted`, whether complete, failed, blocked or interrupted. A live admitted snapshot sets the same flag. The next full decision is `!snapshot->full_this_cycle && !cycle.snapshot_attempted`. A failed full snapshot is therefore not automatically retried as a full snapshot that night. A later targeted success can complete the state's targeted obligation without repairing that date's failed full requirement.
3. The report's comprehensive sentence says that the run “measures” a SHA and its aggregate cycle counts mix snapshot/backlog. It does not publish a distinct daily full-snapshot pass/fail/missing status or alert. The only planner alerts are worker-window unknown, branch refused, merge-queue coverage gaps, and backlog capacity/age. A green coordinator is not proof of a green complete snapshot.
4. The after-window 08:17 trigger uses that same coordinator and same concurrency group. It is not an independent deadline observer and can itself be delayed, dropped, or replaced while pending.
5. The 08:37 CI timing workflow reads the latest dated nightly report and preserves only its carried-over/capacity lines. It does not cross-check expected cycle dates or full snapshot completion.
6. The automatic setup-rerun workflow explicitly excludes nightly dispatches: it only accepts `push` and `pull_request` events. It is not snapshot recovery.
7. A normal manually dispatched `purpose: full` run lacks the admitted snapshot purpose/request used by `full_this_cycle`; it does not retroactively satisfy a missed calendar cycle under the existing predicate. A coordinator override changes admission hours but does not remove `snapshot_attempted`.

Sources:
- [cycle calculation](https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/tools/ci/nightly.c#L487-L514)
- [attempt folding](https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/tools/ci/nightly.c#L2398-L2405) and [live request folding](https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/tools/ci/nightly.c#L2451-L2455)
- [daily full decision](https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/tools/ci/nightly.c#L2887-L2936)
- [report and alerts](https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/tools/ci/nightly.c#L2595-L2685)
- [timing collector](https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/tools/ci/timings.sh#L349-L362)
- [rerun event guard](https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/.github/workflows/rerun.yml#L3-L35)

This is a source-proven observability/recovery gap, not evidence that any particular missing date or failed production run occurred. Pair it with the retained production evidence in the parent audit before filing.

### Recommended bounded follow-up

Suggested title: **CI: report missed or incomplete nightly full cycles and define bounded recovery**.

Extend the existing C planner/ledger/report; do not introduce another scheduler, ledger or priority service. Add an explicit per-expected-cycle assessment that distinguishes complete at pin, complete substitute (with why), failed, interrupted, not attempted, and evidence unavailable. Preserve pin, inventory, exact record/run/attempt/native mode, and reason. A late observer must inspect the last closed expected date as well as today, and a stale/missing publication or API error must remain unknown. Its visibility should not depend solely on the coordinator that it audits. Define the actual completion deadline and reporting grace separately. Decide documented, bounded in-window retries or operator recovery without erasing the original failed/missed date, broadening hours, weakening full inventory, or counting targeted work as full.

The follow-up should keep existing source-state failures explicit and use deterministic fixtures for dropped whole date, early failed snapshot, interrupted snapshot, delayed completed record, substitute revision, later targeted success, duplicate/retied attempts and DST days. Hardware is not required to implement the assessment; observing a successful real full cycle remains separate evidence.

Searches for nightly recovery/monitoring/watchdog/missed cycle, nightly-title issues, snapshot-title issues, and cycle+deadline returned no distinct existing implementation issue covering this gap. #1439 and #2029 already require assessing it. Existing related owners are:
- #2034: phase accounting (implemented in #2904); configured account capacity remains unknown.
- #2035: immutable measurement bundles, open.
- #2036: bounded resumable campaigns, open; not a missing-cycle observer.
- #2037: calibrated paired performance verdicts, closed; not daily full-cycle completion.
- #3426 / #3428: repeated unproductive hosted preparations; current source bounds these at three.
- #2870: nightly code-certificate benchmark failure; separate compiler/benchmark correctness.

### Capacity-report interpretation caveat

The report's `Capacity` line is not itself a unique-state/calendar-day throughput estimate. At `nightly.c` 2551–2591:
- arrivals are code states committed within the trailing seven days;
- completion count scans all ledger rows with an admitted request and outcome complete, including snapshot completions and successful rerun attempts;
- it does not apply the latest-attempt filter used in the current-cycle count;
- its denominator counts only dates having at least one admitted request, so dates with no admission are omitted.

Therefore retain that printed figure as the report's statistic, but independently calculate distinct newly completed backlog states and include every expected calendar cycle in the before/after capacity audit. A hypothetical repeated successful run/attempt can inflate the printed numerator. No such actual duplicate is asserted here without checking the ledger.

Source: [capacity calculation](https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/tools/ci/nightly.c#L2551-L2593).

### Historical failures must remain failures

The [November 23 coordination update](https://github.com/buster14a/buster/issues/2029#issuecomment-7112854365) recorded 622 blocked-native states, mostly pre-#2579 arena-page-policy failures. It explicitly left replaying historical revisions with fixed tests to the maintainer. This audit cannot mark them complete from current-source fixes or silently patch immutable worker revisions. Current source likewise keeps blocked states skipped and separately visible.

## Retained evidence and provenance

- `source/revision.txt`: source pin.
- `source/git-blobs.tsv`: exact blob identities for the inspected source/workflow/docs.
- `issues/*.json`: issue snapshots and comment bodies retrieved through the GitHub connector.
- `prs/3525.json`: merged smoke-qualification metadata.
- `searches/*.json`: duplicate searches as returned; issue search snapshots do not prove absence outside the stated queries.
- `retrieved-at.txt`: UTC collection time.

Agent: /root/recovery_audit, contributing to parent session 6b07ef78-8230-83ed-a344-72666686206a. Model: OpenAI / GPT-6 Astra Pro. This is a temporary analysis report for the parent to preserve in buster-performance; no GitHub mutation was performed.

## Additional coordination verification

### Phase accounting is already merged

[PR #2904](https://github.com/buster14a/buster/pull/2904), source head `5fc216c16ec86707a5a5e93325dc902a7b56734d`, merged on 2026-11-20 at 08:19:47 UTC as `15a913d3913d1a04dd66ff3b355affa6a5100813`. Its exact current implementation is already in the pinned source inspected above. The [#2034 final handoff](https://github.com/buster14a/buster/issues/2034#issuecomment-6943975083) leaves the administrator-confirmed account concurrency observation outstanding, not the accounting implementation. The nightly verification should use/coordinate those metrics instead of creating competing phase tooling.

### Assembly-output production failure belongs with the active #1362 owner

Parent's retained November 25/26 evidence identifies `test-assembly-output --cross-check` failing the GNU-as offset-marker comparison, while all 4,474 forms/8,948 records agree. The exact current assertion is [assembly_output_test.c:1219](https://github.com/buster14a/buster/blob/8e4d32879e17b7d9548cad54257a2f8461328366/src/buster/compiler/assembly_output_test.c#L1213-L1219), checked at both tiers. The fixture and DWARF output arrived with [#3548](https://github.com/buster14a/buster/pull/3548), merged 2026-11-24 at 10:48:27 UTC, commit `a57dc29fc7901cd7d208484f297ad24073ba16f4`. This establishes the source lineage, not a root-cause diagnosis of the relocation mismatch.

The fresh [#1362 owner claim](https://github.com/buster14a/buster/issues/1362#issuecomment-7186883952) is on branch `codex/1362-assembly-completion`, session `6b07efa4-bfac-83eb-98c2-8886f9788059`. It explicitly includes remaining symbol/section, relocation, inline-text, unwind and assembler round-trip work. Do not start an overlapping fix or file a competing implementation issue; send the concrete production run/error proof to that owner through the existing issue. Searches for the exact test, GNU-as relocation, offset-marker and relocation-0 phrases found no separately filed exact failure or open assembly PR. Search results and the current claim are retained here.

### Capacity sample clarification from the independent ledger audit

The generic denominator/retry caveat above is a code observation. The independent ledger audit found no duplicate run/attempt inflation in the actual inspected November 7–26 and November 20–26 cohorts; each inspected date had admissions. Its figures should therefore be reported directly with their snapshot/backlog distinction, rather than insinuating that the observed rate is inflated. This note is a coordination result; the parent should cite the ledger audit's own retained records for exact counts.
