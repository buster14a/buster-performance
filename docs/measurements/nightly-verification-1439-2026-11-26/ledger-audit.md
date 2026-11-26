# Nightly ledger verification for buster #1439

Raw filenames in this detailed note are relative to `ledger/` after extracting `raw-evidence.tar.gz`.

Read-only observation taken 2026-11-26. The retained production ledger is
`buster14a/buster-performance@bf8108aa9d8257f6dbe6049013f1832bd913c1e8`,
committed 2026-11-26 06:43:34 UTC by report run 45758471286.
The accompanying source interpretation used
`buster14a/buster@8e4d32879e17b7d9548cad54257a2f8461328366`.

## Result

The subsequent-cycle requirement now has observable results. It does **not**
have a passing all-cycles result or sustainable per-state capacity.

For the twenty post-fix cycles **November 7–26**, the retained ledger contains
eight full native/measurement snapshot admissions marked complete, six
blocked-native snapshots, two interrupted snapshots and four failed snapshots.
One of those eight, November 13, had blocked hosted preparation and is not an
all-diagnostics-green cycle (see the preparation table below).
Every cycle has exactly one snapshot
admission request. The eight complete cycles are November 7, 13, 14, 19, 20,
21, 22 and 23. November 24 failed; November 25 and 26 were blocked-native.

These are ledger outcomes, not an independent rereading of all native inventory
results or hook timestamps. The cycle/job audit must supply that independent
log verification before reporting those stronger claims. A purpose=snapshot,
coverage=full row whose outcome is failed is not a complete cycle.

## Hosted preparation versus native/measurement completion

The eight complete admitted snapshot rows prove the ledger accepted the
full native/measurement run. They do **not** establish that all hosted
sanitizer/fuzz diagnostics in that cycle passed. Snapshot preparation and
hardware admission are separate dispatches of the same pinned state.

All twenty preparations below have `plain=ok`, `hardware=skip` and
`coverage=full`. Fifteen have outcome deferred and **five have outcome
blocked-hosted** (November 8, 9, 10, 11 and 13).

**November 13 is a mixed result:** preparation **43314889186** is
blocked-hosted despite plain=ok, while native/measurement admission
**43341714661** is complete. It must not be reported as an all-diagnostics-green
cycle. The other seven complete native/measurement cycles have preparation
outcome deferred; their complete hosted inventories still need job-level
verification before claiming all diagnostics passed. The source's
`nightly_record_outcome` returns deferred for non-admitted runs after known
failure/cancellation checks; that enum is not by itself proof that every
declared hosted job executed successfully.

