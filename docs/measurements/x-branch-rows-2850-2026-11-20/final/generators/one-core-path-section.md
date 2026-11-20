## The branches' rows on the window

[The record](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/x-branch-rows-2850-2026-11-20).
`measure-node-machine --shadow --window-rows`
([the guide](commands/lowering.md#xs-rows-on-the-window-2850)).

X's rows on the window listed every expression with an operator evaluated as
branches: @@before_branches_sqlite3@@ of `sqlite3.c`'s @@expressions_sqlite3@@ that C takes there. X
writes such an operator no entry, and each value it tests its test and a
branch by its sense after the value's row. This piece makes those as the
tested value's conversion's part's row (four rows of the rows' table), in a
chunk where a condition branches: the update's sweep compresses the chunk's
`!`, `&&` and `||` evaluated as branches into a second list, and a loop down
that list gives each operand its sense and each tested value its shape. No
compile takes any of it. [The node machine's
page](node-machine.md#the-branches-rows-on-the-window) has it whole: the
rows, the builds, the probes and the faults. [Its
specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7037879405)
had five gates.

### What it measured

The 9700X, CPU 2, under the lock, Release, TSC ticks, @@readings@@ readings; in each
one executable with the branches' rows on and off (an experiment's switch),
and the piece before's executable between them:

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
@@short_table@@

### Against its gates

@@short_gates@@

### What stays a record at a time, and why

The branches' loop, a turn for each `!`, `&&` and `||` evaluated as branches:
@@turns_share_sqlite3@@ of `sqlite3.c`'s records swept, @@turns_share_lua@@ of Lua's and @@turns_share_musl@@ of
musl's. An operator's first operand is at a distance only its own record
has, and an operand's sense is its consumer's, a turn after it. @@vector_note@@

### What it means

@@means@@
