# X's rows on the window (buster#2850's step 2), 2026-11-19

The evidence for the piece that makes X's rows (the node machine's X sweep, `node_machine_expand`) on the front's
window, from C's answers there. The census before it is
[x-rows-census-2850-2026-11-19](../x-rows-census-2850-2026-11-19/).

The 9700X, CPU 2, Release, each run its own hold of the lock.

## 1. Before the specification (`before/`)

Two counts, on main `3741c264f` and on the census's build.

**The reference's time** (`before/job-xr0.sh`, `before/x-reference-time.patch`: two clock reads around
`node_machine_expand` at reader time, on the expressions it takes; `before/9700x/xr0/`, five readings a corpus of
`measure-node-machine --shadow --passes 0 --window-contexts`):

| X on T's columns, TSC ticks a record | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| median (range) | 24.82 (24.62 to 25.06) | 22.75 (22.66 to 23.05) | 27.32 (27.22 to 28.20) |
| expressions, records, entries | 50,159, 281,956, 319,525 | 10,366, 72,167, 66,089 | 41,068, 210,497, 209,223 |

A record here is any of an expression's, evaluated or not, and the pair of clock reads an expression is in the figure.

**Which expressions a first piece takes** (`before/job-first-piece.sh`, `before/first-piece.py`: the X census's lines,
`census-x2.patch`'s build on main `b84780116`, an expression at a time; `before/9700x/first-piece/`). An expression is
the first piece's where every one of its records is evaluated with nothing after its row, and none has the template of
an update, of a logical operator's or a conditional's value, or of an operator evaluated as branches:

| | `sqlite3.c` | Lua | musl | the compiler's own source |
| --- | ---: | ---: | ---: | ---: |
| expressions X takes | 50,159 | 10,366 | 41,068 | 43,775 |
| the first piece's | 44,008 (87.74%) | 9,097 (87.76%) | 35,732 (87.01%) | 31,736 (72.50%) |
| their records (evaluated) | 202,565 (80.35%) | 44,267 (77.44%) | 145,879 (78.01%) | 136,799 (56.25%) |
| their entries | 234,753 (73.47%) | 45,580 (68.97%) | 149,110 (71.27%) | 172,368 (49.58%) |
| with an update | 3,526 | 789 | 3,693 | 5,586 |
| with branches | 2,079 | 244 | 849 | 3,661 |
| with a logical operator's or a conditional's value | 546 | 236 | 794 | 2,792 |

In the first piece's expressions (`before/shares.txt`, by `before/shares.py`):

| | `sqlite3.c` | Lua | musl | the compiler's own source |
| --- | ---: | ---: | ---: | ---: |
| lists of kinds of a record's own entries, by template | 43 | 43 | 44 | 43 |
| lists of kinds of its conversion's | 3 | 3 | 3 | 5 |
| the most entries a record, own and conversion | 4 | 4 | 4 | 7 |
| records with two own entries or more | 15.07% | 10.62% | 7.78% | 14.99% |
| a target that is not the record's type, in a value's context | 23.0% | 19.1% | 24.6% | 36.0% |
| a member's record | 11.6% | 12.5% | 3.2% | 9.5% |
| a truth's | 5.0% | 3.1% | 4.7% | 4.4% |
| an address constant of an object | 2.5% | 3.0% | 3.1% | 6.4% |

An integer constant whose conversion folds into a floating class: 6, 10, 252 and 31 records; none that converts to
one and does not fold.

## 2. The builds, and how it came to its cost (`builds/`)

Five builds before the fault rounds, each a patch on main (`builds/9700x/xrN/xrN.patch`; `xr1` on `3741c264f`, the
others on `903bf7ef4`), built and read by `builds/job-xr.sh`: ONE executable with the rows on (`--window-rows`) and
off (`--window-contexts`), on, off, off, on in each reading, on `sqlite3.c`, Lua and musl. Three readings a build,
seven for `xr5`. `builds/xr-table.py` makes a build's table (`builds/xrN-table.txt`); `xr1`'s report has no reads'
part of its own, and `builds/xr1-table.py` makes its table.

| the three sweeps and the part, TSC ticks a record swept (median, range) | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| `xr1`: one sweep with two loops a block, the rows eight records a step | 7.47 (7.34 to 7.78) | 8.21 (8.07 to 8.25) | 11.07 (10.03 to 12.94) |
| `xr2`: the reads a sweep of their own, a record's type a column, the rows by slots | 5.66 (5.47 to 5.74) | 6.52 (6.48 to 6.56) | 10.26 (9.31 to 11.26) |
| `xr3`: the reads' two lists, a loop a list | 4.88 (4.66 to 4.97) | 6.04 (5.99 to 6.14) | 12.47 (11.15 to 16.64) |
| `xr4`: no word read for void, and the expression's part with no branch | 5.00 (4.92 to 5.15) | 5.90 (5.84 to 5.99) | 11.46 (10.93 to 12.49) |
| `xr5`: the part with its branch again | 4.84 (4.67 to 4.99) | 5.80 (5.65 to 6.07) | 10.48 (9.95 to 14.49) |

By part, on `sqlite3.c` and Lua:

| | `xr1` | `xr2` | `xr3` | `xr4` | `xr5` |
| --- | ---: | ---: | ---: | ---: | ---: |
| the reads | (in the shapes) | 2.71, 2.81 | 1.81, 2.09 | 1.81, 2.06 | 1.83, 2.05 |
| the shapes | 4.35, 4.74 | 0.80, 1.23 | 0.86, 1.40 | 0.85, 1.35 | 0.88, 1.29 |
| the rows | 1.85, 2.18 | 0.84, 1.27 | 0.90, 1.37 | 0.91, 1.29 | 0.84, 1.26 |
| an expression's part | 1.27, 1.25 | 1.25, 1.20 | 1.26, 1.19 | 1.45, 1.21 | 1.27, 1.20 |

The records the reads read for, a record at a time (`builds/words-and-lines-by-build.txt`): a target's word for
58,216 of `sqlite3.c`'s 321,434 records swept (18.11%) and 11,808 of Lua's 91,252 (12.94%) through `xr3`, and for
31,998 (9.95%) and 6,919 (7.58%) from `xr4`, which reads none for void; a line or a table for 47,178 (14.68%) and
11,584 (12.69%).

`xr5`'s second run over the same chunk reads 3.90, 3.65 and 4.61 ticks a record swept on the three corpora
(`builds/xr5-table.txt`).

Two more after the fault rounds' changes, seven readings each (`builds/xr9-table.txt`, `builds/xr10-table.txt`):

| the three sweeps and the part, TSC ticks a record swept (median, range) | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| `xr9`: the terms that are no mask out (rounds 1 to 3) | 4.38 (4.31 to 4.54) | 5.37 (5.20 to 5.49) | 10.83 (9.22 to 12.12) |
| `xr10`, the code as it is pushed: the part without its root's test, and round 4's other terms out | 4.11 (4.02 to 4.23) | 5.17 (5.09 to 5.33) | 10.54 (9.22 to 13.20) |

Section 6 has `xr10` whole.

## 3. The reads' three stages (`builds/job-xr-stages.sh`, `builds/9700x/xr5i/`, `builds/9700x/xr9i/`)

`xr5` and `xr9` with a clock read between the reads' stages (`xr5i.patch`, `xr9i.patch`), three runs a corpus; ticks a
record swept, the two runs of a chunk together, medians:

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| `xr5i`: the masks and the two lists | 0.54 | 0.59 | 0.89 |
| the loop over the targets' words | 0.35 | 0.34 | 0.71 |
| the loop over the lines | 0.77 | 0.74 | 0.71 |
| `xr9i`: the masks and the two lists | 0.50 | 0.57 | 0.94 |
| the loop over the targets' words | 0.35 | 0.32 | 0.76 |
| the loop over the lines | 0.67 | 0.65 | 0.64 |

`xr10`'s reads are `xr9`'s: round 4 changed the shapes' sweep and the part.

## 4. The fault rounds (`faults/`)

A fault is one change of the rows' code (`c_check_node_machine_rows.c`, and the type column of
`c_check_node_census.c`'s sweep), applied alone to a tree at the round's base; the tree is built and
`test-checker --seed 133 --part 5/8` run: caught where the part fails. `faults/roundN/` has each round's list
(`faults-rows[-N].py`, made from the round before's by `make-roundN.py`), its job and its verdicts.

A round was stopped when its survivors had changed the code, and the next run on the changed code:

| round | base | faults in its list | run | caught | survived | did not build |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| 1 (Release builds; the 9700X and three trees in the cloud container) | `xr6.patch` on `903bf7ef4` | 173 | 55 | 34 | 12 | 9 |
| 2 (Develop builds, the 9700X) | `xr7.patch` | 167 | 47 | 43 | 4 | 0 |
| 3 | `xr8.patch` | 164 | 44 | 42 | 2 | 0 |
| 4 (the 9700X and one tree in the cloud container) | `xr9.patch` | 165 | 157 | 153 | 4 | 0 |
| 5, the code as it is pushed (the 9700X and one tree in the cloud container) | `xr10.patch` | 167 | 167 | 167 | 0 | 0 (one after it was rewritten) |

Round 4 was stopped with 8 of its faults not run; they are of round 5's list. Round 5's list is round 4's 155 faults
that still apply and 12 of the changed lines (`make-round5.py`). The 9700X ran
the list from its front (`round5/9700x-round5.txt`, 110 faults) and the cloud container from its end
(`round5/cloud-round5.txt`, 50, and `round5/cloud-round5-2.txt`, 12, of which 5 are the 9700X's too). One fault,
`shapes-own-not-evaluated`, did not build as round 4 wrote it (on the changed code it left a variable unused); it was
rewritten to keep the variable used and is caught (`round5/cloud-round5-rewritten.txt`).

Round 1's builds were Release: a fault took about 70 s on the 9700X and five minutes in the cloud container, and
nine of its faults did not build (each took a variable's only use away, an error with `-Werror`; a syntax check of
all 173 found 24 such, and each was rewritten to keep the variable used). From round 2 a fault's build is Develop,
about 10 s on the 9700X with 4 s for the part, and every fault of a list is compiled (`-fsyntax-only`) before the
round.

What each survivor led to:

| round | fault | what it changed | outcome |
| --- | --- | --- | --- |
| 1 | `reads-converts-not-evaluated` | the conversions' mask without the evaluated records' | the fixture pins the entries written and the records read for; caught from round 3 |
| 1 | `reads-far-a-bit` | a member's offset not zero in bits, for in bytes | the term is out: a bit-field's record lists its expression in C's loop |
| 1 | `reads-local-unknown` | an object's kind read with no bound's test of the result | the test is out: a record with no object reads the first object's symbol, and no one reads its bit |
| 1 | `reads-offset-always` | an address's offset's bit always set | the payload's read is out: the standing's bit says an offset is not zero |
| 1 | `shapes-no-discard` | no discarded context | its terms are out: no record on the window has the context |
| 1 | `shapes-local-without-object`, `shapes-offset-without-object` | an address's bits read of a record with no object | the address's shape asks the object once, last |
| 1 | `shapes-offset-any-field` | the payload's field's two bits for one | one bit's test |
| 1 | `shapes-refused-taken` | a refused conversion's shape made | the term is out: a refused record's shape is read by no one |
| 1 | `shapes-discard-void-source` | a DISCARD of a void | the term is out: a void's conversion to a void is of one class |
| 1 | `shapes-discard-to-any`, `shapes-convert-same-class` | a conversion between two types of one class | fixture lines: a `_BitInt`'s target of its value's class |
| 2 | `reads-converts-any-context` | a conversion in any context | the term is out: a record read for its address has no target but its own type (the three corpora's counts are the base's with the fault) |
| 2 | `reads-lined-any-constant` | a constant with an object read for whatever its kind | the term is out (the three corpora's counts are the base's with the fault) |
| 2 | `shapes-live-empty` | no conversion empty | the mask is out: each line writes an empty one nothing |
| 2, 3 | `shapes-fold-any-template` | a fold whatever the template | fixture lines: a store of a constant. With the term out, five of musl's tapes differ (`probes/9700x-the-fold-without-its-template-test.txt`) |
| 3 | `shapes-discard-to-any` | a DISCARD to any target | the conversion's shape is two selections: the lines after wrote over it |
| 4 | `shapes-folded-bool-as-target` | a constant folded to bool as any other folded constant | the bool's row is out: its CONST is of its target's class, and bool's is a U8's |
| 4 | `shapes-listed-not-evaluated` | a listing record's evaluated bit not asked | the term is out: with the fault the three corpora's counts are the base's, and so are 17 probes of updates and operators that are not evaluated (`probes/9700x-a-listing-records-evaluated-bit-out.txt`) |
| 4 | `types-not-masked` | the types' column written for the records the kernel didn't place too | the rows' fixture test asserts the reader's verify, which counted those bytes and was read by no test of the rows' |
| 4 | `part-no-root` | no test of the root's own record in an expression's part | the test is out: a root's record has no target, and its one template whose rows are not made here is a CONDITION's over `&&` or `\|\|`, whose operand lists the expression; with the fault the three corpora's counts are the base's (`probes/9700x-the-parts-root-test-out.txt`) |

## 5. The probes (`probes/`)

241 one-statement programs (`probes/cases1.py` to `cases8.py`), each a file of its own, through
`measure-node-machine --shadow --window-rows --passes 0` (`probes/probe.py`): what C makes of each on the window
(decided, refused, listed) and what the rows make of it. On the code as it is pushed (`probes/9700x-probes-241.txt`,
a Develop build on the 9700X): C's answers and the rows' tapes differ from their references on none; 114 are one
expression that C takes, 44 one that C refuses, 35 one that C does not decide, 25 have no expression of the
window's, and the other 23 have two expressions or more. The rows make 122 tapes of them and list 32 expressions.
(`probes/9700x-probes.txt` has the first 224 on round 4's base.)

Three faults the fixture did not see were run on the three corpora (`probes/dev-mutant.sh`,
`probes/9700x-mutants-on-the-corpora.txt`): with `reads-converts-any-context` and with `reads-lined-any-constant`
every count is the base's (the tapes, the entries written, the records read for), and their terms are out; with the
fold's test of the template out (`probes/the-fold-without-its-template-test.patch`), five of musl's tapes differ,
and the term stayed.

Round 4's two (`probes/dev-mutant-list.sh`): with a listing record's evaluated bit not asked and with the part's test
of the root's record out, every count on the three corpora is the base's. `probes/cases8.py` is 17 programs: 13 with
an update or a logical operator in an operand that is not evaluated (a `sizeof`'s, an `_Alignof`'s, a `__typeof__`'s,
a `_Generic`'s, a `__builtin_constant_p`'s), of which 11 have no expression on the window and the other two's
expressions there are the statement's others, with no record of that operand; 3 with one on a decided conditional's
or logical operator's dead side, which C does not decide; and an evaluated update, which is listed.
`probes/9700x-the-fourth-rounds-changes-on-the-corpora.txt` is the three corpora on the code with round 4's four
changes (a Develop build): no tape differs, and the counts are `xr9`'s.

## 6. The code as it is pushed (`builds/9700x/xr10/`, `builds/xr10-table.txt`, `builds/xr10-doc.txt`)

`xr10.patch` on `903bf7ef4`, a Release build on the 9700X, CPU 2, each run its own hold of the lock; seven readings,
each one executable with the rows on, off, off, on (`builds/job-xr.sh`); TSC ticks. Round 5 and a CI job shared the
host's lock with the readings.

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| expressions C decides on the window | 49,310 | 10,079 | 41,759 |
| expressions C takes there | 49,155 | 9,909 | 39,712 |
| their tapes made here | 43,719 (88.94%) | 8,961 (90.43%) | 35,194 (88.62%) |
| of the expressions C decides | 88.66% | 88.91% | 84.28% |
| their entries | 231,724 | 44,248 | 145,442 |
| listed for an update | 3,394 | 742 | 3,530 |
| listed for branches | 2,033 | 196 | 775 |
| listed for a refused conversion | 1 | 0 | 20 |
| listed for a constant to a floating class | 8 | 10 | 193 |
| tapes that differ from X's on T's columns | 0 | 0 | 0 |
| **the three sweeps and the part, a record swept** | **4.11 (4.02 to 4.23)** | **5.17 (5.09 to 5.33)** | **10.54 (9.22 to 13.20)** |
| the reads | 1.62 | 1.83 | 3.46 |
| the shapes | 0.62 | 1.00 | 2.60 |
| the rows | 0.86 | 1.29 | 2.66 |
| an expression's part | 1.02 | 1.05 | 1.54 |
| a second run over the same chunk | 3.29 | 3.14 | 4.04 |
| its parts: the reads, the shapes, the rows, the part | 1.31, 0.47, 0.64, 0.86 | 1.13, 0.47, 0.72, 0.82 | 1.30, 0.69, 1.04, 1.02 |
| a record of the taken expressions | 5.84 | 8.66 | 24.68 |
| X on T's columns, a record of theirs, with its values | 24.34 | 22.99 | 27.54 |
| records whose target's word is read | 31,998 (9.95%) | 6,919 (7.58%) | 34,220 (9.07%) |
| records whose line is read | 47,178 (14.68%) | 11,584 (12.69%) | 19,496 (5.17%) |
| records swept; chunks | 321,434; 611 | 91,252; 241 | 377,187; 2,975 |

The rows on less off, each reading's own difference (the mean of its two on runs less the mean of its two off
runs), median and range:

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| the kernel in place | -0.12 (-0.24 to +0.60) | +0.06 (+0.03 to +0.17) | -0.01 (-0.45 to +2.71) |
| the tests on the window, their sum | +0.21 (-0.27 to +0.57) | +0.56 (-1.85 to +3.10) | -0.77 (-6.00 to +3.45) |
| the records' bytes | +0.15 (+0.09 to +0.34) | +0.35 (+0.26 to +3.29) | -0.86 (-5.46 to +0.54) |
| the tests' loop | -0.04 (-0.11 to +0.03) | +0.05 (-0.03 to +0.18) | +0.53 (-0.67 to +1.14) |
| the tests' expression's part | +0.06 (-0.12 to +0.21) | -0.01 (-1.95 to +0.21) | +0.60 (-0.42 to +2.41) |
| the tests on T's records | +0.04 (-0.19 to +0.14) | +0.08 (-0.16 to +0.21) | -0.46 (-1.74 to +3.70) |
| C's three sweeps, a record swept | +0.00 (-0.08 to +0.12) | +0.01 (-3.15 to +0.15) | +0.02 (-1.22 to +1.95) |
| C's loop | +0.04 (-0.05 to +0.12) | +0.04 (-0.06 to +0.17) | +0.39 (-0.40 to +1.76) |
| C's targets | +0.00 (-0.04 to +0.02) | +0.01 (-3.08 to +0.05) | +0.05 (-0.12 to +0.24) |
| C's expression's part | -0.01 (-0.08 to +0.02) | -0.03 (-0.06 to +0.01) | -0.06 (-1.88 to +0.02) |

The records' bytes' sweep makes the types' column with the rows on (four permutes, three inserts, a masked move and
a store a step of sixteen records): it reads +0.15 and +0.35 more for it here, on every reading of Lua's, where
`xr9`, whose code there is the same, read +0.08 and -0.07 (`builds/xr9-table.txt`). Counted with the rows, they are
4.26 ticks a record swept on `sqlite3.c` and 5.52 on Lua.

Against the gates: R1 met (no tape differs, here and in section 7's runs); R2 met on `sqlite3.c` and Lua (88.66% and
88.91% of the expressions C decides; 85% asked) and 84.28% on musl, where C refuses 2,047 of the 41,759 it decides;
R3 met on `sqlite3.c` (4.11; 5.0 asked) and not on Lua (5.17; refuted over 8.0); R4 met for the kernel, the tests'
loop, part and sweep on T's records and C's three sweeps (each within 0.12 on `sqlite3.c` and Lua; 0.3 asked) and
not for the records' bytes on Lua (+0.35); R5 is section 4's.

## 7. Checks in the cloud container on the head (`final/`)

On `ec32ed54f` (the piece on main `505904cd0`; the commit pushed has its code, with two comments reworded):

- `final/cloud-checks/` (`checks-rows.sh`): a native Release build; `test-checker`'s eight parts pass; the shadow with
  `--window-rows` and with `--window-contexts`, with the default warnings and with `-Wall -Wextra`, on `sqlite3.c`,
  Lua and musl, and with `--window-rows` on the compiler's own source: 14 runs, none with a tape or an answer that
  differs (`rows-counts.txt`); the shadow's other modes on `sqlite3.c` and Lua (22 runs); the self-check, the
  self-parse, the call graph's test and check, and the ownership check; the complete driver's lists and parse. One
  item of the complete driver's light list fails in this container, on main too: the preprocessor's comparison with
  the system's clang, which is 23.1.6 there.
- The compiler's own source there: C decides 41,375 expressions and takes 40,050; the rows make 31,573 tapes of
  171,305 entries (78.83%) and list 5,210 for an update, 3,213 for branches, 22 for a refused conversion and 32 for a
  constant to a floating class; 555,241 records swept, a target's word read for 90,464 (16.29%) and a line for 55,282
  (9.96%).
- `final/cloud-sanitizers/` (`sanitizers-parts.sh`): native memory, address and thread builds; `test-checker` part 5
  under each, and under memory and address the shadow with `--window-rows`, `--window-contexts` and `--window-tests`
  on `sqlite3.c`, Lua and the compiler's own source: 24 lines with status 0, no report.
