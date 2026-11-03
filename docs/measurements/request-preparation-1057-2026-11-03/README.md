# One request's configuration and source preparation: their cost (#1057), 2026-11-03

Evidence for buster14a/buster#1057's last done-when item: the preparation cost of
buster14a/buster#1141, which made the C driver and the real-source benchmarks
share one request's configuration (`c_check_request.c`) and one source
preparation (`c_check_source_prepare.c`), measured on the locked 9700X.

**Result**, for the inputs and method below (whole processes on one CPU,
medians of 5 to 41 runs):

- The C driver's commands run between 20,003 fewer and 587 more instructions
  per command than main's. The single files (a tiny file, `tools/ci/changes.c`,
  `sqlite3.c`) differ by 1,604 fewer to 587 more; Lua 5.4.8's 33 units in one
  command by about 20,000 fewer, about 600 per unit. On these inputs, from
  1.4 million instructions (a tiny file) to 1.2 billion (`sqlite3.c`'s `-c`),
  the difference doesn't grow with the input: they show no added work per
  token.
- Time: the merge costs slightly more user cycles, while its retired
  instructions fall for the tiny file, `changes.c` and Lua's units and rise
  slightly for `sqlite3.c` (397 more by `-c`, 587 by `-fsyntax-only`). In the
  first holds, one executable per tree, its runs were
  slower in most pairs on several rows (Lua's user cycles in 11 of 11), with
  medians within 1.22% of main's. Over six placements of the checker's code
  and three copies each, in three rounds ("Placements" below), its user
  cycles are 0.09% to 0.26% above main's for Lua's units and `sqlite3.c`,
  where main against itself moves −0.10% to +0.07%, and 2.8% to 3.1% above
  for the tiny file's 1-ms `-c`, where main against itself moves 1.5% to 1.8%.
  Every range over the placements includes 0 except the tiny file's, whose
  floor's range doesn't either. That cost doesn't grow with the input:
  `sqlite3.c`'s 526 million cycles show no more of it than Lua's. The record
  doesn't attribute it: retired-instruction totals don't explain it, and they
  can't rule out a change in instruction mix, dependencies or execution cost;
  nor do placements of one unit sample the rest of the executable's layout.
- Every `-c` object is byte for byte main's, Lua's 33 included.
- The source benchmarks report the same counts and timed regions on both
  builds, and only the merge prints its configuration receipt. Their whole
  processes do differ: `benchmark-backend-source`'s runs 609,260 fewer
  instructions (0.006%), and `benchmark-lowering-source`'s 4,505,849 more
  (0.031%) in no more wall time, for the selection and target-feature check
  that its preparation now runs once per file, as `-c` does, outside the
  timed region.

## Source revisions and trees

- main: `754475d4cc8f27813cf0b2f029fbae0012ab11fe`, the first parent of
  #1141's merge on buster14a/buster `main`.
- head: `4670b2ebf5ca104feb5c902015ad6a2179d8c2e7`, #1141's merge.

Each tree is `git archive` of its commit, sent to the 9700X by tar.
`trees/manifest-*.txt` are the trees' `sha256sum`s made before sending
(`LC_ALL=C` order), and `logs/host-manifest-*.txt` the host's of the same
trees before building: they are equal (`logs/receipts.txt`: "manifest
matches", 1,083 and 1,087 files).

Both were built with `BUSTER_DEBUG_INFO=0 ./build.sh` (`-march=native`, which
is znver5 there), each in its own hold of the host's lock
(`logs/build-*.log`). `logs/receipts.txt` has the executables' `sha256sum`s.

## Host

The Ryzen 7 9700X (`logs/receipts.txt`): Linux 6.18.50-2-lts, clang 23.1.1,
transparent huge pages `always`. CPU 2's governor and EPP are `performance`;
CPUs 0, 1 and 3 to 7 are `powersave` with `balance_performance`. Every timed
process ran on CPU 2 (`taskset -c 2`).

## Commands

`scripts/run.sh` builds the trees, then holds the lock once for
`logs/measure.sh`, which runs, with main's executable driving `time-runs`
(whole processes, the builds interleaved in a rotating order, one warm-up):

- a tiny file (`inputs/tiny.c`: one function, no header) by `-c` and by
  `-fsyntax-only`, 41 runs (`logs/tiny.log`);
- main's `tools/ci/changes.c` by `-c`, 21 runs (`logs/changes.log`; its
  `sha256sum` in the receipts is the tree's file's);
- the frozen corpus's `sqlite3.c` by `-c` and by `-fsyntax-only`, with its
  pinned predefines and headers as the 9700X workflow passes them, 11 runs
  (`logs/sqlite.log`; the file's `sha256sum` in the receipts);
- `benchmark-backend-source` over `sqlite3.c`, 5 runs
  (`logs/backend-source.log`);
- each build's `-c` objects of the three files, compared byte for byte
  (`logs/receipts.txt`: "objects identical", with their `sha256sum`s).

`scripts/corpus.sh`, in a fourth hold, added a representative multi-file
corpus beside `sqlite3.c`: Lua 5.4.8's 33 units but `luac.c`, the sources
#1128's record measured, copied on the host and not into this record
(`logs/lua-sources.txt`: their `sha256sum`s, the same as that record's), with `-std=gnu99 -DLUA_COMPAT_5_3
-DLUA_USE_LINUX -w`, as one command by `--lanes 1 -fsyntax-only` and by
`--lanes 1 -c`, 11 runs (`logs/lua.log`), then each build's 33 objects
compared byte for byte (`logs/receipts.txt`: "lua objects identical";
`logs/lua-objects.txt`).

`time-runs` keeps no output of the processes it times, so `scripts/outputs.sh`,
in a second hold, ran each source benchmark once per build for its own report
(`logs/output-*-754475d4.log`, `logs/output-*-4670b2eb.log`).
`logs/lowering-source.log`'s runs measured nothing: `benchmark-lowering-source`
refuses `--no-default-config` ("unknown argument", on both builds), which the
record had passed it as it passes `benchmark-backend-source`. `scripts/lowering.sh`,
in a third hold, ran it again without that option, as its own report
(`logs/output-lowering-source-2-*.log`) and interleaved by `time-runs`
(`logs/lowering-source-2.log`).

Every step's exit status is in `logs/receipts.txt`; every timed process exited
as its first warm-up did, 0 for all but the refused `benchmark-lowering-source`
runs, which exited 1 on both builds.

## Results

Medians (`time-runs`): wall time, user cycles and user instructions, the
instructions' range over the runs in brackets.

| command | runs | wall ms, main → head | user cycles (M), main → head | instructions, main → head |
| --- | ---: | --- | --- | --- |
| tiny `-c` | 41 | 0.831 → 0.839 (+0.96%) | 1.242 → 1.236 (−0.49%) | 1,531,831 [1,531,822–1,531,876] → 1,531,002 [1,530,989–1,531,022] (−829) |
| tiny `-fsyntax-only` | 41 | 0.735 → 0.744 (+1.22%) | 1.101 → 1.090 (−0.93%) | 1,428,388 [1,428,377–1,428,405] → 1,427,677 [1,427,673–1,427,696] (−711) |
| `changes.c` `-c` | 21 | 7.917 → 7.883 (−0.42%) | 25.936 → 26.095 (+0.61%) | 63,570,059 [63,569,795–63,570,489] → 63,568,455 [63,568,143–63,568,663] (−1,604) |
| `sqlite3.c` `-c` | 11 | 112.309 → 112.223 (−0.08%) | 527.823 → 528.570 (+0.14%) | 1,215,785,766 [1,215,785,749–1,215,785,907] → 1,215,786,163 [1,215,786,154–1,215,786,178] (+397) |
| `sqlite3.c` `-fsyntax-only` | 11 | 89.167 → 89.370 (+0.23%) | 406.938 → 408.998 (+0.51%) | 903,854,433 [903,854,418–903,854,452] → 903,855,020 [903,855,006–903,855,039] (+587) |
| Lua's 33 units `--lanes 1 -fsyntax-only` | 11 | 59.950 → 60.159 (+0.35%) | 270.722 → 271.893 (+0.43%) | 741,327,601 [741,323,246–741,328,194] → 741,307,598 [741,304,929–741,308,133] (−20,003) |
| Lua's 33 units `--lanes 1 -c` | 11 | 70.094 → 70.599 (+0.72%) | 319.846 → 322.033 (+0.68%) | 847,785,264 [847,780,795–847,786,094] → 847,765,941 [847,764,487–847,766,774] (−19,323) |
| `benchmark-backend-source` `sqlite3.c` | 5 | 656.661 → 660.375 (+0.57%) | 3,504.737 → 3,523.936 (+0.55%) | 9,630,170,403 → 9,629,561,143 (−609,260) |
| `benchmark-lowering-source` `sqlite3.c` (third hold) | 5 | 1,024.968 → 1,023.769 (−0.12%) | 5,520.128 → 5,512.423 (−0.14%) | 14,479,142,381 [14,479,142,077–14,479,143,144] → 14,483,648,230 [14,483,648,003–14,483,654,450] (+4,505,849) |

The wall times' ranges overlap in every row (the logs' `(min to max)`), and
user cycles move by less than 1% either way, but paired by run number the
merge is slower in most pairs of several rows: Lua's `-c` in 10 of 11 (user
cycles higher in 11 of 11), its `-fsyntax-only` in 9 (11), the tiny file's
`-c` in 31 of 41 (17), and `benchmark-backend-source` in 5 of 5 (5). One
executable per tree can't tell that from code placement, which "Placements"
measures. In the single-file rows and
`benchmark-backend-source`'s, the instruction counts vary by under 900 between
a build's runs; in Lua's by up to 5,299, and in `benchmark-lowering-source`'s
by 1,067 for main and 6,447 for the head. Each row's difference is larger
than its spread, so it is the change's own per-command work. The
driver's argument scan (`check_request_scan`) and refusal
(`check_request_refusal`) replace the loop's own comparisons, and the shared
program options replace a copy of the same three fields: a tiny file's `-c`
runs 829 fewer instructions and `sqlite3.c`'s 397 more, and on these inputs
the difference doesn't grow with their size. Lua's 33 units in one command run
about 600 fewer instructions per unit.

`benchmark-backend-source` now prepares its file as `-c` does, the
target-feature check included, outside its timed region. Its whole process
runs 609,260 fewer instructions (0.006%). Its report
(`logs/output-backend-source-*.log`) is the same on both builds: 2,602
functions, 396,829 typed entries and 364,086 records, and the same
instructions per entry in each timed variant (vector 163.62, scalar 533.53,
sizing 11.45, encode 14.14, validate 31.36, validate-scalar 135.20, choose
2.92, choose-scalar 20.11). Only the merge prints the configuration receipt:
`configuration=44600aab6807bccb target=znver5 ... language=gnu17 unwind=on
debug=off overrides=path:vector,selection:reachable,unwind:off,debug:off`.

`benchmark-lowering-source` (`logs/lowering-source-2.log`, the third hold) runs
4.5 million more instructions per process (0.031%), and no more time. #1141 made
its preparation `-c`'s, which now selects the file's referenced definitions and
checks their target features once (`CheckSourceRequest.select`), before the
benchmark's own runs, which each select for themselves. That work is outside
the benchmark's timed region, which it doesn't change: its report
(`logs/output-lowering-source-2-*.log`) gives both builds the same 2,608
functions defined, 2,602 lowered and 6 skipped, 2,066 objects defined and
2,036 lowered, and timed lowerings of 20.85 ms and 20.76 ms (main) and
20.83 ms and 20.81 ms (head) for the referenced definitions and for all of
them. Only the merge prints the receipt:
`configuration=7fe5e2819be8e031 target=znver5 ... language=gnu17 unwind=on
debug=off overrides=path:vector,selection:reachable+all,unwind:off,debug:off`.

## Placements

`scripts/placements.sh`, the fifth step, measures the first holds' paired
direction as `docs/profiling.md`'s "Builds over their code's placements and
copies" does (#509). Each tree's checker unit (`main_unit_checker.c`, the
unit #1141 changed) is linked at six placements, shifted by 0, 640, 1344,
2048, 2752 and 3456 bytes (multiples of its `.text`'s 64-byte alignment; a
first attempt with shifts of 688 bytes failed to build, `logs/*-attempt1.log`)
by each tree's own `./build.sh shifts`, each build in a hold of the lock
(`logs/shifts-build-*.log`; the executables' `sha256sum`s in the receipts).
Three rounds of `ab` (each `time-runs` process in a hold of its own) then ran
main's placements, the merge's and main's again (`main-again`, the
comparison's own floor), three fresh copies each, 3 runs, 54 processes per
build and command, on CPU 2 (`logs/placements.log`).

User cycles against main, by round (the median's difference; in brackets the
difference's range over the placements):

| command | head | main-again |
| --- | --- | --- |
| Lua's 33 units `--lanes 1 -c` | +0.23% [−0.45, +0.74], +0.25% [−0.31, +0.55], +0.23% [−0.29, +0.54] | +0.03%, −0.08%, −0.01% |
| Lua's 33 units `--lanes 1 -fsyntax-only` | +0.09% [−0.31, +0.74], +0.25% [−0.44, +0.82], +0.26% [−0.01, +0.67] | +0.05%, +0.05%, +0.06% |
| tiny `-c` | +2.83% [+2.13, +4.00], +2.78% [+1.28, +4.33], +3.06% [+2.23, +4.24] | +1.69% [+0.32, +2.50], +1.54% [+0.05, +2.60], +1.76% [+0.98, +2.31] |
| `sqlite3.c` `-c` | +0.14% [−0.36, +0.36], +0.16% [−0.36, +0.44], +0.09% [−0.57, +0.44] | +0.07%, +0.05%, −0.10% |

Wall time against main: Lua's `-c` +0.22%, +0.16% and +0.17% (main-again
−0.02%, −0.18%, −0.01%), Lua's `-fsyntax-only` +0.14%, +0.27% and +0.26%
(+0.04%, −0.05%, +0.09%), `sqlite3.c`'s `-c` +0.04%, +0.13% and −0.09%
(−0.06%, +0.02%, −0.11%), and the tiny file's +2.20%, +0.89% and +0.50%
(+0.19%, +0.12%, +0.47%), whose placements spread 7% to 19% in wall time.

By `docs/profiling.md`'s criterion (within the floor when the difference is
within main against itself and its range over the placements includes 0), the
merge's cycles exceed the floor in every round for Lua's `-c` and the tiny
file, in two of three for Lua's `-fsyntax-only` and `sqlite3.c`. The excess
is about 0.1 to 0.25% of the larger compiles and about 1.2 percentage points
(about 25,000 cycles) of the tiny file's. Retired instructions fall in Lua's
and the tiny file's rows and rise in `sqlite3.c`'s (397 more of 1.2 billion),
so their totals don't explain the excess, and they can't rule out a change in
instruction mix, dependencies or execution cost. The placements move only the
checker's unit, and the rest of #1141's executable differs from main's too.
The record leaves the excess's cause open.

## Limitations

- One host, one CPU (2), one session's run; the 9700X was shared through its
  lock with CI and other sessions between the holds, never during them.
- The corpus is two programs: `sqlite3.c`, one large unit, and Lua's 33
  units. Other programs' inputs (more headers, other options) may differ.
- Medians of 5 to 41 runs bound what the first holds' wall times can show; the
  placements' 54 processes per build and command, in three rounds, resolve
  about 0.1% of user cycles on the larger compiles.
- The placements shift one unit; other differences between the two
  executables' layouts aren't sampled.
- `time-runs` times whole processes, so the instruction counts include process
  start and exit, which both builds share.
- The record compares #1141's merge with its first parent only: it doesn't
  measure later commits, which have changed the same files since.
