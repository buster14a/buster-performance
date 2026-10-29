# Publication scope: issues 590, 652 and 657

[Authoritative status snapshot](regions-publication-status.md),
[652 qualification](652/QUALIFICATION.md), [657 identity](657/source.txt),
[590 identity](590/source.txt). All use main321. Publication heads are
657 ed73205fa8298dffafdd8e4552a31e9a764fbc59,
590 d1a9070b300ed95f517d3373b6b70b6abc00fef7 and
652 a08583d3ef27672309a9f3ee42f1212ba4cab69d. Each 41-unit build passes.
657 region/driver, 590 startup/lane/driver and 652 reuse/cleanup/driver/parser
and call-graph checks pass at their recorded code identities. Later doc-only
heads remain distinct from built identities. 590/652 address bounded slices;
their broader setup work remains open. Frozen performance is not remeasured.
The 657 publication uses reader->subtree_sizes as validated d3; the older
parser->sizes source is historical. Region fixtures cover normal/tree_only
and scalar/vector modes. For652, isolated A/A, A/B and reversal controls
supersede the contextual mixed-role method; SQLite remains neutral. For590,
THP-disabled means per-process policy, not madvise, and tcc remains faster.

These are frozen publication/correctness receipts, not new performance results.
Original reports and CI JSON preserve their handoff status, not live PR state.
Historical timings remain attributed to their original source revisions.
See [publication method and supersession note](../publication-method/ARCHIVE-SCOPE.md).
