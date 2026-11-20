Part of #2850 (step 2). [The specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7043553775), [the piece before](https://github.com/buster14a/buster/pull/3191), [the record](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/x-values-2850-2026-11-20).

> **Four of the five gates are met, and the cost gate (V3) is refuted.** The specification asked at most 1.5 TSC ticks a record swept over the piece before's and set 2.5 as what refutes it. The rows' sweeps read +3.48 (+3.13 to +3.69) more on `sqlite3.c` and +4.78 (+4.28 to +4.91) on Lua. On musl, which the gate did not name and whose chunks are a quarter the size, they read +10.16 (+8.10 to +12.23) more, and the window's rows now cost more a record of the taken expressions than X on T's columns does (42.59 ticks for 28.64; 10.16 for 25.61 on `sqlite3.c`). [Where the piece stood](https://github.com/buster14a/buster/issues/2850#issuecomment-7045799975) said so before the fault rounds. The counters put a chunk's first run's cost in a cold start a chunk more than in work a record, which every sweep of the window pays: #3196 has it, and the one build the specification named against the loops that this piece did not make. The values run in the shadow alone, so no compile reads a tick more.

## What it is

An entry of X's tape is a kind, a class and a value, and X's rows on the window made the first two. This makes the third (`measure-node-machine --shadow --window-rows`): a quadword an entry, a stream beside the kinds' and the classes'. A tape the rows make is then whole, and every one is compared with X's on T's columns entry by entry, its value too. **No compile takes any of it.**

- **The stream starts as zeros and its sums' ones** (`node_rows_window_values`): 64 entries a step, a compare of their kinds with PTR_ADD's and eight masked stores.
- **Two columns hold what a loop would read of a line.** A record's value (`window_x_values`: its object's number where it has one, else its payload) is stored by the tests' sweep, which loads every record's line already; the rows' reads leave a member's offset in bytes there. A pointer's stride (`window_c_strides`) is kept by C's loop as it asks for it.
- **One sweep of masks makes the lists**, 64 records a step: a byte of a new table by a record's own shape (`NodeRowsTables.value_owns`) has a bit a list, and a list is the block's records' numbers under its bit, compressed. A loop a list then writes its values, each a load or two and a store at its row's place. The tested values with the control's label are the branches' loop's list, and the chunk's updates the updates' loop's.
- **The numbers of an expression** (`node_rows_window_number`). A call's row, an operator's own label and a postfix update's two temporaries are numbers in their expression, and its first of each is what the loops wrote. The sweep lists every record with such a value that is no first one of its expression by one subtraction a block, from two masks (those records, and the expressions' operands' last records, which the reader marks); each one's expression is numbered once, a record at a time, by the reference's rules: 0.97%, 1.65% and 1.61% of the tapes.
- **The shadow** compares each tape's values and counts the tapes that differ in a value alone; keeps a chunk's first run's values and lists' counts and compares its second run's with them; and times the values as a part of their own. Its control changes an entry's value in its turn, and one of a chunk's first run's answers in thirteen turns, so that both comparisons count everything they are given.

## Measured

