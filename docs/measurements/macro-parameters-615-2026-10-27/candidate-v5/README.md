# Fifth candidate: restoring the parser call boundary did not pay

Source: Buster `2a98eef06a426230a0ff185497daf325f0f9dfb1`.
Default executable SHA-256:
`c0846455c4f8a151c64d9c6380edbd4fa00356ddef4baeecd7a834f03fe32f2c`.
Only the parameter parser's inlining annotation changes from candidate v4.
Baseline, inputs, six frontend placements and list ordering are recorded in
the parent report. All three primary rounds complete (162 per label/input),
as do all three after-scalar rounds (36). Every measured process exits zero.
Samples are not pooled with another source revision.

For 10,000 definitions and first invocations (`summary.tsv`, lists 7–10):

| Parameters | Baseline wall ms | Candidate wall ms | Second baseline wall ms | Baseline instructions | Candidate instructions | Baseline cycles | Candidate cycles |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 0 | 1.765 | 1.773 | 1.761 | 23,958,701 | 24,458,998 | 5,720,109 | 5,778,283 |
| 1 | 1.875 | 1.885 | 1.869 | 26,504,158 | 27,174,455 | 6,239,608 | 6,314,785 |
| 2 | 2.528 | 2.536 | 2.523 | 39,045,893 | 39,496,190 | 8,526,236 | 8,586,796 |
| 4 | 3.651 | 3.658 | 3.638 | 64,472,171 | 63,922,468 | 13,035,620 | 13,038,263 |

Zero/one-parameter instructions rise by 2.09% and 2.53%; user cycles rise by
1.02% and 1.20%. The corresponding central A/A cycle changes are -0.06%
and -0.20%. These tiny-list instruction costs are larger than candidate v4's.
Shrinking native `pp_define` from 4,659 to 2,741 bytes (baseline 2,720) did
not make the complete small-macro path cheaper. The caller's size alone was
an insufficient performance model; the separate parser still does its work.

The next revision restores inlining and handles complete valid empty/one-name
lists directly, avoiding the general grammar loop for those shapes. Variadics
and malformed lists retain the ordered reader.

Large-list scaling results, full distributions and after-scalar controls are
retained here. Local/native release builds, full Clang/preprocessor suites
with 3,000 generated cases, call-graph checks, frozen SQLite (706,237 identical
tokens) and focused ASan+UBSan checks all pass. Matching source/binary hashes,
build/test logs, placement symbols and assembly are included.
