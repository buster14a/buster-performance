# The merge queue's waste and fresh shard costs (#2703), 2026-11-14

Where main's merge queue spent its runner time from the queue's start (2026-11-13 11:49 UTC) to 2026-11-14 09:00 UTC.
The questions: what sets a passing candidate's wall time, and why failing candidates cost almost as much as passing
ones. The analysis is behind buster's issue #2703 and its pull request. The PR stops a failing candidate at its first
failure (`parallel --fail-fast`, plus a run cancel once a candidate's tests or fuzz campaigns fail), and refreshes the
rows' shard costs.

## Contents

| Path | What |
|---|---|
| `results/candidates.tsv` | The 162 completed `merge_group` runs of `gh-readonly-queue/main/*`: run, conclusion, start, update, commit, branch, attempt |
| `results/main-first-parents.txt` | Main's first parents since 2026-11-13 11:00 UTC: a candidate merged when its commit is one |
| `results/jobs.tsv` | Every job of 160 of them (two runs' second pages failed to download): 18,431 jobs with name, conclusion, times, runner and first failed step |
| `results/waste.txt` | `scripts/waste.py`: runner time by fate and period, and each failure's first failed job and run end |
| `results/merged.txt` | `scripts/merged.py`: merged candidates' wall time, the job that finished last, each row's shard test-step medians |
| `results/steps.txt` | `scripts/steps.py`: a merged candidate's runner time by job kind and step |
| `results/span.txt` | `scripts/span.py`: when each row's tests start, and its build's time |
| `results/failing-commands.tsv` | The failed jobs' failing commands, from their logs' headings, outside the outage |
| `results/plan-compare.md` | `costs plan` per row: the longest shard by today's tables and by the fresh ones, both timed by the fresh costs |
| `scripts/` | The analysis scripts (Python 3). Each reads `$QUEUE_DATA/runs.tsv`, `main.txt` and `jobs/RUN-PAGE.json` (the API's `actions/runs/RUN/jobs?per_page=100&page=PAGE&filter=latest`) |

## Where the runner time went

160 candidates, 1,080 runner-hours, 43 merges (`results/waste.txt`):

| Fate | Runs | Runner time | Per run |
|---|---:|---:|---:|
| merged | 43 | 60.5% | 912 runner-min |
| failed | 15 | 18.3% | 790 runner-min |
| cancelled (invalidated behind a failure) | 34 | 11.2% | 213 runner-min |
| passed, not merged | 1 | 1.4% | 929 runner-min |
| the libc6 404 outage, 22:20–02:50 UTC: failed | 32 | 1.1% | 22 runner-min |
| the outage: cancelled | 35 | 7.5% | 139 runner-min |

During the outage, `prepare-hosted-tools` failed on every candidate that missed its cache. Ubuntu's archive had
dropped the pinned glibc, and buster#2687 fixed it. Each failure took about 18 minutes: three acquisition attempts,
each about 4.5 minutes before its 404s, with 20 s and 40 s between them. No candidate merged for four and a half hours.

**Failures report late.** Outside the outage, a failing candidate's first failed job ended 16.4 to 33.5 minutes in,
22.5 on average, and the required check failed 21.9 to 35.2 minutes in. Yet the failing commands
(`results/failing-commands.tsv`) ran for 0.7 to 82 s. Two reasons:

- `parallel` ran a shard to its end after a failure. One shard reported "49 commands in 820.1 s: 45 passed, 1 failed,
  3 skipped, 0 not started" for a 2.8 s failure. Its report comes in the list's order, so nothing showed until the
  commands before the failure had ended.
- The aggregate waited for the other matrices. GitHub's fail-fast is per matrix, and the fuzz campaigns took about
  21 minutes (`frontend`), so even an early failure couldn't fail the required check before then.

Several failures also repeat in the entry behind, whose candidate contains the failing change: 43575669389 for
buster#2674 and 43575670467 for buster#2681 failed the same test.

## A passing candidate (`results/merged.txt`, `steps.txt`, `span.txt`)

- **Wall time:** median 34.2 min over 43 (29.9 to 37.8). After buster#2660 the preamble is 1.4 minutes; before it
  the first shard started at a median 4.7 minutes.
- **The job that finished last:** an x86-64 MSan shard 20 times, a native MSan shard 14, a native TSan shard 4, a
  vector item 1 4.
- **Runner time, 912 minutes:**
  - test steps 58%;
  - native shards building their own compiler 12.5%;
  - vector items waiting for their configuration's product 9.0%;
  - the fuzz jobs' builds 3.5% (31.6 of their 35 minutes);
  - Clang installs and input restores about 4%.
- **Builds:** MSan about 10 minutes (native 628 s median, the x86-64 product 454 s, vector item 1 up to 892 s), TSan
  about 4 (226 s native). In a native MSan build's log, the benchmark-only units take about 2.5 of its 10 minutes.
- **Shard imbalance under the old tables.** The test steps' medians ranged from 344 to 999 s within x86-64 MSan, 682
  to 1,118 s within native TSan, and 421 to 836 s within native MSan.

## Fresh shard costs (`results/plan-compare.md`)

The sanitizer rows' tables held 3 to 7 samples a command, from revisions before 11 November. `costs collect` over the
318 shard logs of the six candidates that merged after buster#2660 gives 6 samples a command in every row:

- 43574311146 (buster#2660)
- 43575635669 (#2698)
- 43577948137 (#2681)
- 43577949253 (#2683)
- 43577950072 (#2688)
- 43577951162 (#2696)

`costs plan --deal OLD` then times the old deal by the new costs. The longest shard, in the slowest CPU's seconds:

| Row | Old tables | Fresh tables |
|---|---:|---:|
| native TSan | 1,479.0 | 1,313.0 |
| native MSan | 1,293.4 | 1,099.0 |
| x86-64 MSan | 1,236.9 | 1,061.6 |
| x86-64 TSan | 1,335.4 | 1,286.9 (its floor: the semantic driver's part 1 of 4) |
| vector TSan | 1,393.0 | 1,178.7 |
| vector MSan | 1,067.7 | 988.4 |

Every row's longest shard shortens, 2% to 22%. The candidates after the PR will measure the effect on wall time.

To reproduce:

```sh
bash tools/ci/costs.sh LOGS 43574311146 43575635669 43577948137 43577949253 43577950072 43577951162
```

That needs `gh` with `--paginate`, which fails through the cloud sessions' proxy, so those sessions page by hand.

## Not measured here

The 9700X: nothing in the change runs on it. `parallel.c` is test tooling outside the compile path.
