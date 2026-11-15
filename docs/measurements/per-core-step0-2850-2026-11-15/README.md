# What each of the sweeps' answers depends on: buster#2850's step 0, its census (2026-11-15)

[buster#2850](https://github.com/buster14a/buster/issues/2850) is the design for
[buster#672](https://github.com/buster14a/buster/issues/672)'s per-core target. It asks that the node machine's rules
be arithmetic on bytes, or tables of at most 128 entries, so that 64 records are typed by one vector. Its step 0 starts
with this census: for each answer the sweeps give, the fewest bytes of the key that decide it. An answer that needs a
wide key or a large table is a load, and the design's premise fails there.

**Nothing here is a timing.** It is a count over the dumps of the
[one-core record](../one-core-design-672-2026-11-12) (buster `d96b2e73`), run off the 9700X.

- **The dumps:** that record's `sqlite3.dump` and `musl.dump`, copied from the host
  (`~/buster-fast-bench/672-st-claude/scratch`): the SHA-256 of each is the one its `raw/sweeps/dump-sizes.txt` has
  (`b151aa40…` and `b8b2dd79…`). `results/census/census-hashes.txt` has them, the tools' and the compiler's.
- **The prototype:** `scripts/tools/sweeps.c` is that record's file, byte for byte (`ccc961c5…`). Run alone on the two
  dumps it gives that record's counts again: 3,075, 9,742 and 2,400 keys for `sqlite3.c`, 96.53% of its nodes in taken
  expressions, none of 346,998 entries wrong; 88.19% and none of 154,132 for musl.
- **The census:** `scripts/tools/census.c` includes `sweeps.c`, so the reader and every key are the prototype's own.
- **Where:** a cloud session's container (clang 23.1.6, an Intel Xeon). The 9700X isn't needed for a count.
- **To run it again:** `scripts/census.sh DUMPS`, with the two dumps in `DUMPS`. It takes 20 seconds.
  `census DUMP... --list TABLE OPERATOR` lists one operator's distinct samples.

## What is counted

A sample's inputs are the bytes of the prototype's key for that answer. A node's seven fact bytes are the lowering
key's bytes 2 to 8: its type's class (`cls`), its type's facts (`tf`), its constant's kind (`con`), its category
(`cat`), its flags (`flg`: a bit-field, a vector element, an overload set), its object's kind (`obj`) and whether a
member's offset is past the start (`mem`).

| table | a sample | its inputs | its answers |
| --- | --- | --- | --- |
| T | a node the table types (not a leaf, and not one whose facts a lookup gives) | its operand count `n`; its first two operands' types' class and facts (`t0`, `t1`); its first three evaluated operands' facts (`a`, `b`, `c`) | its seven fact bytes |
| C | an operand of a node whose operands' contexts the table gives | the node's operand count, context `ctx` and facts (`s`); the operand's index `idx`, operator `o.op` and facts (`o`); the node's first two operands' facts (`a`, `b`) | the operand's context, and its conversion's target: class `tg.cls` and facts `tg.tf` |
| X | every node | its context, target, store, operand count, operands' types and facts | its template, and its entry count |

- **A set of inputs decides an answer** when no more samples fall in keys with two answers than fall there with the
  whole key. The whole key's own conflicts are the baseline, which the prototype's tables refuse.
- **The fewest inputs** are searched exhaustively up to four. Past that a set that no input can be dropped from is
  found by elimination in three orders, and the report says so.
- **Each operator is taken alone.** Its rule for an answer is a constant, a copy of one input, the greatest of two
  classes and `int`'s, or a table.
- **A rule may read lane arithmetic on the key.** Beside the key's bytes it is offered the greatest of two classes and
  `int`'s, and whether two classes are equal. C's target is also offered the operand's context, C's first answer.
- **A table's rows** are its distinct keys at the set. Its **recoded bits** are its index bits once each input byte
  has gone through a recode of its own, which is one in-register lookup of the byte: values of a byte that never
  disagree at the same other inputs share a code. The recodes are found greedily, so the bits are an upper bound.
- **The trees:** how far back in the postorder a node's operands are, and how many rounds a block of 64 records takes
  before every table-typed node in it has had its operands typed.

## The trees

| | `sqlite3.c` | musl | both |
| --- | ---: | ---: | ---: |
| nodes; full expressions | 266,707; 52,368 | 131,092; 26,451 | 397,799; 78,819 |
| nodes with operands | 154,522 | 72,823 | 227,345 |
| … whose last operand isn't the record before | 0 | 0 | 0 |
| … whose first operand is more than 32 records back | 28 | 56 | 84 (0.037%) |
| … more than 64 back | 0 | 8 | 8 (0.004%) |
| expressions with an operand more than 64 back; their nodes | 0 | 8; 1,000 | 8; 1,000 (0.25% of the nodes) |
| … more than 127 back | 0 | 4 | 4 |
| rounds a block of 64 records | 2.95 | 3.61 | 3.17 |
| blocks of at most 4 rounds; at most 6 | 91.2%; 98.9% | 81.3%; 94.3% | 88.0%; 97.4% |

The facts take few values over the two corpora: `cls` 14, `tf` 5, `con` 4, `cat` 3, `flg` 2, `obj` 8, `mem` 2.

## T: a typed node's facts

95,802 samples in the two corpora (59,298 and 36,504). No key is in conflict, and every set was found exhaustively.
Shares are of the samples, by their operator's rule:

| answer | population | constant | copy | greatest | table | the tables' rows (the largest) |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| `cls` | `sqlite3.c` | 53.01% | 32.22% | 10.55% | 4.23% | 26 (8) |
| | musl | 40.78% | 27.57% | 23.82% | 7.83% | 24 (15) |
| | both | 48.35% | 30.39% | 13.06% | 8.20% | 48 (20) |
| `tf` | `sqlite3.c` | 61.86% | 30.58% | | 7.57% | 16 (10) |
| | musl | 51.77% | 32.61% | | 15.62% | 17 (9) |
| | both | 57.27% | 32.10% | | 10.63% | 18 (10) |
| `flg` | `sqlite3.c` | 72.02% | | | 27.98% | 4 (4) |
| | musl | 77.21% | 22.79% | | | |
| | both | 73.99% | | | 26.01% | 4 (4) |
| `con`, `cat`, `obj`, `mem` | each | 100% | | | | |

Every table is within 5 recoded bits. The class's rules over both corpora:

- **Constant:** the comparisons, `&&`, `||`, `!`, a condition, `&x`.
- **A copy of the first operand's type's class:** `=`, the compound assignments, the increments. Of the second's: `,`.
- **The greatest of the two operands' types' classes and `int`'s:** `+`, `&`, `|`, `^`, `/`, `%`. Of the first's and
  `int`'s: `<<`, `>>`, `-x`, `~`.
- **A table,** each the greatest class and one or two more bytes: `-` (its second operand's type's facts and a
  bit-field's flag, 10 rows), `*` (a bit-field's flag, 10), `?:` (20) and `+x` (8).

Two things the tables say. The greatest is of the operands' **types'** classes, not of the evaluated operands' facts:
a folded operand isn't an evaluated one (`x / 2` has one). And a bit-field's class isn't its promoted class: an
unsigned bit-field narrower than `int` has class `U32` and promotes to `int`, which is every row that keeps `*` and
`+x` from being the greatest alone.

## C: an operand's context and target

272,035 samples (179,916 and 92,119).

| answer | population | constant | table | the tables' rows (the largest) | at 7 recoded bits or fewer | at 8 | at more |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| context | `sqlite3.c` | 62.97% | 37.01% | 95 (60) | 37.01% | | |
| | musl | 49.54% | 50.40% | 175 (67) | 50.40% | | |
| | both | 47.60% | 52.37% | 187 (72) | 52.37% | | |
| target's class | `sqlite3.c` | 31.65% | 68.35% | 432 (46) | 65.41% | 2.94% | |
| | musl | 22.29% | 77.71% | 647 (191) | 70.44% | 6.48% | 0.80% |
| | both | 28.46% | 71.54% | 762 (191) | 66.71% | 4.56% | 0.27% |
| target's facts | `sqlite3.c` | 55.05% | 44.95% | 29 (8) | 44.95% | | |
| | musl | 61.90% | 38.10% | 97 (67) | 38.10% | | |
| | both | 56.10% | 43.90% | 112 (73) | 43.90% | | |

In conflict with the whole key over both corpora: 0 samples for the context, 76 for the target's class, 21 for its
facts.

- **The target is the wanted class unless the operand has it.** For nine operators (`=`, `*`, `/`, `%`, `&`, `|`,
  `^`, `*=` and a conversion) the set is the node's class and whether the operand's equals it, at most 24 rows an
  operator. For the comparisons it is the greatest of the two operands' classes and `int`'s and whether the operand's
  equals that, with a bit-field's flag for `==`, `!=`, `>` and `>=`: 18 rows, those four agreeing as one table.
  Without the derived inputs and the operand's context the same rules read up to four bytes each, and the cast's
  is 310 rows on `sqlite3.c`.
- **The cast is a fifth of the samples** (54,750, most of them the discards). Its operand's context reads the cast's
  own context, the operand's operator and three of the operand's fact bytes: 72 rows and 7 recoded bits, by a set
  found by elimination. Its target then reads the cast's class, whether the operand's equals it, and the operand's
  context: 29 rows.
- **Pointer arithmetic is the 8-bit case:** `+`'s target reads the node's and the operand's class and type facts (41
  rows), `+=`'s 52.
- **The one large rule** is the operands of a `value` node: 733 samples, all musl's, 191 rows by nine inputs, 74 of
  the samples in conflict with the whole key. They are among the nodes the tasks pop twice, which the prototype
  refuses.

## X: a node's template

397,799 samples.

| answer | population | the tables' rows (the largest) | at 7 recoded bits or fewer | at 8 | at more |
| --- | --- | ---: | ---: | ---: | ---: |
| template | `sqlite3.c` | 1,306 (185) | 20.82% | 0.33% | 78.59% |
| | musl | 1,376 (144) | 20.45% | 3.88% | 75.47% |
| | both | 1,900 (230) | 15.90% | 1.22% | 82.87% |
| entry count | `sqlite3.c` | 663 (80) | 99.74% | | |
| | musl | 772 (130) | 60.30% | 39.49% | |
| | both | 1,101 (160) | 58.15% | 41.84% | |

A template's rule reads up to eight bytes of the key (its context, its target, its store, its operand count, its
operands' types and its own facts), 72% of the samples by a set found by elimination. 2,269 samples are in conflict
with the whole key, where a node no template holds shares a key with one a template does.

## What it decides

- **T's and C's rules are lane arithmetic and small tables.** Over both corpora every rule of T is a constant, a copy,
  the greatest, or a table of at most 20 rows. Every rule of C but one is a constant or a table of at most 73 rows and
  8 recoded bits, and that one is 0.27% of the operands, among nodes the prototype already refuses.
- **The template is a load.** Its key is up to eight bytes and 1,900 rows, as buster#2850 has it.
- **An operand is within reach.** Its last operand is always the record before, and 8 nodes of 397,799 have an operand
  more than 64 records back.
- **A block takes about three rounds:** 3.17 on average, six or fewer for 97.4% of the blocks.

So the census holds, and the second path of step 0 is worth building.

## Limits

- **Two corpora.** A rule is what `sqlite3.c` and musl show. The one-core record found that one corpus's tables give
  the other 23 wrong entries, all one key's: tables are baked from the rules, and this census doesn't replace that.
- **The lookups are given,** as in the prototype: a leaf's facts, a cast's, a member's, a call's, a subscript's and a
  dereference's. Nothing here says what they cost.
- **No diagnostic is in the dump.** What a rule has to prove silent isn't counted.
- **An operator at a time.** A vector holds many operators, so a kernel computes each shape's answer and selects by
  the operator. The class's rules have four table shapes beside the copies and the greatest; C's target has
  seventeen. The count of shapes, not of rows, is what the second path will pay for.
- **The rounds** are counted over a unit's postorder in blocks of 64 records, not body by body.
