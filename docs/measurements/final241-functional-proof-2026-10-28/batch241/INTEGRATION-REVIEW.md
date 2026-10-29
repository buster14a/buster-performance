# Bounded source review at 4349d8fd

No concrete source integration defect was found. This is a read-only contract
review and does not replace the executable checks recorded separately.

The independent deferred-reader audit checked both main-241's change and the
actual final composition. At the freeze, `c_check_deferred.c` refreshes reader
and input copies for each reading, rebinds their output/types/arena/scratch,
and resets each private warning interval index. It retains memory arenas, not
old semantic snapshots. Initialization of top and changes both uses the new
`memory.top` field, after the retained arenas have been reset.

The final merge resets the warning-row count and its prepared flag, recounts
all non-sentinel rows during its required remap traversal, then publishes the
prepared flag. Lane-private copies of the counter are never treated as an
aggregate. Declaration-time warning mutations continue through the same
count-maintaining helper. The literal-table array type is replayed in both
the retained plan and its embedded bytes part. Payloads belong to the current
input arena, not the reusable lane scratch.

The nullable ASM remap remains inside `input->asm_ids != NULL`; vector access
guards pointer arithmetic. Retained input columns are aliased to each current
reader. Optional parser traversal metadata is replaced by reader-owned sizes,
and copied into lanes as immutable metadata. Region checks use
`reader->subtree_sizes`; the no-region path needs no traversal columns.

The source pass completes deferred merging before expression production and
late diagnostics. Recorded graph facts are finalized only after those passes.
The compilation reader still omits the environment publication while enabling
literal tables (`false, true`), the public/deferred readers enable both, and
the ordinary source oracle publishes the environment but disables compact
tables (`true, false`).

The retained static-data declaration keys replace only a repeated static
declaration selection; no rejected compact selection maps are introduced.
Initializer plans keep ascending declaration tokens, use the sparse lookup,
and pass the existing string-ID column to ordinary planning. The final count
is published only after all plans succeed. Warning collectors preserve dense
fallbacks for hand-built inputs without producer metadata.

The guardian correction was reviewed against its immediate 35d22324 parent.
Its recovery buffer is reserved and faulted before borrowing any byte. Every
partial write retains its suffix; EAGAIN compaction takes at most the buffer's
remaining capacity and returns those additional bytes with the lease. GNU
make token conservation bounds owned plus available bytes by the pipe's
initial capacity. Draining frees nonappendable pipe pages. EINTR and transient
IO failures do not acknowledge lost ownership. Both validated private pipe
endpoints remain open until the guardian has returned its bytes. The module
is byte-identical to reviewed b1b3e490. Driver budget initialization precedes
source IO, final close is outside both terminal mapping-release guards, and
guardian dispatch precedes dry-run handling.

Merge resolutions only combine host guards with the retained algorithm or
keep both independent regression tests. New literal-table host guards exactly
match the already validated private d74d8736 helper. Source and binary hashes
are recorded independently; no source change was made after the freeze.
