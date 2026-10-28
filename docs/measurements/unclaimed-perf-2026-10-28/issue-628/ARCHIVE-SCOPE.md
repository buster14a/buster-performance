# Archive scope: issue 628 qualified parser memory slice

[Qualified report](PARSER-RESULTS.md), [local method](LOCAL-METHOD.md),
[native identities](target/evidence628/native-identities.sha256),
[186 exact timing-object comparisons](target/evidence628/parser-timing-objects.log).
Patch `050dbfcde5687c339a7a2ea33237e5667162d01e` is based on pure a62;
native head `1b98b195139a114c9b5da6cf7f82c083ce14c165` merges it with pure main
`4165454ebadf9b96c2b40ab99c55f4c0b28ba975`. The accepted scope is four
parser/benchmark/test/docs files, with about 6 MiB lower native RSS in both orders.
Wall and system-time improvement are unestablished. This does not complete #628.
Older bc1/3864 and a62 local screens do not establish current native acceptance;
local a62 proof is retained only with that label. Every uncommitted asm-ID slice,
its asm-column records and column_counts proposal accounting remain local raw,
with source identities in COLLECTION.tsv; none is accepted or copied here.
