# The branches' rows on the window (buster#2850's step 2), 2026-11-20

The evidence for the piece that makes, on the front's window, what the node machine's X sweep writes for a statement's
condition evaluated as branches (`node_machine_classify_branches`'s states and `node_machine_branch_hook`'s entries):
a tested value's test and its branch. The piece before it is
[x-update-rows-2850-2026-11-20](../x-update-rows-2850-2026-11-20/), and the census its specification reads again is
[x-rows-census-2850-2026-11-19](../x-rows-census-2850-2026-11-19/).

## 1. Before the specification (`before/`)

**What the piece before left listed** (`before/before-counts.py` on that piece's final runs on the 9700X,
`../x-update-rows-2850-2026-11-20/final/9700x/xu8/rows-on1-CORPUS-1.txt`):

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| expressions C takes on the window | 49,155 | 9,909 | 39,712 |
| their tapes made today | 47,027 (95.67%) | 9,689 (97.78%) | 38,705 (97.46%) |
| **listed for X, first for an operator evaluated as branches** | 2,046 | 200 | 790 |
| the records C's loop evaluates as branches | 5,613 (1.75% of the records swept) | 570 (0.62% of the records swept) | 2,364 (0.63% of the records swept) |
| of them a statement's CONDITION | 2,198 | 230 | 877 |
| listed first for an update; a refused conversion; a constant to a floating class | 73; 1; 8 | 10; 0; 10 | 4; 20; 193 |

**One count, on the piece before's code** (`before/count.patch` on main `903bf7ef4`: that piece's source and, in its
shadow's loop over the listed expressions, a line of counts at exit). Of the expressions the rows list first for a
record evaluated as branches: those another record lists for another reason; and of the others, their records
evaluated as branches, the values those test (an operand of such a record that is none itself), and of those values
how many have a conversion's part of their own, a narrow class, each number of own entries and a row over eight
entries with the test's three or four. A Develop build on the 9700X (`before/dev-xr-develop.sh`), then
`measure-node-machine --shadow --passes 0 --window-rows` on `sqlite3.c`, Lua and musl, CPU 2, each run its own hold of
the lock (`before/dev-xr-corpora.sh`): `before/corpus-CORPUS.txt` are the runs' outputs and `before/9700x-count.txt`
their lines of counts, in the corpora's order. The compiler's own source's line is the cloud container's
(`before/cloud-own-count.txt`; `before/count-own.patch` has one count more, the expressions with a row over eight).
`before/count-table.py` makes the table; its rows after the second are of the expressions no other record lists:

| | `sqlite3.c` | Lua | musl | the compiler's own source |
| --- | ---: | ---: | ---: | ---: |
| **listed for X, first for a record evaluated as branches** | 2,046 | 200 | 790 | 3,217 |
| of them with another record that lists them | 0 | 1 | 0 | 0 |
| their records evaluated as branches; of them roots | 5,126; 2,046 | 465; 199 | 2,102; 790 | 8,668; 3,217 |
| the values those test | 4,860 | 428 | 1,814 | 7,941 |
| with a conversion's part of their own | 0 | 0 | 0 | 759 |
| of a narrow class (the test has four entries, and three otherwise) | 227 | 5 | 122 | 2,296 |
| own entries: none; one; two; three; four | 0; 4,509; 39; 312; 0 | 0; 419; 0; 9; 0 | 0; 1,651; 107; 56; 0 | 0; 7,645; 16; 280; 0 |
| a row over eight entries with the test; the expressions with one | 0; 0 | 0; 0 | 0; 0 | 759; 559 |

**The values with a conversion's part of their own** are a `const` bool's reads, which the lowering converts to bool
by four entries (a CONVERT to I32, a CONST, NE and a CONVERT to U8) before the test's four. One-statement programs
through the count's build (`before/probes/p1.c` to `p5.c`, `before/const-bool-probes.txt`): a `const _Bool`
parameter's and a `_Bool` member's through a pointer to const have the part, and a `_Bool`'s, a `char`'s and a
comparison's do not.

**The census's lines again** (`before/tested-values.py` on `../x-rows-census-2850-2026-11-19/second/census-*.tsv`: X
on T's columns, every expression it takes, where the count above is of those C takes on the window):