The 9700X, CPU 2, Release, each run its own hold of the lock, TSC ticks, seven readings; in each reading one executable with the values on, off (an experiment's switch), the piece before's executable twice, then off and on again.

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| expressions C takes on the window | 49,155 | 9,909 | 39,712 |
| their tapes made here, whole | 49,073 (99.83%) | 9,888 (99.79%) | 39,495 (99.45%) |
| tapes that differ from X's on T's columns, in a value too | 0 | 0 | 0 |
| listed for a value | 0 | 0 | 0 |
| expressions numbered | 474 (0.97% of the tapes) | 163 (1.65% of the tapes) | 635 (1.61% of the tapes) |
| **the rows' sweeps and the part, a record swept** | **8.50 (8.27 to 8.66)** | **11.09 (10.98 to 11.58)** | **21.26 (19.89 to 22.95)** |
| the piece before's executable, in the same readings | 5.05 | 6.41 | 11.29 |
| **more than the piece before's** | **+3.48 (+3.13 to +3.69)** | **+4.78 (+4.28 to +4.91)** | **+10.16 (+8.10 to +12.23)** |
| with the values off; on less off | 5.15; +3.38 | 6.94; +4.19 | 13.81; +7.63 |
| with the values off, more than the piece before's | +0.12 (-0.04 to +0.21) | +0.49 (+0.20 to +0.75) | +2.53 (+0.98 to +3.72) |
| the values' part | 3.20 | 4.11 | 7.48 |
| a second run over the same chunk; the piece before's | 6.17; 4.05 | 6.17; 3.72 | 8.04; 4.83 |
| the values' part in it | 1.93 | 2.05 | 2.91 |
| the records' bytes, which make a record's value; on less off | 9.33; +0.30 | 11.88; +0.26 | 23.36; +0.42 |
| X on T's columns, a record of theirs | 25.61 | 23.69 | 28.64 |

How it came to its cost, a build a line (ticks a record swept, two or three readings each; the piece before's executable read 5.07 (5.03 to 5.21) and 6.43 (6.32 to 6.68) beside the last of them):

| build | `sqlite3.c`, the rows' sweeps with the values | the values' part: a first run; a second | Lua, the rows' sweeps | the values' part | the values' sweep's code, bytes |
| --- | ---: | ---: | ---: | ---: | ---: |
| first: seven lists, each loop reading its records' lines, and a pointer's type's row for its stride; an expression's marked records counted in its part | 9.51 (9.45 to 9.62) | 3.30; 2.13 | 11.84 (11.76 to 12.49) | 4.19; 1.89 | 4,290 |
| a record's value and a pointer's stride as two columns; the tested values' list from the branches' loop and the updates' from their own; an expression's later marked records by a subtraction a block; a member's offset, an update's step and its store's object written under a condition | 10.19 (10.09 to 10.63) | 4.04; 2.30 | 12.61 (12.61 to 13.00) | 5.42; 2.36 | 5,145 |
| those three written at a place chosen without a branch | 9.32 (9.24 to 9.39) | 4.06; 2.28 | 12.35 (12.34 to 12.36) | 5.56; 2.34 | 5,142 |
| the stream's start with its sums' ones, by the entries' kinds, and no list for the members; each loop's step in one copy, its columns' addresses loaded once; the numbering's expression from a column the reader writes, and its labels' walk over the operators' records alone | 8.25 (8.22 to 8.67) | 3.14; 1.86 | 11.01 (10.91 to 11.45) | 4.23; 1.89 | 3,537 |
| the fourth's with the columns' and the stream's lines asked for from the rows' write | 8.59 (8.48 to 8.87) | 3.11; 1.86 | 11.24 (11.16 to 11.45) | 4.24; 1.86 | 3,537 |
| the fifth's with the sweep compiled for size | 8.89 (8.82 to 8.97) | 3.43; 2.08 | 11.06 (11.03 to 11.13) | 4.20; 2.08 | 2,373 |

- **A value written where its record has one was a branch.** The second build's reads' loop left a member's
  offset in the record's value's place as `*value = member ? offset : *value`, and the updates' loop wrote an
  update's step and its store's object the same way. The compiler made each a store behind a branch on the
  record's kind, which no predictor learns: the reads read 2.65 to 2.76 ticks a record swept on `sqlite3.c` where the
  first build's read 1.67 to 1.76. The third build writes each at a place chosen by arithmetic, the record's own
  or one past the column's records that no one reads: 1.77 to 1.80.
- **The two columns and the lists moved read no better by themselves.** The third build's rows' sweeps read 9.32
  ticks a record swept on `sqlite3.c` for the first's 9.51, and 12.35 for 11.84 on Lua; its values' part more, 4.06 and
  5.56 for 3.30 and 4.19. Its stream started as zeros, with a list of the members that wrote each one's offset and its
  sum's 1, and its loops reached each column through the reader's state. The fourth starts the
  stream with the sums' ones by the entries' kinds, has a member's offset on the first list, and each loop's step
  in one copy (`unroll(disable)`): the values' part read 3.14 and 4.23, the rows' sweeps 8.25 and 11.01, and the
  sweep's code is 3,537 bytes for 5,142. The builds changed more than one thing at a time, and no reading is of the
  columns alone.
- **A chunk's first run pays a cold start, more than work a record.** A build that reads the processor's counters
  around the sweep (user mode, a chunk's average; `sqlite3.c` has 526 records a chunk and Lua 379): the sweep
  executes 4,313 to 4,429 instructions a chunk on `sqlite3.c` and 1,974 to 2,075 on Lua, the same in a chunk's two runs,
  in 1,898 to 2,284 cycles the first run and 1,262 to 1,323 the second (Lua: 1,795 to 2,316 and 931 to 961). The first run has
  18.9 to 22.7 mispredicted branches a chunk for the second's 10.6 to 12.0, 18.4 to 73.9 instruction-cache misses for
  2.7 to 27.4, and 631 to 1,594 cycles with the front end stalled for 231 to 364. No run of either corpus has more than
  0.1 TLB misses a chunk, data or instructions. The fourth build's ticks a chunk are nearly the same on the two
  (1,652 and 1,602) though `sqlite3.c`'s chunk has 39% more records. The rows' write, measured the same way,
  takes 835 to 843 cycles a chunk its first run and 683 to 686 its second on `sqlite3.c`.
- **Two builds that went after the cold start changed nothing.** Asking for the columns' and the stream's lines
  from the rows' write, the sweep before: the write read 1.19 and 1.79 for 0.92 and 1.50, and the values' part
  3.11 and 4.24 for 3.14 and 4.23. Compiling the sweep for size on top of that (2,373 bytes for 3,537): 3.43 and 4.20.
  Neither is in the code.

## Against its gates

- **V1, exact: met.** No tape made differs from X's on T's columns in its number of entries, a kind, a class or a
  value, on the three corpora on the 9700X (49,073, 9,888 and 39,495 tapes), and no chunk's second run differs from its
  first. In the cloud container the same on the three and on the compiler's own source (39,473 tapes of its 40,215
  expressions, 98.15%), with the default warnings and with `-Wall -Wextra`. The values' fixture has a line a source of a
  value (1,057 tapes), the rows' 1,166, C's 1,479 and two units of one chunk 3 each: with one of the reference's answers
  changed for each tape the comparison counts every one, and with one of a chunk's first run's answers changed every
  chunk's second run differs. And 5,447 one-statement programs, each a file of its own: 4,313 written for the values (a
  constant of each class, plain and folded; an address constant; a member; a pointer's sum, subscript and update; a
  store and an update by name and through an address; calls nested and side by side; conditions whose operators own
  a label; postfix updates through an address), 1,476 of the 5,447 with an expression numbered, and the 1,134 of the pieces
  before.
- **V2, how much: met.** Every expression whose rows the piece before made has its tape whole: none is listed for a
  value on the three corpora or the compiler's own source (0.5% refutes). The numbered expressions are the count's: 474,
  163, 635 and 479.
- **V3, cost: refuted.** The rows' sweeps and the part read +3.48 ticks a record swept more than the piece before's
  executable on `sqlite3.c` (+3.13 to +3.69) and +4.78 on Lua (+4.28 to +4.91); 1.5 was asked and 2.5 refutes. On musl, which the gate
  did not name, +10.16 (+8.10 to +12.23): its chunks are a quarter the size. The values' own part is 3.20, 4.11 and 7.48 of it;
  by the switch, on less off, the reads, which leave a member's offset, read +0.20 and +0.17 more on the first two, and the
  rows' write +0.02 and +0.02. With the values off the same executable reads +0.12 and +0.49 more than the piece before's, its
  two clock's reads around the sweep among them. A chunk's
  second run reads the whole +2.14 and +2.46 more than the piece before's, the values' part 1.93 and 2.05: the work a
  record is over what was asked with its code and its tables at hand, and a first run adds a cold start a chunk to it
  (1,683 ticks a chunk for 1,015 on `sqlite3.c`, 1,556 for 776 on Lua).
- **V4, nothing else moves: met.** By the switch, on less off, on `sqlite3.c` and Lua: the kernel in place -0.02 and -0.09;
  the tests' loop +0.01 and +0.02, their expression's part -0.01 and +0.01, their sweep on T's records +0.05 and +0.18; C's targets +0.03
  and +0.00, its expression's part +0.01 and -0.01. The two sweeps the piece gives work to: the records' bytes, which make a
  record's value, +0.30 and +0.26 a record of the tests', at the gate's bound, and C's loop, which keeps a stride, +0.04 and +0.05
  (0.3 asked).
- **V5, faults: met.** Two rounds: each entry of the values' tables, each term of the sweep's masks and of the later
  records' arithmetic, each loop's load, shift and store, the two lists made before the sweep, the columns' makers, each
  term of the numbering, and the shadow's comparisons and their control, changed alone, a build and the fixture's
  tests a fault. The first round's 352 faults, run from the list's two ends at once (the 9700X and the cloud container:
  51 faults by both, with the same verdict each), left 41.
  - Eight were terms no program separates, and are out of the code: an address's range beside the two variants that
    are within it; a record's constant's kind beside its object (X's own test is the object's, and a count found no
    record of the three corpora with an object and a constant that is no address's); a fold beside a floating
    class and the reads' mask beside a fold (a folded constant is an integer's with a target the reads read); the
    expressions' ends in the subtraction (a borrow that runs on stops at the next expression's first marked record,
    which no start is); and the numbering's test for two marked records (a count of its calls found none with fewer).
  - Five change nothing a program reaches, and are no faults: an object's number sign-extended (it is a token's
    index and one); an update's step's class read from the operation after it, which is of the same class; a
    destination's shape taken through the kept rows' rest's, which are a conversion's part's; an expression's marked
    records taken from its second record on, its first being a leaf; and an owned record with any conversion's part
    taken for a tested value, which a numbered expression has none of.
  - Seven were the shadow's own comparisons, which no test could fail. The control now changes a value's lowest bit and
    its highest, a tape's first entry's and its last's, and a value beside a class; and one of a chunk's first run's
    answers in thirteen turns, so that the second run's comparison counts every chunk.
  - Fourteen were in the later records' arithmetic, where a superfluous record on the list numbered nothing and changed
    no answer: the list's records are counted and pinned now.
  - Six got a line in the fixture, each run against its fault's build before the next round: an expression with two
    calls beside one C leaves; an operator with no label between a tested value and its owner; a member past 4 GB;
    a constant before an entry of a narrower class; a listed expression with two calls; and a call with no
    argument right after a condition. And one comparison had slack: a call's holder is one whose subtree starts no
    later than its own, where the code asked no later than its record.
  The second round's 89 faults, every one whose text changed, the new ones and the first's survivors, on the code as
  it is, are all caught.

