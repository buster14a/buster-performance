# PR 2854 preliminary Benchpress object sizes

2026-11-15, Ryzen 7 9700X, Clang 23.1.4, Release znver5. Base `6c59018e4df9dc4b3a77adac524fedba90a83048`, PR head `539c0d01bd83e2d48f44012f0e2585a4de3ef914`; c-testsuite `5c7275656d751de0e68b2d340a95b5681858ed07`. The scripts and logs retain the commands, output and host snapshots. Both campaigns held the shared host lock and used CPU 2. Section sizes sum all sections whose names begin with `.rodata`, `.data`, or `.bss` respectively.

All 220 declared subset files compiled with each compiler. Aggregate bytes, base and PR respectively: rodata 4060 / 4060, data 1726 / 1726, bss 2248 / 2248; Clang 4456, 1790, 2244. For frozen SQLite, base and PR both have rodata 61341, data 19944, bss 1137; Clang has 61737, 20384, 1140. These inputs show no reduction from the PR; they do not replace its regression fixture. This is the original base and head, not a current-main merge candidate.

## Merged candidate

The comparison was repeated against main `807bcc14b0f79b7c9c1963bf70e5c8619725a406` and the tree of merge commit `bb21331e2b0aa2e31c9b3d27e860ecc5b6ed800b`. The tested worktree's binary diff from the PR's original head and the commit's diff had identical SHA-256 `771a03f62f34085027de6ab27c203a2f66c06346d73af8a83b0973c8fcab8eeb`. The same 220 files compiled with all three compilers and yielded the same per-compiler aggregate section sizes as above; SQLite's section sizes also matched the earlier comparison. The shared-lock owner link for the subset run had a mistyped PR number (`2852854`); the command's title and this record identify PR 2854. The SQLite run used the correct link.
