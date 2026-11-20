# An update's rows on the window (buster#2850's step 2), 2026-11-20

The evidence for the piece that makes an update's two rows (the node machine's X sweep's
`node_machine_update_first` and `node_machine_update_last`) on the front's window. The piece before it is
[x-rows-on-the-window-2850-2026-11-19](../x-rows-on-the-window-2850-2026-11-19/), and the census its specification
reads again is [x-rows-census-2850-2026-11-19](../x-rows-census-2850-2026-11-19/).

## 1. Before the specification (`before/`)

One count, on the piece before's code (`before/count.patch` on main `903bf7ef4`: that piece's source and, in its
shadow's count of the listed expressions, a line of counts at exit): of the expressions the rows list first for an
update, which have another record that lists them, and what their updates are. A Develop build on the 9700X
(`before/dev-xr-develop.sh`), then `measure-node-machine --shadow --passes 0 --window-rows` on `sqlite3.c`, Lua and
musl, CPU 2, each run its own hold of the lock (`before/dev-xr-corpora.sh`); `before/9700x-count.txt` has the lines,
musl's first and then the three's in the corpora's order.

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| listed for X, first for an update | 3,394 | 742 | 3,530 |
| of them with an operator evaluated as branches too | 13 | 4 | 15 |
| with a refused conversion or a constant to a floating class too | 0 | 0 | 0 |
| with updates alone | 3,381 | 738 | 3,515 |
| of those, with a postfix update through an address | 438 | 115 | 80 |
| of those, with a bool's update | 0 | 0 | 0 |
| their updates | 3,428 | 743 | 3,556 |
| by name; of them postfix | 2,134; 1,399 | 527; 389 | 3,174; 1,214 |
| through an address: prefix; postfix | 856; 438 | 101; 115 | 302; 80 |
| a pointer's | 445 | 322 | 618 |
| `++` and `--` | 2,025 | 524 | 1,383 |

An update is by name where its first operand's record is a name's value, a pointer's and a bool's by its own
record's type's facts, and postfix by its operator.

## 2. The builds, and how it came to its cost (`builds/`)