## What stays a record at a time, and why

- **The lists' loops:** 0.48, 0.36 and 0.29 listed records a record swept. A value is a load from a column and a store at
  its row's place, which is the sum of two columns' bytes for its record: the places are no register's eight in a
  row, and a scatter is 88 micro-operations on Zen 5, one every 17 cycles ("SIMD and Zen 5" in the coding style).
  The vector makes the lists. The specification named two things to measure against the loops if they read over
  their gate. The first is in the code since the second build: a column of each record's one value (the rows'
  sweeps read 9.51 and 11.84 in the first build and 8.25 and 11.01 in the fourth). The second is not: the values
  written by slots as the kinds are, eight quadwords a register through a compress. What the counters say of the
  loops is that their work is not the cost a chunk's first run pays: the sweep executes the same instructions in
  both runs, and takes 1,898 to 2,284 cycles a chunk the first and 1,262 to 1,323 the second on `sqlite3.c`.
  [#3196](https://github.com/buster14a/buster/issues/3196) has that cold start, for every sweep of the
  window, and the by-slots build as what to measure there.
- **The numbering:** 0.97%, 1.65% and 1.61% of the tapes. A call's row and a label are preorder numbers in the
  expression's tree, and the reference numbers them a record at a time too. The sweep finds those expressions with
  no test an expression: one subtraction a block.

## Tests

`test-checker` part 5 of 8. The values' fixture (`node_rows_test_values_source`) has a line a source of a value: a constant of each class, its own and folded (extended, cut, to bool), one before an entry of a narrower class, a floating one's and its zeros; an object's number read, stored and updated, a local's, a parameter's and a global's; an address constant with and without an object and an offset; a member's offset, and one past 4 GB; a pointer's stride of each element, one past 4 GB, and its update's; an update's step of each class; one, two and three postfix updates through an address; calls nested, side by side, in a callee, not evaluated, with no argument right after a condition, in an expression C leaves between two it takes and in one the rows list; conditions whose operators own a label, two and three of them, with calls and postfix updates as their tested values and with an operator that has no label between a tested value and its owner; expressions of more than 64 records with their numbered records on either side of the first 64; a postfix update with no room after a statement whose tape is made; and seven statements 64 times each, for a block's every lane. `node_rows_test_tables` has the values' two tables' bytes by a record's own shape. The pins have each list's records, the expressions numbered, their walks' records and each fixture's chunks. The control counts every tape with one of the reference's answers changed (an entry's value among them: its first's and its last's, a low bit and a high one), and every chunk with one of its first run's answers changed.

## Checks

In the cloud container, on the code's commit `c6f230d87`:

- a native Release build; `test-checker`, all eight parts; the shadow with `--window-rows` and `--window-contexts` on `sqlite3.c`, Lua and musl and with `--window-rows` on the compiler's own source, with the default warnings and with `-Wall -Wextra` (14 runs, no difference); the shadow's other modes on `sqlite3.c` and Lua (22 runs); the self-check, the self-parse, `test-call-graph` and `check-call-graph`; the ownership check;
- the complete driver's lists and parse: 5 of 6 items pass. The one that does not is the preprocessor's comparison with clang, whose 45 differing units of 66 differ by where their line markers place a token and by no token (each one's count is clang's), as on the piece before's commit in this container;
- the sanitizers' native rows (memory, address and thread: a Release build each, `test-checker`'s part 5, and for memory and address the shadow with `--window-rows` on `sqlite3.c`, Lua and the compiler's own source): 12 of 12 steps with status 0, no report. The second commit changes three comments in the sources and no code.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

https://claude.ai/code/session_01EgbxneipucKBYgjW4XLXVp

---
Agent session: [private session](https://claude.ai/code/session_01EgbxneipucKBYgjW4XLXVp)
Model: Anthropic / claude-fable-5-2

---
_Generated by [Claude Code](https://claude.ai/code)_
