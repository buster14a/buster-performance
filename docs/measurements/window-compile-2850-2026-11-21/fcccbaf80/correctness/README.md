# Integer arithmetic windows on the untimed expression reader

The `--node-window-constants` compiler and its unmodified parent compile the same frozen C inputs through the ordinary driver. The parent includes the change from #3252 that runs an ordinary expression action without visiting the profiling clock. The arithmetic and return-window actions both pass through the driver's selected clock pointer when they fall back to an ordinary action. The options for clock collection and for arithmetic admission remain independently selectable.

## Source identity

The two tested parent revisions, `707ef11f4` and `faff3cc89`, have Git tree `6b2103734200dc6b69017f3ea922e57073987af5`. The two combined revisions, `27441f465` and `fcccbaf80`, have tree `51988082173c4d0e39d09cba7c6e3f3f679dce08`. The different revisions arose from a merge-queue retry which preserved the complete source tree. The local Develop builds use the first combined revision and the second parent. The Git tree and both parents of each merge appear in `revisions.txt`. The complete feature diff applies to `faff3cc89` and appears in `source.patch`.

## Compiler checks

Each of 21,483 driver cases compiled three times using the parent, the new compiler with ordinary settings, and the new compiler with arithmetic windows. All 64,449 runs agreed on exit status, standard output, diagnostics and the complete ELF when a file was emitted. The per-case receipts include 11,835 tracked source/policy combinations, 4,160 generated combinations and 5,488 frozen workload/policy combinations. The test policies, corpus commands and output paths appear in `commands/`. The TSV archives identify every individual compile by source and policy.

The eight checker shards passed 848,429 assertions. The eight driver shards passed 151,324. The additional attested input catalogue passed all 28 checks. The `full-checks/` directory holds the individual shard records.

The `focused.tsv` hashes cover 24 three-way comparisons across two fixtures, three window options and four debug, source-map and poisoned-arena settings. Each compared ordinary compilation to window compilation with profiling off and on. The 72 compiler results all matched the appropriate whole-object checksum. The accompanying timed stderr records retain their reported admission totals. Both the contiguous and remapped arithmetic fixtures admitted four operands, removed ten ordinary nodes and retained a 45-node graph.

| Frozen input | Source files | Arithmetic operands | Ordinary nodes removed |
|---|---:|---:|---:|
| SQLite | 1 | 2,356 | 4,759 |
| Lua | 34 | 781 | 1,986 |
| musl | 1,336 | 2,895 | 4,005 |
| Buster compiler | 1 | 27,201 | 67,186 |

`stages/stage-counts.tsv.gz` holds the individual instrumented driver receipts for the workload counts. Local stage clocks describe those diagnostic invocations. Throughput comparisons use separately timed uninstrumented compilations on the locked host.
