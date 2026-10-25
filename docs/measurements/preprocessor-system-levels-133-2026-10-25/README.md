# System levels without the expansion history (#133, #117), 2026-10-25

The 9700X's measurements behind Buster's PR [#425](https://github.com/buster14a/buster/pull/425). In that PR, the
checker judges system headers' tokens from runs that the preprocessor's main loop keeps (`pp_system_levels`), rather
than from the expansion history, so the checker's driver defers the history as `-E` and `parse` do since #412
([record](../preprocessor-history-replay-117-2026-10-25/README.md)). Cited by `docs/c-preprocessor.md` ("System
levels").

## Sources and inputs

| Tree | Buster commit | Files | Source manifest's SHA-256 |
| --- | --- | ---: | --- |
| `main-7c428ce` | `7c428ce4cef554a564b7a99bbf3022ff0c8b2574` (main under #412) | 564 | `1d831c84eaf988e7ff961fcc6578867c98333f9a3f09764bca21cf7a3b4b55f3` |
| `cand-9d16823` | `9d16823f6dd76a43caebbb2c7fbce4e485e576bd` (#412's head, as merged) | 564 | `8d65b87116c1be90e262a6c571c46c1f4dcafcd2ab6c865c2d5427535b98c7ed` |
| `cand-4ef0652` | `4ef0652f71fbd7f59c86b48910f1a06242b9f2f1` (#425's code; its later commits change tests and docs) | 564 | `df99cf005766562b0387440c6d71f8d343016fd27543ca4c8ae14a6165cea769` |

Each `source-*.sha256` lists the SHA-256 of every file of `git archive` of the commit. All three trees were sent to the
host by `git archive`, and the host's files, apart from `build/`, match the manifests. Buster's `./build.sh` built each
one there (`logs/build14-*.txt`; main's build is in the replay's record). The `build/compiler` SHA-256s:

- `main-7c428ce`: `b85355b099ca0ff1297b014669efcdab2b047b9e9e660e4e32e5b7aaa06faf08`;
- `cand-9d16823`: `7cf4d2c938d4cc664824949283b5c5e300d22e5408415bb8c8644bf1576094a3`;
- `cand-4ef0652`: `a83077d1860748e84b4cda8caa8f9a506a909baa6b00d79bd017e53f8e37b723`.

The input is the 2026-10-23 acceptance's frozen `sqlite3.c` 3.53.2, from the bundle
`preprocessor-corpora-astra-01a158dd` (`sqlite3.c`: `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`).
It is compiled with the bundle's pinned headers: `-target x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc` and its
three `-isystem` directories (`scripts/args.sh`). `SOURCE_DATE_EPOCH=1792454400`; `CPATH`, `C_INCLUDE_PATH` and
`CPLUS_INCLUDE_PATH` are unset. The checker accepts the unit with no diagnostic (`logs/fs14-check.txt`, status 0), so
a deferred run never preprocesses it again.

Host: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, with the `performance` governor and energy preference.
`scripts/queue14.sh` ran everything below in order. Every run took the shared lock on its own, through
`~/buster-fast-bench/exclusive.sh` with `EXCLUSIVE_OWNER=claude-117` (`scripts/locked.sh`), pinned to CPU 2. The lock's
waiting messages, which name other sessions' runs, are removed from the logs; nothing else in them is changed.

## The main loop

`benchmark-preprocessor --only vectorized` (21 passes after a warm-up, medians) ran on the two trees by turns, four
rounds. Both record the history, as the benchmark does by default, and #425's also keeps its runs. A range is the
rounds' medians (`logs/ab14-*.txt`).

| Tree | Whole run | Directive tables | Main loop/setup | Instructions/input token |
| --- | ---: | ---: | ---: | ---: |
| `cand-9d16823` | 10.623-10.674 ms | 0.294-0.301 ms | 5.817-5.865 ms | 118.21 |
| `cand-4ef0652` | 10.583-10.643 ms | 0.295-0.298 ms | 5.786-5.852 ms | 118.16 |

## Whole drivers

`time-runs` ran under `ab` (Buster's `docs/profiling.md`, "Whole drivers"): five rounds with the trees' order rotating
by round, and in each round 21 processes of each command after a warm-up. Each process is timed from `fork` to
`wait4`, with its startup, page faults and teardown included. A range is the rounds' medians, and the spread is the
fastest and slowest single process over all rounds (`logs/drivers14-sqlite.txt`).

- Main records the history in all three commands.
- #412's head defers it in `-E` and `parse`.
- #425 also defers it in the checker's driver (`-fsyntax-only`).

| `sqlite3.c` | Tree | Wall time | Spread | Peak resident set | Minor faults |
| --- | --- | ---: | ---: | ---: | ---: |
| `-fsyntax-only` (the checker) | `main-7c428ce` | 149.626-150.277 ms | 148.674-151.237 ms | 590,708-590,748 KB | 1,787-1,788 |
| | `cand-9d16823` | 149.530-149.954 ms | 148.506-152.200 ms | 590,620-592,124 KB | 1,776-1,784 |
| | `cand-4ef0652` | **147.310-147.784 ms** | 146.622-148.766 ms | 588,576-588,616 KB | 1,414-1,415 |
| `-E -o /dev/null` | `main-7c428ce` | 20.729-20.952 ms | 20.412-21.420 ms | 62,640-62,740 KB | 1,012-1,014 |
| | `cand-9d16823` | 19.835-20.019 ms | 19.601-20.360 ms | 57,688-59,304 KB | 795-802 |
| | `cand-4ef0652` | 19.674-19.801 ms | 19.473-20.610 ms | 59,232-59,308 KB | 796-797 |
| `parse -fsyntax-only` | `main-7c428ce` | 19.622-19.703 ms | 19.386-20.166 ms | 143,824-143,852 KB | 1,284-1,285 |
| | `cand-9d16823` | 18.649-18.745 ms | 18.402-19.266 ms | 140,192-141,800 KB | 913-919 |
| | `cand-4ef0652` | 18.657-18.807 ms | 18.468-19.311 ms | 141,788-141,820 KB | 914-915 |

## Limitations

The data are medians of rounds from one machine, taken by turns while CI jobs and other sessions shared the machine
between runs. Different builds of the same code differ by up to about 1% from code placement alone (Buster's
`docs/profiling.md`, "Builds in turn"). The table's `-E` and `parse` rows are within that between #412's head and #425.
Only `sqlite3.c` was timed.
