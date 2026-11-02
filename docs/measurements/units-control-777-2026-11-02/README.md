# A few large units by one command, against their processes verified, buster#777, 2026-11-02

[buster#777](https://github.com/buster14a/buster/issues/777) asks that a command of a few large units
(`sqlite3.c shell.c`, with `-c` and linked) be no slower than its units' processes run at once, and that Lua's,
synth's and musl's commands of #763's record stay as fast, with their peaks. #834's record
([afdfdd40](https://github.com/buster14a/buster-performance/tree/afdfdd4051b834e5a880766a87bf7f464be3b437/docs/measurements/units-functions-777-cache-776-2026-10-29))
compared the one command with two processes that its scripts waited for without checking their statuses or outputs.
This record has that control verified, attributes what the one command spends against its processes, and measures
the change that came of it: a units lane frees its memory as soon as it has no unit left to take, and with `-c` the
lane that stops last leaves its memory to the process's exit.

## Sources and trees

Every measured tree is `git archive` of a commit of buster14a/buster: `receipts/manifest-tree-*.txt` (`sha256sum` of
every file, made on the host, `build/` and the `COMMIT` file aside) are identical to the same of `git archive` of
the commit, checked on the laptop (`receipts/manifests-checked.txt`).

- **main:** `3ce71ec312efb45fbcab4d66775e069e30d7e513`.
- **head 1:** `7fd7aab18145b9de582e1462eb0d3f25b09b8f06`, on main: the lanes release their memory as soon as they take
  no units, before they help the others' emissions; in a command that releases no memory (main's), the lane that stops
  taking units last leaves its memory to the exit.
- **head 2:** `1177419c6cb96e9b95babcb96b393874cf37b60a`, on head 1: before a link, the last lane releases its memory
  too. Its `-c` is head 1's. Both are on buster's branch `claude/solve-777-02d567`.
- **Experiments**, local commits on main that were not pushed; `experiment/*.diff` is each one's diff against main:
  `c190a293` (a trace of each unit's stages and each lane's times, `BUSTER_777_TRACE=1`), `1ef2b35a` (candidate A:
  the early release alone), `a4fdd67a` (candidate B: head 1 before its tidying) and `08ede275` (candidate C: no lane
  releases its memory in a command that releases none).

Each was built with `BUSTER_DEBUG_INFO=0 ./build.sh`. The executables' SHA-256 are in the logs: main `9230ca8d…`,
head 1 `2138c848…`, head 2 `036e758a…`, the trace `36cec227…`, A `8ba8b5d8…`, B `de01895f…`, C `8f20566c…`.

## Host and inputs

AMD Ryzen 7 9700X (`benchpress`), Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9-1, GCC 16.2.1 (`cc`), mold 3.0.0.
CPU 2's governor and EPP are `performance`; CPUs 0, 1 and 3 to 7 run `powersave` with `balance_performance` (each
log's head lists them). Every run is on CPUs 0 to 7, one CPU per core.

- SQLite 3.53.4's amalgamation: `sqlite3.c` (9,515,341 bytes, SHA-256 `b1dd5d74…a8db28189`) and `shell.c` (1,185,915
  bytes, `8011ed01…11c85179`).
- Lua 5.4.8's interpreter, its 33 units but `luac.c`, linked with `-std=gnu99 -U__ELF__ -DLUA_COMPAT_5_3
  -DLUA_USE_LINUX -lm -ldl`; synth, `test-check-units --generate`'s 512 units of 200 functions, linked; musl 1.2.5's
  library units with `-c`, the x86_64 sources in place of the generic ones they replace (1,309 units, all of which
  compile now), as in #763's and #834's records.

## Method

Every build, test and measurement held the host's lock (`exclusive.sh`) for itself. Whole processes are `time-runs`
(`build/compiler time-runs --executable /bin/sh`): a warm-up, then N runs in an order that rotates by run, each run's
wall time, user and system time, `wait4`'s peak resident set (of the shell and the children it waited for), faults,
user cycles and instructions, and its exit status, which must be the warm-up's: every list here exited 0 in every run
(the logs' `runs with status 0` lines count them, and `time-runs: done, 0 failed processes`).

- **The one command:** `rm -f sqlite3.o shell.o && compiler -c sqlite3.c shell.c && test -s sqlite3.o && test -s
  shell.o`, and linked, `rm -f sq && compiler -o sq sqlite3.c shell.c -lm && test -x sq`.
- **The two processes at once:** `rm -f sqlite3.o shell.o && { compiler -c sqlite3.c & a=$!; compiler -c shell.c &
  b=$!; wait $a; sa=$?; wait $b; sb=$?; test $sa = 0 && test $sb = 0; } && test -s sqlite3.o && test -s shell.o`: each
  process's status checked, its object removed before and required after. Linked, the same and then `cc -o sq
  sqlite3.o shell.o -lm`, or `cc -fuse-ld=mold`, and `test -x sq`. The processes are those of the head's executable in
  each comparison (a command of one file runs the same instructions by main and by the heads, below).
- After each `time-runs`, every list's objects are compared with main's objects of each unit alone (`cmp`), and each
  executable runs `select 6 * 7;` (42).

| script | what |
| --- | --- |
| `scripts/ctl.sh` | main's control: the one command and the two processes, with `-c` and linked, and each unit alone (21 runs) |
| `scripts/probe.sh` | `perf stat -r 11` of the one command and of the two processes, twice each; `--time-stages` of the one command and of each unit alone (5 runs) |
| `scripts/trace.sh` | the trace build's per-unit stages and per-lane times of the one command (7 runs) |
| `scripts/two.sh` | `--time-stages` of each of the two processes run at once (7 runs) |
| `scripts/ab.sh` | the one command by several executables against the two processes, interleaved (21 runs): A, then A, B and C |
| `scripts/final.sh` | head 1: its tests; the control in two rounds of 31 runs, with `cc`'s and mold's links; `--time-stages`; synth's (7 runs) and Lua's links (15) and musl's `-c` (7) by 8 lanes and one; a command of one file by `perf stat -r 11` on CPU 2, three rounds |
| `scripts/lanes.sh` | `test-lanes` by main and head 1, twice each |
| `scripts/final2.sh` | head 2: its units tests; the control in two rounds of 31 runs; synth's and Lua's links by 8 lanes and one |
| `scripts/musl.sh`, `scripts/musl8.sh` | musl's `-c` by head 2 and main (11 runs, 8 lanes and one), and by main, A, head 2 and C (11 runs, 8 lanes) |

`chain*.sh` ran each script after the one before it. `scripts/strip_lock.py` made `logs/` from the host's logs: it
dropped `exclusive.sh`'s waiting messages, which name other jobs, with the lines of their holders' commands, and
nothing else (each dropped line was read).

## Results

### main's control (`logs/ctl-3ce71ec3.log`, `logs/ctl-tree-3ce71ec3/runs.log`, 21 runs)

| ms, median (range) | | peak KiB |
| --- | ---: | ---: |
| one command, `-c` | 114.369 (113.264 to 116.297) | 471,508 |
| two processes, `-c` | 113.787 (112.077 to 115.293) | 367,884 |
| `sqlite3.c` alone | 106.832 (104.773 to 109.430) | 367,960 |
| `shell.c` alone | 36.433 (36.016 to 37.207) | 178,388 |
| one command, linked | 116.343 (114.639 to 120.271) | 479,844 |
| two processes, then `cc`'s link | 129.841 (128.360 to 131.629) | 366,464 |

`perf stat -r 11` (`logs/probe-3ce71ec3.log`), the one command against the two processes, twice each: task clock
198.44 and 198.00 ms against 201.23 and 205.21; user cycles 834.7 and 836.4 million against 839.3 and 852.7; user
instructions 1,671.2 million against 1,672.3; kernel instructions 106.9 and 107.6 million against 83.9 and 84.8;
context switches 255 and 247 against 137.

### Where the one command's time goes (`logs/trace-c190a293.log`, `logs/two-3ce71ec3.log`, `logs/probe-3ce71ec3.log`)

Each unit's stages, medians in ms, alone (`--time-stages`, 5 runs), beside the other in the one command (the trace, 7
runs) and in the two processes (`--time-stages`, 7 runs):

| | alone | one command | two processes |
| --- | ---: | ---: | ---: |
| `sqlite3.c` preprocess | 9.897 | 11.894 | 11.845 |
| `sqlite3.c` parse | 7.251 | 7.820 | 7.848 |
| `sqlite3.c` check-input | 48.667 | 52.839 | 52.379 |
| `sqlite3.c` check-expressions | 14.132 | 13.989 | 13.823 |
| `sqlite3.c` lanes (its functions) | 4.852 | 4.098 | 4.714 |
| `shell.c` preprocess | 4.122 | 4.888 | 4.604 |
| `shell.c` check-input | 15.778 | 23.832 | 23.666 |

The units grow alike in one process and in two: what they share is the machine's memory, not the address space. In
the trace, `sqlite3.c`'s unit ended 110.37 to 111.13 ms into the lanes' run (median 110.66) and the run 1.42 to 1.70
ms after it: lane 0 released its memory in 1.03 to 1.41 ms, and `shell.c`'s lane, whose unit ended 44.7 to 45.4 ms
in, released its own (0.86 to 1.68 ms) only then, after helping, and ended last in 6 of the 7 runs. The trace's
per-unit clocks read the process's `getrusage`, so their system times and faults are the process's.

### The candidates (`logs/ab-candA.log`, `logs/ab-abc.log`, `logs/musl8-v1.log`)

21 runs, medians in ms (peak KiB):

| | main | A | B | C | two processes |
| --- | ---: | ---: | ---: | ---: | ---: |
| `-c` (ab-candA) | 114.666 (471,204) | 114.631 (419,724) | | | 114.249 |
| `-c` (ab-abc) | 114.584 (471,340) | 114.069 (419,912) | 114.034 (419,720) | 113.659 (471,244) | 114.400 |
| linked (ab-candA) | 120.133 | 119.446 | | | 130.901 with `cc` |
| linked (ab-abc) | 119.604 (479,628) | 119.265 (424,052) | 118.298 (423,960) | 118.678 (479,740) | 130.365 with `cc` |

C is as fast as B and keeps main's peak; B was taken. musl's `-c` by 8 lanes (11 runs): main 677.193, A 679.821, head
2 675.924, C 673.423 (peaks 252,872, 251,260, 254,264 and 251,824 KiB).

### Head 1 (`logs/final-7fd7aab1.log`, `logs/final-tree-7fd7aab1/`)

Tests at head 1: `test-check-units` 4,569 checks (4,006 reservations failed in turn), with
`--corpus` on c-testsuite's 879 programs 448, `test-check-lanes` 6,471, `test-checker-driver --executable` 48,303,
`test-check-debug --cross-check` 2,615, all with 0 failures; `test-driver-multicore` passed; the call graph has 0
cycles. `test-lanes` exited 1 once (its sessions' check: 16 wrong; `lane.c` is unchanged); `logs/lanes.log` then has
it pass twice by main and twice by head 1, its sessions 0 wrong.

The control, 31 runs per round, medians in ms (peak KiB):

| | main | head 1 | two processes | with mold's link | with `cc`'s |
| --- | ---: | ---: | ---: | ---: | ---: |
| `-c`, round 1 | 114.234 (471,168) | 113.452 (421,520) | 114.202 (368,220) | | |
| `-c`, round 2 | 114.356 | 113.991 | 113.898 | | |
| linked, round 1 | 119.842 (479,596) | 118.509 (425,672) | | 122.323 | 131.010 |
| linked, round 2 | 119.524 | 118.212 | | 122.252 | 130.559 |

Linked, main's and head 1's executables are the same bytes. By head 1, `--time-stages` of the one command (5 runs):
`total` 110.789 to 114.957 ms, `release` after the lanes 0.041 to 0.084, peak 421,044 to 423,780 KiB.

| ms (peak KiB) | main | head 1 |
| --- | ---: | ---: |
| synth linked, 8 lanes | 628.229 (527,588) | 631.455 (530,784) |
| synth linked, 1 lane | 1,743.044 (327,660) | 1,727.083 (386,020) |
| Lua linked, 8 lanes | 42.162 (197,828) | 40.165 (200,300) |
| Lua linked, 1 lane | 81.696 (59,440) | 80.925 (79,308) |
| musl `-c`, 8 lanes | 674.873 (252,092) | 678.981 (253,888) |
| musl `-c`, 1 lane | 1,043.771 (147,660) | 1,044.715 (149,704) |

Head 1 kept the last lane's memory through a link: synth's and Lua's links by one lane peaked 58 MB and 20 MB higher.
Head 2 releases it before a link.

A command of one file (`-c sqlite3.c`, `perf stat -r 11` on CPU 2, three rounds): user instructions 1,258,485,043 to
047 by main and 1,258,485,008 to 024 by head 1; user cycles 547.8 to 549.9 million and 547.4 to 548.7; task clock
115.73 to 116.01 ms and 115.68 to 115.75. The object is main's.

### Head 2 (`logs/final2-1177419c.log`, `logs/final2-tree-1177419c/`, `logs/musl-1177419c.log`)

Tests at head 2: `test-check-units` 4,562 checks (3,999 reservations failed in turn), with `--corpus` 448, 0 failures; `test-driver-multicore` passed;
the call graph has 0 cycles.

| | main | head 2 | two processes | with mold's link | with `cc`'s |
| --- | ---: | ---: | ---: | ---: | ---: |
| `-c`, round 1 | 114.696 (471,276) | 114.114 (421,472) | 113.819 (368,140) | | |
| `-c`, round 2 | 114.500 | 113.349 | 113.882 | | |
| linked, round 1 | 119.829 (479,752) | 119.010 (425,624) | | 122.356 | 130.921 |
| linked, round 2 | 119.748 | 119.201 | | 122.335 | 131.000 |

| ms (peak KiB) | main | head 2 |
| --- | ---: | ---: |
| synth linked, 8 lanes | 626.216 (528,976) | 621.843 (530,420) |
| synth linked, 1 lane | 1,729.329 (327,724) | 1,732.306 (329,516) |
| Lua linked, 8 lanes | 42.320 (198,888) | 41.122 (199,716) |
| Lua linked, 1 lane | 81.669 (59,580) | 80.928 (61,292) |
| musl `-c`, 8 lanes (11 runs) | 674.418 (252,040) | 678.484 (255,468) |
| musl `-c`, 1 lane (11 runs) | 1,043.837 (147,896) | 1,041.565 (149,632) |

### Against the issue

Over the four rounds of the control, with `-c` the one command took 113.35 to 114.11 ms by the heads (whose `-c` is
the same code), against 113.82 to 114.20 for the two processes (from 0.66% faster to 0.25% slower, round by round)
and 114.23 to 114.70 by main (0.32% to 1.02% slower than the heads in each round, and 0.03% to 0.77% slower than the
processes). Linked, head 2 took 119.01 and 119.20 ms, 2.6% to 2.7% less than the processes with mold's link and 9%
less than with `cc`'s. Lua's, synth's and musl's commands run as main's, within their ranges, with peaks 0.8 to 3.4 MB
above main's.

## Limitations

- The governors were not all `performance`. The control's `-c` differences between the heads and the two processes are
  within the runs' ranges; four rounds of 31 runs give their spread.
- musl's 8-lane medians moved by about 1% between measurements of the same executables (main: 674.4 to 677.2 ms).
- The heads' peaks are 0.8 to 3.4 MB above main's even where nothing they change runs (one lane): a layout's
  executable can take one more 2 MB transparent huge page of its `.bss`; this record doesn't check that.
- main's commands of many units are slower than #763's record (Lua 30.9 ms by 8 lanes then, 42 now; synth 533 and
  626): [buster#1128](https://github.com/buster14a/buster/issues/1128)'s arena commits; this record doesn't
  attribute it.
- The trace build reads the TSC around each unit's and lane's steps, and its per-unit clocks read the process's
  resource use; its stage times are used only beside the two processes' and the alone ones'.
- The experiments' commits weren't pushed; their diffs against main are exact, and their trees' manifests match.
