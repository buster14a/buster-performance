# Pooled arenas keep their commits and take the closest fit (#1128), 2026-11-02

Evidence for buster14a/buster#1128's pull request: the units lanes' arena pool
(`lane.c`) keeps a released arena's committed prefix writable and gives a
reservation the smallest pooled mapping that holds it, where main
reprotected every pooled arena and matched only exact capacities.

## Source revisions and trees

- main: `3ce71ec312efb45fbcab4d66775e069e30d7e513` (buster14a/buster `main`).
- head: `d415aa31182908830d544a3fb93ff633f36475bc` (branch
  `claude/solve-1128-c4f158`), one commit on main.

Each tree is `git archive` of its commit, sent to the 9700X by tar.
`trees/manifest-*.txt` are the archives' `sha256sum`s, made before sending,
and `logs/host-manifest-*.txt` the host's of the same trees before building
(build output excluded). The two hosts' `sort` orders differ, so
`run.sh`'s byte comparison printed "MANIFEST DIFFERS" in `logs/receipts.txt`;
sorted by path they are identical (`logs/manifests-compared.txt`, 1,033 files
each).

Both were built with `BUSTER_DEBUG_INFO=0 ./build.sh` (`-march=native`, which
is znver5 there), each in its own hold of the host's lock
(`logs/build-*.log`). `logs/receipts.txt` has the executables' `sha256sum`s.

## Host

The Ryzen 7 9700X (`logs/receipts.txt`): Linux 6.18.50-2-lts, clang 23.1.1,
strace 7.2, `vm.overcommit_memory` 0, transparent huge pages `always`. CPU 2's
governor and EPP are `performance`; CPUs 0, 1 and 3 to 7 are `powersave` with
`balance_performance`. The lanes' runs use CPUs 0 to 7, one per core; the
single-file run uses CPU 2.

## Commands

`scripts/run.sh` builds the trees, then holds the lock once for
`logs/measure.sh`, which runs, with main's executable driving `time-runs`
(whole processes, the builds interleaved in a rotating order, one warm-up):

- Lua 5.4.8's 33 units but `luac.c` (`logs/lua-sources.txt`) linked with
  `-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -w --lanes N -o lua *.c -lm
  -ldl`, N 1, 2, 4 and 8, 11 runs each, `taskset -c 0-7` (`logs/lua.log`);
- synth's 512 units of 200 functions (`test-check-units --generate`, made by
  main's executable; `logs/synth-sources.txt`) linked by `--lanes 1` and `8`,
  5 runs each, `taskset -c 0-7` (`logs/synth.log`);
