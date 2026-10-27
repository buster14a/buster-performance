# The passes after checking on sqlite3.c, against main (#592)

Raw evidence for buster's `docs/compile-time.md` (buster14a/buster#592, its
PR): the C driver's `-c` of the frozen `sqlite3.c` by main and by the
PR's head, interleaved on the 9700X, with `--time-stages`' report of each stage
and perf's counters of the whole compile.

## Identity

- **Revisions** (buster):
  - main: `8ab9a2081de1f67ac6fb79325c8bfd3caf0f46a9`, the merge of PR #555;
  - head: `d4be6a47c0523d6cdf075377248684dfe384fc4f`, #592's branch with that
    main merged.
- **Trees:** each tree on the host is the same files as `git archive` of its
  commit, file by file by sha256 (`tree-main2.txt`, `tree-head.txt`, the build
  directory left out).
- **Host:** `benchpress`, an AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, every run under the
  host's lock and pinned to CPU 2 (`host.txt`).
- **Compilers:** each tree built with `BUSTER_DEBUG_INFO=0 ./build.sh` (clang 23.1.1,
  `-O3 -march=native`), as the 9700X job builds (`compilers.txt`, `builds.txt`).
- **Source:** `sqlite/sqlite3.c` of the frozen corpus
  `preprocessor-391e729af658`, sha256
  `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`, with the
  host's default headers.
- **Date:** 2026-10-27.

## Commands

`run-final.sh` builds both trees, each in a hold of the lock of its own, then
runs `ab.sh final 15 main2 head` in one hold (with `PERF_ROUNDS=4`). The options
are #518's step's:

```sh
-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c"
```

- **Objects:** each build wrote the object by default and with `--scalar`;
  all four are the same bytes (`objects.txt`).
- **Stages:** 15 rounds of `--time-stages`, each build once a round, the order
  rotating by round (each build first in 7 or 8 rounds).
- **Counters:** 4 rounds of `perf stat -x, -r 3 -e instructions:u,cycles:u` of
  each build's default compile, in turn: 12 runs of each.
- `summary.sh` computes the medians.

## Results

Medians of the 15 rounds (`summary.sh final main2 head`), and each stage's
range:

| | main | head | change |
| --- | ---: | ---: | ---: |
| `check-declarations` | 5.350 ms (5.192 to 5.590) | 2.895 ms (2.814 to 3.007) | -45.9% |
| `static-data` | 1.522 ms (1.455 to 1.552) | 0.446 ms (0.425 to 0.461) | -70.7% |
| `select` | 1.390 ms (1.315 to 1.443) | 0.881 ms (0.851 to 1.004) | -36.6% |
| `emit-setup` | 1.426 ms (1.404 to 1.477) | 1.240 ms (1.209 to 1.277) | -13.0% |
| the clock's span | 146.656 ms (145.862 to 147.246) | 142.028 ms (141.313 to 143.096) | -3.2% |
| user instructions | 1,555.99 M in every round | 1,452.81 M in every round | -6.6% |
| user cycles | 692.5 M (690.5 to 695.6) | 667.9 M (665.2 to 670.2) | -3.6% |

The counters are the mean of the 4 rounds' `perf stat -r 3` means, with the
rounds' range.

## Files

- `ab.sh`, `run-final.sh`, `summary.sh`, `collect.sh`: the scripts.
- `stages.txt`: every `--time-stages` report, each line prefixed by its build and round.
- `stat.txt`: perf stat's CSV lines, each prefixed by its build and round.
- `objects.txt`, `compilers.txt`, `builds.txt`, `host.txt`, `tree-main2.txt`, `tree-head.txt`: the identities.
- `run.log`: the scripts' own lines. exclusive.sh's messages about other
  holders of the lock are left out: they name other sessions' commands and links.
