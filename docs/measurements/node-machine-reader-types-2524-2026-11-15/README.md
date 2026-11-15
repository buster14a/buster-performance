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

## Checks

- `test-checker --seed 133` in its eight parts on the final sources (cloud, Develop): 842,216 checks, 0 failures on
  the native host, and 844,961 checks, 0 failures on a `BUSTER_HOST_ARCH=x86-64` build (where the walk is the scalar
  one, the front does not run, and T at reader time types nothing).
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

## Files

- `scripts/`: `build-label.sh`, `lock.sh`; the readings: `types-o.sh`, `types-musl-o.sh`, `job10.sh` to `job13.sh`;
  `ab-copies.sh`, `ab-copies-n.sh`; `symdiff.py` (text symbols whose sizes differ between two executables);
  `tables.py`; the cloud's `shapes-local.sh`, `mutate_types.py`, `mutations.sh`.
- `patches/`: `t1.patch` to `t4.patch` (each against main `639e730ed`).
- `results/9700x/LABEL/`: each build's log, revision and checksum, and its runs:
  `types-TAG-{sqlite3,lua,musl}-SUFFIX-N.txt` (suffix `k`: job10, `t1`; `l`: job11, `t2`; `m`: job12, `t3`; `n`: job13,
  `t4`; tags `types1` and `types7`: T at reader time with one and seven timed passes after the pipeline;
  `leantypes1`: with the lean front; `firsttypes1`: the front before the walk; `plain7`, `plain1`: no front);
  `ab-copies-m11-*/`; `symbols-m11-*.txt`; the holds and the jobs' logs.
- `results/cloud/mutations.txt`: the faults' runs. `results/tables.txt`: `tables.py`'s output.
