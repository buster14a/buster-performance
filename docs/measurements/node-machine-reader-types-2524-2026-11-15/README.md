# T where it sits: the node machine's T at reader time (buster#2524), 2026-11-15

[buster#2524](https://github.com/buster14a/buster/issues/2524)'s step 2 puts the node machine in the reader, after a
unit's names are bound and before its program exists. Every figure of step 1 has the machine's sweeps run after the
pipeline: on the finished graph, with the program's columns and with every type's word made at once. This record
measures the first of the sweeps, T, where step 2 would run it: `measure-node-machine --shadow --front-types`
(`c_check_node_machine_reader.c`) runs T right after the reader's coded walk acted at a chunk, on each full expression
the machine's own front made whole. After the pipeline the shadow's own T types the same expression, and the two must
agree in every column that C, X and the shadow read. The design's section is "T where it sits" in
`docs/node-machine.md`.

Host: the Ryzen 7 9700X (`benchpress`), under its lock, a hold a run or a short series; Release builds; `taskset -c 2`;
TSC ticks at 3,792.9 MHz. The pull request's sources are build `t4` (checked: `t4.patch` is the diff of `src` and
`tools` between main `639e730ed` and the branch's commit `ccd5c5463`).

## Findings

1. **T has what it needs at reader time, and it is exact there.** On `sqlite3.c`, Lua and musl, 50,555, 10,545 and
   22,363 expressions are typed both at reader time and by the shadow after the pipeline: none differs in its range,
   its refusal or its records, in any of 248 readings. What the reader had to supply in place of the program's is
   small (the table below), and each piece is compared with the program's own: no object's columns and no library
   call's answer differ.
2. **Where it sits, T costs what a body's expressions a run cost.** On `sqlite3.c` T at reader time is 67.5 TSC ticks
   a record: 9% over the shadow's first pass in its tight loop (61.8) and 25% over its best of seven (54.1). Step 2's
   sum took the sweeps at 75 to 91 cycles a body token (tight, and a body a run); T in place is at the upper figure, so
   the sum is at its lower end: 1.25 times on `-c sqlite3.c` with the lean front.
3. **Sparse expressions cost much more.** Lua has an expression every 21 acting tokens and musl one every 49
   (`sqlite3.c`: one every 8). T at reader time is 84.3 and 134.5 ticks a record there, 1.4 and 2.2 times the tight
   loop's first pass. Step 2's gate has a line for those corpora (no unit slower by more than 1%).
4. **A reader types much that is never lowered.** Of the expressions T runs on at reader time, 7.0% on `sqlite3.c`,
   13.1% on Lua and 45.9% on musl are ones it takes in bodies that no lowering pops: the selection drops them. The
   pipeline reads and types them today and stops there; a machine in the reader would run C and X on them too.
5. **The machine's state is a scan a unit as the shadow makes it:** 0.96 ms on `sqlite3.c`, 3.39 ms for Lua's 34 units
   and 35.1 ms for musl's 1,336, where T's own time is 8.8 ms. Step 2 would make it as the declarations are read.
6. **A compile is unchanged** (+0.07% and -0.18%; 26,000 instructions of 1,363 M). The shadow's own sweeps retire 1.6
   to 2.2 more instructions a node (0.5%). Two earlier builds of this work cost them 21 and 2.4: a cold call in the
   type word's read, and a helper that was no longer inlined.

`scripts/tables.py` prints every table below from the result files (`results/tables.txt` is its output).

## What the reader supplies

The coded walk runs once the reader has bound the whole unit's names and made its declarations' types, so the unit's
types and its tags' history are whole by then (the history is on the graph before the walk starts). What T reads that
the graph run or the program makes:

| what T reads | after the pipeline | at reader time | checked by |
| --- | --- | --- | --- |
| an object's last static declaration, returns_twice, asm label | `CheckProgram`'s three columns | the same three made from the reader's columns, by the program's own tests | each object's against the program's |
| whether a called object has a symbol | the selection's numbering | whether it has a static declaration | T's records |
| a library call's "computed inline?" | the stream's value of its size (`check_program_call_library`) | T's own record of the size | each call's answer against the program's |
| a node's context | the graph's | the front's own, which is the walk's at the unit's end | the front's comparison |
| a type's word, its completion position, its pointer | every type's, made when the machine begins | the unit's when the machine begins; a later type's when it is made | T's records |

An expression is a root's operand's subtree and the root: a discard's cast, a condition, a return's conversion. An
initialization's is its value alone, whose root the lowering pops with the object's type as its target.

## Builds

All on main `639e730ed` (#2861 merged).

| label | sources | what |
| --- | --- | --- |
| `m11` | main `639e730ed` | the baseline |
| `t1` | `m11` with `patches/t1.patch` | T at reader time; a type's word past the table made in the read's miss, a cold call |
| `t2` | `m11` with `patches/t2.patch` | the type word's read as main has it; a type T makes is settled where it is made |
| `t3` | `m11` with `patches/t3.patch` | `t2` with the three program-or-reader helpers inline |
| `t4` | `m11` with `patches/t4.patch` | `t3` with the pointer type's making out of line: the pull request's sources |

After main gained #2850's fact words (buster#2863, main `fdf0de745`), for section 5:

| label | sources | what |
| --- | --- | --- |
| `m12` | main `fdf0de745` | the baseline with the fact words' kernel |
| `u1` | `m12` with `patches/u1.patch` | the pull request's branch with that main merged in (`55ad392b4`) |
| `m13` | `m12` with `patches/align.patch` | `m12` with the fact words' eight kernel functions aligned to 64 bytes |
| `u2` | `m12` with `patches/u2.patch` | `u1` with the same alignment |

After main gained the follow-up's lean record and the load alone (buster#2868, main `be6515fba`), for section 6:

| label | sources | what |
| --- | --- | --- |
| `m14` | main `be6515fba` | the baseline with the kernel's three variants |
| `u3` | `m14` with `patches/u3.patch` | the pull request's branch with that main merged in (`084b3facb`) |

## 1. Exact

The shadow's reading by `t4` (`results/tables.txt`, sections 3 and 4); the same counts in every run of a corpus:

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| expressions T ran on at reader time | 56,681 | 13,184 | 57,888 |
| their records, and those T typed | 314,762, 311,245 | 92,986, 91,609 | 267,931, 248,824 |
| T took | 55,063 | 12,568 | 49,115 |
| T refused: a context (a static object's initializer) | 1,480 | 556 | 8,577 |
| T refused: a callee | 138 | 60 | 155 |
| T refused: a leaf | 0 | 0 | 41 |
| in a lowered body (the lowering popped its root) | 51,255 (90.4%) | 10,896 (82.6%) | 22,914 (39.6%) |
| in none, and taken | 3,941 (7.0%) | 1,722 (13.1%) | 26,597 (45.9%) |
| in none, and refused for its context | 1,480 | 556 | 8,346 |
| compared with the shadow's T (the census's taken set) | 50,555 | 10,545 | 22,363 |
| their records | 285,934 | 74,207 | 132,443 |
| differences: range, refusal, records | 0, 0, 0 | 0, 0, 0 | 0, 0, 0 |
| the census's taken expressions the front left (T not run) | 778 | 284 | 672 |
| taken expressions the front made without a root | 0 | 0 | 2 |
| objects with a static declaration; differences | 5,201; 0 | 13,118; 0 | 255,903; 0 |
| library calls T asked of; differences | 332; 0 | 53; 0 | 0; 0 |
| types made after the machine began | 1,264 | 1,081 | 4,786 |

- The comparison is a digest of each expression's records: the refusal, and of every typed record its operator and
  operands, its value whole, its type's word, its operands' conversions, its member's offset, its subtree's least
  record, and a call's arguments with their conversions.
- musl's two expressions without a root are an initializer beside a variable-length array's bound
  (`char (*p)[width] = base;` in `lsearch.c`): the front's INITIALIZE takes two values there and is left.
- The late types are nearly all the walk's own (a string literal's array type). T's derivations make a handful: with
  their words withheld, two expressions of `sqlite3.c` and one of Lua differ (fault 3 below).
- All 248 readings by `t1` to `t4` (whole and lean fronts, the front before and after the walk) give no difference.
  In the cloud (Develop build of the same sources, its own copies of the corpora): none either.

## 2. What it costs where it sits

`scripts/job13.sh` (`types-o.sh`, `types-musl-o.sh`): seven readings of `sqlite3.c` and Lua and three of musl by each
spec in turn. T at reader time is timed as one run over a chunk's roots (TSC ticks; the digests are a second run). The
shadow's T after the pipeline is its timed sweep in the tight loop over the taken expressions, one pass
(`--passes 1`) or the best of seven. Medians:

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| T at reader time, ms | 5.54 | 2.04 | 8.82 |
| ticks a typed record | 67.5 | 84.3 | 134.5 |
| the shadow's T, one pass: ticks a record | 61.8 | 59.8 | 61.7 |
| its cycles and instructions a record | 90.3, 298.0 | 87.2, 334.8 | 93.5, 323.3 |
| the shadow's T, best of seven: ticks a record (cycles) | 54.1 (79.1) | 43.2 (62.9) | |
| reader time over one tight pass | 1.09 | 1.41 | 2.18 |
| reader time over the best of seven | 1.25 | 1.95 | |
| acting tokens an expression | 8.2 | 21.4 | 48.9 |
| the machine's state as the shadow makes it, ms | 0.96 | 3.39 | 35.09 |
| with the lean front: T at reader time, ticks a record | 91.8 | 103.6 | 163.9 |
| the front before the walk: T at reader time, ticks a record | 67.8 | 84.2 | |

- **At about 1.46 cycles a tick** (the shadow's own sweeps' cycles over their ticks), T at reader time is about 99,
  123 and 204 cycles a record.
- **`sqlite3.c`:** in place T is 1.25 times its best in the tight loop, which is what the design's "Where the machine
  runs" measured for a body's expressions a run (199 cycles a node against 164).
- **Lua and musl:** a chunk holds few expressions, and between two chunks' runs of T the reader reads a chunk's
  tokens, the front makes its records and the shadow compares them. This record has no counters at reader time; the
  design's same section measured the cause with other code between runs (217 to 273 cycles a node at the shortest
  runs).
