# Profile-guided reduction in reader-time condition production

Three locked Ryzen 7 9700X rounds compared the ordinary compiler, the source-window producer with early ownership checks, and the same producer with three hot paths reduced. Each round includes two fresh processes per build and measurement series in symmetric order. The revised producer checks for types requiring a segmented walk before scanning them, vectorizes the unit scans for terminal names and declaration origins, and tests graph opcodes before attempting a condition splice.

On the frozen SQLite unit the revised producer retired 39,022,324 fewer user instructions and ran 1.481 ms faster than the preceding producer by paired median. Both improved in all three rounds. It still retired 108,072,130 more user instructions and took 14.618 ms longer than the ordinary compiler. All three runs per comparison agreed on the direction. Both producers generated the same 310,975-node graph. All builds produced identical object bytes, native entries and diagnostics.

[Paired estimates and ranges](sqlite/paired.tsv), [graph and native hashes](sqlite/oracles.tsv), [timing logs and object receipts](sqlite/native-receipts.tar.xz), [patches and reproduction commands](source-and-builds.tar.xz).
