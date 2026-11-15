# PR 2854 preliminary Benchpress object sizes

2026-11-15, Ryzen 7 9700X, Clang 23.1.4, Release znver5. Base `6c59018e4df9dc4b3a77adac524fedba90a83048`, PR head `539c0d01bd83e2d48f44012f0e2585a4de3ef914`; c-testsuite `5c7275656d751de0e68b2d340a95b5681858ed07`. The scripts and logs retain the commands, output and host snapshots. Both campaigns held the shared host lock and used CPU 2. Section sizes sum all sections whose names begin with `.rodata`, `.data`, or `.bss` respectively.

All 220 declared subset files compiled with each compiler. Aggregate bytes, base and PR respectively: rodata 4060 / 4060, data 1726 / 1726, bss 2248 / 2248; Clang 4456, 1790, 2244. For frozen SQLite, base and PR both have rodata 61341, data 19944, bss 1137; Clang has 61737, 20384, 1140. These inputs show no reduction from the PR; they do not replace its regression fixture. This is the original base and head, not a current-main merge candidate.
