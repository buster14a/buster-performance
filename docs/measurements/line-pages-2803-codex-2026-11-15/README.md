# PR 2855 preliminary Benchpress measurements

2026-11-15, Ryzen 7 9700X, Clang 23.1.4, Release. Base `6c59018e4df9dc4b3a77adac524fedba90a83048`, PR head `2f3a6dea386acbe50816da0e2b2cc195ec8423df`. Frozen SQLite input SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`. Each invocation held the shared lock and pinned CPU 2; the command and host process snapshots are in the logs. Seven measured repetitions per variant, with one warmup, not interleaved across variants. Scalar was run base then PR; vector PR then base.

| Host | Base median wall ms | PR median wall ms | Base check-program ms | PR check-program ms |
| --- | ---: | ---: | ---: | ---: |
| x86-64 | 475.060 | 400.219 | 140.257 | 64.423 |
| znver5 | 123.299 | 124.111 | 23.133 | 23.296 |

This does not measure the single-backward-lookup case. These comparisons use the PR's original base, not a current-main merge candidate.
