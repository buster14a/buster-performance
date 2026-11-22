# Source qualification

The candidate passed 850,925 checks across the eight checker shards and matched the unmodified parent in all 4,116 per-unit comparisons on SQLite, Buster, Lua and musl. A further 480 directed compilations matched exit status, diagnostic streams and object output across the recorded modes. The compressed tables retain the observations for each comparison. [Checker log](checker.log) · [Directed results](directed.tsv.gz)


Ten additional field-access fixtures run on graphs padded beyond the cache threshold. All 70 parent/candidate pairs matched compiler status, both output streams and emitted ELF across the recorded modes. The valid ordinary and Tier 1 objects were linked and executed against Clang 23, including 4,096 combinations of guarded bitwise field reads. Source, exact diagnostic and typed/static dump streams, runtime output and digests are in [the guard observations](guarded-source/observations.tar.xz).

After the ordinary checker returned, the native debugger captured node-indexed graph columns, every stream value and its conversions, member bit offsets, diagnostics and warnings, arguments, normalized extended-precision payloads, canonical type columns and statistic counts. Each candidate capture matched its reference on SQLite, the local Buster source snapshot, Lua lvm.c, musl vfprintf.c and the member fixture. The commands derive each executable's ABI separately. [Column capture](native-columns/columns.py) · [Structural admission and observed cache hits](native-columns/coverage.tsv)
