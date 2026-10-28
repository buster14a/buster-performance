# File-window preparation: #451 completion and residual costs

This is an evidence/documentation completion record for
[Buster #451](https://github.com/buster14a/buster/issues/451), building on the
already-merged #462/#486 work. It adds no compiler algorithm and claims no new
source speedup. The rejected page-line fusion remains rejected.

Source is `e7f89091648f68940b595aadd648841c1ffc3ec5`, tree
`4d76bb93e2950d437c834d289805c09a0e5b0eb3`; later main is outside the record.
Both configurations use one official-Clang-23.1.4, debug-enabled native binary,
SHA-256 `06132c96872df0d3ffa910c0c7ef7814f0547deb4f40209840bcba1c63f1947e`.
Production 128 KiB windows are compared with forced whole files. All native
operations used the shared 9700X lock; measurements used CPU 2. No host
settings changed and no remeasurement occurred during publication.

Exactly 12 one-input/two-role cohorts contain 504 timed children (all zero
status, zero major faults, PMU counted), plus 48 scheduled warmups. Sixteen
phase processes supply two alternating pairs per input, each with 21 passes.
Native PP/Clang/window/CR-line, 520-file refinement and file/resource gates
pass. Main's total preparation is neutral in this bounded sample, SQLite
favors windows, and about 2 MiB of extra peak memory remains in three commands.
The spliced stress case's small window cost is retained as a negative result.

Read [RESULTS.md](RESULTS.md) for all medians, ranges, controls and limits,
[REVIEWER-PACKET.md](REVIEWER-PACKET.md) for the acceptance map, and
[NATIVE-PLAN.md](NATIVE-PLAN.md)/[REPRODUCE.md](REPRODUCE.md) for exact commands.
Historical source effects remain attributed to #462/#486 and their immutable
records. Current configuration costs, native correctness and future PR/CI
status are separate claims.

## Byte-preserving curation

The original frozen source manifest SHA-256 is
`386f5be7d469371010621fc4f11a5ab1b230c678c35e9e8354373080f916eece`.
It lists 414 payload files; that manifest is also retained here, giving
415 source/disposition rows in [COLLECTION.tsv](COLLECTION.tsv). Every source
file was hashed against the frozen manifest. There are 376 byte-exact copies
and 39 explicitly omitted private artifacts: 14 ELF executables, 18 complete
or failed preprocessed outputs, four large generated inputs and three duplicate
transfer archives. Their sizes/digests/dispositions remain in the collection.
All failure/status/diagnostic logs and all raw timed/phase rows are retained.

The complete private native transfer archive is retained at the campaign
location recorded in the receipts, SHA-256
`8d49109281e5909acd5292eae386d4db3513fb668317cf49f9bb5a7fa9391ccb`.
Every payload digest passed after transfer, and local readers reproduce all
12 whole and four phase-group summaries byte for byte. Large generated inputs
are reproducible from the retained generator and exact hashes. See
[ARCHIVE-SCOPE.md](ARCHIVE-SCOPE.md) for the private-artifact boundaries.

`FINAL-SHA256SUMS` and `READY.md` are byte-exact snapshots of the private frozen
record, so they still describe private artifacts. Use `CURATED-SHA256SUMS` to
verify the public payload. `DRAFT-DOC-SECTION.md` is likewise the frozen review
proposal, with its then-pending evidence-link wording; it is not the final
compiler PR. New curation metadata and the original C curator live alongside
the copied record. [PROVENANCE.md](PROVENANCE.md) records their terms.

The first native own-header-layout gate, the four older local header-pack
failures, the first final-audit status-schema failure, reader fault injections,
and the negative spliced result remain visible. The SQL pack's 786-path content
inventory is explicitly postrun; main's 841-file dependency/source identities
were observed before and verified after measurement. This record must not be
used to claim a new speedup or qualification of a later compiler head.
