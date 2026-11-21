# Reuse conversion targets proved for selected roots

The warning proof produces both template bytes and conversion context. The source writer applies each closed expression’s mask to that context before emitting its entries. Three locked Ryzen 7 9700X rounds used fresh compilations of each input. Each round ran the public baseline, experimental build disabled and experimental build enabled in a symmetric order. Elapsed times and PMU counts came from separate invocations.

| Input | Fewer checker nodes | Identical native bytes | Enabled minus disabled (ms) | Enabled minus public baseline (ms) | Enabled minus disabled (M user instructions) |
| --- | ---: | ---: | ---: | ---: | ---: |
| sqlite | 13,744 | 4,512,453 | +11.2105 | +11.8350 | +59.410 |
| main | 9,016 | 3,906,526 | +18.6220 | +16.8345 | +101.526 |

The local controls matched on exit codes, object bytes and diagnostics in all 4,116 per-unit comparisons. The directed test exercised 4,096 inputs in each of four compilation policies and compared return values and side effects with Clang. The same-build and public comparisons include all source preparation and ordinary ELF output. [SQLite readings](sqlite/paired.tsv) · [Self-compile readings](main/paired.tsv) · [Local oracles](local-oracles.tar.xz) · [Source and build receipts](source-and-builds.tar.xz)
