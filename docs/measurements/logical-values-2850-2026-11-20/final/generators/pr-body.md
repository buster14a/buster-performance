Part of #2850 (step 2). [The specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7049301495), [its census](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/logical-values-census-2850-2026-11-20), [the piece before](https://github.com/buster14a/buster/pull/3197), [the record](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/logical-values-2850-2026-11-20).

> **It is exact and its faults are caught. Of its other four gates none is met in full, and none is refuted by its median.** It takes 769, 360 and 949 expressions more where 780, 355 and 950 were asked (L2: 11 short on `sqlite3.c`, 1 on musl). A chunk's second run is within its gate for the rows, and C's reads +0.36 ticks a record of the decided on `sqlite3.c` where 0.35 was asked (L3). The rows' sweeps' cost a chunk is within its gate on `sqlite3.c` and musl by their medians and over it on Lua (+237; 150 asked, 300 refutes: L4). The kernel, which the piece does not touch, reads a third of a tick less (L5). **And the cost no gate named is the largest: C's sweeps' first run over a chunk, less their second, rose by 410, 630 and 373 ticks a chunk.** Over all the records swept, a first run of the two sweeps adds 86%, 61% and 154% of what the reference's C and X read on the newly taken records; a second run, 35%, 23% and 62%. On musl a first run costs more than the reference's work it replaces. The piece runs in the shadow alone, so no compile reads a tick more.

## What it is

`&&` and `||` as values, `?:` and a comma were what C on the window listed most: C decided no expression with one, and X made no row of theirs. This makes them in both (`measure-node-machine --shadow --window-contexts` and `--window-rows`), in the sweeps that exist, each compared with the reference's answers and tape. **No compile takes any of it.**

