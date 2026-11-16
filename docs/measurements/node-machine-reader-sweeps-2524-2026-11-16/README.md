# C and X where they sit: the node machine's other two sweeps at reader time (buster#2524), 2026-11-16

[buster#2524](https://github.com/buster14a/buster/issues/2524)'s step 2 puts the node machine in the reader.
[T where it sits](../node-machine-reader-types-2524-2026-11-15) ran the first of its sweeps there, in the shadow, and
left the other two after the pipeline. This record runs them at reader time too, under
[the claim](https://github.com/buster14a/buster/issues/2524#issuecomment-6904114428):
`measure-node-machine --shadow --front-sweeps` runs C and X right after T on each full expression T takes there, before
the unit's program exists. After the pipeline the shadow's own C and X run on the same expression, and reader time's
tape, patched with the program's symbols, must be theirs entry for entry. The design's section is "C and X where they
sit" in `docs/node-machine.md`.

Host: the Ryzen 7 9700X (`benchpress`), under its lock, a hold a run; Release builds; `taskset -c 2`; TSC ticks at
3,792.9 MHz. The pull request's sources are build `w2` (checked: `patches/w2.patch` is the diff of `src` and `tools`
between main `be6515fba` and the commit). No compile takes any of it.

## Findings

1. **C and X have what they need at reader time, and they are exact there.** On `sqlite3.c`, Lua and musl, 50,555,
   10,544 and 22,324 expressions are compared: none differs in its root's target or object, its refusal, its tape, its
   labels or its calls, in any of 34 readings (whole front and lean).
2. **What they read of the program was one thing: an object's symbol.** Whether an object has one (a global, or a local
   the function numbers), and a global's symbol in its entries and in a direct call's row. The machine holds the
   objects' columns itself now; at reader time an object with a static declaration, and a string's object, has itself
   in its symbol's place.
3. **A splice patches little.** In `sqlite3.c`'s compared expressions 2,199 entries of 331,155 hold a global and there
   are 12,555 direct calls; Lua 668 of 65,963 and 3,845; musl 2,396 of 133,898 and 4,871. Locals, labels, calls' rows
   and temporaries were relative on a tape already.
4. **The root's consumer is the front's root.** Every root the shadow takes is popped by the lowering with no context,
   and only an initialization has a conversion's target: its object's type without its qualifiers, where the conversion
   writes entries.
5. **Where they sit, the three sweeps cost what a body's expressions a run cost.** On `sqlite3.c` T, C and X at reader
   time are 127.7 ticks a typed record, 1.19 times their tight loop's first pass: about 212 cycles a node, where the
   design's "Where the machine runs" has 216.5 for the three with a body's expressions a run. C and X pay a third over
   their tight loop (58.7 against 44.0) and T a tenth.
6. **Step 2's sum stands at 1.25 on `sqlite3.c`.** It took T and the one sweep at a body's expressions a run; reader
   time ran the three sweeps as they are and reads them just under that position's figure.
7. **Sparse expressions cost C and X as they cost T:** the three are 1.40 times the tight loop's first pass on Lua and
   2.26 times on musl.
8. **A compile is unchanged** (-0.47% and -0.15%, the same 1,363.464 M instructions).
9. **The shadow's own sweeps retire 0.5 to 0.7 fewer instructions a node and read 1.3% more cycles as built.** That is
   inside what their frames' place on the stack alone moves them: 5.6% in the baseline and 8.4% in this build, over 32
   places. At each build's best places the three sweeps are 1.0% apart, all of it X's, whose functions the Release
   build's parts now place beside T's.
10. **The fact words' kernels (buster#2850) do the same work** and read from 4.8% faster to 8.9% slower by row: their
    lean leaves' loop is 32 bytes further into its line, and on Lua it misses the op cache 15 times as often.

`scripts/tables.py` prints the tables below from the result files (`results/tables.txt` is its output for `w2`,
`results/tables-w1.txt` for `w1`).

## Builds

