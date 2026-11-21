# Dispatch of body-window leaf and lookup rules

Dispatching the six lookup operations separately from the full operator kernel cut the median paired SQLite cost by 0.695 cycles per taken leaf or lookup in lean mode and 0.790 in whole mode. Compacting the physical declaration-line numbers alongside the leaf positions cost more than it saved. All 108 processes matched the independently checked records, list order and decoys. The 10-cycle target remains open.

| Input | Reference | Lookup dispatch | Compacted leaf lines |
| --- | ---: | ---: | ---: |
| SQLite lean | 29.185 | 28.395 | 29.570 |
| SQLite whole | 30.405 | 29.615 | 30.450 |
| Lua lean | 22.340 | 22.325 | 23.305 |
| Lua whole | 23.010 | 22.575 | 23.725 |
| musl lean | 19.290 | 18.975 | 19.615 |
| musl whole | 20.495 | 20.075 | 20.700 |

Each cell gives the median of three round means on the locked Ryzen 7 9700X CPU 2. Each round ran two fresh processes per compiler in symmetric order. Each process ran five passes. The existing shadow benchmark subtracts the cost of installing each window's given records. The six-operation variant specializes lean and whole dispatch and detects the present classes of a round with one vector compare. The leaf variant separately tests producing a list of physical declaration lines during the SIMD input scan, against the shared reference compiler.

[Paired differences and ranges](paired.tsv) · [Per-process counters](samples.tsv) · [Build and patch hashes](builds.tsv) · [Native reports](measurements.tar.xz) · [Runner](facts-leaf-pair.sh)
