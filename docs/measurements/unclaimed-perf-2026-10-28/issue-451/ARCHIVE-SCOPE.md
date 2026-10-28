# Archive scope: issue 451 page-line fusion — rejected

[Negative report](README.md), [frozen reproduction method](REPRODUCE.md),
[native provenance](native/451-qa-provenance.txt),
[complete proposed patch](experiment-68e113ee.patch).
This collection covers only the page-line fusion follow-up in issue comment
6452207581, claimed by the coordinator in comment 6469199014. The original
parts retain their ownership and credit under merged PRs #462 and #486.
Do not count #451 as solved or integrate this experiment.

Preserved source is `68e113ee445af2a80296412a2b8791d3bf9098a6`, based on pure
main `4165454ebadf9b96c2b40ab99c55f4c0b28ba975`. Its native image is identical
to prototype `d6b3f5c37217cad5cb5c5ab3ef3aaa14f32c4f5d`; the final extra guard
delegates to the scalar-host lexer, whose broader runtime compatibility was
not qualified in this rejected experiment. All native correctness checks pass.
Preparation stays 10.000 to 10.000 ms, whole-process changes remain within A/A,
and real compilation adds 2,188 KiB peak RSS. It was never integrated.
Misrouted probes, failed starts, truncated-log negative controls and the
reverted restrict refinement remain explicitly fenced in the original report.

COLLECTION.tsv paths are relative to local `work/evidence-451/review-package/`.
Only bounded, byte-identical UTF-8 text is copied. The package's original
provenance archive remains local raw with its digest/disposition recorded;
the full experiment history and remnants outside this lean package remain
local and were not modified or imported. No new target work was performed.
