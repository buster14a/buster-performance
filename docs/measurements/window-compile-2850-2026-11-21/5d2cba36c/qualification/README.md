# Source qualification

The candidate passed 850,925 checks across the eight checker shards and matched the unmodified parent in all 4,116 per-unit comparisons on SQLite, Buster, Lua and musl. A further 480 directed compilations matched exit status, diagnostic streams and object output across the recorded modes. The compressed tables retain the observations for each comparison. [Checker log](checker.log) · [Directed results](directed.tsv.gz)

All [336 colon and brace comparisons](colons.tsv.gz) and [120 parser boundary comparisons](parse-boundaries.tsv.gz) matched for printed tree rows, diagnostics, object bytes and status in the requested mode. The native binaries also matched Clang on 18 linked executions.

The ordinary typed dump comparison compiled both SQLite and Buster with `--dump-typed --lanes 1 -c`. Each complete dump, diagnostic stream and ELF object matched the baseline. The [stream and object sizes and hashes](typed-object-and-output.tsv) record each source.
