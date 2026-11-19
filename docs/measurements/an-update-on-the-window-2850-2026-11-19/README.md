# An update on the window (buster#2850), 2026-11-19

The record of [buster14a/buster#2850](https://github.com/buster14a/buster/issues/2850)'s
next piece of C on the window, [buster14a/buster#3025](https://github.com/buster14a/buster/pull/3025):
C's answers for `++`, `--` and the compound assignments, made on the reader's
window by the loop's masks. In the shadow alone (`measure-node-machine
--shadow --window-contexts`): no compile takes C's answers on the window.

- [The specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7011006204),
  with its four gates (U1 exact, U2 what it decides, U3 C's sweeps' cost, U4
  nothing else moves).
- [The note of the form that was refuted, and of the one that replaced it](https://github.com/buster14a/buster/issues/2850#issuecomment-7013427495).
- The design and what it measured: buster's `docs/node-machine.md`, "An
  update on the window".

Every figure below is a TSC tick count on the 9700X (benchpress), CPU 2,
Release, each run its own hold of the host's lock, the two builds of a job in
turn in each reading. The counts are the cloud container's runs.

## 1. What is here

| Path | What |
| --- | --- |
| `census/` | `shapes.py` and `estimate.py`, which mined the census of C's answers (the record `c-answers-census-2850-2026-11-18`) for the updates' shapes and for U2's thresholds, before the code |
| `patches/` | each measured build as a patch on main `041cfd9ed`, the revision the build before (`null2`, #3023's code) was built on: `contexts-upd1.patch` (a rule a record), `-upd2` (the masks as first written), `-upd3` (trimmed), `-upd4` (the pull request's code), `-upd4x` (`upd4` with the switch); `knob-update.patch` is the switch alone, on the pull request's sources |
| `9700x/results/` | every reading's output: `updN/window-contexts-*`, `updN/window-tests-*` and `updN/window-*` the piece's (C on the window, the tests on the window alone, the window without the tests), `null2/contexts-vs-updN-*`, `null2/vs-updN-*` and `null2/vs-updN-window-*` the build before's in the same job, `updN/compile-*.txt` `-c sqlite3.c`, and `upd4x/contexts-on1`, `-off1`, `-off2`, `-on2` the switch's |
| `9700x/docgen-updN.txt` | a job's table (`scripts/docgen-call.py RESULTS updN null2`) |
| `9700x/gate-table.txt` | U3's figure of the build before and of each build in its own job (`scripts/gate-table.py results null2 upd1 upd2 upd3 upd4`) |
| `9700x/knob-upd4x.txt` | the switch's table (`scripts/knob-table.py results upd4x`) |
| `9700x/scripts/` | `job-upd-knob.sh` (the switch's job); the other jobs are `job-call-final.sh HEAD PATCH null2` of the record `a-call-on-the-window-2850-2026-11-19` |
| `probes/` | the statements run one at a time: `updates1.txt` (159) and `updates2.txt` (92), `probe-u2.py` (each statement alone in a function, in a unit with a type in the gs space or with `--flat` in one with none), the final build's four outputs (`*-u13-*`), and the rule's form's output (`updates1-u3.txt`, `probe-u.py`); `atomics.txt` and `literals.txt` are the statements that showed an atomic value that is no lvalue and a compound literal never reach an update on the window |
| `faults/` | `faults5.py` (the last round's list; `run5.sh` a worker), and each round's verdicts |
| `cloud/` | the checks before pushing, the sanitizer rows, and the switch's counts |

## 2. The form that was refuted (`upd1`)

C's plan asked of each update by a rule, a record at a time. Exact, and it
decided what the masks decide. `9700x/gate-table.txt`:

| U3's figure: C's sweeps with the records' bytes, a record of the decided | `sqlite3.c` | Lua |
| --- | ---: | ---: |
| the build before, in the same job | 9.10 | 13.19 |
| with a rule a record | 10.14 | 14.60 |
| the limit, and where it is refuted | 9.1, 9.6 | 13.3, 13.8 |

The rule alone, run again over each chunk's updates
(`update-rule-ticks=` in `9700x/results/upd1/window-contexts-*`): 75.4 ticks
an update on `sqlite3.c`, 82.2 on Lua, 66.8 on musl (medians of 7, 7 and 15
readings). What in the rule costs that was not measured.

## 3. The masks: three builds

`upd2` is the masks as first written (nineteen vector operations a step for
the update), `upd3` after trimming, `upd4` after the faults' rounds (eight):
the pull request's code. U3's figure, before and with, each in its own job:

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| `upd2` | 9.15, 9.03 | 13.11, 13.26 | 29.99, 29.43 |
| `upd3` | 9.03, 8.88 | 12.90, 13.36 | 29.84, 31.83 |
| **`upd4`** | **9.12, 8.90** | **12.93, 13.39** | 30.42, 27.54 |

The loop, a record swept, in its first run over a chunk and in a second run
over the same chunk (before, with):

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| `upd1`, first run | 2.67, 3.87 | 4.06, 5.69 | 7.80, 10.38 |
| `upd2` | 2.67, 3.12 | 4.03, 4.77 | 7.25, 9.21 |
| `upd3` | 2.73, 3.00 | 4.03, 4.81 | 7.60, 9.23 |
| `upd4` | 2.66, 2.97 | 3.98, 4.77 | 8.03, 8.78 |
| `upd1`, second run | 1.95, 2.53 | 2.18, 2.66 | 2.26, 2.92 |
| `upd2` | 1.95, 2.25 | 2.19, 2.44 | 2.26, 2.61 |
| `upd3` | 1.95, 2.17 | 2.17, 2.45 | 2.27, 2.83 |
| `upd4` | 1.95, 2.16 | 2.17, 2.38 | 2.27, 2.62 |

The loop's function, in the 9700X's builds (`nm -S`): 4,920 bytes before;
5,852 and the rule's 649 in `upd1`; 6,294 in `upd2`, 6,190 in `upd3`, 6,140
in `upd4`. On Lua fewer operations did not move the first run's figure (4.77,
4.81 and 4.77).

`upd4` against the build before (`9700x/docgen-upd4.txt`): the kernel in place
17.56 and 17.41, 22.43 and 22.43, 20.49 and 20.37; the tests on the window
with C off 31.5 and 31.2, 50.3 and 49.6, 99.0 and 94.7; `-c sqlite3.c`, which
runs none of it, wall -0.00% and +0.03% in two comparisons where the base
again read +0.23% and +0.20%.

## 4. One executable, the update's block on and off (`upd4x`)

Two builds differ in more than the code one of them adds. `upd4x` is `upd4`
with a switch (`BUSTER_TESTS_SKIP=1`) that skips the update's block by a
branch and lists every update's expression, as before the piece: off, it
decides what the build before decides (`cloud/knob-counts.txt`: 43,876, 9,135
and 37,304 expressions; on, 47,266, 9,877 and 40,937). On, off, off, on in
each of seven readings; each reading's own difference, on less off
(`9700x/knob-upd4x.txt`):

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| the loop, a record swept, first run | +0.19 (0.09 to 0.27) | +0.26 (0.13 to 0.35) | +0.14 (-1.22 to 2.22) |
| the loop, a second run | +0.15 (0.13 to 0.25) | +0.17 (0.16 to 0.21) | +0.17 (0.12 to 0.21) |
| C's three sweeps, a record of the decided | -0.36 (-0.46 to -0.16) | -0.52 (-0.70 to -0.35) | -2.70 (-5.58 to 1.81) |
| the kernel in place, a record | +0.04 (-0.06 to 0.14) | +0.03 (-0.05 to 0.10) | +0.01 (-2.94 to 1.04) |

Off, the loop's first run reads 2.85 and 4.53 ticks a record swept on
`sqlite3.c` and Lua, where the build before read 2.66 to 2.73 and 3.98 to
4.06 in the four jobs above. So of the 0.79 the two builds differ by on Lua,
0.26 is the update's block, and about half a tick is there with the block
skipped. What that part is was not established.

## 5. The counts

The cloud container's runs of the pull request's code, the same with the
default warnings and with `-Wall -Wextra` (`cloud/checks/shadow/`):

| | `sqlite3.c` | Lua | musl | the compiler's own source |
| --- | ---: | ---: | ---: | ---: |
| expressions the kernel places | 50,996 | 10,839 | 43,415 | 51,842 |
| decided before the piece | 43,876 | 9,135 | 37,304 | |
| decided | 47,266 | 9,877 | 40,937 | 38,020 |
| updates C asks its plan of | 3,736 | 861 | 3,969 | 6,103 |
| of them a pointer's | 527 | 369 | 846 | |
| taken by the masks | 3,734 | 861 | 3,969 | 6,103 |
| listed: `&&`, `\|\|`, `?:` | 2,744 | 493 | 1,787 | 11,222 |
| a comma or a selection | 263 | 375 | 169 | 0 |
| a division by a constant | 170 | 40 | 261 | 419 |
| a value the columns don't hold whole | 529 | 6 | 77 | 65 |
| an update | 6 | 1 | 27 | 9 |
| a call | 18 | 47 | 157 | 2,107 |

Every run ends with status 0: no expression C on the window decides differs
from C on T's columns.

## 6. Statements one at a time

`probes/probe-u2.py COMPILER LIST [--flat]`: 159 and 92 statements, each
alone in a function. The checker accepts 250 (it rejects `i += (_Atomic
int)l;`). In a unit with a type in the gs space and in one with none: no
accepted statement has a difference from C on T's columns or from T's
records. The two units' outputs differ on two lines, `(*seg)++;` and `*seg +=
1;`: listed where `seg` points into the gs space, taken where it does not.

Against the rule's form (`updates1-u3.txt`): 13 of the 159 go from refused to
listed, each an update the rule refused; the masks take five the rule did not
(two of a bit-field, whose expression its value's record lists, and three of
a vector's element, whose expression that record refuses), and leave none the
rule took.

## 7. Faults

One at a time in four copies of the tree, a Debug build and `test-checker
--part 5/8` each; a fault the tests don't fail then runs the 251 statements.

| Round | Faults | Caught | Survived | Not built |
| --- | ---: | ---: | ---: | ---: |
| 1, the trimmed masks | 72 | 56 | 7 | 9 |
| 2, after round 1's dead terms left | 66 | 58 | 3 | 5 |
| 3, the pull request's code | 61 | 60 | 1 | 0 |

A fault that did not build was a text that left a variable unused; each was
written again for the next round.

- **Round 1's survivors.** A far consumer's key's pointer's bit, either way
  (two): read by the second operand alone, the record right before the
  update's own, which no load reads for; removed. `placed` in what the loop
  asks of: a record the kernel didn't place has no class's byte; removed.
  The address's context there: no update's record is read for its address;
  removed. The pointer's fact's own mask against `left_pointer`: the same of
  an update; removed. The object's flag, and the standing's mask's width:
  round 2's.
- **Round 2's survivors.** "An lvalue" (the destination's standing, with its
  permute and its far lane's row): the checker takes no update of anything
  else; removed. The standing's mask of one bit for two: gone with it. The
  object's flag beside the register's: a name's leaf has its object, and the
  statements in `probes/literals.txt` show a compound literal's expression is
  none the window runs on; removed.
- **Round 3's survivor.** The test of whether the unit's type table has an
  extended qualifier, made always true: the same answers, with a loop over
  each step's updates in every unit. It stays, for that loop.

## 8. The checks before pushing

`cloud/checks/` is the run on main `1962b1f73` with the piece (`checks-call.sh`
with `TREE` and `OUT`; `progress.txt` has a line a step): a native Release
build; `test-checker`'s eight parts, each with status 0; C on the window on
the three corpora and the compiler's own source with both warning sets, 8 of
8 runs with status 0; the shadow's eleven other modes on `sqlite3.c` and Lua,
22 of 22; the self-check, the self-parse and the call graph; the build's
ownership check; and the complete driver's lists. `complete-light` exits 1
for one item of five, "Test the preprocessor on the repository's translation
units against clang", which fails in this container before the piece too:
its clang spells its include directory another way.

The checks ran on the commit before the pull request's (`revision.txt`). The
pull request's differs from it in comments and in one function written as
main has it: the two builds' `.text`, `.rodata` and `.data` are the same byte
for byte.

`cloud/sanitizers/` is the rows a pull request's checks skip, on the pull
request's commit `164f337e2` (`sanitizers-native.sh TREE OUT "--passes 0
--window-contexts"`; `progress.txt` has a line a step): memory, address and
thread, native, each a Release build as CI's rows build it and `test-checker
--part 5/8` (210,344 checks, 0 failures under each), and under memory and
address C on the window on `sqlite3.c`, Lua and the compiler's own source. No
report.
