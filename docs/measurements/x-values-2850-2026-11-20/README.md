# The entries' values on the window (buster#2850's step 2), 2026-11-20

The evidence for the piece that makes, on the front's window, the value of each entry the node machine's X sweep
writes (`node_machine_expand`'s third column: an entry is a kind, a class and a value). The pieces before it made the
kinds and the classes: [x-rows-on-the-window-2850-2026-11-19](../x-rows-on-the-window-2850-2026-11-19/),
[x-update-rows-2850-2026-11-20](../x-update-rows-2850-2026-11-20/) and
[x-branch-rows-2850-2026-11-20](../x-branch-rows-2850-2026-11-20/). The census of X's rows that counted each
value's source by X's code is [x-rows-census-2850-2026-11-19](../x-rows-census-2850-2026-11-19/).

## 1. Before the specification: a census of the values (`before/`)

**What was run.** An experiment's patch (`before/census-values.patch`, on
[buster14a/buster#3191](https://github.com/buster14a/buster/pull/3191)'s head `5ee22d6a5`, the branches' rows' code)
prints, with `BUSTER_CENSUS_V=1`, a line for each record of each expression the rows take on the window
(`measure-node-machine --shadow --passes 0 --window-rows`): what the window has of the record (its operator, its
template, its two shapes, its operands' distances, its subtree's records, its line's object, payload, standing,
exponent and member's offset, its classes and facts, its first operand's conversion's type's stride and its own
type's) and its row's entries as the reference's tape has them at reader time, a kind, a class and a value each
(`xv` lines; one `xh` line has the operators' and the templates' numbers). On the 9700X (`before/census-run.sh`: the
working tree's incremental Develop build and `test-checker --seed 133 --part 5/8`, `dev-census.log`; then the shadow
on `sqlite3.c`, Lua and musl, CPU 2, each run its own hold of the lock, `census-corpora.log` and
`corpus-CORPUS.txt`, the runs' outputs without the census's lines; and on the compiler's own source, the working
tree's `main.c` with the patch in it, `before/census-own.sh`). Counts, no times. The lines are `CORPUS.tsv.xz`
(`lines.txt`: 268,942, 61,509, 188,250 and 205,869 records' lines and a header each).

**The simulation** (`before/simulate-values.py`, its outputs `sim-CORPUS.txt`, and `sim-three.txt` for the three C corpora together): a candidate rule
for each entry's value, a function of the window's fields alone, run over the lines and compared with the
reference's value. Every rule gives every entry's value on the four corpora but a floating constant's, which the
simulation does not compute (its significand and exponent, converted to its class's bits): 796,051 entries, none
wrong. `before/census-table.py` makes the table (`before/table.md`), and `before/census-totals.py` the totals the
list below has:

| | `sqlite3.c` | Lua | musl | the compiler's own source |
| --- | ---: | ---: | ---: | ---: |
| expressions the rows take; their records | 49,073; 268,942 | 9,888; 61,509 | 39,495; 188,250 | 39,456; 205,869 |
| their entries; those whose value is not zero | 302,047; 152,808 (50.59%) | 54,341; 29,859 (54.95%) | 184,146; 96,945 (52.65%) | 255,517; 129,265 (50.59%) |
| values that are not zero, a record | 0.568 | 0.485 | 0.515 | 0.628 |
| **by its source: entries; of them not zero** | | | | |
| its record's object: a name's read, an address constant's, an update's read by name | 67,111; 67,111 | 14,532; 14,532 | 58,111; 58,111 | 62,499; 62,499 |
| its destination's record's object: a store or an update by name | 10,881; 10,881 | 1,649; 1,649 | 9,641; 9,641 | 7,130; 7,130 |
| an integer constant's bits, by its class | 22,277; 10,553 | 4,324; 3,030 | 11,755; 9,123 | 5,314; 4,147 |
| a folded constant's, by its target's class; to bool | 10,889; 4,838 | 1,194; 845 | 6,481; 4,853 | 21,446; 11,358 |
| a member's offset in bytes | 21,511; 21,511 | 3,431; 3,431 | 2,822; 2,822 | 13,584; 13,584 |
| the 1 of an offset's sum (a member's, an address constant's) | 22,272; 22,272 | 3,485; 3,485 | 3,167; 3,167 | 14,545; 14,545 |
| an address constant's offset | 959; 761 | 525; 54 | 719; 345 | 1,200; 961 |
| a pointer's stride (a sum's, a subscript's) | 6,184; 6,184 | 923; 923 | 3,546; 3,546 | 8,349; 8,349 |
| a pointer's update's stride; its step's 1 | 768; 768 | 588; 588 | 1,070; 1,070 | 104; 104 |
| an update's step: one, of the class it is computed in | 1,633; 1,633 | 251; 251 | 932; 932 | 190; 190 |
| a floating constant's bits | 83; 46 | 10; 9 | 956; 898 | 31; 31 |
| a branch's label: the control's | 3,969; 3,969 | 352; 352 | 1,434; 1,434 | 5,589; 5,589 |
| a branch's label: an operator's own | 891; 58 | 76; 5 | 380; 12 | 756; 66 |
| a call's row | 12,501; 398 | 3,710; 180 | 6,957; 611 | 8,674; 437 |
| a temporary's number | 1,825; 1,825 | 525; 525 | 380; 380 | 275; 275 |
| an access's value (a vector's bytes, else 0) | 29,526; 0 | 4,850; 0 | 10,090; 0 | 22,355; 0 |
| a test's zero | 15,077; 0 | 1,820; 0 | 8,681; 0 | 14,420; 0 |
| none: an operation's, a conversion's, a discard's | 73,690; 0 | 12,096; 0 | 57,024; 0 | 69,056; 0 |
| **expressions with two or more of an evaluated call, a labeled operator and a postfix update through an address** | 474 (0.97%) | 163 (1.65%) | 635 (1.61%) | 479 (1.21%) |

What the rules are, as the simulation has them:

- **A record's object** is its line's (`NodeFactsRecord.object`). At reader time a global's entry holds its object,
  which stands for its symbol (the machine's `object_symbols` has the object there): no record of the four corpora
  has another symbol than its object.
- **A store or an update by name** has its destination's record's object, its first operand's; the store's own
  record has it too for 3,137 of the 29,301.
- **An integer constant's CONST** is its payload masked to its class's width and extended from it by the class's
  signedness; a folded one's the same by its target's class, and whether it is not zero for a bool's.
- **A member's offset** is its line's, in bits, over eight; an address constant's offset is its payload.
- **A stride** is its first operand's conversion's type's (`check_action_pointer_stride`): a pointer's update's own
  type's is the same for every one of the 1,492 (`before/check-strides.py`, `check-strides.txt` and
  `check-strides-own.txt`).
- **An update's step** is 1, or one's bits of a floating class (four of the 4,044 are a double's).
- **A branch's label** is the control's own (`BUSTER_NODE_MACHINE_CONTROL_LABEL`) or the label of the operator that
  owns the tested value (an `&&` branched where true, an `||` where false: its first operand's), which is its
  preorder number among the expression's labeled operators: zero for 1,962 of the 2,103.
- **A call's row** is its preorder number among the expression's evaluated calls: zero for 30,216 of the 31,842.
- **A temporary's number** is the pair 0 and 1 in every postfix update through an address: no expression of the
  four corpora has two such updates (`check-strides.txt`'s `kept` lines have each row's pattern).
- **An access's value** is zero for every LOAD, STORE and SET: none is a vector's.

So an expression's values are fields of its records' lines and fixed numbers, but for the expressions with two or
more of an evaluated call, a labeled operator and a postfix update through an address, 0.97%, 1.65%, 1.61% and
1.21% of them, whose rows, labels and temporaries are numbered.

## 2. The builds (`builds/`)

**What was run.** Each build is a patch on [buster14a/buster#3191](https://github.com/buster14a/buster/pull/3191)'s
head `5ee22d6a5` (`builds/9700x/LABEL/LABEL.patch`, `revision.txt`, `build.log`), built Release on the 9700X by
`builds/build-label.sh` and read by `builds/turns.sh`: `measure-node-machine --shadow --passes 0 --window-rows` on
`sqlite3.c` and Lua, CPU 2, each run its own hold of the lock, two or three readings (`on-CORPUS-N.txt`), with the
branches' piece's executable beside it (`xb6/base-CORPUS-N.txt`). Each job wrote the base's readings under one name,
so the ones in the record are those taken beside the last build (`xv6`): the base's beside the earlier builds are
gone, and the table has each build's own readings. `builds/xv-table.py` makes `builds/xv-table.txt` from the runs.

| build | `sqlite3.c`, the rows' sweeps with the values | the values' part: a first run; a second | Lua, the rows' sweeps | the values' part | the values' sweep's code, bytes |
| --- | ---: | ---: | ---: | ---: | ---: |
| first: seven lists, each loop reading its records' lines, and a pointer's type's row for its stride; an expression's marked records counted in its part | 9.51 (9.45 to 9.62) | 3.30; 2.13 | 11.84 (11.76 to 12.49) | 4.19; 1.89 | 4,290 |
| a record's value and a pointer's stride as two columns; the tested values' list from the branches' loop and the updates' from their own; an expression's later marked records by a subtraction a block; a member's offset, an update's step and its store's object written under a condition | 10.19 (10.09 to 10.63) | 4.04; 2.30 | 12.61 (12.61 to 13.00) | 5.42; 2.36 | 5,145 |
| those three written at a place chosen without a branch | 9.32 (9.24 to 9.39) | 4.06; 2.28 | 12.35 (12.34 to 12.36) | 5.56; 2.34 | 5,142 |
| the stream's start with its sums' ones, by the entries' kinds, and no list for the members; each loop's step in one copy, its columns' addresses loaded once; the numbering's expression from a column the reader writes, and its labels' walk over the operators' records alone | 8.25 (8.22 to 8.67) | 3.14; 1.86 | 11.01 (10.91 to 11.45) | 4.23; 1.89 | 3,537 |
| the fourth's with the columns' and the stream's lines asked for from the rows' write | 8.59 (8.48 to 8.87) | 3.11; 1.86 | 11.24 (11.16 to 11.45) | 4.24; 1.86 | 3,537 |
| the fifth's with the sweep compiled for size | 8.89 (8.82 to 8.97) | 3.43; 2.08 | 11.06 (11.03 to 11.13) | 4.20; 2.08 | 2,373 |

- **A value written where its record has one was a branch.** The second build's reads' loop left a member's
  offset in the record's value's place as `*value = member ? offset : *value`, and the updates' loop wrote an
  update's step and its store's object the same way. The compiler made each a store behind a branch on the
  record's kind, which no predictor learns: the reads read 2.65 to 2.76 ticks a record swept on `sqlite3.c` where the
  first build's read 1.67 to 1.76. The third build writes each at a place chosen by arithmetic, the record's own
  or one past the column's records that no one reads: 1.77 to 1.80.
- **The two columns and the lists moved read no better by themselves.** The third build's rows' sweeps read 9.32
  ticks a record swept on `sqlite3.c` for the first's 9.51, and 12.35 for 11.84 on Lua; its values' part more, 4.06 and
  5.56 for 3.30 and 4.19. Its stream started as zeros, with a list of the members that wrote each one's offset and its
  sum's 1, and its loops reached each column through the reader's state. The fourth starts the
  stream with the sums' ones by the entries' kinds, has a member's offset on the first list, and each loop's step
  in one copy (`unroll(disable)`): the values' part read 3.14 and 4.23, the rows' sweeps 8.25 and 11.01, and the
  sweep's code is 3,537 bytes for 5,142. The builds changed more than one thing at a time, and no reading is of the
  columns alone.
- **A chunk's first run pays a cold start, more than work a record.** A build that reads the processor's counters
  around the sweep (user mode, a chunk's average; `sqlite3.c` has 526 records a chunk and Lua 379): the sweep
  executes 4,313 to 4,429 instructions a chunk on `sqlite3.c` and 1,974 to 2,075 on Lua, the same in a chunk's two runs,
  in 1,898 to 2,284 cycles the first run and 1,262 to 1,323 the second (Lua: 1,795 to 2,316 and 931 to 961). The first run has
  18.9 to 22.7 mispredicted branches a chunk for the second's 10.6 to 12.0, 18.4 to 73.9 instruction-cache misses for
  2.7 to 27.4, and 631 to 1,594 cycles with the front end stalled for 231 to 364. No run of either corpus has more than
  0.1 TLB misses a chunk, data or instructions. The fourth build's ticks a chunk are nearly the same on the two
  (1,652 and 1,602) though `sqlite3.c`'s chunk has 39% more records. The rows' write, measured the same way,
  takes 835 to 843 cycles a chunk its first run and 683 to 686 its second on `sqlite3.c`.
- **Two builds that went after the cold start changed nothing.** Asking for the columns' and the stream's lines
  from the rows' write, the sweep before: the write read 1.19 and 1.79 for 0.92 and 1.50, and the values' part
  3.11 and 4.24 for 3.14 and 4.23. Compiling the sweep for size on top of that (2,373 bytes for 3,537): 3.43 and 4.20.
  Neither is in the code.

- **The builds between.** `xv1s` and `xv3s` are the first and the third with a clock's read around each loop of the
  sweep (`split-CORPUS-N.txt`): the reads cost more than the loops, and their totals are not the builds'. `xv5`'s
  `again-CORPUS-N.txt` are three more readings of the same executable.
- **The counters** (`builds/counters.py`, `builds/counters.txt`): `xv4p` is the fourth build and `xv7p` the code as
  the fault rounds found it, each with an experiment's patch that opens seven or eight counters with
  `perf_event_open` (user mode) and reads each before and after the sweep, summed for a chunk's first run and its
  second (`pmu-CORPUS-N.txt`; `xv7p` reads them around the rows' write too). The reads are instructions of the
  region themselves, more of them with eight counters than with seven. `LL-read-misses` and
  `stalled-cycles-backend` do not count on this processor and read zero.
- `builds/functions.txt`: the sizes of the rows' functions in each build's executable (`nm -S`).

## 3. Three counts for terms the first fault round found implied (`experiments/`)

Each is an edit of the tree in place, made by its script, never committed, a Develop build in the cloud container,
and the shadow on the three corpora (counts, no times).

- `object-kinds.py`, `object-kinds/`: the window's placed records by whether they have an object and what their
  constant's kind is. 590,493 placed records of the three corpora, 0 with an object and a constant that is no
  address's; and of the records each of the values' loops reads a value of, none has both either (the loops' counts
  are of a chunk's two runs). Four records of `sqlite3.c`'s first list have an object and no constant: members, whose
  value the reads' loop overwrites with the offset. So a record's value is its object's number where it has one,
  with no test of its constant's kind.
- `start-two-after.py`, `start-two-after/`: a block's first marked records with an expression's start two records
  after the end before it, beside the code's own. The two differ in 138, 12 and 206 blocks of the three corpora: a
  call with no argument right after a condition. The fixture has those lines now.
- `number-calls.py`, `number-calls/`: the numbering's calls by its expression's marked records: 5,408 calls on the
  three corpora and the fixtures, 0 for an expression with fewer than two. So the routine has no test for it.

## 4. The fault rounds (`faults/`)

**What was run.** `make-faults-values.py` makes a round's list (`faults-values-round1.py`: 352 faults on the code
`xvf1.patch` has, on main `3e6f78b67`): each fault alone, a Develop build and `test-checker --seed 133 --part 5/8`.
The first round ran from the list's two ends at once: on the 9700X from the first fault up
(`job-faults-values.sh`, `raw/round1-9700x.txt`, 269 verdicts) and in the cloud container's mutation trees from
the last down (`local-round.sh`; `raw/round1-cloud-*.txt`, 134 verdicts).
`join-round.py` joins them by name (`round1-joined.txt`): every fault has a verdict, 51 have two, and no two
differ. 311 caught, 41 survived.

As a survivor came up its change was made and its fault's build run against the changed code before the next round
(`checks/check2.txt` to `check6.txt`, in the cloud container, each on the tree as it was then: 55 caught; seconds-starts-two-on
survived a check and was caught by a later one, once the fixture had its line).

`make-faults-values2.py` makes the second round's list from the code as it is (`faults-values-round2.py`, 349
faults; `faults-values-round2.py.no-faults.txt` has the five left out and why). The second round ran the faults whose
text changed, the new ones and the first round's survivors (`round2-indices.txt`, 89 faults; each compiled alone
first, `syntax-check.sh`, `syntax-round2.txt`: 89 ok and one that left a variable unused, rewritten) on the
9700X, on the pull request's code (`xvf2.patch` on main `4acd0645e`; `round2.txt`): 89 caught, 0 survived. The
other faults' lines are the first round's, and the tests have every check they had then.

## 5. The probes (`probes/`)

`probe.py` runs each case as a file of its own through `measure-node-machine --shadow --window-rows --passes 0`
and prints a line a case. `cases15.py` to `cases19.py` are the values' (a constant's, an address's, a member's and a
stride's; a store's and an update's; a call's row; a branch's label; a temporary's number), and `cases20.py` what a
surviving fault's fixture line was probed with. The outputs on the pull request's code are in
`final/cloud-checks/probes/`: 4,313 of the values' and the 1,134 of the pieces before, every tape made the
reference's, in a value too.

## 6. The final readings, and the checks (`final/`)

**What was run.** `final/job-xv.sh`: a Release build of the pull request's code with an experiment's switch
(`final/9700x/xv8/xv8.patch` on main `4acd0645e`; `BUSTER_TESTS_SKIP=1` turns the values off: no record's
value's column, no list, loop or numbering, and no value compared) and one of main as it is (`xb7`, the piece
before's); seven readings on `sqlite3.c`, Lua and musl, CPU 2, each run its own hold of the lock: in each
reading the first with the values on, off, the piece before's twice, then off and on again.
`final/xv-final-table.py` makes `final/xv8-table.txt`.

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| expressions C takes on the window | 49,155 | 9,909 | 39,712 |
| their tapes made here, whole | 49,073 (99.83%) | 9,888 (99.79%) | 39,495 (99.45%) |
| tapes that differ from X's on T's columns, in a value too | 0 | 0 | 0 |
| listed for a value | 0 | 0 | 0 |
| their entries | 302,047 | 54,341 | 184,146 |
| records on a list, a record swept | 0.482 | 0.363 | 0.288 |
| expressions numbered | 474 (0.97% of the tapes) | 163 (1.65% of the tapes) | 635 (1.61% of the tapes) |
| **the rows' sweeps and the part, a record swept** | **8.50 (8.27 to 8.66)** | **11.09 (10.98 to 11.58)** | **21.26 (19.89 to 22.95)** |
| the piece before's executable, in the same readings | 5.05 | 6.41 | 11.29 |
| **more than the piece before's** | **+3.48 (+3.13 to +3.69)** | **+4.78 (+4.28 to +4.91)** | **+10.16 (+8.10 to +12.23)** |
| with the values off; on less off | 5.15; +3.38 | 6.94; +4.19 | 13.81; +7.63 |
| with the values off, more than the piece before's | +0.12 (-0.04 to +0.21) | +0.49 (+0.20 to +0.75) | +2.53 (+0.98 to +3.72) |
| the values' part | 3.20 | 4.11 | 7.48 |
| the reads; on less off | 1.83; +0.20 | 2.26; +0.17 | 4.77; +0.44 |
| the shapes | 0.60 | 1.05 | 2.38 |
| the updates' and the branches' lists and loops; on less off | 0.97; +0.01 | 1.12; +0.00 | 1.98; +0.01 |
| the rows; on less off | 0.95; +0.02 | 1.52; +0.02 | 3.12; +0.01 |
| an expression's part | 0.96 | 1.06 | 1.46 |
| a second run over the same chunk; the piece before's | 6.17; 4.05 | 6.17; 3.72 | 8.04; 4.83 |
| the values' part in it | 1.93 | 2.05 | 2.91 |
| the values' part, ticks a chunk: a first run; a second | 1,683; 1,015 | 1,556; 776 | 948; 369 |
| the records' bytes, which make a record's value; on less off | 9.33; +0.30 | 11.88; +0.26 | 23.36; +0.42 |
| C's loop, which keeps a stride; on less off | 3.37; +0.04 | 5.21; +0.05 | 9.03; +0.54 |
| a record of the taken expressions | 10.16 | 16.45 | 42.59 |
| X on T's columns, a record of theirs | 25.61 | 23.69 | 28.64 |
| records a chunk | 526 | 379 | 127 |

**Against the specification's gates.**

- **V1, exact: met.** No tape made differs from X's on T's columns in its number of entries, a kind, a class or a
  value, on the three corpora on the 9700X (49,073, 9,888 and 39,495 tapes), and no chunk's second run differs from its
  first. In the cloud container the same on the three and on the compiler's own source (39,473 tapes of its 40,215
  expressions, 98.15%), with the default warnings and with `-Wall -Wextra`. The values' fixture has a line a source of a
  value (1,057 tapes), the rows' 1,166, C's 1,479 and two units of one chunk 3 each: with one of the reference's answers
  changed for each tape the comparison counts every one, and with one of a chunk's first run's answers changed every
  chunk's second run differs. And 5,447 one-statement programs, each a file of its own: 4,313 written for the values (a
  constant of each class, plain and folded; an address constant; a member; a pointer's sum, subscript and update; a
  store and an update by name and through an address; calls nested and side by side; conditions whose operators own
  a label; postfix updates through an address), 1,476 of the 5,447 with an expression numbered, and the 1,134 of the pieces
  before.
- **V2, how much: met.** Every expression whose rows the piece before made has its tape whole: none is listed for a
  value on the three corpora or the compiler's own source (0.5% refutes). The numbered expressions are the count's: 474,
  163, 635 and 479.
- **V3, cost: refuted.** The rows' sweeps and the part read +3.48 ticks a record swept more than the piece before's
  executable on `sqlite3.c` (+3.13 to +3.69) and +4.78 on Lua (+4.28 to +4.91); 1.5 was asked and 2.5 refutes. On musl, which the gate
  did not name, +10.16 (+8.10 to +12.23): its chunks are a quarter the size. The values' own part is 3.20, 4.11 and 7.48 of it;
  by the switch, on less off, the reads, which leave a member's offset, read +0.20 and +0.17 more on the first two, and the
  rows' write +0.02 and +0.02. With the values off the same executable reads +0.12 and +0.49 more than the piece before's, its
  two clock's reads around the sweep among them. A chunk's
  second run reads the whole +2.14 and +2.46 more than the piece before's, the values' part 1.93 and 2.05: the work a
  record is over what was asked with its code and its tables at hand, and a first run adds a cold start a chunk to it
  (1,683 ticks a chunk for 1,015 on `sqlite3.c`, 1,556 for 776 on Lua).
- **V4, nothing else moves: met.** By the switch, on less off, on `sqlite3.c` and Lua: the kernel in place -0.02 and -0.09;
  the tests' loop +0.01 and +0.02, their expression's part -0.01 and +0.01, their sweep on T's records +0.05 and +0.18; C's targets +0.03
  and +0.00, its expression's part +0.01 and -0.01. The two sweeps the piece gives work to: the records' bytes, which make a
  record's value, +0.30 and +0.26 a record of the tests', at the gate's bound, and C's loop, which keeps a stride, +0.04 and +0.05
  (0.3 asked).
- **V5, faults: met.** Two rounds: each entry of the values' tables, each term of the sweep's masks and of the later
  records' arithmetic, each loop's load, shift and store, the two lists made before the sweep, the columns' makers, each
  term of the numbering, and the shadow's comparisons and their control, changed alone, a build and the fixture's
  tests a fault. The first round's 352 faults, run from the list's two ends at once (the 9700X and the cloud container:
  51 faults by both, with the same verdict each), left 41.
  - Eight were terms no program separates, and are out of the code: an address's range beside the two variants that
    are within it; a record's constant's kind beside its object (X's own test is the object's, and a count found no
    record of the three corpora with an object and a constant that is no address's); a fold beside a floating
    class and the reads' mask beside a fold (a folded constant is an integer's with a target the reads read); the
    expressions' ends in the subtraction (a borrow that runs on stops at the next expression's first marked record,
    which no start is); and the numbering's test for two marked records (a count of its calls found none with fewer).
  - Five change nothing a program reaches, and are no faults: an object's number sign-extended (it is a token's
    index and one); an update's step's class read from the operation after it, which is of the same class; a
    destination's shape taken through the kept rows' rest's, which are a conversion's part's; an expression's marked
    records taken from its second record on, its first being a leaf; and an owned record with any conversion's part
    taken for a tested value, which a numbered expression has none of.
  - Seven were the shadow's own comparisons, which no test could fail. The control now changes a value's lowest bit and
    its highest, a tape's first entry's and its last's, and a value beside a class; and one of a chunk's first run's
    answers in thirteen turns, so that the second run's comparison counts every chunk.
  - Fourteen were in the later records' arithmetic, where a superfluous record on the list numbered nothing and changed
    no answer: the list's records are counted and pinned now.
  - Six got a line in the fixture, each run against its fault's build before the next round: an expression with two
    calls beside one C leaves; an operator with no label between a tested value and its owner; a member past 4 GB;
    a constant before an entry of a narrower class; a listed expression with two calls; and a call with no
    argument right after a condition. And one comparison had slack: a call's holder is one whose subtree starts no
    later than its own, where the code asked no later than its record.
  The second round's 89 faults, every one whose text changed, the new ones and the first's survivors, on the code as
  it is, are all caught.

**The cloud container's checks** on the code's commit `c6f230d87` (`final/cloud-checks/`, `checks-rows.sh`,
`progress.txt`): a native Release build; the whole `test-checker` (8 of 8 parts with status 0); the shadow with
`--window-rows` and with `--window-contexts` on the three corpora and with `--window-rows` on the compiler's own
source, with the default warnings and with `-Wall -Wextra` (14 of 14 runs with status 0; `shadow/` has their rows' lines); the shadow's
other modes on `sqlite3.c` and Lua (22 of 22); the self-check, the self-parse, the call graph and the
ownership check; and the complete driver's lists, 5 of whose 6 items pass. The one that does not is the preprocessor's comparison
with clang: 45 of its 66 units differ, each by where the line markers place a token and by no token
(`complete-light-the-preprocessor-against-clang.txt`; each one's count is clang's), as they did on the piece
before's commit in this container (its record's `final/cloud-checks/`, the same 45 of 66). `final/pins.txt` has the
fixtures' pins (`final/pins.py`).

**The sanitizers** (`final/cloud-sanitizers/progress.txt`, `sanitizers-parts.sh`): the native memory, address and
thread rows, each a Release build, `test-checker`'s part 5 and, for memory and address, the shadow with
`--window-rows` on `sqlite3.c`, Lua and the compiler's own source: 12 of 12 steps with status 0, no report.

## 7. The generators (`final/generators/`)

`gen-docs.py` makes the design's two sections from their templates and this record's files (`values.json` has every
number it read or computed), `gen-readme.py` this file's sections 2 to 7, and `assemble.sh` copied the evidence
here.
