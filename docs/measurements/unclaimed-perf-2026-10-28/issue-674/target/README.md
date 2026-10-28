# #674 native Ryzen 7 9700X qualification

Retain the sparse implementation for its measured **eight-worker full-compile
improvement**. The single-worker improvement remains unresolved by the observed
placement/copy floor. This conclusion applies to the frozen sources below and
the pinned SQLite recipe, including both the reader producing summaries and
the graph consuming them. Later merged sources need their own qualification.

## Frozen source and environment

| Role | Source commit | Native compiler SHA-256 |
| --- | --- | --- |
| baseline | `bc1b486150850fe00bad1361a19f57d67706bb3b` | `d4420d3786771dc3f9b851b6931bc8d8cdb7d01959b3213f4927821847fe871d` |
| sparse candidate | `7274e1bc47dfa60c80a584bc01f270af5a7d420b` | `863bcbdce9a4499433b770258187aa38a72ba96f15f4c5bb45ec0d65270f3f7c` |

The first implementation is `05b82bfd94234f5d0f8439a3041799007e56fddc`.
The sparse follow-up above changes only counter updates to avoid writing the
entire counter vector for ordinary nodes. All native results here use sparse.

Target: Ryzen 7 9700X, 64 GiB RAM, native Clang 23.1.1. All builds, tests,
timed runs, object hashing and remote archival use the existing shared
`exclusive.sh` wrapper. Machine settings are unchanged. The original frozen
compiler binaries remain unchanged; fresh captured-object builds reproduce
their hashes exactly. See `674-qa-provenance.txt` for tools, input and source
hashes, plus `674-qa-final-method-sha256.txt` for final helper provenance.

The pinned `sqlite3.c` has SHA-256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`;
predefines have SHA-256
`a39036d8215977b5a205f7fd3c4e7dfe6576b58eaa76a7bb0b0e214a164e8d33`.
The flags and replay method are in
`method/section-control/README.md`. Every task emits a real native object with
`--lanes 1 -c`. One physical worker runs four tasks on CPU 2; eight physical
workers run 32 tasks across CPUs 2,0,1,3,4,5,6,7. Cohort wall time includes
fresh compiler process startup, all stages, object writing and waiting.

## Correctness

- Exact native candidate: **398,971 checker checks, zero failures**.
- Relocated zero-prefix native candidate: **398,971 checks, zero failures**.
- Frozen SQLite compiles successfully with `--verify` in scalar and vector
  paths. This independently validates the published reader summary and purity
  marks against the fallback graph validator.
- All 5,258 original frozen-binary, repeated, A/A and explicit verification
  objects have SHA-256
  `cb578161715c2ecf83659069957077739447d8eccb7be54953faeb30990d9755`.
  Explicit representative baseline/head/scalar/vector byte comparisons pass.
  The final balanced-series manifest adds **4,396** matching objects, covering
  every warmup, primer and timed output, including the annotated original
  pass. These two manifests cover **9,654** outputs in total.

Full checker, verification, byte-comparison and object manifests are retained
as raw receipts. Local adapter/sanitizer and source fixture evidence belongs
in the parent evidence directory; native correctness is independently clean.

## Actual placement, fresh-copy and predecessor controls

The checker is in a page-aligned `.text.buster_checker` section. The controls
move that actual section by 0, 688, 1376, 2064, 2752 and 3440 bytes, preserving
4096-byte section alignment. All **48** checks of four hot symbols across six
placements and two builds require exact address deltas and unchanged sizes;
all pass. Ordinary `.text` padding would not establish this.

Each of three passes uses two fresh equal-length-path copies per placement
and role. Roles are baseline, candidate, and baseline again. The controller
verifies every copy, runs 36 predeclared `--verify` warmups, compares their
objects, and uses a full-size untimed primer. Every predecessor/current role
pair occurs four times per pass; each role/placement/copy follows every
predecessor once over the three passes. An independent reader checks actual
emitted order, complete unique rows, cohort sizes, finite metrics and all
reported failures. Method source, negative controls and explicit order
receipts are retained.

The final results use **36 timed cohorts per role per worker count**, pooled
over all three passes. Placement comparisons are unpaired across all six
placement medians; copy comparisons are unpaired across all twelve copy
medians. They do not assume equal offsets represent the same layout.

| Final balanced control | 1 worker / 4 tasks | 8 workers / 32 tasks |
| --- | --- | --- |
| Baseline median MB/s | 66.021349 | 190.957899 |
| Candidate median MB/s | 66.438842 | 194.163131 |
| Candidate pooled throughput change | **+0.6324%** | **+1.6785%** |
| Baseline-again pooled change | +0.1445% | +0.2828% |
| Candidate unpaired placement range | -0.1970% to +1.1148% | **+1.1591% to +2.1581%** |
| Candidate unpaired copy range | -0.3932% to +1.8824% | **+0.3791% to +4.0679%** |
| Major faults, baseline / candidate / baseline again | 0 / 0 / 0 | 135 / 170 / 171 |

The eight-worker gain survives the observed placement and fresh-copy
comparisons, with a smaller baseline-again median difference. The one-worker
ranges cross zero, so its positive pooled median does not establish a
layout-independent improvement. These are whole-compile wall-throughput
results. Hardware-counter attribution remains unmeasured in this protocol.
All successful samples, page faults and outliers are retained.

## Repeatability and disclosed corrections

The original 11-pair frozen-binary A/B measured +0.487% at one worker and
+1.204% at eight. Independent 31-pair repeats measured +0.396% and +1.540%;
31-pair identical-base A/A measured +0.029% and -0.305% role differences.
Those fixed binary paths are supportive repeatability screens; the balanced
placement/copy series above determines the scoped conclusion.

Two initial global-rotation placement passes are retained as exploratory
and excluded from qualification. Rotation preserved most role adjacency.
The corrected protocol explicitly balances predecessor work instead.

The coordinator reported external compression outside the shared lock from
12:27:37.850 to 12:27:40.604 UTC. This overlaps the last six single-worker
pass-1 cohorts. Their full original log and original three-pass summary
remain retained (+0.7055% pooled candidate median). A complete clean pass-1
replacement preserves the exact case/order balance; the final one-worker
table substitutes that explicitly designated pass. The affected rows and
original file-lifetime receipts are in `raw/674-qa-packaging-overlap.md`.

Four additional possible interference windows, 11:46:01–11:46:10,
11:51:35–11:51:44, 12:06:56–12:07:12 and 12:08:16–12:08:24 UTC, overlap none
of the accepted #674 timings: frozen A/B/A/A finish by 11:09:11, and the
balanced series begins after 12:17.
The excluded exploratory series ran around 11:57–11:58. Raw log and cohort
file timestamps are retained to bound these windows.

## Limits and delivery

This supports retaining #674 for the pinned eight-worker full compile.
It does not establish a resolved single-worker gain, a rate for other inputs,
a memory-traffic reduction, or performance of later integration heads.
No pull request, push, GitHub comment or machine-setting change was made.
The evidence includes original C measurement helpers and raw metadata; the
corpus symlink and bulk generated objects are omitted from the archive.
`native/` preserves the target-relative raw tree; `raw/` adds final local
reader summaries and the interference audit. All 11,022 child records,
including the excluded exploratory series, have zero status and the expected
object size; every captured compiler stderr is empty.
The original native metadata archive is `674-qa-evidence.tar.gz`, 453,127
bytes, SHA-256
`20eb43b5008a7cac3ba8a2d6e5f27593f737427190e4a7bcbc5db97fd4204ba4`.