Six builds before the fault rounds and one beside the first (`builds/9700x/xuN/`, each with its patch on main
`903bf7ef4`, `xuNx.patch`: the piece's source at that point and an experiment's switch, `BUSTER_TESTS_SKIP=1`, with
which an update's template lists its expression as the piece before had it). `builds/job-xu.sh` builds one and reads
it: in each reading that executable with the update's rows on, off, the piece before's executable (`xr10`, the record
before this one) twice, then off and on, on `sqlite3.c`, Lua and musl, CPU 2, each run its own hold of the lock.
`builds/xu-table.py` makes a build's table (`builds/xuN-table.txt`), `builds/builds.py` a line a build and
`builds/builds-detail.py` each part's (`builds/builds-detail.txt`); `builds/make-switch-patch.sh` made the patches.
TSC ticks a record swept, three readings a build (seven for the last line, section 5):

| build | `sqlite3.c`, with the update's rows | more than the piece before's | Lua, with them | more |
| --- | ---: | ---: | ---: | ---: |
| first: the update's loop in the reads' sweep, each shape chosen by branches; four columns of its own | 5.16 | +1.02 | 6.52 | +1.30 |
| each shape a sum of bits, with no branch | 5.21 | +1.11 | 6.98 | +1.89 |
| no column of its own: the shapes into the two the sweeps write | 4.84 | +0.62 | 6.18 | +1.06 |
| both rows' shapes as masks in the shapes' sweep; the loop carries what crosses the two records | 4.75 | +0.57 | 6.40 | +1.27 |
| a sweep and a loop of their own, after the shapes' sweep | 4.75 | +0.61 | 6.15 | +0.99 |
| that loop with no table of its own (not kept) | 4.79 | +0.70 | 6.10 | +0.95 |
| the fifth's, in a chunk with an update alone, and a row's entries' number one byte (seven readings) | **4.71** | **+0.67** | **6.11** | **+0.94** |

`xu7` is the last line's code read while the first fault round ran on the 9700X: its runs came between that round's
builds, and Lua's read +1.46 for it; it is no line of the table.

- **A shape chosen by branches is mispredicted.** The first build's loop chose each shape by branches: the reads
  read 0.57 ticks a record more with the update's rows on than off on `sqlite3.c`, 49.1 an update; as sums of bits,
  0.43 and 37.0.
- **A column of its own is one more a block, in every chunk.** With four (the two shapes', the operation's kind and
  the store's), the reads read 0.34 ticks a record more than the piece before's on `sqlite3.c` and 1.01 on Lua with
  the update's rows off; with none, 0.14 and 0.44.
- **A term in a big sweep is every block's.** The fourth build made both rows' shapes of masks in the shapes' sweep,
  its loop carrying only what crosses the two records. The shapes' sweep read 0.22 ticks a record more than the
  piece before's on `sqlite3.c` and 0.49 on Lua, 0.18 and 0.47 of it with the update's rows off; and the reads, with
  the list and the loop in them, 0.29 and 0.67 more.
- **A sweep and a loop of their own leave the others theirs.** In the fifth build the reads read +0.00 and +0.02 against
  the piece before's and the shapes +0.01 and +0.01. The updates' own counter reads 0.53 and 0.89, of which 0.11 and 0.30
  are the list's sweep with no update to make (the switch), and 0.35 and 0.34 on a chunk's second run.
- **The loop with no table of its own read no less**, 0.58 and 0.96: a sum of bits for each shape and each length
  is more instructions than the lookups it replaces.

## 3. The faults (`faults/`)

Each term of the updates' loop's bits and shapes, each of its stores, the list's sweep, the rows' write's new
resolutions and marks, and each new row of the tables, changed alone (`faults/make-faults-round1.py` makes
`faults-update-round1.py`, the first round's list; `faults/make-faults.py` makes `faults-update.py`, the later
rounds'). Each fault was compiled first with `-fsyntax-only` (`faults/syntax-check.sh`,
`faults/syntax-round1.txt`: 171 of 174 built, and the three that did not, for a variable left without a use, were
rewritten). Then on the 9700X (`faults/job-faults-update.sh`, and `job-faults-update2.sh` from the second round, which
restores C's loop's file too): a tree of its own with the round's patch on main `903bf7ef4` (`faults/xufN.patch`), the
tree as it is first, which must pass, then a Develop build and `test-checker --seed 133 --part 5/8` a fault, each its
own hold of the lock. A line a fault in `faults/roundN.txt`.

| round | faults | caught | survived |
| --- | ---: | ---: | --- |
| 1 | 174 | 171 | `loop-own-pointer-converted`, `loop-first-length-swapped`, `list-not-evaluated` |
| 2 | 181 | 178 | `length-low-bits`, `chunk-updates-of-two`, `chunk-updates-count-of-the-asked` |
| 3 | 181 | 180 | `length-low-bits` |
| 4 | 181 | 181 | none |

- `loop-own-pointer-converted` gives a pointer's own row a CONVERT. No pointer's update has one (its computation is
  its own class's, by C's masks), so the fault changes nothing a program reaches; it is not in the later lists.
- `loop-first-length-swapped` swapped a row's two parts' lengths. No one read them apart: the write and the comparison
  read their sum. They became a row's entries' number, one byte.
- `list-not-evaluated` let the list take records that are not evaluated. The three corpora and the compiler's own
  source read the same with it (`faults/unevaluated/*.lines`), and so did 30 one-statement programs
  (`faults/unevaluated/cases10.py`, `base.txt` and `mutant.txt`). The case exists all the same: a folded `&&`'s dead
  operand has the update's template and is not evaluated, and C lists its expression, so no tape is compared; the
  mutant writes 6 entries for `return 0 && a++;`'s records where the code writes 1. The fixture got two such lines,
  and its pin of the entries written catches the fault.
- `length-low-bits` read a row's entries' number by its low three bits: a row of eight reads as none. It survived
  the second round and the third. The line the fixture got after the second
  (`_Bool told = (char)(long)&global_outer.inner.second;`; `probes/cases11.py` has its kind) was written from the
  tables, an address constant's own four entries and a narrow class's conversion to bool's four, and was not run
  against the fault. Run against it (`faults/eight/`: the fault's build, `mutant-cases11.txt`), none of the 8
  cases differs: no expression there has a row of eight at its last record. By the tables the address constant is the
  cast to `long`'s record, of four entries, and the cast to `char` a record of its own, its CONVERT and the
  conversion's four; the cases' entries' numbers agree with that. An update's row does have eight
  (`probes/cases12.py`, `faults/eight/mutant-cases12.txt`): a narrow destination's `++` or `--` (its CONST, the
  operation, the CONVERT back and the store) whose value is converted to bool, four more, where that record is an
  expression's last (an initialization's, a `return`'s). 7 of the 12 cases differ under the fault; the others have a
  last record of six or seven entries, or the eight at a record that is not the last. The fixture's line is
  `_Bool told = ++c;` now, in place of the other (`faults/eight/fixture-eight.py`; `part5-mutant.err` is the fault
  caught by it in the cloud container), and the fourth round ran on that.
- `chunk-updates-of-two` and `chunk-updates-count-of-the-asked` skip the updates' sweep in a chunk with one update:
  the fixture got a unit of one chunk with one update.

## 4. The probes (`probes/`)

One-statement programs, each a file of its own through `measure-node-machine --shadow --window-rows --passes 0`
(`probes/probe.py COMPILER CASES`), on the final build in the cloud container: 241 of the first piece's
(`probes/earlier.txt`; their cases are in the record before this one), 327 of an update's cases (`probes/cases9.py`),
30 of updates that are not evaluated (`cases10.py`), 8 of an address constant's cast converted to bool (`cases11.py`)
and 12 of an update's value converted to bool (`cases12.py`: a row of eight entries at an expression's last record).
Every one reads as X on T's columns does: no tape differs, and no answer of C's.

## 5. The final readings (`final/9700x/`)

`final/9700x/xu8/` (its patch `xu8x.patch` on main `903bf7ef4`) and the piece before's executable's runs beside it
(`final/9700x/xr10/`), `builds/job-xu.sh`'s seven readings with no other job of this session's on the 9700X;
`final/xu8-table.txt` by `builds/xu-table.py`, `final/xu8-numbers.txt` by `builds/piece-numbers.py`. TSC ticks.

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| expressions C takes on the window | 49,155 | 9,909 | 39,712 |
| their tapes made here | 47,027 (95.67%) | 9,689 (97.78%) | 38,705 (97.46%) |
| the piece before's | 43,719 (88.94%) | 8,961 (90.43%) | 35,194 (88.62%) |
| of the expressions C decides | 95.37% | 96.13% | 92.69% |
| listed for an update | 73 | 10 | 4 |
| listed for branches | 2,046 | 200 | 790 |
| listed for a refused conversion | 1 | 0 | 20 |
| listed for a constant to a floating class | 8 | 10 | 193 |
| tapes that differ from X's on T's columns | 0 | 0 | 0 |
| updates | 3,734 (1.16% of the records swept) | 861 (0.94% of the records swept) | 3,969 (1.05% of the records swept) |
| **the rows' sweeps and the part, a record swept** | **4.71 (4.61 to 4.93)** | **6.11 (5.99 to 8.12)** | **11.97 (9.87 to 14.39)** |
| the piece before's executable, in the same readings | 4.12 | 5.15 | 10.59 |
| **more than the piece before's** | **+0.67 (+0.47 to +0.81)** | **+0.94 (+0.87 to +1.99)** | **+1.27 (-1.11 to +4.23)** |
| with the update's rows off | 4.37 | 5.54 | 11.68 |
| the reads | 1.62 | 1.81 | 3.58 |
| the shapes | 0.62 | 1.02 | 2.10 |
| the updates; with none to make | 0.52; 0.11 | 0.81; 0.27 | 1.55; 0.69 |
| the rows | 0.98 | 1.44 | 3.16 |
| an expression's part | 0.99 | 0.99 | 1.51 |
| a second run over the same chunk; the piece before's | 3.81; 3.29 | 3.54; 3.15 | 4.70; 4.04 |
| the updates in it; with none to make | 0.36; 0.09 | 0.33; 0.12 | 0.53; 0.30 |
| the updates, ticks an update: a first run; a second | 45; 31 | 86; 35 | 147; 50 |
| a record of the taken expressions | 6.22 | 9.51 | 25.20 |
| X on T's columns, a record of theirs, with its values | 26.64 | 24.78 | 29.25 |
| records a chunk; updates a chunk | 526; 6.1 | 379; 3.6 | 127; 1.3 |

**Against its gates** ([the specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7030649938)):

- **U1, exact: met.** No tape made differs from X's on T's columns in its number of entries, a kind or a class, on
  the three corpora on the 9700X, with the update's rows on and off. In the cloud
  container the same on the three and on the compiler's own source (36,721 tapes there), with the default warnings and
  with `-Wall -Wextra`. The rows' fixture has a line an update's case (629 tapes with the first piece's lines), a
  unit of one chunk with one update has 3, and C's fixture 1,253 more; with one of the reference's answers changed
  for each tape the comparison counts every tape of the three. And 618 one-statement programs, each a file of its
  own, 369 of them an update's cases, read as X on T's columns does.
- **U2, how much: met.** 3,308 tapes more on `sqlite3.c`, 728 on Lua and 3,511 on musl (2,900, 600 and 3,400 asked;
  refuted under 2,500, 500 and 3,000): 95.67%, 97.78% and 97.46% of the expressions C takes, and 95.37%, 96.13% and 92.69%
  of those it decides. Of the 438, 115 and 80 expressions with a postfix update
  through an address (the count before the specification), 73, 10 and 4 are listed still, for the entries of their
  destination's own.
- **U3, cost: not met.** The rows' sweeps and the part read +0.67 ticks a record swept more
  than the piece before's executable on `sqlite3.c` (+0.47 to +0.81) and +0.94 on Lua (+0.87 to +1.99), where 0.5 was asked
  and 1.0 refutes; +1.27 on musl (-1.11 to +4.23), which the gate did not name. Of it the updates' sweep and loop are 0.52,
  0.81 and 1.55, and the rows' write, with the update's marks and sources in it, +0.12, +0.17 and +0.22. On a chunk's second
  run the whole reads +0.52, +0.40 and +0.67 more.
- **U4, nothing else moves: met.** By the switch, on less off, on `sqlite3.c` and Lua: the kernel in place -0.10 and
  -0.04; the records' bytes -0.01 and +0.00, the tests' loop +0.03 and +0.00, their expression's part -0.02 and +0.00, their sweep on
  T's records -0.06 and -0.12; C's three sweeps +0.01 and -0.07 (0.3 asked).
- **U5, faults: met.** Four rounds: each term of the updates' loop's bits and shapes, each of its stores, the list's sweep, the
  write's new resolutions and marks and each new row of the tables changed alone, a build and the fixture's tests a
  fault. The first round's 174 faults left 3: one that gives a pointer's row a CONVERT, which no pointer's update
  has, so it changes nothing (dropped); the two parts' lengths of a row swapped, which no one read apart (they became
  a row's entries' number, one byte); and the list taking records that are not evaluated, whose case, a folded
  `&&`'s dead operand, got its lines. The second's 181, on the changed code, left 3: a row's entries' number read by
  its low bits, and two that skip a chunk with one update (a unit of one chunk with one update). The third's 181 left
  the first of those still: the line it had got, an address constant's cast converted to bool, makes rows of four
  and of five entries and none of eight. Run against the fault's build, a narrow destination's `++` whose value is
  converted to bool does (its own four and the conversion's four, an expression's last record's), and that is the
  fixture's line now. The fourth's 181, on the code as it is, are all caught.

`final/gen-docs.py` made the design's two sections of these files (`final/node-machine-section.md` and
`final/one-core-path-section.md` are its templates), and `final/apply-docs.py` put them in the docs.
`final/gen-readme.py` made this file from its second section on, and `final/gen-notes.py` and `final/gen-body.py` the
pull request's body and the issue's note of the docs' sections (`final/body-template.md`,
`final/result-note-template.md`).

