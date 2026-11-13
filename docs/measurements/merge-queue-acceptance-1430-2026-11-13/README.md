# The merge queue's acceptance on real merges (#1430)

The record behind closing [buster14a/buster#1430](https://github.com/buster14a/buster/issues/1430). Since
[#2621](https://github.com/buster14a/buster/pull/2621) merged, main's ruleset has required the queue's
`Integration qualification`, and pushes to main run no checks. This record covers main's first queue merges: what
landed, what the pushes started, what the nightly credited, and what the queue cost.

## Source

- **Window.** Main's queue from its first candidate (2026-11-13 11:49 UTC) to 19:50 UTC.
  - The first merge was [#2631](https://github.com/buster14a/buster/pull/2631)'s candidate `a6ba875e`, at 16:14.
  - #2621, the switch that removes the push triggers, merged at 18:16 as `47b70363`.
- **Collection.** Everything was read through the Actions, compare and timeline APIs after the fact, with explicit
  `page=` requests. The proxied session rejects `--paginate`'s links.
  - One job page that returned HTTP 502 was fetched again.
  - Every candidate's job count matches its run's `total_count`.
- **Queue settings** (ruleset 25225502): `ALLGREEN`, `max_entries_to_build` 4, `max_entries_to_merge` 1, merge
  commits, 180-minute check timeout.
- **Excluded.** Only main's queue (`gh-readonly-queue/main/...`) is counted. The drill's 16 candidates on
  `merge-queue-drill` are left out; #2657 makes `timings.sh` do the same.

## Files

- `candidates.tsv`: every completed candidate run of main's queue, 52 of them. One line each:
  - `run`, `outcome`, `conclusion`: the run, then `outcome` from `timings.sh`'s rule. It is `merged` when the
    candidate's commit is on main, and otherwise the run's own conclusion: `passed` (invalidated), `failed` or
    `cancelled`.
  - `wall_s`: wall seconds, from the run's start to its last update.
  - `runner_s`: runner seconds, the sum of the jobs' own times.
  - `longest_wait_s`, `waits_s`, `jobs`: the hosted jobs' waits for a runner, from each job's creation to its start
    (#2031). These are the longest, the sum, and how many jobs.
  - `candidate`: the candidate's branch.
  - `created`: when the run was created.
- `queue-report.md`: `timings --queue` at main `65ab5d8f` (with #2651's runner waits) over those lines.
- `first-parents.tsv`: each of main's first parents from `a6ba875e` on, one line each:
  - `commit`, `tree`, `pr`: the merge commit, its tree and its pull request.
  - `candidate_run`, `candidate_conclusion`: the queue run that built that exact commit, and how it ended.
  - `push_runs`: how many `push` runs the commit started.
  - `other_runs`: any other runs that carry the commit.
- `ledger-queue-rows.tsv`: the nightly ledger's `merge_group` rows (`tools/ci/nightly.c`'s `run` lines), from
  artifact `nightly-ledger-prepare-1` of the plan-only nightly run
  [43492575157](https://github.com/buster14a/buster/actions/runs/43492575157), dispatched at 19:28 UTC.

## Acceptance

1. **Main lands on each candidate's exact commit and tree.**
   - Main has 11 first parents since `a6ba875e`. Each is the merge commit its candidate run built and passed, with
     the same SHA and therefore the same tree (`first-parents.tsv`).
   - Main was fast-forwarded to the tested commits. Nothing was re-merged on the way.
2. **The pushes start no checks.**
   - From `47b70363` (#2621) on, main's ten pushes started 0 `push` runs.
   - `a6ba875e`'s one push run was the last before the switch.
   - The only other runs on these commits are `workflow_run` reruns of failed hosted setup steps (`Re-run hosted
     setup failures`), which react to completed runs, and the plan-only nightly run dispatched for this check.
3. **The nightly credits the queue's records to those states.**
   - The plan-only nightly run harvested all 11 merged candidates. Each is recorded against its own first-parent
     commit, with event `merge_group`, kind `queue`, hosted `ok` and outcome `deferred`: its 9700X work is left to
     the window (`ledger-queue-rows.tsv`).
   - Only merged candidates are rows. Invalidated, failed and cancelled ones are absent.
   - It planned nothing, because it ran before the 22:00 Europe/Madrid pin.
4. **Stale candidates are cancelled.** Each time an entry left the queue, GitHub rebuilt the candidates behind it,
   and the superseded runs ended `cancelled` within seconds (#2614). The 29 cancelled lines took a median of 53
   runner-minutes each: what each run had spent before it was superseded, or before its entry was removed.

## Latency and cost

From `queue-report.md` and `candidates.tsv`:

- **Merged candidates' wall time:** median 34.9 min, p95 37.9 min (11 candidates). That is inside #1430's
  30–40 minute target.
- **Runner waits:** each candidate's longest wait for a hosted runner had a median of 3.0 s and a p95 of 12 s. The
  mean over 4,014 jobs was 2.1 s, so the pool wasn't saturated at four builds.
  - At the queue's busiest, 13:44 UTC, 261 hosted candidate jobs ran at once. That count excludes pull requests' runs.
- **Runner-minutes by outcome:**

  | Window | Candidates | Merged | Failed | Passed, invalidated | Cancelled | Not merged |
  | --- | ---: | ---: | ---: | ---: | ---: | ---: |
  | The whole day | 52 | 11 (10,158) | 11 (8,693) | 1 (929) | 29 (5,736) | 60.2% |
  | Since 15:38 (the first merge's candidate) | 37 | 11 (10,158) | 3 (2,330) | 1 (929) | 22 (4,168) | 42.2% |

  - Eight of the day's eleven failures came before 15:38. They were main's latent sanitizer failures, found one per
    run because a candidate fails fast, and #2631 fixed them.
  - The run that passed but was invalidated was #2632's candidate. It was built behind #2621's 16:43 candidate,
    whose x86-64 TSan shard 1 ran on a degraded hosted runner, an EPYC 9V45 at about a fifth of its usual speed. That
    candidate was cancelled after 1,014 runner-minutes, and everything built behind it was thrown away.

## Limitations

- **The first day only.** The failure share since 15:38 still includes entries removed by hand and one degraded
  runner. A steady-state failure rate needs more days, and `ci-timings` reports these figures daily.
- **No slot waits.** The time an entry waits for a build slot isn't in these figures. The pull request's timeline
  (`added_to_merge_queue`) against its candidate run's creation would give it.
- **Runner time is the sum of the jobs' own times.** Jobs cancelled before they started count nothing.
