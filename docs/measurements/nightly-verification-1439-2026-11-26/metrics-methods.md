# Independent review of retained 9700X timing evidence

This review recomputes the timing observations from the retained hardware
**job** API records and the hooks' own timestamped log lines. It replaces
the provisional queue and wait calculations, which are not published. In particular,
workflow creation-to-job start includes hosted admission work and is **not**
the hardware job's runner queue.

## Definitions and arithmetic

The definitions were checked against `tools/ci/timings.c`,
`tools/ci/timings.sh` and `tools/ci/timings_accounting.c` at
buster `8e4d32879e17b7d9548cad54257a2f8461328366`.

- **Hardware job queue:** the hardware job's API `started_at - created_at`.
- **Lock wait:** the log line starting `##[group]Run .../job-started.sh`
  through `buster-9700x: this job has the machine`. API job start and API
  “Set up runner” step start are not substituted for the first marker.
- **Lock hold:** acquisition marker through
  `buster-9700x: gave the machine back`.
- **API host occupation:** the first step after the runner hook
  (“Verify benchmark host” in these records) through the API job end.
  This overlaps lock hold and execution; these durations must not be added.
- **Quantiles:** the average of the two central observations for an even
  median; nearest-rank p95, `ceil(0.95 * n)`, as the existing C timing reader.
- **Canonical current integer-second inputs:** `timings.sh` parses each
  timestamp with `date ... +%s`, then subtracts endpoints. Both integer
  endpoint subtraction and nearest-second rounding of the exact duration
  are retained separately, because the two can differ by one second.
- **Exact sums:** timestamp fractions were parsed as integer nanoseconds,
  preserving the source's seven fractional digits; only afterward was the
  difference rendered as decimal seconds. The authoritative precise totals
  are the `exact_lock_*_sum_seconds` strings in the summary.

The parent supplemented 37 extracts with `hook-context-JOB.json`, because
the first extraction omitted the hook-start marker. Every reviewed observation
now has its exact start, acquisition and release markers. All 48 hardware
jobs match one hook record and the ledger's exact commit SHA.

## November 26: all outcomes

All 40 admitted hardware jobs were actually allocated to
`buster-zen5-9700x`. Their ownership intervals are pairwise disjoint and
wholly inside **01:00–07:00 UTC / 02:00–08:00 Madrid**.

First acquisition: **01:02:22.7300603 UTC**.

Last release: **06:36:50.3641329 UTC**.

The table below uses current integer-endpoint seconds for quantiles.

| Cohort | Jobs | Distinct states | Queue median / p95 | Lock-wait median / p95 | Lock-hold median / p95 | Exact lock-hold sum |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| All admissions | 40 | 19 | 1 / 2 s | 1 / 1 s | 436.5 / 511 s | 16,351.5595482 s |
| All backlog | 39 | 18 | 1 / 2 s | 1 / 1 s | 437 / 549 s | 16,005.4776348 s |
| Completed backlog | 7 | 7 | 1 / 2 s | 1 / 1 s | 491 / 575 s | 3,554.0231461 s |
| Failed backlog | 32 | 11 | 1 / 2 s | 1 / 1 s | 390 / 473 s | 12,451.4544887 s |
| Failed full snapshot | 1 | 1 | 1 / 1 s | 1 / 1 s | 346 / 346 s | 346.0819134 s |

The 39 backlog requests cover **18 unique states**: seven completed once,
ten failed in three separate admitted runs each, and
`dc58207037ab92f1ba052151e107bd8c61deb2f8` failed twice. Thus 32 failed
backlog runs do not mean 32 different failed states. They are distinct
dispatch/run IDs, not attempts of a single GitHub run.

Total observed lock occupation is **4 h 32 min 31.5595482 s**, approximately
**75.70%** of the six-hour window. Of it, **12,797.5364021 s** was spent by
failed/blocked jobs (32 backlog failures plus the blocked-native snapshot).
That is outcome-attributed occupation, not proof that all the underlying
work was useless; those jobs also ran correctness before their failures.

