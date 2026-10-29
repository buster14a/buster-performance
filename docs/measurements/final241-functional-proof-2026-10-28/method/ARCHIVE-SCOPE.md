# Functional archival method

[Collector](curate_final241.py) imports [byte-exact archival core](curate_evidence.py).
The core is copied unchanged from evidence commit
9f50a7ba6dbcdc88f9b6237b92d9f9c8a5e835e6 at
docs/measurements/unclaimed-perf-2026-10-28/publication-method/curate_evidence.py.
Its SHA256 is bfdeac4d147a2b9fa37f85ee8f6a7014c90e74fcc1b8b388d9be14e57692a43c.
COLLECTION.tsv records every regular source file's path, bytes, SHA256 and
copied-text versus retained-local-raw disposition. Copied bytes are unchanged
UTF-8, without NUL, and at most 5 MiB per file. Objects, executables and binary
archives remain local. Generated scope/readme interpretation is distinct from
original raw receipts. No active owner folder is collected before explicit
completion, and no target/performance run is performed by this collector.
The method inventory contains exactly the two named scripts; Python caches
and the collector's own changing scratch output are not method source inputs.
