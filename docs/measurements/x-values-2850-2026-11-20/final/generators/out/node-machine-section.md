### The entries' values on the window

[The record](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/x-values-2850-2026-11-20).
Its [specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7043553775)
had five gates: exact (V1), how much (V2), cost (V3), that nothing else moves
(V4) and faults (V5). The cost gate is refuted as it was specified.

An entry of X's tape is a kind, a class and a value (`node_machine_expand`'s
three columns), and the three pieces before made the first two on the
window. This piece makes the third: a quadword an entry, a stream beside the
kinds' and the classes'. With it a tape the rows make is whole, and it is
compared with X's on T's columns entry by entry, its value too. No compile
takes any of it.

**What a value is** (`node_machine_own`, `node_machine_address`,
`node_machine_fold_conversion`, `node_machine_update_first` and `_last`,
`node_machine_branch_hook`, `node_machine_call_own`):

- an object's number, for a LOCAL, a GLOBAL and their addresses; a store's
  and an update's by name are their destination's. At reader time a global's
  entry holds its object, which stands for its symbol until a splice patches
  it;
- an integer constant's bits, masked to its class's width and extended by
  its sign; a folded one's by its own class and then its target's, and
  whether it is not zero for a bool's; a floating one's as a float's or a
  double's;
- a member's offset in bytes and its sum's 1; an address constant's offset
  and its sum's 1;
- a pointer's stride, its sum's, its subscript's and its update's;
- an update's step: 1, or one's bits of a floating class;
- a branch's label: the control's own, or the label of the operator that
  owns the tested value (an `&&` branched where true or an `||` where false,
  for its first operand), its preorder number among the expression's
  operators with a label;
- a call's row, its preorder number among the expression's evaluated calls;
- a postfix update through an address's two temporaries, numbered in the
  order their first rows are written;
- and zero for every other entry: an operation's, a conversion's, a test's,
  a discard's, and an access's (a vector's bytes, and C takes no vector's
  access).

**What the count before the specification found.** A line a record of each
expression the rows take, with its row's entries as the reference's tape has
them, and a candidate rule for each value run over the lines:
796,051 entries of the three corpora's and the compiler's own
source's, none wrong. Half the values are zero (50.59%, 54.95%, 52.65% and 50.59% are not),
and a record has about half a value that is not (0.568, 0.485, 0.515 and 0.628). What
is no field of a line and no fixed number is a numbering, and nearly every
one is its first: a call's row is zero for 30,216 of
31,842 calls, an operator's own label for 1,962 of
2,103, and no expression of the four has two postfix updates
through an address. An expression with two or more of an evaluated call, an
operator with a label and such an update is about one in eighty:
474 (0.97%) of `sqlite3.c`'s, 163 (1.65%) of Lua's, 635 (1.61%) of musl's and 479 (1.21%) of the compiler's own source's.

**The stream starts as zeros and its sums' ones.** After the rows' write,
which gives each row its place: 64 entries a step, a compare of their kinds
with PTR_ADD's and eight masked stores of a zero or a one. A member's
offset's sum and an address constant's have that 1, which no loop then
writes; a pointer's stride is written over its own.

**Two columns hold what a loop would read of a line.** A record's line is 64
bytes, and the first build's loops read one a record, a line of the cache a
value. The tests' sweep loads every record's line for its bytes already, so
it stores a quadword a record too, the record's value (`window_x_values`):
its object's number where it has one, else its payload. The rows' reads'
loop, which reads a member's line for its offset, leaves the offset in bytes
in that place. And C's loop, which asks a type's row for a pointer's stride
to choose its template, keeps the stride it asked for (`window_c_strides`).
The loops below read these two columns and write the stream.

**One sweep of masks makes the lists**, 64 records a step over each record's
own shape, once the updates' and the branches' loops are done. A byte of a
table by the shape (`NodeRowsTables.value_owns`) has a bit a list, and a list
is the block's records' numbers under its bit, compressed. A constant's list
is by its class and its fold too: an integer's is the constants', a floating
one's and one folded to bool the rest's.

