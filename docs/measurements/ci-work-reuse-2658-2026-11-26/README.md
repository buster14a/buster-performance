# Hosted CI costs for #2658, 26 November 2026

## Final scope and subsequent evidence

The final proposed compiler revision is
[e8746a798795c8e5e6702442a56f6d6ccc7a5b5d](https://github.com/buster14a/buster/commit/e8746a798795c8e5e6702442a56f6d6ccc7a5b5d),
tree 191d46ae8381b89d8d9107ed5d0752d75fd6c06d. It retains the five cost tables
documented below and the [per-file reference reuse](files-reuse/README.md).
The final-head normal PR workflow is
[45795512701](https://github.com/buster14a/buster/actions/runs/45795512701).

The [hosted after record](after-45788677912/README.md) and
[local runtime record](runtime/README.md) preserve the earlier candidate
4d1f2024095f233cba19e8f8135dd99b17b9e264. That candidate also contained a
sanitizer arena-policy experiment which was later removed. Its sixteen vector
suites passed, but these measurements do not describe the final PR revision.
Selected vector-job occupancy increased from 271.63 to 276.87 runner-minutes;
same-model comparisons were mixed, and the local A/B/A sequence showed large
drift. No causal source-speedup or whole-candidate target attainment is claimed.

The tested [arena-policy patch](after-45788677912/deferred-arena-policy/README.md)
and [post-suite cost-collector patch](after-45788677912/deferred-collector/README.md)
are preserved as deferred experiments. Offset-aware schedule forecasts
regressed held-out observations. Neither experiment is part of the final
compiler tree. The original three-run measurements, generated tables and
held-out schedules below remain unchanged.

## Original three-run collection

This record recalibrates the five active hosted cost tables from three passing
merge-queue candidates. The current table generator and scheduler are unchanged.
The inventory still contains 167 headings, every row still has four shards,
and the optimization, detector, sanitizer and CPU settings are unchanged.
No 9700X/benchpress access was used.

## Observed candidates

All are first attempts, `merge_group`, completed successfully. Wall time below
is the workflow's recorded `updated_at - run_started_at`; runner-minutes are
the sum of nonnegative job `completed_at - started_at`, without per-job billing
rounding. These are observations of the **old** tables, not after measurements.

| Run | Revision | Wall | Runner-minutes |
| --- | --- | ---: | ---: |
| [45779319802](https://github.com/buster14a/buster/actions/runs/45779319802) | `8e4d32879e17b7d9548cad54257a2f8461328366` | 27m09s | 379.82 |
| [45779273785](https://github.com/buster14a/buster/actions/runs/45779273785) | `a2f06b5bdef1930b6ee1c974ffdccf14cd3882be` | 25m53s | 370.42 |
| [45778920528](https://github.com/buster14a/buster/actions/runs/45778920528) | `7df8ae398e4717507c98a9ae7c28d2815a98af97` | 30m31s | 405.50 |

Each has 112 job records, 84 non-skipped jobs, and 20 correctness-suite jobs:
four native plain and four each of vector plain, ASan, TSan and MSan. The
60 suite logs contain every current heading three times per row. The recorded
CPU classes are AMD EPYC 9V45, AMD EPYC 9V74 and Intel Xeon Platinum 8573C.
The existing collector estimates their relative times as 0.82, 1.00 and 0.98
respectively and uses its existing 90th-percentile rule. See each generated
table for per-row CPU/job counts, revisions and peaks.

The newest run's critical jobs were MSan `m3` and `m4`, both on EPYC 9V74:

| Job | Product wait | Correctness suite | Completion |
| --- | ---: | ---: | --- |
| [139771125492, m3](https://github.com/buster14a/buster/actions/runs/45779319802/job/139771125492) | 521s | 917.3s | 08:24:58 UTC |
| [139771125496, m4](https://github.com/buster14a/buster/actions/runs/45779319802/job/139771125496) | 521s | 898.0s | 08:24:45 UTC |
| [139771125484, m1 builder](https://github.com/buster14a/buster/actions/runs/45779319802/job/139771125484) | build 495s | 604.9s | 08:21:25 UTC |

The same run spent 174.7 runner-minutes in the twenty correctness-suite steps,
70.65 waiting for shared products, 42.33 in the three fuzz build/qualification
steps, and 34.97 in the eight correctness product builds. Product waits and
builds are unchanged by the cost update.

## Predicted schedule with the refreshed tables

`costs plan` scores both deals with the same freshly collected costs. The old
deal is selected with `--deal baseline/ROW-O3.costs`; the new deal uses the new
table. These are **scheduler predictions**, not measured speedups. All are
four-shard, four-CPU schedules. Setup and vector shard-one extra steps are
excluded from this table.

| Row | Longest, old → new | Change | Mean, old → new | Imbalance, old → new | Floor | Suite runner-minutes, old → new |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| native plain | 548.9 → 382.9s | -30.2% | 390.1 → 381.5s | 1.41 → 1.00 | 271.3s | 26.0 → 25.4 |
| vector plain | 313.9 → 253.8s | -19.1% | 246.9 → 253.7s | 1.27 → 1.00 | 140.3s | 16.5 → 16.9 |
| vector ASan | 643.4 → 549.3s | -14.6% | 562.4 → 548.4s | 1.14 → 1.00 | 255.6s | 37.5 → 36.6 |
| vector TSan | 1286.5 → 909.3s | -29.3% | 988.4 → 908.4s | 1.30 → 1.00 | 499.5s | 65.9 → 60.6 |
| vector MSan | 926.0 → 761.1s | -17.8% | 794.8 → 761.0s | 1.17 → 1.00 | 299.1s | 53.0 → 50.7 |

The five suite schedules sum to approximately 198.85 → 190.20 runner-minutes
(-4.35%); individual table cells are rounded. Vector plain consumes slightly
more runner time under the balanced deal. Reducing the longest shard is the
main value of this update.

**Vector shard-one caveat:** `costs collect` deliberately omits its
`first-shard` adjustment for vector draws. MSan shard one ran a separate
`main.c` compile for 101s after its suite in the newest run. The new balanced
761s suite would therefore finish closer to 862s on that builder, before other
setup/post-suite work. The 17.8% MSan suite reduction is not a claim of a 17.8%
reduction in total MSan time or whole-candidate latency. A tested queue
candidate is still needed for actual after evidence.

## Held-out run check

For each row below, the new deal is generated from the **other two runs**.
The held-out run's measured costs then score both the old and newly trained
deals. This checks sensitivity to the particular three-run sample; it is still
a simulation, not an execution of the new deal. Full schedules are in the
`holdout-RUN` directories.

| Held-out run | Row | Longest, old → new | Suite runner-minutes, old → new |
| --- | --- | ---: | ---: |
| 45779319802 | native plain | 445.4 → 322.7s | 21.9 → 21.2 |
| 45779319802 | vector plain | 280.7 → 245.8s | 15.0 → 15.7 |
| 45779319802 | vector ASan | 622.6 → 496.0s | 31.3 → 31.5 |
| 45779319802 | vector TSan | 1009.5 → 837.8s | 55.6 → 53.5 |
| 45779319802 | vector MSan | 917.3 → 786.0s | 50.9 → 50.1 |
| 45779273785 | native plain | 469.5 → 357.0s | 24.0 → 23.6 |
| 45779273785 | vector plain | 268.0 → 216.5s | 13.5 → 14.1 |
| 45779273785 | vector ASan | 613.0 → 496.4s | 31.9 → 32.2 |
| 45779273785 | vector TSan | 840.8 → 745.0s | 50.5 → 47.6 |
| 45779273785 | vector MSan | 905.4 → 684.6s | 44.5 → 43.4 |
| 45778920528 | native plain | 464.9 → 366.7s | 23.4 → 23.9 |
| 45778920528 | vector plain | 307.2 → 251.3s | 16.0 → 16.3 |
| 45778920528 | vector ASan | 569.8 → 506.7s | 32.8 → 32.5 |
| 45778920528 | vector TSan | 1057.5 → 795.7s | 54.1 → 49.7 |
| 45778920528 | vector MSan | 916.9 → 737.2s | 46.6 → 46.1 |

All fifteen held-out row schedules have a shorter longest shard, by 11.1% to
27.5%. Runner-minutes do not improve in every row, as the table shows.

## Reproduction and checks

Run `bash reproduce.sh /absolute/path/to/buster /absolute/path/to/output`.
The script uses the source at `8e4d32879e17b7d9548cad54257a2f8461328366` from
that checkout's Git object database, verifies the log hashes, rebuilds `costs`,
collects the five active tables, reproduces the old/new and held-out schedules,
and checks all tables. It writes only to the given output directory. The
archived logs may be unpacked automatically from `logs.tar.gz`.

Validation performed: `costs check` passed; `costs --self-test --root .`
passed all 161 checks; `git diff --check` passed. Only the five active tables
were copied to the compiler repository. Retired native sanitizer tables were
left unchanged. No inventory heading, command, shard, CPU grant or detector
was removed or added.

`runs.json` and `jobs-RUN.json` retain selected API metadata fields. `logs/`
contains the exact decoded suite logs returned by the GitHub connector; the
archive preserves the same bytes. `baseline/` holds the old active tables,
`recollected/` the newly generated tables, and each `*-deal.txt` the complete
predicted schedule. This record makes no claim that #2658's original
16.4-minute whole-candidate target has been reached.
