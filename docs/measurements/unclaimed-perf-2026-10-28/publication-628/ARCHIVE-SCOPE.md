# Publication scope: issue 628 on main321

[Built source](SOURCE_COMMIT), [compiler hash](compiler.sha256),
[object controls](objects.log), [full checker](checker.log).
Built head 722ecc1b95817ec15b6c2f95fd137f411d7e0905 refreshes the qualified parser
and nullable-ASM slices on pure321. Published a70bca0106d0ea01bb7a2562f222b23064118cdb
adds only six documentation lines; production code is unchanged. Build, parser,
ASM, driver, deferred, call graph and object controls pass. The full local
checker retains four known oracle disagreements (464,841 checks), not a full
pass. Frozen416 measurements establish bounded RSS only, without wall/system
gain. Bulk-NONE/output-fill and issue-628-fill remain entirely excluded.

These are frozen publication/correctness receipts, not new performance results.
Original reports and CI JSON preserve their handoff status, not live PR state.
Historical timings remain attributed to their original source revisions.
See [publication method and supersession note](../publication-method/ARCHIVE-SCOPE.md).
