# An operator's value and a comma on the window (buster#2850's step 2), 2026-11-20

The evidence for the piece that makes `&&` and `||` as values, `?:` and a comma on the front's window, in the node
machine's C (a record's context, target and template) and in its X (the rows' entries), where both listed them:
[its specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7049301495), and the census before
it, [logical-values-census-2850-2026-11-20](../logical-values-census-2850-2026-11-20/). The piece before is
[x-values-2850-2026-11-20](../x-values-2850-2026-11-20/). Nothing here is in a compile: every reading is the
shadow's (`measure-node-machine --shadow --passes 0 --window-rows`), which runs the window's sweeps beside the
reference, C and X on T's columns at reader time, and compares.

The code is buster `e93eb1e9c`'s, which is main `549613156` with `final/9700x/xl3.patch` (the cloud checks ran
on that commit; the pull request's first commit has its sources byte for byte).

## 1. The builds (`builds/`)

Three builds were read on the 9700X, each by `builds/job-xl.sh LABEL PATCH REVISION RUNS BASE SUFFIX`: a Release
build of PATCH on REVISION (`build-label.sh`), the piece before's executable (BASE, REVISION as it is), and in each
of RUNS readings the build, the piece before's twice, and the build again, on `sqlite3.c`, Lua 5.4.8's 34 files and
musl's 1,336 units (`turns.sh`, `turns-env.sh`, `corpora.sh`), CPU 2, each run its own hold of the lock
(`lock.sh`). A reading's file is `results/LABEL/TAG-CORPUS-SUFFIX-N.txt`, the shadow's own report.
`xl-table.py results LABEL BASE SUFFIX` makes a build's table: a line's median of the seven readings of the build
(the mean of its two runs a reading), of the piece before's, and of their difference a reading, each with its
lowest and highest.

| build | its patch | on | against | its table |
| --- | --- | --- | --- | --- |
| the first | `builds/xl1.patch` | `8a7427df2` (#3197's head) | the same revision, `xlb` | `builds/xl1/table.txt` |
| the second | `builds/xl2.patch` | `8a7427df2` | `xlb` | `builds/xl2/table.txt` |
| the code | `final/9700x/xl3.patch` | `549613156` (main, #3197 merged) | `xlm` | `final/9700x/table.txt` |

| build | expressions more taken: `sqlite3.c`; Lua; musl | C's loop, a record swept, more, a chunk's first run: `sqlite3.c`; Lua | its second run: `sqlite3.c`; Lua | C's sweeps' first run less their second, ticks a chunk, more: `sqlite3.c`; Lua |
| --- | ---: | ---: | ---: | ---: |
| the first: two more permutes a block, of the block's answers by the consumer's lane (a `!` that is not deep has its consumer's answer) and of its classes (a comma's consumer's, before the loop that reads its type); a comma's and a conditional's keys three blends in a row; the discard's context a blend | +789; +360; +958 | +1.34 (+1.04 to +1.49); +1.97 (+1.63 to +2.01) | +0.61 (+0.59 to +0.62); +0.65 (+0.62 to +0.83) | +495 (+342 to +602); +632 (+504 to +683) |
| the second: neither permute (a `!` under an operator is entered or chained as an `&&` is, and a value whose first operand is a `!` lists; every comma under a wrapper or an arm loads its consumer's byte), the three keys made beside the templates and placed in one step, a discarded comma's context a byte's store each, a block's edge listed from the block below | +785; +360; +955 | +0.91 (+0.62 to +1.06); +1.34 (+1.20 to +1.58) | +0.52 (+0.47 to +0.53); +0.54 (+0.51 to +0.65) | +302 (+158 to +395); +443 (+382 to +538) |
| the code: the second, with the terms the first fault round found implied taken out and the sinks' rule its three terms | +769; +360; +949 | +1.02 (+0.94 to +1.49); +1.94 (+1.44 to +2.94) | +0.44 (+0.35 to +0.48); +0.53 (+0.51 to +0.57) | +410 (+379 to +668); +630 (+324 to +1051) |

A second run's readings fell with each build. The first runs' are too wide to
order the three builds: the third build's ranges hold the first's on Lua.

What changed between them:

- **The first to the second** (C's loop alone; the rows' code is the same). The first had two more permutes a
  block: the block's answers by each record's consumer's lane, for a `!` that is not over an `&&` or an `||`,
  whose answer is its consumer's; and the block's classes by the consumer's lane, to ask a comma's consumer's
  class before the loop that read its type. The second has neither: a `!` under an operator is entered or chained
  as an `&&` is, and a value whose first operand is a `!` lists; every comma under a wrapper or an arm loads its
  consumer's byte. A comma's and a conditional's keys were three blends in a row on the templates' register; the
  second makes the three keys beside the templates and places them in one blend. A discarded comma's context was a
  second blend into the contexts' register; the second stores a byte a discarded comma. And a `!` at a block's
  first lane read the operator of the record below it, a load a block, to list a run that starts in the block
  below; the second lists it from below, the block's last record that is a branch operator under a `!`.
- **The second to the code:** the first fault round's changes (section 2).

## 2. The fault rounds (`faults/`)

`make-faults-logical.py` writes a round's list, `faults-logical-round1.py` (308 faults) and
`faults-logical-round2.py` (282, of which the second round ran the 55 in `round2-indices.txt`: every one whose
text changed, the new ones and the first round's survivors). A fault is one edit of the piece's code; a round is,
a fault, a Develop build and `test-checker --seed 133 --part 5/8`, with every fault syntax-checked first
(`syntax-check.sh`). Each round ran from the list's two ends at once: the 9700X from the first up
(`job-faults-values.sh` with `xlf1.patch` and `xlf2.patch`, the code of each round; `dev-mutant*.sh`), and the
cloud container from the last down (`local-round.sh`); `join-round.py` joins them by name (`roundN/9700x.txt`,
`roundN/cloud.txt`, `roundN/joined.txt`), and `account.py` counts them and says what became of each of the first
round's survivors (`final/generators/faults.json`).

| | faults | caught | survived |
| --- | ---: | ---: | ---: |
| the first round | 308 | 262 | 46 |
| the second round | 55 | 50 | 5 |

The first round's 46: 15 terms taken out of the code or left in the fault's simpler form, 18 of the rule for a
conversion the tasks put into an operator's arms as the first two builds had it, 10 that found a line of the
fixture or a pin to add (each caught in the second round), and 3 that change nothing a program reaches. The
pull request's description names each. The second round's survivors, which change nothing a program reaches:
`key-conditional-every-value, key-conditional-its-template, sinks-first-arm-any-bit, sinks-no-target-too, table-conditional-arm-given`.

**The rule for the tasks' conversions** (`node_contexts_sinks`). The first two builds had the reference's
`node_machine_sinks` term by term on the window's bytes. 18 of its terms' faults survived the first round: no
line of the fixture separated them. It is three terms now, each with a line, and lists what the others would
take: the code's build takes 16, 0 and 6 expressions fewer than the second on `sqlite3.c`, Lua and musl, and
lists 16, 0 and 6 more records for their target.

## 3. The probes (`probes/`)

`probes/cases21.py` is 966 one-statement programs written for this piece and a baseline (the same function
with an empty statement), each a file of its own run through the shadow by `probe.py`, which asks that no answer
and no entry differ from the reference's and that no chunk's second run differ from its first:

- a comma under each consumer, discarded and not, of each class, nested either way;
- a conditional with each arm's conversion and each kind of condition, of void's class, nested, as an argument;
- `&&` and `||` as values with each operand's class, with operators for operands, under and over `!`s;
- mixes of them (`plain`): operators' values nested either way and beside one another, under runs of `!`s, with
  conditionals, commas, stores and calls for operands, as values and in a statement's condition;
- nine statements whose answer is another record's, the next one's or a consumer's past a long operand, each
  after 0 to 69 padding statements of three records, so that each of its records lands on every lane of a block
  and each run of chained records crosses a block's end (`edge_not`, `chain`, `value_chain`, `discard`,
  `void_arm`, `shallow`, `held`, `held_far`, `comma_far`).

`probes/final/` is their run on the code's build (`compiler.sha256`), with every earlier piece's
(`values/`, `earlier/`): 6,414 lines, 0 that do not agree (`summary.txt`). `probe-summary.py` sorts the
piece's by what the window makes of each statement beside the baseline's (`summary21.txt`): 857 taken whole,
70 listed by C, 23 listed by X and 16 refused as the reference refuses.

## 4. The final readings, and the checks (`final/`)

**The readings** (`final/9700x/`): `job-xl.sh xl3 xl3.patch 549613156 7 xlm -xl3` (`job-xl3.log`;
`results/xl3` and `results/xlm`, 84 runs, 0 without status 0; `table.txt`).

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
| C's loop, a record swept: a first run; the piece before's; more | 4.41; 3.30; +1.02 (+0.94 to +1.49) | 7.20; 5.21; +1.94 (+1.44 to +2.94) | 13.99; 11.21; +3.49 (+1.58 to +11.31) |
| C's loop, a second run; the piece before's; more | 2.87; 2.42; +0.44 (+0.35 to +0.48) | 3.20; 2.67; +0.53 (+0.51 to +0.57) | 3.99; 2.79; +1.24 (+1.05 to +1.38) |
| C's targets; its expression's part: more | -0.01; +0.33 | -0.08; +0.56 | -0.13; +0.60 |
| the rows' reads; shapes; write: more | -0.05; +0.01; +0.08 | +0.06; +0.03; +0.08 | -0.28; -0.31; +0.31 |
| the updates' and the branches' lists and loops: a first run; the piece before's; more | 1.11; 0.87; +0.25 (+0.21 to +0.37) | 1.50; 1.06; +0.41 (+0.21 to +1.41) | 2.45; 1.91; +0.60 (+0.29 to +2.28) |
| the values: a first run; the piece before's; more | 3.35; 3.15; +0.22 (-0.12 to +0.26) | 5.18; 4.14; +1.04 (+0.95 to +1.07) | 10.05; 8.76; +0.88 (-1.73 to +3.63) |
| the values, a second run; the piece before's; more | 1.93; 1.85; +0.10 (+0.03 to +0.14) | 2.37; 1.90; +0.47 (+0.44 to +0.55) | 2.56; 2.44; +0.13 (+0.11 to +1.04) |
| the kernel in place, more; the tests on the window, more | -0.33 (-0.80 to -0.24); +0.21 (-0.17 to +0.39) | -0.36 (-2.67 to -0.12); -0.59 (-2.58 to +1.80) | -0.17 (-3.27 to +3.05); -4.12 (-5.91 to +5.21) |
| the reference's C, a record of the decided; its X, a record of the taken | 40.50; 25.80 | 36.84; 23.50 | 43.70; 28.97 |
| records a chunk; chunks | 526; 611 | 379; 241 | 127; 2,975 |

**Against the specification's gates:**

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

Beside the gates, what the reference's C and X read on the newly taken records against what the piece adds over
all the records swept (`final/generators/beside.py`):

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| records newly taken; of those taken before | 9,925; 3.7% | 9,364; 15.2% | 16,596; 8.8% |
| the reference's C and X, ticks a record of theirs | 66.30 | 60.34 | 72.67 |
| **the reference on the newly taken records, ticks** | **658,028** | **565,024** | **1,206,031** |
| the piece, C's sweeps and the rows', more a record swept: a chunk's first run; its second | +1.76; +0.71 | +3.75; +1.42 | +4.93; +1.97 |
| records swept | 321,434 | 91,252 | 377,187 |
| **the piece over all the records swept, a first run: ticks; of the reference's** | **565,724; 86%** | **342,195; 61%** | **1,859,532; 154%** |
| the same, a second run | 228,218; 35% | 129,578; 23% | 743,058; 62% |

**The cloud container's checks** (`final/cloud-checks/`, on `e93eb1e9c`; `progress.txt`): a native Release
build (`build.log`); `test-checker --seed 133`, 8 of 8 parts with status 0 (`test-checker/`); the shadow with
`--window-rows` and `--window-contexts` on `sqlite3.c`, Lua and musl and with `--window-rows` on the compiler's
own source, with the default warnings and with `-Wall -Wextra` (`shadow/`, 14 runs, 0 without status 0); the
shadow's other modes on `sqlite3.c` and Lua (`modes/`, 22 of 22 runs with status 0); the self-check, the
self-parse, `test-call-graph`, `check-call-graph` and the ownership check; and the complete driver's lists
(`complete-lists/`, `complete-light.log`, `complete-heavy.log`): 5 of 6 items pass, and the one that does not
is the preprocessor's comparison with clang, whose 45 differing units of 66 differ by where their line markers
place a token (the container's clang's resource directory is spelled two ways) and by no token.

**The compiler's own source, before and after** (`final/cloud-checks/own/`: `run.sh`, the piece's tree's source
through main `549613156`'s build and through the piece's, with the default warnings and with `-Wall -Wextra`,
which read the same). The window decides 45,074 of 52,163 expressions (86.41%) where it decided
41,541 (79.64%), and X makes 41,890 tapes whole where it made 39,473: 2,417 more, 4.63% of the
expressions. 9,606 records are operators' values, 2,712 of them listed for their target; C lists 4,338
expressions for a logical operator or a conditional where it listed 7,932; and X lists 1,448 expressions at a
turn where it listed 560. This piece's two listings at a turn are an arm converted to bool and a logical
operator's second operand of a narrow class, and the compiler's own source has `bool` where the three corpora
have `int`.

**The sanitizers** (`final/cloud-sanitizers/`, `sanitizers-parts.sh`, on the same commit): the native rows,
memory, address and thread: a Release build each, `test-checker`'s part 5, and for memory and address the shadow
with `--window-rows` on `sqlite3.c`, Lua and the compiler's own source: 12 of 12 steps with status 0,
0 reports (`progress.txt`).

## 5. The generators (`final/generators/`)

No number of the write-ups is typed: `pr/gen.sh` runs `values.py` (the three builds' tables into `values.json`),
`derive.py` (the gates' counts, the cost beside the reference's, the probes', the faults', the cloud runs' and the
fixture's, into `all.json`), `table.py` and `beside.py` (the tables), and `fill.py` over each template: the two
design sections (`node-machine-section.md`, `one-core-path-section.md`, placed by `apply-docs.py`), the pull
request's description (`pr/body-template.md`, with parts of the design section by `pr/extract.py`), the result
note (`pr/result-note-template.md`) and this file (`pr/readme-template.md`). A placeholder that names nothing fails
the run.
