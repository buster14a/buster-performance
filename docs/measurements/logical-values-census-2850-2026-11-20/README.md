# A census of `&&`, `||`, `?:` and the comma on the window (#2850, step 2)

What C on the window lists today for a logical operator, a conditional or a comma, what the reference (C and X on
T's columns at reader time) makes of each such record, and which of them a set of candidate rules would take. It is
the census before [the piece's specification](https://github.com/buster14a/buster/issues/2850): a count, with no
timing. Nothing here is in a compile.

- **The tree:** buster `8a7427df2` (pull request buster14a/buster#3197's head, the entries' values on the window)
  with `census-logical.patch`, an experiment's patch that is not for a commit. A Develop build in the cloud
  container (no reading here is a timing).
- **The run:** `BUSTER_CENSUS_L=1 build/compiler measure-node-machine --shadow --passes 0 --window-rows --list 20`
  on `sqlite3.c`, Lua 5.4.8's 34 files and musl's 1,336 units (`out/shadow-*.txt` are the runs' own reports, which
  the patch doesn't change: 0 differences).
- **The lines** (`lines/*.tsv.gz`), for each expression with an `&&`, an `||`, a `?:`, a comma or a selection:
  - `le`, the reference's expression: the batch, the root's and its operand's records, its records' count, the
    refusal (0 taken, 6 C's template, 7 X's row), the record it stopped at, the root's context and target, its
    labels, its entries, whether the tests refuse it, the target's class and facts;
  - `lr`, a record of it as the reference has it: its operator, its operands, its state, context, template and
    target, its type, class and facts, T's two conversions, its constant's kind, category and flags, its hook,
    whether it has labels and its first label, the target's and the conversions' classes and facts, whether its
    truth is known and its truth; then its row's entries (kind:class:value) with the segment after it;
  - `we` and `wr`, the window's expression and each record of it: its verdict (1 listed, 2 taken, 3 refused), and
    a record's operator's class, why it lists the expression, its masks' bits, its template, its bytes and its
    distances.
- **The counts:** `census1.py` to `census4.py` over the lines, their outputs in `out/`:
  `python3 census4.py lines/sqlite3.tsv.gz lines/lua.tsv.gz lines/musl.tsv.gz`.

## What is listed, and what the reference makes of it (`out/census1.txt`)

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| expressions with such an operator | 3,133 | 876 | 2,002 |
| the window takes already (a statement's condition's `&&`, `\|\|` and `!` as branches) | 2,047 | 200 | 792 |
| the window lists, and the reference takes | 841 | 393 | 1,065 |
| the window lists, and the reference refuses (C's template; X's row) | 245; 0 | 281; 0 | 111; 4 |
| the window refuses, as the reference does | 0 | 2 | 30 |
| **listed for a logical operator, a conditional or a comma alone, and taken by the reference** | **825** | **387** | **1,033** |
| the same, refused by the reference | 109 | 276 | 97 |

The others are listed for another reason too (a wide value, a division by a constant, a call), which this piece
doesn't touch. Of Lua's 276 refused, the reference stops at a comma of void's class in 266 (`((void)L, ((void)0))`
and the like: C's comma takes a scalar class alone) and at another record in 10.

## The listed records, by what the reference makes of them (the three corpora together; `out/census2.txt` has each corpus's, by consumer)

| | records |
| --- | ---: |
| a conditional, two labels (`BRANCH`) | 1,343 |
| a comma (`PASS`) | 743 |
| an `\|\|`'s value, two labels | 434 |
| an `&&` or an `\|\|` evaluated as branches, a conditional's condition | 87 |
| an `&&`'s value, two labels | 58 |
| a conditional whose condition is known (`PASS`, one arm not evaluated) | 55 |
| a `!` over or under one | 23 |
| an `&&` or an `\|\|` whose first operand's truth is known (`SECOND`) | 22 |
| a record that is not evaluated, or a folded one | 20 |

## Their features (`out/census3.txt`)

- **A conditional's condition is a value tested after its row** in 515 of `sqlite3.c`'s 525, 314 of Lua's 358 and
  427 of musl's 460; the others' is an `&&` or an `||` evaluated as branches. Its type is its target in 510, 312
  and 410 of those (the others' conversion writes no entry: the same class).
- **A conditional's first arm is converted to another class** in 44, 53 and 85 (a `CONVERT` before its jump), and
  its target is its own type in 410, 241 and 339.
- **A conditional of void's class:** none on `sqlite3.c`, 55 on Lua, 26 on musl.
- **A logical operator's value's own row is four entries** in 68 of `sqlite3.c`'s 71, 26 of Lua's 42 and 28 of
  musl's 396; five where its value is discarded (`(void)(x || (f(), 0))`, musl's `assert`: 368 there and 16 on
  Lua) and five where its second operand's class is a narrow one (3 on `sqlite3.c`, none elsewhere).
- **A comma is discarded** (its target void's) in 317 of `sqlite3.c`'s 326, 87 of Lua's 239 and 172 of musl's
  178; its first operand is a store, an update, a call, a cast to void or another comma.
- **An expression's labels:** two in 538, 241 and 794 of the expressions (one operator with labels); four or more
  in 22, 58 and 16.
- **No selection** is in an expression the window lists for these alone.

## The candidate rules, simulated (`out/census4.txt`)

The rules of the specification: a comma that is not read for its address; a conditional, an `&&` and an `||` as a
value whose first operand's truth is not known, with a condition that is a value or an `&&` or an `||` evaluated
as branches; a logical operator's second operand of no narrow class. An expression is taken where every record
that lists it is one the rules take. (No comma of these expressions is read for its address.)

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| listed for these alone and taken by the reference: expressions; records | 825; 10,694 | 387; 9,854 | 1,033; 17,839 |
| **the rules take: expressions; records** | **793; 10,359** | **366; 9,438** | **970; 16,849** |
| not taken: a condition whose truth is known | 17 | 1 | 56 |
| not taken: a `!` over or under a logical operator | 2 | 19 | 1 |
| not taken: a record that is not evaluated, or a folded one (the simulation leaves both out) | 10 | 1 | 6 |
| not taken: a second operand of a narrow class | 3 | 0 | 0 |
| taken, with one operator with labels and no call | 325 | 76 | 211 |
| taken, with one operator with labels and a call or more | 201 | 160 | 578 |
| taken, with two operators with labels or more | 32 | 63 | 20 |

An expression with one operator with labels and one call has one number of each kind, an expression's first: the
numbering has nothing to do for it if a call's row and a label are counted apart.
