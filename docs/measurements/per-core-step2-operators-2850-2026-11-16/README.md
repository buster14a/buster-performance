# The one-core path's step 2, first piece: T's other operators on the fact words' records (buster#2850), 2026-11-16

The first piece of step 2 of
[buster#2850](https://github.com/buster14a/buster/issues/2850), under
[its claim](https://github.com/buster14a/buster/issues/2850#issuecomment-6903451811).
[Step 1](../per-core-step1-2850-2026-11-15) and
[its follow-up](../per-core-step1-lean-2850-2026-11-15) made T's leaves and
lookups from fact words and took every other record from T: the operators
that are no lookup (a quarter of `sqlite3.c`'s records) and the literals. This
piece makes those too, in the same kernel, so that T whole on these records
can be read against the shadow's own T on the same windows.

**Result.** Every record is T's, on `sqlite3.c`, Lua and musl, with whole and
with lean records, and over decoys too. The kernel makes 99.34%, 97.13% and
98.08% of the records that are no literal. T whole costs **38** cycles an
evaluated node on `sqlite3.c` with a body a window (37.7, 38.2 and 38.6 in
three builds of one kernel; 33.2 to 34.3 with the windows packed to 384
records), and **32** with lean records (31.7 to 32.6; 28.2 to 28.6 packed),
where the shadow's own T costs 89 to 90: 2.3 to 3.2 times less. **The gate's
25 cycles are missed**, and whole records are at the claim's refutation line
of 38, above it in two of the three builds. Lua is 40.6 to 41.5 and 36.2
(T's 81), musl 32.6 to 33.8 and 28.9 to 29.4 (T's 72).

The code is buster's `c_check_node_machine_facts.c`
(`measure-node-machine --shadow --facts-operators`); the design's page is
buster's `docs/one-core-path.md`.

## What was built

- **The other operators, by T's rows' and rules' own steps on the kernel's
  records**: the rows' operators (arithmetic, comparisons, shifts, bitwise,
  the unary ones) from T's baked table, with the constants' folds, a pointer
  plus or minus an integer and a pointer's equality with a null pointer
  constant behind it; `=`, a conversion and an initialization; a control's
  condition and `!`; `&x`; a cast; `&&` and `||`; the increments and the
  compound assignments; a comma; `sizeof` and `_Alignof`; `?:`.
- **A literal's leaf from a line of its own**, as an identifier's from its
  declaration's.
- **Two more words**: a type's side row (the pointer types to it, its size
  and alignment) and a pair's slot (whether one pointer type converts to
  another as T's rule takes it), a memo as the members' slots are.
- **The classes are a round and a code**, not a level and an operator: see
  "The classes" below. One scalar pass puts each made operator's place on its
  class's list; a round then runs its classes' loops in the codes' order.
- **A class's loop** takes what its short path takes, lists the rest, marks
  each listed record wide (so that a later operator of the class that reads
  it is listed too) and makes the listed ones by their rules after the loop.
- **The check**: every record against T's over poisoned records; the lists
  against a record-at-a-time twin; a second checked pass over decoys (T's
  record of each node the kernel is to make, with one inherited flag the
  other way), which shows an operator made before its operand; and in the
  twin the order itself: an operand the kernel makes by class is on a list
  no later than its operator's.

## How it was measured

- The 9700X (`benchpress`), CPU 2, every build and run under the host's lock,
  one hold a run (`scripts/lock.sh`).
- `base` is buster main `be6515fb` (it has step 1's follow-up, buster#2868).
  `head` is it with `results/head/ops-final.patch` and is the record's run:
  every variant, the profiles and the whole compile (`scripts/final.sh`).
  Both are `./build.sh --config Release` (`scripts/build-label.sh`).
- `pr` is the same main with `results/pr/ops-pr.patch`: the pull request's
  sources, but for one line of the tests' fixture that was added after it
  with its counts (`x = !a; x = f(!a); x = f(*q); *q += 1; (*q)++;`: data of
  the tests). Against `head` it has the lists' twin's order check, which
  runs in the checked pass alone, and four more statements of the fixture
  (`x = 7 - 2`, `y = -1`, `q = &ga[3] - 1`, `d = a ? x : d`). Its timed
  kernel is `head`'s, instruction for instruction (117.75 an evaluated node
  whole and 98.02 lean on `sqlite3.c`). `scripts/confirm.sh` ran its
  operators' kernel in the four settings, three runs each.
- The inputs, a run's passes and what a figure is are step 1's
  (`scripts/facts.sh`; that record's "How it was measured"): a run is five
  passes over the unit and reports the least; the kernel's cycles are a pass
  less the same windows' given records put in place.
- **An evaluated node** is the shadow's own denominator for its T
  (`node-shadow: time sweeps=T`): `sqlite3.c` has 256,292 in 291,021 records,
  Lua 57,625 in 73,998, musl 109,639 in 130,291.
- Each setting ran three times; the tables have the medians, with the least
  and the greatest in brackets where it matters. `python3
  scripts/summary.py results base head pr` makes the figures and `python3
  scripts/parts.py results head NAME 160 facts-sqlite3-NAME-1.txt` the
  parts.
- `o1` to `o10` are earlier builds of the same piece, one run each but `o9`
  and `o10` (three). "The versions" below has what each is.

## The result

Cycles an evaluated node, T whole from the fact words (medians of three
runs). The counts and the rows not named `pr` are `head`'s.

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| records of the windows, and evaluated nodes | 291,021, 256,292 | 73,998, 57,625 | 130,291, 109,639 |
| identifiers' leaves, all taken | 93,682 | 21,795 | 42,850 |
| literals, each with a line, all taken | 38,961 | 11,041 | 17,324 |
| lookups, and those taken | 88,737, 88,497 | 19,792, 19,736 | 27,566, 27,383 |
| the other operators, and those taken | 69,641, 68,226 (97.97%) | 21,370, 19,621 (91.82%) | 42,551, 40,570 (95.34%) |
| of them by a class's loop, by their rule one at a time | 60,512, 7,714 | 11,937, 7,684 | 35,192, 5,378 |
| records that are no literal, and those the kernel makes | 252,060, 250,405 (99.34%) | 62,957, 61,152 (97.13%) | 112,967, 110,803 (98.08%) |
| records that differ from T's, every run; over decoys | 0; 0 | 0; 0 | 0; 0 |
| **the shadow's own T** (main's), cycles; instructions | 89.6; 337 | 81.0; 428 | 72.0; 382 |
| **a body a window:** whole records | **37.74** [37.62..38.19] | 40.58 [40.41..40.74] | 32.60 [32.50..32.91] |
| instructions; mispredicted branches a record | 117.8; 0.30 | 179.0; 0.02 | 146.0; 0.01 |
| lean records | **31.71** [31.71..32.04] | 36.18 [36.08..36.37] | 28.88 [28.88..28.93] |
| instructions; mispredicted branches a record | 98.0; 0.26 | 159.5; 0.02 | 128.3; 0.01 |
| **windows packed to 384 records:** whole | 33.18 [33.16..33.21] | 38.14 [38.11..38.26] | 31.29 [31.26..31.30] |
| lean | 28.23 [27.96..28.35] | 34.35 [34.16..34.51] | 27.66 [27.49..27.76] |
| cycles a unit: whole, lean (a body a window) | 9.67 M, 8.13 M | 2.34 M, 2.08 M | 3.57 M, 3.17 M |
| **`pr`, a body a window:** whole | 38.22 [38.04..38.77] | 41.48 [41.02..41.57] | 33.82 [33.72..33.86] |
| lean | 31.85 [31.83..32.50] | 36.24 [36.23..36.45] | 29.43 [29.25..29.46] |
| **`pr`, packed:** whole | 33.91 [33.88..34.01] | 39.05 [38.89..39.22] | 32.66 [32.49..32.70] |
| lean | 28.24 [27.94..28.25] | 34.47 [34.44..34.65] | 28.16 [28.02..28.32] |
| the shadow's own T a unit | 22.96 M | 4.67 M | 7.89 M |

- A lean kernel writes a leaf's line alone and a record's first half, no
  conversion's entry, and makes no discard, as the follow-up's. What it
  leaves out is checked: on `sqlite3.c` all 120,199 conversions' entries are
  their rule's on the kernel's own records, and 36,524 of the 36,724 discards
  (the rest are the ones the whole kernel leaves to T). A lean kernel
  therefore makes 84.85% of the records that are no literal; with the
  discards its rule derives, the same 99.34%.
- **The kernel's time has nothing for what it leaves to T**: 1,655, 1,805
  and 2,164 records that are no literal. At the shadow's own T's average
  (89.6, 81.0 and 72.0 cycles an evaluated node; an operator costs T more
  than its average) that is 0.6, 2.5 and 1.4 cycles an evaluated node more.
- **Nor for making the words**, as in step 1: a row, a declaration's line
  and a slot are made once each as the shadow reaches them, and a literal's
  line is a copy of the reader's record of it, which T reads too.
- Lua's and musl's mispredicted branches read as none, as in step 1: their
  passes repeat and the predictor learns them. Their cycles are the lower
  bound of what a compile would see; `sqlite3.c`'s are not learned (0.30 a
  record at five passes, 0.23 at 160).