| | `sqlite3.c` | Lua | musl | the compiler's own source |
| --- | ---: | ---: | ---: | ---: |
| values an operator evaluated as branches tests | 4,970 | 607 | 1,994 | 9,367 |
| with a conversion before the test | 0 | 0 | 0 | 1,009 |
| the test and the branch: three entries | 4,740 | 600 | 1,867 | 6,629 |
| four (a narrow class's) | 230 | 7 | 127 | 2,738 |
| another number | 0 | 0 | 0 | 0 |
| own entries: 0 | 3 | 36 | 19 | 6 |
| own entries: 1 | 4,611 | 560 | 1,805 | 9,012 |
| own entries: 2 | 41 | 0 | 109 | 21 |
| own entries: 3 | 315 | 11 | 61 | 328 |
| own entries: 4 | 0 | 0 | 0 | 0 |
| rows over eight entries | 0 | 0 | 0 | 1,009 |
| a branch of kind 37 | 1,059 | 114 | 549 | 1,768 |
| a branch of kind 36 | 3,911 | 493 | 1,445 | 7,599 |
| operators evaluated as branches | 5,223 | 621 | 2,260 | 9,646 |

`before/gen-spec.py` made [the specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7037879405)'s
text of these lines (`before/spec-template.md`; `before/specification.md` is the text as posted). What the counts
found of a `const` bool's read is [buster14a/buster#3185](https://github.com/buster14a/buster/issues/3185).

## 2. The builds, and how it came to its cost (`builds/`)

Five builds before the fault rounds (`builds/9700x/xbN/`, each with its patch on main `00faef7dd`'s lineage,
`xbNx.patch`: the piece's source at that point and an experiment's switch, `BUSTER_TESTS_SKIP=1`, with which the
branches' template lists its expression and the sweep makes no second list, as the piece before had it).
`builds/job-xb.sh` builds one and reads it: in each reading that executable with the branches' rows on, off, the
piece before's executable (`xu8`, the record before this one) twice, then off and on, on `sqlite3.c`, Lua and musl,
CPU 2, each run its own hold of the lock. `builds/xb-table.py` makes a build's table (`builds/xbN-table.txt`);
`builds/make-patch.sh` made the patches; `builds/functions.sh` read the rows' functions' sizes off each build's
executable (`builds/functions.txt`). TSC ticks a record swept, three readings a build (seven for the last line,
section 5):

| build | `sqlite3.c`, with the branches' rows | more than the piece before's | Lua, with them | more | the lists' and the loops' code, bytes |
| --- | ---: | ---: | ---: | ---: | ---: |
| first: the second list in every chunk, a statement's CONDITION a turn of its own, the loop a function and a clock's read of its own | 5.40 | +0.60 | 6.83 | +0.70 | 2,648 |
| one timed region; the bit that lists written where it is set; the second list in a chunk that branches | 5.41 | +0.58 | 6.85 | +0.71 | 2,623 |
| a CONDITION takes no turn (the reader writes its sense at its operand); an operand's entries counted once | 5.40 | +0.59 | 7.02 | +0.94 | 2,662 |
| the lists' sweep's step in one copy, where the compiler had unrolled it by four | 5.29 | +0.47 | 6.58 | +0.51 | 1,740 |
| the branches' loop in the lists' function, its mask in a chunk that branches alone | 5.36 | +0.53 | 6.41 | +0.35 | 1,806 |
| the fifth's after the fault rounds' changes, the code as it is: an operand's rule with one mask for its shape and its length, the narrow test by its upper bound alone, the chunk's guard on the operators with a turn (seven readings) | **5.10** | **+0.32** | **6.39** | **+0.34** | 1,736 |

- **A statement's CONDITION needs no turn.** The first two builds gave every record evaluated as branches a turn:
  5,613 on `sqlite3.c`, 570 on Lua and 2,364 on musl. A CONDITION's one operand has the CONDITION's own sense, which the
  reader knows when it registers the expression, so the third build has it write the sense there: 3,415, 340 and 1,487 turns.
- **The step in one copy.** The compiler had unrolled the lists' sweep's block loop by four, with a remainder's
  copies: 2,145 bytes of function for 1,223 with `unroll(disable)`, the same work a block. A chunk's first run read
  +0.59 ticks a record swept more than the piece before's on `sqlite3.c` and +0.94 on Lua unrolled, and +0.47 and +0.51 in one
  copy; its second run, +0.40 and +0.32, then +0.34 and +0.30. A chunk is some 8 blocks of `sqlite3.c`'s and 6 of
  Lua's. What a first run pays for there, the function's bytes or its loops' ends, which a second run over the same
  chunk has just seen, these readings don't separate.
- **The loop where the lists are made.** The fourth build's branches' loop was a function of its own, 517 bytes
  beside the lists' 1,223; in the lists' function, with its mask computed in a chunk that branches alone, the two are
  1,806 bytes, and the rows read +0.53 and +0.35 more than the piece before's (+0.47 and +0.51 before).
- **`sqlite3.c` moved little, Lua by half.** Across the five builds `sqlite3.c` read from +0.47 to +0.60 more than the
  piece before's, their readings' ranges overlapping; Lua from +0.94 down to +0.35.
- **The fault rounds' changes read less on `sqlite3.c`.** They touched the timed code after the fifth build: an
  operand's rule (one mask for its shape and its length), the narrow test (its upper bound alone) and the chunk's
  guard (the operators with a turn). By the switch, on less off, the lists and the two loops read +0.48 ticks a record
  swept on `sqlite3.c` and +0.23 on Lua in the fifth build's three readings, and +0.29 and +0.22 in the final code's seven; the
  rows +0.32 and +0.34 more than the piece before's, for +0.53 and +0.35. Which of the three changes it is was not measured.

## 3. The faults (`faults/`)

Each term of an operand's rule and of an operator's turn, each of their stores, the second list's sweep, the chunk's
guard, the reader's sense, each new row of the tables and the listed expression's reason, changed alone
(`faults/make-faults-round1.py` makes the first round's list, `faults-branch-round1.py`; `faults/make-faults.py` the
later rounds', `faults-branch-round2.py` and `faults-branch-round3.py`, and has a line for each fault that left the
list and why). Each fault was compiled first with `-fsyntax-only` (`faults/syntax-check.sh`: `faults/syntax-round1/`,
156 of 160 built, and the four that did not, for a variable left without a use, were rewritten; `faults/syntax-round2/`,
the 18 that were new or changed in the second round's list). A round ran on two machines at once, from the list's two
ends until they met: on the 9700X (`faults/job-faults-branch.sh`: a tree of its own with the round's patch on main
`00faef7dd`'s lineage, `faults/xbfN.patch`; the tree as it is first, which must pass, then a Develop build and
`test-checker --seed 133 --part 5/8` a fault, each its own hold of the lock) and in the cloud container
(`faults/local-round.sh`, the same a fault in a tree at the round's commit). `faults/roundN.txt` has a line a fault
with the machine that ran it (the faults both ran agree); `faults/raw/` has each machine's own lines.

| round | faults | caught | survived | on the 9700X; in the cloud container |
| --- | ---: | ---: | --- | --- |
| 1 | 160 | 153 | `list-branching-with-two`, `list-count-not-ended`, `operand-narrow-with-void`, `turn-second-before-first`, `loop-before-the-updates`, `reason-a-root-tested`, `window-branches-count-of-roots` | 117; 43 |
| 2 | 159 | 157 | `reason-mark-of-its-conversion`, `reason-mark-other-way` | 111; 48 |
| 3 | 158 | 158 | none | 158; 0 |

The first round's seven:

- `list-count-not-ended` set the second list's count to the lesser of itself and its block's end. The turns' loop
  before it leaves the count no less than the end, so the fault changes nothing a program reaches; it is not in the
  later lists.
- `loop-before-the-updates` ran the branches' loop before the updates'. An update that is a tested value takes its
  own part from the one and its conversion's from the other, and each adds its entries to the row's length: the two
  orders write the same. The specification had the updates' first for that case; the comment says now that the
  order is no one's.
- `turn-second-before-first` gave an operator's second operand its sense before the first: two records, but a
  `!`'s one operand, whose two senses are the same.
- `operand-narrow-with-void` took void's class for a narrow one. No tested value has it (the checker takes only a
  scalar for a logical operator's operand), so the lower bound was a term no byte asked: the test is by its upper
  bound alone now.
- `list-branching-with-two` made the second list in a chunk with two records evaluated as branches or more, and
  `window-branches-count-of-roots` took the CONDITIONs out of that count. Both passed for one reason: the count had
  the CONDITIONs, which take no turn, and a chunk with a turn has a CONDITION and an operator below it. The count is
  the operators' with a turn now, and the unit of one chunk with one such operator fails the first fault
  (`faults/mutants/list-branching-with-two-on-the-turns-count.err`: its build's run of the fixture, 4 entries for
  the unit's 11).
- `reason-a-root-tested` removed, from the listed expression's reason, the test that its record has a consumer
  before the read of that consumer's template. Nothing failed. A build of the round's code with a line for each
  listed record with no consumer (`faults/reason-probe/`: its patch, the three corpora's runs and the fixture's)
  printed none: every record that lists its expression there has a consumer (an initializer's value among them:
  `double d = 1;` prints none), so the test was a term no record asked. The front writes a record's consumer's
  distance only when the consumer's record is made, so a read without the test would lean on that. The reason reads
  no consumer now: an
  update by its template, an update's destination with no room by its own shape's mark, and any other record a
  tested value's.

The second round's two, both in the reason as rewritten:

- `reason-mark-of-its-conversion` read the mark in the record's conversion's part. The tables give a destination
  with no room the mark in both parts (`kept_owns` and `kept_conversions`, set together), so the fault changes
  nothing; it is not in the third list.
- `reason-mark-other-way` swapped the two reasons a record with the bit alone can have. It is a real fault, and the
  fixture hid it by a coincidence: it listed 67 expressions for an update's destination and 67 for a tested value,
  so the two counts swapped were the same two. The fixture got one more of the second (a `const` bool's read under a
  `do`), and that fault's build fails on it (`faults/mutants/reason-mark-other-way-with-the-line.err`: update=134
  for 133, branches=67 for 68). The line was run against the fault's build before the third round.

## 4. The probes (`probes/`)

One-statement programs, each a file of its own through `measure-node-machine --shadow --window-rows --passes 0`
(`probes/probe-again.py COMPILER CASES`, which also asks that no chunk's second run differ from its first), on the
checks' build in the cloud container: 286 conditions (`probes/cases13.py`: `&&`, `||` and `!` under an `if`, a
`while`, a `do` and a `for`; each nested in either operand of each, three deep; a tested value of each class and
kind; conditions C lists) and 230 tested values that might have a conversion of their own (`probes/cases14.py`: a
decayed array's and function's, a qualified, an atomic and a bit-field's read, a cast's, a class past double's; 20 of
them list their expression for branches, each a qualified `_Bool`'s read). And the pieces' before, 618
(`probes/earlier.txt`, `cases9` to `cases12`; their cases are in the records before this one). Every one reads as X
on T's columns does: no tape differs, and no answer of C's. The pull request's commit's build read them again
(`final/cloud-checks/probes/`, `final/cloud-checks/run-probes.sh`): 1134 lines, none that does not agree.

## 5. The final readings (`final/9700x/`)

`final/9700x/xb6/` (its patch on main `00faef7dd`'s lineage beside it, its build's log and its executable's hash)
and the piece before's executable's runs (`final/9700x/xu8/`): `builds/job-xb.sh`'s seven readings, the job the
session before started as it handed the work off (`final/9700x/job-xb6.log`); `final/xb6-table.txt` by
`builds/xb-table.py`. The patch's sources are the pull request's code's commit's with the experiment's switch and
three comments' wording apart: main `00faef7dd` with the patch, compared file by file with the commit. TSC ticks.

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| expressions C takes on the window | 49,155 | 9,909 | 39,712 |
| their tapes made here | 49,073 (99.83%) | 9,888 (99.79%) | 39,495 (99.45%) |
| the piece before's | 47,027 (95.67%) | 9,689 (97.78%) | 38,705 (97.46%) |
| of the expressions C decides | 99.52% | 98.10% | 94.58% |
| listed for an update | 73 | 10 | 4 |
| listed for branches | 0 | 0 | 0 |
| listed for a refused conversion | 1 | 0 | 20 |
| listed for a constant to a floating class | 8 | 11 | 193 |
| tapes that differ from X's on T's columns | 0 | 0 | 0 |
| operators with a turn | 3,415 (1.06% of the records swept) | 340 (0.37% of the records swept) | 1,487 (0.39% of the records swept) |
| **the rows' sweeps and the part, a record swept** | **5.10 (5.01 to 5.28)** | **6.39 (6.31 to 9.88)** | **12.46 (10.37 to 14.48)** |
| the piece before's executable, in the same readings | 4.80 | 6.08 | 13.34 |
| **more than the piece before's** | **+0.32 (+0.17 to +0.40)** | **+0.34 (+0.07 to +2.13)** | **-0.45 (-1.82 to +0.17)** |
| with the branches' rows off; on less off | 4.80; +0.30 | 6.13; +0.25 | 11.50; +0.52 |
| the reads | 1.67 | 1.83 | 3.21 |
| the shapes | 0.67 | 1.02 | 1.96 |
| the lists and the two loops; with the branches' rows off | 0.83; 0.53 | 1.05; 0.83 | 1.94; 1.79 |
| the rows | 0.95 | 1.47 | 3.38 |
| an expression's part | 0.98 | 0.99 | 1.52 |
| a second run over the same chunk; the piece before's | 4.08; 3.79 | 3.83; 3.54 | 5.12; 4.71 |
| the lists and the two loops in it; with the branches' rows off | 0.62; 0.43 | 0.56; 0.46 | 0.91; 0.83 |
| the branches' rows, ticks a turn (on less off): a first run; a second | 27; 18 | 59; 30 | 38; 20 |
| a record of the taken expressions | 6.09 | 9.48 | 24.98 |
| X on T's columns, a record of theirs, with its values | 25.53 | 23.55 | 28.34 |
| records a chunk; turns a chunk | 526; 5.6 | 379; 1.4 | 127; 0.5 |

**Against its gates** ([the specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7037879405)):

- **B1, exact: met.** No tape made differs from X's on T's columns in its number of entries, a kind or a class, on
  the three corpora on the 9700X, with the branches' rows on and off. In the cloud container the same on the three
  and on the compiler's own source (39,453 tapes of its 40,195 expressions, 98.15%), with the default warnings and with
  `-Wall -Wextra`. The rows' fixture has a line a
  pattern (1,166 tapes with the pieces' before), a unit of one chunk with one condition and no update has 3, one with
  one update 3, and C's fixture 1,479 more; with one of the reference's answers changed for each tape the comparison
  counts every tape of the four. And 1,134 one-statement programs, each a file of its own: 286 conditions (`&&`, `||` and `!`
  under an `if`, a `while`, a `do` and a `for`, nested in either operand three deep, a tested value of each class and
  kind, and conditions C lists), 230 tested values that might have a conversion of their own (a decayed array's and
  function's, a qualified, an atomic and a bit-field's read, a class past double's), and the 618 of the pieces before.
- **B2, how much: met.** 2,046 tapes more on `sqlite3.c`, 199 on Lua and 790 on musl (2,046, 199 and 790 asked: every
  expression the count had with no other record that lists it; refuted under 2,000, 190 and 770): 99.83%, 99.79% and
  99.45% of the expressions C takes, and 99.52%, 98.10% and 94.58% of those it decides. No expression is listed for
  branches on the three.
- **B3, cost: met.** The rows' sweeps and the part read +0.32 ticks a record swept more than the piece before's
  executable on `sqlite3.c` (+0.17 to +0.40; 0.6 asked, 1.0 refutes) and +0.34 on Lua (+0.07 to +2.13; 0.4 asked, 0.8 refutes);
  -0.45 on musl (-1.82 to +0.17), which the gate did not name. Two of Lua's 14 runs with the branches' rows on read 9.44 and 9.88, each with one part some 300,000 ticks over its
  other readings (the lists and the loops in the one, the rows' write in the other); the other 12 read
  6.31 to 6.47. By the switch, on less off, the lists and the two loops read
  +0.29, +0.22 and +0.15: 27, 59 and 38 ticks a turn. On a chunk's second run the whole reads +0.29, +0.29 and +0.40 more than
  the piece before's.
- **B4, nothing else moves: met.** By the switch, on less off, on `sqlite3.c` and Lua: the kernel in place +0.02 and
  -0.03; the records' bytes -0.06 and +0.07, the tests' loop -0.02 and +0.02, their expression's part +0.01 and -0.07, their sweep on
  T's records -0.02 and -0.07; C's three sweeps -0.03 and +0.05 (0.3 asked).
- **B5, faults: met.** Three rounds: each term of an operand's rule and of an operator's turn, each of their stores, the second
  list's sweep, the chunk's guard, the reader's sense, each new row of the tables and the listed expression's reason
  changed alone, a build and the fixture's tests a fault. The first round's 160 faults left 7. Four change nothing
  a program reaches, and are no faults: a count set to the lesser of itself and its block's end, which the loop
  before it leaves no less; the two loops in the other order (an update that is a tested value has its own part from
  the one and its conversion's from the other); a second operand given its sense before the first; and void's class
  taken for a narrow one, which no tested value has (the test is by its upper bound alone now). Three found code to
  change. The chunk's guard counted the CONDITIONs, which take no turn, so a guard of two for one and a count without
  them both passed: the count is the turns' now, and a unit of one chunk with one turn separates them (run against
  the first fault's build before the next round). And the listed expression's reason read its record's consumer
  behind a test that the record has one, which a fault removed unseen: a build with a line for each listed record
  with no consumer printed none on the three corpora and the fixture, so the test was a term no record asked. The
  reason is by the record's own shape now, with no consumer's read. The second round's 159 faults left 2, both in
  that rewritten reason: one changes nothing (the tables give a destination with no room the mark in both of its
  parts), and one swapped the two reasons a record with the bit alone can have, which the fixture hid, its counts
  for the two being the same. A fourth `const` bool condition makes them differ, and that fault's build fails on it,
  run before the third round. The third round's 158 faults, on the code as it is, are all caught.

`final/generators/gen-docs.py` made the design's two sections of these files (`node-machine-section.md` and
`one-core-path-section.md` beside it are its templates; `values.json` its values), and `apply-docs.py` put them in
the docs. `gen-readme.py` made this file from its second section on, and `gen-body.py` the pull request's body and
the issue's note (`body-template.md`, `result-note-template.md`, `tests.md`); `assemble.sh` copied this session's
files here. The session before wrote the generators and their templates against the fifth build's readings; this
session ran them on the final ones, with the fault rounds' paragraph as the rounds went, the final build's line and
Lua's two runs' note added (the record's history has them as handed off, at `0c2e9decc`).

## 6. The cloud container's checks (`final/cloud-*`)

`final/cloud-checks/` (`checks-rows.sh`, on the commit in `revision.txt`: the pull request's code's commit, on the
main it was opened on, in the container of the session that took the work over; the session before ran the same on
its own commit, whose files are in this record's history at `0c2e9decc`): a native Release build; `test-checker`, its eight parts; the shadow with `--window-rows` and with
`--window-contexts` on `sqlite3.c`, Lua and musl and with `--window-rows` on the compiler's own source, with the
default warnings and with `-Wall -Wextra` (`rows-counts.txt`); the shadow's other modes on `sqlite3.c` and Lua; the
self-check, the self-parse, the call graph's two; the ownership check; and the complete driver's lists and parse.
`progress.txt` has each one's status. All pass but the preprocessor's comparison with clang in the complete driver's
light list: 45 of its 66 units differ, each by where its line markers place a token and none by a token's count
(`complete-light-the-preprocessor-against-clang.txt`). The container's clang (23.1.6) names its resource directory
otherwise; the session before read the same of main in its own container.

`final/cloud-sanitizers/` (`sanitizers-parts.sh`, on the same commit, `progress-73b723aa9.txt`; and the session
before's pass on `9eb233772`, that code but for three comments, `progress-9eb233772.txt`): native memory, address and thread builds;
`test-checker` part 5 under each, and under memory and address the shadow with `--window-rows` on `sqlite3.c`, Lua
and the compiler's own source. No report in either: native-memory part5 status 0 wall 24 s; 210453 checks, 0 failures; reports 0; native-address part5 status 0 wall 20 s; 210453 checks, 0 failures; reports 0; native-thread part5 status 0 wall 38 s; 210453 checks, 0 failures; reports 0.

## 7. Who did what

The session that specified, built and measured the piece (the specification, the five builds, the three fault
rounds, the probes, its own checks and sanitizer pass, and [buster14a/buster#3190](https://github.com/buster14a/buster/pull/3190))
handed it off at its user's request before the final readings
([the hand-off](https://github.com/buster14a/buster/issues/2850#issuecomment-7042274752)), with their job running on
the 9700X. The session that took #2850 over ([its claim](https://github.com/buster14a/buster/issues/2850#issuecomment-7042574537))
read that job's results (sections 5 and its gates), ran the generators on them, checked the code's commit again on
the main of that hour (section 6) and opened [buster14a/buster#3191](https://github.com/buster14a/buster/pull/3191),
which has #3190's one commit, cherry-picked unchanged, and the design's two sections as a second: it pushes to its
own branch alone, so #3190 was closed for it.
