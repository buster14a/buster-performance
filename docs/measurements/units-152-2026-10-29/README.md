# Many translation units in one process, buster#152, 2026-10-29

Compiler branch: `claude/solve-152-eda9b1` of buster14a/buster, for
[this claim on #152](https://github.com/buster14a/buster/issues/152). The branch
makes `compiler [options] a.c b.c ...` compile every source file of its command
line in one process, the units as lane items, and link them into one executable
through the direct path (or write each one's object with `-c`). This record has
#152's "Done when" measurement: from 1 to 8 lanes on Lua 5.4.8's interpreter,
synth's shape and musl 1.2.5's units, against `make -j8` with `clang -O0` and
with `tcc`, on the 9700X; and the one-file commands against main.

## Sources and host

Each measured tree's `build.sh`, `src` and `tools` are those of a commit
(`receipts/manifest-*.txt`, `sha256sum` of every file, identical to `git archive`
of the commit, checked on the laptop):

- **main:** `9bb5060ebe347de5c7a0a92ba325a7b14a567788`, the branch's merge-base;
- **final:** `965ec185`, the units' arenas kept, the base-page floor and the
  named sections' fix (round 1's head);
- **head:** `64984fac`, `965ec185` with a test change and the merge's
  `--time-stages` mark (round 1's A/B and stages);
- **pool:** `ae5fb51e`, `64984fac` with the arenas' pool (round 2's head; the
  measurements the buster docs report).

The executables' SHA-256, as the logs print them: main
`81181fcd6731fe16ca4dd712c9ab5ef325850f686f877b0855a18b4c72766cf8`, final
`4011c573eae808af34dd75f4b8abc6ab0b18c27f17dd5e555fddc43e1694640e`, head
`8c32acb0fa624ff356e525d7f81bc0b11525a5903dd38883dc94eb3f07b93583`, pool
`b8689b240be5a9b34aeeecf50d68c315300ec9de1b90983269c6166d4007e249`. Each was
built with `BUSTER_DEBUG_INFO=0 ./build.sh`, as the 9700X job builds.

Host (`receipts/receipts.log`): AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang
23.1.1, tcc 0.9.28rc, GCC 16.2.1, GNU make 4.4.1, perf 7.2.9; transparent huge
pages `always`, defrag `madvise`. CPU 2's governor was `performance` and CPUs 0,
1 and 3 to 7's `powersave`: the multicore rows ran on all eight, under those
governors, for every compiler alike.

Inputs (`receipts/receipts.log`): `sqlite3.c` SHA-256 `b1dd5d74…db28189`; Lua
5.4.8's `src` (its 34 `.c` files, of which the interpreter's 33 but `luac.c`);
synth's shape, `test-check-units --generate`'s 512 units of 200 functions;
musl 1.2.5's library sources, selected for x86-64 as its Makefile selects them
(1,309; `measure2.sh`), of which the driver compiles 1,006 and refuses 303 as
unsupported: every compiler compiles those 1,006 with the same options
(`round2/makefiles/musl.mk`).

## Method

