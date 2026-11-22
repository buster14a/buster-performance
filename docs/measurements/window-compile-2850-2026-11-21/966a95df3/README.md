# Native source body ownership with the combined checker

SQLite emitted the ordinary 2,061,200-byte local object after selecting all 2,674 source bodies. The final unit graph had one allocated slot and zero persistent expression nodes. The reader closed 7,298 contiguous roots and emitted 2,665 native fragments. Buster closed 12,518 roots and kept its unsupported work in the ordinary graph. The graph, statement and native counters are per translation unit. The full compiler for this experiment was built with the unmodified Develop build command. [Source](source.patch), [revision](revision.tsv), [build](build.log), [audit flags](check.sh).

All 6,860 comparisons against an independent ordinary binary matched process status, diagnostics, stdout and complete object bytes, including 863 expected failures. The corpus covers SQLite, the Buster compiler, Lua and musl under five policy settings. The four SQLite shell sessions also matched the Clang-built shell in output and exit status. The logs retain all 92 directed initializer and warning comparisons. [Policy counts](source-policy.tsv), [per-unit data, source fixtures and logs](local-records.tar.gz).

These are correctness and storage results for the combined experiment. Separate exceptional-source investigations found required diagnostic fallbacks for recovered views, unavailable members, nonliteral-null conversions and incomplete counted-pointer initialization. Those follow-up repairs are outside this revision.

The SQL runtime command was corrected to link this revision’s own SQLite object directly. The earlier harness used an older, byte-identical object. All four SQL traces passed again. [Fresh runtime receipt](runtime.native.log), [corrected command and output](local-records.tar.gz).
