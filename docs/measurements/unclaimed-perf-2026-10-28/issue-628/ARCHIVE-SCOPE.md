# Archive scope: issue 628 qualified parser and ASM-column memory slices

[Qualified report](PARSER-RESULTS.md), [local method](LOCAL-METHOD.md),
[native identities](target/evidence628/native-identities.sha256),
[186 exact timing-object comparisons](target/evidence628/parser-timing-objects.log).
[Qualified ASM-column report](ASM-COLUMN-RESULTS.md),
[ASM native identities](target-asm/evidence628-asm/native-identities.sha256),
[248 exact ASM timing-object comparisons](target-asm/evidence628-asm/timing-objects.log).
Patch `050dbfcde5687c339a7a2ea33237e5667162d01e` is based on pure a62;
native head `1b98b195139a114c9b5da6cf7f82c083ce14c165` merges it with pure main
`4165454ebadf9b96c2b40ab99c55f4c0b28ba975`. The accepted scope is four
parser/benchmark/test/docs files, with about 6 MiB lower native RSS in both orders.
Additional ASM slice `dc15a18ed3ad273888ae1cb87e903969e876acfa` is qualified on
that immutable parser+416 parent. It saves about 2 MiB incremental native RSS;
the directly measured parser+ASM total versus pure416 is about 8 MiB. Native
checker, ASM/Clang and deferred checks pass; all 248 timing objects match.
Wall and system-time improvement are unestablished. This does not complete #628.
Older bc1/3864 and a62 local screens do not establish current native acceptance;
local a62 proof is retained only with that label. The ASM local negative timing
and mistaken CLI invocation remain explicitly fenced. The parser-only target
tree is unchanged. Column-count proposal accounting stays local raw. The bulk
NONE/output-fill experiment is unqualified and excluded entirely, along with
the private issue-628-fill branch. No latest-main timing is inferred.
