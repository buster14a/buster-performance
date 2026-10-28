# Archive scope: issue 673 clean launch

[Final report](REPORT.md), [matrix rows](matrix-summary.tsv),
[balanced policy rows](balanced-summary.tsv), [interference audit](contamination-audit.txt).
Frozen implementation is `1d076d6736df9b7350610ec646dc1fe1ef39f7dc`; follow-up
`30658d647bfaba8ec33d1fee676a0c853a274f02` changes documentation only.
Raw controls remain separately under [issue-673](../issue-673/ARCHIVE-SCOPE.md).
Original reports' code-formatted `../evidence-673/` paths name their local source
directory; the equivalent archived raw records are under `../issue-673/`.
Ownership is qualified with workload tradeoffs: balanced uniform large files
improve 4.58% against free eight; the uneven mix costs 4.80%; tiny ranges overlap.
The mixed policy screen is fenced, local spare-token prototype timing predates
the final regression compile, and the matrix makes no baseline/head speedup claim.
No universal neutrality, latest-main/678 speedup or DRAM-traffic claim is made.
