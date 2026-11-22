# Source qualification

The candidate passed 850,925 checks across the eight checker shards and matched the unmodified parent in all 4,116 per-unit comparisons on SQLite, Buster, Lua and musl. A further 480 directed compilations matched exit status, diagnostic streams and object output across the recorded modes. The compressed tables retain the observations for each comparison. [Checker log](checker.log) · [Directed results](directed.tsv.gz)

The [depth-boundary cases](deep.tsv.gz) checked 756 pairs of native compiles with shallow and deep syntax, scalar declaration fallback, recovery, debug information and warning policies. Their linked native results matched Clang in 35 executions. The [physical depth capture](physical.tsv) reads the parser output before the checker consumes it, expands the actual depth values to 32 bits, and hashes the entire sequence. The byte count describes depth payload for live tokens. The [debugger observations](parser-tree-observations.tar.xz) and [source identities](local-source-inputs.tsv) accompany the comparison.

The [independent C17 error comparisons](clang-diagnostics.tsv) matched complete Buster diagnostic streams in all 40 cases. The first error text, line and column matched Clang in 30 cases. Clang used a bracket limit of 8,192 to reach the tested expressions. [Raw diagnostic streams](clang-diagnostic-streams.tar.xz)

The full-word fallback was observed on paren-257 (depth 258), paren-2060 (depth 2061). The role and parent sequences also matched in each complete capture.
