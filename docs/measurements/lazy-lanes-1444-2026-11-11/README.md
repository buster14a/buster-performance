# One source file's lanes on demand (#1444), 2026-11-11

Evidence for the pull request from buster14a/buster's `claude/lazy-lanes-1444`, part of
[#1444](https://github.com/buster14a/buster/issues/1444): a small compile's fixed start. On main, the C driver's session
for one source file started its whole lane team as the command began: a one-line `-c` on the 9700X created 7 lane
threads, which no round of so small a unit ever runs on. The change starts that session on demand
(`BUSTER_LANE_SESSION_ON_DEMAND`): lane 0 creates lane 1 (which counts the cores and creates the others, as the lazy
start did) only once the unit is preprocessed and has `BUSTER_CHECK_EMIT_LANE_TOKENS` (4,096) tokens or more, or when the
emission's or the deferred reader's rule asks for lanes. Several units, `--lanes N` and pinned lanes start as before.

## Sources

| tree | revision | executables |
| --- | --- | --- |
| `base` | `1fe4110580688558a845752ebd7475c989402b0b` (main when the branch was cut, #2072's merge) | `shifts-base/compiler-{0,1088,2112,3136}` |
| `head` | `0aed4cb134c1fd92bd1a67f960eebb29a6cf0dc3` (the change) | `shifts-head/compiler-{0,1088,2112,3136}` |

The branch's next commit, `a96dbcb0`, changes only documentation. Each tree is a `git worktree` of a clone of
buster14a/buster, built on the 9700X by `scripts/build.sh` under the machine's lock:
`BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 taskset -c 0-7 ./build.sh shifts --config Release DIR main_unit_checker.c 0 1088 2112 3136`,
four placements of `main_unit_checker.c`'s code. `raw/build-base.log` and `raw/build-head.log` are the builds' logs, and
`raw/hostinfo.txt` has every executable's SHA-256 (placement 0: base `bf55d9d5…`, head `e9f4437a…`). `base-again` is
base's four executables timed again, the A/A floor.

## Host

`raw/hostinfo.txt`: AMD Ryzen 7 9700X (8 cores, CPUs 0–9 and 11–15 online, siblings n and n + 8), Linux 6.18.50-2-lts,
CPU 2 on the `performance` governor and the others on `powersave` with `balance_performance`, transparent huge pages
`always`, clang 23.1.1, perf 7.2.9, strace 7.2, glibc 2.44.

Every build, test and measurement ran under the shared lock (`~/buster-fast-bench/exclusive.sh`), one script's command
per hold. No log here holds the lock's waiting notices, which would name other sessions. The timed processes run on
every CPU (no `taskset`): what changes is the lanes a process starts on the CPUs it may run on, and a process pinned to
one CPU starts none in either build.

## Inputs

`inputs/`: `empty.c`; `tiny.c` (`int main(void){return 0;}`, 10 tokens); `two.c` (two one-line functions); `hello.c`
(`#include <stdio.h>` and a `printf`, 2,963 tokens); `medium.c` (200 functions of a loop each, 11,817 tokens, whose
emission runs on several lanes); `a.c` to `d.c` (#905's four small units, from
`lanes-per-core-905-2026-10-30/inputs`). And the 9700X's frozen `sqlite3.c`
(`/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite`, SHA-256 `0a409f16…`), with
`-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0`. `raw/hostinfo.txt` has their hashes.

## Runs

- `scripts/run.sh r1`: three `time-runs` processes (whole fresh processes from two fresh copies of each executable, a
  Williams design's order over base, head and base-again at four placements; `raw/ab-small-r1.txt`,
  `raw/ab-medium-r1.txt`, `raw/ab-sqlite-r1.txt`): the small inputs, 30 runs (3 warm-ups) of each slot; `medium.c` and
  the four units, 20 runs (2 warm-ups); `sqlite3.c`, 11 runs (1 warm-up), one copy.
- `scripts/counts.sh r1`: `strace -f -c` of one process, `perf stat -r` (200, 100 or 10 processes) and one
  `--time-stages` report per build and input (`raw/strace-*`, `raw/perf-*`, `raw/stages-*`).
- `scripts/kstat.sh r1`: `perf stat` of the one-line `-c` and `hello.c`'s, 4 blocks of 100 processes per build,
  alternated, with user and kernel cycles (`raw/kstat-*`).
- `scripts/waits.sh r1` (`scripts/waits.c`): 400 processes of each build per input, alternated, the parent asleep in
  `wait4` or spinning on `waitpid(WNOHANG)`; and each build's `--time-stages` total (its in-process time, from the setup's
  start to the release's end), 200 each (`raw/waits-r1.txt`, `raw/total-*`).
- `scripts/phases.sh r1` and `scripts/phases2.sh r1` (`scripts/phases.c`): where a process's wall time goes, seen from a
  spinning parent: fork to exec (a close-on-exec pipe), exec to the first byte of the `--time-stages` report (written
  once the work is done), the report to its stream's end of file (the last thread's descriptors closed, in its exit),
  and that to the reaping. `phases` alternates base and head; `phases2` runs each build after itself, as a serial run of
  one build's compiles has it (`raw/phases-r1.txt`, `raw/phases2-r1.txt`).
- `scripts/kprof.sh r1`: `perf record -a -g` at 25 kHz while 300 of each build's one-line `-c` run
  (`raw/kprof-*.txt`, the reports by symbol of the `compiler-0` threads; the `.data` files aren't kept).
- `scripts/exits.sh r1` and `r2` (`scripts/exits.c`): a process that touches 64 MB in base pages and exits, with no
  thread, 1 to 7 parked threads, one joined thread, or a private futex hash of 16 slots (`raw/exits-r2.txt`; r1, in
  `raw/exits-r1.txt`, ran a first version of both files, with only 1 and 7 parked threads and the joined one, 200 rounds;
  `exits.c` then gained the other modes, which leave those three as they were).
- `scripts/batch.sh r2`: 400 processes of one input, 1, 8 or 16 at a time (`xargs -P`), under `perf stat -a` (the
  elapsed time and the unhalted cycles of every CPU), base and head alternated, 5 rounds (`raw/batch-*-r2.txt`; `r1`'s
  per-process task clock missed the kworkers' work and its elapsed time wasn't recorded, so it isn't kept).
- `scripts/tests.sh`: the head's tests on the 9700X (`raw/tests-head.status`, `raw/test-head-*.log`).

## Results

**A one-line `-c` (`tiny.c`).** The head creates no thread. Its process makes 129 system calls rather than 233 (no
`clone3` against 7, no `futex` against 14; `raw/strace-*-tiny-r1.txt`), takes 437 page faults rather than 616 and 13.5%
fewer user instructions (635,271 against 734,351; `raw/ab-small-r1.txt`), and in `raw/kstat-*` 0.61 to 0.64 ms of task
clock rather than 0.98 to 1.00, 0.81 to 0.83 M user cycles rather than 1.02 to 1.05 M, 2.5 to 2.7 M kernel cycles rather
than 4.1 to 4.3 M, no context switch against 19 or 20 and no migration against 2. Its in-process time is 0.571 ms
against 0.610 (`raw/waits-r1.txt`).

**Whole processes, one at a time** (`time-runs`, medians over placements and copies, the range over placements;
user cycles count every thread's):

| input | wall base → head | head against base | base-again | user cycles head against base | base-again |
| --- | --- | --- | --- | --- | --- |
| empty `-fsyntax-only` | 0.764 → 0.823 ms | +7.76% (−2.67% to +13.97%) | −1.45% | +3.25% | +2.53% |
| `tiny.c` `-c` | 1.023 → 1.128 ms | +10.28% (+1.15% to +16.94%) | +1.24% | −11.04% (−14.49% to −7.54%) | −1.48% |
| `two.c` `-c` | 1.083 → 1.228 ms | +13.44% (+2.19% to +16.96%) | −1.36% | −8.94% | +1.10% |
| `hello.c` `-c` | 2.303 → 2.475 ms | +7.50% (+3.62% to +10.54%) | −0.98% | −3.81% | +0.59% |
| `medium.c` `-c` | 2.808 → 2.820 ms | +0.44% (−2.94% to +3.48%) | −0.16% | +0.78% | +0.11% |
| `a.c` to `d.c` `-c` | 3.749 → 3.706 ms | −1.14% (−4.64% to +3.22%) | −0.59% | +0.25% | +0.36% |
| `sqlite3.c` `-c` | 104.356 → 104.194 ms | −0.16% (−0.91% to +0.37%) | −0.17% | −0.65% (−1.22% to +0.65%) | −0.47% |

The empty `-fsyntax-only` runs on one lane in both builds, the same instructions and faults; `raw/waits-r1.txt` and
`raw/phases-r1.txt` time it alike in both (636.7 against 696.9 µs, 955.2 against 960.4), so its +7.76% is this run's
noise. `medium.c`, the four units and `sqlite3.c` start their lanes in both builds (7 `clone3` each) and don't change
beyond the floor; their faults and instructions are within each other's ranges.

**Many at once** (`raw/batch-*-r2.txt`: 400 processes, medians of 5 rounds; cycles are every CPU's):

| input | at once | elapsed base → head | cycles base → head |
| --- | --- | --- | --- |
| `tiny.c` | 1 | 304.7 → 391.1 ms (+28.4%) | 2.91 → 1.82 G (−37.5%) |
| `tiny.c` | 8 | 94.0 → 70.4 ms (−25.1%) | 4.92 → 3.37 G (−31.5%) |
| `tiny.c` | 16 | 91.7 → 83.4 ms (−9.1%) | 5.75 → 4.60 G (−20.0%) |
| `hello.c` | 1 | 759.6 → 927.7 ms (+22.1%) | 5.81 → 4.42 G (−23.9%) |
| `hello.c` | 8 | 143.0 → 122.0 ms (−14.7%) | 7.03 → 5.43 G (−22.8%) |
| `hello.c` | 16 | 131.9 → 133.2 ms (+1.0%) | 8.48 → 7.62 G (−10.1%) |

**Why one at a time takes longer.** `raw/phases-r1.txt` (alternated) and `raw/phases2-r1.txt` (each build after
itself), medians of 400 processes, µs:

| input, order | build | whole | fork to exec | exec to report | report to end of file |
| --- | --- | --- | --- | --- | --- |
| `tiny.c`, alternated | base | 881.2 | 65.5 | 715.9 | 92.5 |
| | head | 952.5 | 65.4 | 699.2 | 180.0 |
| `tiny.c`, after itself | base | 889.5 | 67.2 | 726.1 | 90.2 |
| | head | 1120.0 | 122.7 | 807.0 | 179.2 |
| `hello.c`, alternated | base | 2166.2 | 76.7 | 1979.3 | 96.4 |
| | head | 2259.0 | 73.6 | 1933.4 | 235.8 |
| `hello.c`, after itself | base | 2048.7 | 76.0 | 1867.2 | 95.8 |
| | head | 2452.3 | 134.6 | 2063.6 | 227.6 |

Two things, neither the head's work:

- **The exit tears the address space down.** From the report to its stream's end of file, the head takes 90 µs more
  for `tiny.c` and 130 µs more for `hello.c`. In `raw/kprof-children-head-r1.txt`, `exit_group`'s `exit_mmap` takes
  13.7% of the head's `compiler-0` cycles; in base's, the `compiler-0` threads don't run it: kworkers do
  (`kworker/12:1-mm`, `kworker/0:2-events` and others, from a work item's `__mmput`). `raw/exits-r2.txt` shows the
  kernel's rule: a process touching 64 MB with no thread, 1 to 4 parked threads or a joined one tears it down in its
  exit (870 to 1,390 µs from its last write to its end of file), and with 5 to 7 parked threads it exits first and a
  kworker tears it down (59 to 61 µs). A private futex hash of 16 slots without threads doesn't do it. So on Linux 6.18
  a process of 6 threads or more leaves its teardown to a kworker; base's 8 lanes did, and paid for it in CPU time
  elsewhere.
- **The next process starts on an idle core.** Run after itself, the head's process takes 56 µs more from fork to exec
  and 81 µs more for its work (59 and 196 µs for `hello.c`'s); alternated with base's, it takes the same or less. Most
  likely base's lanes, running on other cores until the process exits, kept cores out of deep idle for the next
  process; these runs don't show the idle states themselves.

Run 8 at a time, where cores stay busy, the head is 15% to 25% faster.

**Tests** (`raw/tests-head.status`, on the 9700X, the head's own Release build `tree-head/build/compiler`, SHA-256
`c5f5ae5e…`): `test-lanes` (with its new on-demand sessions; the core checks on a core's two siblings), `test-check-lanes`
(7,622 checks, its sibling commands among them), `test-check-units`, `test-checker-deferred`, `test-call-graph` and
`./build.sh check-call-graph` all pass. `raw/container.txt` has the cloud container's cross-check (4 CPUs, no SMT, shared
with other sessions, so counts only): base's one-line `-c` created 3 threads there and the head's none, the outputs of
both builds byte-identical for every input, and the head's tests there.

## Limitations

- Each comparison is one run of its script, on one machine and kernel. The exit's teardown rule is Linux 6.18's
  behaviour as measured here, not a documented interface; another kernel may tear down a few-threaded process's address
  space otherwise.
- The serial cost depends on the host's idle states and governors: CPU 2 runs `performance` and the others `powersave`
  with `balance_performance`, and the timed processes ran on any CPU.
- `raw/kprof-*` are sampled profiles of 300 processes per build, a few thousand samples each; `scripts/trace.sh`'s
  scheduler tracepoints weren't readable by the session's user (no access to tracefs), so it isn't kept.
- `raw/batch-*` time `xargs` and its children together; the cycles count every CPU's, the host's background among them.
