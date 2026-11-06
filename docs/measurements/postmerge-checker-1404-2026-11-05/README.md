# Post-merge checker work on deferred lanes (#1404)

Evidence for [buster#1404](https://github.com/buster14a/buster/issues/1404) and
[buster#1440](https://github.com/buster14a/buster/pull/1440). Controls, binding
answers, constant contexts and independent expression/graph construction run
on the deferred reader's lanes. The caller publishes graph parts and warnings
in source order; shared preparation and exceptional actions remain ordered.
The driver retains its lane lease through these rounds. Any post-merge failure
retries the complete source-order reader.

## Sources and environment

| Source | Revision |
| --- | --- |
| Baseline, before this work | [`e7d3fc79e7528f987280b5b12b0e72fb65b8351a`](https://github.com/buster14a/buster/commit/e7d3fc79e7528f987280b5b12b0e72fb65b8351a) |
| Measured implementation | [`5abff5412b8ebff26c92ea0a85410b5ae9b8af31`](https://github.com/buster14a/buster/commit/5abff5412b8ebff26c92ea0a85410b5ae9b8af31) |

The implementation includes both review fixes: the spare-worker lease is
returned immediately after the final parallel round joins, before ordered
graph publication and serial finishing, and a delayed-caller test checks the
identities of workers that completed expression parts. The baseline is the
landed main revision shared by this branch. Both source trees were clean.

Every build, test and measurement ran on the Ryzen 7 9700X (`benchpress`) under
its shared `exclusive.sh` lock. Measurements use CPUs 0–7, one thread per
physical core. The default driver uses eight lanes there. Linux 6.18.50-2-lts,
Clang 23.1.1, perf 7.2.9-1 and GNU Make 4.4.1 were used. CPU 2's governor was
`performance`, the other seven `powersave`, as recorded in
[`raw/identity.txt`](raw/identity.txt). Native builds use
`BUSTER_HOST_ARCH=znver5`, the normal static host link and default line
information; the separate sanitizer build uses `BUSTER_SANITIZER=thread` at
the default `-O3`. Build logs and executable SHA-256s are retained in `raw/`.

The frozen SQLite source has SHA-256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`,
from corpus `preprocessor-391e729af658`. Single-process compiles use the same
options as #151's record: `-c`, `SQLITE_OMIT_LOAD_EXTENSION`,
`SQLITE_THREADSAFE=0`, `SQLITE_ENABLE_MEMSYS5`, `SQLITE_ENABLE_RTREE` and its
include directory, with the host's system headers. The concurrent #673 control
uses its frozen GNU17 predefines and header tree. Corpus comparisons generate
their predefines from the selected Clang oracle. These are separate
configurations; their token counts should not be compared as one workload.
[`raw/provenance.txt`](raw/provenance.txt) pins the corpus manifest, predefines,
lock script, tool versions and c-testsuite revision.

## Method

[`scripts/run.sh`](scripts/run.sh) reproduces the campaign from a directory with
`base/`, `head/`, `scripts/` and a `corpus` symlink to the frozen corpus.
`run.sh` performs the three initial controls and invokes
[`scripts/finish.sh`](scripts/finish.sh) for the remaining comparisons, profiles
and balanced concurrent cases. Executable hashes are captured before and
after the campaign. Functional acceptance uses
[`scripts/acceptance.sh`](scripts/acceptance.sh) and the repository's CPU-budgeted `parallel --jobs 8` runner under one lock per acceptance run.
The lane and deferred-corpus groups declare eight CPUs; the two full scalar
suites declare two each and may run together.

- Same-binary source/deferred comparisons: 21 measured runs and two warmups
  per case, in rotated order, by default, with and without `-w`.
- Baseline/implementation controls: 11 runs and two warmups per fresh copy,
  three copies of each binary, for each mode. These are one code placement
  per build; copies do not establish robustness across different internal
  function placements.
- Explicit lanes 2–8: fourteen source/deferred cases in one `time-runs`
  invocation, fourteen measured runs and two warmups each. Each case occupies
  each position once. Whole-process wall time and user cycles are retained.
- Representative stage reports and `benchmark-checker-deferred`, 24 passes on `--cpus 2,0,1,3,4,5,6,7` with eight lanes. Summed
  `expressions.work.*` counters are lane work, rather than elapsed time;
  `expressions` and the planning/round/ordered/publication rows are elapsed.
- Concurrent GNU make builds: the #673 harness with source/deferred mode
  included in the balanced predecessor pattern, as described below.

Each measurement or build invocation takes the hardware lock separately. Compiled objects are
compared outside timing, hashed, then removed. `wait4` peaks include inherited
pre-exec memory and waited descendants; they are reported as rusage peaks,
rather than executable-only RSS. The source/deferred comparison in one binary
avoids code-placement differences between modes. Baseline controls quantify
the incremental implementation effect at the recorded placements.

## Whole-process results

SQLite `-c -w`, default eight lanes, same binary, 21 runs per case:

| | Source order | Deferred |
| --- | ---: | ---: |
| Median wall | 111.064 ms | 108.427 ms (−2.37%) |
| Median user cycles | 633.504 M | 825.271 M (+30.27%) |
| Median minor faults | 8,524 | 25,132 |
| Median wait4 peak | 324,916 KiB | 386,252 KiB |

The incremental change with deferred checking enabled, baseline versus the
implementation, 33 runs per build across three copies:

| | Baseline | Implementation | Change |
| --- | ---: | ---: | ---: |
| Median wall | 109.068 ms | 107.680 ms | −1.27% |
| Median user cycles | 715.469 M | 828.138 M | +15.75% |

The wall change across copies is −1.44% to −0.92%; user cycles +14.67% to
+16.48%. With deferred checking disabled, the build control is −0.13% wall
(−0.21% to +0.00% over copies) and −0.15% user cycles (−0.37% to +0.08%).
This is a modest latency improvement with an appreciable additional CPU cost.
The same-binary source/deferred comparison is the default-policy comparison;
the cross-build comparison measures the incremental implementation effect.

With warnings enabled, the same-binary medians are 162.025 → 159.371 ms
(−1.64%) and 906.461 → 1,102.305 M user cycles (+21.61%). The corresponding
baseline/implementation control with deferred mode enabled is 160.386 →
159.044 ms (−0.84%, −1.11% to −0.17% over copies), and 988.392 →
1,099.588 M cycles (+11.25%, +11.01% to +11.72%). Source order's warning-enabled
control changes −0.16% wall and −0.12% cycles, with copy ranges spanning zero.

### Explicit lane counts

Same binary, `-w`, fourteen measured runs per case:

| Lanes | Source wall (ms) | Deferred wall (ms) | Wall change | Source user cycles (M) | Deferred user cycles (M) | Cycle change |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 2 | 115.390 | 120.633 | +4.54% | 587.199 | 679.738 | +15.76% |
| 3 | 113.218 | 113.689 | +0.42% | 592.549 | 700.558 | +18.23% |
| 4 | 112.124 | 110.579 | −1.38% | 599.112 | 722.369 | +20.57% |
| 5 | 112.047 | 109.292 | −2.46% | 604.975 | 745.062 | +23.16% |
| 6 | 111.220 | 108.810 | −2.17% | 611.171 | 771.659 | +26.26% |
| 7 | 110.884 | 108.275 | −2.35% | 623.178 | 795.901 | +27.72% |
| 8 | 111.260 | 108.052 | −2.88% | 633.468 | 825.445 | +30.31% |

The separate lane sweep has its own eight-lane pair; it is not pooled with
the 21-run default pair. Two lanes regress and three are essentially unchanged.
More lanes buy a few milliseconds at increasing CPU cost.

### Where the work went

The representative stage reports are single samples, used to describe the
work split rather than estimate a speedup. Source order's `check-input` is
58.750 ms and deferred mode's is 54.249 ms. Expression elapsed time is
13.808 → 12.608 ms. The deferred expression planner takes 4.012 ms, the lane
round 5.304 ms, ordered parts 1.108 ms and publication 1.795 ms. All eight
workers complete expression parts; 669,809 of 716,136 classified token slots
(93.5%) belong to eligible parallel parts, across 143 parts, with no retry.
This token share is not a share of elapsed time. Shared preparation,
publication and the remaining ordered actions limit the wall-time benefit.

The lane work counters sum 6.254 ms of preparation, 32.253 ms of actions and
3.559 ms of visits; they may overlap in wall time. They must not be added to
or ranked as elapsed stage spans. The 24-pass reader control reports
77.31 ns/token for the original source-order reader and 67.22 ns/token for
the eight-lane deferred reader. Its parser and driver setup are outside that
reader-only comparison. This invocation uses fresh deferred state per reading,
with caller arenas taken back and reused; it does not request `--cold`'s fresh
caller mappings. The whole-process rows above determine the default.

## Concurrent policy control

[`scripts/policy_balanced.c`](scripts/policy_balanced.c),
[`scripts/usage_record.c`](scripts/usage_record.c),
[`scripts/compile-budget.mk`](scripts/compile-budget.mk) and
[`scripts/tiny.c`](scripts/tiny.c) derive from
[`unclaimed-perf-2026-10-28/issue-673-spawn`](../unclaimed-perf-2026-10-28/issue-673-spawn)
at performance commit `1118f3cb6bee774b0422ced77b643b98957e996d`.
The original file hashes are in
[`raw/harness-provenance.sha256`](raw/harness-provenance.sha256).

The first concurrent primer rejected an accidental `--no-default-config`
option, which the semantic driver does not accept. It produced no valid
measurement. The rejected argv and errors are retained in
`raw/rejected-primer.tar.gz`; the option was removed, the harness rebuilt
under the lock, and all three concurrent workloads then started afresh.
[`scripts/resume-cohorts.sh`](scripts/resume-cohorts.sh) records that continuation.
No production binary or completed single-process sample changed. The earlier
`qualify-native.sh` and `qualify-tsan.sh` launchers are retained because the
identity snapshots hashed them; the reported final acceptance uses
`acceptance.sh` and its retained inventories.

Each workload runs a full-size primer and four cyclic 36-edge sequences. The
six roles are source order with inherited jobserver, one worker and free
lanes, then deferred mode with those three policies. Every predecessor/current
role pair occurs four times, giving 24 measured cases per mode/policy. The
primer is excluded. The three workloads are eight SQLite units, eight tiny
units, and two SQLite units plus six tiny units. Every build has eight make
recipes and `--lanes=8`; worker limits are eight except the one-worker control.
Free-lane recipes unset `MAKEFLAGS`, as #673's harness does.

Every case preserves its argv, `perf stat` user cycles/instructions, `wait4`
resources and each compiler's worker-budget receipt. Every object is compared
with the primer's corresponding object, across modes as well as policies.
The harness refuses a failed process, a differing object or an unbalanced
predecessor table. The only hardware events are `cycles:u` and
`instructions:u`; software events are retained alongside them. The reported
cohort wall span and cycles include make, the resource adapter and the eight
compiler processes. Per-unit rusage peaks are not summed into a cohort RSS.

| Workload | Policy | Source wall (ms) | Deferred wall (ms) | Wall change | Source user cycles (G) | Deferred user cycles (G) |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| Eight SQLite | Jobserver | 362.420 | 360.658 | −0.49% | 11.867 | 11.913 |
| Eight SQLite | Cap one | 362.195 | 362.194 | 0.00% | 11.899 | 11.897 |
| Eight SQLite | Free eight | 378.337 | 429.435 | +13.51% | 12.022 | 13.247 |
| Eight tiny | Jobserver | 4.799 | 4.980 | +3.77% | 0.0308 | 0.0306 |
| Eight tiny | Cap one | 4.703 | 4.707 | +0.09% | 0.0286 | 0.0287 |
| Eight tiny | Free eight | 5.025 | 5.033 | +0.16% | 0.0324 | 0.0326 |
| Two SQLite + six tiny | Jobserver | 188.887 | 191.256 | +1.25% | 1.948 | 2.153 |
| Two SQLite + six tiny | Cap one | 196.218 | 195.904 | −0.16% | 1.877 | 1.877 |
| Two SQLite + six tiny | Free eight | 191.514 | 196.695 | +2.71% | 1.975 | 2.376 |

Each row contains 24 samples per mode. The eight-SQLite free-lane regression
has disjoint wall ranges: source 374.145–385.753 ms, deferred
424.273–440.958 ms, with +10.19% user cycles. The mixed jobserver case costs
+10.55% user cycles and free lanes +20.30%. The tiny-unit ranges overlap;
their sub-millisecond median differences do not establish a general change.

All 432 measured cohorts exit zero, with 3,456 valid compiler receipts and
no worker-budget fallback. Receipt checks confirm inherited `jobserver`
mode for both cooperative policies and `none` for the free policy. The tiny
unit's work rule requests one lane even when eight are allowed. Large
jobserver units initially receive one or two lanes and may grow as recipes
finish; the mixed workload has more spare capacity. The cap-one control
keeps source-order reading. These controls show neither a concurrent
throughput gain nor a reason to enable deferred checking by default.

The compressed raw cases and all 3,480 output digests, including the three
primers, are in [`raw/cohorts.tar.gz`](raw/cohorts.tar.gz).
[`raw/cohort-samples.json`](raw/cohort-samples.json) retains every measured
case's counters and receipts;
[`raw/cohort-summary.tsv`](raw/cohort-summary.tsv) retains medians and ranges.
To regenerate the summaries, extract the archive into `raw/` and run
`python3 scripts/summarize.py raw`. The reader independently checks all
36 predecessor/current counts per workload, complete case numbering,
zero statuses, counter coverage and receipt policies.

## Correctness qualification

The measured implementation passed these native checks:

- `test-checker-deferred`: 152 fixtures, 3,399 checks, including a deterministic caller/nonzero-worker assertion, scalar
  relocation, reordered identifiers, poisoned rereads, parallel warning
  metadata, 15/16/17-leaf boundaries and a failure after the expression round.
- `test-check-lanes`: 7,600 checks, including 24 deferred objects/executables
  and 16 failing programs' diagnostic comparisons.
- `test-checker --seed 133`: 764,533 checks.
- `test-checker-corpus --deferred 8`: c-testsuite, SQLite and musl, all with
  zero acceptance, path or deferred-result differences. C-testsuite uses
  `--id-order 153`; SQLite also compares reordered identifiers.

Type constructors and capacity bounds also passed. ThreadSanitizer at `-O3`
passed the same 152 fixtures, 7,600 lane checks, type tests and
all three corpora with no detector reports. C-testsuite has 220 accepted
files; musl has 613 files, 574 accepted by both compilers, with 37 deferred
readings falling back because a body reports an error. These are not resource
failures. The raw per-suite status and accounting are retained under
`raw/acceptance-native/` and `raw/acceptance-tsan/`.

The full native `test-checker-driver` run has 57,352 checks and four failures:
the existing static-chain argument-order comparison at both tiers and through
both paths. The baseline and implementation produce identical outputs in all
four cases; this host's Clang 23.1.1 produces a different order.
[`raw/static-chain-control.log`](raw/static-chain-control.log) reproduces the
existing fixture with both compiler revisions and Clang. The timing report
and `measure-compile` checks in that run passed. This full-driver run is not
reported as a passing suite.

All eight hosted Ubuntu 26.04 correctness shards with Clang 23.1.4 passed
on the measured revision, `5abff541`
([run](https://github.com/buster14a/buster/actions/runs/42089233909)).
The hardware aggregate of that draft is deliberately withheld by repository
policy; that is separate from these manual native and sanitizer checks.

## Default decision

Deferred checking remains opt-in. Moving additional work to lanes preserves
source order's result and reduces isolated latency at higher lane counts,
while increasing user cycles, page faults and rusage peak memory. Two lanes
regress, and concurrent builds show no throughput gain. A small isolated
wall-time gain does not justify spending those cycles in ordinary builds. The existing source-order
default and explicit `--deferred-bodies` / `--no-deferred-bodies` controls are
retained.


## Session provenance

Agent session: `01a1ac7b-ffbc-70b1-9afc-ea82329b14c1` (Codex session ID; no
private share URL is exposed). Model: OpenAI / GPT-6 (Codex).
