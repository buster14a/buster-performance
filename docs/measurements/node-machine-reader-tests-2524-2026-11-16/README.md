# The tests where they sit: the census's set and silence tests at reader time (buster#2524), 2026-11-16

**Hand-off, 2026-11-16.** This record's commit was never pushed: the session handed buster#2524 off with it unmerged.
It is patch `0002` of [the hand-off series](../node-machine-own-tests-2524-2026-11-16/patches/handoff), re-picked on
main `3d0d56ed7`; `patches/pull-request.patch` here is its form on buster#2867's head, on "C and X where they sit".

[buster#2524](https://github.com/buster14a/buster/issues/2524)'s step 2 puts the node machine in the reader. "T where it
sits" and "C and X where they sit" ran its three sweeps there, in the shadow. What decided which expressions the machine
may take stayed after the pipeline: the census's set and its silence tests, which read the stream. This record runs
them at reader time: `measure-node-machine --shadow --front-tests` runs the census's own test code after T takes an
expression and before C and X, on T's records, and compares the verdict with the census's after the pipeline, test by
test. The design's section is "The tests where they sit" in `docs/node-machine.md`;
[the claim](https://github.com/buster14a/buster/issues/2524#issuecomment-6907583853) is on the issue.

Host: the Ryzen 7 9700X (`benchpress`), under its lock, a hold a run; Release builds; `taskset -c 2`; TSC ticks at
3,792.9 MHz. Build `z3` is the pull request's sources but for two lines of a test's fixture added after it (section
"Checks"; `patches/z3.patch` is its `src` and `tools` against main `be6515fba`). Its parent, "C and X where they sit" at
the same main, is build `w2` of [that record](../node-machine-reader-sweeps-2524-2026-11-16).

## Findings

1. **The verdict can be made at reader time, and it is exact there.** With the census's own tests on T's records, no
   expression reader time takes is one the census refuses after the pipeline: on `sqlite3.c`, Lua and musl, with the
   default warnings and with `-Wall -Wextra`, on the roots the lowering pops (51,122, 10,846 and 22,518) and on those it
   never pops (63, 13 and 20,963). No test's bit differs, in the 105 readings of the four builds below.
2. **The sweeps' own refusals are not enough.** T, C and X refuse what they have no row or template for, which is most
   of the set, and know no warning. With the default warnings they would take 4 expressions of `sqlite3.c` that the
   census refuses, 208 of Lua's and 298 of musl's; with `-Wall -Wextra` 3,256, 728 and 2,243.
3. **As the census writes them, the tests cost more than the three sweeps.** In place they are 165.5 TSC ticks a
   typed record on `sqlite3.c`, 179.9 on Lua and 274.0 on musl, beside 134.3, 158.5 and 254.1 for T, C and X: about 115
   cycles a body token on `sqlite3.c`, where ten move step 2's sum by a hundredth. The sum (1.25) had no term for
   them; with them as they are it is about 1.13, under the step's gate of 1.2.
4. **There is no one thing to fix in them.** As the census first had them they were 206.1, 221.7 and 292.8. A byte a
   type and a byte a declaration, and three tests asked only where a node's operator can fail them, took a fifth off.
   The rest is spread over the walk, the sequence of conditions a node passes whatever its operator, and the view's step
   from a node to its record. The machine needs the same tests in its own form, with this code as their oracle.
5. **A declaration's discard was a root, and two records read it wrongly.** At a declaration's `;` the walk casts each
   initializer's value to void; the front made that cast a root, and nothing evaluates it. They were 5,355 of the
   56,681 roots T ran on at reader time on `sqlite3.c`, 2,275 of Lua's 13,184 and 13,991 of musl's 57,888. The records
   of T and of C and X where they sit read the ones T took as expressions "in bodies that are never lowered": on
   `sqlite3.c` and Lua nearly all were discards (section 2). Reader time leaves them alone now.
6. **T's rows and rules know no warning, and none is missed.** With `--verify` at reader time, every node a row or a
   rule typed has the action's value and conversions, and its action gives no warning, on every expression T types
   there, with every warning on.
7. **A compile is unchanged** (-0.11% and +0.22%, the same 1,363.464 M instructions). The shadow's own sweeps retire
   the same instructions a node and read 1% more cycles as built.
8. **buster#2850's kernels are not moved, and their harness's figure is, on musl:** 13% to 30% lower in this build.
   The figure is a pass less a second pass that only puts the given records in place, and it is the second that
   reads a tenth slower here, by a constant a unit inside its own ticks; the kernel's pass reads the same a record
   (section 5; [buster#2872](https://github.com/buster14a/buster/issues/2872)).

`scripts/tables.py` prints every table below from the result files (`results/tables.txt` is its output).

## 1. The verdict at reader time against the census's

The tests are one code with two views of a node (`node_view_value` and its kin in `c_check_node_census.c`): the stream's
after the pipeline, T's record at reader time. What else they read, and what stands for it before the pipeline:

| what the tests read | after the pipeline | at reader time |
| --- | --- | --- |
| a node's value, its operands' and arguments' conversions, a member's offset | the stream's | T's record of the node |
| an action's warnings at a node | the stream's, less an unevaluated operand's | T's own actions', for the whole expression |
| the root's kind | the control that pushed it | the front's root's operator; a root inside a statement expression is a nested control's |
| an initializer's object's type | its control's declaration's | the declaration's |
| the unit's enabled warnings | the options and the diagnostic pragmas | the same, whole before the coded walk |
| a body's diagnostic and floating-point pragmas | by the body's braces | by the outermost braces around each pragma |
| the warning events at the expression's tokens | the reader's, the graph run's and the later passes' | the reader's own so far |
| a packed member's address | the reader's witnesses, a later pass's | any address taken in a unit with a packed record or member |
| a body that tracks its stack, a node popped twice | the lowering's | nothing: a splice reads them where it pops the root |

On the 9700X (`z3`, the first run of each; every run of the seven, or of musl's three, has the same counts):

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| roots T ran on at reader time | 51,326 | 10,909 | 43,897 |
| of them, popped by the lowering | 51,255 | 10,896 | 22,914 |
| never popped, and taken; of those, in a lowered body | 63; 41 | 13; 4 | 20,963; 218 |
| declarations' discards left alone | 5,355 | 2,275 | 13,991 |
| expressions the tests ran on (those T took) | 51,185 | 10,859 | 43,481 |
| refused there by a test | 567 | 302 | 435 |
| by test | bit-field 495, aggregate 66, declaration's flag 6 | callee 208, aggregate 94 | parentheses 279, aggregate 77, a type 56, bit-field 13, constant 6, callee 2, string plus integer 1, unused value 1 |
| compared with the census: popped, never popped | 51,122, 63 | 10,846, 13 | 22,518, 20,963 |
| taken there and refused by the census; tests that differ; root kinds that differ | 0; 0; 0 | 0; 0; 0 | 0; 0; 0 |
| refused by the census; of them, ones C and X take (their nodes) | 567; 4 (42) | 302; 208 (1,366) | 435; 298 (3,746) |
| with `-Wall -Wextra`: refused there by a test | 3,821 | 824 | 2,408 |
| with `-Wall -Wextra`: of them, ones C and X take (their nodes) | 3,256 (12,362) | 728 (3,412) | 2,243 (13,806) |
| with `-Wall -Wextra`: taken there and refused by the census; tests that differ | 0; 0 | 0; 0 | 0; 0 |
| `--verify` there: values not the action's; nodes whose action warns | 0; 0 | 0; 0 | 0; 0 |
| with the lean front: the tests ran on; refused; taken and refused by the census; differ | 50,993; 560; 0; 0 | 10,839; 302; 0; 0 | 43,415; 435; 0; 0 |

With `-Wall -Wextra` the refusals are a for statement's clauses under `-Wfor-loop-analysis` (3,244, 523 and 1,857),
then sign comparisons (11, 0 and 131), musl's parentheses (286) and self-assignments (2, 0 and 7), beside the set's.
No expression reader time takes on the corpora is refused by the census for one of the lowering's own facts.

- **The comparison** (`node_shadow_tested`): every root the tests ran on at reader time is compared after the pipeline.
  One the lowering popped has the census's own verdict. One it never popped is read by the census again from the stream,
  with the root's kind and the object's type reader time gave. An expression reader time takes (no test refuses it, and
  C and X take it) that a test of the census's refuses fails the command. So does a test's bit that differs otherwise
  than in three ways: reader time's actions' warnings may be more (the graph run drops an unevaluated operand's), an
  address in a unit with a packed record or member stands for a witness, and the census's events include the later
  passes'. The lowering's own facts are counted apart.
- **`--verify` at reader time** checks each node a row or a rule typed against the action, on every expression T types
  there: its value and conversions must be the action's, and the count of such nodes whose action gives a warning is
  reported. Both are 0 on the three corpora with every warning on.

## 2. A declaration's discard, and a correction of the two records before this one

The comparison of every root the tests ran on, popped or not, showed thousands of roots refused as "a value without an
effect" that the lowering never pops. They are no statements:

- **What they are.** At a declaration's `;` the reader's walk casts each of its initializers' values to void, an
  initialization's node or a braced initializer's value, as it does an expression statement's value. The front made a
  root of each cast (`CHECK_INPUT_FORM_DISCARD`). The program takes an initializer's nodes for data and makes no control
  of the cast, and the initialization's value is a root of its own: T typed each scalar initialization twice.
- **Counted** (a build of this work before the fix, the cloud's copies of the corpora; the roots T took that the
  lowering never popped, as the two earlier records published them):

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| taken at reader time and never popped | 3,941 | 1,722 | 26,597 |
| a declaration's discard of a scalar initialization | 3,828 | 1,708 | 5,557 |
| another root, in a body the lowering lowers | 91 | 5 | 295 |
| another root, in a body it doesn't | 22 | 9 | 20,745 |

- **The fix** (`node_machine_reader_discard`): a cast at a terminator whose operand's token is an initializer's `=` or
  below one in the parser's tree (`CheckInputReader.initializers`) is no root of the machine's. That covers a braced
  and a static initializer's values too, which T refused for their context before: 5,355, 2,275 and 13,991 roots in
  all, and T runs on 51,326, 10,909 and 43,897 expressions where it ran on 56,681, 13,184 and 57,888.
- **What was wrong in the records.** `node-machine-reader-types-2524-2026-11-15` (finding 4, the "in none" rows) and
  `node-machine-reader-sweeps-2524-2026-11-16` read all of those as expressions "in bodies that are never lowered",
  headers' inline functions. That holds for musl (20,745 of its 26,597) and not for `sqlite3.c` (22 of 3,941) or Lua
  (9 of 1,722). Both are corrected in place (`ba023c976`), with buster#2867's description and the design's sections;
  [the correction](https://github.com/buster14a/buster/issues/2524#issuecomment-6908043343) is on the issue.
- **What it does to their timings.** They are per record T typed and included the second typings, which were cheaper
  than a first: without the discards T, C and X read 134.3 ticks a typed record on `sqlite3.c` (127.7 with them), 158.5
  on Lua (139.9) and 254.1 on musl (235.9).

## 3. What the fixtures found

`test-checker`'s census fixture has one warning a line. The same six fixtures run with the tests at reader time
(`node_tests_test_fixture`), and three lines were taken there at first:

- **`e = 5;` under `-Wassign-enum`.** The test read a file-scope flag that the census sets after the pipeline
  (`node_census_assign_enum`), which at reader time still had the unit before's value. It reads the unit's policy now.
- **A statement expression's inner roots.** The lowering pushes them under a nested control, which the census refuses
  (`other-control`). The front gives them as a statement's or an initialization's. Reader time takes any root inside a
  statement expression (`CheckInput.regions`) for a nested control's.
- **`q = &pp->i;` of a packed record.** The census reads the reader's witnesses (`CheckInput.packed_members`), which a
  pass after the walk makes. At reader time any address taken in a unit with a packed record or member stands for
  one: more than the witnesses, never less.

Two lines were added for what no line read: a conditional whose third operand's conversion changes a constant
(`i ? 1.5f : 16777217`: T's columns held two operands' conversions), and a body with a diagnostic pragma (the
floating-point pragma's body is T's own refusal, by its nodes' contexts, before any test).

A body with a statement expression tracks its stack in the lowering, and the census refuses its every expression
(`tracked-body`). Reader time has nothing for that: three expressions of the fixture's body are taken there and
counted apart ("for the lowering's facts alone"). A splice reads that fact where it pops the root. On the corpora
there is none.

## 4. What the tests cost in place

TSC ticks a record T typed at reader time, medians of seven readings in turn (musl's of three), each reading both
runs of a build one after the other: T, C and X (`--front-sweeps`), and the same with the tests between T and C
(`--front-tests`). The tests' cost is the difference. C and X run on the expressions no test refuses in the timed run
(567 of 51,185 fewer on `sqlite3.c`).

| build | | `sqlite3.c` | Lua | musl |
| --- | --- | ---: | ---: | ---: |
| `z0`: the tests as the census had them (`patches/plain.patch` on `z1`) | T, C and X | 135.1 | 162.7 | 249.9 |
| | with the tests | 341.1 | 384.4 | 542.7 |
| | the tests | 206.1 | 221.7 | 292.8 |
| `z1`: a byte a type and a declaration; three tests by the operator | T, C and X | 135.2 | 158.3 | 249.5 |
| | with the tests | 301.0 | 339.3 | 521.6 |
| | the tests | 165.7 | 181.0 | 272.1 |
| `z2`: the walk's columns by record too | T, C and X | 134.6 | 159.4 | 259.5 |
| | with the tests | 315.8 | 352.5 | 554.9 |
| | the tests | 181.2 | 193.1 | 295.3 |
| `z3`: the pull request's sources but for two fixture lines (`z1`'s code: the fixtures alone differ) | T, C and X | 134.3 | 158.5 | 254.1 |
| | with the tests | 299.8 | 338.4 | 528.0 |
| | the tests | 165.5 | 179.9 | 274.0 |
| `z3`, the lean front | T, C and X; with the tests | 162.6; 329.8 | 183.1; 365.7 | not run; 545.4 |
| `z3`: the unit's state, ms: without the tests; with them | | 1.047; 1.234 | 3.529; 5.617 | 36.02; 44.98 |

- **`z0` to `z1`** (the pull request's changes to the census's code):
  - *A byte a type* (`node_census_type_bits`): whether a value's type is one the machine has no kind for, a record, an
    enumeration, a floating type or a pointer, made once a type by the census's own predicates, where the tests asked
    the type table at every node.
  - *A byte a declaration* (`node_census_declaration_facts`): an attribute the tables don't model, a callee's semantics
    by its name or attributes, a result its callee asks for: once a declaration, where each leaf and each call scanned
    the attributes and compared the name.
  - *Three tests by the operator:* the constants' tests only where an operand or an argument is a constant (each of
    them reads one); the tree's parent only for an assignment, a `!` and a comparison's token; a truth context only for
    a left shift and a product.
  - *A node's type and flags* read alone, its whole value only at a leaf.
  - The census's own reports are the same before and after, line for line, on the three corpora with the default
    warnings and with `-Wall -Wextra` and on the fixtures (`scripts/census-run.sh`).
- **`z2` is slower.** The walk keeps three columns a node (a mark, its parent, its depth), an entry a node of the
  unit. `z2` kept them by record at reader time, an expression's alone, behind one more step from a node to its record
  at each read: 181.2 against 165.7. Not kept.
- **Where the time is** (`scripts/tests-profile.sh`: `perf record` of `cycles:u`, three processes each of `z1`'s two
  runs; shares, since the period asked for more samples than the kernel keeps, section "Traps"): of the cycles the tests
  add to the whole run, 76% are in the census's file, 15% in the machine's own files (the sweeps run colder with that
  code between an expression's T and its C) and 5% in the type table's functions. Within the census's file no part
  holds a fifth of the added cycles: a node's tests 13%, the walk and an expression's own tests 11%, the view's step
  from a node to its record 7%, the constants' tests 7%, and 17% at lines the profile doesn't place
  (`results/9700x/z1/tp-*`; `z2/tp-*` has the same picture).
- **In the sum's units.** T, C and X in place were 127.7 ticks a typed record for about 212 cycles a node, and 216.5
  cycles a node are 91 cycles a body token: 165.5 ticks a record are about 275 cycles a node and 115 a body token. Ten
  move step 2's sum by a hundredth, so the tests as they are take 1.25 to about 1.13. Without the discards the sweeps
  themselves are 134.3 ticks a record, 223 cycles a node where the sum took 216.5: a third of a hundredth.
- **The unit's state** is the enabled warnings (some 300 questions of the options and the pragmas), a bit a token for
  the reader's events and for the statement expressions, a byte a token and a byte a type cleared, and the walk's
  columns: 0.19 ms on `sqlite3.c`, 61 µs a unit on Lua's 34, 6.7 µs a unit on musl's 1,336.

## 5. A compile, the shadow's own sweeps, and buster#2850's kernels

`w2` is the parent (C and X where they sit, at main `be6515fba`) and `z3` this change. A compile runs none of it: the
reader's hooks stay behind their one test, and the coded walk's function is 32 bytes longer
(`results/9700x/symbols-w2-z3.txt`). The shadow's own T has two additions (below).

- **`-c sqlite3.c`** as whole processes, 21 runs a build from three fresh copies of each executable
  (`results/9700x/ab-copies-w2-z3-1`, `-2`):

| | wall ms, `w2` | `z3` | difference (over copies) | instructions, M |
| --- | ---: | ---: | --- | --- |
| first | 122.571 | 122.440 | -0.11% (-0.36% to +0.02%) | 1,363.464, 1,363.464 |
| second | 122.509 | 122.782 | +0.22% (-0.01% to +0.39%) | 1,363.464, 1,363.464 |

- **The shadow's own sweeps** after the pipeline, no front (medians a taken node; seven passes on `sqlite3.c` and Lua,
  one on musl; seven runs each, musl three):

| | `sqlite3.c`, `w2` | `z3` | Lua, `w2` | `z3` | musl, `w2` | `z3` |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| T, cycles | 90.0 | 88.8 | 80.4 | 80.7 | 122.3 | 120.3 |
| T and C | 134.7 | 134.8 | 117.8 | 118.5 | 158.8 | 154.4 |
| T, C and X | 174.4 | 176.3 | 146.9 | 148.2 | 193.3 | 195.5 |
| T, C and X, instructions | 597.76 | 597.61 | 687.10 | 687.12 | 648.63 | 648.58 |
| T, instructions | 337.51 | 337.76 | 428.82 | 429.20 | 383.20 | 383.55 |

  T retires 0.25 to 0.38 more instructions a node, which is what its two additions are (a store an expression that
  clears its warnings, and a conditional's third conversion kept), and the three together the same within 0.15 (C and
  X compile to a few instructions fewer beside the unit's new code). The three read 1% more cycles as built on the
  three corpora. That is inside what the stack's place alone moves these sweeps
  ([buster#2869](https://github.com/buster14a/buster/issues/2869): 5% to 8% over 32 places); it was not swept by place
  here.

- **buster#2850's fact words** (`--facts` and its settings; rounds 19 to 24 of the two builds in turn, six runs a
  setting; `results/9700x/facts-w2-z3.txt` is the harness's table and `results/kernel-baseline.txt` what it is made of,
  by `scripts/kernel-baseline.py`). The harness's figure, cycles a taken leaf or lookup:

| | `sqlite3.c`, `w2` | `z3` | Lua, `w2` | `z3` | musl, `w2` | `z3` |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| a body a window | 23.09 | 22.80 | 17.73 | 17.57 | 15.71 | 13.64 |
| lean | 20.85 | 20.74 | 15.88 | 15.72 | 13.97 | 11.23 |
| lean, packed | 16.45 | 16.63 | 13.37 | 13.17 | 12.84 | 10.48 |
| loads | 15.25 | 15.25 | 10.69 | 10.84 | 8.82 | 6.21 |
| loads, packed | 11.08 | 11.02 | 8.30 | 8.16 | 7.79 | 5.47 |
| packed | 18.70 | 18.66 | 14.88 | 14.75 | 14.54 | 12.59 |
| packed, 4,096 records a window | 18.38 | 18.75 | 15.71 | 15.67 | 14.72 | 12.80 |
| instructions, a body a window | 75.11 | 75.13 | 77.12 | 77.14 | 72.86 | 72.90 |

  On `sqlite3.c` and Lua the two builds read the same within their rounds. On musl the figure is 13% to 30% lower in
  `z3`, with the same instructions, and **that is no faster kernel**:

  - *The figure is a difference of two passes.* The harness times a pass over a unit's windows (each window's given
    records put in place, then the kernel) and a second pass that only puts the given records in place, and reports
    the first less the second, a taken leaf or lookup. It prints the second pass too, a record of the window.
  - *The second pass moved, the first didn't.* Cycles a record of the window, medians and ranges of the six rounds:

| musl | `w2` | `z3` |
| --- | ---: | ---: |
| the given records put in place alone | 11.41 (11.40 to 11.42) | 12.57 (12.43 to 12.63) |
| its instructions | 47.06 | 47.04 |
| both passes' sum a record, a body a window | 19.89 (19.86 to 19.89) | 19.93 (19.93 to 19.94) |
| lean | 17.81 | 17.80 |
| lean, packed | 17.32 | 17.35 |
| loads | 15.46 | 15.47 |
| loads, packed | 15.01 | 15.05 |
| packed | 19.28 | 19.34 |
| packed, 4,096 records a window | 19.39 | 19.45 |

    The sum (the figure by the records taken, 70,233 or 59,725 of 130,291, plus the second pass) is what the first
    pass read: the same in both builds within 0.3%, in each of the seven settings. The pass that is subtracted reads
    10% more cycles in `z3`, in every one of its 42 runs (12.37 to 12.66 against 11.40 to 11.48), and a tenth of 11.4
    cycles a record is the whole of the figure's fall (1.16 cycles a record are 2.1 a taken leaf or lookup).
  - *Not the stack's place* (`scripts/job41.sh`: eight pads of the environment, 0 to 3,584 bytes, `padmusl-*`): the
    figure is 15.70 to 15.76 in `w2` and 13.53 to 13.86 in `z3` at every pad, the second pass 11.41 to 11.42 and 12.47
    to 12.64, and the sum 19.88 to 19.92 and 19.93 to 19.94.
  - *Not the counters' reads* (`scripts/facts-gdb-musl.sh`, `job42.sh`: the harness keeps both passes' TSC ticks and
    prints neither; they are read with gdb at its report, three runs a build). A pass's cycles are counted between two
    reads of the counter, with four more system calls inside, and its ticks are read inside those. A unit of musl
    has 97 records a pass:

| musl, a body a window | `w2` | `z3` |
| --- | ---: | ---: |
| the first pass, a record: cycles; ticks | 19.88; 12.07 | 19.94; 12.10 |
| the second pass, a record: cycles; ticks | 11.41; 6.22 | 12.59; 7.06 |
| cycles outside the ticks, a unit's pass: the first; the second | 222; 226 | 221; 224 |
| with 4,096 records a window, the second pass: cycles; ticks | 11.44; 6.25 | 12.58; 7.01 |

    The reads cost some 220 cycles a unit's pass in each pass of each build (a fifth of the second pass's cycles on
    musl), and so they cancel. The second pass's own ticks are 13% more in `z3`: the difference is inside the copying
    alone, the same with one window a unit as with two.
  - *A leaf's and a lookup's own loops* (the harness's ticks inside the kernel) are the same: 6.14 and 30.13 cycles
    in `w2`, 6.14 and 30.12 in `z3`.
  - *What it is was not found.* The second pass alone has some 120 cycles more a unit's pass in `z3` (0.84 ticks a
    record), which the same copying inside the first pass doesn't show. Its function (`node_facts_given`) is the same
    size and retires the same instructions; this change's code before it moved it by 18,896 bytes, from 48 bytes
    into a 64-byte line to a line's start (`results/9700x/addresses-w2-z3.txt`), and the function that holds the
    timing loops was compiled again, its structure's fields having moved. Lua's 34 units have a twentieth of it a
    record (9.14 to 9.21 cycles, the figure 17.73 to 17.57, the sum 19.09 and 19.07) and `sqlite3.c`'s one unit none.
  - *What to read instead:* the sum a record, or the two passes apart. On `sqlite3.c` it is 24.09 and 23.90 with a
    body a window, 19.86 and 19.82 lean, 17.04 and 17.37 for the loads (rounds of 16.73 to 17.24 and 16.98 to 17.72);
    on Lua 19.09 and 19.07, 16.68 and 16.68, 14.21 and 14.34. This change does not move the kernels.
    [buster#2872](https://github.com/buster14a/buster/issues/2872) has it for the harness.

## Checks

- **`test-checker --seed 133`,** the eight parts, on the pull request's sources (a Develop build, native): 842,455
  checks, 0 failures. Its part 5, where the census's tests are, on the `BUSTER_HOST_ARCH=x86-64` build too: 210,262
  checks, 0 failures (that build has no front, and the fixtures check that the tests ran on nothing there).
- **The census's own reports** are the same before and after on `sqlite3.c`, Lua and musl, with the default warnings
  and with `-Wall -Wextra`, and on the four fixtures that gained no line (`scripts/census-run.sh`).
- **The compiler parses and checks itself** (`parse` and `-fsyntax-only -Wall -Werror` of `main.c`), and
  `check-call-graph` finds 0 cycles in 43 translation units and 40,980 functions (its three allowed ones are the
  preprocessor fuzzer's).
- **Faults** (`scripts/mutate_tests.py`, `scripts/mutations.sh`; `results/cloud/mutations.txt`): 26 faults put into the
  sources one at a time, each built and run on the census's part of `test-checker` and on `sqlite3.c` and Lua with
  `-Wall -Wextra`. The tests show 25. The corpora's comparison alone shows 10 (the view reading the wrong record, no
  flags, no constant, no object or no member's offset; a root's kind or an initializer's object's type; the tests'
  bits not kept; the unit's warnings read as none): the other 15 are what the corpora have no expression for, which
  is what the fixtures are for.
  - *Two faults showed nowhere at first* (`results/cloud/mutations-first.txt`): the view without an argument's
    conversion and without a member's offset. Two fixture lines were added for them, `narrow(300);` (a constant an
    argument's conversion changes) and `st.a = st.b = 0;` (two members of one record, where the self-assignment test
    reads the offsets), and both show now.
  - *One shows on no input:* a conditional's third operand's conversion read as its second's. Both operands convert to
    the conditional's common type, so the two are one type wherever the test reads them.
- **105 readings on the 9700X** (`results/9700x/z0` to `z3`: every `--front-tests` run of sections 1 and 4) end with
  status 0: no expression taken there and refused by the census, no test's bit that differs, no root's kind that
  differs, no node outside the records, no unit whose enabled warnings differ.
- **`z3` is not the last commit.** `z3` was built before the two fixture lines above were added: the pull request
  differs from `patches/z3.patch` by those lines of `c_check_node_census_test.c` and their counts (test data, which no
  measured run reads) and by the documents. `patches/pull-request.patch` is the commit.

## Traps

- **A sampling period the kernel won't keep.** `tests-profile.sh` asked `perf record` for a sample every 20,011 user
  cycles, some 275,000 a second on this core, and the kernel kept about a sixth. Its shares are usable and its counts
  are not: I first read the tests' functions as 12 M cycles a pass against a difference of 77 M by the TSC, and looked
  for the rest in page faults. By shares they are all of it. A period of 200,003 keeps every sample (the earlier
  records' scripts use it).
- **A figure of the tests is a difference of two runs of one executable,** T, C and X with and without them, so code
  placement is no part of it; C and X run on 1% fewer expressions with them on `sqlite3.c` (the ones a test refuses).
- **The census's own code was changed,** so its reports are the regression check: `scripts/census-run.sh` runs the
  plain census on the three corpora with the default warnings and with `-Wall -Wextra` and on the six fixtures, and its
  `node-census:` lines must be the same before and after. They are, for the view, for the bytes and gates, and for the
  last sources (the two fixtures that gained lines differ by those lines).
- **A fixture's count is exact on purpose.** With T's warnings kept across expressions (one fault of section
  "Checks") reader time only refuses more, which no comparison forbids; the fixtures' exact counts of refused
  expressions show it.

## Files

- `scripts/tables.py`: every table of sections 1, 4 and 5 from the result files; `results/tables.txt` is its output.
  `scripts/kernel-baseline.py`: section 5's fact words by their two passes; `results/kernel-baseline.txt`.
- `scripts/job36.sh` to `job42.sh`: the 9700X's jobs, in order (`z1`; `z0` beside it; `z2` and the profiles; `z3`,
  the compile and the fact words; musl by the stack's place; musl's two passes by their ticks). They run
  `types-o2.sh` and `types-musl-o.sh` (the shadow's runs), `ticks.sh`, `tests-profile.sh`, `ab-copies-n.sh` (a compile
  from fresh copies), `facts.sh`, `facts-pad-musl.sh` and `facts-gdb-musl.sh` (buster#2850's harness), each run under
  `lock.sh`; `build-label.sh` makes a build from a revision and a patch. `symdiff.py` and `trim.sh` are the symbol
  table's comparison and the result files' trimming.
- `scripts/census-run.sh`, `shapes-local.sh`: the census's reports before and after, and the corpora, on the cloud
  container. `scripts/mutate_tests.py`, `mutations.sh`: the faults.
- `patches/z1.patch`, `z2.patch`, `z3.patch`: each build's `src` and `tools` against main `be6515fba`.
  `patches/plain.patch`: `z0`, on `z1` (the bytes and the gates off). `patches/pull-request.patch` and
  `pull-request-body.md`: the commit (on "C and X where they sit", which waits for its own pull request) and its
  description, for when the three pull requests before it have merged.
- `results/9700x/z0`, `z1`, `z2`, `z3`: each build's runs (`types-TAG-CORPUS-SUFFIX-N.txt`; `tp-*` the profiles;
  `padmusl-*` the stack's places; `gdbmusl-*` the two passes' ticks; `build.log`, `revision.txt`, `compiler.sha256`).
  `results/9700x/w2`: the parent's runs of section 5. `results/9700x/facts-19-24`: the fact words' rounds.
  `results/9700x/ab-copies-w2-z3-1`, `-2`: the compile. `results/9700x/holds-*.txt`: the lock's holds.
  `results/9700x/symbols-w2-z3.txt`, `addresses-w2-z3.txt`: the functions whose size changed, and where the fact
  words' functions sit.
- `results/cloud/mutations.txt`, `mutations-first.txt`: the faults, after and before the two fixture lines.
