# Ryzen 7 9700X measurements for PR 3648

[3648](https://github.com/buster14a/buster/pull/3648) at `d5dfb65a16e6e6bab2fb19b5878c20c1a1bb1a5a` versus merge base `8e4d32879e17b7d9548cad54257a2f8461328366`.

| SQLite compile mode | Median wall, base → head | Median user cycles, base → head | Object bytes |
| --- | ---: | ---: | --- |
| Default | 15.320 → 15.284 ms (-0.23%) | 76.4M → 76.2M (-0.26%) | Match |
| --no-direct | 112.765 → 112.680 ms (-0.08%) | 547.8M → 546.5M (-0.24%) | Match |

Using the pinned C suite and Benchpress's GNU as 2.47, one native `test-assembly-output --cross-check` run passed all 440 C-suite round trips and all 8,948 instruction-form record comparisons. It reported 20 failures among 888 checks in debug-object comparisons, at 1.605 s task-clock and 4.820B user cycles.

The TLS fixture's retained object inspection showed why the comparator rejected a relocation at offset 8. The native assembler defaults to compressed DWARF, and the comparator read the compression header bytes as part of the relocation field. The exact same assembly on Debian GNU as 2.44 emitted uncompressed `.debug_info`. The Debian reassembly was a diagnostic check outside Benchpress.

A second native sample with `as --compress-debug-sections=none` passed all 888 checks, all 440 C-suite round trips, and all 8,948 instruction-form record comparisons. That sample used 1.877 s task-clock and 5.565B user cycles.

[Measurement protocol](../README.md) · [Raw data and logs](raw.tar.gz)
