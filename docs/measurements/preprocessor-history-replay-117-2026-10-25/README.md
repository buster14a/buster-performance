# Deferred expansion history (#117), 2026-10-25

The 9700X's measurements behind Buster's [#117](https://github.com/buster14a/buster/issues/117) PR that records the
preprocessor's expansion history only when something asks for it (`PPOptions.defer_history`), cited by
`docs/c-preprocessor.md` ("Deferred history"). `-E` and `parse` defer the history; the checker's driver still records
it. #115 budgets 2 ms for `sqlite3.c`'s directive tables plus main loop and setup; the main loop's fast paths
([record](../preprocessor-main-loop-117-2026-10-25/README.md)) left 6.09-6.12 ms.

## Sources and inputs

| Tree | Buster commit | Files | Source manifest's SHA-256 |
| --- | --- | ---: | --- |
| `main-7c428ce` | `7c428ce4cef554a564b7a99bbf3022ff0c8b2574` (main, with #410) | 564 | `1d831c84eaf988e7ff961fcc6578867c98333f9a3f09764bca21cf7a3b4b55f3` |
| `cand-a964539` | `a964539507c68228c5b6720e4fc42ae7b7d0a15b` (the PR's commit, on that main) | 564 | `cc7788d3aacd3d0af94acc578d010f0314c856a65b213527cbae23b95f0f6237` |

Each `source-*.sha256` lists the SHA-256 of every file of `git archive` of the commit. Both trees were sent to the
host by `git archive`; the host's files but `build/` match the manifests. Buster's `./build.sh` built each there
(`logs/build13-*.txt`). The `build/compiler` SHA-256s: `main-7c428ce`
`b85355b099ca0ff1297b014669efcdab2b047b9e9e660e4e32e5b7aaa06faf08`, `cand-a964539`
`4271bcdaabe61bdd755b7991ad4e9c3141495c311a1b3111cdb82c85b7053778`.

Inputs, the 2026-10-23 acceptance's frozen ones, as in the main loop's record (`scripts/args.sh`):

- `sqlite3.c` 3.53.2 from the bundle `preprocessor-corpora-astra-01a158dd` (`MANIFESTS.sha256`:
  `391e729af6587355050881752558e790299cfe638c7dc7803bd028a8535ebcbd`; `sqlite3.c`:
  `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`), with the bundle's pinned headers:
  `-target x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc` and its three `-isystem` directories.
- `main.c` of Buster at `635434f2a4d153c6de1dd2f1149055c4507c6f46`, with the system's headers:
  `-march=native -std=gnu17 -I <tree>/src -fwrapv -funsigned-char`.
- `SOURCE_DATE_EPOCH=1792454400`; `CPATH`, `C_INCLUDE_PATH` and `CPLUS_INCLUDE_PATH` unset.

Host: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, the `performance` governor and energy preference. Every
build and run took the shared lock on its own, through `~/buster-fast-bench/exclusive.sh` with
`EXCLUSIVE_OWNER=claude-117` (`scripts/locked.sh`), pinned to CPU 2. `scripts/queue13.sh` ran everything below in
order. The lock's waiting messages, which name other sessions' runs, are removed from the logs; nothing else in them
is changed.

## Recording the history: main against the PR

`benchmark-preprocessor --only vectorized` (21 passes after a warm-up, medians), the two trees by turns: four rounds
on `sqlite3.c` and three on `main.c`. Both record the history, as the checker's driver does. A range is the rounds'
medians.

| Input | Tree | Whole run | Directive tables | Main loop/setup | Instructions/input token |
| --- | --- | ---: | ---: | ---: | ---: |
| `sqlite3.c` | `main-7c428ce` | 10.579-10.624 ms | 0.294-0.296 ms | 5.790-5.829 ms | 118.75 |
| `sqlite3.c` | `cand-a964539` | 10.624-10.691 ms | 0.295-0.299 ms | 5.837-5.873 ms | 118.21 |
| `main.c` | `main-7c428ce` | 34.310-35.460 ms | 0.275-0.284 ms | 25.449-26.575 ms | 326.03 |
| `main.c` | `cand-a964539` | 34.305-34.741 ms | 0.286-0.287 ms | 25.453-25.828 ms | 321.86 |

`logs/ab13-*.txt`. Both trees record the same history and do the same work (each log's history bytes, records and
per-pass statistics are the same for both). The PR's tree runs fewer instructions, from clang's code for the functions
it changes, and the same times within two builds' placement noise (Buster's `docs/profiling.md`, "Builds in turn").

## Recording against deferring, one build

`benchmark-preprocessor --history-cost` on `cand-a964539`: the vectorized kernels recording the history and with it
deferred (`PPOptions.defer_history`; neither input has a diagnostic, so the deferred runs record none), by turns in
each pass; four processes on `sqlite3.c` and three on `main.c`. `logs/hc13-*.txt`.

| Input | Run | Whole run | Directive tables | Main loop/setup | Instructions/input token |
| --- | --- | ---: | ---: | ---: | ---: |
| `sqlite3.c` | recording | 10.552-10.568 ms | 0.287-0.300 ms | 5.761-5.797 ms | 118.21 |
| `sqlite3.c` | deferred | 9.757-9.773 ms | 0.288-0.294 ms | 4.983-5.015 ms | 109.70 |
| `main.c` | recording | 34.382-34.488 ms | 0.284-0.287 ms | 25.548-25.690 ms | 321.86 |
| `main.c` | deferred | 29.937-29.997 ms | 0.284-0.286 ms | 21.144-21.207 ms | 283.38 |

## Whole drivers

`time-runs` under `ab` (Buster's `docs/profiling.md`, "Whole drivers"): five rounds, the trees in an order that rotates
by round, each round 21 processes of each command after a warm-up, each process timed from `fork` to `wait4`, its
startup, page faults and teardown included. Main's `-E` and `parse` record the history; the PR's defer it.
`logs/drivers13-sqlite.txt`; a range is the rounds' medians.

| `sqlite3.c` | Tree | Wall time | Peak resident set | Minor faults |
| --- | --- | ---: | ---: | ---: |
| `-E -o /dev/null` | `main-7c428ce` | 20.717-20.877 ms | 62,644-62,724 KB | 1,012-1,014 |
| `-E -o /dev/null` | `cand-a964539` | 19.653-19.707 ms | 59,324-59,340 KB | 797 |
| `parse -fsyntax-only` | `main-7c428ce` | 19.631-20.123 ms | 143,820-143,856 KB | 1,284-1,286 |
| `parse -fsyntax-only` | `cand-a964539` | 18.671-18.965 ms | 141,804-141,812 KB | 911-912 |

## Limitations

Medians of rounds from one machine, by turns, in sessions that shared the machine with CI jobs and another session
between runs. `main.c` has build-dependent speed states (Buster's `docs/profiling.md`): main's first round there,
26.575 ms, is one. The whole drivers' times include writing `-E`'s text to `/dev/null` and the parse.
