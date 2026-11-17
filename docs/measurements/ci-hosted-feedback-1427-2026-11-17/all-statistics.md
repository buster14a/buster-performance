## CI latency and cost

Hardware metrics use successful hardware jobs. PR first-result includes useful early passes and actionable failures; cost includes every allocated job and attempt, including failures and redraws. Values are seconds except runner-minutes. Event classes are not coverage certificates.

| Event class | Metric | Samples | Median | p95 |
| --- | --- | ---: | ---: | ---: |
| PR | first-result | 6 | 312.5 | 360 |
| PR | runner-minutes | 7 | 28.43 | 69.78 |
| PR | total runner-minutes | 7 | 243.12 | — |

p95 uses the nearest-rank definition. Missing timestamps are omitted.
`first-result` starts at run creation (queue/setup included) and ends at the first completed early-feedback pass or failed prerequisite/test step. Qualification/coverage aggregates are excluded: cancellation can fail them without an actionable product or infrastructure failure. Cancelled, skipped and incomplete steps never count as passes. Completed PR runs without a first result or complete job timestamps have no corresponding sample. `runner-minutes` sums actual allocated job durations across all attempts, not rounded billing minutes.
`runner-hook` is the job-started hook's step, from the API's whole-second step times. `lock-wait` and `lock-hold` come from the hooks' own log lines instead, rounded to whole seconds: the wait runs from the job-started hook's start to its `this job has the machine`, the hold from there to the job-completed hook's `gave the machine back`, the host's time under this job's lock. Those lines bracket the lock operations, so each includes the hook's own work around them, tens of milliseconds, below the rounding.
`setup-build` spans host verification through the start of native tests. `benchmark-steps` is the sum of successful benchmark/measurement step durations, not a performance result.
`host-occupation` spans the job's first step after the runner hook (the lock is held by then) through the job's end: the time the host was this job's.
