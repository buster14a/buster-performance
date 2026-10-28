# Raw artifact

- Release: [issue-628-bulk-none-2026-10-28-95be46e6](https://github.com/buster14a/buster-performance/releases/tag/issue-628-bulk-none-2026-10-28-95be46e6)
- Asset: [target-95be.tar.gz](https://github.com/buster14a/buster-performance/releases/download/issue-628-bulk-none-2026-10-28-95be46e6/target-95be.tar.gz)
- Bytes: `132955754`
- SHA-256: `9ec7618b22c98c16e88c0396a7f49f449b5c58660389b5cbdd52691483f56971`

The archive contains both native build identities/commands/source markers,
host policy, the complete generated table source, pinned external-input
identities, campaign helpers, six 21-pair timing campaigns,
six nine-pair user-instruction controls, all 360 complete objects and their
hashes, stdout/stderr, per-process records, and summaries. Object equality was
checked before packaging. The successful fallback and compression run took the
shared native lock. The prior failed `rg` enumeration attempt is retained in
the public local receipts; it did not produce a published archive or alter any
measurement.

Extract into an empty directory and verify the complete object manifest from
that directory:

```sh
tar xzf target-95be.tar.gz
sha256sum -c fill-tools95be/all-objects.sha256
```

`SHA256SUMS` covers the public text copies and local correctness receipts in
this issue folder. The generated large source and executable objects are kept
in the release asset rather than duplicated as Git blobs. The original C
generator and collector source snapshots accompany the report.
