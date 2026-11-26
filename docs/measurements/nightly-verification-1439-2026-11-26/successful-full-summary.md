## 9700X CI latency

Successful hardware jobs only; seconds of wall time. Event classes are not benchmark-coverage certificates.

| Event class | Metric | Samples | Median (s) | p95 (s) |
| --- | --- | ---: | ---: | ---: |
| full (daily, dispatched, snapshot) | queue | 8 | 1.0 | 3079 |
| full (daily, dispatched, snapshot) | execution | 8 | 1250.0 | 1327 |
| full (daily, dispatched, snapshot) | runner-hook | 8 | 1.0 | 86 |
| full (daily, dispatched, snapshot) | lock-wait | 8 | 1.0 | 86 |
| full (daily, dispatched, snapshot) | lock-hold | 8 | 1229.0 | 1320 |
| full (daily, dispatched, snapshot) | host-occupation | 8 | 1233.0 | 1324 |

p95 uses the nearest-rank definition. Missing timestamps are omitted.
`runner-hook` is the job-started hook's step, from the API's whole-second step times. `lock-wait` and `lock-hold` come from the hooks' own log lines instead, rounded to whole seconds: the wait runs from the job-started hook's start to its `this job has the machine`, the hold from there to the job-completed hook's `gave the machine back`, the host's time under this job's lock. Those lines bracket the lock operations, so each includes the hook's own work around them, tens of milliseconds, below the rounding.
`setup-build` spans host verification through the start of native tests. `benchmark-steps` is the sum of successful benchmark/measurement step durations, not a performance result.
`host-occupation` spans the job's first step after the runner hook (the lock is held by then) through the job's end: the time the host was this job's.
