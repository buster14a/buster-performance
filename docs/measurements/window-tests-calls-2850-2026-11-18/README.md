# The tests on the window, second half: the calls with no test to make, and a statement that discards nothing (buster#2850, step 2): 2026-11-18

The third piece of the second half of "the tests on the window"
([its specification](https://github.com/buster14a/buster/issues/2850#issuecomment-6971718467)), after
[the second](../window-tests-listing-2850-2026-11-18/README.md) (buster14a/buster#2960). Each form is a patch here:
`c1` to `c9` against main `aa09d1a04` (a patch holds the second piece's sources too, and its base is that piece's
build, `a14`); `c12`, `c14` and the padded builds against main `8d4025fbf`, whose own build is `m3`.

- 9700X: CPU 2, Release, each run its own hold of the lock, the two builds in turn in each reading (`job-pair.sh`,
  `job-pair-built.sh`, `turns.sh`, `compile.sh`, `build-label.sh`, `lock.sh` and `corpora.sh` are the earlier records':
  [the second piece's](../window-tests-listing-2850-2026-11-18/scripts) and
  [the first half's](../window-tests-2850-2026-11-17/scripts); the scripts here are this piece's own).
- TSC ticks a record of the expressions the tests ran on. Medians of seven readings on `sqlite3.c` and Lua, of
  fifteen on musl; with every warning of five, and fifteen on musl. `scripts/tables3.py RESULTS HEAD BASE` prints a
  job's table, `scripts/tables-knobs.py RESULTS LABEL KNOB...` a switches' job's.
- The window's sweeps: `bytes` the records' bytes, `loop` the loop (with the asks, from `c6` on), `part` an
  expression's part, `rest` the tests that read T's records (T's own time taken off them).

## 1. What was listed, counted (`patches/calls-census-experiment.patch`, `results/cloud/census`)

Counted in the cloud container on the second piece's sources, before any code (the `calls-census:` lines; default
warnings, and with every warning in parentheses):

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| expressions the tests run on | 50,996 | 10,839 | 43,415 |
| listed for the tests that read T's records | 29,839 (42,203) | 7,770 (9,537) | 21,490 (28,269) |
| listed calls | 12,921 | 4,182 | 8,586 |
| of them, with a test that finds nothing and sends nothing | 12,904 | 3,971 | 8,541 |
| statements listed because their top is no write | 12,769 | 3,233 | 2,746 |
| of them, the top a cast to void | 5,667 | 573 | 31 |
| of them, the top a call | 6,619 | 2,186 | 2,069 |
| of those calls, the callee asks for its result | 0 | 1 | 0 |
| expressions the specified rule would unlist | 13,894 (11,523) | 2,596 (2,237) | 4,471 (2,282) |

## 2. The form specified, and its inputs by a switch (`patches/tests-c1-on-main.patch`, `tests-k1-experiment.patch`; `results/9700x/c1`, `k1`)

`c1` is the specification as written: the callee's facts (its own semantics, whether it asks for its result, what
each parameter takes) a bit of its declaration's line's byte, made at the line's first leaf; and each loud argument
marking its consumer by the front's distances, a scalar step a loud record.

| ticks a record | `sqlite3.c` | | Lua | | musl | |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| | before | `c1` | before | `c1` | before | `c1` |
| the tests on the window | 41.74 | 37.77 | 58.43 | 59.67 | 96.57 | 112.52 |
| bytes | 8.50 | 11.58 | 9.41 | 17.11 | 17.95 | 34.28 |
| loop | 0.83 | 1.78 | 1.16 | 2.46 | 2.36 | 7.85 |
| part | 9.38 | 9.38 | 9.89 | 9.53 | 15.90 | 15.67 |
| rest | 23.06 | 15.03 | 37.95 | 30.34 | 58.84 | 54.57 |
| with every warning | 67.20 | 64.97 | 74.74 | 76.87 | 120.05 | 138.69 |
| beside `--verify` (one reading) | | 87.66 | | 108.23 | | 183.83 |
| the kernel in place, without the tests | 15.72 | 15.63 | 20.47 | 20.23 | 18.74 | 18.81 |
| the front with the window | 52.96 | 53.20 | 70.47 | 70.02 | 87.97 | 90.86 |

It lists 15,739 operators on `sqlite3.c`, 6,161 on Lua and 15,531 on musl, and leaves 35,033, 5,610 and 26,119
expressions with nothing listed. The rule takes 8.0, 7.6 and 4.3 ticks a record off the tests on T's records, and its
inputs put 4.0, 9.0 and 21.8 on the records' bytes and the loop.

`k1` is `c1` with each input behind a bit of `BUSTER_CALLS_KNOB`, one executable, the settings in turn in each of five
readings (`scripts/job-knobs.sh`): 1, no fact of a result asked for; 2, no fact of a callee's own semantics; 4, no scan
of the parameters; 8, no lookup of the line's type's row; 16, no marking; 32, the rule off.

| knob | readings | `sqlite3.c` | bytes | loop | part | rest | Lua | bytes | loop | part | rest | musl | bytes | loop | part | rest |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 0 | 5 | 38.48 | 12.31 | 1.83 | 9.42 | 14.82 | 60.65 | 18.40 | 2.57 | 9.54 | 30.31 | 114.03 | 36.01 | 6.20 | 17.35 | 52.08 |
| 1 | 5 | 37.77 | 11.52 | 1.85 | 9.55 | 14.75 | 57.08 | 14.80 | 2.57 | 9.56 | 30.14 | 101.93 | 28.06 | 5.66 | 16.81 | 51.46 |
| 3 | 5 | 37.50 | 11.39 | 1.84 | 9.50 | 14.69 | 56.83 | 14.71 | 2.58 | 9.57 | 29.96 | 104.73 | 27.66 | 5.56 | 17.40 | 53.10 |
| 7 | 5 | 37.04 | 10.82 | 1.88 | 9.45 | 14.78 | 54.51 | 13.01 | 2.60 | 9.56 | 29.33 | 98.96 | 23.50 | 5.87 | 17.95 | 51.70 |
| 15 | 5 | 36.27 | 10.25 | 1.87 | 9.49 | 14.79 | 53.57 | 11.88 | 2.55 | 9.62 | 29.43 | 97.60 | 21.79 | 5.93 | 18.15 | 52.44 |
| 16 | 5 | 36.59 | 12.26 | 1.03 | 9.36 | 13.93 | 58.70 | 18.32 | 1.44 | 9.59 | 29.25 | 106.80 | 35.90 | 3.89 | 18.25 | 49.55 |
| 32 | 5 | 46.12 | 12.30 | 1.85 | 9.47 | 22.26 | 68.49 | 18.54 | 2.58 | 9.57 | 37.51 | 121.45 | 35.59 | 5.69 | 16.93 | 61.53 |
| 47 | 5 | 44.11 | 10.21 | 1.88 | 9.49 | 22.57 | 61.90 | 11.98 | 2.57 | 9.57 | 37.66 | 108.03 | 21.47 | 5.93 | 16.67 | 61.54 |

A setting that skips an input leaves the rule on, so the rule then leaves out calls the input would have kept, and
the run reports its differences with status 1 (settings 3, 7, 15 and 16 on some corpora): they time the work skipped,
and their verdicts are not the rule's.

By the medians of each reading's differences, in ticks a record on `sqlite3.c`, Lua and musl:

- **The fact of a result asked for, made for every function's line:** 0.8, 3.6 and 7.8 of the records' bytes (knob 0
  against 1).
- **The parameters' scan:** 0.6, 1.8 and 4.0 (3 against 7).
- **The line's type's row:** 0.5, 1.1 and 2.0 (7 against 15).
- **The callee's own semantics:** under 0.2 on each (1 against 3).
- **The marking:** 0.8, 1.1 and 2.3 of the loop (0 against 16).
- **The rule itself:** the tests on T's records from 22.3, 37.5 and 61.5 to 14.8, 30.3 and 52.1 (32 against 0).

## 3. Each input where its record is read (`patches/tests-c3-on-main.patch` to `tests-c9-on-main.patch`; `results/9700x/c3` to `c9`)

From `c3` on: the arguments' part is the kernel's call rule's short path's, which reads each argument's record already
(`node_facts_argument`, the call's record's exponent says `BUSTER_NODE_FACTS_QUIET_CALL`); what each parameter takes
is a bit of the callee's type's row (`BUSTER_NODE_FACTS_TAKES`); the callee's own semantics stays a bit of its line's
byte; and whether a callee asks for its result is asked only of a call a statement may discard. The forms differ by
where that last ask is made. Each lists the same operators and expressions (15,686, 5,970 and 14,556 operators;
35,069, 5,731 and 26,760 expressions with nothing listed).

| the form | `sqlite3.c` | bytes | loop | part | rest | every warning | Lua | every warning | musl | every warning |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `a14`, the second piece (seven jobs) | 41.74 to 42.07 | 8.49 to 8.53 | 0.81 to 0.87 | 9.36 to 9.43 | 23.02 to 23.22 | 67.12 to 67.80 | 58.42 to 58.66 | 74.06 to 75.21 | 96.26 to 99.87 | 119.81 to 122.84 |
| `c1`: as specified | 37.77 | 11.58 | 1.78 | 9.38 | 15.03 | 64.97 | 59.67 | 76.87 | 112.52 | 138.69 |
| `c3`: the ask a call from the loop, at the calls a cast follows | 36.51 | 9.30 | 3.24 | 9.70 | 14.33 | 62.49 | 55.66 | 72.63 | 104.19 | 130.04 |
| `c4`: asked in the listing, of every expression's top, with a branch on the callee's kind | 37.45 | 9.14 | 1.03 | 12.11 | 15.07 | 63.69 | 55.79 | 71.78 | 99.24 | 124.07 |
| `c5`: the same with no branch | 37.16 | 9.17 | 0.95 | 12.04 | 14.92 | 63.21 | 54.26 | 70.88 | 94.44 | 121.89 |
| `c6`: the loop marks the casts over a call left out; a pass over each block's marks | 36.03 | 9.27 | 2.20 | 9.44 | 15.24 | 64.18 | 54.04 | 71.87 | 102.38 | 128.48 |
| `c8`: the marks compressed into a list, one counted pass | 35.24 | 9.24 | 1.72 | 9.37 | 14.96 | 60.72 | 53.38 | 69.68 | 94.13 | 119.96 |
| `c9`: its mask written for a callee that asks alone | 35.40 | 9.24 | 1.64 | 9.56 | 14.83 | 61.45 | 53.41 | 70.10 | 95.82 | 119.50 |

- **A call from inside the loop cost every block** (`c3`): the loop reads 3.24, 5.52 and 10.53 ticks a record, for
  1.03, 1.34 and 3.10 in `c4`, which calls nothing from it.
- **Asked of every expression, it cost every expression** (`c4`, `c5`): four loads at each expression's top's first
  operand, 2.7 ticks a record more in an expression's part, with a branch on the callee's kind or with none. `c5`
  times the facts' making: 1,130 asks at 27.8 ticks each on `sqlite3.c` (0.11 a record), 741 at 30.9 on Lua, 1,361
  at 60.5 on musl.
- **A pass over each block's marks mispredicts its own loops** (`c6`, timed in `c7`, three readings): 46.7 ticks a
  cast on `sqlite3.c` (6,471 casts, 1.04 a record), 57.1 on Lua, 198.7 on musl.
- **The same casts as one list** (`c8`): 26.7 ticks a cast on `sqlite3.c` (0.60 a record), 39.7 on Lua (0.93), 116.5
  on musl (1.13), the facts' making included.
- **musl moves between builds that list the same expressions:** its `rest` reads 55.37, 56.66, 49.64, 59.99, 52.27 and
  52.50 in `c3` to `c9`, and its fifteen readings of a build span 8 to 18 ticks (`tables3.py` prints each job's).
- **The kernel in place, without the tests,** reads 16.00 to 16.10 for 15.63 to 15.79 on `sqlite3.c` from `c3` on
  (the arguments' part of its call rule), 20.56 to 20.71 for 20.21 to 20.60 on Lua, 18.90 to 19.21 for 18.73 to 18.74
  on musl; the front with the window 52.58 to 52.79 for 52.63 to 53.24.

## 4. The campaign's changes, and the pull request's sources (`patches/tests-c12-on-main8d.patch`, `tests-c14-on-main8d.patch`, `tests-pad64-experiment.patch`; `results/9700x/c12`, `c14`, `p64`, `m3`)

Section 8's faults took code out of `c9`. `c12` has the first of it (the kernel's rule's own path says nothing, a
record of type void discards nothing whatever its operator, the records' bytes read a call's one bit, a leaf without a
line is loud as a callee); `c14`, the pull request's sources, the rest (the asks' list is the casts to void whose call
is in their block or the one before; a call whose discard is further back keeps its statement listed, cleared by the
far path; no word of the masks for the calls left out). Both on main `8d4025fbf`, in turn with its own build `m3`.

| ticks a record | `sqlite3.c` | | Lua | | musl | |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| | before | `c14` | before | `c14` | before | `c14` |
| **the tests on the window** | 41.84 | **35.79** | 58.00 | **52.97** | 97.97 | **96.40** |
| bytes | 8.49 | 9.28 | 9.44 | 10.71 | 16.23 | 18.64 |
| loop | 0.92 | 1.66 | 1.12 | 2.28 | 2.26 | 4.37 |
| part | 9.31 | 9.69 | 9.62 | 9.74 | 16.56 | 16.61 |
| rest | 23.13 | 15.10 | 37.82 | 30.22 | 63.09 | 55.85 |
| with every warning | 67.65 | 63.79 | 73.88 | 70.76 | 120.61 | 121.14 |
| beside `--verify` (one reading) | | 85.50 | | 103.37 | | 172.49 |
| the kernel in place, without the tests | 15.55 | 16.38 | 20.15 | 20.85 | 18.67 | 19.15 |
| the front with the window (its one file's pages: section 5) | 52.76 | 71.74 | 71.22 | 91.93 | 90.81 | 102.00 |
| the names' pass, ticks a name | 22.55 | 22.59 | 93.14 | 94.45 | 68.27 | 67.77 |

Readings of the tests: `sqlite3.c` 35.4 to 36.2 for 41.7 to 42.1; Lua 52.5 to 53.3 for 57.6 to 58.7; musl 92.6 to
105.5 for 95.6 to 106.6.

`-c sqlite3.c` as whole processes (`compile.sh`: 21 runs of each of three copies, twice): wall -0.08% and -0.10%, user
cycles -0.05% and -0.03%; main against itself -0.10% and -0.02%, +0.01% and +0.04%.

**The pull request's head** is the same sources on main `5fa4e76c3`, two merges of Tier 1's certificate later
(`patches/tests-h1-on-main5f.patch`, `results/9700x/h1`; that main's own build is `m4`; the head's commit differs from
the patch by eight lines of the documents, which have this reading). The two in turn:

| ticks a record | `sqlite3.c` | | Lua | | musl | |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| | before | `h1` | before | `h1` | before | `h1` |
| **the tests on the window** | 42.21 | **35.64** | 58.06 | **53.01** | 104.53 | **97.70** |
| bytes | 8.48 | 9.23 | 9.46 | 10.68 | 15.87 | 18.27 |
| loop | 0.95 | 1.61 | 1.13 | 2.31 | 2.30 | 5.67 |
| part | 9.36 | 9.74 | 9.61 | 9.71 | 17.79 | 18.17 |
| rest | 23.27 | 15.04 | 37.82 | 30.24 | 67.40 | 55.79 |
| with every warning | 67.38 | 63.00 | 74.16 | 70.60 | 128.32 | 124.94 |
| beside `--verify` (one reading) | | 85.08 | | 104.05 | | 171.91 |
| the kernel in place, without the tests | 15.69 | 16.34 | 20.18 | 20.88 | 18.62 | 19.21 |
| the front with the window | 52.75 | 52.80 | 70.66 | 70.95 | 88.21 | 90.91 |
| the names' pass, ticks a name | 22.66 | 22.27 | 94.06 | 94.08 | 67.99 | 70.03 |

Readings of the tests: `sqlite3.c` 35.2 to 35.9 for 41.9 to 42.5; Lua 52.6 to 53.2 for 57.7 to 61.0; musl 91.8 to
108.1 for 94.7 to 109.6. The front with the window, each reading: 52.80, 52.91 and 52.80 for 52.70, 52.86 and 52.75;
Lua 71.66, 70.95 and 70.77 for 70.66, 71.10 and 70.56; musl 90.91, 92.91 and 88.01 for 88.21, 90.84 and 87.75. `-c sqlite3.c`: wall -0.08% and +0.06%, user cycles -0.15% and +0.16%; main against
itself +0.11% and -0.00%, +0.10% and +0.10%.

The two other builds beside `c14`, each against `m3` in its own job:

| ticks a record | `sqlite3.c` | | Lua | | musl | |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| | before | the build | before | the build | before | the build |
| `c12`, the tests on the window | 41.80 | 34.89 | 58.14 | 52.50 | 100.37 | 95.89 |
| its part and rest | 9.44, 23.00 | 9.34, 14.61 | 9.59, 37.92 | 9.51, 29.81 | 16.88, 62.71 | 16.67, 54.86 |
| with every warning | 67.30 | 61.49 | 73.86 | 69.57 | 122.33 | 120.94 |
| the kernel in place | 15.62 | 16.38 | 20.25 | 20.83 | 18.58 | 19.07 |
| the front with the window | 52.76 | 53.19 | 71.05 | 70.89 | 89.83 | 90.06 |
| `p64`: `c14` with a 64-byte string before the fixtures' texts, the tests on the window | 41.96 | 35.62 | 58.01 | 53.24 | 100.03 | 96.32 |
| its part and rest | 9.28, 23.01 | 9.68, 15.14 | 9.58, 37.98 | 9.80, 30.46 | 18.09, 62.72 | 17.77, 54.51 |
| with every warning | 67.61 | 62.76 | 73.98 | 70.62 | 123.93 | 123.78 |

- **`c14` reads 0.9 more than `c12` on `sqlite3.c`, 2.3 with every warning,** and `p64`, the same sources, 0.7 and 1.3.
  The sources differ in the asks, the far path and the verify's own check; what reads more is an expression's part
  (9.69 for 9.34; 12.48 for 11.86 with every warning) and the tests on T's records (15.10 for 14.61; 40.16 for 38.73).
  `nm -S`: the tests' functions (`node_tests_operator`, `node_tests_constants`, `node_tests_tree`) are the same sizes
  576 bytes further on, and `node_facts_reader_flush`, where the sweeps are inlined, is 0x4367 bytes for 0x4329.
- **In one executable, the rule on and off** (`patches/tests-k2-experiment.patch`, `results/9700x/k2`: `c9`'s form on
  main `cbe317910`, whose commits the patch carries; `BUSTER_CALLS_KNOB` 1, no call is left out; 2, a cast to void is no
  top that discards nothing; seven readings, the settings in turn):

  | knob | readings | `sqlite3.c` | bytes | loop | part | rest | Lua | bytes | loop | part | rest | musl | bytes | loop | part | rest |
  | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
  | 0 | 7 | 35.76 | 9.22 | 1.60 | 9.28 | 15.72 | 54.29 | 10.70 | 2.48 | 9.48 | 31.40 | 102.48 | 18.58 | 4.80 | 16.55 | 59.12 |
  | 1 | 7 | 43.20 | 9.23 | 1.16 | 9.42 | 23.44 | 61.70 | 10.72 | 1.65 | 9.53 | 39.71 | 109.88 | 18.82 | 4.40 | 17.41 | 67.85 |
  | 2 | 7 | 37.25 | 9.24 | 1.62 | 9.38 | 17.00 | 54.79 | 10.67 | 2.46 | 9.49 | 32.07 | 100.64 | 18.80 | 5.50 | 17.34 | 58.62 |
  | 3 | 7 | 44.46 | 9.25 | 1.11 | 9.28 | 24.78 | 62.46 | 10.68 | 1.65 | 9.52 | 40.36 | 111.41 | 18.67 | 4.86 | 17.34 | 69.80 |

Counts in the pull request's sources' runs on the 9700X's corpora (`results/9700x/c14/window-tests-*-1.txt`):

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| calls the loop leaves out | 12,064 | 3,509 | 7,227 |
| casts to void over a call left out, the asks' list | 6,145 | 1,721 | 1,974 |
| declarations asked whether they want their result | 1,144 | 740 | 1,361 |
| operators listed (27,750, 9,486 and 21,783 before) | 15,686 | 5,977 | 14,556 |
| expressions with nothing listed (21,157, 3,069 and 21,925 before) | 35,069 | 5,731 | 26,760 |
| with every warning (8,793, 1,302 and 15,146 before) | 20,333 | 3,594 | 17,622 |
| chunks | 611 | 244 | 2,975 |

Against the specification's gates:

1. **Exact: met** (section 7).
2. **The tests on the window under 40.0 on `sqlite3.c`, refuted at 41.0: met,** 35.79, and 35.62 in the second build.
3. **The rule's inputs under 1.0 tick a record (the records' bytes and the loop together, 9.4 before): missed.** They
   read 10.94: 0.79 more in the bytes, where a line's byte has the callee's fact, and 0.74 in the loop, of which the
   asks were 0.60 where they were timed (`c8`).
4. **What is not this piece's reads the same:** the names' pass and `-c sqlite3.c` do. The kernel in place does not, by
   the form that replaced the specification's: its call rule gathers the arguments' part, 16.38 for 15.55 on
   `sqlite3.c` (16.00 for 15.74 in `c9`'s build). The front with the window read a third more from `c14`'s file and
   main's from fresh copies of it: the file's pages, not the piece (section 5).

## 5. The front's ticks from one file of the executable (buster14a/buster#2967; `results/9700x/c14`, `p64`, `p1088`, `m3p3008`, `m3p2944`)

**Corrected 2026-11-18.** This section first said the piece's build read the front with the window a third slower "by
where read-only data sits". It was not the build: it was the one file of it on the 9700X, as its pages sat in the page
cache. The readings below are as they were; what they meant is in "What settled it".

"The window without the tests" (`--front-window`), millions of ticks of the front's chunks on `sqlite3.c` (315,966
records: 16.7 M is 52.8 ticks a record and 22.7 M is 71.7), every reading without a counter:

| the file | readings | the front with the window | the same front without it | the tree checker, and its setup |
| --- | ---: | ---: | ---: | ---: |
| `m3`, main | 19 | 16.6 to 17.0 | 13.9 to 14.1 | 29.4 to 29.8, 4.9 to 5.1 |
| `c12` | 12 | 16.7 to 16.9 | 14.0 to 14.4 | 29.5 to 29.9, 5.0 to 5.2 |
| `c14`, the pull request's sources | 14 | 22.5 to 22.8 | 13.9 to 14.2 | 29.5 to 30.1, 5.1 to 5.3 |
| `p64`: `c14` with a 64-byte string before the fixtures' texts | 2 | 16.6, 16.7 | 14.1, 14.3 | 29.8, 29.5; 4.8, 5.1 |
| `p1088`: with 1,088 bytes | 2 | 16.7, 18.7 | 14.0, 14.3 | 30.3, 29.7; 5.0, 5.0 |
| `m3p3008`, `m3p2944`: main with a string of 3,008 and of 2,944 bytes there | 2 each | 16.7 to 16.9 | | |

On Lua and musl: `c14` 91.6 to 95.0 and 101.9 to 105.2 ticks a record for main's 71.2 and 90.8; `c12` 70.7 to 70.9 and
88.6 to 91.1.

### What settled it (`scripts/copies.sh`, `scripts/evict.sh`; `results/9700x/copies.log`, `evict.log`)

| `c14`'s executable | the front with the window |
| --- | ---: |
| its file, as it had been since its build (two readings here, fourteen above) | 22.6 M, 22.8 M |
| four fresh copies of the file (`cp`), two readings each | 16.72 M to 16.82 M |
| the file through a hard link: the same inode, the same pages | 22.65 M |
| the file after its pages were dropped from the page cache (`posix_fadvise(DONTNEED)`) and read back | 16.77 M, 16.63 M |
| `p64`'s file and four copies of it, two readings each | 16.65 M to 16.87 M |

The same bytes read main's from any other pages. The slow instance is gone since the last row.

### What the slow file's runs looked like

- **The same ops, retired sooner** (`scripts/perf11.sh`: IBS op samples with data addresses over 60 runs a build,
  `c14`'s file against `p64`'s; `perf11-window-samples.txt`). 8,487 samples in `node_front_chunk_window` for 8,474:
  1,994 loads and 1,694 stores for 1,973 and 1,658, at the same addresses (the heap, six lines of `.bss`, the
  function's `switch` tables), 28 loads and 46 stores that miss the first level for 24 and 50, one TLB miss for two.
  Tag to retire 27.0 cycles an op for 30.3, completion to retire 13.7 for 15.7; the front's ticks under the samples
  23.4 M for 17.5 M. Fewer ops in flight, and no load that waits longer: the ops arrive more slowly.
- **The fetch side, in the function** (`scripts/perf13.sh`: IBS fetch samples over 20 runs, the slow file against a
  fresh copy of it): 102 fetches of 3,282 miss the op cache for 59 of 3,647; 798 are not completed for 780; 13 miss
  the instruction cache for 23.
- **Counters of the whole process** (`scripts/perf12.sh`, `perf12.log`: three runs of each of two sets, the slow file
  against a fresh copy): instruction-cache misses 89.3 M to 90.4 M for 89.6 M to 90.2 M, their fills from L2 34.8 M to
  35.4 M for 34.0 M to 34.8 M and from further 0.43 M to 0.53 M for 0.54 M to 0.59 M, op-cache misses 138.4 M to
  138.8 M for 139.2 M to 140.8 M, the decoder's ops 452 M to 459 M for 443 M to 451 M, L1 ITLB misses 0.86 M to 0.94 M
  for 0.91 M to 1.05 M, L2 ITLB misses about 2,000 in each but one run. Nothing there tells the two files apart.
- **The ITLB's page size is not it** (`scripts/perf14.sh`, `perf14.log`: one run of fetch samples in the whole text of
  eight files): `c14`'s slow file and a fresh copy of it both fetch from 4 KB pages, as `m3`, `c12`, `h1`, `p1088` and
  `c9` do. (`perf13`'s fresh copy fetched its samples in the function from pages of the size perf prints as
  `RESERVED`; `perf14`'s copy did not, and read as fast.)
- **Not the stack's place** (`pads.sh` with `--front-window`, `results/9700x/*/padw-sqlite3-pad*.txt`): with an
  environment variable of nine sizes from 0 to 3,072 bytes `c14`'s file read 22.6 to 22.8, `c12`'s 16.7 to 16.8, `m3`'s
  16.6 to 17.0. **Nor the code's:** every `node_front_*` function has main's size at main's address in `c12`, `c14`
  and `p64`.

### What was wrong here before

- **"What moved is the read-only data after the test file's fixture texts."** Between `c12` and `c14` the function's
  `switch` tables did move by 3,008 bytes (`0x5b2ccc` to `0x5b388c`), but `p64`'s and `p1088`'s are where `c14`'s are
  (`0x5b388c`, read from the code of each): their strings moved what follows them among the strings alone. `p64` was
  fast because it was another file.
- **"A false dependency of a load on a store fits."** No load waits longer in the slow file's samples.
- **The earlier counters** (`perf6.sh`, `perf10.sh`, `perf7.sh` to `perf9.sh`; `c14`, `p64` and `c12`'s files) compared
  files of different builds, and two of `c14`'s three `perf10` runs read the whole process 8% and 10% higher (every
  timed section of the one whose report was kept, the tree checker's setup twice). They are in `results/9700x` as
  they were; they don't bear on the cause.

### What changed in the jobs

`scripts/turns.sh` (the earlier records' one ran each build from its one file): each reading now runs each build from
a fresh copy of its compiler, read once before the reading's runs and removed after them. A file like `c14`'s is then
one outlier of a build's readings, and its copy can be kept for samples. `compile.sh` already ran three copies a build.
The tables above and in sections 2 to 4 are from the one-file jobs: their tests' sweeps agree between `c14`'s slow file
and `p64` (35.79 and 35.62 on `sqlite3.c`), so the slow pages took their third from the front's function and not from
the tests.

## 6. What is left, counted (`patches/left-census-experiment.patch`, `results/cloud/left`)

Counted in the cloud container on the form before the campaign's changes (seven calls of Lua's fewer listed than in
the pull request's sources), default warnings:

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| expressions listed for the tests that read T's records | 15,926 | 5,108 | 16,655 |
| for a listed operator alone | 10,453 | 2,150 | 8,640 |
| for an initialization's root alone | 3,310 | 1,155 | 5,780 |
| for writes out of sequence alone | 600 | 137 | 420 |
| for a returned address alone | 76 | 129 | 316 |
| for a statement's top alone | 0 | 0 | 0 |
| operators listed | 15,688 | 5,970 | 14,556 |
| of them, with a test that finds nothing and sends nothing | 14,770 | 4,858 | 12,734 |
| casts | 7,370 | 1,995 | 3,849 |
| of them, with nothing | 7,370 | 1,919 | 3,824 |
| subscripts, by a constant | 3,181 | 87 | 1,586 |
| assignments of a constant | 1,250 | 223 | 1,112 |
| calls | 854 | 666 | 1,359 |
| conditionals and commas, listed whatever their operands | 988 | 925 | 816 |
| comparisons with a constant | 1,041 | 466 | 2,153 |
| shifts by a constant | 282 | 1,094 | 823 |

## 7. The cloud container's checks (`results/cloud/final`)

The pull request's sources on main `8d4025fbf` (the work branch's `48109b97e` with the documents' edits; 4 CPUs,
native host, Release; `checks.sh`, `progress.txt`):

- `test-checker`, all eight parts: 842,783 checks, 0 failures (`test-checker-status.txt`).
- The shadow on `sqlite3.c`, Lua, musl and the compiler's own source in 12 modes: 48 runs, each status 0
  (`shadow/status.txt`). `shadow/` has the `--window-tests` runs' outputs: no expression differs. Beside `--verify`:

  | | `sqlite3.c` | Lua | musl | the compiler's own source |
  | --- | ---: | ---: | ---: | ---: |
  | calls left out, checked | 12,067 | 3,509 | 7,227 | 0 |
  | of them with a test, or with a constant argument the rule doesn't take | 0 | 0 | 0 | 0 |
  | casts in the asks' list | 6,145 | 1,721 | 1,974 | 0 |
  | declarations asked whether they want their result | 1,144 | 740 | 1,361 | 0 |
  | expressions with nothing listed, checked | 35,070 | 5,731 | 26,760 | 18,255 |
  | with every warning | 20,333 | 3,594 | 17,622 | 7,931 |
  | of them with another verdict | 0 | 0 | 0 | 0 |
  | records the tree's tests read that no listed operator has as an operand, checked (the second piece's) | 27,788 | 4,844 | 17,837 | 28,215 |
  | operators left out for their constants, checked (the first piece's) | 20,897 | 7,027 | 14,477 | 22,699 |
  | with every warning | 10,152 | 5,718 | 10,597 | 11,020 |
  | of either with a test | 0 | 0 | 0 | 0 |

- The self-check, the self-parse, `test-call-graph` and `check-call-graph`: status 0.
- The complete driver (`-DBUSTER_COMPLETE_DRIVER=1`; `complete-light.log`, `complete-heavy.log`, the workflow's
  parse): one heading fails, as on main in this container: "Test the preprocessor on the repository's translation
  units against clang", 45 of 66 files, each by the container's clang's resource directory's path
  (`/usr/lib/llvm-23/lib/clang/23`) and nothing else.
- The sanitizer rows a pull request's checks don't run (`sanitizers.sh`, `sanitizers-progress.txt`; native memory,
  address and thread): a build each, `test-checker --part 5/8` (210,336 checks, 0 failures), and for memory and
  address the shadow with `--window-tests --verify` and with `--window-tests --verify -Wall -Wextra` on `sqlite3.c`,
  Lua and the compiler's own source. Every run status 0, no report.

The pull request's head, the same sources on main `5fa4e76c3` (`results/cloud/head`: `head-check.sh`, `progress.txt`;
the work branch's `ee5994cf9`): a build, `test-checker --part 5/8` (210,336 checks, 0 failures), the self-check, and
twenty `--window-tests` runs (the four corpora in five modes), each status 0 with no difference.

**The compiler's own source has no call at reader time** (buster14a/buster#2968): one of its functions has clang's
`no_builtin` attribute (`dataflow_liveness_vector_one`, since `e2da9f0fd`, 2026-10-21), and the node machine's fronts
leave every call of such a unit unmade. So the runs above check the calls' rule on the three other corpora and the
fixtures, and on the compiler's own source the piece is exact on expressions without a call, as the two pieces before
were. `results/cloud/no-builtin` has the evidence:

- A probe of nine expressions with five calls (`probe.c`): five calls left out. With one `no_builtin("memset")`
  function after them (`probe-no-builtin.c`): none listed and none left out.
- `bind_benchmark.c`, a unit of the compiler's without that function: 1,037 calls listed, 1,822 left out.
- **With the refusal lifted in a copy of the tree** (`lifted-experiment.patch`: the two fronts' term, nothing else; a
  Debug build of the pull request's sources), `--window-tests --verify`, each run status 0:

  | | `main_unit_assembler.c` | the compiler's own source, `main.c` |
  | --- | ---: | ---: |
  | expressions the tests ran on (with the refusal: 32,846 and 38,155) | 42,862 | 52,015 |
  | that differ | 0 | 0 |
  | calls listed | 3,217 | 4,393 |
  | calls left out, checked | 8,987 | 12,484 |
  | of them with a test, or with a constant argument the rule doesn't take | 0 | 0 |
  | casts in the asks' list | 2,596 | 4,140 |
  | declarations asked whether they want their result | 590 | 723 |
  | expressions with nothing listed, checked | 19,819 | 24,063 |
  | with every warning (`main-lifted-every-warning.txt`: the same 12,484 calls left out and checked) | | 11,812 |
  | of them with another verdict | 0 | 0 |
  | operators left out for their constants, checked (the first piece's), with a test | 23,603, 0 | 28,179, 0 |
  | records the tree's tests read that no listed operator has, checked (the second piece's), with a test | 30,798, 0 | 36,381, 0 |
  | the tree checker's objects and library calls at reader time that differ | 0 | 0 |
  | the lowering's and the tape's comparisons that differ | 0 | 0 |

  The lift itself is buster14a/buster#2968's, not this pull request's.

## 8. Faults (`faults/`)

Faults put into the new code one at a time, each in a copy of the tree: the Debug compiler built, and the node
machine's tests run (`test-checker --seed 133 --part 5/8`). A fault the tests don't fail is a survivor.

| round | sources | faults | fail the tests | don't build | survive |
| --- | --- | ---: | ---: | ---: | ---: |
| `round1.py` | the work branch's `8a940f328` (`c10`: `c9` with a count) | 155 | 98 | 25 | 32 |
| `round2.py` | `48109b97e` (`c14`): the pull request | 139 | 137 | 0 | 2 |

Round 1's 25 texts that didn't build left a variable unused under `-Werror`; they were written again for round 2.
What its 32 survivors showed, each from the code that makes the value it reads:

- **Code that did nothing, taken out.**
  - The kernel's rule's own path's verdict (`k-store-rule-always`, `k-store-rule-none`, `k-gather-rule`): it makes
    seven of Lua's calls and no fixture's; they stay listed.
  - A parameter's type's word's valid bit (`k-takes-valid`): a prototype's parameters' types are valid.
  - A cast's operator beside a top's void type (`l-void-every`, `l-asks-no-casts` in part): the census's code asks
    the type of any discarded value (`node_census_discarded`).
  - A record's standing and the rest of its exponent where the records' bytes read a call's bit, and the mask of
    placed records on it (`b-quiet-exponent`, `b-quiet-standing`, `b-quiet-unplaced`): a call's record says 0 or 1.
  - A leaf without a line's declaration's fact (`b-loud-stray-never`): such a leaf is loud as a callee without asking.
  - A word of a block's masks for the calls left out, and the asks' reads of it (`l-mask-calls-every`, `a-left-mask`,
    `a-left-always`, `a-ask-any`, `a-keep-any`, `a-result-literal-known`, `w-named-any`).
  - The asks of a cast further back than the block before, and the mask of live records on them (`l-asks-no-far`,
    `l-live-off-by-one`): its call stays listed, by the far path.
  - An aggregate, a missing record and a wide value in the verify's own list of arguments (`v-own-aggregate`,
    `v-argument-aggregate`, `v-argument-none`, `v-small-wide`): the call's test finds the first, and a call left out
    has neither of the others.
- **New fixture lines** (the seventh fixture's function `calls`): the first of two parameters that takes no constant
  (`k-takes-last-alone`); a constant a cast or a conditional makes, whose record says no value (`k-arg-large-zero`);
  six arguments, the fifth and the sixth loud (`k-gather-more`); a static object's address; a pointer whose
  declaration has a format (`b-line-calls-row`); a null callee; a cast to another type and a comma over a call left
  out (`l-no-sends`); a `for`'s last clause whose discard is in the block before, and further back, with a callee that
  asks, one that doesn't and a write (`l-previous-stale`); and seventy statements of each kind, a cast to void at each
  place of a block (`l-high-count`).
- **A pinned count:** the casts in the asks' list (`e-casts-count`).
- **Not a fault of the code under test:** `v-wrong` (and `v-loud`, which didn't build) are the verify's own two counts
  of a call left out; a fault there shows only beside one in the rule, and they are not in round 2.

`faults/probe/` has the programs that showed which of these a C program can reach (a constant a cast or a conditional
makes says no value, so the guard of zero is reachable; no probed callee form reaches the kernel's rule's own path).

**Round 2, on the pull request's sources:** 137 of 139 fail the tests, each with status 1 and a named check. The other
two change no result a test can read:

- `f-far-count`, the far path's test of a record's place in its chunk: a record past the chunk's count is read there
  as the others that far are, and without the test a stale one could keep a call listed: another listing, the same
  verdicts.
- `b-loud-no-line`, a leaf without a line, loud as a callee: no call has one for a callee. A name's leaf has no line
  where its value is past the columns, an enumerator's, or where the lines are full, and their room is half the
  unit's tokens and 64.
