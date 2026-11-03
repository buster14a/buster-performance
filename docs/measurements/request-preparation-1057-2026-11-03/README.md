# One request's configuration and source preparation: their cost (#1057), 2026-11-03

Evidence for buster14a/buster#1057's last done-when item: the preparation cost of
buster14a/buster#1141, which made the C driver and the real-source benchmarks
share one request's configuration (`c_check_request.c`) and one source
preparation (`c_check_source_prepare.c`), measured on the locked 9700X.

**Result:** no measurable cost. Per command, the merge runs between 1,604
fewer and 587 more instructions than main, out of 1.4 million (a tiny file) to
1.2 billion (`sqlite3.c`'s `-c`): 0.00003% of `sqlite3.c`'s compile, which
leaves no per-token tax. Wall time is within each build's own spread, at most
1.2% apart at the median. Every `-c` object is byte for byte main's. The
source benchmarks time the same work: their counts and timed regions are
the same, and only the merge prints its configuration receipt.
`benchmark-lowering-source`'s process runs 0.031% more instructions, outside
its timed region and in no more time: its preparation now selects and checks
the file's target features once, as `-c` does.

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
| `benchmark-backend-source` `sqlite3.c` | 5 | 656.661 → 660.375 (+0.57%) | 3,504.737 → 3,523.936 (+0.55%) | 9,630,170,403 → 9,629,561,143 (−609,260) |
| `benchmark-lowering-source` `sqlite3.c` (third hold) | 5 | 1,024.968 → 1,023.769 (−0.12%) | 5,520.128 → 5,512.423 (−0.14%) | 14,479,142,381 [14,479,142,077–14,479,143,144] → 14,483,648,230 [14,483,648,003–14,483,654,450] (+4,505,849) |

The wall times' ranges overlap in every row (the logs' `(min to max)`), and
user cycles move by less than 1% either way: the 9700X shows no time cost.
The instruction counts, which vary by at most 900 within a build, show the
change's whole per-command work. The driver's argument scan
(`check_request_scan`) and refusal (`check_request_refusal`) replace the loop's
own comparisons, and the shared program options replace a copy of the same
three fields, so a tiny file's `-c` runs 829 fewer instructions and
`sqlite3.c`'s 397 more, whatever the input's size: no work per token.

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

## Limitations

- One host, one CPU (2), one session's run; the 9700X was shared through its
  lock with CI and other sessions between the holds, never during them.
- `time-runs` times whole processes, so the instruction counts include process
  start and exit, which both builds share.
- The record compares #1141's merge with its first parent only: it doesn't
  measure later commits, which have changed the same files since.
