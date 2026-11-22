# Bound the warning range index by the active source root

SQLite reserved 32,168 index entries cumulatively instead of 90,832,896. Buster reserved 114,104 instead of 1,174,274,048. These are logical table capacities accumulated across source roots.

[Source against 0e1d5b825](source.patch), [revision](revision.tsv), [independent source-policy counts](source-policy.tsv) and [local logs and commands](local-records.tar.gz). The local checker was rebuilt at -O0 against the Develop units. The SQLite and Buster object files matched the frozen independent ordinary reference.

All 6,860 independent status, diagnostic and object comparisons passed, including 863 expected nonzero exits. The same object also survived the source and control poisoning configuration. [Exact options used](check-used.sh).
