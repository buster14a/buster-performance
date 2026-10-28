# #674 target qualification status

The final decision is **retain the sparse candidate for its eight-worker
full-compile improvement; single-worker improvement remains inconclusive**.
`README.md` is the final report. The dated work below preserves the methodology
and its corrections; earlier pending statements are historical.
No PR, push, issue update or machine-setting change was made by this agent.

- Source baseline `bc1b486150850fe00bad1361a19f57d67706bb3b`, binary SHA-256
  `d4420d3786771dc3f9b851b6931bc8d8cdb7d01959b3213f4927821847fe871d`.
- Source candidate `7274e1bc47dfa60c80a584bc01f270af5a7d420b`, binary SHA-256
  `863bcbdce9a4499433b770258187aa38a72ba96f15f4c5bb45ec0d65270f3f7c`.
- Remote root: `~/buster-fast-bench/unclaimed-perf-20261028` on benchpress.
- Existing original `base` and `issue-674` trees/binaries remain unchanged.
- Fresh `674-qa-base` and `674-qa-head` builds captured objects into
  `674-qa-objects-base` and `674-qa-objects-head`. Their plain compiler binaries
  match the respective frozen binaries exactly. Both 41-unit builds pass.

Completed target results:

| Control | 1 physical worker | 8 physical workers |
| --- | --- | --- |
| Parent initial 11-pair A/B | 66.136757 -> 66.459016 MB/s (+0.487%) | 191.038228 -> 193.338399 (+1.204%) |
| Independent 31-pair A/B | 66.031504 -> 66.293179 (+0.396%), positive 24/31 | 190.812148 -> 193.750498 (+1.540%), positive 28/31 |
| Identical-base 31-pair A/A | 66.103766 / 66.123070 (+0.029% role bias) | 191.729485 / 191.144823 (-0.305% role bias) |

All processes succeed. Retain all samples: original 8-worker A/B has 96/93
major faults; repeat 205/226; A/A 218/226. A repeat pair has a +15.179% ratio
outlier; nothing was filtered. Ratios are throughput, not wall-time reductions.

- Exact native candidate `test-checker --seed 674`: **398,971 checks, 0 failures**.
- Frozen SQLite `--verify -c` succeeds in both scalar/vector paths.
- All **5,258** original, repeated, A/A and verified objects have SHA-256
  `cb578161715c2ecf83659069957077739447d8eccb7be54953faeb30990d9755`.
  Explicit representative baseline/head/verified byte comparisons pass too.
- Target source-file hashes match the local candidate. Remote receipts:
  `674-qa-provenance.txt`, `674-qa-all-object-sha256.txt`, `674-qa-byte-compare.log`,
  `674-qa-checker.log`, `674-qa-aa{1,8}.log`, `674-qa-repeat{1,8}.log`.

Placement methodology is in `method/section-control/`:

- `capture-build.sh` is the original build script with one post-link object-copy
  hook; its exact diff is retained.
- `section_variants.c` uses `ld -r` to prefix the actual `.text.buster_checker`
  section with 0/688/1376/2064/2752/3440 bytes. `objcopy` restores its original
  4096-byte section alignment after GNU ld's `SUBALIGN(16)`. Original code bytes,
  symbol offsets and relocations are preserved apart from the prefix.
- A local six-variant executable smoke passes; actual symbol shifts and section
  alignment are checked. Ordinary `.text` padding would miss the hot section.
- `placement_samples.c` creates two fresh equal-length-path binary copies per
  placement/role. Three roles are baseline, head, and baseline again. Each run
  verifies copies, runs predeclared `--verify` warmups and compares every warmup
  object with the frozen reference before timing its 36 cohorts. Three rotated
  runs are planned for each worker count; each 8-worker hold is about 65 seconds.
- Controller smoke: three runs each produce 36 timed cohorts and 36 successful
  verified object checks; all binary argument lengths are identical. A bad
  reference is rejected before any timed cohort.

The corrected helpers and all twelve native variants have built. Every actual
checker section is aligned to 4096 bytes. `raw/674-qa-symbol-validation.txt`
requires all 48 hot-symbol checks (four symbols, six placements, two builds)
to have the exact requested delta and unchanged function size; all pass.
The relocated head's zero-prefix binary also passes the complete native
checker, **398,971 checks, zero failures** (`674-qa-relocated-checker.log`).

The initial global-rotation matrix pass completed at each worker count:

- Remote `674-qa-placement-j1-r0.log`, results `results/674-qa-placement-j1/r000`
  (exec session 82729).
- Remote `674-qa-placement-j8-r0.log`, results `results/674-qa-placement-j8/r000`
  (exec session 4557).

Those logs are **exploratory, excluded from qualification**: global rotation
preserves role adjacency and does not control predecessor work. The old helper
sources are retained with `_rotation` suffixes.

The corrected controller uses a nine-edge cyclic role sequence containing all
3x3 predecessor/current role pairs. A full untimed primer provides its first
edge. Each role pair occurs four times per run. Stratified shuffled case lists
also require every role/placement/copy to follow each predecessor once across
the three passes. The reader validates these exact counts as well as complete
rows, consistent cohort jobs/tasks/source, finite rates and verified objects.
The corrected positive mock passes all balance checks; bad reference and mixed
job-count controls fail before acceptance.

The corrected controller built successfully. An independent read-only review
confirmed the cycle, stratification and reader balance gates. Corrected source
provenance is staged under `674-qa-method/balanced`. Corrected pass 0 is queued
for both worker counts, with new result prefixes `results/674-qa-balanced-j1`
and `results/674-qa-balanced-j8`; use passes 1 and 2 after those succeed.
Preserve the baseline-again floor and unpaired ranges over placements/copies.
The subsequent three-pass balanced series completed successfully at each
worker count. The coordinator reported a brief out-of-lock compression during
the last six single-worker pass-1 cohorts. That entire pass remains retained,
with timestamp bounds and annotation, and a full clean replacement completed.
The corrected final one-worker triple uses that explicit replacement.

Final pooled throughput:

- One worker: 66.021349 -> 66.438842 MB/s (+0.6324%); baseline again +0.1445%.
  Unpaired placement range -0.1970% to +1.1148%; copy range -0.3932% to
  +1.8824%. The positive median does not resolve the layout/copy floor.
- Eight workers: 190.957899 -> 194.163131 MB/s (+1.6785%); baseline again
  +0.2828%. Unpaired placement range +1.1591% to +2.1581%; copy range
  +0.3791% to +4.0679%. All 36 cohorts per role remain included, including
  major faults 135/170/171. This survives the observed controls for the frozen
  pinned full-compile recipe.

Four earlier possible compression windows reported by the #673 and #658
owners overlap none of the accepted #674 series: 11:46:01–11:46:10,
11:51:35–11:51:44, 12:06:56–12:07:12 and 12:08:16–12:08:24 UTC.
Original A/B/A/A finish by 11:09:11 UTC;
balanced runs begin after 12:17. Original exploratory placement runs around
11:57–11:58 remain excluded for their scheduling flaw. Collection of final
object hashes and raw metadata used the shared lock and completed. All 4,396
balanced-series objects match the original object hash; the local archive's
SHA matches the target receipt. `native/` contains the metadata tree without
corpus symlinks or generated objects. Final reports and method sources are
ready for the coordinator's evidence integration.