- **The lean front's rows are the shadow's own cost:** it finds a root's operand's record by a search of the front's
  places, inside the timed run. A machine would have it.
- **The state** is what `node_machine_begin_reader` does a unit: every type's word and completion position, the unit's
  declarations read for the objects' three columns, the pointers' columns and the argument memo cleared.

## 3. The shadow's own sweeps, and a compile

The sweeps after the pipeline with no front, `m11` against each build in turn, seven passes (`--passes 7`; musl one):

| instructions a node (cycles) | T | T+C | T+C+X |
| --- | ---: | ---: | ---: |
| `sqlite3.c`, `m11` | 336.8 (89.1) | 508.0 (134.5) | 596.5 (176.1) |
| `t1` | 340.0 | 524.6 | 617.7 |
| `t2`, `t3` | 338.9 | 510.4 | 598.9 |
| `t4` | 338.4 (90.0) | 509.8 (135.4) | 598.3 (175.4) |
| Lua, `m11` | 427.7 (79.4) | 600.4 (117.5) | 685.2 (148.0) |
| `t4` | 429.9 (80.7) | 603.0 (118.6) | 687.8 (148.8) |
| musl, `m11` | 382.0 (119.9) | 555.3 (156.2) | 646.7 (192.1) |
| `t4` | 384.2 (123.2) | 557.6 (161.2) | 649.1 (194.7) |

