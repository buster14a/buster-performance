## An update's rows on the window

[The record](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/x-update-rows-2850-2026-11-20).
`measure-node-machine --shadow --window-rows`
([the guide](commands/lowering.md#xs-rows-on-the-window-2850)).

X's rows on the window listed every expression with an update: @@before_update_sqlite3@@ of
`sqlite3.c`'s @@expressions_sqlite3@@ that C takes there. This piece makes an update's two rows
(the old value's read after its destination's row, and the operation, the
conversion back and the store at its own record) as shapes of the rows'
table, in the slots its two records have free, written over the shapes'
sweep's by a sweep and a loop of their own. No compile takes any of it. [The
node machine's page](node-machine.md#an-updates-rows-on-the-window) has it
whole: the rows, the six builds, the probes and the faults. [Its
specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7030649938)
had five gates.

### What it measured

The 9700X, CPU 2, under the lock, Release, TSC ticks, @@readings@@ readings; in each
one executable with the update's rows on and off (an experiment's switch),
and the piece before's executable between them:

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
@@short_table@@

### Against its gates

@@short_gates@@

### What stays a record at a time, and why

The updates' loop, for one record in some ninety. An update's two records
are apart by a distance only its own record has, its computation's class is
a load by its line's type's number, and its shapes are bytes stored at the
two records. The fourth build had the two rows' shapes as masks in the
shapes' sweep, with the loop carrying only what crosses the two records:
@@vector_note@@

### What it means

@@means@@

