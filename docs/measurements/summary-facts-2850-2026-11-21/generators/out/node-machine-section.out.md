### A summary node's side facts on the window

Step 2 ends with a flip: one summary node in the graph where a taken
expression's nodes were, and its tape spliced. Every pass after the reader
that reads below a full expression's root today then needs its answer from
that node's value or from a side record of it, or has to be shown not to
read there. This piece makes the side record's facts on the window, for each
expression whose tape X makes whole, and compares them after the pipeline
with the program's own walks on that expression's root ([#2850's
specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7053609091);
`measure-node-machine --shadow --window-rows`, [the
guide](commands/lowering.md#a-summary-nodes-side-facts-on-the-window-2850);
[the
record](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/summary-facts-2850-2026-11-21)).
No compile takes any of it.

**What reads below a root today** ([the survey and its
census](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/summary-facts-census-2850-2026-11-20):
the passes, a file and a line each, and what the program's walks say of each
taken root beside the window's bytes). In a compile with the default
warnings:

| reader | what it reads below a root | a summary node's answer |
| --- | --- | --- |
| `check_program_references`, every body | the static objects its leaves name, a set | **the side record: its references** |
| the return flow (`check_program_return_facts`; `-Wreturn-type` is on by default) | each call's callee, joined up the tree | **the side record: its root's fact** |
| `check_program_branch_truth` (the return flow, the warnings' reach) | a branch's condition's truth, through `!`, casts and the operands of `&&` and `\|\|` | its value's: the window lists what an operand or a cast alone decides |
| the controls' fold (`check_control_fold_truth`) | the root's constant, and below it where it is one | its value's: a taken constant folds |
| `-Wswitch` | the node at the selector's first token | none: a `switch`'s condition stays the walk's ([#3200](https://github.com/buster14a/buster/issues/3200)) |
| the initializer planner (`check_initializers_run_events`) | the greatest node of the source's tokens' | the flip's: the summary node is its tokens' |
| the lowering and its rooms | everything | the flip's: the tape is spliced |
| the default-on warning passes | subtrees | none: a taken expression has none of their warnings, by its tests |

Only with an option or a construct a unit may have: the uninitialized scan
and `-Wunused-but-set-parameter` (`-Wall`, `-Wextra`),
`-Wfor-loop-analysis`, the target features' check, the symbol pragmas' walk,
the candidates' scan, `musttail`, and `-g`'s rows. Those are the piece after
the first compile's.

**What the count before the specification found**, on the expressions the
window took whole in the cloud container (the census's own table's rows):

| | `sqlite3.c` | Lua | musl | the compiler's own source |
| --- | ---: | ---: | ---: | ---: |
| expressions the window takes whole; their records | 49,845; 278,892 | 10,248; 70,873 | 40,444; 204,846 | 41,890; 238,831 |
| **the references the program's walk makes of them** | **14,506** | **4,920** | **9,396** | **13,365** |
| expressions with none; one; two; three or more | 36,878; 11,618; 1,204; 145 | 6,365; 3,044; 717; 122 | 32,311; 7,231; 750; 152 | 31,897; 7,532; 1,812; 649 |
| calls; through a value (no declared function's name) | 12,724; 252 | 4,022; 15 | 7,943; 65 | 9,637; 9 |
| expressions with a call of a function declared noreturn | 0 | 112 | 21 | 30 |
| conditions; with a known truth; of them by a constant value; by one operand of an `&&` or an `\|\|` alone | 11,905; 53; 53; 0 | 1,537; 0; 0; 0 | 7,206; 239; 237; 2 | 8,218; 1; 1; 0 |
| roots with a constant integer value and no effect; of them with a comma | 3,028; 0 | 550; 0 | 1,643; 0 | 5,631; 0 |

A reference is exactly a leaf with an object that is static or has a name's
symbol, evaluated or not: none missing and none extra on the four. The
return fact is the flow's own rule run over the window's records. A
condition's truth is its value's but for two of musl's.

**The references.** `check_program_references` takes a VALUE's leaf's object
where its value is a static object's or its declaration is static, whatever
is above the leaf (it leaves out a `sizeof`'s operand, whose token the front
leaves to the walk). On the window that is two bits of a record's flags'
byte, by its kind: a name's leaf with a symbol of its own, or a literal's
leaf with an object, a string's. The walk has other sources of a reference
(a compound literal's initializer, a statement expression's region, an
overloaded call's function, a constant string's builtin); none adds one to a
taken expression on the four inputs or in the probes. The sweep
(`node_rows_window_summary`) takes 64 records a step:

- **the mask**: the flags tested against a table of what each kind of record
  needs, one shuffle and one test;
- **the list**: the block's references' records' numbers, one compression,
  and after the sweep a gather writes each one's object, its record's value,
  eight a step;
- **the counts**: the references through each record of the block, in a
  register. A multiplication of the mask's bytes by `0x0101010101010101`
  gives each byte the sum of its quadword's bytes up to it; the quadwords'
  totals are summed up the register in three steps; and the two are added.
  The chunk's count before the block is added and the 64 counts stored.

An expression's references are then the list's between two of those counts:
the one through the record before its operand's first and the one through
its last. That is two loads where the expression's summary's record is
written, and no step of the sweep is an expression's own. The first form of
the sweep was not so: it asked each expression's two counts of each list by
its block's mask, an expression at a time, and was replaced before any
reading on the 9700X. So was a form that took the n-th end mark for the n-th
expression: a batch's expressions are in the walk's order, an `if`'s
condition after its body's, and not in the window's.

**The return fact.** The flow gives a call its own fact
(`check_program_return_call`): none where its callee, through `*` and `&`,
is the name of a function, a stop where that function is declared noreturn,
and an unknown for a call through a value or of a library's name the flow
leaves unknown. Facts go up the tree; an `&&`, an `||` or a `?:` keeps its
condition's, an unknown of either arm, and a stop where both arms of a `?:`
stop. On the window:

- **A plain call has none.** A function's declaration's line has two bits,
  made with the line: a plain function's (not noreturn, no such name), and a
  noreturn one's. The tests' sweep copies a name's leaf's line's byte beside
  the records' bytes, and the tests' loop, which has each record's first
  operand's place at hand, gives each block a mask of the calls whose callee
  is no plain function's leaf in the block or the block before.
- **The others are asked a record at a time** (`node_rows_summary_call`, by
  the callee's record's byte; C lists an expression that calls `*f` or `&f`
  of a function's name, so the window asks no such call): 255, 127 and 99 of
  the three corpora's 321,434, 91,252 and 377,187 records swept, one record
  in 1,261, 719 and 3,810.
- **An expression's fact is its calls' together**, since an unknown goes up
  through every operator and a stop through every one that selects no
  operand. Where a call stops and the expression has an `&&`, an `||` or a
  `?:`, the flow's own reduction runs over its records
  (`node_rows_summary_reduce`): no expression of the three corpora and 18 of
  the compiler's own source.
- **A unit with a function unknown from a declaration on** (an
  `analyzer_noreturn`, an ignored `noreturn`:
  `check_program_return_unknowns`' table, made at the reader's start) has no
  plain call: each is asked, with its use's place.

**A condition's truth and a constant's fold** need nothing in the side
record. `check_program_branch_truth` knows a truth where a condition's value
has none in two cases, and the window lists both:

- **An `&&` or an `||` whose second operand's truth is known and decides**
  (`x && 0`, `x || 1`; one whose first operand's is known is C's to list
  already). The turns list an `&&` or an `||` whose second operand's truth
  is known, as branches or as a value: its standing's constant's kind, but
  an object's lvalue's. That leaves out 3, 2, 3 and 0 expressions the piece
  before took.
- **A cast that passes a truth its own value has not.** The walk gives a
  cast its operand's truth where the cast's value has none. An address
  constant is not null; `(char)(long)&x` is no constant, and its low byte
  may be zero ([#3204](https://github.com/buster14a/buster/issues/3204):
  clang keeps both edges, and the walk does not). C's loop lists the
  expression of a cast that is no constant, over an operand whose truth may
  be known, where its consumer may ask its truth: a CONDITION, a `!`, an
  `&&` or an `||`, or another wrapper (`passes_truth`). A `!` and a
  CONDITION are a constant wherever their operand's truth is known
  (`check_action_logic`), so only a cast passes one. On the four inputs it
  lists no expression: the specification did not have this case, and a
  one-statement program found it (below).

The controls' fold does not fold a comma whose left operand is no constant,
and C lists a folded comma: every taken root with an integer constant folds
as a leaf of its value would.

**Not made: a `switch`'s selector's type.** The specification had it as a
third fact. `-Wswitch` does not read the selector's own type: it reads the
node at the selector's first token, which is the selector only where that
token is its root's
([#3200](https://github.com/buster14a/buster/issues/3200): `switch
(s->kind)` warns in clang and not here). A side type by the root would
answer another question than the pass asks, so a `switch`'s condition stays
the walk's: 70, 85, 115 and 27 of the taken expressions.

**What the corpora did not have.** The four inputs, the fixtures and the
piece's own one-statement programs read no difference when the code was
first frozen. Two things run after that found two in it, and three in the
earlier pieces' code:

- **The earlier pieces' one-statement programs**, run again with the facts'
  comparison (6,414 programs; 7,957 with this piece's 1,543): one of them,
  `if ((char)(long)&x)`, has a truth the walk knows and its value has not.
  The cast's term above is its fix.
- **A generator of random one-statement programs** through the shadow, whose
  exit status is the oracle (integer, pointer and floating operands of each
  operator, weighted toward constants, addresses and casts): 18,000 programs
  on the first frozen code gave 82 that differ, 68 by that cast and 14 by an
  entry's value on the window, an earlier piece's: `(_Bool)&x` is an
  integer's constant, 1, whose record still has x for its object, and the
  value's column took a record's object wherever it had one. It takes it
  where the record's constant is an address's now. The repository's own
  regression programs have that statement (`tests/checker/sources/0013.c`),
  and no corpus has.
- **The earlier pieces' three:** with a share of operands of the wrong kind
  the generator finds what the reader-time tests take with a warning (an
  ordered comparison of a pointer with an integer, a cast of an array or a
  function to a narrower integer:
  [#3201](https://github.com/buster14a/buster/issues/3201)), and the
  regression programs a `return` under a pending cleanup
  ([#3202](https://github.com/buster14a/buster/issues/3202)) and a
  multiversioned function's object
  ([#3203](https://github.com/buster14a/buster/issues/3203)). Those are
  filed and not this piece's; each is the first compile's to have closed.

On the code here the generator read 60,000 programs with operands of the
right kind and 30,000 with a share of the wrong kind: 1 and 211 differ,
every one a take of the reader-time tests' with one of #3201's two warnings
(the one of the right kind by a cast the generator wrote without its
parentheses). Of the 1,229 regression programs 408 run through the shadow
with no option, and 9 end with status 1, #3202's 2 and #3203's 7; on main 13
do, the 4 more by that constant's value.

**How it came to its cost.** Builds on the 9700X, CPU 2, Release, one
executable with the facts and without them in each reading
(`--no-window-summaries`; TSC ticks, the timed region's own two timer reads
taken off):

| build | the sweep, a record swept, a chunk's second run | a first run less a second, ticks a chunk | the tests' loop, more | the rows' sweeps with the facts, a second run, more | readings |
| --- | ---: | ---: | ---: | ---: | ---: |
| the masks, the lists and the counts' column; the references' mask by two compares of the kinds and two tests under a mask of the chunk's records; both lists compressed in every block; the reduction for every expression with a call that stops; the tests' loop's mask of plain callees from three columns (the operators, the standings, the lines' bytes) | 0.33, 0.49, 0.49 | 75, 217, 190 | +0.16, +0.16, +0.16 | +0.33, +0.54, +0.60 | 3 |
| the references' mask by a table's shuffle and one test, with no mask of the chunk's records (the tests' sweep writes a block's bytes whole); the calls' list only in a block that has one; the counts' stores aligned; the reduction only where the expression has an `&&`, an `||` or a `?:` | 0.26, 0.35, 0.34 | 109, 192, 219 | +0.09, +0.14, +0.47 | +0.29, +0.40, +0.43 | 5 |
| a line's byte's two bits a plain function's and a noreturn one's (they were a noreturn one's and an unknown name's): the tests' loop's test is one AND of the lines' bytes, with no standing read | 0.28, 0.35, 0.35 | 99, 184, 193 | +0.05, +0.00, +0.07 | +0.30, +0.44, +0.44 | 7 |
| the code as first frozen: the terms the first three fault rounds took out | 0.29, 0.36, 0.37 | 94, 179, 212 | +0.05, +0.08, -0.15 | +0.34, +0.46, +0.41 | 7 |
| a cast's term in C's loop and the value's column's choice, both in a run with the facts and without them alike | 0.27, 0.36, 0.39 | 86, 184, 196 | +0.14, +0.09, +0.05 | +0.31, +0.43, +0.48 | 7 |
| **the code here**: the objects by a gather of eight where a loop wrote them one a step | 0.27, 0.31, 0.31 | 68, 185, 167 | +0.12, +0.06, +0.67 | +0.34, +0.39, +0.36 | 7 |

(`sqlite3.c`, Lua and musl in each cell.)

**Measured** (the 9700X, the code here, 7 readings, each the facts on, off
twice and on again; a median and its least and most):

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

A second set, 8 readings of the same executable (the repeat, below), reads
the sweep at 0.28, 0.32 and 0.31 a record on a second run, the rows' sweeps
with the facts +0.34, +0.39 and +0.34 more, and the tests' other parts
+0.04, -0.13 and -0.14.

**Against its gates**

- **F1, exact: met for what the piece makes, with two differences from the
  gate's letter.** On `sqlite3.c`, Lua, musl and the compiler's own source,
  in the cloud container, every kept expression's references and return fact
  are the program's own walks' (49,842, 10,246, 40,441 and 41,890
  expressions, 14,506, 4,918, 9,391 and 13,365 references, 250, 15, 64 and
  15 facts with an unknown and 0, 112, 21 and 30 with a stop), every kept
  branch's condition's truth is its value's (11,902, 1,536, 7,204 and 8,218
  asked, 53, 0, 237 and 1 known) and every kept root with an integer
  constant folds (3,028, 550, 1,643 and 5,631); the same with `-Wall
  -Wextra` (49,842, 10,246, 40,441 and 41,890 expressions). The 7,957
  one-statement programs agree: 1,543 written for this piece (a reference of
  each kind in each place, a call of each form, a stop in each place an
  operator puts it, conditions an operand or a cast decides, the walks'
  other sources of a reference, a `constexpr` object, and statements at each
  lane of a block) and the 6,414 of the pieces before. The differences: a
  selector's type is not made (above); and the control changes what reader
  time kept, not the program's answers. With it each kept expression's facts
  are kept with one changed (a reference more, a reference's object, its
  fact's stop and its unknown in turn), and the comparison must count every
  one by its turn; one of a chunk's first run's facts is changed, and every
  chunk's second run must differ; and the truths and the folds are asked of
  every root reader time typed, where they must count the fixture's lines
  the window lists for them.
- **F2, how much: met.** The turns' listing leaves out 3, 2, 3 and 0
  expressions the piece before took (5 a corpus asked), and the cast's term
  lists no expression there.
- **F3, work a record: met for the tests' sweep; the rows' sweeps read +0.34
  on `sqlite3.c` and +0.39 on Lua where 0.30 was asked.** A chunk's second
  run of the rows' sweeps, the facts' among them, reads +0.34 (+0.31 to
  +0.38) ticks a record swept more with the facts on `sqlite3.c` and +0.39
  (-0.18 to +0.40) on Lua (0.30 asked, 0.60 refutes), and +0.34 and +0.39 in
  the repeat; the sweep itself is 0.27 and 0.31 of it. The tests' sweep that
  makes the records' bytes reads -0.01 (-0.12 to +0.06) and -0.01 (-0.24 to
  +0.98) more (0.20 asked), +0.05 and -0.15 in the repeat. The tests' sweeps
  have one run a chunk: theirs is a first run's reading, and the gate's
  "second run" is the rows' alone. On musl, which the gate did not name,
  +0.36 (-0.39 to +1.14) and -0.81 (-6.69 to +3.09).
- **F4, a chunk: refuted on musl for the rows' sweeps, not met on Lua, met
  on `sqlite3.c`; and the tests' sweep reads by the build.** The rows'
  sweeps' first run less their second rose by +23 (-44 to +64) ticks a chunk
  on `sqlite3.c`, +115 (-11 to +372) on Lua and +232 (-1 to +248) on musl
  (100 asked, 200 refutes), and by +46, +144 and +259 in the repeat: musl's
  is past what refutes in both sets. The sweep is a function of its own and
  pays a chunk's cold start of its own, 68, 185 and 167 ticks a chunk (70,
  192 and 208 in the repeat), and musl's chunks are 127 records. The two
  frozen builds before read +62, +109 and +157 and +19, +102 and +165: over
  the gate on Lua and musl in each. **The tests' sweep reads by the build.**
  Its bytes and loop read +66 (-60 to +104) ticks a chunk more with the
  facts on `sqlite3.c` here and +87 (+21 to +142) in the repeat (50 asked,
  100 refutes); the two frozen builds before read +41 and +38, then +181 and
  +140, in two sets each. The first and the second of the three builds
  differ by one mask's operation in the bytes' sweep, and the second and
  this one by nothing in either sweep. With the facts and without them each
  of the tests' sweeps is another copy of its code
  (`node_tests_window_bytes_by`'s and `node_tests_window_loop_by`'s forms),
  so the switch reads one copy's place in the executable against the
  other's, which is the build's: by the gate's letter it is met in one
  build, over in one and refuted in one. What the facts add to the two is a
  narrowing and a store a step of sixteen records, and a load, an AND, a
  permute, two tests and a quadword's store a step of sixty-four. On Lua +2
  (-46 to +834) and -33, on musl +89 (-763 to +663) and -274.
- **F5, nothing else moves: met for the kernel and C's sweeps; the tests'
  other parts are within it on `sqlite3.c` and not told apart on Lua and
  musl.** By the switch, the kernel in place reads +0.01 (-0.05 to +0.14),
  +0.01 (-0.41 to +0.40) and +0.01 (-0.78 to +0.10) more and C's sweeps'
  second run +0.01 (-0.03 to +0.06), +0.01 (-0.43 to +0.05) and -0.06 (-1.40
  to +0.28) (0.2 asked). The tests' other parts read -0.02 (-0.27 to +0.20),
  -0.43 (-2.81 to +0.71) and +2.14 (-1.49 to +2.94), and +0.04, -0.13 and
  -0.14 in the repeat: one run a chunk, with ranges ten times the gate on
  the two corpora of small chunks. Five earlier builds' medians of the same
  parts on musl are +0.91, -0.36, -0.94, +0.62 and +1.18.
- **F6, faults: met, with one fault no test separates whose term stays.**
  Each term of the piece changed alone, a build and the node machine's tests
  a fault: the turns' listing, a call's own fact, the selection's test, the
  reduction, the sweep's masks, counts and lists, the gather, the lines'
  column and the loop's mask, the unit's table, the comparison after the
  pipeline and a chunk's second run's, the cast's term and the value's
  column's choice. A round is run from the list's two ends at once, the
  9700X and the cloud container, and the two agree on every fault both ran.
  - The first round's 126 faults, on the third build's code, left 12, and 12
    that did not build (a name left unused), worded again for the second.
    Five of the survivors were terms the window's own rules imply, and are
    out of the code: the listing's test for a `!` above the operator; the
    call's walk through `*` and through `&`, whose expression C lists; the
    test that a call is inside the expression its end mark names; and the
    reduction's test that a record has a consumer. Two were a table's
    entries no record reaches, and the table is simpler. Three found a line
    of the fixture or a turn of the control: an arm that stops beside one
    that is unknown, the reduction's bytes of the chunk before, and a second
    run's objects. Two change nothing a program reaches.
  - The second round's 26, every one whose text changed and the survivors:
    22 caught, 1 that did not build and 3 that survived, one of them a gap
    of the control's (the reference more it kept could be the expression's
    own object's), closed for the third round, whose 13 are all caught.
  - After the probes' finds, the 17 faults of the cast's term and the
    value's column: 15 caught, and 2 whose terms are out of the code: the
    count's mask of the placed records, and the value's column's "or no
    constant at all" (the reader makes every object's leaf with an address's
    constant).
  - **The whole list on the code here, 142 faults: 141 caught and one that
    changes nothing a program reaches**, the reduction started at its
    operand's second record: an operand's first record is a leaf, which has
    no fact of its own and joins none to its consumer's. Both machines ran 6
    of them, with one verdict each.

**What stays a record at a time, and why**

The objects were a loop, and are a gather. Until this build the code wrote
each reference's object by a load and a store, one a step (14,911, 5,128 and
11,522 records listed, one in 22, 18 and 33 of those swept). An experiment
build (the build before's code with a switch read from the environment, not
for a commit; 7 readings, each setting in turn in one executable) read its
two vector's forms against it:

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| records listed for a reference; a chunk | 14,911; 24.4 | 5,128; 21.3 | 11,522; 3.9 |
| the sweep with the loop, a record swept, a chunk's second run (a region's two timer reads in it) | 0.33 (0.32 to 0.34) | 0.44 (0.44 to 0.45) | 0.68 (0.68 to 0.73) |
| the same executable and setting twice in a reading, the second less the first | +0.01 (-0.01 to +0.02) | -0.00 (-0.01 to +0.02) | -0.01 (-0.09 to +0.01) |
| **with a gather of eight quadwords, more** | **+0.00 (-0.00 to +0.09)** | **-0.07 (-0.08 to -0.05)** | **-0.14 (-0.19 to -0.13)** |
| with a gather of sixteen doublewords, more | +0.06 (+0.04 to +0.08) | -0.06 (-0.07 to -0.05) | -0.15 (-0.20 to -0.14) |
| a first run: with the loop | 0.64 (0.59 to 0.65) | 1.29 (1.27 to 1.32) | 2.71 (2.35 to 3.60) |
| **a first run: with a gather of eight, more** | **-0.04 (-0.07 to +0.02)** | **-0.06 (-0.10 to +0.01)** | **-0.40 (-0.84 to -0.27)** |
| a first run: with a gather of sixteen, more | -0.01 (-0.07 to +0.02) | -0.11 (-0.14 to +0.86) | -0.60 (-1.13 to -0.49) |

A gather of eight is the code: it reads the same on `sqlite3.c` and less
where a chunk has few references, which end the loop on a branch their count
mispredicts. A gather of sixteen doublewords reads more on `sqlite3.c`. An
earlier experiment read the sweep with no objects written at all -0.09
(-0.35 to -0.09) ticks a record swept on `sqlite3.c` and -0.11 (-0.12 to
-0.11) on Lua: the loop was a third of the sweep.

What stays a record at a time:

- **A call asked** (`node_rows_summary_call`, a byte of its callee's and, in
  a unit with a function unknown from a declaration on, a table's entry):
  255, 127 and 99 calls, one record in 1,261, 719 and 3,810 of those swept.
  With none asked that experiment reads -0.02 (-0.29 to -0.01) and -0.04
  (-0.05 to -0.03). A call that says a fact (an unknown in 250, 15 and 64
  expressions, a stop in 0, 112 and 21) then scans to its expression's end
  mark, some records on.
- **The reduction** (`node_rows_summary_reduce`), up one expression's
  postorder: no expression of the three corpora and 18 of the compiler's own
  source, those with a call that stops under an `&&`, an `||` or a `?:`. It
  is the flow's own rule in its own order, for expressions no reading here
  has enough of to time.

**What it means**

- **The side facts a compile with the default warnings reads are exact on
  the window**: an expression's references and its root's return fact as a
  side record, and a condition's truth and a constant's fold by its root's
  value, with two listings. A `switch`'s condition stays the walk's.
- **Their work a record is a third of a tick, and over its gate:** the sweep
  reads 0.27, 0.31 and 0.31 ticks a record swept on a chunk's second run,
  4%, 5% and 4% of what the rows' sweeps read without it (6.27, 6.71 and
  8.14). What the consumer adds, two loads an expression where its summary's
  record is written, is the first compile's to read.
- **By the chunk it pays a cold start of its own, and on musl that is past
  what its gate allows:** the sweep's first run reads 0.41, 0.80 and 1.70 a
  record swept, and its first run less its second 68, 185 and 167 ticks a
  chunk, beside the 1342, 2163 and 2044 the rows' other sweeps pay there
  already ([#3196](https://github.com/buster14a/buster/issues/3196)). In the
  shadow the reference's sweeps run between a chunk's and the next's; a
  compile that takes expressions runs none of them there, and is where a
  chunk's first run is to be read.
- **Four inputs and a fixture are not what "exact" asks.** Five differences
  were in none of them: a truth through a cast and a constant of an object's
  record here, and in earlier pieces' code what the reader-time tests take
  with a warning, a `return` under a cleanup and a multiversioned function's
  object. A generator of programs and the repository's own regression
  programs found them in minutes. Both are in the record, and a piece's
  freeze runs them from here on.

**What is next:** the earlier pieces' three holes
([#3201](https://github.com/buster14a/buster/issues/3201),
[#3202](https://github.com/buster14a/buster/issues/3202),
[#3203](https://github.com/buster14a/buster/issues/3203)), which a compile
that takes expressions cannot have, with a trigger of every warning the
tests stand for run through the shadow; then that compile, behind an option,
where the sweeps' cost by the chunk is read.