## 6. The cloud container's checks (`final/cloud-*`)

`final/cloud-checks/` (`checks-rows.sh`, on the commit in `revision.txt`: the pull request's sources, on the main it
was opened on): a native Release build; `test-checker`, its eight parts; the shadow with `--window-rows` and with
`--window-contexts` on `sqlite3.c`, Lua and musl and with `--window-rows` on the compiler's own source, with the
default warnings and with `-Wall -Wextra` (`rows-counts.txt`); the shadow's other modes on `sqlite3.c` and Lua; the
self-check, the self-parse, the call graph's two; the ownership check; and the complete driver's lists and parse.
`progress.txt` has each one's status. All pass but the preprocessor's comparison with clang in the complete driver's
light list, which fails in this container on main too (its system clang is 23.1.6).

`final/cloud-sanitizers/` (`sanitizers-parts.sh`): native memory, address and thread builds. On the commit before the
fixture's last line (`progress.txt`): `test-checker` part 5 under each, and under memory and address the shadow with
`--window-rows`, `--window-contexts` and `--window-tests` on `sqlite3.c`, Lua and the compiler's own source. On the
pull request's sources (`progress-final.txt`): `test-checker` part 5 under each, and under memory and address the
shadow with `--window-rows` on the three. No report in either: native-memory part5 status 0 wall 26 s; 210389 checks, 0 failures; reports 0; native-address part5 status 0 wall 23 s; 210389 checks, 0 failures; reports 0; native-thread part5 status 0 wall 39 s; 210389 checks, 0 failures; reports 0.

