# #3510: Key Locker's segment copies

Main decided Key Locker's implicit XMM registers by `form & BUSTER_X86_FORM_NUMBER`, which keeps the FS, GS and SS
copies' offsets. So the copies of the 7 forms got no XMM0 to XMM7 reads or writes. The fix compares the form's row.

`cmp.c` and `side.c` link main `2b2950d54`'s `x86_semantics.c` and the branch's in one executable. They run 2^21 random
records over every form number (15 bits), with and without the opmasks' column, and count the forms whose outputs
differ. The result: 21 forms, 1,542 records.
- **FS copies:** 9,727 to 9,733 (8,358 + 1,369 to 1,375).
- **GS copies:** 18,085 to 18,091.
- **SS copies:** 26,443 to 26,449.

These are the FS, GS and SS copies of rows 1,369 to 1,375 (the four wide forms, encodekey128, encodekey256 and
loadiwkey; the SS copies exist below row 7,694). No other form differs, so the columns' digest
(`BUSTER_X86_SEMANTICS_TEST_COLUMNS_DIGEST`) is re-recorded for this change alone: `0x50941581527bed0d`.
