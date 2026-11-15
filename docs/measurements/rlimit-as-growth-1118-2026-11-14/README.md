# Arenas grow in place under a finite RLIMIT_AS (#1118), 2026-11-14

Evidence for [buster#1118](https://github.com/buster14a/buster/issues/1118) and its pull request,
[buster#2812](https://github.com/buster14a/buster/pull/2812). By Claude in David's directed session
([the session](https://claude.ai/code/session_01NNmNQtNx5pKNvksed8tTcd)).

Under a finite `RLIMIT_AS`, every arena held at most a 128th of the limit. A 130-line program that includes 45 libc
and POSIX headers needed 4 to 5 GiB, where clang needs less than 1. The pull request does three things:
- An arena whose request is past its share grows in place, in a 16 GiB slot of its own from 17 TiB
  (`arena_reserve_growing`, `arena_grow`).
- Memory failures are fatal errors that name the limit, never errors at a token.
- Under a limit, the default lanes are those the limit affords (`check_driver_address_lanes`).

## Revisions

| Role | What |
| --- | --- |
| base | `main` at `2ebfe68`, the branch's merge-base |
| head | `601875a` (`claude/keen-hypatia-afeao9`), the pull request's code |

Both were built on the 9700X by their own `./build.sh --config Release` with `BUSTER_HOST_ARCH=znver5`, each build one
hold of the lock (`scripts/setup.sh`). `9700x/sha256.txt` has the executables' and `sqlite3.c`'s hashes, and
`9700x/log.txt` the times.

## 1. The path without a limit, on the 9700X

`scripts/measure.sh`: head's `measure-compile --runs N --reference compiler-base -- ARGS`, pinned to CPU 2 (`taskset -c
2`, so one lane), one hold of the lock per input. The processes run in a Williams order with the default's
`--time-stages` variant. Each file in `9700x/` starts with the lock holder's line, the busiest processes and
`/proc/loadavg`, and ends with `/proc/loadavg`.

| Input (`-c`) | Runs | head median wall | base median wall | head / base | user instructions, head / base | minor faults, head / base |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `hello.c` (an empty `main`) | 41 | 0.528 ms | 0.533 ms | 0.99 | 581,113 / 580,333 (+780, +0.13%) | 325 / 317 |
| `sys.c` (the issue's program, 80,195 tokens) | 31 | 15.848 ms | 15.930 ms | 0.99 | 170.6 M / 170.6 M | 2003 / 1997 |
| `sqlite3.c` (`-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0`, 693,112 tokens) | 21 | 118.918 ms | 118.931 ms | 1.00 | 1318.9 M / 1318.9 M | 6840 / 6831 |
| `sys.c` under `ulimit -v 6291456` (6 GiB, which both compile within; head grows, base takes its 48 MiB shares) | 31 | 15.856 ms | 15.984 ms | 0.99 | 170.6 M / 170.6 M | 2004 / 1997 |

The ranges are in each file's `median of N` lines: for example `sys.c` head 15.595 to 16.091 ms and base 15.744 to
16.037 ms. The empty unit's 780 more instructions (+0.13%) are the new branches in `arena_reserve_policy`,
`arena_commit` and `arena_release` and the code's placement. Its 8 more minor faults and 292 KiB more `wait4` peak
weren't traced. `sys.c` had 6 more faults and a 112 KiB lower peak, and `sqlite3.c` 9 more faults and 56 KiB more.

As the `sqlite3.c` hold took the lock, `exclusive.sh` listed one other busy process, a `sha256sum` 0 seconds old on CPU 2
(the previous holder's last step). Its medians match the base's to 0.013 ms.

## 2. The thresholds, in a cloud container

Not the 9700X: this session's container (4 CPUs, Linux 6.18, an AVX-512 Xeon), with Release builds of base and of
the head's code at the same commits. These are pass/fail limits, not timings.

`./build/compiler -o x inputs/sys.c -lm` under `ulimit -v`, three runs at each limit, all alike:

| `ulimit -v` | base | head |
| --- | --- | --- |
| 320 MiB | `can't reserve memory for checking` | `out of memory for the parser`, note naming `RLIMIT_AS` |
| 400 MiB | `out of memory for the parser` | `checker input capacity exhausted`, note |
| 448 MiB to 1 GiB | `out of memory for the parser` | compiles and links |
| 2 GiB | `can't reserve type table` | compiles and links |
| 3 to 4 GiB | `checker input capacity exhausted` | compiles and links |
| 5 and 6 GiB | compiles and links | compiles and links |

Head, in 8 MiB steps from 280 to 432 MiB: every run exits with status 1, one fatal error and `RLIMIT_AS` named, and no
error placed at a line of `sys.c`. From 440 MiB it compiles and links. The executable's image is 279 MiB. Under a 1 GiB
limit, head maps 207 MiB at its peak (`strace -f` of `mmap`, `munmap` and `brk`).

The lanes' share, on a generated unit of 2,000 functions (the pull request's `check_test_driver_address_limit`
fixture, `inputs/address-limit.py`), `-c`, five runs at each limit and lane count, with the head's code before
`check_driver_address_lanes`:

| Lanes | 700 MiB | 800 MiB | 900 MiB | 1047 MiB |
| --- | --- | --- | --- | --- |
| `--lanes 1` | 5/5 | 5/5 | 5/5 | 5/5 |
| `--lanes 2` | 0/5 | 5/5 | 5/5 | 5/5 |
| `--lanes 4` | 0/5 | 0/5 | 3/5 | 5/5 |
| default (4 CPUs) | 0/5 | 0/5 | 2/5 | 5/5 |

With `check_driver_address_lanes`, the default passed 5/5 from 700 MiB. The first version of the growth doubled each
arena's mapping, as `arena_commit` doubles its commits. That passed only 5 of 6 runs at 1047 MiB, failing when two lanes
grew at once near the limit, so growth takes a quarter instead.
