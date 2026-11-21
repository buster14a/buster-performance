**Result: a summary node's side facts on the window** ([the specification above](https://github.com/buster14a/buster/issues/2850#issuecomment-7053609091)). The code is on buster14a/buster#3199's branch, after the piece that pull request opened with; [the record](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/summary-facts-2850-2026-11-21); [the design's section](https://github.com/buster14a/buster/blob/ccr-fe760795-0ic1aw/docs/node-machine.md#a-summary-nodes-side-facts-on-the-window). In the shadow alone: no compile takes any of it.

**It is exact for what it makes and its faults are caught. One gate is refuted on one corpus, two are over without being refuted, and the piece found that the four inputs were not enough to call anything here exact.**

| gate | asked | read | verdict |
| --- | --- | --- | --- |
| F1, exact | every kept expression's references, return fact and selector's type are the program's; the probes agree; a control | 49,842, 10,246, 40,441 and 41,890 expressions and 14,506, 4,918, 9,391 and 13,365 references with no difference, with the default warnings and with `-Wall -Wextra`; 7,957 one-statement programs agree | **met for what it makes**; a selector's type is not made (#3200), and the control changes what reader time kept, not the program's answers |
| F2, how much | the listing leaves out at most 5 expressions a corpus | 3, 2, 3 and 0 | **met** |
| F3, work a record | the rows' sweeps' second run no more than +0.30 ticks a record swept on `sqlite3.c` and Lua (0.60 refutes); the tests' bytes no more than +0.20 | +0.34 and +0.39 (+0.34 and +0.39 in a second set); -0.01 and -0.01 | **over for the rows' sweeps, not refuted**; met for the tests' bytes |
| F4, a chunk | the rows' sweeps' first run less their second no more than +100 ticks a chunk on each corpus (200 refutes); the tests' sweep no more than +50 | +23, +115 and +232 (+46, +144 and +259 in a second set); the tests' sweep +66 on `sqlite3.c` here, +41 and +181 in the two builds before | **refuted on musl**, over on Lua, met on `sqlite3.c`; the tests' sweep is **not decided**: it reads by the build |
| F5, nothing else moves | the kernel, C's sweeps and the tests' other parts within 0.2 by the switch | +0.01, +0.01 and +0.01; +0.01, +0.01 and -0.06; -0.02, -0.43 and +2.14 (+0.04, -0.13 and -0.14 in a second set) | **met** for the kernel and C's sweeps; the tests' other parts are within it on `sqlite3.c` and not told apart on Lua and musl |
| F6, faults | every fault caught, or its term implied and out | the whole list on the code as it is, 142 faults: 141 caught, 1 that changes nothing a program reaches; nine terms out | **met**, with that one |

(`sqlite3.c`, Lua and musl in that order, and the compiler's own source fourth where there are four; the 9700X, seven readings, and eight more for the second set.)

**What the sweep costs.** 0.27, 0.31 and 0.31 ticks a record swept on a chunk's second run (4%, 5% and 4% of the rows' sweeps without it) and 0.41, 0.80 and 1.70 on a first; its first run less its second is 68, 185 and 167 ticks a chunk. That cold start of its own is what F4 reads on musl, whose chunks are 127 records, beside the 1,342, 2,163 and 2,044 the rows' other sweeps pay a chunk already (#3196). In the shadow the reference's sweeps run between one chunk's and the next's; a compile that takes expressions is where a chunk's first run is to be read.

**Differences from the specification, plainly:**

- **No selector's type.** `-Wswitch` reads the node at the selector's first token, not the selector's type (#3200), so a side type by the root would answer another question. A `switch`'s condition stays the walk's.
- **A third case of a truth the value has not.** The specification listed one (an `&&` or an `||` its second operand decides). The checker's walk also gives a cast its operand's truth where the cast's value has none, `(char)(long)&x` (#3204: clang keeps both edges). C's loop lists such a cast's expression; on the four inputs it lists no expression.
- **The objects are a gather.** The specification said "a loop writes each one's object". An experiment build read the loop against a gather of eight quadwords in one executable: +0.00 (-0.00 to +0.09), -0.07 (-0.08 to -0.05) and -0.14 (-0.19 to -0.13) ticks a record swept (a chunk's few references ended the loop on a mispredicted branch). The gather is the code.
- **The tests' sweep's gate cannot be read by the switch.** With the facts the tests' sweeps are another copy of their code, and the switch reads the two copies' places in the executable: +41 and +38, +181 and +140, +66 and +87 ticks a chunk on `sqlite3.c` in three builds' two sets each, with the sweeps' source the same but for one mask's operation.

**What the corpora did not have.** When the code was first frozen, the four inputs, the fixtures and 838 one-statement programs of its own read no difference. Then:

- the **earlier pieces' one-statement programs**, run again with the facts' comparison, had the cast above;
- a **generator of random one-statement programs** through the shadow (its exit status is the oracle) found a wrong value in the values' piece, merged in #3197: `(_Bool)&x` is an integer's constant of x's record, and the value's column took the object. Fixed here; `tests/checker/sources/0013.c` has that statement, and no corpus has;
- with operands of the wrong kind the generator found what the **reader-time tests take with a warning** (#3201), and the **regression programs** under `tests/`, run through the shadow one a file, a `return` under a pending cleanup (#3202) and a multiversioned function's object (#3203).

On the code as it is: 7,957 one-statement programs agree; the generator's 90,000 programs read 212 that differ, every one #3201's; and of the 408 regression programs that run with no option 9 end with status 1, #3202's and #3203's.

**What is next, in order.** The plan above put the first compile that takes expressions next. It cannot be yet:

1. **#3201, #3202 and #3203**, each an unsound take or a wrong fact at reader time that a compile would turn into a missed warning or wrong code, with a trigger of every warning the tests stand for (`node_census_warning_classes`) run through the shadow, since the generator only reaches what its grammar has.
2. **The first compile that takes expressions**, behind an option, as specified above; a chunk's first run and #3196 are read there.
3. **The events**, `-g`'s tokens and the target features' calls.

---
Agent session: [private session](https://claude.ai/code/session_01EgbxneipucKBYgjW4XLXVp)
Model: Anthropic / claude-fable-5-2

---
_Generated by [Claude Code](https://claude.ai/code)_