| list | the value | where in its row |
| --- | --- | --- |
| a name's read, an address constant, an update's read by name, a member's offset | its record's value | its first entry |
| a store by name | its first operand's record's value | its one entry |
| an integer constant, plain or folded | its record's value, extended from its own class's width and then its entry's | its first |
| a pointer's sum, subscript and update | its stride; and a 1 for an update's step | the PTR_ADD's place, its shape's; its first |
| a tested value the control owns | the control's label | its last |
| the rest: a floating constant, one folded to bool, an address constant's offset after its object's address | by its shape, from its line | |
| a record with a number of its expression's that is no first such record of it | the numbering's, below | |

The fifth list is the branches' loop's, made as it gives a value its test,
and the chunk's updates are the updates' loop's list already: a loop over
them writes each one's store by name's object, its step (one of the class it
is computed in) and, of a postfix update through an address, its
destination's two temporaries, the expression's first pair.

**A loop a list:** each value a load or two and a store at its row's place
(the entries before its eight records' and before it among them, two
columns' loads), none waiting for another. Each loop's step is in one copy
(`unroll(disable)`): a list is some tens of records a chunk.

**The numbers of an expression.** A call's row, an operator's own label and
a postfix update's temporaries are numbers in their expression, and its
first of each is what the loops wrote: a zero, and the pair 0 and 1. The
sweep finds every record with such a value that is no first one of its
expression by one subtraction a block, from two masks: those records (a bit
of the table's byte), and the expressions' operands' last records, which the
reader marks in the senses' column as it registers an expression. A borrow
from an expression's first record stops at its first marked bit, the one bit
that then differs; the other marked bits are the list. The expression that
goes on from the block before with a marked record there has its first in
this block on the list too, a word of state a block. Each listed record's
expression is then numbered once, a record at a time, by the reference's own
rules (`node_rows_window_number`): its calls' rows, its labels down a walk
from its last operator with a label, and its temporaries.

**How it came to its cost.** Builds on the 9700X, TSC ticks a record swept,
two or three readings each: the rows' sweeps with the values, and the
values' own part of them, a chunk's first run and its second. The piece
before's executable read 5.07 (5.03 to 5.21) on `sqlite3.c` and
6.43 (6.32 to 6.68) on Lua beside the last of them.

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

**Measured.** The 9700X, CPU 2, Release, each run its own hold of the lock,
TSC ticks, seven readings; in each reading one executable with the
values on, off (an experiment's switch: no record's value's column, no list,
loop or numbering, and no value compared), the piece before's executable
twice, then off and on again.

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

**Against its gates.**

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

**What stays a record at a time, and why.**

- **The lists' loops:** 0.48, 0.36 and 0.29 listed records a record swept. A value is a load from a column and a store at
  its row's place, which is the sum of two columns' bytes for its record: the places are no register's eight in a
  row, and a scatter is 88 micro-operations on Zen 5, one every 17 cycles ("SIMD and Zen 5" in the coding style).
  The vector makes the lists. The specification named two things to measure against the loops if they read over
  their gate. The first is in the code since the second build: a column of each record's one value (the rows'
  sweeps read 9.51 and 11.84 in the first build and 8.25 and 11.01 in the fourth). The second is not: the values
  written by slots as the kinds are, eight quadwords a register through a compress. What the counters say of the
  loops is that their work is not the cost a chunk's first run pays: the sweep executes the same instructions in
  both runs, and takes 1,898 to 2,284 cycles a chunk the first and 1,262 to 1,323 the second on `sqlite3.c`.
  [#@@followup@@](https://github.com/buster14a/buster/issues/@@followup@@) has that cold start, for every sweep of the
  window, and the by-slots build as what to measure there.
- **The numbering:** 0.97%, 1.65% and 1.61% of the tapes. A call's row and a label are preorder numbers in the
  expression's tree, and the reference numbers them a record at a time too. The sweep finds those expressions with
  no test an expression: one subtraction a block.

**What is next:** `&&` and `||` as values, `?:` and a comma, in C and in X on
the window together (C lists them still); then a taken expression's
references and events, and the splice and the summary node, #2524's step 2.
