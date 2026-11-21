## A summary node's side facts on the window

[The
record](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/summary-facts-2850-2026-11-21).
`measure-node-machine --shadow --window-rows` ([the
guide](commands/lowering.md#a-summary-nodes-side-facts-on-the-window-2850)).

Step 2 ends with one summary node where a taken expression's nodes were. Every pass that reads below a full
expression's root then needs its answer from that node. A survey of today's code found what a compile with the
default warnings reads there: the static objects an expression's leaves name, its root's return fact, a branch's
condition's truth and a constant root's fold. This piece makes the first two on the window, for each expression
whose tape X makes whole: the references by one sweep of masks with a count of them through each record, so that an
expression's are a range of one list, and the return fact from a mask of the calls that are no plain function's,
asked a record at a time. The last two are the root's value's to answer, and the window lists the two cases where
the program knows a truth its value has not. No compile takes any of it. [The node machine's
page](node-machine.md#a-summary-nodes-side-facts-on-the-window) has it whole: the survey, the rules, the builds,
what a generator of programs found after the code was frozen, and the faults. [Its
specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7053609091) had six gates. It is exact
on what it makes and its faults are caught; a `switch`'s selector's type is not made; its work a record is over its
gate and under what refutes it; and by the chunk it is past what refutes its gate on musl.

### What it measured

The 9700X, CPU 2, under the lock, Release, TSC ticks, 7 readings; in each the facts on, off twice by the shadow's
switch (`--no-window-summaries`), and on again, in one executable:

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| records swept; chunks; records a chunk | 321,434; 611; 526 | 91,252; 241; 379 | 377,187; 2,975; 127 |
| expressions whose facts are kept; their references; the program's (a set an expression) | 49,839; 14,634; 14,502 | 10,246; 4,959; 4,918 | 40,441; 10,247; 9,391 |
| of them with an unknown for a return fact; with a stop | 250; 0 | 15; 112 | 64; 21 |
| records listed for a reference; calls asked a record at a time; expressions reduced | 14,911; 255; 0 | 5,128; 127; 0 | 11,522; 99; 0 |
| **the sweep, a record swept, a chunk's second run** | **0.27 (0.27 to 0.28)** | **0.31 (0.31 to 0.32)** | **0.31 (0.31 to 1.19)** |
| the sweep, a record swept, a first run | 0.41 (0.39 to 0.43) | 0.80 (0.78 to 0.81) | 1.70 (1.57 to 2.28) |
| the tests' records' bytes, a record swept, more with the facts (their one run) | -0.01 (-0.12 to +0.06) | -0.01 (-0.24 to +0.98) | -0.81 (-6.69 to +3.09) |
| the tests' loop, more (its one run) | +0.12 (-0.07 to +0.32) | +0.06 (+0.01 to +1.22) | +0.67 (-1.20 to +4.47) |
| **the three together, the sweep by its second run** | **+0.40 (+0.17 to +0.47)** | **+0.32 (+0.18 to +2.52)** | **+1.01 (-5.70 to +5.54)** |
| the three together, the sweep by its first run | +0.55 (+0.29 to +0.61) | +0.81 (+0.68 to +3.00) | +2.33 (-3.74 to +7.00) |
| **the sweep, a first run less a second, ticks a chunk** | **68 (63 to 80)** | **185 (178 to 186)** | **167 (86 to 249)** |
| the sweep, ticks a chunk: a first run; a second | 215 (207 to 226); 144 (143 to 147) | 304 (295 to 306); 119 (116 to 122) | 216 (199 to 290); 40 (39 to 151) |
| the tests' bytes and loop, ticks a chunk, more | +66 (-60 to +104) | +2 (-46 to +834) | +89 (-763 to +663) |
| **the rows' sweeps, the facts' among them, a record swept, a second run, more** | **+0.34 (+0.31 to +0.38)** | **+0.39 (-0.18 to +0.40)** | **+0.36 (-0.39 to +1.14)** |
| **the rows' sweeps, the facts' among them, a first run less a second, ticks a chunk, more** | **+23 (-44 to +64)** | **+115 (-11 to +372)** | **+232 (-1 to +248)** |
| the rows' other sweeps, a second run, more | +0.06 (+0.03 to +0.10) | +0.07 (-0.49 to +0.07) | +0.03 (-0.70 to +0.26) |
| of them the turns' lists and loops, where the listing is | +0.01 (-0.01 to +0.02) | +0.00 (-0.02 to +0.02) | -0.01 (-0.03 to +0.00) |
| the rows' other sweeps, a first run less a second, ticks a chunk, more | -47 (-117 to +0) | -70 (-189 to +188) | +60 (-156 to +81) |
| C's sweeps, a second run, more; a first run less a second, ticks a chunk, more | +0.01 (-0.03 to +0.06); +20 (-86 to +111) | +0.01 (-0.43 to +0.05); +7 (-37 to +61) | -0.06 (-1.40 to +0.28); +54 (-185 to +229) |
| the kernel in place, more | +0.01 (-0.05 to +0.14) | +0.01 (-0.41 to +0.40) | +0.01 (-0.78 to +0.10) |
| the tests' other parts, more | -0.02 (-0.27 to +0.20) | -0.43 (-2.81 to +0.71) | +2.14 (-1.49 to +2.94) |
| the rows' sweeps without the facts, a record swept: a first run; a second | 8.82 (8.58 to 9.11); 6.27 (6.25 to 6.30) | 12.42 (12.20 to 13.06); 6.71 (6.65 to 7.23) | 24.27 (23.53 to 25.94); 8.14 (8.03 to 8.77) |
| the timed region with no sweep in it, ticks a chunk | 27.0 (26.6 to 30.1) | 26.9 (25.6 to 28.6) | 27.4 (27.1 to 27.8) |

### Against its gates

- **F1, exact: met for what the piece makes.** Every kept expression's references and return fact are the program's
  own walks' on the three corpora and the compiler's own source (49,842, 10,246, 40,441 and 41,890 expressions), a
  kept branch's truth is its value's and a kept constant folds; 7,957 one-statement programs agree. A `switch`'s
  selector's type is not made, and the control changes what reader time kept, not the program's answers.
- **F2, how much: met.** The turns' listing leaves out 3, 2, 3 and 0 expressions the piece before took (5 a corpus
  asked); the cast's term lists none.
- **F3, work a record: met for the tests' sweep, over for the rows'.** A chunk's second run of the rows' sweeps
  reads +0.34 and +0.39 ticks a record swept more with the facts on `sqlite3.c` and Lua (0.30 asked, 0.60 refutes);
  the tests' bytes -0.01 and -0.01 (0.20 asked).
- **F4, a chunk: refuted on musl, not met on Lua, met on `sqlite3.c`.** The rows' sweeps' first run less their
  second rose by +23, +115 and +232 ticks a chunk (100 asked, 200 refutes), and by +46, +144 and +259 in a second
  set. The tests' sweep reads +66 on `sqlite3.c` here and +41 and +181 in the two builds before (50 asked): with the
  facts it is another copy of its code, and the switch reads the two copies' places.
- **F5, nothing else moves: met for the kernel and C's sweeps** (+0.01, +0.01 and +0.01 and +0.01, +0.01 and -0.06);
  the tests' other parts read -0.02, -0.43 and +2.14, one run a chunk, and +0.04, -0.13 and -0.14 in the second set.
- **F6, faults: met, with one fault no test separates.** The whole list on the code here, 142 faults: 141 caught,
  and one that changes nothing a program reaches. Nine terms no test separated in the rounds before are out of the
  code.

### What stays a record at a time, and why

The objects, one a reference, were a loop of a load and a store, a third of the sweep; a gather of eight is the
code, the same on `sqlite3.c` (+0.00 (-0.00 to +0.09) ticks a record swept against the loop, one executable) and
less on Lua and musl (-0.07 (-0.08 to -0.05) and -0.14 (-0.19 to -0.13)), whose chunks' few references ended the
loop on a mispredicted branch. A record at a time stay a call that is no plain function's (one record in 1,261, 719
and 3,810 of those swept) and the flow's reduction, for an expression with a call that stops under an `&&`, an `||`
or a `?:` (none in the three corpora, 18 in the compiler's own source).

### What it means

- **The side facts are exact on the window,** and the piece before's takes stand but for 3, 2, 3 and 0 expressions.
- **The sweep is a third of a tick a record** (0.27, 0.31 and 0.31 on a second run), and a chunk's cold start of its
  own (68, 185 and 167 ticks a chunk), which on musl's small chunks is past its gate. A compile that takes
  expressions is where a chunk's first run is to be read ([#3196](https://github.com/buster14a/buster/issues/3196)).
- **The corpora and the fixtures were not enough to call it exact:** a generator of programs and the regression
  programs found a truth through a cast and a constant of an object's record here, and in earlier pieces what the
  reader-time tests take with a warning ([#3201](https://github.com/buster14a/buster/issues/3201)), a `return` under
  a cleanup ([#3202](https://github.com/buster14a/buster/issues/3202)) and a multiversioned function's object
  ([#3203](https://github.com/buster14a/buster/issues/3203)). Those three are next, before the first compile that
  takes expressions.
