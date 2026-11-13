
## Merge-queue candidates

Completed `merge_group` runs of `9700x.yml`, by what became of the candidate: runner time is the sum of its jobs' own times.

| Outcome | Candidates | Runner-minutes |
| --- | ---: | ---: |
| merged | 11 | 10158 |
| passed, not merged (invalidated) | 1 | 929 |
| failed | 11 | 8693 |
| cancelled (dropped or invalidated) | 29 | 5736 |
| all | 52 | 25517 |

Candidates that didn't merge took 15359 runner-minutes, 60.2% of the queue's: the failures themselves, and the entries behind them that GitHub rebuilt, whose first runs passed, failed or were cancelled for nothing.

Merged candidates' wall time, from the run's start to its last update: median 34.9 min, p95 37.9 min (11 candidates).

Hosted jobs' waits for a runner, from each job's creation to its start: each candidate's longest, median 3.0 s and p95 12 s (52 candidates); every job's, mean 2.1 s over 4014 jobs.
