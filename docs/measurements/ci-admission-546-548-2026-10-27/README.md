# 9700X admission: #546–#548 live acceptance

Source: [Buster PR #557](https://github.com/buster14a/buster/pull/557),
qualified head `cad9a8f54966c92fe842f5bc9800bd7eb8acfe7f`, merged as
`78ec3f8a8716cd0a8427caa621acc13c33847135`. The ordinary pre-activation
[9700X run](https://github.com/buster14a/buster/actions/runs/40497893284) passed.
The source change is separate from this operational evidence. All times are UTC.

## Before admission

`before/` archives REST workflow-run/job/review responses for seven recent
successful PR qualifications and the source PR's qualification. These are actual
`buster-zen5-9700x` jobs, not local-laptop or fixture timing. The sample is
observational: source revisions, workloads and queue conditions differ. It is
not a matched compiler-speed comparison or an estimate of causal improvement.

| PR | Run | Event to physical job | Job wall time | Job start to host verification |
| --- | --- | ---: | ---: | ---: |
| #520 | 40490876689 | 1,723 s | 185 s | 13 s |
| #556 | 40491896797 | 1,433 s | 222 s | 38 s |
| #511 | 40492263502 | 659 s | 215 s | 58 s |
| #517 | 40492626588 | 253 s | 231 s | 63 s |
| #555 | 40493711074 | 805 s | 207 s | 66 s |
| #553 | 40494643695 | 1,124 s | 383 s | 112 s |
| #550 | 40495946068 | 290 s | 215 s | 75 s |
| #557 | 40497893284 | 105 s | 221 s | 39 s |
| #559 probe | 40498518163 | 549 s | 219 s | 97 s |

The event is the Actions run's `created_at`; job start/end are its completed
physical job's `started_at`/`completed_at`. Job wall time includes the runner
hook's lock wait and setup. `Verify host and bootstrap compiler` starts after the
hook has acquired the lock, so its timestamp distinguishes that wait from the
subsequent qualification wall time. Neither duration is a CPU-busy measurement.
The filtered identity logs preserve setup, checkout, host verification and
completion; checkout's `git log -1 --format=%H` identifies the actual tested merge.

The historical review snapshots contain no current-head `APPROVED` review for
these selected runs. Approval-to-green latency is therefore unavailable; a
`COMMENTED` review is not silently counted as approval. The controlled
[probe PR #559](https://github.com/buster14a/buster/pull/559) records an explicit
`/ci approve` command and its real author/permission/time before physical qualification,
so the campaign can measure that path without inventing historical approval.
The command was posted at 11:45:44 and the physical job passed at 11:58:10:
**746 seconds approval-to-green**. Its head was
`375361b435cb1e99c9a1afe3a214c02843d3bd71`; the archived checkout log pins the
actual old-path test merge. This is one controlled observation under the recorded
queue, not a statistical estimate.

GitHub may empty a workflow run's `pull_requests` array after merging.
`associations-40497893284.json` preserves the commit-to-PR association used by
the report to identify merged #557. The raw head SHA is retained in all rows.

## Staged host source gate

The existing runner group has one runner and selected repositories Buster and
`buster-legacy`, with all-workflow access. Its access was inspected in the
administrator UI and left unchanged. The root-owned Buster-only source gate
preserves legacy policy. The installed runner is 2.338.0; `after/host.txt`
records the actual 9700X/toolchain/lock metadata.

`before/host-hook-environment.txt` records only the three whitelisted identity
variables from an actual running PR #550 job-start hook. They identify the PR
merge workflow/ref, rather than `main`, confirming the identity the source gate
will reject. No credential environment was printed or archived.

The reviewed-main guard was built on the 9700X under `exclusive.sh`, with owner
`codex-546-548`, title `CI admission reviewed host guard build` and source PR
link. Its separate self-test invocation also acquired the shared lock: 183
checks, zero failures (`after/host-guard-selftest.log`). Both were short separate
runs, not one lock around a series. This validates metadata code, not compiler
performance.

`after/staged-source-gate.txt` records installation with the enable marker absent.
The original start hook was copied once with owner/mode/content preserved, then
the reviewed wrapper and guard were installed atomically, root-owned 0755.
Original start-hook SHA-256:
`2888467bc28b3d7820620d7983e34a93b0e4643b76e64b2eb763c3b116fe4b96`.
Unchanged completed-hook SHA-256:
`861bdaf651283ba8da65be6a40ce15afc83b49c009cf8e909519ffc0569fd4b1`.
No runner registration, restart, `.env`, group access or shared-lock change was
needed. Installation alone does not enable admission or establish live acceptance.

## First cutover and paused recovery

The root marker was enabled at 12:00:32, then repository admission/capacity
variables were enabled and the default-branch controller was dispatched
([run 40500413196](https://github.com/buster14a/buster/actions/runs/40500413196)).
The standalone installed-gate probe rejected a PR workflow identity before the
lock, accepted reviewed main and retained legacy access. Its output and unchanged
original/completed-hook hashes are in `after/installed-source-gate-probe.txt`.

Live validation found that #559's PR `baseRefOid` and test-merge parents still
pointed at `ad408cf2`, while `baseRef.target.oid` was `78ec3f8a`. The raw query is
`after/stale-base-snapshot-559.json`. It also found missing fork variable context,
empty fork run `pull_requests` arrays and missing creator fields in the combined
commit-status response. These are addressed by source follow-up
[PR #564](https://github.com/buster14a/buster/pull/564).

Admission was turned off, and the controlled fork's native run 40500493197 was
cancelled and confirmed terminal before closing #563 and removing the host marker
at 12:07:49. The wrapper remains installed and inert. The paused ledger has
**generation 0, no issued lease**, and is retained with the variables and first
controller log under `after/paused-*` and `after/first-reconcile.log`.
This was a paused rollout, not a successful after campaign.

Two ordinary bootstrap runs then failed before compilation because `/tmp` had
reached its 1,048,576-inode limit despite having free data space. Under a separate
shared-lock administrative run, the live tmpfs inode limit was raised to
4,194,304 at 12:42:36. No files were removed and no persistent mount configuration
was changed. The failure log and resulting mount/inode metadata are in
`after/bootstrap-1d5d32bc-inode-failure.log` and `after/tmpfs-inode-recovery.txt`.
The unchanged source head `1d5d32bc` then passed on native run 40505449677 attempt 2
at 12:47:19. Later review fixes still require their own current-head qualification.

## Reviewed cache and negative-dispatch validation

Candidate `5bb1d029` added immutable head/base/engine caching and actual bounded
preflight workers. `64aacbfc` also disabled background Git maintenance and made
process-group cleanup retain the leader PID until helpers were stopped. These
candidate observations are read-only validation, not post-cutover hardware timing.

The original `profile-preflight.c` audit ran through `cores -n 1` on the local
machine. Its cold pass read all 16 actual open PRs and completed 16 Git preflights
with zero errors/deferred results in **22,884 ms** of Git work. It serialized the
cache, deleted the private object store and reloaded that cache for a fresh pass.
Fifteen unchanged pairs were reused; only #567's changed head was recomputed,
taking **2,378 ms**. That head changed `5d616ff5` → `7153d997`, with base
`a2c7c5b6` unchanged. Raw per-pair SHAs, engine and counters are in
`after/candidate-cache-profile.log`; the local cache and allocator wait/grant log
are retained too. This is metadata work on the local machine, not a 9700X benchmark.

With admission off, a targeted dispatch of candidate `5bb1d029` for #559
([run 40510747650](https://github.com/buster14a/buster/actions/runs/40510747650))
failed only its intended hosted `invalid-target` rejection. Admission, selector
and physical jobs were skipped; the archived job response identifies no physical
runner. The workflow failure is the expected pass condition of this negative
test, not a qualification failure. The repository's fork contributor-approval
policy was read and preserved as `all_external_contributors`.

## Reproduction and limits

Use a Buster checkout at `78ec3f8a8716cd0a8427caa621acc13c33847135` for its
original bounded JSON reader, then from this repository:

```sh
campaign=docs/measurements/ci-admission-546-548-2026-10-27
cc -std=c17 -O2 -Wall -Wextra -Werror -Wno-unused-function \
  -I ../buster/tools/ci "$campaign/report.c" -o /tmp/admission-report
/tmp/admission-report "$campaign"/before/run-*.json > /tmp/before.tsv
diff -u "$campaign/before/summary.tsv" /tmp/before.tsv
```

`report.c` is original analysis code. It reads saved responses and makes no API
calls. API snapshots were collected with `gh api` for
`repos/buster14a/buster/actions/runs/ID`, `/jobs?per_page=100`,
`repos/buster14a/buster/pulls/PR/reviews?per_page=100`, and the explicit probe's
conversation comments and collaborator permission. Identity logs were extracted
from `gh run view ID --job JOB --log`, retaining only the four named steps above.
The original required-context/integration rules are in `before/ruleset.json`.

Live activation, default-branch and public-fork result attribution, promotion,
hold/resume/retry, conflict/resolve and post-cutover timings are still pending at
this staging snapshot. Fixture success and an installed inert hook do not satisfy
those gates. Do not claim the full issues complete from this snapshot.
