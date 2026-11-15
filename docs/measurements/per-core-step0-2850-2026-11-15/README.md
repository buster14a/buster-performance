# buster#2850's step 0: the sweeps on byte columns, and the census before them (2026-11-15)

[buster#2850](https://github.com/buster14a/buster/issues/2850) is the design for
[buster#672](https://github.com/buster14a/buster/issues/672)'s per-core target. Its step 0 tests the design's middle
outside the compiler, on the dumps of the [one-core record](../one-core-design-672-2026-11-12) (buster `d96b2e73`):
every evaluated node of every lowered body, with the lowering's key and the entries its task wrote. That record's
`sweeps.c` types the nodes (T), gives each operand its context and conversion (C), chooses each node's template and
writes its entries (X), an expression at a time. Step 0 has two parts, and both are here:

1. **A census:** for each answer the sweeps give, the fewest bytes of the key that decide it. It is a count, run off
   the 9700X. It held, and is the second half of this file.
2. **A second path:** the same sweeps over the same dumps on the layout the issue proposes, checked against the first
   path entry for entry and timed on the 9700X.

## The result

The 9700X, CPU 2, each run under the host's lock. Cycles a node of the taken expressions; the median of 21 passes, and
the range over three processes.

| | `sqlite3.c` | musl |
| --- | ---: | ---: |
| the first path, an expression at a time | 110 to 112 | 115 to 117 |
| … its instructions; mispredicted branches | 277.9; 1.2 | 309.9; 1.3 |
| the second path, its rules read at run time | 23.4 to 23.6 | 29.3 to 29.5 |
| … its instructions; mispredicted branches | 100.8; 0.026 | 129.5; 0.048 |
| **the second path, its rules baked** | **16.6 to 16.7** | **20.5 to 20.7** |
| … its instructions; mispredicted branches | 57.0; 0.025 | 67.7; 0.045 |
| … each pass after 200 ms of the first path (one process) | 24.0 | 21.6 |
| … a process's first pass | 22.5 to 22.9 | 26.6 to 28.9 |

Against the issue's gate for step 0:

| the gate | `sqlite3.c` | musl |
| --- | --- | --- |
| every entry the stream's | 346,998 entries, none wrong | 152,052, none wrong |
| the taken share no lower than the prototype's | 96.53%, the same expressions | 87.54% against 88.19% |
| 20 cycles a taken node or less | 16.7 back to back; 24.0 after the first path | 20.6; 21.6 |
| 0.2 mispredicted branches a node or fewer | 0.025 | 0.045 |

- **It is at the line, not clear of it.** With the rules baked, `sqlite3.c` is under 20 back to back and musl is 0.6
  over; after 200 ms of the first path they are 4.0 and 1.6 over. With the rules read at run time it is 23.5 and
  29.4. Nothing is near the 40 the issue takes for a refutation.
- **Exact.** Every fact, context, target and template of every record is the truth's or the first path's, and the
  entries are compared after a pass that writes over poisoned arrays, so an entry the path didn't write shows.
- **musl's share is 0.65 points lower.** Six expressions (852 nodes) that the first path takes have an operand more
  than 64 records back, and the layout leaves such an expression to the scalar path, as the issue has it.
- **"After the first path" is this harness's memory, not a vector warm-up.** The instructions and the mispredicted
  branches are the same; the first-level cache's fills that come from memory rise from 0.006 to 0.35 a node on
  `sqlite3.c` ("Where the fills come from"). The harness's arrays are as long as the unit, and 200 ms of the
  first path over the whole unit pushes the second path's columns out of the third-level cache. A compile's window
  would have been written just before.

## How it was run

- **The dumps:** the one-core record's `sqlite3.dump` and `musl.dump` on the host
  (`~/buster-fast-bench/672-st-claude/scratch`), with the SHA-256 that record's `raw/sweeps/dump-sizes.txt` has
  (`b151aa40…` and `b8b2dd79…`).
- **The tools,** in `scripts/tools`: `sweeps.c` is that record's file, byte for byte (`ccc961c5…`). `census.c`
  includes it, and `lanes.c` includes `census.c`, so the reader, the keys and the first path are the prototype's own.
- **The second path's runs:** `scripts/lanes.sh DUMPS`, on the 9700X (clang 23.1.1, `-O3 -march=native`), with
  `LOCK=~/buster-fast-bench/exclusive.sh`: each build and each run takes the lock by itself, pinned to CPU 2.
  `results/lanes/lanes-hashes.txt` has the tools', the dumps' and the compiler's; each run's whole output is a file
  there.
- **Sanitizers:** both builds run both dumps clean under the address and undefined-behaviour sanitizers, with the
  same checks passing. That was in the session's container; its output isn't a file here.
- **A run** learns the rules from the dump, runs the first path, runs the second path's passes, then one more pass
  that isn't timed and is the one checked. It prints the rules' counts, the rounds, the checks and the times.
  `--split` reads the counters around each part, which adds system calls to the whole: the whole's time is from the
  runs without it.
- **The census:** `scripts/census.sh DUMPS`, in a cloud session's container. It takes 20 seconds and needs no lock.

## The second path

`lanes.c`. A record is a node of the dump, in postorder; a block is 64 records; a window is whole expressions of
about 4,096 records, and every pass runs over a window before the next pass starts.

- **Byte columns.** A record's seven facts, its operator, its context, its conversion's class and facts, its operand
  count and its place among its parent's operands are a byte each, a column each. A record's operands are byte
  distances back in the postorder, and its parent a byte distance forward.
- **Given,** as in the prototype: a leaf's facts, a cast's, a member's, a call's, a subscript's and a dereference's;
  an operand's context where a prototype gives the operator's operands; every entry's value.
- **The rules,** learned from the dump an operator at a time: a constant, a copy of one input, or a table. The
  inputs include lane arithmetic on the bytes: the greatest of two classes and `int`'s, whether two classes are
  equal, and the class a conversion is to unless the operand has it. A table's inputs are each recoded to a few bits
  by one `vpermb`, and index at most 256 bytes.

  | answer | `sqlite3.c`: operators with a constant; a copy; a table | its tables | musl | its tables |
  | --- | --- | ---: | --- | ---: |
  | T: the class | 12; 26 (of 4 inputs); 4 | 4, 26 rows | 11; 28 (4); 2 | 2, 16 rows |
  | T: the type's facts | 33; 6 (2); 3 | 3, 10 rows | 28; 10 (2); 3 | 3, 10 rows |
  | T: the flags | 41; 0; 1 | 1, 4 rows | 40; 1 (1); 0 | |
  | T: the other four facts | 42 each | | 41 each | |
  | C: the context | 39; 2 (1); 8 | 3, 13 rows | 31; 2 (2); 18 | 9, 36 rows |
  | C: the target's class | 17; 14 (2); 18 | 13, 133 rows | 16; 20 (2); 14 | 12, 126 rows |
  | C: the target's facts | 44; 0; 5 | 5, 20 rows | 46; 0; 5 | 5, 20 rows |

  One operator of musl's has no rule for the target's class within 8 index bits (the operands of a `value` node, as
  the census found): its 684 operands take the truth and their expressions aren't taken.
- **T, in rounds.** A block's constants are one lookup by the operator. A round fetches the operands' facts with
  `vpermi2b` over this block and the one before, and gives each record whose rules' operands are typed its copies
  and tables. A record waits only for the operands its operator's rules read: a comparison's class is a constant,
  so it is typed in the first round whatever is under it. A block then takes 1.51 rounds on `sqlite3.c` and 2.38 on
  musl, where the census counts 2.95 and 3.61 with every operand awaited.
- **C,** from the last block to the first: an operand's context from its parent's operator, the parent's context
  and their facts, again while a context of the block changes (1.66 rounds a block, 1.77 on musl), then its target.
- **The template:** a record's 16 key bytes and its operator, hashed 8 records at a time in the vector, then one
  load of a bucket of four keys, compared at once. No branch a record.
- **X,** in six steps (`lanes_expand`):
  1. The records that need care are listed by compress stores: those that write before or between their operands,
     those no root is taken with, and those with more than four entries.
  2. A record that writes early gives its runs' room to the records the runs come before; a root that isn't taken
     gets no room.
  3. An entry's place is a prefix sum of 16 records at a time, stored with the template's row's place in one word.
  4. Each root's place is read back.
  5. Every record's row is written at its place with no branch: 8 kinds, 8 classes and 4 values, whatever the count.
  6. The few records with more than four entries get the rest, and the early runs are written into their gaps.

  The entries are the first path's stream: the same arrays, the same places.

### Rules read, and rules baked

As built, T and C walk the learned rules' lists: each lookup's table and inputs are found through the lists at run
time, at about ten scalar instructions a vector operation. A compiler has its rules when it is built. So
`lanes DUMP --bake FILE` writes the same rules as straight-line code with the tables as constants
(`results/lanes/baked-sqlite3.h`, `baked-musl.h`), and a build with `-DLANES_BAKED` compiles that in. A baked build
checks its rules against those learned from the dump at hand and refuses another dump's. Both builds are timed;
the baked one is what the gate is read against, and that is a judgement: the rules here are learned from the same
dump they are run on, as the first path's tables are.

## The parts

Cycles a taken node, with the instructions and mispredicted branches, from the `--split` runs.

| | `sqlite3.c`, baked | read | musl, baked | read |
| --- | ---: | ---: | ---: | ---: |
| T | 2.6 (7.6; 0.009) | 5.8 (26.6) | 3.4 (9.5; 0.013) | 7.0 (34.8) |
| C | 2.4 (6.7; 0.006) | 6.1 (31.5) | 3.6 (9.1; 0.007) | 8.7 (45.6) |
| the keys and their hashes | 1.1 (3.0) | 1.1 | 1.2 (3.3) | 1.2 |
| the templates' lookup | 3.7 (14.6) | 3.7 | 4.1 (16.1) | 4.1 |
| X | 6.8 (23.6; 0.012) | 6.9 | 8.4 (27.9; 0.026) | 8.4 |

X is two fifths of the baked path. Its steps, in TSC ticks a taken node from the runs without `--split` (a tick is
about 1.46 cycles there):

| X's step | `sqlite3.c` | musl |
| --- | ---: | ---: |
| the listed records | 0.50 | 0.56 |
| the early runs' room, and the roots not taken | 0.38 | 0.81 |
| the places | 0.48 | 0.51 |
| the roots' places | 0.24 | 0.26 |
| **the rows** | **2.32** | **2.50** |
| the entries past a record's fourth | 0.14 | 0.18 |
| the early runs | 0.57 | 0.88 |

### What bounds the rows

The rows' loop is 11.2 instructions and 3.4 cycles a taken node: two loads in the record's order, the row, 32 bytes of
the payload, and three stores. It is not bound by its instructions. `lanes.c`'s `LANES_ROWS_VARIANT` builds it as
experiments (`results/lanes/rows-variant-*.txt`):

| the rows' loop | cycles | instructions |
| --- | ---: | ---: |
| as it is | 3.39 | 11.2 |
| the values as two stores of two entries | 4.07 | 13.3 |
| the values alone (no kinds, no classes) | 2.27 | 7.7 |
| the kinds and the classes alone | 2.26 | 10.0 |
| the values' store alone, of nothing read | 1.78 | 7.8 |
| the streams' lines prefetched 384 bytes ahead | 4.06 | 13.3 |
| … and the record's own columns and the kinds' | 4.98 | 16.4 |

Each stream costs half a cycle to a cycle a record whatever the instructions around it, and a prefetch instruction
costs what any other does. Before the loop lost its branch it was 19.8 instructions and 4.1 cycles. Variant 5, the
reads alone, says nothing: the compiler turns it into gathers. What the bound is isn't settled here: the loop's data is 0.6 new lines a record across eight streams, all from the second-level
cache, since a window's columns and entries are larger than the first.

### Where the fills come from

`sqlite3.c`, baked: the first-level cache's fills a taken node over a whole pass, by their source
(`results/lanes/fills-*.txt`).

| | back to back | each pass after 200 ms of the first path |
| --- | ---: | ---: |
| from the second-level cache | 2.85 | 2.59 |
| from the third | 0.17 | 0.35 |
| from memory | 0.006 | 0.35 |

### The window

`sqlite3.c`, baked, cycles a taken node: 20.9 at 256 records a window, 17.5 at 1,024, 16.7 at 4,096, 16.4 at 16,384
and 16.7 with the unit as one window. A window that fits the first-level cache doesn't pay here: each
window's edge blocks are worked twice, and the passes' starts cost more than the second-level cache does.

## What moved it

The second path's first exact version was 63.2 cycles a taken node on `sqlite3.c`. What each change bought, from this
session's runs on the same host under the same lock (their outputs weren't kept as files, so these are the session's
figures, not this record's):

| the change | cycles a taken node after it |
| --- | ---: |
| T's and C's rounds restructured; the template's key hashed in the vector | 43.1 |
| the template's lookup with no branch (a bucket's four keys compared at once) | 39.1 |
| X: places by a prefix sum, the records that need care listed, no bookkeeping a record | 28.5 |
| the rules as constants, copies and tables; a record waits only for what its rules read | 26.7 |
| the rules baked | 19.1 |
| X's sparse steps on the byte columns, in two lists | 17.2 |
| X's rows with no branch, the long rows after them | 16.7 |

Three things didn't pay: staggering the columns against the cache's sets (63.7 against 63.2), software prefetch in
the rows' loop, and a window small enough for the first-level cache.

## What it decides

- **The layout carries the middle to the line the issue drew, on these dumps, with the lookups given.** The first
  path is the one-core record's prototype (99.7 cycles a taken node there, 110 to 117 in this harness); the second
  is 16.7 and 20.6 with the rules baked.
- **The rules' form matters as much as the layout.** Read from lists at run time the same kernels are 23.5 and 29.4:
  T and C are then 11.9 of `sqlite3.c`'s cycles where baked they are 5.0.
- **X is now the largest part,** and its rows' loop is bound by its streams. The entries' layout is the first
  path's (kinds, classes and values as three arrays); one that wrote a record's kinds and classes as one store
  would have a stream less.
- **The census's counts held in the kernel:** T's rules are constants, copies and tables that add to at most 26
  rows an answer; C's target's class is the largest, 133 rows in 13 tables.

## Limits

- **Outside the compiler.** The records are a dump's, the lookups and the entries' values are given, and no
  diagnostic is in the dump. Step 1 of the issue measures the lookups.
- **Learned on what it runs.** The rules and the templates' table are learned from the dump they are timed on, as
  the first path's are. This measures the layout's cost, not the tables' safety.
- **Two corpora,** and the baked kernel is one corpus's: `sqlite3.c`'s rules and musl's differ, and a compiler's
  would be the union.
- **The harness's memory is not a compile's.** Its arrays are as long as the unit and every pass reads them from
  the second and third-level caches. Back to back flatters nothing a compile would have warmer, and "after the first
  path" charges the path for columns a compile would have just written.
- **A taken node,** not a token: the nodes of the expressions the path takes, 96.5% and 87.5% of the evaluated
  nodes. The others, the statements and the file scope are not here.

# The census: what each of the sweeps' answers depends on

The first part of step 0: for each answer the sweeps give, the fewest bytes of the key that decide it. An answer that
needs a wide key or a large table is a load, and the design's premise fails there.

**Nothing in this part is a timing.** It is a count over the two dumps, run off the 9700X.

- **The prototype** run alone on the two dumps gives the one-core record's counts again: 3,075, 9,742 and 2,400 keys
  for `sqlite3.c`, 96.53% of its nodes in taken expressions, none of 346,998 entries wrong; 88.19% and none of
  154,132 for musl.
- **Where:** a cloud session's container (clang 23.1.6, an Intel Xeon). `results/census/census-hashes.txt` has the
  dumps', the tools' and the compiler's.
- **To run it again:** `scripts/census.sh DUMPS`, with the two dumps in `DUMPS`.
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

The facts take few values over the two corpora: `cls` 14, `tf` 5, `con` 4, `cat` 3, `flg` 2, `obj` 8, `mem` 2. The
rounds here wait for every operand; the second path's wait for those a rule reads, and are 1.51 and 2.38.

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
  is 310 rows on `sqlite3.c`. The second path offers that wanted class as an input, and 14 of `sqlite3.c`'s operators
  then copy it.
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

## What the census decided

- **T's and C's rules are lane arithmetic and small tables.** Over both corpora every rule of T is a constant, a copy,
  the greatest, or a table of at most 20 rows. Every rule of C but one is a constant or a table of at most 73 rows and
  8 recoded bits, and that one is 0.27% of the operands, among nodes the prototype already refuses.
- **The template is a load.** Its key is up to eight bytes and 1,900 rows, as buster#2850 has it.
- **An operand is within reach.** Its last operand is always the record before, and 8 nodes of 397,799 have an operand
  more than 64 records back.
- **A block takes about three rounds** when a record waits for every operand: 3.17 on average, six or fewer for 97.4%
  of the blocks.

## The census's limits

- **Two corpora.** A rule is what `sqlite3.c` and musl show. The one-core record found that one corpus's tables give
  the other 23 wrong entries, all one key's: tables are baked from the rules, and this census doesn't replace that.
- **The lookups are given,** as in the prototype. Nothing here says what they cost.
- **No diagnostic is in the dump.** What a rule has to prove silent isn't counted.
- **An operator at a time.** A vector holds many operators, so a kernel computes each rule's answer and selects by
  the operator. The second path is what that costs.
- **The rounds** are counted over a unit's postorder in blocks of 64 records, not body by body.
