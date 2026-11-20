### An update's rows on the window

[The record](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/x-update-rows-2850-2026-11-20).
Its [specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7030649938)
had five gates: exact (U1), how much (U2), cost (U3), that nothing else moves
(U4) and faults (U5).

The piece before listed every expression with an update: @@before_update_sqlite3@@ of the
@@expressions_sqlite3@@ `sqlite3.c` has that C takes on the window, @@before_update_lua@@ of Lua's @@expressions_lua@@ and
@@before_update_musl@@ of musl's @@expressions_musl@@. X writes an update two rows, by
`node_machine_update_plan`'s choices: the first after its destination's row
(`node_machine_update_first`: the old value's read, by name or through the
address its destination's entries left, and its CONVERT to the class the
operation is computed in), the last where its own record is
(`node_machine_update_last`: the step's CONST for `++` and `--`, the
operation, the result's CONVERT back and the store). This piece makes the
kinds and the classes of both on the window. No compile takes any of it.

**Each row where its record has free slots.** A record's row is two parts of
four slots, its own entries' and its conversion's (the piece before). An
update's two rows are shapes of the same table, in the slots its two records
don't use:

| row | where | entries |
| --- | --- | --- |
| its own, 87 to 90 | the update's record's own part | a CONST of the computation's class for `++` and `--`; the operation; a CONVERT back to the destination's class where the two differ; the store |
| a pointer's own, 91 to 94 | the same | its step's CONST for `++` and `--`; a NEG for `--` and `-=`; the PTR_ADD; the store |
| its first by name, 95 to 98, and 99 | its destination's record's two parts: a destination by name is not evaluated, and has no entry | the read, a local's or a global's, and a postfix update's DUP in the own part; the CONVERT in the conversion's |
| its first through an address, 100 and 101 | its destination's record's conversion's part: a record read for its address converts nothing | a DUP of the address, the LOAD, the CONVERT |
| a postfix update's first through an address, 102 to 111 | both parts of its destination's record, after the destination's own entries | six entries (the address kept in a temporary and read back, the old value loaded and kept in another, and the two read for the store and for the value) and the CONVERT |

A row's slots are fixed, with none where an entry is not written: the write's
compress drops an empty slot as it joins the parts. Two of the own row's
entries have a kind that is the record's to say, the operation's (by the
operator's code) and the store's (a local's, a global's or through its
address; a SET for a postfix update): each is a mark in the table, which the
write resolves with one masked move, as it does a class's source. A first
row's CONVERT is its part's last slot's in each row, so one slot of a
conversion's part reads the computation's class.

**What it lists.** A bool's update, whose result is tested (the conversion
back is the test's entries, which the four slots have no room for); and a
postfix update through an address whose destination's own entries leave the
six no room: an address and its offset's three, or a member's offset's two
with the CONVERT. @@on_update_sqlite3@@ of `sqlite3.c`'s expressions, @@on_update_lua@@ of Lua's and
@@on_update_musl@@ of musl's.

**A sweep and a loop of their own**, after the shapes' sweep and before the
rows' write (`node_rows_window_updates`), in a chunk where C's loop gave a
record the update's template. A sweep of masks, 64 records a step, compresses
the chunk's updates' numbers into a list: their places in the block as bytes,
one compress, the first 16 widened onto the list, and another turn for a
block with more. A loop over the list then writes each update's two rows'
shapes over what the shapes' sweep made of its record and of its
destination's, with their lengths; its store's kind and the class its
operation is computed in (T's conversion of its first operand, one read of
the update's line), where the write reads them; and, where its rows are not
made, the bit that lists its expression. Each choice is a bit and each shape
a sum or a table's byte, with no branch on an update's bits. The reads' and
the shapes' sweeps have no term of an update, and an update has no column of
its own.

**The terms that are no term here.** The plan asks more than this reads; for
what C on the window takes an update by, each is said by a byte the loop has
already (the comments there):

- **The stored class and facts**, the destination's type's, are the update's
  own record's and its destination's record's alike: an update's type is its
  destination's value's.
- **The class the operation is computed in** is its computation's: the plan's
  other case is a narrow class's, a `_BitInt`'s alone (C promotes the others),
  and C takes no update of a `_BitInt`.
- **A pointer's computation** is its own class's: no pointer's update has the
  CONVERT.
- **A destination by name** has an object, and one through its address
  converts nothing.
- **A division or a remainder by a power of two**, a shift or a mask in the
  plan: C on the window lists every compound division and remainder by an
  integer constant.

**How it came to its cost.** Builds on the 9700X, TSC ticks a record swept,
three readings each: the rows' sweeps with the update's rows on, and what
they read more than the piece before's executable in the same readings.

@@builds_table@@

@@builds_notes@@

**Measured.** The 9700X, CPU 2, Release, each run its own hold of the lock,
TSC ticks, @@readings@@ readings; in each reading one executable with the update's
rows on, off (an experiment's switch: an update's template lists its
expression, as the piece before had it), the piece before's executable
twice, then off and on again.

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
@@measured_table@@

**Against its gates.**

@@gates@@

**What stays a record at a time, and why.** The updates' loop, for @@updates_share_sqlite3@@ of
`sqlite3.c`'s records swept, @@updates_share_lua@@ of Lua's and @@updates_share_musl@@ of musl's. An update's
two records are apart by a distance only its own record has; its
computation's class is a load by its line's type's number; and its shapes
are bytes stored at the two records. As masks in the shapes' sweep (the
fourth build), an update's terms are every block's, for one record in some
ninety: @@vector_note@@

**What is next:** the branches' rows (the states, the senses and the
labels), then the entries' values.