All on main `be6515fba` (#2868 merged).

| label | sources | what |
| --- | --- | --- |
| `u3` | main with #2867's branch merged (`084b3facb`) | the baseline: T alone at reader time. Built for the earlier record's section 6; its runs here are new |
| `w1` | main with `patches/w1.patch` | C and X at reader time; the commit's sources but for the tests' last fixture lines |
| `w2` | main with `patches/w2.patch` | the pull request's sources |

`w1` and `w2` differ in `c_check_node_census_test.c` alone. `scripts/job29.sh` ran `w1`, `scripts/job30.sh` ran `w2`;
the tables are `w2`'s, and `w1`'s agree.

## 1. Exact

`measure-node-machine --shadow --front-sweeps` (the whole front) and `--front-lean --front-sweeps`, `--passes 1`. The
first run of each; every run of the seven (musl's three) reads the same:

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| expressions T ran on at reader time; took | 56,681; 55,063 | 13,184; 12,568 | 57,888; 49,115 |
| C and X ran on (those T took); took | 55,063; 50,393 | 12,568; 10,387 | 49,115; 41,209 |
| refused: a template, a row | 4,670, 0 | 2,181, 0 | 7,882, 24 |
| entries written; tapes the store had no room for | 331,566; 0 | 67,513; 0 | 214,275; 0 |
| compared after the pipeline: expressions, entries | 50,555, 331,155 | 10,544, 65,963 | 22,324, 133,898 |
| differences: root, refusal, tape, labels and calls | 0, 0, 0, 0 | 0, 0, 0, 0 | 0, 0, 0, 0 |
| patched in the compared ones: globals' entries, direct calls | 2,199, 12,555 | 668, 3,845 | 2,396, 4,871 |
| with the lean front: compared, differences | 50,370, 0 | 10,524, 0 | 22,258, 0 |

- **Compared** are the expressions of the census's taken set that T took both times; reader time's other expressions
  are ones the lowering never popped (`sqlite3.c`: 3,941 of the 55,063; Lua 1,722; musl 26,597) or ones the census
  refuses. **Corrected 2026-11-16:** this first said "in bodies the lowering never popped". Most of the never-popped
  on `sqlite3.c` and Lua are a declaration's discard (the walk's cast to void of an initializer's value at the
  declaration's `;`: 3,828 and 1,708), and 22 and 9 are in bodies the selection drops; on musl 5,557 and 20,745
  ([the correction](https://github.com/buster14a/buster/issues/2524#issuecomment-6908043343)). C and X ran on those
  discards too, and the ticks a typed record include them. The pull request's description and patch kept in
  `patches/` still have the first reading in one bullet ("The reader runs them for nothing too"); it is corrected where
  the commit is carried to its pull request.
- **The comparison:** the root's conversion's target and its object against the lowering's pop's; the refusal; each
  entry's kind, class and value, a global's value (`GLOBAL`, `GLOBAL_ADDRESS`, `STORE_GLOBAL`, `SET_GLOBAL`) after
  `program->object_symbols[object]`; and a digest of the labels' entries, the calls' records and the temporaries.
- **What the first run lacked**, both found by the comparison on `sqlite3.c`: 1,054 tapes with a local's address where
  the shadow has a global's, a string literal's (a string's object is static without a declaration); and 14 roots
  whose target had the object's `const`.

## 2. What they cost where they sit

`scripts/job30.sh`: the specs in turn inside a run, a hold of the lock a run, seven runs (musl three). TSC ticks a
record T typed at reader time; in the tight loop, a record of the taken expressions in the first pass after the
pipeline (`--passes 1`):

| the whole front before T | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| T alone at reader time, `u3` | 67.5 | 85.1 | 137.0 |
| T alone at reader time, `w2` | 69.1 | 85.6 | 138.7 |
| T, C and X at reader time | 127.7 | 139.9 | 235.9 |
| C and X in place (the difference) | 58.7 | 54.4 | 97.2 |
| the tight loop's first pass: T; T and C; the three | 62.9; 86.9; 106.9 | 60.0; 81.6; 99.8 | 61.7; 82.8; 104.5 |
| C and X there | 44.0 | 39.8 | 42.8 |
| in place over the tight loop: T; C and X; the three | 1.10; 1.33; 1.19 | 1.43; 1.36; 1.40 | 2.25; 2.27; 2.26 |
| the three in place, as cycles a node | 212.0 | 262.6 | 414.1 |
| reader time's milliseconds: T alone; the three | 5.67; 10.48 | 2.07; 3.38 | 9.10; 15.48 |

| the lean front before T | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| T alone at reader time, `u3`; `w2` | 91.7; 93.8 | 103.6; 105.0 | 164.7; 170.3 |
| T, C and X at reader time | 152.8 | 160.7 | 264.4 |
| C and X in place | 59.0 | 55.7 | 94.0 |

- **Cycles a node** are the ticks a record by the same runs' tight loop: its three sweeps' cycles a taken node over
  their ticks a record (177.4 over 106.9 on `sqlite3.c`).
- **On `sqlite3.c` the three in place are at a body's expressions a run.** The design's "Where the machine runs" has
  174.9 cycles a node for the three sweeps in the tight loop, 216.5 with a body's expressions a run, and 199.3 there
  for T and the one sweep, which step 2's sum took (91 cycles a body token). Reader time runs a chunk's expressions a
  run, with the walk's code between two runs, and reads 212.
- **C and X lose more of their tight loop than T does there** (1.33 against 1.10), and the sum of the three is what
  the position predicted.
- **The lean front's rows carry the shadow's own cost** in both lines: it finds a root's operand's record by a search
  of the front's places, inside the timed run. The difference is the same 59.
- **Lua and musl:** an expression every 21 and every 49 acting tokens. A chunk holds few, and the three sweeps' code
  and tables leave the caches between chunks, as T's did.

## 3. The shadow's own sweeps, and a compile

The machine's own columns changed three files of the sweeps (`c_check_node_machine.c`, `_contexts.c`, `_expand.c`):
C and X read `machine->object_count`, `declaration_bits` and `object_symbols` where they read the program's, and T's
`node_machine_symbolled` reads the column without asking where it comes from. The shadow's own sweeps after the
pipeline, no front, `u3` against `w2`, a taken node (seven passes on `sqlite3.c` and Lua, one on musl; medians of
seven runs, musl's of three):

| | T | T and C | the three |
| --- | --- | --- | --- |
| `sqlite3.c`: cycles, `u3`, `w2` | 89.4, 90.6 | 133.9, 135.1 | 173.3, 175.5 |
| instructions | 338.38, 337.51 | 509.83, 509.27 | 598.30, 597.76 |
| Lua: cycles | 80.1, 80.5 | 116.7, 118.3 | 145.0, 147.4 |
| instructions | 429.90, 428.82 | 603.01, 602.31 | 687.80, 687.10 |
| musl: cycles | 122.6, 122.0 | 158.3, 158.2 | 192.6, 192.9 |
| instructions | 384.17, 383.20 | 557.65, 557.18 | 649.10, 648.63 |

- **Fewer instructions:** the three sweeps retire 0.54, 0.70 and 0.47 fewer a node, T 0.87, 1.08 and 0.97 fewer (its
  test of where a callee's symbol comes from is gone).
- **More cycles as built:** 1.3% on `sqlite3.c` (ranges 172.1 to 174.1 and 173.5 to 177.5), 1.7% on Lua, 0.2% on musl.
  A second seven runs of each (`scripts/job32.sh`, suffix `v`) read 173.3 and 175.6, and 145.0 and 146.8.

What moved, on `sqlite3.c` (`scripts/job31.sh`, `job32.sh`: `sweeps-events.sh`, 40 passes, no front, six processes
each; the machine's functions together, millions a process; `results/9700x/sweeps-events-plain-u3-w2-six.txt`):

| | `u3` | `w2` | |
| --- | ---: | ---: | ---: |
| cycles | 4,026.1 | 4,094.8 | +1.7% |
| mispredicted branches | 37.79 | 38.03 | +0.6% |
| instruction cache misses | 48.15 | 49.14 | +2.1% |
| op cache misses | 48.10 | 48.36 | +0.5% |
| store-to-load interference | 14.25 | 20.52 | +44% |

The interference is spread over T, its rule and C; in C its largest place is the test of a record's state after the
sweep's own clearing of the states (`scripts/job33.sh`, `results/9700x/{u3,w2}/sa-plain-*`), the same instruction in
both builds.

**The sweeps' cycles follow where their frames fall on the stack** (the interference was not counted by place: that
it is the event there is a reading). The machine's structure is a local of the census's
function, and the sweeps' frames are below it, at a distance the build fixes. `u4` and `w4` are `u3` and `w2` with
`patches/phase.patch`: `BUSTER_STACK_PHASE=N` moves the sweeps' frames down by N bytes at run time (an `alloca` in
the timing function; not the pull request's). The three sweeps' cycles a taken node on `sqlite3.c`, seven passes, at
N from 0 to 3,968 in steps of 128, the builds in turn (`scripts/job34.sh`, `results/9700x/phase-a-u4-w4.txt`):

| over the 32 places | T | T and C | the three |
| --- | --- | --- | --- |
| `u4`: least, median, greatest | 89.0, 90.0, 95.8 | 133.8, 134.9, 145.0 | 172.8, 174.6, 182.4 |
| `w4`: least, median, greatest | 89.5, 90.6, 96.2 | 133.9, 135.3, 153.9 | 174.5, 175.9, 189.1 |

- **Either build moves by more than the two differ.** The baseline's three sweeps read from 172.8 to 182.4 (5.6%) by
  the place alone, and this build's from 174.5 to 189.1 (8.4%); T and C from 133.8 to 145.0 and to 153.9. About a
  third of the places are slow in the baseline (13 of 32 over 176) and a quarter in this build.
- **At their best places the two are 1.0% apart**, and it is X's: T 89.0 and 89.5, C 44.8 and 44.4, X 39.0 and 40.6.
  X retires the same instructions (88.5 a node). The Release build's parts put `node_machine_contexts` and
  `node_machine_expand` beside T's functions now, 4.5 MB from where they were (`results/9700x/addresses-u3-w2.txt`),
  and X's op cache misses are 6% up.
- **Every earlier figure of these sweeps carries this.** A build's figure is one place of the 32; the design's "about
  3% is the placement's" has it. A comparison of two builds of the machine needs the places swept, or the structure
  off the stack.
- **`w3` settles nothing** (`patches/w3.patch`: `w2` with 4,072 bytes of padding after the structure's new fields, so
  that it is a page larger than `u3`'s). It reads as `w2` (174.6 and 147.0; interference 20.6 M): the padding is past
  the fields the sweeps read, so every distance that matters is `w2`'s. Kept as the trap it was.

`-c sqlite3.c` as whole processes, 21 runs a build from three fresh copies of each executable
(`results/9700x/ab-copies-u3-w2-1`, `-2`; `w1`'s are `ab-copies-u3-w1-*`):

| | wall ms, `u3` | `w2` | against `u3` (over copies) | instructions, M |
| --- | ---: | ---: | --- | --- |
| first | 123.354 | 122.780 | -0.47% (-0.55% to -0.29%) | 1,363.464, 1,363.464 |
| second | 123.064 | 122.882 | -0.15% (-0.62% to +0.15%) | 1,363.464, 1,363.464 |
| `w1`, first | 123.393 | 123.212 | -0.15% (-0.44% to +0.06%) | 1,363.464, 1,363.464 |
| `w1`, second | 123.019 | 123.051 | +0.03% (-0.55% to +0.16%) | 1,363.464, 1,363.464 |

## 4. The fact words' kernels (buster#2850)

This change moves that session's code too: its kernel's functions are 0x3260 bytes further on in `w2` (201 lines of 64
bytes and 32 bytes: the other half of their lines), and its slow path is T's rule. The same runs as the earlier record's
section 6 (`scripts/facts.sh`, `--passes 5`, the labels in turn, a hold a run; `scripts/job30.sh`, runs 13 to 17,
stopped after five rounds for the nightly backlog on the host). Cycles a taken leaf or lookup, `u3` against `w2`,
medians of five (`results/9700x/facts-u3-w2.txt`):

| | whole | lean | loads |
| --- | ---: | ---: | ---: |
| `sqlite3.c`, a body a window | 23.01, 23.01 (+0.0%) | 20.73, 20.41 (-1.5%) | 15.38, 14.95 (-2.8%) |
| Lua | 17.67, 17.61 (-0.3%) | 15.64, 17.03 (+8.9%) | 10.87, 11.84 (+8.9%) |
| musl | 15.77, 15.74 (-0.2%) | 13.91, 14.33 (+3.0%) | 8.81, 9.19 (+4.3%) |
| `sqlite3.c`, packed to 384 | 18.99, 18.72 (-1.4%) | 16.82, 16.49 (-2.0%) | 11.15, 11.18 (+0.3%) |
| Lua | 14.90, 14.86 (-0.3%) | 13.48, 13.42 (-0.4%) | 8.25, 8.45 (+2.4%) |
| musl | 14.65, 14.55 (-0.7%) | 12.97, 12.95 (-0.2%) | 7.85, 7.91 (+0.8%) |
| `sqlite3.c`, packed to 4,096 | 19.26, 18.34 (-4.8%) | | |
| Lua | 15.92, 15.74 (-1.1%) | | |
| musl | 14.82, 14.72 (-0.7%) | | |

- **The same work:** the instructions a taken leaf or lookup are within 0.05 on the 21 rows (the kernel's rare path is
  T's rule, which changed), and every record is T's in all 210 runs.
- **Fifteen rows are within 1.5% or faster,** `sqlite3.c`'s widest windows by 4.8%.
- **The lean leaves' loop moved the other way by corpus.** With a body a window the lean and the loads' rows share
  `node_facts_leaves_lean`: a leaf costs 7.76 and 9.96 cycles on Lua, 5.69 and 6.43 on musl, and 7.19 and 5.44 on
  `sqlite3.c`. Every run of one build is apart from every run of the other on Lua's two rows.
- **On Lua it is the op cache** (`scripts/job35.sh`, 160 passes, two processes each,
  `results/9700x/facts-annotate-lua-lean-u3-w2.txt`): the loop misses it 0.34 and 0.30 M times by `u3` and 4.82 and
  4.59 M by `w2`, with fewer instruction cache misses (0.94 and 0.93 M, then 0.58 and 0.56 M). The loop is 173 bytes; it
  starts 48 bytes into a line in `u3` and 16 in `w2`.
- **This is the earlier record's section 6 again:** the same code at another place, a loop that thousands of windows a
  pass enter. Nothing in that kernel is changed here.

## 5. Faults

`scripts/mutate_sweeps.py` puts one fault at a time into the reader-time path (twelve in
`c_check_node_machine_reader.c`, one in the census's comparison); `scripts/mutations.sh` builds each (cloud, Develop),
runs the census's part of `test-checker` and the comparison on `sqlite3.c` and Lua (`results/cloud/mutations.txt`).
The tests show all 13:

| fault | the tests' failures | `sqlite3.c`, of 50,373 compared | Lua, of 10,524 |
| --- | ---: | --- | --- |
| 1. an initialization's root has a target though its conversion is empty | 3 | 128 roots | 162 roots |
| 2. an initialization's target keeps the object's qualifiers | 2 | 14 roots | 0 |
| 3. an initialization's root has no object | 3 | 3,842 roots | 1,709 roots |
| 4. a string's object has nothing in its symbol's place | 2 | 1,054 tapes | 483 tapes |
| 5. an object with a static declaration has nothing in its symbol's place | 4 | 12,910 tapes | 3,671 tapes, 1 of T's records |
| 6. the root is evaluated as discarded | 2 | 3,372 tapes, 6 refusals | 701 tapes, 1 refusal |
| 7. a tape is kept an entry short | 3 | 50,095 tapes | 10,145 tapes |
| 8. the kept classes are the entries' kinds | 3 | 50,077 tapes | 10,145 tapes |
| 9. C and X run on an expression T refused | 2 | 0 | 0 |
| 10. no root is marked as swept | 3 | nothing compared | nothing compared |
| 11. every root gets a target of its wrapper's type | 1 | 1,054 roots | 165 roots |
| 12. a global's entry is compared without the patch | 3 | 1,988 tapes | 611 tapes |
| 13. a chunk's new strings are marked a chunk late | 2 | 0 | 0 |

- **Faults 1 and 11 needed a fixture line each** before the tests showed them: a conversion that is empty between two
  types (a pointer to a pointer to `const`), and a `for` statement, whose condition's wrapper has a type that is not
  its value's (under `-Wall` the census refuses a `for` statement's expressions, so the fixture runs once more without
  warnings).
- **Fault 9 and fault 13 show in the tests alone:** the corpora compare only what T took both times, and their strings
  are made before the first chunk that names one.
- **What no comparison reads:** the root's object. The lowering's pop has it and reader time derives the same, but C
  and X read it only for a root that is an `INITIALIZE`, and an initialization's root is its value.

## Checks

- `test-checker --seed 133` in its eight parts on the commit's sources (cloud, Develop): 842,449 checks, 0 failures
  on the native host; the census's part on a `BUSTER_HOST_ARCH=x86-64` build: 210,256 checks, 0 failures (where the
  front does not run and nothing is swept).
- `--front-sweeps` with the whole front and the lean one on the three corpora (cloud): no difference.

## Traps

- **A string's object has no declaration.** "Has a static declaration" stood for "has a symbol" in T's one use of it
  (a direct callee is a function). For C and X it missed every string literal.
- **The initializer's plan converts to the unqualified type.** The `INITIALIZE` node's own type is the object's, with
  its `const`.
- **Under `-Wall` the census refuses a `for` statement's expressions** (`-Wfor-loop-analysis`), so a fixture that
  runs with warnings compares none of them.
- **A fault that removes a variable's last use doesn't compile** (`-Werror`): write it so that the variable stays
  read.
- **The 9700X's nightly snapshots hold the lock for 20 minutes each**, several in a row after 01:00 UTC: a job that
  takes a hold a run waits its turn between them.

## Files

- `scripts/`: `build-label.sh`, `lock.sh`; `types-o2.sh` (the shadow on `sqlite3.c` and Lua, the specs in turn, a hold
  a run), `types-musl-o.sh`; `job29.sh` (`w1`) and `job30.sh` (`w2`); `ab-copies.sh`, `ab-copies-n.sh`; `facts.sh` and
  `facts-tables2.py` (the fact words' records' own); `symdiff.py`; `tables.py`; `trim.sh`; `job31.sh` to `job35.sh` with `sweeps-events.sh` and `sweeps-events.py` (the sweeps' events by symbol), `sweeps-annotate.sh` (by a function's instructions), `phase-o.sh` and `phase.py` (the stack's place), `facts-annotate-lua.sh`; the cloud's `shapes-local.sh`,
  `mutate_sweeps.py`, `mutations.sh`.
- `patches/`: `w1.patch`, `w2.patch` (each against main `be6515fba`); `pull-request.patch`, the commit as it waits
  for its branch (`git format-patch`, on #2867's head `ced595678`: `w2`'s sources with the docs, their bullet on
  the never-popped roots corrected), and `pull-request-body.md`, its description.
- `results/9700x/LABEL/`: each build's log, revision and checksum, and its runs
  `types-TAG-{sqlite3,lua,musl}-SUFFIX-N.txt` (suffix `s`: job29; `t`: job30; tags `types1` and `leantypes1`: T alone at
  reader time with the whole front and the lean one; `sweeps1` and `leansweeps1`: T, C and X there; `plain7`, `plain1`:
  no front, seven passes and one); `ab-copies-u3-w*-*/`; `symbols-u3-w2.txt`, `addresses-u3-w2.txt`; the holds and
  the builds' outputs.
- Section 3's: `patches/w3.patch`, `phase.patch`, `u3.patch` and `w4.patch`; `results/9700x/{u3,w2,w3}/se-plain-*`
  (job31: rounds 1 to 3; job32: 4 to 6) and `types-plain7-*-v-N.txt`, `{u3,w2}/sa-plain-*` (job33),
  `{u4,w4}/phase-a-BYTES.txt` (job34), `sweeps-events-plain-*.txt`, `phase-a-u4-w4.txt`.
- Section 4's: `results/9700x/{u3,w2}/facts-CORPUS[-SETTING]-N.txt` (runs 13 to 17), `facts-u3-w2.txt`,
  `{u3,w2}/fl-lean*` (job35), `facts-annotate-lua-lean-u3-w2.txt`.
- `results/cloud/mutations.txt`: the faults' runs. `results/tables.txt`, `results/tables-w1.txt`: `tables.py`'s output.
