# Source qualification

The candidate passed 850,925 checks across the eight checker shards and matched the unmodified parent in all 4,116 per-unit comparisons on SQLite, Buster, Lua and musl. A further 480 directed compilations matched exit status, diagnostic streams and object output across the recorded modes. The compressed tables retain the observations for each comparison. [Checker log](checker.log) · [Directed results](directed.tsv.gz)

## Large source units

Padded sources reached the 8,192-token threshold. Status, object and diagnostic output matched the local parent in all 145 compilations. The candidate and Clang executables also matched in 34 linked comparisons. The local parent only differs from the native timing parent in documentation. [Sources](padded-sources.tar.xz) · [Per-case results](padded-sources.tsv) · [Reproducer](verify-discard-fixtures.py)
