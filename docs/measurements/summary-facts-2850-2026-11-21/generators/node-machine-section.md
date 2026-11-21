### A summary node's side facts on the window

Step 2 ends with a flip: one summary node in the graph where a taken
expression's nodes were, and its tape spliced. Every pass after the reader
that reads below a full expression's root today then needs its answer from
that node's value or from a side record of it, or has to be shown not to
read there. This piece makes the side record's facts on the window, for each
expression whose tape X makes whole, and compares them after the pipeline
with the program's own walks on that expression's root
([#2850's specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7053609091);
`measure-node-machine --shadow --window-rows`,
[the guide](commands/lowering.md#a-summary-nodes-side-facts-on-the-window-2850);
[the record](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/summary-facts-2850-2026-11-21)).
No compile takes any of it.

**What reads below a root today**
([the survey and its census](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/summary-facts-census-2850-2026-11-20):
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
and `-Wunused-but-set-parameter` (`-Wall`, `-Wextra`), `-Wfor-loop-analysis`,
the target features' check, the symbol pragmas' walk, the candidates' scan,
`musttail`, and `-g`'s rows. Those are the piece after the first compile's.

**What the count before the specification found**, on the expressions the
window took whole in the cloud container (the census's own table's rows):

{{=census_rows(['expressions the window takes whole', '**the references the program', 'expressions with none', 'calls; through a value', 'expressions with a call of a function declared noreturn', 'conditions; with a known truth', 'roots with a constant integer value'])}}

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

- **the mask**: the flags tested against a table of what each kind of
  record needs, one shuffle and one test;
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
reading on the 9700X. So was a form that took the n-th end mark for the
n-th expression: a batch's expressions are in the walk's order, an `if`'s
condition after its body's, and not in the window's.

**The return fact.** The flow gives a call its own fact
(`check_program_return_call`): none where its callee, through `*` and `&`, is
the name of a function, a stop where that function is declared noreturn, and
an unknown for a call through a value or of a library's name the flow leaves
unknown. Facts go up the tree; an `&&`, an `||` or a `?:` keeps its
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
  of a function's name, so the window asks no such call):
  {{=three('suspects')}} of the three corpora's {{=three('swept')}} records
  swept, one record in {{=join([one_in(c) for c in CORPORA])}}.
- **An expression's fact is its calls' together**, since an unknown goes up
  through every operator and a stop through every one that selects no
  operand. Where a call stops and the expression has an `&&`, an `||` or a
  `?:`, the flow's own reduction runs over its records
  (`node_rows_summary_reduce`): {{='no expression' if all(v['final'][c]['reduced'] == 0 for c in CORPORA) else three('reduced') + ' expressions'}}
  of the three corpora and {{=cloud('main', 'reduced')}} of the compiler's
  own source.
- **A unit with a function unknown from a declaration on** (an
  `analyzer_noreturn`, an ignored `noreturn`:
  `check_program_return_unknowns`' table, made at the reader's start) has no
  plain call: each is asked, with its use's place.

**A condition's truth and a constant's fold** need nothing in the side
record. `check_program_branch_truth` knows a truth where a condition's value
has none in two cases, and the window lists both:

- **An `&&` or an `||` whose second operand's truth is known and decides**
  (`x && 0`, `x || 1`; one whose first operand's is known is C's to list
  already). The turns list an `&&` or an `||` whose second operand's truth is
  known, as branches or as a value: its standing's constant's kind, but an
  object's lvalue's. That leaves out {{=four('left_out')}} expressions the
  piece before took.
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
  lists {{='no expression' if all(v['cloud'][u]['passed'] == 0 for u in UNITS) else four('passed') + ' expressions'}}: the specification did not
  have this case, and a one-statement program found it (below).

The controls' fold does not fold a comma whose left operand is no constant,
and C lists a folded comma: every taken root with an integer constant folds
as a leaf of its value would.

**Not made: a `switch`'s selector's type.** The specification had it as a
third fact. `-Wswitch` does not read the selector's own type: it reads the
node at the selector's first token, which is the selector only where that
token is its root's ([#3200](https://github.com/buster14a/buster/issues/3200):
`switch (s->kind)` warns in clang and not here). A side type by the root
would answer another question than the pass asks, so a `switch`'s condition
stays the walk's: {{=census_cells('switch selectors', 0)}} of the taken
expressions.

**What the corpora did not have.** The four inputs, the fixtures and the
piece's own one-statement programs read no difference when the code was
first frozen. Two things run after that found two in it, and three in the
earlier pieces' code:

- **The earlier pieces' one-statement programs**, run again with the facts'
  comparison ({{=n(v['probes']['before'])}} programs;
  {{=n(v['probes']['cases'])}} with this piece's
  {{=n(v['probes']['piece'])}}): one of them, `if ((char)(long)&x)`, has a
  truth the walk knows and its value has not. The cast's term above is its
  fix.
- **A generator of random one-statement programs** through the shadow,
  whose exit status is the oracle (integer, pointer and floating operands of
  each operator, weighted toward constants, addresses and casts):
  {{=n(v['fuzz']['first']['programs'])}} programs on the first frozen code
  gave {{=n(v['fuzz']['first']['found'])}} that differ,
  {{=n(v['fuzz']['first']['truth'])}} by that cast and
  {{=n(v['fuzz']['first']['value'])}} by an entry's value on the window, an
  earlier piece's: `(_Bool)&x` is an integer's constant, 1, whose record
  still has x for its object, and the value's column took a record's object
  wherever it had one. It takes it where the record's constant is an
  address's now. The repository's own regression programs have that
  statement (`tests/checker/sources/0013.c`), and no corpus has.
- **The earlier pieces' three:** with a share of operands of the wrong
  kind the generator finds what the reader-time tests take with a
  warning (an ordered comparison of a pointer with an integer, a cast
  of an array or a function to a narrower integer:
  [#3201](https://github.com/buster14a/buster/issues/3201)), and the
  regression programs a `return` under a pending cleanup
  ([#3202](https://github.com/buster14a/buster/issues/3202)) and a
  multiversioned function's object
  ([#3203](https://github.com/buster14a/buster/issues/3203)). Those are
  filed and not this piece's; each is the first compile's to have closed.

On the code here the generator read
{{=n(sum(v['fuzz']['final']['variants'][s]['programs'] for s in ('61', '62', '63', '64')))}}
programs with operands of the right kind and
{{=n(sum(v['fuzz']['final']['variants'][s]['programs'] for s in ('65', '66')))}}
with a share of the wrong kind:
{{=n(sum(v['fuzz']['final']['variants'][s]['found'] for s in ('61', '62', '63', '64')))}}
and {{=n(sum(v['fuzz']['final']['variants'][s]['found'] for s in ('65', '66')))}}
differ, every one a take of the reader-time tests' with one of #3201's two
warnings{{=must(v['fuzz']['final']['unsound'] == v['fuzz']['final']['found'] and v['fuzz']['final']['classes']['neither'] == 0)}}
(the one of the right kind by a cast the generator wrote without its
parentheses). Of the {{=n(v['tests']['final']['programs'])}} regression
programs {{=n(v['tests']['final']['ran'])}} run through the shadow with no
option, and {{=n(v['tests']['final']['found'])}} end with status 1, #3202's
{{=n(v['tests']['final']['cleanup'])}} and #3203's
{{=n(v['tests']['final']['objects'])}}{{=must(v['tests']['final']['cleanup'] + v['tests']['final']['objects'] == v['tests']['final']['found'])}};
on main {{=n(v['tests']['main']['found'])}} do, the
{{=n(v['tests']['main']['rows'])}} more by that constant's value.

**How it came to its cost.** Builds on the 9700X, CPU 2, Release, one
executable with the facts and without them in each reading
(`--no-window-summaries`; TSC ticks, the timed region's own two timer reads
taken off):

{{file:builds}}

**Measured** (the 9700X, the code here, {{=v['final']['sqlite3']['runs']}}
readings, each the facts on, off twice and on again; a median and its least
and most):

{{file:table}}

A second set, {{=v['repeat']['sqlite3']['runs']}} readings of the same
executable (the repeat, below), reads the sweep at
{{=threev('sweep_second', 2, 'repeat')}} a record on a second run, the rows'
sweeps with the facts {{=threes('rows_all_second', 2, 'repeat')}} more, and
the tests' other parts {{=threes('tests_rest', 2, 'repeat')}}.

**Against its gates**

{{file:gates}}

**What stays a record at a time, and why**

{{file:scalar}}

**What it means**

{{file:means}}
