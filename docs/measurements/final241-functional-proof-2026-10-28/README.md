# Pinned main-241 functional proof

This record preserves local functional checks for all twelve original publication
slices plus lossless guardian correction `b1b3e490`, composed with compiler main
`241fcb3e9a5a55d8ccc3dfffc7d9d0efd56bdda7` and pinned PR #678
`4b2a8a6f51cf8dee5a5833a8f32138d865d780b8`. It also preserves a separate,
focused #702/#678 compatibility check. It establishes no new performance result
and does not qualify every later public branch head.

| Exact source | Checks and disposition |
| --- | --- |
| `b1b3e490` in bounded `b66527e3` composition | Both 41-unit builds, native/generic lane smoke and 204-check protocol pass. Public `ce8be689` has the identical tree. This is bounded adoption proof, without a broad checker run. |
| `4349d8fd1a8b5be358669b89b08e80e38a68b7bc` | Both 41-unit builds and all nine original suites pass on each host. The separately added ASM suite passes native 1,010/0 but fails generic 1,010/2. Those failures remain negative receipts. |
| Test-only `a07682fe6c31cdf5329a7601d2074f907e407341` | Actual-production focused adapters reproduce the two old generic assertions and pass the corrected predicate and full ASM suite, 1,010/0 per host. The nine broad suites were not rerun and the two whole compilers were not rebuilt at this test-only head. |
| Private `26364e88d61f34b3df635e24d85bed46a3333052` | Separate #702 plus pinned #678 native and actual x86-64 ASan/UBSan adapters pass 214/0 each. This is focused caller/host-header compatibility, without a full compiler build, the all-twelve matrix, or a timing claim. |

The full [batch results](batch241/RESULTS.md) retain the native/generic counters,
source and binary hashes, independent source review, original failure statuses,
one-line test correction and its limited replay scope. In particular, the original
freeze is **not an unconditional all-suite pass**, and the corrected fixture is
**not a newly tested whole public head**. The corrected presence check uses the
actual `parser.options.scalar`, preserving generic #678's selected scalar oracle.

The [lossless-adoption record](695-adoption/ARCHIVE-SCOPE.md) preserves the original
35d EAGAIN/63-credit-loss finding despite its green old CI. Corrected real-reexec
protocol checks pass 204/0; obsolete old-source adapter receipts remain rejected.
The proposal's larger real-make, stress and driver evidence is externally credited,
not relabelled as our reruns. Public ce8 and tested b665 share tree
`c7627b0d586819ee942ada2e1b28cb8c8d9af854`; that equality supports same-tree
functional attribution, not a fresh build or performance measurement.

The [separate #702 record](focused702/ARCHIVE-SCOPE.md) retains both unsuccessful
generic warning-flag invocations and final passing actual-host adapters. Its caller
keeps the explicit scalar policy: zero bulk calls when requested scalar, and one
bounded fill per each of thirteen columns by default, with identical values and
sentinels for empty and three-token units. It does not qualify its four surrounding
program/emission merge resolutions as a full suite. The `4349` batch excludes the
historical #628 bulk-fill experiment; the focused published #702 result does not
silently become part of that batch. #665 remains outside this record.

The coordinator published the original source at
`codex/experiment-20261028-asm-control` and corrected source at
`codex/qualification-20261028-final241`. Public test companion
[#708](https://github.com/buster14a/buster/pull/708) was closed **unmerged** as
superseded at 16:32:36 UTC: a parallel coordinator had already published the same
assertion on #693 at `31413e36b71d4ce8115a53645ada22c9166288b3`. The entire test
blob equals a076/c27, with stable patch ID
`7950ed0494128bf5ce9e9a2d6a7daecd310cc542`. Root verified that equality and
closed the redundant companion; root did not edit #693 or merge #708. External
review's two-host 425/0 checks are credited as external, not our new runs.
None of this asserts a fresh full suite at public 31413e36.

Known CI observations are snapshots: ce8 hosted native/baseline checks passed
while its benchmark was queued; the original #702 native job was queued and
other PRs were refreshing. The original reports retain their earlier in-progress
handoff text byte for byte. #678 later merged upstream, but this record keeps
its pinned 4b2 identity and does not transfer qualification to later heads.
The [publication update](PUBLICATION-UPDATE.md) records the coordinator's verified
#678 merge time and its own passing hosted/Benchpress/aggregation result,
separately from our local functional checks and the superseded #708 companion.

Historical [performance evidence](../unclaimed-perf-2026-10-28/README.md) remains
scoped to its frozen revisions. The new recovery-buffer setup cost is unmeasured;
prior throughput, latency and RSS results are not reassigned to b1 or this matrix.
No new target operation, performance run or new PMU result was performed here.

Each source owner explicitly completed and froze its folder before collection.
The [method](method/ARCHIVE-SCOPE.md) records the exact collector/core version.
Every original regular file has a path/size/SHA256/disposition row in its
`COLLECTION.tsv`. Public copies are unchanged UTF-8 without NUL, at most 5 MiB
each; objects, executables and binary archives remain local. Generated scope
notes and this README are separate interpretation, not edited raw receipts.
