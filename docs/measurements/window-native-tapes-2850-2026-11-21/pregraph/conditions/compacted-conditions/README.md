# Compiling memory comparisons after removing their operand graphs

The source reader can now replace the operand of a complete plain integer or pointer comparison that includes a dereference, field access or subscript. It records the checked value at the operand's token and preserves the ordinary condition wrapper. When a selected body reaches that wrapper the native writer must consume the saved source entries. Source references also carry the original spelling and postorder of local reads through unused and uninitialized-variable diagnostics. The proof declines volatile accesses, bit fields, side effects and unsupported warning policies. [Cumulative source patch against Buster 84a7d3d76](compact-memory-reads.patch)

| Frozen input, ordinary object | Conditions with compacted operands | Graph nodes removed | Reached by ordinary native lowering |
| --- | ---: | ---: | ---: |
| SQLite | 1,551 | 5,469 | 1,550 |
| Lua, 34 units | 124 | 470 | 124 |
| musl, 1,336 units | 288 | 1,065 | 287 |
| Buster compiler | 615 | 2,134 | 184 |

The debug results have the same coverage. The current proof leaves all four workloads on the existing graph under `-Wall -Wextra`. All 4,116 real full-object pairs and six fixture pairs matched exit status, diagnostic text, stdout, the complete native-stream witness and ELF bytes. Graph comparisons reconciled the checked value, source token and surviving edges through the 1,551 SQLite replacements. The SQLite graph fell from 323,623 to 318,154 nodes and all 259,326 surviving edges matched. In every unit the native writer consumed exactly the intersection of compacted operands and wrappers reached by the graph-retaining writer. This distinction matters for the compiler's own 431 dormant conditions. [Per-corpus counts](object-driver.tsv) · [Unit digests and graph witnesses](raw.tar.xz) · [Graph comparison](graph_check.py)

Of 560 additional warning and pragma cases, 527 compiled and 33 were rejected. All matched the original compiler's objects, native witness, diagnostics, stdout and exit status. The window compacted 128 operands and emitted native code for 118. The grid includes initialized and uninitialized locals, volatile and atomic operands, bit fields, short circuits, unevaluated operands, loop conditions and malformed source. [Policy data](warnings.tsv) · [Generated source families](compact-warning-grid.py)

A two-condition executable returned the Clang 23 checksum 17717848474759356400 in both ordinary and debug builds. Disabling the source consumer on the physically reduced graph failed compilation. Changing the recorded pointer stride changed the checksum to 6103991864315257024. The same controls retained the reference result when the warning policy selected neither condition. These are correctness results. End-to-end steady or fresh-process throughput requires a separate measurement. [Execution receipts](execute.tsv) · [Consumer and stride controls](compact-necessity.sh)
