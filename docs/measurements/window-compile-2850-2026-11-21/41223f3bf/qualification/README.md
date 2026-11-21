# Source qualification

The candidate passed 850,925 checks across the eight checker shards and matched the unmodified parent in all 4,116 per-unit comparisons on SQLite, Buster, Lua and musl. A further 480 directed compilations matched exit status, diagnostic streams and object output across the recorded modes. The compressed tables retain the observations for each comparison. [Checker log](checker.log) · [Directed results](directed.tsv.gz)

## Large source units

Padded sources reached the 8,192-token threshold. Status, object and diagnostic output matched the local parent in all 145 compilations. The candidate and Clang executables also matched in 34 linked comparisons. The local parent only differs from the native timing parent in documentation. [Sources](padded-sources.tar.xz) · [Per-case results](padded-sources.tsv) · [Reproducer](verify-discard-fixtures.py)

## Materialized leaf records

At entry to the ordinary checker, the debugger read the actual leaf and overflow counters. Compact rows occupy 16 bytes each, with 32 extra bytes per overflow row. The parent uses one 32-byte row per leaf. These counts exclude virtual reservations, allocator rounding and the full payload table shared by both representations.

| Input | Leaves | Overflow rows | Parent record bytes | Candidate record bytes |
| --- | ---: | ---: | ---: | ---: |
| sqlite | 144,755 | 1,585 | 4,632,160 | 2,366,800 |
| main | 665,961 | 10,077 | 21,310,752 | 10,977,840 |

The SQLite input had 716,136 preprocessed tokens. The local compiler source had 2,433,563 tokens. [Debugger reads](root-coverage.gdb)
