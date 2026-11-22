# Publish control masks while classifying source operations

Sparse per-block masks identify cases, switches, definitions and label addresses. The semantic producers mark region/cleanup/VLA restrictions before source lowering consumes the masks. Native switch handling visits case positions from those masks.

[Source against 0e1d5b825](source.patch), [revision](revision.tsv), [independent source-policy counts](source-policy.tsv) and [local logs and commands](local-records.tar.gz). The local checker was rebuilt at -O0 against the Develop units. The SQLite and Buster object files matched the frozen independent ordinary reference.

All 6,860 independent status, diagnostic and object comparisons passed, including 863 expected nonzero exits. The same object also survived the source and control poisoning configuration. [Exact options used](check-used.sh).
