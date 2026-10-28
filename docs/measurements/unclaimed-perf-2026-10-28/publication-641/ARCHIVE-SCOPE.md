# Publication scope: issue 641 focused stack refresh

[Authoritative report](README.md), [guarded oracles](guarded-oracles.log),
[corrected controls](controls.log), [rejected harness attempt](controls-rejected-filename.log).
Head 725fe7fd178b9bcac7819cfc74b395f1bf58e6ad ports retained code 9b319dd3 onto
focused 628/a70bca01 on main 321; final merge completes doc-link ancestry only.
Syntax/build and recorded driver/deferred/lanes/ASM/corpus, sanitizer and byte
controls pass. Checker 463,928 has four known shared local oracle disagreements,
not a full pass. Independent review found no concrete retained-scope defect.
Larger selection metadata, 674/658/673, rejected 653 and PR 678 are not this delta.
The issue remains partially addressed; historical RSS/representation evidence
does not establish robust whole-compile or refreshed-main speedup.

These are frozen publication/correctness receipts, not new performance results.
Original reports and CI JSON preserve their handoff status, not live PR state.
Historical timings remain attributed to their original source revisions.
See [publication method and supersession note](../publication-method/ARCHIVE-SCOPE.md).
