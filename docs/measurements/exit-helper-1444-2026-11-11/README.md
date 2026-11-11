# A single-threaded compile's teardown off its exit (#1444), 2026-11-11

Evidence for buster14a/buster#2075 (branch `claude/lazy-lanes-1444`), part of
[#1444](https://github.com/buster14a/buster/issues/1444). #2075's on-demand lanes left a small compile with no thread,
and [`lazy-lanes-1444-2026-11-11`](../lazy-lanes-1444-2026-11-11/README.md) found that this made it tear its address space
down in its exit (`exit_mmap`, before its parent's `wait4` returns), where main's 7 parked lanes had left that teardown
to a kworker (Linux 6.18 does so for a process of 6 threads or more). The change starts a helper as such a process exits
(`lane_exit_helper_start`): its streams flushed and every descriptor closed, a `clone3` with `CLONE_VM` and
`CLONE_CLEAR_SIGHAND` makes a process that shares the address space and holds nothing else; it blocks every signal,
asks for `SIGKILL` when its parent dies (`PR_SET_PDEATHSIG`), and exits at once if its parent is already gone. The
caller's exit then leaves the teardown to it. By default only where PID 1 handles `SIGCHLD` (blocks, ignores or catches
it), since an orphan stays a zombie until its new parent waits for it; `BUSTER_EXIT_HELPER=1` starts it wherever it can,
`=0` never.

## Sources

| build | revision | what it is |
| --- | --- | --- |
| `base` | `edb466bcf95ff6141f65a155f8e991c4c6a18f8f` | main (#2074's merge), the merge's base |
| `lanes` | `1c5b8618ac92bdc29ddf5d5b551e24843d467266` | #2075's on-demand lanes, merged with that main, no helper |
| `head` | `88bce28e94969107ef5b3e3671b5b2d1cedb4d65` | `lanes` and the exit helper |

The branch's next commit, `9ae28fe9`, changes only documentation. Each is a `git worktree` of a clone of
buster14a/buster, built on the 9700X by `scripts/build.sh` under the lock:
`BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 taskset -c 0-7 ./build.sh shifts --config Release DIR main_unit_checker.c 0 1088 2112 3136`.
`raw/build-*.log` are the builds' logs and `raw/hostinfo.txt` has every executable's SHA-256 (placement 0: base
`67a1f8a4…`, lanes `daf6af3a…`, head `3f8a9122…`). `base-again` is base's four executables timed again, the floor. Every
run uses the host's default environment, so the head's helper is on: the host's PID 1 is systemd, which blocks
`SIGCHLD` (`raw/hostinfo.txt`).

## Host

`raw/hostinfo.txt`: AMD Ryzen 7 9700X (8 cores, CPUs 0–9 and 11–15 online), Linux 6.18.50-2-lts, CPU 2 on `performance`
and the others on `powersave` with `balance_performance`, transparent huge pages `always`, clang 23.1.1, perf 7.2.9,
strace 7.2, glibc 2.44. Every build, test and measurement ran under the shared lock (`~/buster-fast-bench/exclusive.sh`),
one script's command per hold; the lock's waiting notices, which name other sessions, were removed from the logs. The
timed processes run on every CPU (no `taskset`), as in the earlier record.

## Inputs

`inputs/`, the earlier record's: `empty.c`, `tiny.c` (a one-line `main`), `two.c` (two one-line functions), `hello.c`
(`#include <stdio.h>` and a `printf`), `medium.c` (200 functions, whose emission runs on several lanes), `a.c` to `d.c`
(four small units in one command); and the 9700X's frozen `sqlite3.c` (SHA-256 `0a409f16…`), with
`-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0`.

## Runs

- `scripts/run.sh r1`: three `time-runs` processes over base, lanes, head and base-again at four placements, two fresh
  copies of each (one for `sqlite3.c`), a Williams design's order (`raw/ab-small-r1.txt` 30 runs and 3 warm-ups,
  `raw/ab-medium-r1.txt` 20 and 2, `raw/ab-sqlite-r1.txt` 11 and 1).
- `scripts/counts.sh r1`: `strace -f -c` of one process and `perf stat -r` (200, 100 or 10) per build and input
  (`raw/strace-*`, `raw/perf-*`).
- `scripts/batch.sh r1`: 400 processes of `tiny.c`'s and `hello.c`'s `-c`, 1, 8 or 16 at a time (`xargs -P`), base,
  lanes and head alternated, 5 rounds, under `perf stat -a`: the elapsed time and every CPU's unhalted cycles, the
  helpers' and the kworkers' teardowns among them (`raw/batch-*`).
- `scripts/phases.sh r1` (`scripts/phases.c`, the earlier record's): each build after itself, as a serial run of its
  compiles has it, 400 processes, the parent spinning: fork to exec, exec to the `--time-stages` report, the report to its
  stream's end of file, and that to the reaping (`raw/phases-r1.txt`). The head closes its descriptors before it starts
  its helper, so its end of file comes before the helper's start and its exit, which its "end of file to reaping" holds.
- `scripts/exits3.sh r3` (`scripts/exits.c`): whether anything but other threads moves the teardown off the exit, with
  64 MB touched: a private futex hash replaced (16 slots then 32, or after a joined thread) or made at 32, against 5
  parked threads (`raw/exits-r3.txt`).
- `scripts/procstat.c`: the cost of the default's check, a read of `/proc/1/stat` (`raw/procstat.txt`); `scripts/reaped.c`, the
  check itself (`lane_exit_reaped`) built alone, run here and in the container (`raw/container.txt`).
- `scripts/tests.sh`: the head's tests (`raw/tests-head.status`, `raw/test-head-*.log`), and main's
  `test-checker-driver --part 2/8` for its 4 failures (`raw/test-base-test-checker-driver-executable-2.log`).

## Results

**Whole processes, one at a time** (`time-runs`; medians over placements and copies, the range over placements):

| input | base | lanes against base | head against base | base-again |
| --- | ---: | --- | --- | --- |
| empty `-fsyntax-only` | 0.761 ms | +4.13% (−2.09%…+13.63%) | −3.49% (−7.51%…+2.55%) | −0.89% |
| `tiny.c` `-c` | 1.015 ms | +7.80% (−1.93%…+18.07%) | +0.31% (−7.93%…+8.65%) | −0.23% |
| `two.c` `-c` | 1.063 ms | +7.67% (−3.05%…+16.46%) | −1.99% (−10.19%…+5.11%) | −1.67% |
| `hello.c` `-c` | 2.303 ms | +5.92% (+1.04%…+11.83%) | −1.43% (−4.83%…+2.50%) | −2.60% |
| `medium.c` `-c` | 2.822 ms | −0.48% | −0.36% | +0.34% |
| `a.c` to `d.c` `-c` | 3.725 ms | +0.07% | −0.34% | +0.77% |
| `sqlite3.c` `-c` | 104.049 ms | −0.63% (−1.50%…+0.07%) | −0.63% (−1.54%…−0.02%) | −0.17% |

The empty `-fsyntax-only` runs on one lane in every build, so the head's helper serves it too. `medium.c`, the four
units and `sqlite3.c` start their lanes in every build and start no helper. `time-runs` compared no user cycles for the
small inputs: some head processes' counters didn't count throughout, as the helper, a child of the measured process,
still runs when they are read. Its user cycles for `medium.c` and `sqlite3.c`: lanes +0.60% and −0.50%, head +0.68% and
−0.56%, base-again +0.31% and −0.37%; for the four units, head +2.66% (+1.29%…+4.30%), lanes +0.91%, base-again +0.20%,
at the same wall time.

**The one-line `-c`'s counts** (`raw/strace-*`, `raw/perf-*`, `perf stat -r 200`):

| | base | lanes | head |
| --- | ---: | ---: | ---: |
| lane threads (`clone3`) | 7 | 0 | 0 (and 1 helper) |
| `futex` calls | 14 | 0 | 0 |
| system calls | 233 | 129 | 137 |
| page faults | 616 | 426 | 428 |
| task clock | 0.99 ms | 0.58 ms | 0.68 ms |
| user cycles | 1.02 M | 0.75 M | 0.78 M |
| kernel cycles | 4.16 M | 2.44 M | 2.91 M |
| context switches | 20 | 0 | 0 |

perf stat counts the helper, a child of the measured process, where it ends before perf reads its counters: the head's
task clock and kernel cycles hold its start and the teardown it runs.

**400 compiles** (`raw/batch-*`, medians of 5 rounds; cycles are every CPU's):

| input, at once | base | lanes | head | head's cycles against base |
| --- | ---: | ---: | ---: | ---: |
| `tiny.c`, 1 | 306.7 ms | 356.7 ms (+16.3%) | 304.9 ms (−0.6%) | 1.99 G against 2.99 (−33.5%) |
| `hello.c`, 1 | 766.9 ms | 920.9 ms (+20.1%) | 840.1 ms (+9.5%) | 4.58 G against 5.88 (−22.1%) |
| `tiny.c`, 8 | 96.3 ms | 69.9 ms (−27.5%) | 72.1 ms (−25.2%) | 3.50 G against 5.08 (−31.1%) |
| `hello.c`, 8 | 145.7 ms | 120.1 ms (−17.6%) | 124.6 ms (−14.4%) | 5.84 G against 7.27 (−19.7%) |
| `tiny.c`, 16 | 94.2 ms | 80.5 ms (−14.5%) | 71.2 ms (−24.5%) | 4.48 G against 5.82 (−23.0%) |
| `hello.c`, 16 | 135.5 ms | 130.1 ms (−4.0%) | 118.7 ms (−12.4%) | 7.34 G against 8.52 (−13.8%) |

Lanes' cycles: 1.71, 4.41, 3.23, 5.24, 4.56 and 7.50 G in the same order. Run one at a time, the head takes 0.28 G more
than lanes for 400 one-line compiles, 0.7 M cycles each, and 0.17 G more for `hello.c`'s: the helper's start, a second
task woken on another core, and its exit; the teardown itself is the same work in both.

**Where a serial process's time goes** (`raw/phases-r1.txt`, each build after itself, medians of 400, µs; the head's
"end of file" is its descriptors' closing, before its helper's start and its exit):

| input | build | whole | fork to exec | exec to report | report to end of file | end of file to reaping |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| `tiny.c` | base | 912.7 | 67.9 | 743.0 | 91.8 | 4.1 |
| | lanes | 1154.9 | 126.3 | 825.7 | 180.0 | 4.8 |
| | head | 883.8 | 75.0 | 704.4 | 77.5 | 18.8 |
| | base again | 896.8 | 68.1 | 729.8 | 90.8 | 3.9 |
| `hello.c` | base | 2075.7 | 76.4 | 1894.7 | 96.2 | 4.6 |
| | lanes | 2476.6 | 136.8 | 2082.9 | 225.2 | 6.0 |
| | head | 2275.4 | 142.7 | 2025.2 | 79.7 | 22.1 |
| | base again | 2061.0 | 77.4 | 1884.7 | 96.3 | 4.4 |

- **The exit:** from the report to the reaping, the head takes 96.3 µs (`tiny.c`) and 101.8 µs (`hello.c`), against
  base's 95.9 and 100.8 and lanes' 184.8 and 231.2. The helper recovers all of the synchronous teardown.
- **The idle core:** for `tiny.c` the head's next process also starts and runs as base's does (75.0 and 704.4 µs), as the
  helper's teardown, about 90 µs on another core, overlaps it; for `hello.c` it doesn't (142.7 and 2025.2 µs against
  76.4 and 1894.7): the part of lanes' serial cost that came from starting on an idle core remains, 9.5% of a serial run of
  `hello.c`'s.

**What else moves the teardown** (`raw/exits-r3.txt`, 64 MB, from the last write to its end of file): with no thread
880 to 1,080 µs; with the private futex hash replaced, 1,238 and 1,310; made at 32 slots, 964; with 5 parked threads,
57. Only the threads do, so the helper is a process.

**The default's check** (`raw/procstat.txt`): a read of `/proc/1/stat` takes 2.9 to 13.1 µs as a process's first, 1.1 µs
after.

**Tests** (`raw/tests-head.status`, the head's Release build `tree-head/build/compiler`): `test-lanes`,
`test-check-lanes` (with the exit helper's checks), `test-check-units` and `test-parallel` pass, as does a
ThreadSanitizer build's `test-lanes`; `test-checker-driver` by `--executable` and by `--in-process`, in eight parts each,
passes but for part 2's 4 interrupt-handler checks, whose probe of clang's objects ran nothing ("nothing ran"), each way,
and main's build fails the same 4 there (`raw/test-base-test-checker-driver-executable-2.log`): the host's clang is
23.1.1, not the 23.1.4 the checks expect. No run left a zombie. `raw/container.txt` has the cloud container's runs.

## Limitations

- One run of each script, on one machine and kernel. The kworker teardown for 6 threads or more is Linux 6.18's behaviour
  as measured, not an interface; the helper's gain is the teardown's time on any kernel that tears down in the exit.
- The helper's CPU time is an orphan's, outside the caller's resource use and `time-runs`' counters; `raw/batch-*`'s
  every-CPU cycles include it.
- The default's check reads PID 1's signal dispositions: a subreaper between the compiler and PID 1 takes its orphans
  instead, which the check doesn't see, and a PID 1 that handles `SIGCHLD` but doesn't wait for every child would keep
  the helpers as zombies.
- The serial cost of starting on an idle core depends on the host's idle states and governors (all but CPU 2 on
  `powersave` with `balance_performance` here).