- **`t1`** read a type's word through a miss path that called a cold function (the word of a type made after the
  machine began). The call was never taken after the pipeline, and it cost C and X 17 to 21 instructions a node.
  `t2` reads the word as main does, and takes a later type into the table where the type is made.
- **`t2` and `t3`** added a test and a call to the miss of `node_machine_pointer`, and the rules stopped inlining it
  (`node_machine_rule` shrank from 27,050 to 24,061 bytes, `results/9700x/symbols-m11-t3.txt`). `t4` has the miss's
  body out of line.
- **`t4`'s 1.6 to 2.2 instructions a node** are the tests of where a callee's facts come from (the program or the
  reader), a call at a time.

`-c sqlite3.c`, whole processes from three fresh copies of each executable, 21 runs a build (`ab-copies-n.sh`):

| | wall ms, `m11` | head | against `m11` (over copies) | instructions, M |
| --- | ---: | ---: | --- | --- |
| `t1`, first | 123.119 | 123.125 | +0.00% (-0.93% to +0.54%) | 1,363.298, 1,363.324 |
| `t1`, second | 123.597 | 123.263 | -0.27% (-0.98% to +0.12%) | 1,363.298, 1,363.324 |
| `t2`, first | 122.849 | 122.989 | +0.11% (-0.19% to +0.59%) | 1,363.298, 1,363.324 |
| `t2`, second | 123.350 | 123.143 | -0.17% (-1.16% to +0.14%) | 1,363.298, 1,363.324 |
| `t3`, first | 122.658 | 123.281 | +0.51% (+0.18% to +0.69%) | 1,363.298, 1,363.324 |
| `t3`, second | 123.492 | 123.012 | -0.39% (-0.59% to +1.35%) | 1,363.298, 1,363.324 |
| `t4`, first | 122.949 | 123.039 | +0.07% (-0.16% to +0.21%) | 1,363.298, 1,363.324 |
| `t4`, second | 123.257 | 123.037 | -0.18% (-0.34% to +0.20%) | 1,363.298, 1,363.324 |