Every build, test and measurement took the host's lock (`exclusive.sh`) for
itself; each corpus's rows are one hold. `scripts/measure2.sh` times each
command as a whole process (`time-runs`: a warm-up, then 5 runs in an order
that rotates by run, and each one's median), on CPUs 0 to 7, one per core.
Buster's commands give `--lanes N`; make's rows compile the same units one
process each and link as buster does (Lua and synth; musl's are `-c`). The
one-file A/B (`scripts/ab.sh`, and `final2.sh`'s copy of it) runs `perf stat -r
11` on CPU 2, in three rounds of a rotating order, of main, an A/A copy of
main's executable and the head. The lock's waiting messages name other jobs:
`scripts/keep_own_lines.py` kept only the lines the scripts and the tools print.

## Results (pool, `ae5fb51e`, `round2/final2.log`)

| milliseconds | buster, 1 lane | 2 | 4 | 8 | `make -j8`, clang -O0 | `make -j8`, tcc | `make -j1`, tcc |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Lua, linked | 76.1 | 45.8 | 32.4 | 30.9 | 141.2 | 18.6 | 86.4 |
| synth, linked | 1,546.6 | 884.9 | 607.5 | 532.7 | 2,482.9 | 507.6 | 1,503.5 |
| musl, `-c` | 625.5 | 381.7 | 260.4 | 232.7 | 1,675.7 | 149.4 | 979.3 |

Lua's `make -j1` with clang took 618.8 ms. The driver's executables printed
what the make-built ones print (Lua's `print(6 * 7)`, synth's checksum).

Synth's link by `--time-stages` (three runs): on 8 lanes 485 ms of 533 in the
units' lanes, 19 ms merging their links (`code-atoms`) and 25 ms binding and
writing; on one lane 1,510, 19 and 27 ms.

The one-file A/B (`round2/ab/`, medians of the three rounds):

| | main | main's copy | pool |
| --- | ---: | ---: | ---: |
| `-c sqlite3.c`, user instructions | 1,243,623,074 | 1,243,623,098 | 1,244,367,336 |
| `-c sqlite3.c`, user cycles | 574.39 M | 575.12 M | 573.80 M |
| `-c sqlite3.c`, task clock | 121.32 ms | 121.27 ms | 120.86 ms |
| `-fsyntax-only sqlite3.c`, user instructions | 946,882,976 | 946,883,627 | 947,056,569 |
| `-fsyntax-only sqlite3.c`, user cycles | 439.45 M | 437.81 M | 440.02 M |
| `-fsyntax-only sqlite3.c`, task clock | 95.50 ms | 95.19 ms | 95.50 ms |
| `-o` of c-testsuite's `00220.c`, user instructions | 21,413,378 | 21,413,398 | 21,434,532 |

`-c`'s object was main's, byte for byte.

## Round 1 (before the pool)

`round1/final.log` (final, `965ec185`) has the same table's Lua and musl rows,
`round1/synth2.log` its synth rows:

| milliseconds | buster, 1 lane | 2 | 4 | 8 | `make -j8`, clang -O0 | `make -j8`, tcc | `make -j1`, tcc |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Lua, linked | 80.3 | 49.1 | 36.5 | 34.6 | 135.4 | 19.6 | 85.2 |
| synth, linked | 1,635.9 | 973.2 | 760.6 | 687.7 | 2,467.5 | 502.7 | 1,517.6 |
| musl, `-c` | 741.7 | 496.5 | 413.4 | 429.3 | 1,675.3 | 146.9 | 1,065.6 |

`round1/final.log`'s own synth rows are wrong: `measure.sh` gave the 512 units'
names one per line inside the `sh -c` command, so each command compiled
`unit_0.c` alone (about 50 ms) and ran the other lines as commands.
`measure2.sh`, which `synth2.log` and round 2 ran, puts them on one line.

musl's 8 lanes, more than its 4, are what `round1/profile/` profiles (final,
`perf record -g` at 4,999 Hz): 83% of the samples were the kernel's, 45%
`osq_lock` under `rwsem_down_write_slowpath`, the address space's lock taken
for writing by `madvise` (18%), `munmap` (16%) and `mmap` (10%); task clock
2,750 ms on 8 lanes against 725 ms on one, and 54,293 context switches against
44; `strace -c` counted 108,938 `madvise`, 67,563 `munmap` and 67,577 `mmap`
calls for the 1,006 units. The pool (`ae5fb51e`) answers it.

`round1/final.log` also has a one-file `time-runs` A/B of final against main
(15 runs, CPU 2: `-c sqlite3.c` 123.70 ms main, 123.82 ms final, the same
object; with a tiny second unit 124.44 ms), and `round1/ab.log` with
`round1/ab/` the `perf stat` A/B of head against main, before the pool: `-c`
+1,318,357 instructions (+0.106%), `-fsyntax-only` +725,430 (+0.077%), task
clock within the A/A copy's spread. `round1/stages.log` has head's tests and its
`--time-stages` of synth's and Lua's links.

## The laptop

`laptop/` has the comparisons that chose the pool's shape, on the laptop (Ryzen
9 7940HS, Zen 4), of c-testsuite's 220 programs five times over (1,100 units,
`-c`; `scripts/localp2.sh`): tree-8 is `64984fac`'s code without the pool, p1
the pool with the units' three big arenas kept (`ae5fb51e`), p2 the pool with
those arenas pooled too. `peak-instructions.log` (`scripts/localnp.sh`) counts
the instructions of main, p1, and p1 without `arena_push`'s peak, on
`sqlite3.c`.

## Limitations

- One machine, one session's runs, between other jobs' holds of the lock; the
  medians are of 5 runs (15 for round 1's `time-runs` A/B, 3 rounds of 11 for
  `perf stat`).
- `measure2.sh` drops `time-runs`' per-run lines; its summary line ("0 failed
  processes") says every run's status was its warm-up's.
- The governors above, and transparent huge pages `always`.
- The `osq_lock` profile is of `965ec185`; the pool's effect on it is the
  timings' and the laptop's system-call counts, not a second profile.