The 9700X's readings (section 5) and the first sanitizer pass are of the piece before the fixture's last line. The
readings' executable has the pull request's sweeps' source with the experiment's switch in three places (its patch is
in `final/9700x/xu8/`), and the first pass's commit has that source as it is.
`final/rows-functions.sh` lists a build's rows' functions' instructions without their addresses: that commit's native
Release build's (`final/rows-functions-baa0d0e26.s`) and the pull request's sources' (`final/rows-functions-9efc8650b.s`)
are the same line for line, but for the displacements of their RIP-relative operands (2632 lines each; the check's command is in the
script).

## 7. The compile's speed, asked while this ran (`throughput/`)

`throughput/throughput.sh xr10`: the piece before's executable (main `903bf7ef4`'s compile, which takes none of the
window's work) on `sqlite3.c`, CPU 2, each run its own hold of the lock, three runs each of `-fsyntax-only` and `-c`
with `--time-stages`. The file is 9,507,037 bytes (2,612,735 preprocessed, 716,136 tokens).

| | median | of the file | 1 GB/s of the file is 9.5 ms |
| --- | ---: | ---: | ---: |
| `-c` | 123.1 ms | 77.2 MB/s | 12.9 times away |
| `-fsyntax-only` | 100.8 ms | 94.4 MB/s | 10.6 times away |

`-c`'s stages in its second run, of 121.9 ms: checking 81.4 (67%), lowering 11.8 (10%), preprocessing and parsing
17.5 (14%), Tier 0 5.2.
