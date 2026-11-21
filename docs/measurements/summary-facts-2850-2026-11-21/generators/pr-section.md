## A summary node's side facts on the window

Part of #2850 (step 2), the piece after the one below, on the same branch. [The specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7053609091), [its census and the survey of what reads below a root](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/summary-facts-census-2850-2026-11-20), [the record](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/summary-facts-2850-2026-11-21).

> **It is exact for what it makes and its faults are caught. One gate is refuted on one corpus, and two are over without being refuted.** The sweep reads {{=threev('sweep_second')}} ticks a record swept on a chunk's second run; with it the rows' sweeps read {{=sval('sqlite3', 'rows_all_second')}} and {{=sval('lua', 'rows_all_second')}} more on `sqlite3.c` and Lua where 0.30 was asked (F3). By the chunk the rows' sweeps' first run less their second rose by {{=threes('rows_all_cold', 0)}} ticks ({{=threes('rows_all_cold', 0, 'repeat')}} in a second set) where 100 was asked and 200 refutes: **refuted on musl**, whose chunks are {{='%.0f' % v['final']['musl']['a_chunk']}} records (F4). A `switch`'s selector's type, which the specification named, is not made ([#3200](https://github.com/buster14a/buster/issues/3200)). **And the four inputs were not enough to call it exact:** after the code was first frozen, the earlier pieces' one-statement programs and a generator of random ones found two differences here, both fixed in this piece, and three holes in earlier pieces' code, filed as #3201, #3202 and #3203. The piece runs in the shadow alone, so no compile reads a tick more.

### What it is

Step 2 ends with one summary node in the graph where a taken expression's nodes were. Every pass after the reader that reads below a full expression's root then needs its answer from that node's value or a side record of it. A survey of today's code says what a compile with the default warnings reads there; this piece makes it on the window, for each expression whose tape X makes whole, and compares it after the pipeline with the program's own walks on that root (`measure-node-machine --shadow --window-rows`). **No compile takes any of it.**

- **Its references** (`check_program_references`: the static objects its leaves name). A sweep of masks, 64 records a step (`node_rows_window_summary`), lists the chunk's by a table of the flags a record of each kind needs, and writes the count of the references through each record, in a register: one multiplication within a quadword and three steps of sums across them. An expression's references are the list's between two of those counts, two loads where its summary's record is written. A gather writes each listed record's object, eight a step.
- **Its root's return fact** (`check_program_return_facts`: a stop, an unknown). A call of a plain function's name has none; a function's declaration's line has a bit for that and one for noreturn, the tests' sweep copies a name's leaf's line's byte, and the tests' loop gives each block a mask of the other calls. Those are asked a record at a time (one record in {{=join([one_in(c) for c in CORPORA])}} of those swept), and an expression with a call that stops under an `&&`, an `||` or a `?:` has the flow's own reduction.
- **A condition's truth and a constant's fold** are the root's value's to answer. The window lists the two cases where the program's walk knows a truth the value has not: an `&&` or an `||` whose second operand's truth is known (the rows' turns), and a cast that passes a truth its own value has not, `(char)(long)&x` (C's loop).
- **`--no-window-summaries`** is the cost's switch, and the control (`BUSTER_NODE_READER_WINDOW_SUMMARY_FAULT`) changes what reader time keeps, one fact an expression in turn.

### Two fixes it carries

- **A cast that passes a truth** (found by an earlier piece's probe run again, `if ((char)(long)&x)`): the checker's walk of a branch's condition gives a cast its operand's truth where the cast's value has none ([#3204](https://github.com/buster14a/buster/issues/3204): clang keeps both edges). A summary node has its root's value alone, so C's loop lists such a cast's expression where its consumer may ask its truth. On the four inputs it lists {{='no expression' if all(v['cloud'][u]['passed'] == 0 for u in UNITS) else four('passed') + ' expressions'}}.
- **A constant of an object's record** (found by the generator; the values' piece, #3197, merged): `(_Bool)&x` is an integer's constant, 1, whose record still has x for its object, and the value's column took a record's object wherever it had one. It takes it where the record's constant is an address's. `tests/checker/sources/0013.c` has that statement; no corpus has.

### What else the generator and the regression programs found

Not this piece's, and filed: the reader-time tests take an ordered comparison of a pointer with an integer, and a cast of an array or a function to a narrower integer, with their warning ([#3201](https://github.com/buster14a/buster/issues/3201)); a `return` under a pending cleanup is taken as a plain return ([#3202](https://github.com/buster14a/buster/issues/3202)); a multiversioned function's object has no declaration at reader time ([#3203](https://github.com/buster14a/buster/issues/3203)). On the code here the generator's {{=n(v['fuzz']['final']['programs'])}} programs read {{=n(v['fuzz']['final']['found'])}} that differ, every one #3201's; of the {{=n(v['tests']['final']['ran'])}} regression programs that run with no option, {{=n(v['tests']['final']['found'])}} end with status 1, #3202's and #3203's.

### Measured

The 9700X, CPU 2, Release, each run its own hold of the lock, TSC ticks, {{=v['final']['sqlite3']['runs']}} readings; in each the facts on, off twice by the switch, and on again, in one executable (a timed region's own two timer reads taken off).

{{file:table}}

How it came to its cost, a build a line:

{{file:builds}}

### Against its gates

{{file:gates}}

### What stays a record at a time, and why

{{file:scalar}}

### What it means

{{file:means}}

### Tests

`test-checker` part 5 of 8 ({{=n(v['checks']['part5'])}} checks). A fixture of its own (`node_summary_test_source`), a line a case: references of each kind of leaf in each place; calls of each form, with an unknown and with a stop in each place an operator puts them; conditions an operand decides; the cast's term a line a term, with the count of the casts listed pinned; two constants of an object's record; and, 64 times each for a block's every lane, a statement with two calls and four references, two conditionals with an arm that stops and a call that stops. A second fixture is a unit with a function unknown from a declaration on. Each count is pinned, the switch must keep no fact with the same tapes, and the control must make every kept expression differ by its turn and every chunk's second run differ.

### Checks

In the cloud container, on the code's commit `{{=v['checks']['revision']}}`, whose sources the first of this piece's two commits has byte for byte:

- a native Release build; `test-checker`, all eight parts ({{=n(v['checks']['checks'])}} checks); the shadow with `--window-rows` and `--window-contexts` on `sqlite3.c`, Lua and musl and with `--window-rows` on the compiler's own source, with the default warnings and with `-Wall -Wextra` ({{=v['checks']['shadow_ok']}} of {{=v['checks']['shadow_runs']}} runs with status 0); the shadow's other modes on `sqlite3.c` and Lua ({{=v['checks']['mode_ok']}} of {{=v['checks']['mode_runs']}}); the self-check, the self-parse, `test-call-graph` and `check-call-graph`; the ownership check;
- the complete driver's lists and parse: 5 of 6 items pass. The one that does not is the preprocessor's comparison with clang, whose differing units differ by where their line markers place a token and by no token, as on the pieces before in this container;
- {{=n(v['probes']['cases'])}} one-statement programs, the generator's {{=n(v['fuzz']['final']['programs'])}} and the regression programs, as above;
- the sanitizers' native rows: {{file:sanitizers}}
