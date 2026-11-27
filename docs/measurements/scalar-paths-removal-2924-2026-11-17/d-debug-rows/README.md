# DWARF line-program groups and tails on the 9700X

Issue #3454 covers the remaining scalar row writer. Native Release baseline `0a2c3034cf6093cda0f461e519ceb04484739259` groups four unmarked rows from the same file. A partial group, a prologue marker or a change of file can reach the scalar encoder. An experimental change encodes one through four rows with bounded loads and stores. It places the prologue marker immediately before the special opcode or copy, after any address and line advances.

Each tier compiled one SQLite, 34 Lua and 1,336 musl translation units with debug information. The census reconstructs the existing row grouping from GNU readelf’s raw line program. The last column counts mid-sequence file changes.

| Tier | Corpus | Functions | Total rows | Scalar rows | Four-row groups | Prologue markers | File changes |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 0 | lua | 1096 | 12846 | 3750 | 2274 | 1096 | 0 |
| 0 | musl | 2756 | 30273 | 8781 | 5373 | 2756 | 0 |
| 0 | sqlite | 2668 | 56462 | 8730 | 11933 | 2668 | 0 |
| 1 | lua | 639 | 29936 | 2188 | 6937 | 639 | 0 |
| 1 | musl | 1829 | 49592 | 8880 | 10178 | 1829 | 2137 |
| 1 | sqlite | 1388 | 160440 | 4612 | 38957 | 1388 | 0 |

The 9700X experiment times the complete line-program sizing and writing functions over 128 functions, at 36 sizes through 513 rows per function. Every one of the 180 cells produced identical bytes and size, including a 16-byte sentinel. Independently decoding 806 boundary batches and 4,096 mixed batches under ASan and UBSan also passed.

| Input shape | Sizes matching or beating baseline, median of three runs |
| --- | ---: |
| Ordinary special deltas without marks | 1 / 36 |
| One prologue marker per nonempty function | 8 / 36 |
| Marked, with occasional file changes | 22 / 36 |
| Marked, with a file change on every row | 0 / 36 |
| Wide LEB deltas, marked, with occasional file changes | 35 / 36 |

One ordinary row cost 1.505 times the baseline. Wide LEB rows benefited, but common special rows and file boundaries keep the original writer in production. The measurements time the line-program component and do not establish whole-compiler performance.

To reproduce, copy the baseline’s `src/buster/compiler/debug.c` to `base-debug.c`, apply `prototype.patch` and copy the updated file to `head-debug.c`. Extract the harness alongside both files and run `bash mini-run` under the shared exclusive lock with CPU 2 and native Release Clang 23.1.4. The five columns are shape, row count, baseline ticks, candidate ticks and their ratio. The standalone decoder uses `-O2 -march=native -fsanitize=address,undefined -fno-sanitize-recover=all`. [Results, census commands, prototype and fixtures](reproduce.tar.xz)
