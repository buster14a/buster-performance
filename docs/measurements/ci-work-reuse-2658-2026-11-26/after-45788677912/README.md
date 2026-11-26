# Hosted vector validation and rejected schedule follow-up for #2658

This record preserves a successful validation of the **historical candidate** source revision
[4d1f2024095f233cba19e8f8135dd99b17b9e264](https://github.com/buster14a/buster/commit/4d1f2024095f233cba19e8f8135dd99b17b9e264).
All 16 vector correctness suites passed, with the same 167 inventory headings,
four shards per configuration, four CPUs per runner, optimization settings and
detectors. The candidate also included the per-file reference reuse and guarded
sanitizer arena-limit experiment under review in PR
[3638](https://github.com/buster14a/buster/pull/3638).

The sanitizer arena-limit change was subsequently deferred because its
performance benefit was not isolated and the altered commit granularity could
add work. The final proposed source,
[e8746a798795c8e5e6702442a56f6d6ccc7a5b5d](https://github.com/buster14a/buster/commit/e8746a798795c8e5e6702442a56f6d6ccc7a5b5d),
retains per-file reference reuse and the five refreshed cost tables. These sixteen logs therefore **do not measure the
final PR revision**. They remain evidence of the earlier candidate and of why
the additional experiments were rejected; exact-head final CI is a separate
record, [45795512701](https://github.com/buster14a/buster/actions/runs/45795512701).

**This run does not establish a throughput improvement or completion of the
issue's whole-candidate goal.** The 16 selected vector jobs used **271.63 →
276.87 runner-minutes**, an increase of 1.93%, relative to the newest baseline.
The sum of time inside their suites fell from 152.68 to 146.69 runner-minutes.
CPU models, allocation, product waits and shared-host variation differ. Raw
comparisons restricted to identical CPU models are mixed. The normal PR checks
and hosted vector validation passed, but no full merge-candidate after run is
included here.

The proposed follow-up to teach the cost collector about vector shard one's
post-suite work was **deferred**. Its parser can recover that work, but schedules
chosen from the measured offsets regressed held-out observations. The existing
five refreshed production tables are retained. The complete collector prototype,
tests and rejection evidence remain reviewable in
[deferred-collector](deferred-collector/README.md) and
[sensitivity](sensitivity/sensitivity.tsv).

## Runs and exact observed timing

The after workflow
[45788677912](https://github.com/buster14a/buster/actions/runs/45788677912)
completed successfully at 09:31:04 UTC on 26 November 2026: 52 successful jobs
and seven skipped jobs, with no failed job or step. Its temporary validation
revision was
[1145a859668a030945878fc7361c2e767fc97166](https://github.com/buster14a/buster/commit/1145a859668a030945878fc7361c2e767fc97166).
That revision adds hosted validation YAML to the source above. This invocation
runs the four vector configurations only; it has no native row or fuzz campaigns.
Its complete workflow duration is therefore not compared with the full
merge-candidate baseline.

Both normal PR runs for the same source succeeded:
[45788632775](https://github.com/buster14a/buster/actions/runs/45788632775)
and the ready-for-review run
[45791459627](https://github.com/buster14a/buster/actions/runs/45791459627).
The latter completed at 09:34:13 UTC, with 22 successful and 17 skipped jobs.

The before column below is the newest of the three passing baseline candidates,
[45779319802](https://github.com/buster14a/buster/actions/runs/45779319802),
source 8e4d32879e17b7d9548cad54257a2f8461328366. The other baseline runs,
45779273785 and 45778920528, are used for model-matched heading medians and
schedule training.

| Vector configuration | Longest suite, before → after | Row span, before → after | Selected-job runner-minutes, before → after | Suite-only runner-minutes, before → after | Shard-one extra compile, before → after |
| --- | ---: | ---: | ---: | ---: | ---: |
| plain | 280.6 → 265.1 s | 581 → 564 s | 34.55 → 34.02 | 14.95 → 14.53 | skipped |
| ASan | 622.6 → 512.7 s | 1160 → 1155 s | 66.65 → 74.58 | 31.27 → 31.46 | skipped |
| TSan | 1009.3 → 869.8 s | 1305 → 1296 s | 77.82 → 78.60 | 55.56 → 55.29 | 98 → 103 s |
| MSan | 917.3 → 747.1 s | 1514 → 1484 s | 92.62 → 89.67 | 50.90 → 45.42 | 101 → 102 s |
| All 16 selected jobs | — | — | **271.63 → 276.87** | **152.68 → 146.69** | — |

Suite durations are the runner's exact reported values. Row span is latest
selected-job completion minus earliest selected-job start, using GitHub API
timestamps. Job runner-minutes sum completed_at minus started_at without
per-job rounding. These selected-job totals omit losing draws, collectors,
other orchestration jobs and all non-vector rows; they are not workflow cost.
Rounding each selected job up to a whole minute gives 278 before and 285 after,
a descriptive estimate rather than a billing statement.

The existing costs report reads first and last log timestamps, which are a few
seconds inside the API's job boundaries. Consequently report.txt has slightly
smaller spans and 276.0 rather than 276.87 after runner-minutes. The API-reconciled
table above is authoritative for job occupancy. Exact values and job IDs are in
[job-timings.tsv](job-timings.tsv) and [row-timings.tsv](row-timings.tsv).

After TSan shard one ran its 869.8-second suite followed by a 103-second separate
main.c compile, about 972.8 seconds of this work. The other TSan suites were
roughly 811–821 seconds. After MSan shard one ran a roughly 745.4-second suite
plus a 102-second compile, about 847.4 seconds, although the longest suite alone
was shard three's 747.1 seconds. These builder steps explain why reducing the
maximum suite time did not produce an equal row-span reduction.

The exact after CPU assignments were:

| Row | Shard 1 | Shard 2 | Shard 3 | Shard 4 |
| --- | --- | --- | --- | --- |
| plain | EPYC 9V45 | EPYC 9V74 | EPYC 9V74 | EPYC 9V45 |
| ASan | EPYC 9V45 | EPYC 9V45 | EPYC 9V74 | Xeon 8573C |
| TSan | EPYC 9V74 | Xeon 8573C | EPYC 9V74 | EPYC 9V74 |
| MSan | EPYC 9V74 | EPYC 9V45 | EPYC 9V74 | Xeon 8573C |

## Affected headings: identical CPU model comparisons

This is the primary hosted comparison for the source changes. For every after
heading, select only baseline observations of the **same heading, configuration
and exact CPU model**, then take their nearest-rank median. Compare the after
sample with that median. Baselines come from all three passing candidates.
No normalization fills a missing CPU match. Model identity does not make
different hosted VMs a controlled same-machine pair.

There are six per-file headings and sixteen semantic-driver headings per row.
The table sums matched headings' medians and the corresponding after values;
the sample count is the total number of baseline observations behind those
medians, not the number of independent after runs. All entries have one after
observation per matched heading. An unmatched heading is excluded from both
sums. CPU seconds come from each heading's reported total CPU time.

| Row / family | Exact model, abbreviated | Matched / unmatched headings | Baseline samples | Wall sum, baseline median → after | Wall change | CPU sum, baseline median → after | CPU change |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| plain files | EPYC 9V74 | 5 / 0 | 11 | 72.3 → 64.3 s | −11.1% | 67.0 → 59.9 s | −10.6% |
| plain driver | EPYC 9V45 | 3 / 4 | 3 | 145.6 → 139.3 s | −4.3% | 118.4 → 124.3 s | +5.0% |
| plain driver | EPYC 9V74 | 9 / 0 | 17 | 577.6 → 612.5 s | +6.0% | 461.4 → 459.2 s | −0.5% |
| ASan files | EPYC 9V45 | 4 / 0 | 6 | 84.8 → 97.7 s | +15.2% | 79.2 → 86.8 s | +9.6% |
| ASan files | EPYC 9V74 | 1 / 0 | 2 | 196.8 → 181.4 s | −7.8% | 184.0 → 171.0 s | −7.1% |
| ASan driver | EPYC 9V45 | 7 / 0 | 12 | 581.3 → 626.4 s | +7.8% | 466.4 → 504.1 s | +8.1% |
| ASan driver | EPYC 9V74 | 4 / 1 | 5 | 493.4 → 490.6 s | −0.6% | 399.8 → 411.2 s | +2.9% |
| ASan driver | Xeon 8573C | 1 / 3 | 1 | 182.3 → 166.1 s | −8.9% | 126.6 → 104.0 s | −17.9% |
| TSan files | EPYC 9V74 | 2 / 3 | 3 | 28.3 → 30.3 s | +7.1% | 42.7 → 45.9 s | +7.5% |
| TSan driver | EPYC 9V74 | 5 / 5 | 7 | 957.0 → 1066.4 s | +11.4% | 857.4 → 876.7 s | +2.3% |
| TSan driver | Xeon 8573C | 1 / 5 | 1 | 229.5 → 196.2 s | −14.5% | 195.2 → 160.4 s | −17.8% |
| MSan files | EPYC 9V74 | 4 / 1 | 8 | 175.5 → 162.6 s | −7.4% | 165.0 → 160.9 s | −2.5% |
| MSan files | Xeon 8573C | 1 / 0 | 2 | 208.5 → 235.4 s | +12.9% | 193.9 → 194.7 s | +0.4% |
| MSan driver | EPYC 9V45 | 5 / 2 | 5 | 574.4 → 564.1 s | −1.8% | 504.4 → 479.9 s | −4.9% |
| MSan driver | EPYC 9V74 | 6 / 2 | 13 | 932.9 → 904.4 s | −3.1% | 807.3 → 793.0 s | −1.8% |

Additional groups had no baseline model match: one plain-files heading on 9V45,
one ASan-files heading on 8573C, one TSan-files heading on 8573C, and one
MSan-driver heading on 8573C. They remain explicit in
[same-model.tsv](same-model.tsv) and
[same-model-summary.tsv](same-model-summary.tsv).

The exact model strings are AMD EPYC 9V45 96-Core Processor, AMD EPYC 9V74
80-Core Processor and INTEL(R) XEON(R) PLATINUM 8573C. These mixed observations
do not isolate a causal source-speedup claim. The separate
[runtime record](../runtime/README.md) contains the local order-reversal
experiment and its limitations.

## Initial table refresh predictions, kept separate

The original table refresh uses only the three baseline runs. Its scheduler
predictions compare the old and new deals scored with the same collected
90th-percentile costs. They are neither the observed table above nor forecasts
of whole-workflow completion. Setup, shared-product waits and vector shard one's
extra compile are excluded.

| Row | Predicted longest suite, old → refreshed | Predicted change |
| --- | ---: | ---: |
| native plain | 548.9 → 382.9 s | −30.2% |
| vector plain | 313.9 → 253.8 s | −19.1% |
| vector ASan | 643.4 → 549.3 s | −14.6% |
| vector TSan | 1286.5 → 909.3 s | −29.3% |
| vector MSan | 926.0 → 761.1 s | −17.8% |

All fifteen original two-training-run / one-held-out-run suite comparisons
improved their maximum, by 11.1–27.5%. Their complete plans and limitations are
in the [baseline record](../README.md). In particular, the 17.8% MSan forecast
does not include its observed 101-second builder compile and is not a 17.8%
total MSan or whole-candidate saving.

## Fresh after weights and post-suite offset sensitivity

The comparison helper imports the collector and scheduling code pinned at
4d1f202. It never imports the working-tree offset prototype. The main
before/after helper estimates model factors from the 60 baseline logs only:
9V45 = 822, 9V74 = 1000, 8573C = 980, slowest = 1000. It applies the collector's
integer rounding to wall time multiplied by held CPUs. The same factors score
both schedules; after samples do not fit their own apparent improvement away.

A one-run stock collection cannot estimate nonreference CPU speeds where no
heading is repeated across models. Accordingly after-costs and raw-vector plans
are diagnostic mixed-model outputs. The normalized plans freeze the baseline
factors. Their suite-only current → after-trained maxima are:

| Row | Current deal → after-trained deal, normalized suite-only maximum |
| --- | ---: |
| plain | 265.100 → 241.575 s |
| ASan | 546.533 → 531.950 s |
| TSan | 869.600 → 838.500 s |
| MSan | 747.100 → 707.875 s |

The fresh deal is trained and scored on the same after run. The figures measure
its fit to those observations, not a held-out gain. Adding the observed separate
compile durations to shard one, while leaving the deal unaware, gives
972.600 → 941.500 s for TSan and 847.400 → 809.350 s for MSan. These are the
normalized-plans.tsv “plus-extra” scenarios.

### Independent post-suite measurement

post-suite.c separately requires the actual suite's shard report, its single
timestamped summary, a later exact “Cleaning up orphan processes” completion
marker, complete samples and no post-suite error annotation. All 76 baseline
and after logs pass. Earlier unsharded product-build summaries are ignored.
Optional runner warnings after cleanup do not extend the interval.

The row's offset is the normalized median of shard-one post-suite durations
minus the normalized median of the other shards, clamped at zero. Common
cleanup time is therefore excluded. It contains no product waits, build time,
setup or collector waits.

| Sample set | plain | ASan | TSan | MSan |
| --- | ---: | ---: | ---: | ---: |
| Three baseline runs; 3 first-shard, 9 other samples per row | 0.0 s | 0.5 s | 96.1 s | 61.0 s |
| After run, frozen baseline factors; 1 first-shard, 3 other samples | 0.9 s | 0.0 s | 105.6 s | 101.6 s |

For the baseline TSan row the medians are 102.1 and 6.0 seconds; for MSan,
66.4 and 5.4 seconds. MSan's baseline first-shard raw intervals varied from
52.245 and 65.141 seconds to 104.832 seconds. Its offset is not a constant
102-second extra cost. Per-job timestamps and every per-run median are in
[post-suite.tsv](post-suite.tsv) and
[post-suite-summary.tsv](post-suite-summary.tsv).

### Why the new offset schedules were deferred

schedule-sensitivity.c recollects the original tables with the pinned existing
collector, then adds only the independently measured post-suite offset in
scratch. It verifies that the three-run weights and peaks exactly reproduce
the current tables. Each evaluation uses its own observed offset, normalized
using the training set's factors, to score both schedules. All scenarios retain
four shards, four CPUs and the existing 90% memory bound.

Applying the exact baseline offsets to the existing three-run weights makes the
after observation worse:

| Row | Current deal | Same weights, offset-aware deal | Maximum change | Runner-minutes, current → aware |
| --- | ---: | ---: | ---: | ---: |
| TSan | 975.200 s | 1059.200 s | +8.6% | 57.318 → 59.570 |
| MSan | 847.000 s | 885.450 s | +4.5% | 49.262 → 52.058 |

These values use the observed differential after cleanup, not the coarser API
compile-step duration; that explains the small difference from “plus-extra”
above. The difference does not change the decision.

Recollecting all four runs produces factors 815/1000/984 and offsets 0.0/0.4/
96.5/60.5 seconds. Fitting those costs and offsets to the same after run predicts
975.2 → 887.4 seconds for TSan and 847.0 → 769.0 seconds for MSan, but increases
runner-minutes from 57.263 → 57.955 and 49.307 → 50.027 respectively. These are
in-sample fits. Four-fold validation, always excluding the evaluated run from
training, is mixed:

| Held-out run | TSan maximum, current PR → offset-aware training deal | Change | MSan maximum, current PR → offset-aware training deal | Change |
| --- | ---: | ---: | ---: | ---: |
| 45778920528 | 936.875 → 932.925 s | −0.4% | 765.125 → 788.625 s | +3.1% |
| 45779273785 | 937.350 → 905.716 s | −3.4% | 716.900 → 761.600 s | +6.2% |
| 45779319802 | 979.875 → 973.200 s | −0.7% | 854.525 → 787.791 s | −7.8% |
| 45788677912 | 975.200 → 1059.200 s | +8.6% | 847.000 → 885.450 s | +4.5% |

The current PR reference uses all three baseline runs; the new training deal
excludes the evaluated run. To isolate the offset's effect without that
reference asymmetry, sensitivity.tsv also scores each fold's identical trained
weights with and without the offset. In the baseline-only three folds those
changes are TSan +5.2%, −5.7%, −6.5%, and MSan −0.3%, +3.1%, −11.0%.
The four-run folds also fail to improve consistently.

Every training subset recalculates CPU ratios using only its own observations.
One two-run fold has fewer than five overlapping Intel headings and retains
those raw samples, exactly as the stock collector does; its factor is recorded
as zero. The all-three and all-four collections have measured factors for all
three CPU models. This diagnostic is a sensitivity analysis, not a guarantee of
future runner placement or runtime.

No diagnostic after table or offset table was copied into production. The
collector prototype is archived and the compiler working-tree change was
reverted. A useful parser feature alone does not justify a schedule with worse
held-out behavior.

## Files, provenance and reproduction

The archive logs.tar.gz contains the sixteen exact decoded GitHub job logs.
logs.sha256 identifies each decoded file. Its archive SHA-256 is
b0244a237f507d6261bb13a70186fd958ac8c77278e6e8b3205c715760fc2dd2.
No compiled product or analysis executable is included.

run.json and jobs.json retain final API metadata for the validation run.
pr-ready-run.json and pr-ready-jobs.json retain the second successful normal PR
run. job-timings.tsv reconciles the selected before and after jobs against API
timestamps. headings.tsv retains every before/after heading, peak, raw CPU and
wall time, normalized values and semantic-driver run-mode counts. The raw logs
also preserve all run-mode assertions.

current-costs contains the four vector tables from 4d1f202. after-costs contains
the diagnostic single-run collection. sensitivity contains all nine training
sets, their generated tables and CPU factors, complete after schedules and
the full score matrix. The collector prototype has its own pinned reproduction
record under deferred-collector.

Run the network-free replay with a checkout whose Git object database contains
4d1f202:

    bash reproduce.sh /absolute/path/to/buster /absolute/path/to/new-output

It unpacks logs when necessary, checks their hashes, extracts the pinned
collector, inventory and scheduler, rebuilds only small analysis helpers,
reproduces tables, reports, model-matched comparisons and every sensitivity
score, and compares them with this record. The helpers' build optimization is
not a change to the measured compiler product. Replaying requires the sibling
baseline record's logs or logs.tar.gz and its checksum manifest.

The raw same-model observations, selected-job runner-minute increase, builder
overhead and rejected scheduling alternatives must remain attached to any use
of the favorable suite-max numbers. This record does not claim that the
16.4-minute whole-candidate target has been reached.
