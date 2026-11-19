# A census of X's rows (buster#2850's step 2), 2026-11-19

The count specified in
[buster#2850's comment](https://github.com/buster14a/buster/issues/2850#issuecomment-7022279385): what each record's
row on the tape (the node machine's X sweep, `node_machine_expand`) depends on, before X is written on the window.
Lines from the shadow at reader time; no kernel, no compile path, no timing.

An experiment's patch on main `b84780116` prints a line for each record of each expression X takes (`xx:`, with
`BUSTER_CENSUS_X=1`, in the reader-time sweeps `measure-node-machine --shadow --passes 0 --window-contexts` runs): what
the window has of the record, what C answered, and its row's three parts as lists of entries, a kind and a class
each: its own entries, its conversion's, and what follows its row. Built and run on the 9700X (`9700x/job-xcensus*.sh`;
the lines are aggregated there to unique rows with their counts, `aggregate-x*.py`), on `sqlite3.c`, Lua, musl and
the compiler's own source (the patched tree's `main.c`).

- `first/`: the first patch (`census-x.patch`) and its rows; `analysis-4.txt` (`analyze-x.py`: keys found by backward
  elimination over the lines' raw features), `own-by-template-3.txt`, `keys-4.txt` (`analyze-keys.py`: keys derived as
  X's code reads its inputs).
- `second/`: the second patch (`census-x2.patch`: an update's plan's two kinds and its stored type's facts too), its
  rows, and the results below: `shapes-4.txt` (`analyze-shapes.py`), `distributions-4.txt`, `values-4.txt`
  (`values-by-source.py`), `own-by-template-4.txt` (`analyze-own.py`).

## 1. What was counted

739,444 records (252,092 on `sqlite3.c`, 57,160 on Lua, 186,990 on musl, 243,202 on the compiler's own source) and
942,482 entries: 1.275 a record.

| entries a record | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| its own | 161,479 | 479,039 | 57,594 | 40,120 | 908 | 304 | | |
| its conversion's | 628,867 | 106,601 | | 1,324 | 2,652 | | | |
| what follows its row | 697,830 | 12,462 | 5,531 | 18,304 | 4,432 | | 797 | 88 |

The three together: 148,371 records write none, 377,781 one, 133,561 two; 1,874 write nine to eleven.

## 2. Each part is a table

Keys derived as X's code reads its inputs (`second/shapes-4.txt`):

| part | key | rows | records in conflict | longest list |
| --- | --- | ---: | ---: | ---: |
| its own entries | its template; whether it loads, its member's offset is not zero, its two conversions' classes are narrow, its constant folded its conversion; its operator; a constant's shape (its context, its kind, its category, its class's group, its object, its offset); an update's plan (its bits, how it reads and writes its destination, its operation, its stored type's facts, which of its classes are the same) | 291 | 0 | 5 |
| its conversion's | whether it is evaluated and converts (a value's context, a target that is not its own type), whether its constant folded it, its class and facts, its target's class and facts | 170 | 0 | 4 |
| what follows its row | its state's bits; an update's plan for its first row; whether its hook's first conversion's class, or its own target's, is narrow; whether its hook's class is void, and its hook is an `\|\|`; its object | 141 | 0 | 7 |

The key gives each part's entries' kinds, and so their number, with no conflict on the four corpora. Each entry's class
is, for every record of its key, one same source: a class the record has, or a fixed one.

| an entry's class's source | its own entries | its conversion's | what follows |
| --- | ---: | ---: | ---: |
| the record's own class | 428,882 | | 33,548 |
| fixed by the key | 218,807 | 121,181 | 62,358 |
| its target's | 48,258 | | 5,186 |
| its first conversion's | 23,166 | | |
| its second conversion's | 626 | | |
| an update's calculated class | | | 470 |

