## A summary node's side facts on the window

[The record](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/summary-facts-2850-2026-11-21).
`measure-node-machine --shadow --window-rows`
([the guide](commands/lowering.md#a-summary-nodes-side-facts-on-the-window-2850)).

Step 2 ends with one summary node where a taken expression's nodes were.
Every pass that reads below a full expression's root then needs its answer
from that node. A survey of today's code found what a compile with the
default warnings reads there: the static objects an expression's leaves
name, its root's return fact, a branch's condition's truth and a constant
root's fold. This piece makes the first two on the window, for each
expression whose tape X makes whole: the references by one sweep of masks
with a count of them through each record, so that an expression's are a
range of one list, and the return fact from a mask of the calls that are no
plain function's, asked a record at a time. The last two are the root's
value's to answer, and the window lists the two cases where the program
knows a truth its value has not. No compile takes any of it. [The node
machine's page](node-machine.md#a-summary-nodes-side-facts-on-the-window)
has it whole: the survey, the rules, the builds, what a generator of
programs found after the code was frozen, and the faults. [Its
specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7053609091)
had six gates. It is exact on what it makes and its faults are caught; a
`switch`'s selector's type is not made; its work a record is over its gate
and under what refutes it; and by the chunk it is past what refutes its
gate on musl.

### What it measured

The 9700X, CPU 2, under the lock, Release, TSC ticks,
{{=v['final']['sqlite3']['runs']}} readings; in each the facts on, off twice
by the shadow's switch (`--no-window-summaries`), and on again, in one
executable:

{{file:table}}

### Against its gates

{{file:gates-short}}

### What stays a record at a time, and why

{{file:scalar-short}}

### What it means

{{file:means-short}}