The separate API host-occupation sum is **16,529 s**, and allocated job
execution is **16,645 s**. Those metrics include different start/end
boundaries. They are not additional time to add to lock hold.

The exact total lock wait is **40.6147275 s**. Current endpoint-integer waits
sum to 41 s; rounding each exact duration to its nearest second instead gives
40 s. The median and p95 are 1 s by either convention. Failed-backlog hold
median is 390 s with current endpoint subtraction versus 389.5 s when
rounding each exact duration; the complete-backlog comparison is unaffected.

## Successful targeted before/after comparison

| Successful targeted hardware cohort | Samples | Queue median | Lock-wait median | Lock-hold median |
| --- | ---: | ---: | ---: | ---: |
| November 6 frozen verification | 25 | 1 s | 1 s | 286 s |
| November 26, recomputed here | 7 | 1 s | 1 s | 491 s |

The current successful cohort's lock-hold median is **205 seconds / 71.7%
higher**. This is an observational workload comparison across different
historical compiler states and command inventories; it does not isolate a
regression caused by the coordinator fixes. Current queue/wait values provide
no evidence of a queue/wait improvement from the already low November 6
targeted medians. Failed runs remain included in the all-outcome occupation
analysis above rather than silently disappearing from utilization.

The November 6 baseline is the retained
[verification report](https://github.com/buster14a/buster-performance/blob/f7a479ceedb858e3a68b3fd809c77882040c8ad9/docs/measurements/nightly-verification-1439-2026-11-06/README.md).
This review's current seven successful observations were also fed into the
repository's existing C reader, whose generated table is
`successful-backlog-summary.md`.

## Eight historical full native/measurement successes

These are the eight successful hardware admission jobs on November 7, 13, 14,
19, 20, 21, 22 and 23, not a same-day population and not a certificate of every
cycle's hosted diagnostics.

| Metric | Samples | Median | p95 |
| --- | ---: | ---: | ---: |
| Hardware job queue | 8 | 1 s | 3,079 s |
| Lock wait | 8 | 1 s | 86 s |
| Lock hold, integer endpoints | 8 | 1,229 s | 1,320 s |
| API host occupation | 8 | 1,233 s | 1,324 s |

Exact aggregate hold is **9,990.5179922 s** across those eight distinct days.
The 3,079-second queue is the actual hardware job queue on November 7.
Nearest-second duration rounding gives full-cohort hold p95 1,319 s instead
of the current endpoint-integer 1,320 s. The raw exact maximum is
1,319.3843148 s; this is a rounding-convention difference.

November 13's preparation was blocked-hosted even though its admitted native
measurement job succeeded. This table retains that hardware timing without
claiming all hosted diagnostics passed.

## Files and replay

- `workers/metrics-reviewed-observations.json` inside `raw-evidence.tar.gz`: 48 normalized jobs with raw
  timestamp strings, exact differences, integer-endpoint values, rounded
  durations and source filenames.
- `metrics.json`: cohort quantiles, exact sums, window and
  overlap checks, and all 18 backlog state/attempt counts.
- `workers/metrics-reviewed-hooks.json` inside `raw-evidence.tar.gz`: extracted hook lines from the retained
  sources (includes the two earlier failed snapshots outside these cohorts).
- `successful-backlog-input.tsv` and
  `successful-full-input.tsv`: thin native inputs to the
  unchanged C timing reader.
- `successful-backlog-summary.md` and `successful-full-summary.md`: independently reproduced success-only
  quantile tables. Failed outcomes are deliberately not passed to a reader
  whose header says “Successful hardware jobs only”; their explicit
  all-outcome statistics remain in the normalized summary above.

To reproduce the success-only tables from a checkout of the recorded source,
replace `/path/to/report` with the directory containing this report:

```sh
cc -std=c17 -O2 -Wall -Wextra -Werror -fno-strict-aliasing tools/ci/timings.c -o /tmp/timings-1439
/tmp/timings-1439 < /path/to/report/successful-backlog-input.tsv
/tmp/timings-1439 < /path/to/report/successful-full-input.tsv
```

All analysis was offline using retained evidence. No hardware access or
workflow dispatch was performed.