- Lua's operators go to their rule one at a time far more often (36% of
  them): its macros fold constants (`~`, `+`, `<<` and `|`: 4,491 of the
  7,684). Half its casts (1,213 of 2,417) are left to T: a cast's rule
  takes a value that is no constant, between builtin integer types and
  pointers.

## Against the gate

The claim's gate: every record the oracle's; at least 95% of the records
that are no literal made by the kernel; T whole at 25 cycles an evaluated
node or less on `sqlite3.c`, a body's expressions a run. Refuted if T whole
stays above 38, or if the short paths leave more than a tenth of these
operators' records to T's rules.

| | `sqlite3.c` | Lua | musl |
| --- | --- | --- | --- |
| every record the oracle's | met: 0 differences, and 0 over decoys | met | met |
| 95% of the records that are no literal | met: 99.34% | met: 97.13% | met: 98.08% |
| T whole at 25 cycles or less, a body a window | **missed: 37.7 and 38.2** (lean 31.7 and 31.9) | 40.6 and 41.5 (36.2) | 32.6 and 33.8 (28.9 and 29.4) |
| refuted above 38 | **at the line**: 37.7 (`head`), 38.2 (`pr`) and 38.6 (`o9`), one kernel in three builds | above | under |
| operators left to T: a tenth or fewer | 2.03% | 8.18% | 4.66% |