The first census's lines lacked two of an update's inputs (how its plan writes its destination, a local's or a
global's store; and whether its stored type is bool): 96 records' numbers of entries and 126 records' entries were in
conflict there (`first/keys-4.txt`), and none with them.

## 3. Against the gates

1. **The counts are a table: met, but for the conversions on the compiler's own source.** Learned on three corpora
   and read on the fourth, each way round (`shapes-4.txt`, the entries' kinds, which give their number):

   | read on | its own entries | its conversion's | what follows |
   | --- | ---: | ---: | ---: |
   | `sqlite3.c` | 99.92%, 0.08% flagged | 99.97%, 0.03% | 99.98%, 0.02% |
   | Lua | 99.98%, 0.02% | 100.00%, 0 | 100.00%, 1 record |
   | musl | 99.59%, 0.41% | 99.89%, 0.11% | 99.97%, 0.03% |
   | the compiler's own source | 99.83%, 0.17% | **97.36%, 2.64%** | 99.89%, 0.11% |

   No record is read wrongly: every other one's key is one the three had not seen. The conversions the compiler's own
   source has and the others lack are to bool (3 and 4 entries). Each key packs into six bytes: a constant's shape and
   an update's plan share the bytes no other template reads.
2. **So are the kinds and the classes: met, with the same exception** (the same figures: the kinds give the number).
3. **Not refuted.** The rows that cover 99% of a corpus's records are at most 93 for a record's own entries, 39 for its
   conversion's and 16 for what follows; 159, 78 and 53 cover 99.9%.
4. **Counted** (`values-4.txt`): each entry's value's source, read off X's code by the entry's kind, its part and its
   record's template.

   | an entry's value | entries | |
   | --- | ---: | ---: |
   | an object's number (the record's, its destination's, a temporary's) | 256,767 | 27.24% |
   | none | 255,117 | 27.07% |
   | the record's constant (its payload, or its offset) | 103,897 | 11.02% |
   | an access's value, by its class and type (0 here: no access is a vector's) | 75,880 | 8.05% |
   | fixed: 1, 0, or 0 or 1 by the operator | 101,765 | 10.80% |
   | the member's offset | 46,885 | 4.97% |
   | the call's row, a count of calls | 35,403 | 3.76% |
   | a label, a count of labels | 28,203 | 2.99% |
   | a stride, the type's row's | 23,318 | 2.47% |
   | an object's symbol, a table by object | 10,243 | 1.09% |
   | the update's constant | 5,004 | 0.53% |

   Rows longer than eight entries: 1,874 records (1,722 of nine, 7 of ten, 145 of eleven), all three parts together.

## 4. By template (`second/own-by-template-4.txt`)

A record's own entries: its template's records, their number of entries, and the features a backward elimination
kept for that number (`analyze-own.py`; its features are the first census's, so an update's plan lacks the two inputs
of section 2 here, and 90 of its records are in conflict in this table alone):

| template | records | entries | the features kept |
| --- | ---: | --- | --- |
| LOCAL | 192,330 | 1 | none |
| CONSTANT | 127,329 | 1 to 3 | its object, its offset, its target's class, whether its target is its type |
| PASS | 119,306 | 0 | none |
| MEMBER | 63,485 | 0 to 3 | its type's address fact, its context, whether its offset is zero |
| BINARY | 62,020 | 1 | none |
| CALL | 35,403 | 1 | none |
| TRUTH | 24,928 | 2 or 3 | whether its first conversion's class is narrow |
| POINTER | 21,495 | 1 or 2 | its operator, its type's address fact, its context |
| STORE_LOCAL, STORE_GLOBAL, STORE | 37,031 | 1 | none |
| BRANCHES | 17,750 | 0 | none |
| UPDATE | 14,110 | 2 to 5 | its operator, its plan's bits and classes |
| BRANCH | 5,966 | 0, 4 or 5 | its operator, whether its second conversion's class is narrow |
| DEREFERENCE | 4,914 | 0 or 1 | its type's address fact, its context |
| GLOBAL | 1,561 | 1 | none |
| UNARY | 773 | 1 | none |
| SECOND | 23 | 2 or 3 | whether its target is its type (23 records: X's code reads its second conversion's class) |
| not evaluated (an update's destination read by name) | 11,020 | 0 | none |