| Cycle | Hosted preparation run | Preparation outcome | Native/measurement run | Admission outcome |
| --- | --- | --- | --- | --- |
| 2026-11-07 | [42293408023](https://github.com/buster14a/buster/actions/runs/42293408023) | deferred | [42321791875](https://github.com/buster14a/buster/actions/runs/42321791875) | complete |
| 2026-11-08 | [42414073687](https://github.com/buster14a/buster/actions/runs/42414073687) | blocked-hosted | [42432525416](https://github.com/buster14a/buster/actions/runs/42432525416) | blocked-native |
| 2026-11-09 | [42523364069](https://github.com/buster14a/buster/actions/runs/42523364069) | blocked-hosted | [42543322471](https://github.com/buster14a/buster/actions/runs/42543322471) | blocked-native |
| 2026-11-10 | [42723436389](https://github.com/buster14a/buster/actions/runs/42723436389) | blocked-hosted | [42732660559](https://github.com/buster14a/buster/actions/runs/42732660559) | blocked-native |
| 2026-11-11 | [42904143322](https://github.com/buster14a/buster/actions/runs/42904143322) | blocked-hosted | [42935846494](https://github.com/buster14a/buster/actions/runs/42935846494) | blocked-native |
| 2026-11-12 | [43108435365](https://github.com/buster14a/buster/actions/runs/43108435365) | deferred | [43131788329](https://github.com/buster14a/buster/actions/runs/43131788329) | interrupted |
| 2026-11-13 | [43314889186](https://github.com/buster14a/buster/actions/runs/43314889186) | blocked-hosted | [43341714661](https://github.com/buster14a/buster/actions/runs/43341714661) | complete |
| 2026-11-14 | [43511039105](https://github.com/buster14a/buster/actions/runs/43511039105) | deferred | [43538151259](https://github.com/buster14a/buster/actions/runs/43538151259) | complete |
| 2026-11-15 | [43640611681](https://github.com/buster14a/buster/actions/runs/43640611681) | deferred | [43661227560](https://github.com/buster14a/buster/actions/runs/43661227560) | interrupted |
| 2026-11-16 | [43761423762](https://github.com/buster14a/buster/actions/runs/43761423762) | deferred | [43783883267](https://github.com/buster14a/buster/actions/runs/43783883267) | failed |
| 2026-11-17 | [43982345178](https://github.com/buster14a/buster/actions/runs/43982345178) | deferred | [43992356652](https://github.com/buster14a/buster/actions/runs/43992356652) | failed |
| 2026-11-18 | [44194828047](https://github.com/buster14a/buster/actions/runs/44194828047) | deferred | [44212612100](https://github.com/buster14a/buster/actions/runs/44212612100) | failed |
| 2026-11-19 | [44413660354](https://github.com/buster14a/buster/actions/runs/44413660354) | deferred | [44433733494](https://github.com/buster14a/buster/actions/runs/44433733494) | complete |
| 2026-11-20 | [44631499209](https://github.com/buster14a/buster/actions/runs/44631499209) | deferred | [44650577795](https://github.com/buster14a/buster/actions/runs/44650577795) | complete |
| 2026-11-21 | [44828148293](https://github.com/buster14a/buster/actions/runs/44828148293) | deferred | [44847654516](https://github.com/buster14a/buster/actions/runs/44847654516) | complete |
| 2026-11-22 | [44949278275](https://github.com/buster14a/buster/actions/runs/44949278275) | deferred | [44969521006](https://github.com/buster14a/buster/actions/runs/44969521006) | complete |
| 2026-11-23 | [45070398498](https://github.com/buster14a/buster/actions/runs/45070398498) | deferred | [45092455320](https://github.com/buster14a/buster/actions/runs/45092455320) | complete |
| 2026-11-24 | [45265215463](https://github.com/buster14a/buster/actions/runs/45265215463) | deferred | [45302644116](https://github.com/buster14a/buster/actions/runs/45302644116) | failed |
| 2026-11-25 | [45514049146](https://github.com/buster14a/buster/actions/runs/45514049146) | deferred | [45522673652](https://github.com/buster14a/buster/actions/runs/45522673652) | blocked-native |
| 2026-11-26 | [45723116286](https://github.com/buster14a/buster/actions/runs/45723116286) | deferred | [45732894905](https://github.com/buster14a/buster/actions/runs/45732894905) | blocked-native |

The exact unmodified ledger rows, including requests, commit SHAs, timestamps,
host and protocol fields, are in `snapshot-preparations.json`; the compact
table is `snapshot-preparations.tsv`. These rows were derived from the same
immutable ledger as the rest of this report, without any new dispatch.

## Current state

[November 26 report](https://github.com/buster14a/buster-performance/blob/bf8108aa9d8257f6dbe6049013f1832bd913c1e8/nightly/reports/2026-11-26.md),
generated at 07:43 Europe/Madrid:

| State classification | Count |
| --- | ---: |
| In-scope first-parent main states | 1,611 |
| Documentation-only, not-required | 78 |
| Complete | 309 |
| Blocked-native | 624 |
| Blocked-hosted | 80 |
| Failed | 11 |
| Ready | 509 |
| In flight / preparing / needs preparation | 0 |

Of the 1,533 states that require measurements, **1,224 lack a completed
targeted-or-full record**: 509 ready plus 715 blocked or failed. The advertised
“carried over” count excludes blocked and failed states; it must not be used as
the total native/measurement coverage deficit.

The reported oldest pending state is
`dc58207037ab92f1ba052151e107bd8c61deb2f8`, aged **252.8 hours** at the report.
The source selects the oldest state from the pending classifications
(in-flight, ready, preparing, needs-preparation); it excludes blocked/failed
states. Therefore 252.8 hours is not the maximum age over every outstanding
coverage obligation.

The separate first-parent history audit identifies the actual oldest
outstanding code state as
`81d5c137bfa94b8b689bf6d65f91b461de9ae8ad`, committed **November 4 at
00:04:18 UTC / 01:04:18 Madrid**, about **534.7 hours (22.3 days)** old at the
ledger publication. Its first push was interrupted; its preparation
[41914936297](https://github.com/buster14a/buster/actions/runs/41914936297)
failed hosted qualification. It has no complete targeted/full row. All six
earlier in-scope first-parent states have complete targeted/full rows. The
commit's API response confirms compiler-code changes, so it is not exempt as
documentation-only. `first-parent-scope.tsv` records all 1,611 in-scope commit
IDs, committer epochs and parents; `oldest-incomplete-commit.json` preserves
the commit and changed paths. The age uses the ledger publication time
06:43:34 UTC; the report itself prints only minute precision.

The report independently records 681 states since the first merge-queue
candidate, with zero lacking a passing candidate run of their exact commit.
That hosted coverage observation does not turn incomplete native measurements
into complete records.

## Capacity

All 22 retained daily reports from November 5 through November 26 contain
“The backlog cannot drain at this rate.”

The latest rolling comparison is **64.6 code states/day arriving** against
**22.1 completed admissions/cycle**, over seven days/cycles. The printed arrival
rate is quoted from the report. Its input state list is not in this retained
ledger tree, so it has not been independently regenerated from Git history
during this subtask.

The seven-cycle completion rate **was independently reconciled** against the
raw ledger for November 20–26:

- 284 admission requests in total.
- 155 complete records, all different run IDs and all different state SHAs.
- Four of the completions are full snapshots; 151 are targeted backlog states.
- 95 blocked-native, 33 failed, one deferred.
- Every one of the seven calendar dates has admissions.
- There are no admission reruns anywhere in this frozen ledger.

Consequently 155 / 7 = 22.142857 actual distinct-state completions per calendar
cycle here; the printed 22.1 is not inflated by duplicate attempts or omitted
dates in this particular window. Backlog-only completions are 151 / 7 =
21.571429/day. The arrival/completion ratio is approximately 2.9.

Across November 7–26, 933 admission requests yielded 261 complete records
covering 261 distinct states, 624 blocked-native, 36 failed, nine interrupted
and three deferred. There were admissions on all twenty calendar dates.
These rates describe the actual historical workload and failures; they are
not a maximum machine-throughput estimate or a causal benchmark of the
November 6 fixes.

The code's general printed-capacity formula counts complete rows rather than
deduplicating attempts, and its denominator is dates with admission rows.
Those limitations matter in a different cohort. They do not affect the
reconciled counts above.

## Pin and coverage integrity

All twenty November 7–26 snapshot pins are in the overnight interval beginning
at 22:00 Europe/Madrid on the previous day. Several scheduled preparations
began after midnight; the exact UTC pin, snapshot SHA and coordinator run
are retained in `cycle-summary.tsv` and `derived-cycle-summary.json`.

The latest pin is
`86427a9f58dd361b17823ce5d29efb20f5d2d712`, pinned
2026-11-25 23:40:05 UTC (November 26 00:40:05 Madrid) by coordinator
45722352694. Its snapshot admission is
[45732894905](https://github.com/buster14a/buster/actions/runs/45732894905),
coverage full, outcome blocked-native.

No retained daily report includes a “Branch refused” section. This is narrower
than proving every branch operation succeeded; rejection warnings require
reading coordinator logs.

The per-state coverage policy remains present in current source and the ledger.
`nightly_fold` requires a complete targeted/full row, and a full snapshot for
this exact cycle requires the cycle-matching snapshot admission. A previous
cycle's full run or a later targeted success cannot establish the full cycle.

## Queue coverage and before/after interpretation

The ledger deliberately harvests first-parent main-state records and excludes
pull-request runs. Its zero PR rows are not evidence that no PR workflows ran,
and it cannot supply current PR queue/lock quantiles.

The frozen ledger contains 685 merge-queue records for 681 different merged
states, created from November 13 15:38:43 UTC through November 25 23:08:48 UTC:

| Records | Count | Meaning |
| --- | ---: | --- |
| Deferred, hardware skip, coverage none | 681 | Hosted qualification passed; native measurements remain the nightly obligation |
| Invalid, hardware admit, no host | 4 | Cancelled jobs represented conservatively by the harvester; not verified hardware execution |

All four anomalous runs were checked against their complete two-page job
inventories (112, 124, 122 and 112 jobs, respectively). Their named Benchpress
jobs have conclusion **cancelled**, null runner IDs/names and no steps:

| Workflow run | Benchpress job | Later deferred/skip run for same state |
| --- | --- | --- |
| 44759618425 | 136372744568 | 44761109275 |
| 44759618830 | 136372719594 | 44761107861 |
| 44757468479 | 136372718425 | 44761105700 |
| 44757465996 | 136372713026 | 44761103472 |

There is no observed machine allocation or hardware execution in those jobs.
Their API start/end timestamps are synthetic (two even have end before start),
so they must not contribute negative or zero lock/queue samples. The ledger's
admit field alone is insufficient evidence of a run on the machine. All four
exact states subsequently obtained their successful deferred queue record.

For the narrower November 20 00:00 UTC to November 26 06:43:34 UTC observation,
there are 445 queue records: 441 deferred/skip states and those same four
invalid records. `queue-summary.json` preserves counts and exact rows; the
eight `queue-invalid-*-jobs*.json` files preserve the API inventories.

The ledger does not retain hardware-reason text or phase timestamps. Use
source/current job evidence for the precise PR/queue skip reason, and report
hardware queue/lock distributions for a skipped population as **not
applicable**, not zero seconds. The November 5 PR median queue 767 s and lock
wait 45 s describe the former admitted-PR population; changing to skipped
hardware changes the population, rather than proving an equivalent job
became instantaneous.

## Data and reproduction

`nightly/main-coverage.tsv` contains 3,228 run-attempt rows and 23 pinned-cycle
rows, from November 4–26. Run IDs identify 3,227 unique runs; the sole extra
attempt is not an admission. There are no duplicated (run ID, attempt) keys.

The 23 fetched text files (one ledger and 22 reports) are byte-identical to
their Git blobs. Every `git hash-object` value was checked against the immutable
tree, and sizes match the fetch metadata. `source-manifest.json` records each
file's exact source URL, blob SHA and length; `tree.json` is the complete,
nontruncated tree. `branch-snapshot.json` preserves the branch resolution.

The raw run schema follows `nightly_row_write`:

`kind, run, attempt, commit, event, purpose, request, created_epoch,
completed_epoch, plain, hardware, coverage, outcome, source, host, protocol`

Cycle records contain `cycle, date, snapshot, coordinator, pinned_epoch`.

For cycle reconciliation, select the latest attempt per run ID, then a request
whose prefix is the cycle date in YYYYMMDD and whose suffix is `.admit`.
This matches the source's per-cycle counter semantics. Select purpose
`snapshot` separately for full-snapshot outcomes; never infer it from the
daily report's overall “complete” state count. Count unique commit SHAs
separately when reporting distinct-state completions.

`derived-cycle-summary.json` includes each raw snapshot row, daily state
counts, report capacity fields and recomputed admission/completion counts.
`cycle-summary.tsv` is the compact comparison table.

## Provenance

Parent session: 6b07ef78-8230-83ed-a344-72666686206a (OpenAI session ID; no share
URL is exposed). Subtask: /root/ledger_audit. Model: OpenAI / GPT-6 Astra Pro.
All operations in this subtask were read-only GitHub reads or local analysis.
No hardware access, workflow dispatch, repository mutation or issue comment
was performed.
