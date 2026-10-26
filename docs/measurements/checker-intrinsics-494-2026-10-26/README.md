# Checker intrinsic lookup on frozen SQLite

2026-10-26, [buster #494](https://github.com/buster14a/buster/issues/494), on AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, Clang 23.1.1 and perf 7.2.9-1. Baseline `7e3782ada38379f972f244a5f6b89ed0b2d4ed4a`; candidate `09bd9df40cc4a5c9d57b9e54d98af9d1c840b1d3`. Both were built with `BUSTER_DEBUG_INFO=0 ./build.sh` under the shared lock. The exact binaries and frozen SQLite source are hashed in `sha256.txt`; the frozen `provenance/gnu17-pinned-predefines.txt` SHA-256 is `a39036d8215977b5a205f7fd3c4e7dfe6576b58eaa76a7bb0b0e214a164e8d33`.

Six pairs, always baseline then candidate, each process independently acquiring the shared lock and pinned to CPU 2. Other host work ran between some measurements. With `corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658`, the measured command for each binary was:

```sh
EXCLUSIVE_OWNER=codex-494-perf EXCLUSIVE_TITLE='Issue 494 SQLite measurement' \
EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/494 \
~/buster-fast-bench/exclusive.sh env -u CPATH -u C_INCLUDE_PATH SOURCE_DATE_EPOCH=1792454400 \
  taskset -c 2 bash -c 'TIMEFORMAT=%R; time "$@"' _ \
  perf stat -x, -e instructions:u,cycles:u,task-clock -o RUN.stat \
  COMPILER -fsyntax-only --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" \
  --clang-features --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc \
  -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" \
  -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c" >RUN.out 2>RUN.elapsed
```

All measured commands succeeded with empty standard output. `*.stat` contain raw perf counters; `*.elapsed` contain the lock's waiting notices where applicable, followed by bash's elapsed time in seconds. That time includes perf startup and is rounded to milliseconds. `task-clock` is the CPU time reported by perf, not wall time. Earlier attempts using an unsupported driver option and unavailable `/usr/bin/time` failed and are excluded.

| Median of six | Baseline | Candidate |
|---|---:|---:|
| User instructions | 1,690,248,149.5 | 1,620,998,370 |
| Task-clock | 147.00 ms | 143.275 ms |
| Elapsed (including perf startup) | 187 ms | 161.5 ms |

The instruction median is 4.10% lower and task-clock median 2.53% lower. Elapsed times span 151–191 ms baseline and 147–181 ms candidate, with wide overlapping ranges; six pairs do not establish a reliable wall-time improvement. The pairs are not randomized and were separated by other users of the shared host. This is one frozen translation unit and one build of each revision, not a general compiler speedup claim.
