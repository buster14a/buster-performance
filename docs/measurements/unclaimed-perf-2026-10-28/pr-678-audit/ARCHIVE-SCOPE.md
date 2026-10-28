# Archive scope: PR 678 focused scalar-operation audit

[Audit report](README.md) records unsupported operations in old exact PR
`8af0904bfa103398af64f292d560cfbdc6fdc22d`, compared with retained source b8cd163c.
The three-file local shim fix is `b71c9cfa627c2fb6f0af3b9beda9f18403c45d85`.
Focused baseline/native compile probes and boundary/UBSan tests pass. This is
focused old-head audit evidence, not final latest-PR or integrated runtime acceptance.
The [old/latest pristine controls](../pr-678-controls/README.md) retain their
negative results separately.
