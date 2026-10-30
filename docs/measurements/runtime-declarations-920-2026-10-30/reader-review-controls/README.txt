Independent parser controls for #920

All fixtures here are synthetic parser input, not performance observations.
These controls execute only the standalone C timing-grid reader, stage reducer,
and original small C fixture generators. No Buster compiler image, benchmark,
remote machine or host lock is used.

The export intentionally omits compiled binaries. To reproduce with fresh output
directories:
  bash check-grid.sh /path/to/proof-tools/read_grid.c /new/grid-controls
  bash check-stages.sh /path/to/scripts/summarize-stages.sh /new/stage-controls

The final grid control requires acceptance of the complete 972-record positive
grid and rejects nine malformed numeric/status/completeness cases. The stage
control requires the canonical 33-file A/B/A rotating grid and exact 11-sample
upper medians, and rejects seven filename/value/status cases. Tested input hashes
and host compiler identities are retained beside the exported compact receipts.

pre-fix-history/ is explicitly historical: before the owner tightened numeric
parsing, +inf wall, -1 user cycles and uint64-overflow user cycles were wrongly
accepted with exit zero. The final controls reject those same mutations. Do not
interpret historical acceptance as the final reader's behavior.

The generators and control scripts are original project work under
Apache-2.0 WITH LLVM-exception. They include no external implementation.
