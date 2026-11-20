### An operator's value and a comma on the window

`&&` and `||` as values, `?:` and a comma were what C on the window listed
most after the entries' values: C decided no expression with one, and X made
no row of theirs. This piece makes them in both, in the sweeps that exist:
masks in C's loop, turns in the branches' loop, and the numbering by labels
([#2850's specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7049301495);
`measure-node-machine --shadow --window-rows`,
[the guide](commands/lowering.md#an-operators-value-and-a-comma-on-the-window-2850);
[the record](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/logical-values-2850-2026-11-20)).
No compile takes any of it.

**What the reference makes of them** (`node_machine_logical`,
`node_machine_classify`'s comma, `node_machine_hook`, `node_machine_own`).
An `&&`, an `||` or a conditional whose condition's truth is not known has two
labels, its alternate and its end. Its condition is a value converted to T's
conversion of it and tested after its row, with a branch to the alternate, or,
where an `&&` or an `||` is under its `!`s, it is evaluated as branches to
the alternate. A conditional's first arm is converted to the conditional's
type and then jumps to the end, where the alternate is placed; its second arm
follows. A logical operator's own row tests its second operand, jumps to the
end, and has its value at the alternate, 0 for `&&` and 1 for `||`. A record
whose consumer's conversion the tasks put into its arms (`node_machine_sinks`,
#2678) is left to them. A comma of a number's class passes its second
operand: its first is converted to void, and its second to the comma's type,
or to void where the comma's own target is void, which gives it the discard's
context and no conversion of its own.

**What the count before the specification found**
([the census](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/logical-values-census-2850-2026-11-20):
a line a record of every expression with such an operator, the reference's
answers and rows beside the window's bytes):

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| expressions with an `&&`, an `\|\|`, a `?:`, a comma or a selection | 3,133 | 876 | 2,002 |
| the window took already (a statement's condition as branches) | 2,047 | 200 | 792 |
| listed for one of these alone, and taken by the reference | 825 | 387 | 1,033 |
| candidate rules, simulated over the lines, take of them | 793 | 366 | 970 |

Of the listed records, 1,343 were conditionals, 743 commas and 434 an `||`'s
value. A conditional's condition is a tested value in 515 of `sqlite3.c`'s
525; its first arm is converted to another class in 44; 55 of Lua's and 26 of
musl's are of void's class. 368 of musl's `||`s are discarded,
`(void)(a || b)`.

**C: a comma.** A mask in the loop: a free record of a comma's class and a
number's has a wrapper's template. Its operands' rows are a key's of its own,
since a wrapper's give its operand the wrapper's type: its first operand to
void, a new source the targets' sweep writes; its second to the comma's type,
or to void where the comma is discarded. A comma is discarded where its
target is void, which is its consumer's to say with no chain: a comma's first
operand is; a wrapper's operand and a conditional's arm are where that
record's class is void's, a byte's load a comma. A comma that is a comma's
second operand has that comma's discard, a chain: it lists its expression, as
do a comma read for its address and a folded one, whose constant's template
has the discard's context.

**C: which operators are branches.** C says it from the root down. The loop
said it of a record by its consumer's class alone, and listed every `&&` and
`||` that was not under a branched operator or a statement's CONDITION; with
values to take, a record under an `&&` has to know whether that `&&` is
branches or a value. A record says it of itself:

- A **branch operator** is a `!`, an `&&` or an `||` that is no folded
  constant, and for the last two one whose first operand's truth is not
  known.
- It is **entered**, branched whatever its consumer is, where it is the first
  operand of an `&&` or an `||`: under a branched one it is its operand, and
  under a value's it is the value's condition, which is branches where an
  `&&` or an `||` is under its `!`s. A value whose first operand is a `!`
  lists its expression, since a `!` alone is no such condition.
- A `!` is **deep** where a branch operator `&&` or `||` is under it with
  `!`s alone between: the runs of `!` records right after such an operator's
  record, by one sum's carries (a `!`'s operand is the record before it). A
  deep record is entered too as a statement's CONDITION's operand, where the
  `!` lists (the CONDITION is branched itself, two levels away), and as a
  conditional's condition.
- It is **chained** where it is an `&&`'s or an `||`'s second operand or a
  `!`'s operand: it has its consumer's answer, and its consumer is the next
  record. The answers go down each run of chained records by two doubling
  steps of two masks, three records up, with a bit carried from the block
  after; a longer run lists its expression, and so does a block's last record
  that is a branch operator under a `!`, whose run the block after did not
  see.
- Any other is a **value**.

**C: an operator's value.** An `&&` or an `||` that is a branch operator and
a value, and a conditional of a number's class or of void's whose condition's
truth is not known, where the condition's conversion's type is one a truth's
entries test (and a logical operator's second operand's too), have the
template with two labels. A conditional's operands' rows are a key of its
own: its condition to T's conversion of it, its arms to its own type. Three
of C's terms are a record at a time, for these records alone, one record in
{{=three('valued_one_in')}} of those swept: a conditional of one operand
twice (`a ?: b`), the conversion its consumer puts into its arms
(`node_contexts_sinks`), and the same for a root, whose target its
expression's part gives. Each lists. The sinks' rule here is not the
reference's term by term. It is three of its terms: a target of another type
than the record's own, of an integer's class, and an arm that is a constant
(a logical operator's 0 or 1 is one; a conditional's arm is where it is an
integer constant). The reference asks more, each a term that takes: that the
conversion write entries, that it fold for these classes, and that the arm be
no lvalue, of an integer's class and with no effect. What those would take is
listed here: {{=n(v['xl2']['sqlite3']['counts on']['taken'] - v['final']['sqlite3']['counts on']['taken'])}} expressions of `sqlite3.c`, {{=count(v['xl2']['lua']['counts on']['taken'] - v['final']['lua']['counts on']['taken'])}} of Lua
and {{=n(v['xl2']['musl']['counts on']['taken'] - v['final']['musl']['counts on']['taken'])}} of musl, by the build before, which had the rule term by term
(the faults, below).

**Listed still:** a condition whose truth may be known (one operand is not
evaluated) and a folded conditional; a value whose first operand is a `!`; a
`!` over an `&&` or an `||` under a statement's CONDITION; a run of more than
three chained records, and a block's last record that is a branch operator
under a `!`; `a ?: b`; what the tasks sink and the little more the sinks'
rule lists with it; a comma read for its address, a folded one and a comma's
second operand that is a comma; and a selection.

**X: the turns.** The branches' loop goes down a list of the chunk's
operators evaluated as branches, and an operator's value is on it too
(`node_rows_window_held`):

- Its **condition** takes a tested value's segment, the shape that exists,
  with the sense of its operator (a branch where it holds for `||`, where it
  doesn't for the others) and its operator's label; a condition that is
  branches takes the sense for its own turn.
- A conditional's **first arm** has its jump after its conversion's entries,
  in that part's slots: a row of the table by whether the conditional is
  void's, whether the reads read the arm's target's class and the arm's
  conversion (none, a CONVERT, a DISCARD). An arm converted to bool leaves no
  slot: listed.
- A logical operator's **own row** is four entries, its own part: the test of
  its second operand's conversion's class, its JUMP_VALUE, and its CONST. A
  narrow class's test is one entry more: listed.
- A conditional's own part has no entry: its end's label is placed there.

**The labels.** An operator's value has two where an operator evaluated as
branches has one or none, so the numbering counts labels, and a holder's jump
has its first label's number and one. A call's row and a label are counted
apart: an expression with one operator with labels has the labels 0 and 1
whatever calls it holds, which the lists' loops write (a first arm is on the
list of the rows whose last entry's value is a fixed one, with a bit for its
1), and the numbering runs where an expression has two of one kind:
{{=three('numbered')}} of the tapes on the three corpora
({{=three('numbered_share','%')}}), where the piece before's ran on
{{=three('numbered_before')}}.

**How it came to its cost.** Three builds on the 9700X, CPU 2, Release, seven
readings each, against the piece before's executable in the same readings
(TSC ticks; the first two against #3197's head `8a7427df2`, the third against
main with it merged, `549613156`):

| build | expressions more taken: `sqlite3.c`; Lua; musl | C's loop, a record swept, more, a chunk's first run: `sqlite3.c`; Lua | its second run: `sqlite3.c`; Lua | C's sweeps' first run less their second, ticks a chunk, more: `sqlite3.c`; Lua |
| --- | ---: | ---: | ---: | ---: |
| the first: two more permutes a block, of the block's answers by the consumer's lane (a `!` that is not deep has its consumer's answer) and of its classes (a comma's consumer's, before the loop that reads its type); a comma's and a conditional's keys three blends in a row; the discard's context a blend | {{=more('xl1','sqlite3')}}; {{=more('xl1','lua')}}; {{=more('xl1','musl')}} | {{=rng('sqlite3',"C's loop",'xl1')}}; {{=rng('lua',"C's loop",'xl1')}} | {{=rng('sqlite3',"(a second run) C's loop",'xl1')}}; {{=rng('lua',"(a second run) C's loop",'xl1')}} | {{=rng('sqlite3',"C's sweeps: a chunk's first run less its second, ticks a chunk",'xl1')}}; {{=rng('lua',"C's sweeps: a chunk's first run less its second, ticks a chunk",'xl1')}} |
| the second: neither permute (a `!` under an operator is entered or chained as an `&&` is, and a value whose first operand is a `!` lists; every comma under a wrapper or an arm loads its consumer's byte), the three keys made beside the templates and placed in one step, a discarded comma's context a byte's store each, a block's edge listed from the block below | {{=more('xl2','sqlite3')}}; {{=more('xl2','lua')}}; {{=more('xl2','musl')}} | {{=rng('sqlite3',"C's loop",'xl2')}}; {{=rng('lua',"C's loop",'xl2')}} | {{=rng('sqlite3',"(a second run) C's loop",'xl2')}}; {{=rng('lua',"(a second run) C's loop",'xl2')}} | {{=rng('sqlite3',"C's sweeps: a chunk's first run less its second, ticks a chunk",'xl2')}}; {{=rng('lua',"C's sweeps: a chunk's first run less its second, ticks a chunk",'xl2')}} |
| the code: the second, with the terms the first fault round found implied taken out and the sinks' rule its three terms | {{=more('final','sqlite3')}}; {{=more('final','lua')}}; {{=more('final','musl')}} | {{=rng('sqlite3',"C's loop")}}; {{=rng('lua',"C's loop")}} | {{=rng('sqlite3',"(a second run) C's loop")}}; {{=rng('lua',"(a second run) C's loop")}} | {{=rng('sqlite3',"C's sweeps: a chunk's first run less its second, ticks a chunk")}}; {{=rng('lua',"C's sweeps: a chunk's first run less its second, ticks a chunk")}} |

A second run's readings fell with each build. The first runs' are too wide to
order the three builds: the third build's ranges hold the first's on Lua.

**Measured.** The 9700X, CPU 2, Release, each run its own hold of the lock,
TSC ticks, seven readings; in each reading the build, the piece before's
executable twice, and the build again:

{{file:table}}

**Against its gates.**

- **L1, exact: met.** No answer of C's and no entry of X's tape differs from
  the reference's on the three corpora on the 9700X
  ({{sqlite3|counts on|taken}}, {{lua|counts on|taken}} and {{musl|counts on|taken}} tapes), and no chunk's second run
  differs from its first. In the cloud container the same on the three and
  on the compiler's own source ({{=d('cloud','main','rows','taken')}} tapes of the {{=d('cloud','main','rows','x_expressions')}} expressions C
  takes there, of {{=d('cloud','main','rows','expressions')}}), with the default warnings and with `-Wall -Wextra`,
  {{=d('cloud','runs')}} runs. C's fixture has a function of these operators, a line a
  term ({{=d('fixture','valued')}} operators' values, {{=d('fixture','sunk')}} of them listed for their target, and
  {{=d('fixture','commas')}} commas, pinned). And {{=d('probes','all')}} one-statement programs, each a file of its
  own: {{=d('probes','new_cases')}} written for this piece (a comma under each consumer, discarded
  and not; a conditional with each arm's conversion and each kind of
  condition; `&&` and `||` as values with each operand; and nine statements
  whose answer is another record's, the next one's or a consumer's past a
  long operand, at each lane of a block), of which the window takes {{=d('probes','whole')}} whole, lists {{=d('probes','listed_c')}} in C and
  {{=d('probes','listed_x')}} in X and refuses {{=d('probes','refused')}} as the reference does, and the {{=n(v['derived']['probes']['values'] + v['derived']['probes']['earlier'])}} of the pieces
  before.
- **L2, how much: met on Lua, not on the other two.** {{=d('sqlite3','more_taken')}}, {{=d('lua','more_taken')}} and
  {{=d('musl','more_taken')}} expressions more are taken, C's answers and X's tape both, where
  780, 355 and 950 of the census's 825, 387 and 1,033 were asked: {{=d('sqlite3','short_of_asked')}} short
  on `sqlite3.c` and {{=d('musl','short_of_asked')}} on musl. The second build took {{=more('xl2','sqlite3')[1:]}}, {{=more('xl2','lua')[1:]}} and {{=more('xl2','musl')[1:]}}: what
  is short is what the sinks' rule lists since the first fault round (L6).
  On the compiler's own source, which the gate did not name, {{=d('own','more_taken')}}
  expressions more have their tape whole ({{=d('own','after','taken')}} for {{=d('own','before','taken')}}, the same source
  through main's build and the piece's), {{=d('own','after','sunk')}} of its {{=d('own','after','valued')}} operators' values
  are listed for their target, and X lists {{=d('own','after','x_listed_branches')}} expressions at a turn for {{=d('own','before','x_listed_branches')}}
  (an arm converted to bool and a second operand of a narrow class are what
  the piece lists there, and this source has `bool` where the corpora have
  `int`).
- **L3, work a record: met for the rows; C's reads +{{=f(float(val('sqlite3','(a second run) C, a record of the decided')))}} on `sqlite3.c`
  where 0.35 was asked.** A chunk's second run of the rows' sweeps reads
  {{=rng('sqlite3','(a second run) a record of the taken')}} ticks a record of the taken more than the piece
  before's on `sqlite3.c` (0.30 asked) and {{=rng('lua','(a second run) a record of the taken')}} on Lua (0.40). C's
  sweeps read {{=rng('sqlite3','(a second run) C, a record of the decided')}} a record of the decided on `sqlite3.c` and
  {{=rng('lua','(a second run) C, a record of the decided')}} on Lua (0.35 asked on either; 0.70 refutes). On musl,
  which the gate did not name, {{=rng('musl','(a second run) a record of the taken')}} and {{=rng('musl','(a second run) C, a record of the decided')}}.
- **L4, a chunk: met on `sqlite3.c` and musl by their medians, not on Lua.** The rows' sweeps' first
  run less their second rose by {{=rng('sqlite3',"the rows' sweeps: a chunk's first run less its second, ticks a chunk")}} ticks a chunk on `sqlite3.c`,
  {{=rng('lua',"the rows' sweeps: a chunk's first run less its second, ticks a chunk")}} on Lua and {{=rng('musl',"the rows' sweeps: a chunk's first run less its second, ticks a chunk")}} on musl (150 asked, 300
  refutes): by the medians it is met on `sqlite3.c` and musl, Lua's is
  between the two, and each corpus's range reaches past 300. **The gate named the rows' sweeps alone, and C's loop is where
  the piece's cost a chunk is:** C's sweeps' first run less their second
  rose by {{=rng('sqlite3',"C's sweeps: a chunk's first run less its second, ticks a chunk")}}, {{=rng('lua',"C's sweeps: a chunk's first run less its second, ticks a chunk")}} and {{=rng('musl',"C's sweeps: a chunk's first run less its second, ticks a chunk")}}.
- **L5, nothing else moves: not as written.** The rows' reads are within 0.2
  on `sqlite3.c` and Lua ({{=val('sqlite3','the reads')}} and {{=val('lua','the reads')}}; {{=val('musl','the reads')}} on musl). The kernel in place,
  whose source the piece does not touch, reads {{=rng('sqlite3','the kernel in place, a record')}}, {{=rng('lua','the kernel in place, a record')}} and
  {{=rng('musl','the kernel in place, a record')}}: less in every reading of `sqlite3.c`, and less in each of the
  three builds ({{=val('sqlite3','the kernel in place, a record','d','xl1')}} and {{=val('sqlite3','the kernel in place, a record','d','xl2')}} in the first two). The tests' sweeps read
  {{=rng('sqlite3','the tests on the window, a record')}}, {{=rng('lua','the tests on the window, a record')}} and {{=rng('musl','the tests on the window, a record')}}, on both sides of
  zero. A sweep with no change of its source reads a third of a tick or more
  apart between two builds here, which is the size of L3's margins: C's
  +{{=f(float(val('sqlite3','(a second run) C, a record of the decided')))}} against 0.35 is nearer than the readings can tell.
- **L6, faults: met, with five faults no test separates whose terms stay.**
  Two rounds: each entry of C's tables' new rows, each term of the loop's new
  masks and of the doubling steps, the comma's and the value's loops, the
  sinks' rule, the targets' source, each entry of the rows' new shapes and of
  the arms' table, each line of the turn, the write's second slot and the
  values' and the numbering's new terms, changed alone, a build and the
  fixture's tests a fault. The first round's {{=d('faults','round1')}} faults, run from the list's
  two ends at once (the 9700X and the cloud container), left {{=d('faults','round1_survived')}}.
  - {{=d('faults','taken_out')}} were terms that what makes the records implies, and are out of the
    code or in the fault's simpler form: the `!`s' mask on the seed of a
    deep `!`'s run; the last lane's mask on the chained records and the
    branched records' on the unreached runs; the address's bit in the
    conditional's mask, the value's and the comma's; a number's class in the
    logical value's (an int's, the checker's); the made commas' mask in the
    discard's and the placed records' in the commas' count; the void source's
    target in the sinks' step, which reads as none; the conditional's test
    beside `a ?: b`'s; the reads' test for the discard's context alone, where
    any context converts nothing; an arm's sense's other bits; the upper
    bound of a tested value's shapes in the numbering; and a comma's
    consumer's type, where its class's byte says the same.
  - {{=d('faults','sink')}} were terms of the sinks' rule as the first two builds had it, the
    reference's term by term on the window's bytes. The rule is three terms
    now, each with a fixture's line, and lists what the others would take
    (L2).
  - {{=d('faults','lined')}} found a line of the fixture or a pin to add, each caught in the
    second round: a folded conditional, a conditional and a value with a
    condition a truth's entries don't test, a value with such a second
    operand, a comma that is a conditional's condition, an `&&` the kernel
    didn't place, a target given by the second operand's conversion and one
    by the record's type, a narrow second operand of sixteen bits, and a
    turn of an operator that is not evaluated.
  - {{=d('faults','nothing')}} change nothing a program reaches.
  The second round's {{=d('faults','round2')}} faults, every one whose text changed, the new ones
  and the first's survivors, on the code as it is: {{=d('faults','round2_caught')}} caught, and {{=n(len(v['derived']['faults']['round2_survived']))}} that
  change nothing a program reaches, whose terms stay as the reference has
  them. A conditional's arms' target read from T's conversion of its second
  operand in place of its own type, by the table's row or by its template's
  key: T converts both arms to the conditional's type. The conditional's key
  given to every operator's value in the inner of two blends, whose outer
  mask is the conditional's and the comma's. The sinks' rule asked with no
  target, whose class is no integer's. And an arm's constant's kind read with
  its category's bits, an integer constant being no lvalue.

Beside the gates, as the specification asked, what the reference's C and X
read on the newly taken records against what the piece adds over all the
records swept:

{{file:beside}}

**What stays a record at a time, and why.**

- **In C's loop, one record in {{=three('asking_one_in')}} of those swept** (an operator's
  value or a comma): whether a comma's consumer is of void's class, a byte at
  its consumer's place; a discarded comma's context, a byte's store; and an
  operator's value's target's rule, which reads its target's type's class and
  two operands' standings. The first build had the vector's forms of the
  first two: a permute of the block's classes by the consumer's lane, in
  every block, before the commas' loop, and the discard's context as a blend
  (and a second permute, of the block's answers, for a `!`'s consumer's).
  The second, with neither permute and a byte's store a discarded comma,
  reads {{=f(float(val('sqlite3',"(a second run) C's loop",'d','xl2')) - float(val('sqlite3',"(a second run) C's loop",'d','xl1')))}} and {{=f(float(val('lua',"(a second run) C's loop",'d','xl2')) - float(val('lua',"(a second run) C's loop",'d','xl1')))}} ticks a record swept against it on a chunk's second
  run of C's loop (`sqlite3.c` and Lua; the two builds differ in their keys'
  blends too).
- **X's turn,** one an operator's value: its condition's segment, its arm's
  shape or its own row, each a byte or two at its operands' places. The
  updates' and the branches' lists and loops read {{=rng('sqlite3','the updates and the branches')}} ticks a
  record swept more on `sqlite3.c` a first run and {{=rng('sqlite3','(a second run) the updates and the branches')}} a second.
- **The numbering:** {{=three('numbered_share','%')}} of the tapes. A label is a preorder
  number in the expression's tree, as the reference numbers it.

**What it means.**

- **The operators' values and the commas are exact on the window,** and X's
  tapes are whole for {{sqlite3|counts on|taken}}, {{lua|counts on|taken}} and {{musl|counts on|taken}} expressions of the three corpora's
  {{sqlite3|counts on|expressions}}, {{lua|counts on|expressions}} and {{musl|counts on|expressions}}.
- **Their work a record is small on `sqlite3.c` and Lua:** a chunk's second
  run reads {{=val('sqlite3','(a second run) C, a record of the decided')}} and {{=val('lua','(a second run) C, a record of the decided')}} ticks a record of the decided more than the piece
  before's in C, and {{=val('sqlite3','(a second run) a record of the taken')}} and {{=val('lua','(a second run) a record of the taken')}} a record of the taken in the rows. On musl C's
  reads {{=val('musl','(a second run) C, a record of the decided')}}.
- **Their cost is by the chunk, and it is C's loop's.** The loop's step has
  the new masks in every block, and its first run over a chunk reads
  {{=val('sqlite3',"C's loop")}}, {{=val('lua',"C's loop")}} and {{=val('musl',"C's loop")}} ticks a record swept more where its second reads
  {{=val('sqlite3',"(a second run) C's loop")}}, {{=val('lua',"(a second run) C's loop")}} and {{=val('musl',"(a second run) C's loop")}}. Over all the records swept, a first run of the two
  sweeps adds {{=d('sqlite3','first_share')}}%, {{=d('lua','first_share')}}% and {{=d('musl','first_share')}}% of what the reference's C and X read on the
  newly taken records, and a second run {{=d('sqlite3','second_share')}}%, {{=d('lua','second_share')}}% and {{=d('musl','second_share')}}%. **On musl, whose
  chunks are {{=d('musl','records_a_chunk')}} records, a first run costs more than the reference's work
  it replaces.** What a chunk's first run pays is the window's cold start
  ([#3196](https://github.com/buster14a/buster/issues/3196)), which grew
  here with the masks the loop's step took on; the specification gated it
  for the rows' sweeps and not for C's.

**What is next:** a taken expression's references and events, the flip's
first piece (#2524's step 2), where the window's sweeps run in a compile and
their cost by the chunk is settled there.