- The speed gate is missed by half again, and whole records are at the
  refutation line: above it in two builds of three. With lean records T is
  under the line and 7 cycles over the gate; with the windows packed 3 over.
- "Left to T" is what the kernel doesn't make. Beside it, the kernel makes
  11.1% of `sqlite3.c`'s operators (36.0% of Lua's, 12.6% of musl's) by its
  rule one at a time, outside a class's loop.

## By part

`sqlite3.c`, from profiles of the kernel's functions at 160 passes a run
(`scripts/profiles.sh`; 482 runs of the unit): cycles each (instructions;
mispredicted branches).

| part | of them | whole, a body a window | lean, a body a window | whole, packed |
| --- | ---: | ---: | ---: | ---: |
| the lists, the classes and the dispatch, a record of the window | 291,021 | 6.1 (20; 0.05) | 6.2 (17; 0.05) | 3.7 (12; 0.01) |
| a leaf: its line's load and its record's store | 132,643 | 3.6 (14; 0.02) | 2.9 (12; 0.02) | 3.5 (15; 0.01) |
| `->` | 23,433 | 23.8 (92; 0.13) | 23.2 (78; 0.13) | 24.1 (99; 0.08) |
| `.` | 7,257 | 36.7 (142; 0.20) | 34.3 (124; 0.22) | 33.8 (137; 0.12) |
| `*` | 1,188 | 37.0 (112; 0.45) | 38.1 (115; 0.34) | 35.6 (122; 0.33) |
| a subscript | 6,812 | 60.4 (220; 0.34) | 50.4 (189; 0.30) | 53.5 (226; 0.21) |
| a call | 13,323 | 42.2 (143; 0.33) | 37.6 (123; 0.30) | 39.5 (145; 0.21) |
| a discard | 36,724 | 17.9 (58; 0.17) | not made | 17.6 (56; 0.14) |
| a row's operator, by the table | 21,679 | 52.2 (180; 0.30) | 47.4 (157; 0.30) | 50.7 (179; 0.16) |
| `=` | 16,057 | 58.9 (209; 0.46) | 55.8 (194; 0.48) | 58.5 (208; 0.37) |
| a conversion or an initialization | 3,846 | 62.5 (212; 0.61) | 63.8 (197; 0.59) | 58.8 (212; 0.38) |
| a condition or `!` | 12,938 | 24.4 (75; 0.20) | 17.3 (62; 0.15) | 19.2 (64; 0.13) |
| `&x` | 3,404 | 30.0 (115; 0.21) | 32.8 (109; 0.21) | 31.0 (113; 0.13) |
| a cast | 2,949 | 70.1 (216; 0.73) | 61.9 (203; 0.77) | 71.6 (213; 0.60) |
| `&&` or `\|\|` | 3,105 | 46.1 (144; 0.29) | 35.8 (121; 0.28) | 38.9 (137; 0.22) |
| an update | 3,788 | 77.3 (247; 0.74) | 76.7 (244; 0.75) | 73.4 (257; 0.63) |

