# Read contiguous source roots from parser extents

The parser extent and reverse-order cursor consumed all 7,298 SQLite external declarations and all 12,518 Buster external declarations. An independent always-scan comparison checked original child links and the graphs for both complete objects.

[Source against 0e1d5b825](source.patch), [revision](revision.tsv), [independent source-policy counts](source-policy.tsv) and [local logs and commands](local-records.tar.gz). The local checker was rebuilt at -O0 against the Develop units. The SQLite and Buster object files matched the frozen independent ordinary reference.
