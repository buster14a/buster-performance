# One lane per core by default (#905), 2026-10-30

buster14a/buster#933 (branch `claude/issue-905-lanes-per-core`) changes the default size of the compiler's lane
sessions: one lane per core of the CPUs the process may run on, where main had one per CPU.

The mechanism is `BUSTER_LANE_SESSION_PER_CORE`. Lane 1 counts the cores from sysfs, reading one `core_cpus_list` per
core with its siblings skipped. It publishes the lanes it asks for, then creates them. `--lanes N` stays capped per
CPU.

This record compares that branch's build with main's on the 9700X, and keeps the logs of the tests run there.

## Sources

- **main:** `b424fe30cd29bb6fb6791fc1aa85c37287173150` (host tree `main-b424fe30`).
- **head, timed:** `6fcb448951ea37195b6e48c5b59bb285e7f4386e` (host tree `percore-2`, its ThreadSanitizer copy
  `percore-2-tsan`).
  - This commit was never pushed. It is `7bfaee29` without the tests that commit adds to `lane_test.c` and without
    its AGENTS.md wording.
  - `trees/6fcb4489-from-7bfaee29.patch`, applied to `git archive 7bfaee29`, gives its tree file for file.
- **head, tested last:** `7bfaee292f76a6011ebf36ac71b372004dbe1c8d` (host trees `percore-3`, `percore-3-tsan`). This
  is the pull request's code; its head, `7014c7d0`, changes only comments and docs after it.

`trees/manifest-*.txt` hold each host tree's SHA-256 of every file but `build/`. Each equals `git archive` of its
commit's, and each ThreadSanitizer copy's equals its tree's.

Each tree was built on the host with `BUSTER_DEBUG_INFO=0 ./build.sh`, and each copy with `BUSTER_SANITIZER=thread
./build.sh`. `logs/hostinfo.out` gives the SHA-256 of the executables and of the inputs:

- `inputs/`;
- the preprocessor oracle's frozen `sqlite3.c`, `0a409f16...`.

The executables' modification times predate the runs that used them.

## Host

`logs/hostinfo.out` has the host's details:

- AMD Ryzen 7 9700X: 8 cores, CPUs 0–9 and 11–15 online, siblings n and n + 8, CPU 10 offline.
- Linux 6.18.50-2-lts, clang 23.1.1, GCC 16.2.1 (for `cores_cost.c`) and wild 0.10.0 (`build.sh`'s linker).
- CPU 2 runs the `performance` governor and EPP. The other CPUs run `powersave` with `balance_performance`.

Every build, test and measurement took the host's lock alone, through `~/buster-fast-bench/exclusive.sh`, with one
command per hold. While it waits, the lock prints the command, title and link of whoever holds it. Those lines always
come first in a log; they are cut here, and each log starts at its command's own first line. 45 of the 59 logs had
them.

## Commands

`scripts/wrap11.sh` first waited for an earlier tree's run, which isn't kept here. Then:

1. **The head's tests.** It built the head, ran `./build.sh check-call-graph`, and ran these tests:
   - `test-lanes`, `test-check-lanes`, `test-check-units` and `test-checker-driver --executable ./build/compiler`;
   - `test-foreign --cross-check`, `test-parallel`, `test-call-graph` and `test-c-testsuite --self-test`.

   A ThreadSanitizer build then ran `test-lanes`, `test-check-lanes`, `test-checker-driver` and
   `test-foreign --cross-check`, and on CPUs 0–3 `test-check-units`. In `logs/tests-percore-2.status`, every status
   is 0 and there is no report.
2. **The comparisons.** It built main, then ran three rounds of five `time-runs` comparisons:
   ```
   head/build/compiler time-runs --runs N --warmups 2 --build main main/build/compiler --build head head/build/compiler --list ARGUMENTS
   ```
   N is 11 for sqlite and 21 for the rest. The two builds' processes alternate, each run in a rotated order. The
   cases (`logs/percore-CASE-ROUND.log`):
   - `sqlite-c-all`: `-c sqlite3.c -o out/sqlite.o`, on every CPU;
   - `sqlite-c-4cores`: the same under `taskset -c 0-3,8,9,11`, which is 4 cores and 3 of their siblings, 7 CPUs;
   - `small-c-all`: `-c inputs/small.c -o out/small.o`;
   - `small-link-all`: `inputs/small.c -o out/small`, an executable;
   - `units-c-all`: `-c inputs/a.c inputs/b.c inputs/c.c inputs/d.c`.
3. **The stages.** Each build ran `--time-stages -c sqlite3.c` three times on every CPU and three times on the 7
   (`logs/percore-stages-*.txt`).
4. **`link-foreign`.** Each build ran `benchmark-link --only linkers --linkers link-foreign --kinds dynamic,static
   --functions 1,2000` twice (`logs/percore-link-*.log`).
5. **The core count's cost.** `scripts/cores_cost.c`, built with `cc -O2`, reads one `core_cpus_list` per core as
   `lane_cores` does, 2,001 times after a first call. It ran three times on every CPU and three times on the 7
   (`logs/percore-cores-cost.log`).

`scripts/wrap12.sh` covers `7bfaee29`:

- its build;
- `test-lanes`, `test-check-lanes`, `test-call-graph` and `./build.sh check-call-graph`;
- a ThreadSanitizer build's `test-lanes` and `test-check-lanes`.

In `logs/tests-percore-3.status`, every status is 0 and there is no report.

## Results

Every timed process exited with status 0 (`time-runs: done, 0 failed processes`), and every `time-runs` and
`benchmark-link` invocation with status 0 (the status files).

The table gives main's change to the head. Wall time and user cycles are medians, one per round. Peak is wait4's
median from round 1.

| case | lanes, main → head | wall, rounds 1–3 | user cycles, rounds 1–3 | peak, round 1 |
| --- | --- | --- | --- | --- |
| `sqlite-c-all` | 15 → 8 | −1.84%, −0.94%, −1.41% | −17.74%, −18.24%, −17.51% | 476,056 → 430,664 KiB |
| `sqlite-c-4cores` | 7 → 4 | +0.52%, +0.87%, +0.77% | −7.97%, −7.00%, −6.75% | 424,200 → 403,756 KiB |
| `small-c-all` | | +0.10%, −1.52%, +0.19% | −0.27%, −0.71%, −1.37% | 34,728 → 34,564 KiB |
| `small-link-all` | | −1.58%, +0.51%, +0.45% | −0.25%, −2.10%, +0.71% | 49,592 → 49,560 KiB |
| `units-c-all` | | −1.59%, −0.41%, −4.86% | −2.16%, +1.98%, +0.13% | 53,524 → 53,484 KiB |

- **`sqlite-c-all`.**
  - Wall medians: main 116.0 to 117.0 ms, the head 114.8 to 114.9 ms. The rounds' min-to-max ranges overlap.
  - User time: main 146 to 157 ms, the head 120 to 123 ms.
  - Peak memory: 43,532 to 45,392 KiB less over the three rounds, or 42.5 to 44.3 MiB.
- **`sqlite-c-4cores`.** main's 3 lanes on siblings bought it 0.5% to 0.9% of wall time. In exchange, it used 7% to 9%
  more user cycles and about 20 MiB more peak memory.
- **`--time-stages`.** `lanes-asked` and `lanes` were 15 and 15 on main and 8 and 8 on the head; on the 7 CPUs, 7 and 7
  against 4 and 4. Lane 0's `lanes-start` was 0.030 to 0.063 ms on both builds: the head's core count runs on lane 1.
- **The core count** (`cores_cost`):
  - on every CPU, 8 reads: median 9.4 µs (p10 9.3 to 9.4, p90 9.7 to 9.9), first call 18.8 to 55.0 µs;
  - on the 7 CPUs, 4 reads: median 4.7 to 4.8 µs, first call 23.5 to 26.5 µs;
  - `sched_getaffinity` alone: 0.08 µs.
- **`link-foreign`.** Both builds' sessions start 8 lanes on this host: `min(8, cores)` equals `min(8, CPUs)`. Each row
  of the two builds stayed within its run-to-run spread. By default (`its threads`), in two rounds each:
  - one worker's dynamic PIE: main 1.07 and 1.10 ms, the head 1.09 and 1.13 ms;
  - 2,000 workers' static executable: main 2.66 and 2.78 ms, the head 2.64 and 2.71 ms.

## Limitations

- **Placement.** One placement of each build was timed. `docs/profiling.md`'s "Comparing two versions" reports
  context-specific timing controls, including about 1.5%; these do not establish a placement bound for this comparison.
  The observed wall-time, cycle and memory deltas are consistent with the lane-count change, but this experiment did
  not isolate placement's contribution or measure a cycle/RSS placement floor.
- **The timed head.** It carried `6fcb4489`'s tests, which `7bfaee29` changed. They are compiled into the same
  executable but not run by these commands.
- **Exit statuses.** The `--time-stages` and `cores_cost` runs' statuses weren't logged; each wrote its whole report.
- **Peaks.** wait4's peak includes what the harness's process held before exec, as `time-runs` says in each log. The
  small inputs' peaks may be the harness's, not the compiler's.
- **Zen 4.** The pull request's core-count cost on a 16-CPU Zen 4 (31 µs, and 50 to 65 µs as a first call) was measured
  on another machine with the same program and isn't kept here.
- **One large input:** `sqlite3.c`.