- **A comma is a mask in C's loop** (`node_contexts_window_loop`): a wrapper's template with a key of its own, its first operand converted to void (a new source the targets' sweep writes) and its second to the comma's type, or to void where the comma is discarded. Its consumer says whether it is: a comma's first operand is; a wrapper's operand and a conditional's arm are where that record is of void's class, a byte's load a comma.
- **Each record says of itself whether it is evaluated as branches.** The loop said it by a record's consumer's class alone and listed every `&&` and `||` under a value. Now a branch operator is entered (the first operand of an `&&` or an `||`; an `&&`, an `||` or a `!` over one as a CONDITION's operand or a conditional's condition), chained (an `&&`'s or an `||`'s second operand, a `!`'s operand: it has its consumer's answer, and its consumer is the next record) or a value. The answers go down a run of chained records by two doubling steps of two masks, with a bit carried from the block after.
- **An operator's value has the template with two labels**: an `&&` or an `||` that is a value, and a conditional whose condition's truth is not known, with a key of its own (its arms are converted to its own type). A record at a time, for these records alone: `a ?: b`, and whether the tasks put its consumer's conversion into its arms (`node_contexts_sinks`), asked of a root in its expression's part. Each lists.
- **X's turns** (`node_rows_window_held`): the branches' loop takes an operator's value's turn too. Its condition has a tested value's segment with the operator's label; a conditional's first arm has its jump after its conversion's entries, by a table of the part's shapes; a logical operator's own row is four entries.
- **The numbering counts labels**, two an operator's value, and counts them apart from the calls' rows: an expression with one operator with labels has the labels 0 and 1 whatever calls it holds. It runs on 0.86%, 3.10% and 2.65% of the tapes.
- **Listed still:** a condition whose truth may be known, a folded conditional, a value whose first operand is a `!`, a `!` over an `&&` or an `||` under a CONDITION, a run of more than three chained records, `a ?: b`, what the tasks sink (and the little more the rule lists with it), a comma read for its address, folded or a comma's second operand, an arm converted to bool, a logical operator's second operand of a narrow class, and a selection.
- **The shadow's report** has a line for them: `window contexts valued=N (P% of the records swept) of-them-listed-for-their-target=N commas=N`.

## Measured

The 9700X, CPU 2, Release, each run its own hold of the lock, TSC ticks, seven readings; in each reading the build, the piece before's executable twice, and the build again.

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| expressions C decides on the window; the piece before's | 50,109; 49,310 | 10,715; 10,079 | 42,776; 41,759 |
| **expressions whose tape X makes, whole; the piece before's** | **49,842**; 49,073 | **10,248**; 9,888 | **40,444**; 39,495 |
| more of them | +769 (1.51% of the expressions) | +360 (3.32% of the expressions) | +949 (2.19% of the expressions) |
| their records; the piece before's | 278,867; 268,942 | 70,873; 61,509 | 204,846; 188,250 |
| answers of C's; tapes of X's that differ from the reference's | 0; 0 | 0; 0 | 0; 0 |
| operators' values C takes; of them listed for their target; commas | 715; 98; 330 | 414; 7; 283 | 940; 49; 184 |
| listed for a logical operator or a conditional; the piece before's | 135; 674 | 22; 290 | 115; 964 |
| listed for a comma; the piece before's (a selection among them) | 0; 264 | 5; 376 | 0; 169 |
| listed for X by a turn (an arm with no room, a narrow second operand) | 3 | 0 | 0 |
| expressions numbered; the piece before's | 428; 474 | 318; 163 | 1,071; 635 |
| **C's sweeps, a record of the decided, a chunk's second run; the piece before's; more** | 6.79; 6.40; **+0.36 (+0.34 to +0.44)** | 7.25; 7.61; **-0.35 (-0.38 to -0.30)** | 12.31; 10.95; **+1.53 (+1.09 to +2.51)** |
| **the rows' sweeps, a record of the taken, a second run; the piece before's; more** | 7.30; 7.32; **-0.04 (-0.52 to +0.31)** | 8.83; 9.14; **-0.29 (-0.44 to +0.09)** | 15.74; 16.05; **-0.20 (-0.96 to +5.21)** |
| C's sweeps, a record of the decided, a first run; the piece before's; more | 9.02; 7.67; +1.22 (+1.12 to +1.83) | 13.09; 12.01; +1.02 (-0.14 to +2.36) | 34.48; 29.55; +4.93 (-0.79 to +17.16) |
| the rows' sweeps, a record of the taken, a first run; the piece before's; more | 10.15; 10.00; +0.15 (-0.33 to +1.44) | 16.00; 16.36; -0.46 (-0.99 to +5.09) | 43.61; 44.22; -2.18 (-7.98 to +21.59) |
| C's sweeps, a record swept: a first run, more; a second, more | +1.32 (+1.24 to +1.84); +0.52 (+0.50 to +0.59) | +2.41 (+1.59 to +3.50); +0.71 (+0.68 to +0.75) | +4.12 (+1.06 to +11.21); +1.38 (+1.15 to +2.04) |
| the rows' sweeps, a record swept: a first run, more; a second, more | +0.44 (+0.03 to +1.55); +0.19 (-0.21 to +0.50) | +1.34 (+0.95 to +5.60); +0.71 (+0.65 to +1.01) | +0.81 (-2.07 to +13.62); +0.59 (+0.18 to +3.54) |
| **the rows' sweeps, a first run less a second, ticks a chunk; the piece before's; more** | 1299; 1171; **+116 (-63 to +558)** | 2065; 1859; **+237 (+74 to +1876)** | 1884; 1778; **+63 (-505 to +1653)** |
| C's sweeps, a first run less a second, ticks a chunk; the piece before's; more | 1021; 552; +410 (+379 to +668) | 1800; 1159; +630 (+324 to +1051) | 1635; 1246; +373 (-42 to +1162) |
| the kernel in place, more; the tests on the window, more | -0.33 (-0.80 to -0.24); +0.21 (-0.17 to +0.39) | -0.36 (-2.67 to -0.12); -0.59 (-2.58 to +1.80) | -0.17 (-3.27 to +3.05); -4.12 (-5.91 to +5.21) |
| the reference's C, a record of the decided; its X, a record of the taken | 40.50; 25.80 | 36.84; 23.50 | 43.70; 28.97 |
| records a chunk; chunks | 526; 611 | 379; 241 | 127; 2,975 |

Beside the gates, as the specification asked: what the reference's C and X read on the newly taken records against what the piece adds over all the records swept.

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| records newly taken; of those taken before | 9,925; 3.7% | 9,364; 15.2% | 16,596; 8.8% |
| the reference's C and X, ticks a record of theirs | 66.30 | 60.34 | 72.67 |
| **the reference on the newly taken records, ticks** | **658,028** | **565,024** | **1,206,031** |
| the piece, C's sweeps and the rows', more a record swept: a chunk's first run; its second | +1.76; +0.71 | +3.75; +1.42 | +4.93; +1.97 |
| records swept | 321,434 | 91,252 | 377,187 |
| **the piece over all the records swept, a first run: ticks; of the reference's** | **565,724; 86%** | **342,195; 61%** | **1,859,532; 154%** |
| the same, a second run | 228,218; 35% | 129,578; 23% | 743,058; 62% |

How it came to its cost, a build a line (seven readings each; the first two against #3197's head `8a7427df2`, the third against main with it merged, `549613156`):

| build | expressions more taken: `sqlite3.c`; Lua; musl | C's loop, a record swept, more, a chunk's first run: `sqlite3.c`; Lua | its second run: `sqlite3.c`; Lua | C's sweeps' first run less their second, ticks a chunk, more: `sqlite3.c`; Lua |
| --- | ---: | ---: | ---: | ---: |
| the first: two more permutes a block, of the block's answers by the consumer's lane (a `!` that is not deep has its consumer's answer) and of its classes (a comma's consumer's, before the loop that reads its type); a comma's and a conditional's keys three blends in a row; the discard's context a blend | +789; +360; +958 | +1.34 (+1.04 to +1.49); +1.97 (+1.63 to +2.01) | +0.61 (+0.59 to +0.62); +0.65 (+0.62 to +0.83) | +495 (+342 to +602); +632 (+504 to +683) |
| the second: neither permute (a `!` under an operator is entered or chained as an `&&` is, and a value whose first operand is a `!` lists; every comma under a wrapper or an arm loads its consumer's byte), the three keys made beside the templates and placed in one step, a discarded comma's context a byte's store each, a block's edge listed from the block below | +785; +360; +955 | +0.91 (+0.62 to +1.06); +1.34 (+1.20 to +1.58) | +0.52 (+0.47 to +0.53); +0.54 (+0.51 to +0.65) | +302 (+158 to +395); +443 (+382 to +538) |
| the code: the second, with the terms the first fault round found implied taken out and the sinks' rule its three terms | +769; +360; +949 | +1.02 (+0.94 to +1.49); +1.94 (+1.44 to +2.94) | +0.44 (+0.35 to +0.48); +0.53 (+0.51 to +0.57) | +410 (+379 to +668); +630 (+324 to +1051) |

A second run's readings fell with each build. The first runs' are too wide to
order the three builds: the third build's ranges hold the first's on Lua.

## Against its gates

- **L1, exact: met.** No answer of C's and no entry of X's tape differs from
  the reference's on the three corpora on the 9700X
  (49,842, 10,248 and 40,444 tapes), and no chunk's second run
  differs from its first. In the cloud container the same on the three and
  on the compiler's own source (41,890 tapes of the 43,614 expressions C
  takes there, of 52,163), with the default warnings and with `-Wall -Wextra`,
  14 runs. C's fixture has a function of these operators, a line a
  term (470 operators' values, 18 of them listed for their target, and
  224 commas, pinned). And 6,414 one-statement programs, each a file of its
  own: 966 written for this piece (a comma under each consumer, discarded
  and not; a conditional with each arm's conversion and each kind of
  condition; `&&` and `||` as values with each operand; and nine statements
  whose answer is another record's, the next one's or a consumer's past a
  long operand, at each lane of a block), of which the window takes 857 whole, lists 70 in C and
  23 in X and refuses 16 as the reference does, and the 5,447 of the pieces
  before.
- **L2, how much: met on Lua, not on the other two.** 769, 360 and
  949 expressions more are taken, C's answers and X's tape both, where
  780, 355 and 950 of the census's 825, 387 and 1,033 were asked: 11 short
  on `sqlite3.c` and 1 on musl. The second build took 785, 360 and 955: what
  is short is what the sinks' rule lists since the first fault round (L6).
  On the compiler's own source, which the gate did not name, 2,417
  expressions more have their tape whole (41,890 for 39,473, the same source
  through main's build and the piece's), 2,712 of its 9,606 operators' values
  are listed for their target, and X lists 1,448 expressions at a turn for 560
  (an arm converted to bool and a second operand of a narrow class are what
  the piece lists there, and this source has `bool` where the corpora have
  `int`).
- **L3, work a record: met for the rows; C's reads +0.36 on `sqlite3.c`
  where 0.35 was asked.** A chunk's second run of the rows' sweeps reads
  -0.04 (-0.52 to +0.31) ticks a record of the taken more than the piece
  before's on `sqlite3.c` (0.30 asked) and -0.29 (-0.44 to +0.09) on Lua (0.40). C's
  sweeps read +0.36 (+0.34 to +0.44) a record of the decided on `sqlite3.c` and
  -0.35 (-0.38 to -0.30) on Lua (0.35 asked on either; 0.70 refutes). On musl,
  which the gate did not name, -0.20 (-0.96 to +5.21) and +1.53 (+1.09 to +2.51).
- **L4, a chunk: met on `sqlite3.c` and musl by their medians, not on Lua.** The rows' sweeps' first
  run less their second rose by +116 (-63 to +558) ticks a chunk on `sqlite3.c`,
  +237 (+74 to +1876) on Lua and +63 (-505 to +1653) on musl (150 asked, 300
  refutes): by the medians it is met on `sqlite3.c` and musl, Lua's is
  between the two, and each corpus's range reaches past 300. **The gate named the rows' sweeps alone, and C's loop is where
  the piece's cost a chunk is:** C's sweeps' first run less their second
  rose by +410 (+379 to +668), +630 (+324 to +1051) and +373 (-42 to +1162).
- **L5, nothing else moves: not as written.** The rows' reads are within 0.2
  on `sqlite3.c` and Lua (-0.05 and +0.06; -0.28 on musl). The kernel in place,
  whose source the piece does not touch, reads -0.33 (-0.80 to -0.24), -0.36 (-2.67 to -0.12) and
  -0.17 (-3.27 to +3.05): less in every reading of `sqlite3.c`, and less in each of the
  three builds (-0.29 and -0.45 in the first two). The tests' sweeps read
  +0.21 (-0.17 to +0.39), -0.59 (-2.58 to +1.80) and -4.12 (-5.91 to +5.21), on both sides of
  zero. A sweep with no change of its source reads a third of a tick or more
  apart between two builds here, which is the size of L3's margins: C's
  +0.36 against 0.35 is nearer than the readings can tell.
- **L6, faults: met, with five faults no test separates whose terms stay.**
  Two rounds: each entry of C's tables' new rows, each term of the loop's new
  masks and of the doubling steps, the comma's and the value's loops, the
  sinks' rule, the targets' source, each entry of the rows' new shapes and of
  the arms' table, each line of the turn, the write's second slot and the
  values' and the numbering's new terms, changed alone, a build and the
  fixture's tests a fault. The first round's 308 faults, run from the list's
  two ends at once (the 9700X and the cloud container), left 46.
  - 15 were terms that what makes the records implies, and are out of the
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
  - 18 were terms of the sinks' rule as the first two builds had it, the
    reference's term by term on the window's bytes. The rule is three terms
    now, each with a fixture's line, and lists what the others would take
    (L2).
  - 10 found a line of the fixture or a pin to add, each caught in the
    second round: a folded conditional, a conditional and a value with a
    condition a truth's entries don't test, a value with such a second
    operand, a comma that is a conditional's condition, an `&&` the kernel
    didn't place, a target given by the second operand's conversion and one
    by the record's type, a narrow second operand of sixteen bits, and a
    turn of an operator that is not evaluated.
  - 3 change nothing a program reaches.
  The second round's 55 faults, every one whose text changed, the new ones
  and the first's survivors, on the code as it is: 50 caught, and 5 that
  change nothing a program reaches, whose terms stay as the reference has
  them. A conditional's arms' target read from T's conversion of its second
  operand in place of its own type, by the table's row or by its template's
  key: T converts both arms to the conditional's type. The conditional's key
  given to every operator's value in the inner of two blends, whose outer
  mask is the conditional's and the comma's. The sinks' rule asked with no
  target, whose class is no integer's. And an arm's constant's kind read with
  its category's bits, an integer constant being no lvalue.

## What stays a record at a time, and why

- **In C's loop, one record in 308, 131 and 336 of those swept** (an operator's
  value or a comma): whether a comma's consumer is of void's class, a byte at
  its consumer's place; a discarded comma's context, a byte's store; and an
  operator's value's target's rule, which reads its target's type's class and
  two operands' standings. The first build had the vector's forms of the
  first two: a permute of the block's classes by the consumer's lane, in
  every block, before the commas' loop, and the discard's context as a blend
  (and a second permute, of the block's answers, for a `!`'s consumer's).
  The second, with neither permute and a byte's store a discarded comma,
  reads -0.09 and -0.11 ticks a record swept against it on a chunk's second
  run of C's loop (`sqlite3.c` and Lua; the two builds differ in their keys'
  blends too).
- **X's turn,** one an operator's value: its condition's segment, its arm's
  shape or its own row, each a byte or two at its operands' places. The
  updates' and the branches' lists and loops read +0.25 (+0.21 to +0.37) ticks a
  record swept more on `sqlite3.c` a first run and +0.08 (+0.06 to +0.17) a second.
- **The numbering:** 0.86%, 3.10% and 2.65% of the tapes. A label is a preorder
  number in the expression's tree, as the reference numbers it.

## What it means

- **The operators' values and the commas are exact on the window,** and X's
  tapes are whole for 49,842, 10,248 and 40,444 expressions of the three corpora's
  50,993, 10,839 and 43,415.
- **Their work a record is small on `sqlite3.c` and Lua:** a chunk's second
  run reads +0.36 and -0.35 ticks a record of the decided more than the piece
  before's in C, and -0.04 and -0.29 a record of the taken in the rows. On musl C's
  reads +1.53.
- **Their cost is by the chunk, and it is C's loop's.** The loop's step has
  the new masks in every block, and its first run over a chunk reads
  +1.02, +1.94 and +3.49 ticks a record swept more where its second reads
  +0.44, +0.53 and +1.24. Over all the records swept, a first run of the two
  sweeps adds 86%, 61% and 154% of what the reference's C and X read on the
  newly taken records, and a second run 35%, 23% and 62%. **On musl, whose
  chunks are 127 records, a first run costs more than the reference's work
  it replaces.** What a chunk's first run pays is the window's cold start
  ([#3196](https://github.com/buster14a/buster/issues/3196)), which grew
  here with the masks the loop's step took on; the specification gated it
  for the rows' sweeps and not for C's.

## Tests

`test-checker` part 5 of 8. C's fixture (`node_contexts_test_source`) has a function of these operators, `valued`, which the rows' fixture run reads too, a line a case of each term. **Commas:** discarded and not, nested either way, with a void operand on either side, of a pointer, under a qualified void, as a conditional's arm of either kind, after a store through an address, an aggregate's and a bit-field's, folded, in a `for` statement's clauses, with two calls, and as a void conditional's condition. **Conditionals:** arms converted and not, folded, to bool, of void's class with an arm of each kind, discarded; a condition of each class, branched, under a `!` and known; nested either way and beside one another; with calls; of pointers and of an aggregate; of one operand twice; a root's, taken and listed for its target; a statement's condition's, tested and owned; an arm whose conversion's type is not the conditional's; a condition and an operand of a type no truth's entries test; and what the tasks may sink, by each term of the rule. **`&&` and `||` as values:** of each class on either side, narrow ones among them; with an operator of either kind for an operand, on either side; under and over `!`s, by runs of each length; discarded; beside another; an argument; with a first operand whose truth is known; under a comparison in a condition; a root's; and one that is not evaluated. Conditions, commas and operands past two blocks, and six statements 64 times each for a block's every lane. `node_rows_test_tables` has the new shapes' rows, the arms' table and the values' bytes. The pins have the operators' values (470), those listed for their target (18) and the commas (224), beside the expressions decided, refused and numbered that the earlier pieces pinned.

## Checks

In the cloud container, on the code's commit `e93eb1e9c`, whose sources the first commit here has byte for byte:

- a native Release build; `test-checker`, all eight parts; the shadow with `--window-rows` and `--window-contexts` on `sqlite3.c`, Lua and musl and with `--window-rows` on the compiler's own source, with the default warnings and with `-Wall -Wextra` (14 runs, no difference); the shadow's other modes on `sqlite3.c` and Lua (22 runs); the self-check, the self-parse, `test-call-graph` and `check-call-graph`; the ownership check;
- the complete driver's lists and parse: 5 of 6 items pass. The one that does not is the preprocessor's comparison with clang, whose 45 differing units of 66 differ by where their line markers place a token and by no token (each one's count is clang's), as on the pieces before in this container;
- the sanitizers' native rows (memory, address and thread: a Release build each, `test-checker`'s part 5, and for memory and address the shadow with `--window-rows` on `sqlite3.c`, Lua and the compiler's own source): 12 of 12 steps with status 0, 0 reports.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

https://claude.ai/code/session_01EgbxneipucKBYgjW4XLXVp

---
Agent session: [private session](https://claude.ai/code/session_01EgbxneipucKBYgjW4XLXVp)
Model: Anthropic / claude-fable-5-2

---
_Generated by [Claude Code](https://claude.ai/code)_
