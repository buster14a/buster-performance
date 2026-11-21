# Graph size and checker work on SQLite

The ordinary reader emitted 323,623 nodes for 716,136 preprocessed tokens. The source-only T experiment recognized 33,089 roots. In this storage experiment, 28,665 roots had an operand interior that could be removed, yielding 229,786 actual checker nodes, a 29.0% reduction. Each surviving ordinary wrapper still addressed its replacement operand. The 171,054 surviving direct and call-argument edges mapped to exactly the original source nodes.

This is a downstream checker experiment. The packed input gets each new leaf’s semantic value from the first ordinary check. The measured interval begins after graph construction and pure-node recording. It covers the ordinary checker on fresh output, with no source discovery, independent typing, source admission or native lowering in that interval. The real end-to-end compiler follows separately.

## Measurements

Seven alternating rounds on the local Ryzen 9 7940HS compared the identity reconstruction with the compact graph, under the same fresh-output options used by normal compilation. Current-thread Linux PMU events counted user instructions and cycles. The wall clock and core frequency on this workstation were uncontrolled.

| Per checker invocation | Ordinary median | Packed median | Paired delta median | Paired delta range |
|---|---:|---:|---:|---:|
| Retired user instructions | 175,826,492 | 113,478,054 | −62,348,438 | −62,349,325 to −62,348,375 |
| User cycles | 83,086,599 | 45,187,220 | −37,899,379 | −56,051,741 to −5,699,976 |
| Minor faults | 6,617 | 4,694 | −1,923 | −1,923 to −1,923 |

The fresh-output phase’s graph and stream columns jointly occupied 42,899,858 privately resident bytes for the identity run and 30,788,956 for the packed run. This is a reduction of 12,110,902 bytes. A separate run enabling checker transition and region accounting appears under `real/replay-*.tsv`. Its stream representation and resident counts differ.

Across all fourteen fresh-output runs every surviving value, warning and diagnostic matched. All ordinary fallback member offsets and conversions matched. Each packed run relocated the 1,421 constant-warning IDs, had zero reports, and retained zero store effects, matching the identity run.

The independent ordinary `-c` capacity control under `real/summary.tsv` shows why the distinction between used bytes and reserved space matters. Shrinking SQLite’s capacity to its actual count reduced graph reservation from 142,250,971 to 62,362,321 bytes, while privately resident graph bytes changed by under 50 KiB. A separate 6,000-function generated input genuinely compiled 4,786 source windows. It reduced graph count from 25,200 to 10,842, with exact objects under ordinary, window and bounded-capacity runs.

## Reproduction

For the eight ordinary driver capacity runs, apply `source/column-sampler.patch` to Buster `875c08e9dd85c4c67bbe24a00e54bbe33f0890b5`, build with `./build.sh`, then run `source/compare.py RESULTS_DIR COMPILER` followed by the SQLite arguments in `source/replay.sh`. The script generates its deterministic 6,000-function source. The capacity override is for this premeasured experiment.

For the fresh-output replay, apply `source/storage-replay.patch` to Buster `84a7d3d76891d6c393497e62e6aff38f2b162fc2`, build with `./build.sh`, then run `source/replay.sh COMPILER SQLITE_DIR RESULTS_DIR`. The SQLite amalgamation SHA-256 is `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`. Measurements use Linux pagemap and perf_event_open with permission to count the current thread.

The per-column TSVs contain phase, group, column, capacity, live count, stride, resident bytes, exclusively resident bytes and resident bytes beyond the logical extent. Run `zstd -d real/sqlite-layout.bin.zst` followed by `python3 source/layout.py real/sqlite-layout.bin real/layout-reproduced.json` to reconstruct the dense remapping independently. The phase logs contain each invocation’s semantic check and raw counters.