- the frozen corpus's `sqlite3.c` by `-c` alone, with its pinned
  predefines and headers as the 9700X workflow passes them, 11 runs,
  `taskset -c 2` (`logs/sqlite.log`; the file's `sha256sum` in the receipts);
- `strace -f -c` of each build's Lua link by 1 and 4 lanes
  (`logs/strace-*.txt`).

Every timed process's line, with its exit status, is in its log; all 130 of
them exited 0, as did every step (`logs/receipts.txt`).

## Results

Medians, milliseconds (`time-runs`' wall time; system time from its rusage):

| command | main | head | head against main | system ms, main → head |
| --- | ---: | ---: | ---: | ---: |
| Lua, 1 lane | 82.209 | 77.218 | -6.07% | 22.4 → 15.8 |
| Lua, 2 lanes | 52.234 | 48.105 | -7.90% | 29.6 → 20.2 |
| Lua, 4 lanes | 42.049 | 35.257 | -16.15% | 54.5 → 46.9 |
| Lua, 8 lanes | 41.939 | 33.245 | -20.73% | 100.4 → 75.0 |
| synth, 1 lane | 1,730.245 | 1,675.022 | -3.19% | 359.4 → 275.5 |
| synth, 8 lanes | 615.921 | 507.927 | -17.53% | 1,465.8 → 813.6 |
| `sqlite3.c -c`, CPU 2 | 116.703 | 116.660 | -0.04% | 16.6 → 20.0 |

User instructions: Lua +0.1 to +0.2%, synth +0.04 to +0.08%, `sqlite3.c`
+3,381 (1,256,650,068 → 1,256,653,449). User cycles on 8 lanes rose 3.3 to
3.5% while the wall time fell. Peak RSS (`wait4`, which includes the parent's
pre-exec memory) is within 0.3% but on Lua's 8 lanes, 204,228 → 207,140 KiB
(+1.4%), and synth's 8, 528,868 → 532,552 KiB (+0.7%).

System calls of the Lua link (`strace -c`, which inflates their cost):

| | main, 1 lane | head, 1 lane | main, 4 lanes | head, 4 lanes |
| --- | ---: | ---: | ---: | ---: |
| `mprotect` | 5,122 | 195 | 5,270 | 615 |
| `madvise` | 2,913 | 2,438 | 3,341 | 2,914 |
| `mmap` | 624 | 149 | 866 | 438 |
| `munmap` | 604 | 129 | 842 | 412 |
| `prlimit64` | 2,178 | 17 | 2,234 | 19 |
| all | 12,993 | 4,488 | 16,236 | 8,178 |

## Exploratory rounds

Before the commit existed, trees copied from the session's worktree (not
`git archive`) were measured the same way; their logs are in
`exploratory/`, with the scripts that ran them in `scripts/` and
`exploratory/inner-*.sh`.

- `measure-a1.log` (`scripts/measure.sh`): main against `head1-wip`, whose
  `lane.c` is byte for byte the head commit's (`sha256`
  `b54393dc04a7ffe213acd6190093f85d112ec40f6145b7c6703a090ad41fb42b`);
  Lua by 1, 2, 4 and 8 lanes: -5.69, -9.44, -14.70 and -21.63%.
- `measure-b1.log` (`scripts/run-b1.sh`, `scripts/measure3.sh`): main,
  `head1-wip` and `head2-wip`, which adds `exploratory/memset-variant.patch`:
  a pooled arena whose pushes wrote at most 1 MB kept its pages and was
  cleared by `memset` when the pool handed it out again, rather than
  discarded with `MADV_DONTNEED`. `head1-wip` was -5.53, -9.19, -14.70 and
  -20.57%; `head2-wip` -6.85, -8.41, -10.35 and -14.60%, with 2.4, 5.9 and
  14.8% more user cycles than main on 2, 4 and 8 lanes. The variant was
  dropped. The line naming main's tree in this log was lost: a lock
  message (stripped, below) ran into it; main was `base-3ce71ec3`, a copy of
  `3ce71ec3`'s worktree.
- `measure-b2.log` (`scripts/measure-b2.sh`): synth and `sqlite3.c`, main
  against `head1-wip`: synth -3.28% and -18.04%, `sqlite3.c` +0.35%.
- `profile-8-lanes-classified.txt` (`scripts/profile.sh`,
  `scripts/classify.awk`): `perf record -g` of `head1-wip`'s Lua link by 8
  lanes, three runs, its samples by the system call or fault their kernel
  stack serves: base-page faults 9 to 14%, huge-page faults about 11% (#1109),
  waits for the address space's lock for writing (fresh reservations'
  `mmap`, page advice and commits, and `munmap`) about 11%, and
  `MADV_DONTNEED` with the TLB flushes it sends the other lanes about 11%.
  The perf data files aren't included.

## Limitations

- The lock's waiting messages, which name other sessions' runs and links,
  were removed: each log keeps only the lines its own scripts and tools print
  (a line allowlist), and was searched for other sessions' names and paths
  afterwards.
- One host, one kernel. The issue's 4-core VM, where main's 4 lanes were
  slower than one, wasn't measured.
- `strace -c` serializes the threads it traces; its call counts are exact,
  its times aren't.
- The correctness checks (`test-check-units`, `test-lanes`,
  `test-check-lanes`, the multicore driver test, `tests/arena/resources.c`)
  ran on the laptop (Zen 4), not here; the pull request has them.
