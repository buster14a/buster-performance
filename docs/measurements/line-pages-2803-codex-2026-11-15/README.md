# PR 2855 preliminary Benchpress measurements

2026-11-15, Ryzen 7 9700X, Clang 23.1.4, Release. Base `6c59018e4df9dc4b3a77adac524fedba90a83048`, PR head `2f3a6dea386acbe50816da0e2b2cc195ec8423df`. Frozen SQLite input SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`. Each invocation held the shared lock and pinned CPU 2; the command and host process snapshots are in the logs. Seven measured repetitions per variant, with one warmup, not interleaved across variants. Scalar was run base then PR; vector PR then base.

| Host | Base median wall ms | PR median wall ms | Base check-program ms | PR check-program ms |
| --- | ---: | ---: | ---: | ---: |
| x86-64 | 475.060 | 400.219 | 140.257 | 64.423 |
| znver5 | 123.299 | 124.111 | 23.133 | 23.296 |

## One backward lookup

The temporary `line-bench-snippet.c` was inserted in both revisions' `c_preprocessor_test.c`, gated by `BUSTER_LINE_BENCH` at the start of `run_preprocessor_fixture_tests`, and the scalar Release executables rebuilt. The harness sets the cursor to the file end, clears the line index and times one `pp_line_of` call on the same frozen SQLite bytes. Each offset has one warmup and 21 repetitions, with index arena storage reused and reset between calls; the reported line is verified against `pp_count_lines`. Base was measured before the candidate. The 20 ns result is at timer resolution; the candidate does a full index build on each call.

| Offset in 9,507,037-byte file | Base median | PR median |
| --- | ---: | ---: |
| 0 | 20 ns | 4.020 ms |
| 4,753,518 | 1.768 ms | 4.100 ms |
| 9,507,036 | 3.585 ms | 4.087 ms |

These comparisons use the PR's original base, not a current-main merge candidate.