Cycles a pass, in millions:

| part | whole, a body a window | lean, a body a window | whole, packed |
| --- | ---: | ---: | ---: |
| the lists, the classes and the dispatch | 1.77 | 1.81 | 1.07 |
| the leaves | 0.48 | 0.39 | 0.47 |
| the lookups' loops (`->`, `.`, `*`, a subscript, a call) | 1.84 | 1.68 | 1.75 |
| the discards | 0.66 | | 0.65 |
| the rows' operators by the table, and those it doesn't type | 1.13, 0.51 | 1.03, 0.54 | 1.10, 0.52 |
| `=`; a conversion | 0.95; 0.24 | 0.90; 0.25 | 0.94; 0.23 |
| a condition or `!`; `&x`; a cast; `&&` or `\|\|`; an update | 0.32; 0.10; 0.21; 0.14; 0.29 | 0.22; 0.11; 0.18; 0.11; 0.29 | 0.25; 0.11; 0.21; 0.12; 0.28 |
| the rules an operator at a time (a comma, `sizeof`, `?:`, a unary plus, and what a loop listed) | 0.30 | 0.31 | 0.28 |
| all; instructions; mispredicted branches | 8.94; 30.50 M; 66,129 | 7.81; 25.52 M; 58,807 | 7.96; 28.54 M; 41,752 |

- The profiles' passes are 160 where a timed run's are five. The predictor
  has learned more of the unit by then (66,129 mispredicted branches a pass
  against 88,153), so the parts sum to 8.94 M cycles where a timed pass is
  9.67 M.
- **The operators that are no lookup are 24% of the records and 43% of the
  cycles** (3.89 M of the 8.94 M, without their share of the lists and the
  rules one at a time): 56 cycles each where a lookup is 35 and a leaf 3.6.
  A row's operator, `=`, a conversion, a cast and an update are 180 to 250
  instructions each for T's whole record, with 0.3 to 0.7 mispredicted
  branches.
- **The lists, the classes and the dispatch are 6 cycles a record of the
  window with a body a window and 3.7 packed.** A body has 100 records in 10
  classes of 5 operators each: a class's loop ends as soon as it starts, and
  the predictor misses the classes a window has.
- A part has 100 to 2,000 samples: its cycles read to 3 to 10 percent.

## The classes

Step 1's classes were a level of operands and an operator, each a scan of the
window's lookups. With fifteen codes that is too many classes and scans for a
body. `analysis/` has the count, on dumps of `sqlite3.c`'s windows from the
first build (`dump-windows.txt` says how they were written):
`python3 analysis/schemes.py analysis/windows-body.txt.gz
analysis/windows-packed.txt.gz` (`schemes.txt`), `rounds.py` (`rounds.txt`),
`roots.py` (`roots.txt`) and `order.py`, the search for the order.

