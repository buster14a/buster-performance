# Unclaimed performance work, 2026-10-28

This archive preserves revision-scoped measurements, correctness receipts and
rejected experiments published in [buster-performance PR #64](https://github.com/buster14a/buster-performance/pull/64).
Individual reports remain byte-identical to their collected local records,
including their original statements about publication status. Supporting frozen
source revisions are exposed through the compiler repository's
`codex/qualification-20261028-*` and `codex/experiment-20261028-*` refs.
Full raw artifacts remain in the original local workspace; the collection
manifests identify every copied and omitted file.

## Frozen individual qualification

The following records compare baseline
`bc1b486150850fe00bad1361a19f57d67706bb3b` with the exact individual source
revision named in each report. They do not measure a later main branch or the
combined effect of the fixes. Separate speedups must not be multiplied.

| Issue | Native qualification record | Scope and limits |
| --- | --- | --- |
| 590 | [Record](issue-590/target/README.md) | Empty/data-only backend setup; body-bearing controls stable, tcc remains faster on tiny files. |
| 636 | [Record](issue-636/target/README.md) | Buffered diagnostic bytes, syscall counts, file/pipe process timings and silent controls. |
| 641 | [Record](issue-641/target/README.md) | Retained sparse/count/key slice only; larger compact selection experiment rejected. |
| 649 | [Record](issue-649/target/README.md) | Exact printer output, printing and whole `-E -P`; not ordinary `-c` throughput. |
| 652 | [Record](issue-652/target/README.md) | Terminal cleanup only; isolated A/A/reversal controls supersede mixed-input conditioning bias. |
| 657 | [Record](issue-657/target/README.md) | Bounded region lookup with dense independent oracle and deep scaling. |
| 658 | [Record](issue-658/target/RESULTS.md) | Eligible integer literal tables; general tables and token storage remain open. |
| 664 | [Record](issue-664/target/README.md) | Bounded stable home selection; scalar twin cost is retained explicitly. |
| 674 | [Record](issue-674/target/README.md) | Eight-worker throughput survives placement/copy/order controls; one-worker gain unresolved. |

Later scoped records use different revisions and must be read independently:

- [628 parser storage](issue-628/ARCHIVE-SCOPE.md): current-main-based parser
  memory reduction; timing remains within controls. Unqualified output-column
  experiments are excluded from this collection's accepted scope.
- [647 streaming affinity](issue-647/target-README.md): correct physical-core
  configuration and honest skipped rows; not a compiler throughput gain.
- [673 worker ownership](issue-673-spawn/REPORT.md): frozen GNU make worker
  ownership implementation and measurements, retaining the uneven-tail latency
  cost. The return-capacity defect found during publication review is tracked
  separately in [compiler PR #695](https://github.com/buster14a/buster/pull/695);
  these historical measurements do not establish final protocol acceptance.
- [653 negative result](issue-653/README.md): both admission policies failed
  ordinary-input process controls; all production changes are removed.
- [Pristine 678 controls](pr-678-controls/README.md) and
  [scalar operation audit](pr-678-audit/ARCHIVE-SCOPE.md) separate clean-PR
  failures from interactions with the retained performance changes.

The host is Ryzen 7 9700X / Linux 6.18.50-2-lts, ordinary Clang 23.1.1 native
release builds with `BUSTER_DEBUG_INFO=0`. Every target build, test and timed
run uses the shared `exclusive.sh` lock; no machine settings were changed.
Reports retain exact executable/input/source identities, affinities, commands,
repetitions, statuses and resource metrics. Captured faults and adverse results
are not trimmed.

## Frozen integration and compatibility records

The independent current-main integration is frozen at
`b8cd163ce33bb8042e42fd9fea7c675ae13fa487`, incorporating main
`4165454ebadf9b96c2b40ab99c55f4c0b28ba975` and its #682 test-build change.
The source contract adaptations preserve #640's optional parser traversal,
compact graph leaves, new warning interval producers, string IDs, symbolic
zero data and automatic initializer pools.

This is an intermediate branch that still contains the subsequently rejected
653 experiment. Its [screen and metadata](current-main-b8/README.md) are
retained, not transferred to the next batch. The latter removes 653 and adds
the qualified 628 parser and 647 configuration changes.

On the target, all 41 units build in 28.9 seconds; nine correctness groups
pass in 45.0 seconds, including checker 488,765/zero, deferred 1,147/zero,
Tier 0 95,965/zero and all 220 native cross-checked corpus programs. All 672
tracked source hashes match the staged source tree. These functional results
do not transfer the individual speedups to the new main.

The [early a11 compatibility stage](compat-678-a11/ARCHIVE-SCOPE.md) is frozen
at `06150c52db27a31fe0106acbe00c1e34ae8249d0`. Its original location-limit
fixture failure and focused test correction remain separate from later proof.
The older [pristine PR controls](pr-678-controls/ARCHIVE-SCOPE.md) and
[scalar-operation audit](pr-678-audit/ARCHIVE-SCOPE.md) retain their negative
results at their own exact PR revisions.

The authoritative later [full private union](compat-678-current/README.md) is
`d74d87366e2f7458bc7997b2314d94b0f5cdf96b`: main `321f5976`, qualified next-main
`d3c1d45d`, nullable ASM `dc15a18e` and pinned #678 `a11d8065`. Rejected #653 is
absent. Both 41-unit builds and all 26 corrected native/generic suite commands
pass. Native/generic byte comparisons and true qemu64 compilation, linking and
runtime controls also pass. Initial incorrect invocations and removed-table
syntax attempts are retained and excluded from those passing counts. The
[scope record](compat-678-current/ARCHIVE-SCOPE.md) separates the older unchanged
worker-budget lifecycle proof from actual new-head execution.

These are bounded correctness results for that frozen private union. Later
source PR heads, hosted CI and merges require their own qualification; no individual
historical speedup or combined throughput gain is transferred to them.

Publication review also reproduced a GNU make token-return defect in the
frozen clean-launch implementation and the original #695 publication head:
a full pipe can reject return writes even after credits have been borrowed,
and the old guardian can exit without restoring the exact held bytes. At this
archive's final review, a lossless correction and fresh source qualification
are pending in [#695](https://github.com/buster14a/buster/pull/695). The archived
673 reports and timings remain unchanged observations of their named source;
their passing fixtures and frozen-union results do not override this finding.

## Archival method and provenance

Original project implementation, fixtures and reproduction helpers use
Apache-2.0 WITH LLVM-exception. Existing source notices are retained. Clang,
libc, binutils, tcc and pinned source corpora are external runtime/test inputs;
they are not imported implementations. Each individual report names input and
toolchain provenance and separates external comparisons from byte-exact ones.

`method/curate_evidence.py` copies UTF-8 text evidence up to 5 MiB per file.
Each issue's `COLLECTION.tsv` records every original file's path, byte count,
SHA-256 and disposition. Binaries, objects, large generated inputs and complete
compressed raw archives remain in the local workspace; reports name their
archive identities. Generators and exact commands reproduce omitted payloads.
The full raw artifacts remain in the original local workspace separately.
Publication review independently verified every retained raw file against its
collection digest; this is local retention, not a remote binary archive.

The original `cohort.c` and `samples.c` in `method/` record each process and
real output. Balanced placement/copy controllers and independent schedule
verification are retained in issue 674's record. Simple cyclic rotation of
mixed workloads can confound predecessor workload state; failed controls and
their isolated/balanced replacements are retained in 652, 673 and 674.

Incidental target packaging outside the lock was discovered during provenance
audit. Every known interval was distributed to all campaign owners; original
and uncertain records remain annotated. Where acceptance depended on an
overlap, a complete clean balanced pass was added. The issue reports retain
the interval audit and replacement identities. All subsequent target packaging
also uses the shared lock.
