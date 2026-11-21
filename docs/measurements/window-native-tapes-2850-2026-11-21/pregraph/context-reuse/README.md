# Reusing source contexts for retained native rows

A source-only window can emit the tests, C and X data on either of two schedules. The reference first computes the warning and context decisions for every independently typed record. After admission it prepares the narrower set of records again for X. The candidate computes X’s type and value columns for all typed records up front, then filters the eight context masks to the selected expressions. Both schedules emitted the same native tapes and call ABI rows, including all 26,291 SQLite roots and 133,611 entries reached by ordinary lowering. The source patch applies to 84a7d3d76891d6c393497e62e6aff38f2b162fc2.

A single Release binary ran both schedules on pinned CPU 2 of the locked Ryzen 7 9700X. For each corpus, seven ABBA/BAAB rounds yielded 28 complete observations. The table reports medians of the paired change in the sum of per-chunk TSC deltas divided by the number of swept records, including carried records. The timing covers the independent pregraph T routine and its warning, C and X work through retaining native entries. The T closure includes probe bookkeeping. The ordinary graph, oracle, input front and later native lowering lie outside these intervals. A TSC tick is a timebase tick. The step 2 gate specifies actual core cycles per body node in ordinary object compilation.

| Corpus | Row preparation | Inputs, admission and preparation together | All timed stages | Rounds faster overall |
| --- | ---: | ---: | ---: | ---: |
| SQLite | −8.77 | −0.32 | +0.79 | 0/7 |
| Lua | −10.15 | +6.97 | +8.16 | 0/7 |
| musl | −12.56 | +0.92 | +2.07 | 2/7 |

Preparing X's inputs earlier erased the savings from skipping repeated context work. On SQLite alone, the input stage cost 6.57 more TSC ticks per swept record. Across all timed stages the absolute SQLite medians were 163.27 and 164.27 ticks per swept record, or 74.38 and 74.83 ticks per preprocessed token. Both schedules leave the front and scalar fallback to account for separately.

The archive contains the three timing counters (T, source stages and counts) by chunk and the ordinary lowering comparison receipts for all 84 observations. The reducer verifies exact agreement of every corpus's counts and native receipts across both modes. The shared locked-host build and corpus setup are the same as in the reader-token-columns record. 
