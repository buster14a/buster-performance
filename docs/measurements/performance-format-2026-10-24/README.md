# Benchmark format examples and evidence

Design/implementation roadmap: [Buster #384](https://github.com/buster14a/buster/issues/384). The reviewed format contract and schema belong in Buster; this directory holds the measurement examples, native synthetic capture, reproduction harness and validation receipts.

## Contents and status

- `foreign-strings-example/`: 288 reported process/case/path summaries and 12 execution/resource rows from the frozen source CSV files, preserving all 7,308 source cells. Arrow IPC and JSONL are equivalent representations, not extra rows; ordinary zero-row Arrow IPC sidecars supply physical schemas.
- `profile-example/`: a deliberately synthetic native Perfetto trace, original C generator, SQL checks and an arbitrary Arrow/JSONL table with exact uint64/decimal/null values. It is not a Buster performance result or a verified production import.
- `existing-data-coverage.tsv` and `source-snapshot.json`: the frozen 19-family / 1,043-path design inventory and inspected source identities, not a claim about current archive completeness.
- `*-validation-report.json`, `validation-report.json` and `upstream-dependencies.json`: exact checks, tested tool pins and limitations.
- `PROVENANCE.md`: origins, generator inputs, applicable terms and reproduction boundaries.
- `MANIFEST.sha256`: exact file digests; the checksum file excludes itself. Each example has its own detached checksum inventory.

Local fixture checks passed: **18 native Perfetto queries, 3 tables / 302 rows / 7,320 exact typed cell comparisons**, resource checks and 11 invalid manifest cases. The C generator reproduced the trace byte for byte. Production capture fidelity, all-family imports, independent native/browser readers, embedded UI/synchronization, large-capture costs and actual Pages publication remain work tracked in Buster #385–#390.

No upstream runtime is redistributed here. Schemas are published with the Buster design PR linked from the roadmap. Keep this directory in buster-performance and pin its reviewed commit in production consumers.
