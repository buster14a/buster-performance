# Tier 1's i1, i8 and i16 and, or and xor; `&&` and `||` values as and/or (#2677), 2026-11-14

[buster14a/buster#2677](https://github.com/buster14a/buster/issues/2677)'s kernels, and sqlite3.c's `--tier1 -c`, on the
9700X (benchpress, CPU 2, governor and EPP `performance`), for
[buster14a/buster#2796](https://github.com/buster14a/buster/pull/2796).

## Revisions

| name | commit | tree | what |
| --- | --- | --- | --- |
| main | `2ebfe68a856613e300231520af5e7ec5627708b6` | `fef57601` | #2796's base |
| head | `d42ea94ba32460c962fd3c93d93a52ed4032b87c` | `e5235d61` | #2796's commit |

Each tree was a `git worktree` of its commit, built with `./build.sh --config Release` (native: znver5) under the 9700X's
lock (`scripts/build-tree.sh`). Host: `kernels/identities.txt` (Linux 6.18.50, clang 23.1.1, perf 7.2.9, the compilers'
and objects' sha256).

## Method

- **Kernels** (`scripts/kernels.c`, `scripts/bench.c`): #1382's harness
  ([tier1-if-convert-1382-2026-11-13](../tier1-if-convert-1382-2026-11-13/README.md)) with its loops' kernels left out
  and `k_andori`, the `&&`/`||` kernel returning `int`, added. As an `int` the value is a select of the truth value and 0
  rather than a test of it, which #2796's Tier 1 select candidate takes. Each kernel is compiled by main's and head's
  `--tier1 --tier1-strict -c` and by clang -O2 -fno-vectorize. One clang -O2 driver, in another object, calls it 50 M
  times on xorshift64's high bits. Every build's output was checked equal first (`kernels/build.log`: "built and
  checked"). Each run is pinned to CPU 2 after an untimed warm-up, under
  `perf stat -e cycles:u,instructions:u,branch-misses:u` (`kernels/results.tsv`, with each run's exit status). The
  builds' order rotates by round.
- **Holds** (`kernels/holds.txt`): `scripts/measure.sh` built the objects (23:34 UTC) and ran round 1 (23:45) in holds
  of their own. With the lock's queue at the time, one hold per round took about 30 minutes each, so the run was
  stopped (the waiting `exclusive.sh` killed before its `flock`). `scripts/rounds.sh` then ran rounds 2-6 (00:07) and
  7-11 (00:17) in a hold each, about 10 s: each round's timed runs take 1.0 s (`wall_ns`), and their warm-ups as long.
  `kernels/busy.txt` has the load and the busiest processes before and after each round.
- **Compile** (`scripts/compile.sh`, #1382's `compile3.sh`): the frozen sqlite3.c (sha256 `0a409f16…e23d`, checked),
  `--tier1 -c` with measure-compile's options, by each tree's compiler. First the `--tier1-report` counts, the object's
  `.text` size and its `cmov`/`jcc` counts (`compile/shape.txt`, `compile/report-*.txt`). Then `time-runs --runs 11` of
  both, in one hold, in its Williams order (`compile/compile-time.txt`). Three runs follow, each in a hold of its own:
  - `scripts/time-reversed.sh` lists the builds head first (`compile/compile-time-reversed.txt`).
  - `scripts/time-copies.sh` runs `--copies 3` of main, head and main again (`compile/compile-time-copies.txt`).
  - `scripts/time-shm.sh` writes the object to tmpfs (`/dev/shm`) rather than `/home`'s btrfs, which is zstd-compressed
    and encrypted (`compile/compile-time-shm.txt`).

  `compile/*-busy.txt` have the load and the busiest processes in each hold.
- `exclusive.sh`'s waiting lines (another holder's line, title and link) were removed from the logs. The files that held
  nothing else (`lock.log`, the orchestrators' logs) are left out.

## Kernels (11 rounds; medians in Mcycles, `cycles:u`, with the rounds' range)

| kernel | main | head | clang -O2 -fno-vectorize | head / main | head / -O2 | instructions M, main / head / -O2 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| null (`a ^ b`, the driver loop) | 300.6 (300.5–300.6) | 300.5 (300.5–300.7) | 300.6 (300.6–300.7) | 1.000 | 1.000 | 1350 / 1350 / 1350 |
| `x < 0 ? 0 : x > 255 ? 255 : x` (control) | 350.2 (350.2–350.2) | 350.2 (350.2–350.2) | 313.6 (311.7–315.9) | 1.000 | 1.117 | 2000 / 2000 / 1650 |
| `a < 128 && b < 128` (`_Bool`) | 320.0 (318.5–320.2) | 318.7 (318.3–319.9) | 334.1 (334.1–334.1) | 0.996 | 0.954 | 1750 / 1700 / 1600 |
| `(a < b) && (b < c \|\| c == 0)` (`_Bool`) | 383.9 (383.9–383.9) | 363.1 (363.1–363.1) | 365.5 (363.8–367.4) | 0.946 | 0.993 | 2150 / 2050 / 1900 |
| `(a < b) && (b < c \|\| c == 0)` (`int`) | 374.1 (374.1–374.1) | 362.9 (360.5–365.5) | 381.7 (381.7–381.7) | 0.970 | 0.951 | 2100 / 1900 / 1800 |

Every run exited 0, and branch misses are at most 0.003 M in every row.

- The kernels' cycles include the driver loop's (the null row, 300.6 Mcycles). Without it, each kernel's own work is, in
  Mcycles, main / head / clang -O2:
  - `&&`: 19.4 / 18.1 / 33.5.
  - `&&`/`||` as `_Bool`: 83.3 / 62.5 / 64.9.
  - `&&`/`||` as `int`: 73.5 / 62.4 / 81.1.
  - The clamp control: 49.6 / 49.7 / 13.0.
- **Code** (`kernels/k_*.s`):
  - `k_and`: main's `setl; setl; test; cmovne` becomes head's `setl; setl; and`.
  - `k_andor`: main's two `test; cmovne` pairs and a `mov` become an `or` and an `and`.
  - `k_andori`: the same as `k_andor`, through the select candidate.
- **The `&&` kernel** retires 50 M fewer instructions (one per call), but its cycles barely move, since the driver
  loop's chain hides them.
- **clang -O2's `&&` and `int` kernels are the slowest.** Its `setl %cl; setl %al; and %cl,%al` (and `movzbl` for the
  `int`) write byte registers that it doesn't zero first, so each call's `setcc` merges with the register's previous
  value. Tier 1's `xor; setcc` pairs break that dependency.

## sqlite3.c `--tier1 -c`

| | main | head |
| --- | ---: | ---: |
| `.text` bytes | 1,557,640 | 1,556,344 (−1,296) |
| `cmov` | 1,140 | 910 |
| conditional jumps | 31,736 | 31,736 |
| Tier 1's records (`--tier1-report`) | 383,005 | 382,595 |
| functions by Tier 1 | 1,403 of 1,403 | 1,403 of 1,403 |

| `time-runs --runs 11` (medians) | main | head | head / main |
| --- | ---: | ---: | ---: |
| user cycles | 3,411.2 M (3,406.2–3,418.6) | 3,418.2 M (3,413.7–3,424.8) | +0.21% |
| instructions | 8,368.83 M | 8,371.98 M | +0.04% |
| user time | 616.0 ms | 617.6 ms | |
| wall time | 634.5 ms (633.6–636.6) | 655.5 ms (635.4–659.3) | see below |

**Head's wall time is the object file's write, not the compile.** Head's runs alternate between about 635 and about
657 ms of wall time, at the same user and system time, so the extra ~20 ms is spent off the CPU:
- **Not the order.** With the builds listed head first, head is at 655–660 ms in five of its 11 runs, 643 ms in one
  and 634–637 ms in the other five. Main stays at about 634 ms (one run at 649).
- **Not an executable copy's file state.** With three fresh copies of each build, all three head copies show it (12 of
  15 runs). No copy of main or of main again does.
- **The output's file system.** Written to tmpfs, head's wall time is 635.6 ms against main's 633.6 (+0.30%). Every
  run of both builds is 1.9–2.2 ms past its user + system time, as main's are on btrfs, where six of head's 11 runs
  in `compile-time.txt` are 21.9–24.5 ms past it. The wait goes with head's object on that btrfs, which is 1,296 bytes
  smaller (2,494,592 against 2,495,888). Why writing it over the previous `runs.o` there waits about 20 ms in half to
  four fifths of head's runs wasn't traced.

| run | user cycles, main / head | head / main | wall, main / head |
| --- | ---: | ---: | ---: |
| `compile-time.txt` (11 runs) | 3,411.2 M / 3,418.2 M | +0.21% | 634.5 / 655.5 ms |
| `compile-time-reversed.txt` (11, head first) | 3,407.1 M / 3,414.8 M | +0.23% | 634.6 / 643.4 ms |
| `compile-time-copies.txt` (5 × 3 copies; main again 3,409.9 M, −0.04%) | 3,411.1 M / 3,416.5 M | +0.16% | 634.6 / 655.2 ms |
| `compile-time-shm.txt` (11, object on tmpfs) | 3,407.9 M / 3,418.4 M | +0.31% | 633.6 / 635.6 ms |

The compile costs 0.16% to 0.31% more user cycles, and 0.04% more instructions (3.15 M of 8,369 M). It has 410 fewer
records to encode, 230 fewer `cmov`s, and selects through the new candidates and the grammar's ninth ALU operation.
