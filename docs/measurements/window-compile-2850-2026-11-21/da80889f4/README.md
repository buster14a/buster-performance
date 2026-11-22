# Reuse source-local checked diagnostic storage

Four diagnostic, operand, warning and ignored-result columns are retained across source root boundaries. Semantic writers record dirty 16-slot lines. The golden run independently inspected storage for stale entries at root handoff. Across 2,750 SQLite root checks and 323,623 nodes, the buffer grew to 16,384 entries and cleared no dirty lines. Buster checked 1,401,101 nodes across 8,943 roots, grew to 524,288 entries and cleared 1,369 lines.

[Source against 0e1d5b825](source.patch), [revision](revision.tsv), [independent source-policy counts](source-policy.tsv) and [local logs and commands](local-records.tar.gz). The local checker was rebuilt at -O0 against the Develop units. The SQLite and Buster object files matched the frozen independent ordinary reference.

All 6,860 independent status, diagnostic and object comparisons passed, including 863 expected nonzero exits. The same object also survived the source and control poisoning configuration. [Exact options used](check-used.sh).