| a pass over `sqlite3.c`, 158,396 made operators | a body a window (2,918 windows) | packed (767) |
| --- | ---: | ---: |
| levels, an expression's last record apart (the first build): classes, level scans | 42,306, 14,418 | 25,512, 5,435 |
| rounds of the codes, lookups first: classes, rounds | 38,397, 7,501 | 21,185, 3,079 |
| … with an operator of its operand's code staying in the class (a chain) | 32,266, 5,491 | 16,975, 2,072 |
| **the order built, with chains** | **29,803, 4,653** | **15,323, 1,718** |
| … with the discards and truths after every round | 30,079, 4,653 | 15,050, 1,718 |

- **A round makes its classes in a fixed order of the codes**, each class's
  operators in the window's order. An operator's round is the highest of its
  operands' rounds, and one more only where an operand's code comes after its
  own. An operand of an earlier code is the round's earlier class; one of its
  own code is before it in its class's list.
- **The order** is `->`, a subscript, `.`, `&x`, a cast, the rest (a comma,
  `sizeof`, `?:`, a unary plus), the rows, a call, `&&` and `||`, an update,
  `*`, `=`, a conversion, a discard, a truth: the one that gave these windows
  the fewest classes in `order.py`'s search by swaps.
- **Nine operators in ten are of the first round** (141,780 of 158,396; then
  15,466, 1,061 and 89), and a body is 1.6 rounds and 10.2 classes where it
  was 4.9 levels and 14.5 classes. The kernel has four rounds; what is deeper
  is made by its rule in the window's order (none in these windows).
- A body's classes stay small: 10.0 discards a class, 9.2 `->`, 7.0 rows'
  operators, 6.3 `.`, 5.5 `=`, 4.8 calls, 4.3 truths and 2 to 4 of each
  other code. With the windows packed a class has 24 `->`, 15 rows'
  operators, 11 `=` and 12 calls (`analysis/roots.txt`).

## The versions

`sqlite3.c`, cycles an evaluated node. One run each but `o9`, `o10`, `head`
and `pr` (medians of three). `o3` and `o8` were not run on the host.

| | what it is | whole, body | whole, packed | lean, body | lean, packed |
| --- | --- | ---: | ---: | ---: | ---: |
| `o1` | the first exact build: levels with the last records apart; a vector compress a level, then one a class; every operator by its rule's one path | 49.60 | 42.85 | | |
| `o2` | rounds of the codes with chains; one scalar pass to the classes' lists; a test a code in a round | 42.52 | 37.95 | | |
| `o4` | short paths for `=`, a conversion, a truth, `&&` and `\|\|`; a row's operands' standings from a 256-byte table; the rows the table doesn't type in a loop of their own | 40.12 | 36.21 | | |
| `o5` | `o4` with a vector compress a class in place of the scalar pass | 44.81 | 38.29 | | |
| `o6` | `=` in two straight sides (a value, a constant); the rows' loop without a branch; the lists before the leaves | 40.66 | 33.67 | 32.05 | 28.02 |
| `o7` | `o6` with a compress a code in the listing's steps in place of the scalar pass | 39.14 | 34.90 | 33.18 | 29.31 |
| `o9` | `o6`'s kernel; the check's poison no longer reads as a wide record | 38.55 | 34.25 | 32.60 | 28.63 |
| `o10` | `o9` with software prefetch of the next window's input columns | 38.49 | 34.12 | 32.07 | 28.02 |
| `head` | `o9`'s kernel; the check's second pass over decoys | 37.74 | 33.18 | 31.71 | 28.23 |
| `pr` | `head`'s kernel; the lists' twin's order check, in the checked pass | 38.22 | 33.91 | 31.85 | 28.24 |

