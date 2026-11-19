# The records' bytes without their four gathers (buster#2850), 2026-11-19

The evidence for the piece specified in
[buster#2850's comment](https://github.com/buster14a/buster/issues/2850#issuecomment-7020847483): the sweep that makes
the byte columns the tests' loop and C's read (`node_tests_window_bytes_by` in `c_check_node_census.c`) takes four
columns of a chunk's records, sixteen a step, by sixteen loads and twelve permutes where it took them by four gathers.

The 9700X, CPU 2, Release, each run its own hold of the lock, TSC ticks a record; a reading runs each build, or each
setting, in turn.

## 1. The first experiment, before the specification (`9700x/results/first/`)

Two experiment builds on PR buster#3030's sources (`patches/first-experiment.diff`, and with a switch,
`patches/first-experiment-switch.diff`): `gat1` against the build before, `br2` (`9700x/job-gat.sh`, `gat1-table.txt`),
and `gat1x`, one executable that reads the columns by the gathers where `BUSTER_TESTS_SKIP=1`
(`9700x/job-gat-knob.sh`, `gat1x-table.txt`). The readings kept here are each run's `node-shadow: window` lines and its
status.

## 2. The piece's code (`9700x/results/br2-vs-gat2/`, `9700x/results/gat2x/`)

`9700x/job-gat2.sh`: the piece as it is in the pull request, on the same sources (`gat2`), against `br2`, seven
readings (`gat2-table.txt`, by `gat-table.py`); and with the switch (`gat2x`, `patches/switch-on-the-piece.diff`),
loads, gathers, gathers, loads in each of seven readings (`gat2x-table.txt`, by `gat-knob-table.py`).

| the records' bytes | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| build against build: before, with | 9.16, 7.58 | 10.78, 9.33 | 19.67, 19.48 |
| with less before | -1.65 (-1.72 to -1.35) | -1.49 (-1.86 to -0.64) | -0.48 (-3.57 to 6.54) |
| the switch: loads less gathers | -2.41 (-2.51 to -2.32) | -2.35 (-2.40 to -2.27) | -3.00 (-3.61 to -2.14) |
| the same where the sweep makes C's bytes too | -2.44 (-2.52 to -2.36) | -2.55 (-2.79 to -2.43) | -3.68 (-5.80 to -2.69) |

By the switch on `sqlite3.c` and Lua: the tests on the window's sum -2.52 and -2.26; the tests' loop -0.03 and +0.07;
an expression's part -0.03 and +0.03; the tests on T's records -0.03 and +0.03; C's three sweeps a record swept -0.04
and +0.04; C's loop -0.06 and +0.04; the targets 0.00 and 0.00.

The shadow's count lines of `gat2` are `br2`'s in each of the 42 readings (seven of the tests on the window and
seven of C on the window on each corpus), and no run of the switch has a status but 0.

## 3. The piece on main (`9700x/results/gat3/`, `gat4/`, `gat5/`)

- `9700x/job-gat3.sh b84780116`: `patches/sweep-main.diff`, the piece before its verify's count (section 4), on main
  `b84780116`. `test-checker`'s eight parts pass (`status.txt`), and C on the window's count lines on the three
  corpora are main's (`counts-gat3-*.txt` and `counts-main3030-*.txt`).
- `9700x/job-gat4.sh b84780116`: `patches/sweep-main-2.diff`, the piece as the pull request has it, on the same main.
  The eight parts pass, and the count lines are main's.
- `9700x/job-gat5.sh 3741c264f`: the same patch on main `3741c264f`, the pull request's base, against that main's
  own build (`main3069`). The eight parts pass (305,680, 27,560, 21,758, 58,649, 210,379, 85,528, 71,460 and 63,262
  checks), and the count lines of the tests on the window and of C on the window on the three corpora are main's
  (`counts-tests-*.txt`, `counts-contexts-*.txt`).

`9700x/count-lines.py FILE` prints a run's lines with their times left out; two runs' counts are the same where its
outputs are.

## 4. Faults (`9700x/faults/`)

`job-faults-gat.sh`: `faults-gat.py`'s 37 faults, one at a time in the piece's tree on the 9700X: each of the
permute's sixteen indices naming the other record of its register, one index a column naming the other register's
record, each of the eight shuffles' selections, each column's mask of the placed records dropped, each load's place
and the permute's two registers swapped; an incremental Release build and `test-checker`'s part 5 of 8 for each.

`faults.txt`, the piece before its verify's count: the control passes, 34 faults are caught and 3 pass: the mask of
the placed records dropped from the flags', the objects' and the standings' column. A record the kernel didn't place
then has bytes, and no test read them (the same fault of the words' column fails one check).

The sweep's verify then got a count of such records (a record the kernel didn't place that has a byte, into
`own_values_wrong`, which the tests pin at zero): `patches/sweep-main-2.diff`. `job-faults-gat2.sh`,
`faults-round2.txt`, on that code: the control passes, and the four columns' masks dropped are caught, each of them.

## 5. The cloud container (`cloud/`)

`checks-progress.txt`, on main `b84780116` with the piece before its verify's count: a native Release build;
`test-checker`'s eight parts (`test-checker/`); C on the window on the three corpora and the compiler's own source
with the default warnings and with `-Wall -Wextra` (`shadow/`: the counts of buster#3030, no difference); the shadow's
eleven other modes on `sqlite3.c` and Lua; the self-check, the self-parse and the call graph; the build's ownership
check; and the complete driver's lists (`complete-light-items.txt`: one item fails in this container, as on main).

`head/`, the same checks on the pull request's head (`447ef81fb`, the piece on main `3741c264f`):
`checks-progress.txt`; `test-checker`'s eight parts pass (`test-checker-status.txt`); and the shadow's sixteen runs
read the counts of the run above, each (`shadow-counts.txt`: a run's lines with their times left out, by
`9700x/count-lines.py`, as a digest before and on the head).

`sanitizers-progress.txt`: the rows a pull request's checks skip (memory, address and thread, native), on main
`b84780116` with `patches/sweep-main-2.diff`: the node machine's part of `test-checker` (5 of 8) under each, and under
memory and address the tests on the window and C on the window on `sqlite3.c`, Lua and the compiler's own source. No
report in any of the fifteen runs.
