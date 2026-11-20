# Count sparse operations when sizing Tier 1 emission

[Buster PR #3124](https://github.com/buster14a/buster/pull/3124) combines repeated record, reference, literal and branch-capacity scans into one pass over 64 operation bytes at a time. It consults call descriptors only for call nodes. The largest source-level comparison uses a one-lane `--tier1 -O2 -march=znver5` compilation of SQLite 3.53.2, with Lua 5.4.8’s parser and VM and a Tier 0 SQLite control.

| Workload | Parent instructions | Candidate instructions | Median within-pair change |
| --- | ---: | ---: | ---: |
| SQLite Tier 1 | 7,852,200,508 | 7,825,525,740 | −0.340% |
| Lua parser | 151,670,067 | 151,194,180 | −0.314% |
| Lua VM | 301,646,446 | 300,987,020 | −0.219% |
| SQLite Tier 0 | 1,174,791,680 | 1,174,792,198 | +0.000% |

Each of the eight measured pairs reduced Tier 1 instructions. Local SQLite cycle changes ranged from −2.55% to +1.70%, with a median of −0.366%. Lua’s median cycle counts rose on this host. A separate simpler prototype collected the counts inside the original scalar planning traversal and saved 0.152% of SQLite instructions. That implementation was left out of the PR. These samples are from a Ryzen 9 7940HS. Locked Zen 5 timing is pending.

The complete frozen musl sweep produced 1,336 byte-identical object pairs. All four timed workload object digests matched. The six backend suites cover 220,235 fragment-emission checks, 1,378,382 selection checks, the existing 5,425-plan digest, native differential execution, register masks, liveness and wide integers. An explicit reserve test checks repeated descriptor references, a covered call, code and inline-assembly branches, stack probes, a complete 64-lane chunk and its partial tail.

Both compilers were built with the repository-pinned Clang 23.1.4, `BUSTER_HOST_ARCH=znver5 ./build.sh --config Release`. The counter table includes warmup round zero and eight alternating measured rounds. The summaries report medians of paired ratios and their full ranges. To reproduce the local acquisition, run `python local-compiler-pair.py normal PARENT HEAD RESULTS sparse --inputs INPUT_ROOT`, with `inputs/sqlite3.c` and `inputs/lua/` under INPUT_ROOT. Raw per-process samples, SHA-256 digests, output sizes and before/after load readings are included.