- **`o6`, `o9`, `head` and `pr` are one kernel**: 117.75 instructions an
  evaluated node whole and 98.02 lean in each. They read 40.7 (a run in
  which the shadow's own T read 94.1, where it reads 89 to 90), 38.6, 37.7
  and 38.2 whole, and 32.1, 32.6, 31.7 and 31.9 lean: what a build and a
  run move the figure by. On Lua and musl `pr` reads 0.9 and 1.2 cycles
  more than `head` whole and 0.1 and 0.6 lean. The given records' own pass
  moves by 0.8 cycles a record between runs; the kernel's figure is a
  difference from it.
- **The scalar pass to the lists beat both vector ways.** A compress a class
  (`o5`) is a scan of the window a class: 4.7 cycles an evaluated node more.
  A compress a code while listing (`o7`) is fifteen compresses a vector of
  sixteen records: ten more instructions a node (127.9 against 117.8), and
  worse than `o9`'s medians in all four settings. The scalar pass is about
  6 cycles a made operator, bound by its counts' store and load, not by its
  instructions: half the driver's cycles in
  `results/o4/annotate-cycles-ops-node_facts_window.txt` (50.5%; the dispatch
  32%, the vector listing 8.6%).
- **Instructions are a poor guide here.** The kernel runs at three
  instructions a cycle on `sqlite3.c`. `o5` has 3 more instructions a node
  than `o4` and 4.7 more cycles; `o7` has 10 more than `o9` and 0.6 more
  cycles a body a window.
- **Software prefetch didn't pay**: within what a build moves the operators'
  kernel by, and the leaves' and lookups' kernel alone read 24.8 with it
  against 22.9.
- **What paid**: the classes by rounds (7.1 cycles a node, `o1` to `o2`);
  short paths in the class loops and the rows by a table (2.4, `o2` to
  `o4`); then `=` as two straight sides, the rows' loop without a branch and
  the lists made before the leaves (1.6 a body a window and 2.0 packed, `o4`
  to `o9`).

## The leaves' and lookups' kernels, base against head

The driver changed for every variant, so step 1's kernels (no
`--facts-operators`) were run again. Cycles a taken leaf or lookup, medians
of three runs.

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| whole, a body a window: `base` | 23.18 | 17.54 | 15.85 |
| `head` | 22.41 | 17.95 | 16.46 |
| whole, packed: `base` | 18.91 | 14.95 | 14.68 |
| `head` | 18.99 | 15.48 | 15.14 |
| lean, a body a window: the follow-up's record | 20.8 | 16.0 | 14.1 |
| `head` | 20.39 | 17.27 | 15.29 |
| lean, packed: the follow-up's record | 17.4 | 13.5 | 13.0 |
| `head` | 16.11 | 14.39 | 13.84 |
| loads, a body a window: the follow-up's record | 15.2 | 10.8 | 8.8 |
| `head` | 14.98 | 12.79 | 10.42 |
| loads, packed: the follow-up's record | 11.8 | 8.3 | 7.8 |
| `head` | 10.57 | 9.35 | 8.80 |

`base` gives the follow-up's whole figures again (22.7, 17.6 and 15.9; 18.9,
14.9 and 14.7), so its record's lean and loads figures stand for `base`'s.
The new driver is the same or better on `sqlite3.c` (to 1.3 cycles) and 0.4
to 2.0 cycles dearer on Lua and musl. I didn't take that apart; the likely
cost is the scalar pass to the lists, about 6 cycles a lookup, where the
levels' scans of Lua's and musl's repeating windows cost less.

## The whole compile

`-c sqlite3.c` as whole processes, `base` against `head` in a Williams order
(`scripts/compile.sh`; `results/head/compile-1.txt`, `compile-2.txt`; 21
runs a build, twice): the same instructions (1,363,433,9xx each), wall time
-0.19% and -0.15% where `base` against itself reads -0.40% and -0.30%. The
kernel is the shadow's; a compile doesn't run it.

## What the kernel leaves to T

By operator, on `sqlite3.c`: records, left to T, made by the rule one at a
time (`results/head/facts-sqlite3-ops-1.txt` has every operator).

| operator | records | left | by rule |
| --- | ---: | ---: | ---: |
| a cast | 2,949 | 767 (26.0%) | 0 |
| `?:` | 554 | 168 (30.3%) | 386 |
| `==`, `!=` | 7,314 | 230 (3.1%) | 1,529 |
| a unary plus | 128 | 99 (77.3%) | 29 |
| `<`, `<=`, `>`, `>=` | 3,489 | 81 (2.3%) | 102 |
| `=` | 16,057 | 32 (0.2%) | 265 |
| a unary minus | 1,392 | 7 | 1,334 |
| `\|`, `&`, `<<`, `~` | 4,260 | 0 | 1,720 |
| `sizeof`, a comma | 1,193 | 0 | 1,193 |
| all the operators that are no lookup | 69,641 | 1,415 (2.03%) | 7,714 |

