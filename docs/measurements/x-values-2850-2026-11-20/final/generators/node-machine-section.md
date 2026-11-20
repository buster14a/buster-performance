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
@@census_entries@@ entries of the three corpora's and the compiler's own
source's, none wrong. Half the values are zero (@@census_nonzero@@ are not),
and a record has about half a value that is not (@@census_per_record@@). What
is no field of a line and no fixed number is a numbering, and nearly every
one is its first: a call's row is zero for @@census_calls_zero@@ of
@@census_calls@@ calls, an operator's own label for @@census_labels_zero@@ of
@@census_labels@@, and no expression of the four has two postfix updates
through an address. An expression with two or more of an evaluated call, an
operator with a label and such an update is about one in eighty:
@@census_numbered@@.

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
@@builds_readings@@ readings each: the rows' sweeps with the values, and the
values' own part of them, a chunk's first run and its second. The piece
before's executable read @@builds_base_sqlite3@@ on `sqlite3.c` and
@@builds_base_lua@@ on Lua beside the last of them.

@@builds_table@@

@@builds_notes@@

**Measured.** The 9700X, CPU 2, Release, each run its own hold of the lock,
TSC ticks, @@readings@@ readings; in each reading one executable with the
values on, off (an experiment's switch: no record's value's column, no list,
loop or numbering, and no value compared), the piece before's executable
twice, then off and on again.

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
@@measured_table@@

**Against its gates.**

@@gates@@

**What stays a record at a time, and why.**

@@scalar@@

**What is next:** `&&` and `||` as values, `?:` and a comma, in C and in X on
the window together (C lists them still); then a taken expression's
references and events, and the splice and the summary node, #2524's step 2.
