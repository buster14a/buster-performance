# Carrying operands through the lookup lists

Packing each lookup’s destination and first operand into a 32-bit list entry reduced the five-round SQLite lean median from 28.365 to 27.470 cycles per taken identifier or lookup. The median within-round change was −1.250, with all five rounds between −1.350 and −0.590. The unsubtracted pass, including the given records, also improved in every round, by a median of 0.610 cycles per window record. The Step 1 budget is 10 cycles per taken leaf or lookup.

| Input | Mode | Six-op dispatch | Operand pair | Compress by key | Conflict scatter | 16-bit lists |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| sqlite | whole | 29.260 | 28.690 | 31.275 | 29.470 | 29.400 |
| sqlite | lean | 28.365 | 27.470 | 29.455 | 28.640 | 27.580 |
| lua | whole | 22.720 | 21.930 | 23.545 | 22.840 | 22.130 |
| lua | lean | 22.260 | 21.455 | 22.045 | 22.310 | 21.545 |
| musl | whole | 20.065 | 19.215 | 20.955 | 20.075 | 19.970 |
| musl | lean | 18.995 | 18.655 | 19.275 | 18.990 | 18.685 |

Each candidate pays for list construction inside the kernel. The operand pair stores the window-relative destination and left operand together. Group compression uses one vector compress for each key present in a block. Conflict scatter computes the position within a repeated key before scattering the batch entries. The 16-bit variant lists 32 positions per vector block. Whole mode materializes the conversion record. Lean mode independently verifies the conversions it can derive. All 300 processes reported zero record, list, decoy or failure differences, including the unchanged taken counts for each corpus and mode.

Ryzen 7 9700X CPU 2 ran five symmetric rotations. Each round ran the five executables forward and backward, on each corpus in both modes. Each process ran five passes. The table shows the median of the five round means. The kernel metric subtracts a copying-only pass from the given-records-plus-kernel pass. The full and copying-only observations per window record are published separately because the subtraction can affect cross-build comparisons, especially on short units. Earlier Step 1 work describes the normalization. [Measurement contract](https://github.com/buster14a/buster/blob/f4f8dd9a1663adbdcd1c222e7375f3517d9e47ae/docs/one-core-path.md#the-figures-are-a-difference-of-two-passes-2872)

The exact compiled patches, compiler hashes, input commands, schedules, every observation and paired ranges accompany the record. [Build receipts](builds.tsv) · [Individual samples](samples.tsv) · [Paired differences and ranges](paired.tsv) · [Original command output](measurements.tar.xz)