- A cast is left where its value is a constant, or where either type is no
  builtin integer type or pointer; `?:` where its condition is a constant or
  its arms are neither arithmetic nor void; a comparison where it compares
  two pointers; a unary plus where its operand is no constant.
- "By rule" is mostly a constant's fold (a negative literal, a mask of
  constants), and the codes that have no loop: a comma, `sizeof`, `?:`.

## The check, and its mutants

`mutations/` has 21 single changes of the kernel (`mutations.py`), each
built and run by `mutate2.py` on the compiler's own source (whole and lean),
on `sqlite3.c` and by the census tests (`test-checker --seed 133 --part
5/8`); `mutate2.log` and `mutate3.log` have a line each (the second has the
six that didn't build as first written and the three run again after the
fixture gained their statements). They ran in the session's container, in
Debug builds: they are a check of the oracle, not timings.

- **19 of the 21 fail the tests**; 17 of those also differ from T on the
  compiler's own source or on `sqlite3.c`. (`mutate2.py` leaves the last
  mutant's build as `build/compiler`: build again before any other run.)
- **Two are not seen** ("a truth's form lost", "a logic operator's form
  lost"): no input here has a value with no constant that carries an integer
  constant expression's form. The kernel keeps the step because T's rule has
  it.
- **What the decoys are for**: before them, "a class after its round's later
  code" (an operator made before its operand) differed nowhere. Poison reads
  as a record no short path takes, so the operator went to its rule after
  its operand was made, and came out right; and in a timed pass the records
  hold T's own values. Over decoys it differs 3,677 times on the compiler's
  own source and 8,270 on `sqlite3.c`.
- "A deferred arrow not marked wide" differs on neither corpus; the
  fixture's chain `wp->next->m`, whose first link is T's, fails it.
- **Three more, of the classes' order** (`mutations4.py`, `mutations5.py`;
  `mutate4.log`, `mutate5.log`), after the lists' twin gained its order
  check. A decoy can't show `=`, a call or an update made too early: each
  sets the decoys' flag itself.
  - "An operand's later code not a round more", in the function the kernel
    and the twin share: 4,337 records differ on the compiler's own source
    (4,285 of them over decoys) and 10,574 on `sqlite3.c`; the order check
    fails in 791 and 1,504 windows; 12 of the tests' checks fail.
  - "A store not a round after its later operand": no record differs, over
    poison or over decoys. The order check fails in 14 and 7 windows. The
    fixture didn't see it, so it gained a line (`x = !a; x = f(!a);
    x = f(*q); *q += 1; (*q)++;`); with it, 5 of the tests' checks fail.
  - "A call or an update not a round after its later operand": 57 and 129
    records differ over poison (a call gathers its arguments' flags), none
    over decoys; the order check fails in 63 and 67 windows; 5 of the
    tests' checks fail.

## Files

- `scripts/`: `final.sh` (the record's run), `confirm.sh` (`pr`'s),
  `facts.sh`, `facts1.sh`, `profiles.sh`, `profile.sh`, `annotate.sh`,
  `compile.sh`, `build-label.sh`, `lock.sh`, `setup.sh`, `trim.sh`;
  `first.sh`, `second.sh` and `pair.sh` ran the earlier versions;
  `summary.py` and `parts.py` make the tables.
- `results/base`, `results/head`: the record's builds (each with its
  compiler's hash and build log), their runs (`facts-CORPUS-SETTING-N.txt`),
  `head`'s profiles and the whole compile's comparison.
- `results/pr`: the pull request's sources' build and its runs.
- `results/o1` to `o10`: the earlier versions, each with its patch against
  main `be6515fb`.
- `analysis/`: the classes' counts.
- `mutations/`: the mutants and their outcomes.
- `logs/`: the runs' own logs.
