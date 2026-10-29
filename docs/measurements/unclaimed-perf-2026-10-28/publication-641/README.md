# Issue 641 focused publication on main321

Publication branch `codex/pub-641` freezes at
`725fe7fd178b9bcac7819cfc74b395f1bf58e6ad`. Code commit
`9b319dd3b13b036c318bd5ae72763a33b842eccb` ports retained initial641
`7c1f0b09b7e68b28f8281f06580d5c33540d21ae`; final merge only completes
the doc-link ancestry of its focused628 base
`a70bca0106d0ea01bb7a2562f222b23064118cdb`, itself on main321.

Only the retained first641 slice is included: sparse initializer-plan lookup,
producer warning-row counts with explicit prepared flags/dense fallback,
reused prepared static declaration keys, symbol-domain defined-byte
initialization and sparse attribute retention. New main's warning interval
index maintains the count during its existing scalar/masked mutations;
speculative restoration keeps both count and interval invalidation. Deferred
joins count final rows during the existing remap. New string-index fixtures
and optional ASM output remain intact. No674 trust protocol,658 literal
payloads,673 worker-budget code, rejected653 cache or PR678 code is in this
20-file issue delta. The larger compact selection-metadata experiment remains
excluded, and attributed-declaration lists remain future work.

Local Clang23.1.4, native, debug0, separate cores2 grant per build/test:

* checker/frontend/backend syntax passes; all41 build units pass;
* checker463,928 checks: four known fpclassify order disagreements with local
  Clang, in the same two duplicated families as pure-main/628 controls; no
  additional failures are attributed to641;
* checker driver, deferred, source lanes, assembly checker, and all220 pinned
  c-testsuite programs pass;
* focused ASan+UBSan, no recovery: 15 assertions/0failures; includes1,600 dense
  report-order comparisons, all guarded warning-range/count mutations and
  sparse initializer lookup across0..129 plans with absent/protected tails;
* table/embedded-NUL strings/checksum, empty unit and macro-warning controls:
  native and --scalar head object, stdout/diagnostic and printer bytes match
  exact628 base; all three linked checksum programs run0.

Code-identical final doc-only merge needs no repeat build. Publication compiler
SHA256 c5f26db6c77160e2870f5d997dfc2d9b83a25555518cbd9543fdaee33f1f8489;
628 control binary7e00ba4f9f61c4edecc81d082abde9922069867a92e063da5dd828c5ccee3c3a.
One byte-control harness receipt used the wrong separator for the print-error
filename; it exited2 before completing comparisons, and is preserved as
controls-rejected-filename.log. Corrected controls.log exits0. No failing
compiler result is removed by that harness correction.

Frozen 9700X retained/ablation evidence is public at
https://github.com/buster14a/buster-performance/blob/4df43f7d7a685133b6beade655d9e9a306947081/docs/measurements/unclaimed-perf-2026-10-28/issue-641/target/README.md .
Those exact revisions established lower representation/RSS costs with matching
objects, but no robust whole-compile speedup. They are not new-main timings.
Current focused publication qualification here is local; root coordinates any
new-head target acceptance. The issue is partially addressed, not closed.

Draft source PR694 is published and attached:
https://github.com/buster14a/buster/pull/694 , targeting codex/pub-628 (PR693).
GitHub reports MERGEABLE at exact725fe7fd/a70bca01. Independent read-only
publication scope review is tracked separately; CI state is not implied by
the local receipts above. No force push, GitHub merge or issue comment was made.

Independent read-only reviewer regions657 found no concrete correctness or
scope defect at exact725fe7fd: only retained7c plus required main603 warning
producer adaptation, no rejected selection maps; all count writes/clears and
deferred/graph publication paths checked; sparse lookup covers empty/absent
keys and all old consumers; string_ids and nullable ASM guards retained;
defined/retained object domains initialized before every consumed read. No
review edit or extra broad test run was required.
