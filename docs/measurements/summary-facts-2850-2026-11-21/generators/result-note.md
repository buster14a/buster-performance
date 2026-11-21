**Result: a summary node's side facts on the window** ([the specification above](https://github.com/buster14a/buster/issues/2850#issuecomment-7053609091)). The code is on buster14a/buster#3199's branch, after the piece that pull request opened with; [the record](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/summary-facts-2850-2026-11-21); [the design's section](https://github.com/buster14a/buster/blob/ccr-fe760795-0ic1aw/docs/node-machine.md#a-summary-nodes-side-facts-on-the-window). In the shadow alone: no compile takes any of it.

**It is exact for what it makes and its faults are caught. One gate is refuted on one corpus, two are over without being refuted, and the piece found that the four inputs were not enough to call anything here exact.**

| gate | asked | read | verdict |
| --- | --- | --- | --- |
| F1, exact | every kept expression's references, return fact and selector's type are the program's; the probes agree; a control | {{=four('kept')}} expressions and {{=four('program_references')}} references with no difference, with the default warnings and with `-Wall -Wextra`; {{=n(v['probes']['cases'])}} one-statement programs agree | **met for what it makes**; a selector's type is not made (#3200), and the control changes what reader time kept, not the program's answers |
| F2, how much | the listing leaves out at most 5 expressions a corpus | {{=four('left_out')}} | **met** |
| F3, work a record | the rows' sweeps' second run no more than +0.30 ticks a record swept on `sqlite3.c` and Lua (0.60 refutes); the tests' bytes no more than +0.20 | {{=sval('sqlite3', 'rows_all_second')}} and {{=sval('lua', 'rows_all_second')}} ({{=sval('sqlite3', 'rows_all_second', 2, 'repeat')}} and {{=sval('lua', 'rows_all_second', 2, 'repeat')}} in a second set); {{=sval('sqlite3', 'bytes')}} and {{=sval('lua', 'bytes')}} | **over for the rows' sweeps, not refuted**; met for the tests' bytes |
| F4, a chunk | the rows' sweeps' first run less their second no more than +100 ticks a chunk on each corpus (200 refutes); the tests' sweep no more than +50 | {{=threes('rows_all_cold', 0)}} ({{=threes('rows_all_cold', 0, 'repeat')}} in a second set); the tests' sweep {{=sval('sqlite3', 'tests_two_chunk', 0)}} on `sqlite3.c` here, {{=sval('sqlite3', 'tests_two_chunk', 0, 'xs4')}} and {{=sval('sqlite3', 'tests_two_chunk', 0, 'xs5')}} in the two builds before | **refuted on musl**, over on Lua, met on `sqlite3.c`; the tests' sweep is **not decided**: it reads by the build |
| F5, nothing else moves | the kernel, C's sweeps and the tests' other parts within 0.2 by the switch | {{=threes('kernel')}}; {{=threes('c_second')}}; {{=threes('tests_rest')}} ({{=threes('tests_rest', 2, 'repeat')}} in a second set) | **met** for the kernel and C's sweeps; the tests' other parts are within it on `sqlite3.c` and not told apart on Lua and musl |
| F6, faults | every fault caught, or its term implied and out | the whole list on the code as it is, {{=n(v['faults']['round5']['faults'])}} faults: {{=n(v['faults']['round5']['caught'])}} caught, 1 that changes nothing a program reaches; nine terms out | **met**, with that one |

**What the sweep costs.** {{=threev('sweep_second')}} ticks a record swept on a chunk's second run ({{=join(['%.0f%%' % (100 * med(c, 'sweep_second') / med(c, 'rows_off_second')) for c in CORPORA])}} of the rows' sweeps without it) and {{=threev('sweep_first')}} on a first; its first run less its second is {{=threev('sweep_cold', 0)}} ticks a chunk. That cold start of its own is what F4 reads on musl, whose chunks are {{='%.0f' % v['final']['musl']['a_chunk']}} records, beside the {{=join(['%.0f' % ((med(c, 'rows_off_first') - med(c, 'rows_off_second')) * v['final'][c]['a_chunk']) for c in CORPORA])}} the rows' other sweeps pay a chunk already (#3196). In the shadow the reference's sweeps run between one chunk's and the next's; a compile that takes expressions is where a chunk's first run is to be read.

**Differences from the specification, plainly:**

- **No selector's type.** `-Wswitch` reads the node at the selector's first token, not the selector's type (#3200), so a side type by the root would answer another question. A `switch`'s condition stays the walk's.
- **A third case of a truth the value has not.** The specification listed one (an `&&` or an `||` its second operand decides). The checker's walk also gives a cast its operand's truth where the cast's value has none, `(char)(long)&x` (#3204: clang keeps both edges). C's loop lists such a cast's expression; on the four inputs it lists {{='no expression' if all(v['cloud'][u]['passed'] == 0 for u in UNITS) else four('passed') + ' expressions'}}.
- **The objects are a gather.** The specification said "a loop writes each one's object". An experiment build read the loop against a gather of eight quadwords in one executable: {{=xsrng('sqlite3', 'eight_more_second', 2, 'experiment2')}}, {{=xsrng('lua', 'eight_more_second', 2, 'experiment2')}} and {{=xsrng('musl', 'eight_more_second', 2, 'experiment2')}} ticks a record swept (a chunk's few references ended the loop on a mispredicted branch). The gather is the code.
- **The tests' sweep's gate cannot be read by the switch.** With the facts the tests' sweeps are another copy of their code, and the switch reads the two copies' places in the executable: {{=sval('sqlite3', 'tests_two_chunk', 0, 'xs4')}} and {{=sval('sqlite3', 'tests_two_chunk', 0, 'xs4b')}}, {{=sval('sqlite3', 'tests_two_chunk', 0, 'xs5')}} and {{=sval('sqlite3', 'tests_two_chunk', 0, 'xs5b')}}, {{=sval('sqlite3', 'tests_two_chunk', 0)}} and {{=sval('sqlite3', 'tests_two_chunk', 0, 'repeat')}} ticks a chunk on `sqlite3.c` in three builds' two sets each, with the sweeps' source the same but for one mask's operation.

**What the corpora did not have.** When the code was first frozen, the four inputs, the fixtures and 838 one-statement programs of its own read no difference. Then:

- the **earlier pieces' one-statement programs**, run again with the facts' comparison, had the cast above;
- a **generator of random one-statement programs** through the shadow (its exit status is the oracle) found a wrong value in the values' piece, merged in #3197: `(_Bool)&x` is an integer's constant of x's record, and the value's column took the object. Fixed here; `tests/checker/sources/0013.c` has that statement, and no corpus has;
- with operands of the wrong kind the generator found what the **reader-time tests take with a warning** (#3201), and the **regression programs** under `tests/`, run through the shadow one a file, a `return` under a pending cleanup (#3202) and a multiversioned function's object (#3203).

On the code as it is: {{=n(v['probes']['cases'])}} one-statement programs agree; the generator's {{=n(v['fuzz']['final']['programs'])}} programs read {{=n(v['fuzz']['final']['found'])}} that differ, every one #3201's; and of the {{=n(v['tests']['final']['ran'])}} regression programs that run with no option {{=n(v['tests']['final']['found'])}} end with status 1, #3202's and #3203's.

**What is next, in order.** The plan above put the first compile that takes expressions next. It cannot be yet:

1. **#3201, #3202 and #3203**, each an unsound take or a wrong fact at reader time that a compile would turn into a missed warning or wrong code, with a trigger of every warning the tests stand for (`node_census_warning_classes`) run through the shadow, since the generator only reaches what its grammar has.
2. **The first compile that takes expressions**, behind an option, as specified above; a chunk's first run and #3196 are read there.
3. **The events**, `-g`'s tokens and the target features' calls.

---
Agent session: [private session](https://claude.ai/code/session_01EgbxneipucKBYgjW4XLXVp)
Model: Anthropic / claude-fable-5-2

---
_Generated by [Claude Code](https://claude.ai/code)_
