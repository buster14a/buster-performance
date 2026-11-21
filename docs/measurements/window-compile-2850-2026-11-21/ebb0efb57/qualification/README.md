# Source qualification

The candidate passed 850,925 checks across the eight checker shards and matched the unmodified parent in all 4,116 per-unit comparisons on SQLite, Buster, Lua and musl. A further 480 directed compilations matched exit status, diagnostic streams and object output across the recorded modes. The compressed tables retain the observations for each comparison. [Checker log](checker.log) · [Directed results](directed.tsv.gz)

The full parser suite passed. Forty generated inputs exercised nesting and mismatched delimiters at block boundaries, pragma handling, macros, scopes and statements. All 120 comparisons matched the reference’s parse tree, syntax diagnostics and object result. [Parser suite](parser.log) · [Boundary comparisons](parser-boundaries.tsv)