A compile runs one more call a unit (the front's state asks whether T runs there), in the coded walk's start.

## 4. Faults

In the cloud (`scripts/mutate_types.py`, `scripts/mutations.sh`, `results/cloud/mutations.txt`): one build of the final
sources with 19 single faults in the reader-time path, each selected by an environment variable, run on
`test-checker`'s fixtures (whole and lean) and on `sqlite3.c` and Lua.

| fault | shows in |
| --- | --- |
| 1: a memory builtin's size is never asked | the fixture, `sqlite3.c` (199 expressions), Lua |
| 2: an asm label is ignored | the fixture |
| 3: a type T makes gets no word | the chunk-boundary fixture, `sqlite3.c` (2), Lua (1) |
| 5: no object has a symbol | the fixture, Lua |
| 6: the names that return twice aren't looked up | the fixture, Lua |
| 7: an expression's range starts a node late | every fixture, both corpora |
| 8: an initialization's INITIALIZE is a record | the fixtures (expressions the front made, not run), both corpora |
| 9: returns_twice is forgotten in T's refusal | the fixture's count of callees refused |
| 10: an object's first static declaration, not its last | the fixture, both corpora (the objects' columns) |
| 12: the jmp_buf's tag isn't looked up | the fixture |
| 13: an asm label is never recorded | the fixture, both corpora (the objects' columns) |
| 14: returns_twice is never recorded | the fixture (the objects' columns) |
| 15: a lean root's operand a record late | the fixture, lean |
| 16: a call's arguments are no part of its size | the fixtures, both corpora |
| 17: a record kept across a chunk's end loses its size | the fixtures, both corpora |
| 18: an operand taken twice counts twice | the fixture |
| 4: T reads the graph's own contexts as they stand after the chunk | nothing |
| 11: a later type is complete everywhere | nothing |
| 19: a type the action makes gets no word | nothing |

- **Fault 9** shows in no comparison: the census refuses a returns_twice callee and a library builtin's call before
  the shadow's T, so T's refusal of them at reader time has nothing to be compared with. The objects' columns and the
  library answers behind it are compared with the program's directly, and the fixture counts the six callees reader
  time refuses.
- **Fault 4:** by the time a chunk's nodes are written, the walk has marked the contexts of a taken expression's
  nodes; the contexts it marks later are constant constructs' (a list's values, a case's), which are no taken root's.
  The front's contexts are kept because step 2 has no walk to mark them.
- **Faults 11 and 19:** a type made late is an array's or a pointer's, complete wherever it is asked; and no
  expression here reads the word of a type the action made before something else settled it.

## 5. After main gained the fact words (buster#2863)

#2863 merged while this pull request was open. Both add a file to the node machine's part of the checker unit, and
this one changes T's file. Does it slow the other session's kernel? `measure-node-machine --shadow --facts` by that
record's own script and settings (`scripts/facts.sh`, from `per-core-step1-2850-2026-11-15`, with a run's number
given): `--passes 5`, the labels in turn, CPU 2, each run its own hold of the lock (`scripts/job14.sh`,
`scripts/job15.sh`). Medians, by that record's `tables.py` (`scripts/facts-tables.py`).

Cycles a taken leaf or lookup, `m12` against `u1`, six runs each (`results/9700x/facts-m12-u1-six.txt`):

| | a body a window | packed to 384 | packed to 4,096 |
| --- | ---: | ---: | ---: |
| `sqlite3.c` | 26.23, 26.45 (+0.8%) | 22.26, 22.44 (+0.8%) | 21.47, 22.27 (+3.7%) |
| Lua | 17.36, 17.33 (-0.2%) | 15.00, 15.02 (+0.1%) | 15.74, 15.95 (+1.3%) |
| musl | 16.01, 15.96 (-0.3%) | 15.04, 15.02 (-0.1%) | 15.10, 15.12 (+0.1%) |
| instructions, both builds | 73.27, 75.76, 71.32 | 68.91, 67.63, 67.38 | 70.29, 67.58, 66.95 |

- **The kernel does the same work.** Its instructions a taken leaf or lookup are the same to the hundredth on the nine
  rows, its mispredicted branches the same (0.376 and 0.371, 0.241, 0.145 and 0.146 on `sqlite3.c`), every record is
  T's in all 162 runs, and `symdiff.py` lists none of its functions (`results/9700x/symbols-m12-u1.txt`): their sizes
  are the same.
- **Its cycles move with its place.** The widest windows on `sqlite3.c` read 3.7% slower, three runs and three more
  apart: a lookup 38.5 to 39.7 cycles, a leaf 5.43 to 5.26. This branch's code comes before the kernel's in the unit,
  and each of the kernel's eight functions is 0x2c50 bytes further on, 16 bytes into its 64-byte line
  (`results/9700x/facts-addresses.txt`).

The same pair with those eight functions aligned to 64 bytes, `m13` against `u2`, three runs each
(`results/9700x/facts-m13-u2.txt`):

| | a body a window | packed to 384 | packed to 4,096 |
| --- | ---: | ---: | ---: |
| `sqlite3.c` | 26.66, 26.24 (-1.6%) | 22.38, 22.34 (-0.2%) | 21.71, 21.86 (+0.7%) |
| Lua | 17.50, 17.38 (-0.7%) | 15.13, 15.02 (-0.7%) | 15.94, 15.88 (-0.4%) |
| musl | 16.95, 15.99 (-5.7%) | 16.13, 15.08 (-6.5%) | 16.22, 15.22 (-6.2%) |

- **With the kernel's functions at one place in both builds the 3.7% is 0.7%**, and the other `sqlite3.c` and Lua rows
  read faster with this branch.
- **Aligning them is no cure.** `m13` is `m12` with the alignment alone, and its musl rows read 6% slower than
  `m12`'s, with the same ticks a leaf and a lookup (6.59 and 30.09 against 6.45 and 30.11): what moved is the rest of
  a window's pass, which musl's small units have most of. These figures move a few percent with the code's place,
  either way; the fact words' own record has 26.54 where `m12` has 26.23 for the same kernel.

`-c sqlite3.c`, `m12` against `u1`, as section 3's (`results/9700x/ab-copies-m12-u1-1`, `-2`):

| | wall ms, `m12` | `u1` | against `m12` (over copies) | instructions, M |
| --- | ---: | ---: | --- | --- |
| first | 123.344 | 122.934 | -0.33% (-0.71% to -0.11%) | 1,363.438, 1,363.464 |
| second | 123.799 | 123.071 | -0.59% (-1.76% to -0.16%) | 1,363.438, 1,363.464 |

## 6. After main gained the lean record and the load alone (buster#2868)

#2868 merged next, and main `be6515fba` is merged into the branch (`084b3facb`): one conflict, the shadow's failure
test, both sides' terms kept. The same question as section 5, of the kernel's three variants now: the whole record
(`--facts`), the lean one (`--facts-lean`) and a lookup's load alone (`--facts-loads`), each with a body a window and
with the windows packed to 384 records (that follow-up's record's settings, `per-core-step1-lean-2850-2026-11-15`), and
the whole kernel packed to 4,096. `scripts/facts.sh` as in section 5, `--passes 5`, the labels in turn, CPU 2, each run
its own hold of the lock (`scripts/job21.sh`, `job22.sh`); medians by that record's `tables.py`
(`scripts/facts-tables2.py`).

Cycles a taken leaf or lookup, `m14` against `u3`, six runs each (`results/9700x/facts-m14-u3-six.txt`):

| | whole | lean | loads |
| --- | ---: | ---: | ---: |
| `sqlite3.c`, a body a window | 22.88, 23.16 (+1.2%) | 20.56, 20.86 (+1.5%) | 15.18, 15.31 (+0.9%) |
| Lua | 17.68, 17.64 (-0.2%) | 16.07, 15.76 (-1.9%) | 10.94, 10.73 (-1.9%) |
| musl | 15.82, 15.76 (-0.4%) | 14.00, 13.94 (-0.4%) | 8.91, 8.84 (-0.8%) |
| `sqlite3.c`, packed to 384 | 18.96, 19.03 (+0.4%) | 16.66, 16.59 (-0.4%) | 11.07, 11.79 (+6.5%) |
| Lua | 14.95, 14.92 (-0.2%) | 13.48, 13.41 (-0.5%) | 8.43, 8.41 (-0.2%) |
| musl | 14.67, 14.64 (-0.2%) | 12.96, 12.87 (-0.7%) | 7.79, 7.82 (+0.4%) |
| `sqlite3.c`, packed to 4,096 | 19.11, 19.11 (0.0%) | | |
| Lua | 16.00, 15.94 (-0.4%) | | |
| musl | 14.88, 14.83 (-0.3%) | | |

- **The kernel does the same work.** Its instructions a taken leaf or lookup are the same to the hundredth on the 21
  rows, its mispredicted branches the same (on `sqlite3.c` 0.252 and 0.248, 0.216 and 0.208, 0.205 and 0.202 in
  bodies; 0.117, 0.091, 0.088 and 0.089, and 0.031 packed), and every record is T's in all 364 runs of this section.
  Its functions have the same sizes, and the kernel's 24 (from `node_facts_given` on) are each 0x1c40 bytes further
  on in `u3`: 113 lines of 64 bytes, so at the same place in its line this time
  (`results/9700x/facts-addresses-m14-u3.txt`).
- **Lua and musl read the same or faster with this branch** on their 14 rows (-1.9% to +0.4%), and `sqlite3.c`
  with its windows packed is within 0.4% either way, but for one row.
- **That row is its runs' spread.** The load alone, packed, on `sqlite3.c`: `m14`'s six runs are 10.93 to 11.13 and
  `u3`'s 11.11 to 13.19. Twelve more runs each (`scripts/job24.sh`, `results/9700x/facts-one-m14-u3.txt`) make the
  medians of eighteen 11.04 and 11.19 (+1.3%), with `m14` from 10.76 to 11.29 and `u3` from 10.40 to 13.19; and twelve
  each without address-space randomization read 10.88 and 11.00 (+1.1%; 10.82 to 11.20, and 10.82 to 11.90). By
  profile over 160 passes, three processes each, that kernel's functions take 690 M and 693 M cycles
  (`results/9700x/facts-events-loadspacked-m14-u3.txt`).

### `sqlite3.c` with a body a window: the leaves' loop

The three `sqlite3.c` rows in bodies read 0.9% to 1.5% slower. What moved is one loop, `node_facts_leaves` (198 bytes,
the same code in both builds: a leaf's line loaded, its 64-byte record stored):

| `node_facts_leaves`, whole kernel, a body a window | `m14` | `u3` |
| --- | ---: | ---: |
| cycles a leaf (the split pass's ticks), six runs | 6.40 (6.04 to 6.53) | 7.56 (7.47 to 7.70) |
| cycles a lookup, the same runs | 39.80 | 39.57 |
| its cycles over 160 passes, three processes, M | 197, 206, 197 | 244, 221, 232 |
| the kernel's functions together, the same, M | 1,875, 1,881, 1,885 | 1,928, 1,913, 1,917 |
| in it over 160 passes, one process, M: instruction cache misses | 1.08 | 2.22 |
| op cache misses | 3.44 | 4.10 |
| ops dispatched from the op cache | 251 | 295 |
| mispredicted branches | 1.34 | 1.54 |
| store-to-load interference | 3.22 | 4.71 |
| demand fills of the data cache | 6.69 | 7.15 |

(`scripts/job23.sh`, `job25.sh`, `job28.sh`; `results/9700x/facts-events-body-m14-u3.txt`,
`facts-annotate-body-m14-u3.txt`, `facts-annotate-front-m14-u3.txt`, and each build's `fe-body-*` and `fa-*` files.)

- **It is not the kernel's data.** Its arrays are at the same addresses in both builds: `rows`, `lines`, `numbers`,
  `inputs`, `records`, the lists (`results/9700x/{m14,u3}/where.txt`: gdb at the first window's leaves).
- **It is not where the stack falls.** Without randomization and with the stack moved down by 0 to 3,840 bytes in
  steps of 256 (`scripts/job26.sh`, `results/9700x/facts-pad-m14-u3.txt`), `m14`'s leaf is 6.10 to 6.40 cycles at 14 of
  the 16 positions (6.59 and 7.21 at the two others) and `u3`'s 7.31 to 7.81 at 15 (8.68 at the other). The kernel's own
  figure over those 16 runs has medians of 22.87 and 22.91 cycles a taken leaf or lookup: the loop's cost is in the sum
  only in part.
- **It is the loop's code's place.** The same four lines of code are at page offset 0xee0 in `m14` and 0xb20 in
  `u3`, so in other sets of the instruction cache and the op cache, and they miss twice as often there: 2,918 windows
  a pass start the loop cold. More of its branches mispredict, more ops are dispatched for the same instructions
  retired, and more of its loads meet a store in flight.

The lean leaves' loop (`node_facts_leaves_lean`, in the lean and the loads' rows) also moves with the stack, in both
builds. Without randomization, by the same 16 positions: 5.29 to 5.38 cycles a leaf at nine of `m14`'s and 5.64 to
7.00 at the others; 5.19 to 5.38 at five of `u3`'s and 5.76 to 7.48 at the others. With randomization on a run's
stack falls anywhere: the six runs of the loads' row in bodies read 5.33 to 7.71 cycles a leaf by `m14` and 6.02 to
7.21 by `u3`. Both loops reload the records' base from the stack each leaf, between their 64-byte stores
(`mov 0x10(%rsp),%rax`: 12% to 14% of the whole loop's cycles): that is a reading of why the stack matters, not a
measurement of it.

`-c sqlite3.c`, `m14` against `u3`, as section 3's (`results/9700x/ab-copies-m14-u3-1`, `-2`):

| | wall ms, `m14` | `u3` | against `m14` (over copies) | instructions, M |
| --- | ---: | ---: | --- | --- |
| first | 122.939 | 123.429 | +0.40% (-0.48% to +0.65%) | 1,363.438, 1,363.464 |
| second | 123.120 | 123.089 | -0.02% (-0.06% to +0.02%) | 1,363.438, 1,363.464 |

The same instructions as section 5's pair: #2868 changes the shadow alone. A whole shadow process at 160 passes
retires 0.27% more instructions with the branch (the sweeps' helpers of section 3) in 0.9% to 1.6% fewer cycles.

## Checks

- `test-checker --seed 133` in its eight parts on the final sources (cloud, Develop): 842,216 checks, 0 failures on
  the native host, and 844,961 checks, 0 failures on a `BUSTER_HOST_ARCH=x86-64` build (where the walk is the scalar
  one, the front does not run, and T at reader time types nothing).
- On the two merged heads (cloud, Develop): `55ad392b4`, the eight parts, 842,444 checks, 0 failures natively and
  the census's part on the `x86-64` build, 210,251 checks, 0 failures; `084b3facb`, 842,448 and 210,255, 0 failures,
  with `--facts`, `--facts-lean`, `--facts-loads` and `--front-types` on the three corpora: no difference.
- `./build.sh check-call-graph --config Release`: 0 cycles (cloud).
- The self-check (`-fsyntax-only -Wall -Werror` of `main.c`) and the self-parse pass.

## Traps

- **A read's miss path is part of the read.** Replacing a constant by a cold call in `node_machine_word`'s miss cost
  the sweeps 17 to 21 instructions a node, though the call is never taken after the pipeline (section 3).
- **A line in a small function's miss can stop its inlining.** `node_machine_pointer` is a load; with a second call
  in its miss the rules called it. `scripts/symdiff.py` showed it by the callers' sizes.
- **The census hides T's refusals.** A refusal the census makes first can't be compared through the shadow; compare
  the facts behind it, and count it in a fixture.
- **The cloud VM's ticks mislead**, as in the earlier records: conclusions here are the 9700X's.
- **Another kernel's cycles move when code is added before it.** Section 5: the same instructions and the same
  mispredicted branches, 16 bytes further into the line, and 3.7% more cycles on one setting. Compare a kernel's
  builds at one main, and read a cross-main difference of a few percent as its place until an aligned pair says
  otherwise.
- **A loop's place is also its cache sets.** Section 6: at the same place in its line, a 198-byte loop that 2,918
  windows a pass enter reads 18% slower 0x1c40 bytes further on, with twice the instruction cache misses. Its data's
  addresses and the stack's position were ruled out first (gdb; randomization off and the stack moved by an
  environment variable); misses by symbol said it.
- **A median of six can be three bad runs.** Section 6's +6.5% is +1.3% over eighteen runs. Read each run before a
  median that stands alone.
- **`perf stat` takes the counters a run reads itself**: under it the kernel's own cycles print as 0.

## Files

- `scripts/`: `build-label.sh`, `lock.sh`; the readings: `types-o.sh`, `types-musl-o.sh`, `job10.sh` to `job13.sh`;
  `ab-copies.sh`, `ab-copies-n.sh`; `symdiff.py` (text symbols whose sizes differ between two executables);
  `tables.py`; the cloud's `shapes-local.sh`, `mutate_types.py`, `mutations.sh`.
- `patches/`: `t1.patch` to `t4.patch` (each against main `639e730ed`); `u1.patch`, `align.patch` and `u2.patch`
  (each against main `fdf0de745`).
- `results/9700x/LABEL/`: each build's log, revision and checksum, and its runs:
  `types-TAG-{sqlite3,lua,musl}-SUFFIX-N.txt` (suffix `k`: job10, `t1`; `l`: job11, `t2`; `m`: job12, `t3`; `n`: job13,
  `t4`; tags `types1` and `types7`: T at reader time with one and seven timed passes after the pipeline;
  `leantypes1`: with the lean front; `firsttypes1`: the front before the walk; `plain7`, `plain1`: no front);
  `ab-copies-m11-*/`; `symbols-m11-*.txt`; the holds and the jobs' logs.
- Section 5's: `scripts/job14.sh`, `job15.sh`, `facts.sh` and `facts-tables.py` (the fact words' record's `facts.sh`
  and `tables.py`), `lock-merge.sh` (the lock's title for these runs); `results/9700x/{m12,u1,m13,u2}/facts-CORPUS[-SETTING]-N.txt`
  (runs 1 to 3: job14; 4 to 6: job15), `facts-m12-u1-six.txt`, `facts-m13-u2.txt`, `facts-addresses.txt`,
  `symbols-m12-u1.txt`, `ab-copies-m12-u1-*/`, `job14.log`, `job15.log`.
- Section 6's: `patches/u3.patch` (against main `be6515fba`); `scripts/job21.sh` to `job26.sh` and `job28.sh`,
  `facts-tables2.py` (the follow-up's record's `tables.py`), `facts-events.sh` and `facts-events.py` (counters of a
  whole process and its cycles by symbol), `facts-one.sh` (runs with or without randomization), `facts-annotate.sh`
  (events by symbol and by a function's instructions), `facts-pad.sh` (the stack moved by an environment variable),
  `facts-where.sh` (the arrays' addresses), `lock-merge2.sh`; `results/9700x/{m14,u3}/`: `facts-CORPUS[-SETTING]-N.txt`
  (runs 1 to 3: job21; 4 to 6: job22), `fe-*` (job23), `one-{aslr,fixed}-N.txt` (job24), `fa-body-*` (job25),
  `pad-{body,loads}-PAD.txt` (job26), `fa-front-*` (job28), `where.txt`; and `facts-m14-u3-six.txt`, `-three.txt`,
  `facts-addresses-m14-u3.txt`, `symbols-m14-u3.txt`, `facts-events-*.txt`, `facts-one-m14-u3.txt`,
  `facts-annotate-*.txt`, `facts-pad-m14-u3.txt`, `ab-copies-m14-u3-*/`, the jobs' logs and the holds.
- `results/cloud/mutations.txt`: the faults' runs. `results/tables.txt`: `tables.py`'s output.
