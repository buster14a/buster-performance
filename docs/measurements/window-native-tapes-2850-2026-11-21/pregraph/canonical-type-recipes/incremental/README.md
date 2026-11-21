# Incremental source type preparation on the Ryzen 7 9700X

The source checker needs the address, decay, array and qualifier results available at each window. The original experiment prepared these by copying and scanning the canonical types at each window. The incremental version records links as types first become available and journals changes to restore the original state when the window ends. Both modes run in one compiler image built from 84a7d3d76891d6c393497e62e6aff38f2b162fc2 and the included patch.

| Corpus | Swept records | Preparation, copy → incremental | All three intervals, copy → incremental | Median paired change, all three |
| --- | ---: | ---: | ---: | ---: |
| SQLite | 326,224 | 795.03 → 35.76 | 1,037.73 → 271.65 | −766.17 |
| Lua | 96,660 | 343.12 → 74.25 | 678.25 → 420.13 | −259.47 |
| musl | 676,522 | 363.04 → 89.72 | 723.67 → 482.75 | −242.57 |

Units are invariant TSC ticks per swept source record. Each observation sums the counts and interval ticks across a full corpus before dividing. Seven alternating ABBA/BAAB rounds on locked CPU 2 yielded 84 observations. The table gives medians of the seven within-round two-observation means for each image mode and the median of the seven paired differences. Preparation and the three intervals together improved in all seven rounds on each corpus. In musl the checking/capture and finish intervals increased by 10.74 and 19.77 ticks per swept record. Lua finish increased by 7.49.

Every observation checked the same source selections, type keys, checked values, native entries and call arguments in the reference comparison. The complete non-timing witness for each corpus hashed identically across the two modes. The native comparisons reached 28,440 SQLite, 5,092 Lua and 8,151 musl roots with zero differences. See [the per-corpus counts and hashes](oracle.tsv).

The timed entry point is the instrumented shadow measurement. These figures cover preparation, checking/capture and finish in that producer. The issue's fresh-process object compile, hardware cycles per token and independent wall time require their own measurements. The later VLA address correction for ordinary object emission is outside the measured patch.

[Paired results](pairs.tsv) · [All observations](samples.tsv) · [Raw counters and receipts](raw-counters.tar.xz) · [Source patch](source.patch) · [Locked host protocol](locked.sh) · [Build identity](revision.txt) · [Host](host.txt)

To reduce the archived observations, extract raw-counters.tar.xz into an empty directory and run `python3 reduce.py RAW_DIRECTORY OUTPUT_DIRECTORY links`. The host script records the campaign's input and lock paths.
