# A census of C's answers on the window's bytes (buster#2850's step 2): 2026-11-18

What each of C's answers for a record depends on, counted before any kernel of C's on #2850's window, as
[specified on the issue](https://github.com/buster14a/buster/issues/2850#issuecomment-6981802836). C is the node
machine's second sweep (`c_check_node_machine_contexts.c`): from the root down it gives each evaluated record its
template, and each of its operands whether it is evaluated, its context, the type its consumer converts it to and its
segment's or branch's state. Today it reads T's columns. No compile takes any of this, and the census's code is an
experiment's patch that no pull request has.

- The cloud container (4 CPUs, native host, Release). No timing was read: the census counts.
- Sources: buster's `fd8df4371` (the fourth piece of the tests on the window, which main `521d5b63d` merged) with
  `census-c.patch`.
- `measure-node-machine --shadow --passes 0 --front-sweeps --census-c-reader` on `sqlite3.c`, Lua, musl and the
  compiler's own source: a line for each record of each expression T takes at reader time, right after C and X ran on
  it there (`node_machine_reader_chunk`), with the root's context, target and object that reader time gives it.

## 1. The lines (`sample/`, `columns/`, `scripts/parse.py`)

A line has, for one record: its operator, its type's word, its standing, its flags, what its object is (known, a
local, its declaration's compound, static and register bits), its truth where it is a constant, its member's offset's
parity, its own operands' conversions' types' words; the same of its first two operands and its third's standing;
which operand of its consumer it is (0 to 2, a call's arguments from 3, a root 9), the consumer's operator, word,
standing, flags, template, context, state and target's word, the word of the type T converted this operand to, and
the consumer's other operand's and first operand's fields; then C's answers: its state, its context, its target's
word and which of the candidate sources that target is (T's conversion of the operand, the consumer's type, `long`,
`void`, none, the record's own type), its template, its call depth, its update's plan and its hook's distance.

The fields are T's columns' at reader time: the window's kernel makes the same record fields in place (its oracle is
those columns), but for a record's exponent, where the kernel's record says an integer constant's value and T's says
none. So a constant's truth is a field of its own in the lines (`tr`), and the counts below call it a constant's value.

`columns/*.npz` are the four runs' lines as columns (`parse.py`), 968,051 records; `sample/` has each run's first 400
lines as printed; `results/shadow-*.txt` the runs' own reports.

| | `sqlite3.c` | Lua | musl | own source |
| --- | ---: | ---: | ---: | ---: |
| expressions C ran on at reader time | 51,188 | 10,859 | 43,481 | 52,593 |
| taken; refused for a template; for a row | 50,346; 842; 0 | 10,386; 473; 0 | 41,134; 2,323; 24 | 44,438; 8,149; 6 |
| their records | 291,095 | 76,499 | 224,696 | 375,761 |
| records C answers for (a root, or an operand of an evaluated record with a template) | 285,237 | 68,551 | 215,158 | 289,599 |
| evaluated, with a template | 254,180 | 58,001 | 189,073 | 262,029 |

## 2. C's rules restated over the lines (`scripts/rules.py`, `results/rules.txt`)

Each answer made again in Python from the fields its rule reads in `c_check_node_machine_contexts.c`, and compared
with C's for every record.

**What a consumer gives an operand:**

| | `sqlite3.c` | Lua | musl | own source |
| --- | ---: | ---: | ---: | ---: |
| whether it is evaluated: records, that differ | 285,237, 0 | 68,551, 0 | 215,158, 0 | 289,599, 0 |
| its context's address, its discard, its target's source, its state: evaluated records, that differ | 254,555, 0 | 58,087, 0 | 189,407, 0 | 263,837, 0 |
| the rule read nothing but the consumer's template, its operator and the slot | 86.40% | 88.01% | 88.50% | 83.53% |
| a byte of the operand's own line too (a callee's standing, an update's destination's operator, a condition's operand's operator) | 13.48% | 11.60% | 11.34% | 16.46% |
| the consumer's own context (a comma's second operand, a selection's) | 0.12% | 0.39% | 0.09% | 0.00% |
| a constant's value (a known condition's truth, a divisor that is a power of two) | 10 | 2 | 142 | 20 |

The target is one of six sources:

| an evaluated record's target is | `sqlite3.c` | Lua | musl | own source |
| --- | ---: | ---: | ---: | ---: |
| T's conversion of the operand, in its consumer's record | 48.3% | 50.5% | 45.3% | 51.4% |
| none | 25.7% | 25.0% | 26.0% | 23.4% |
| its consumer's own type | 22.8% | 21.8% | 26.2% | 18.1% |
| `long` (a pointer's index) | 2.7% | 1.9% | 2.1% | 3.9% |
| `void` | 0.3% | 0.6% | 0.2% | 0.0% |
| the root's, given with the expression | 0.3% | 0.1% | 0.3% | 3.1% |
| it is the record's own type | 51.3% | 54.8% | 47.9% | 39.7% |
| of them a call's arguments, whose conversion no record holds (T's side array) | 31,992 (12.6%) | 9,705 (16.7%) | 23,140 (12.2%) | 27,805 (10.6%) |

**A record's template:**

| | `sqlite3.c` | Lua | musl | own source |
| --- | ---: | ---: | ---: | ---: |
| evaluated records with a template | 254,180 | 58,001 | 189,073 | 262,029 |
| the restated rule's template differs | 80 | 24 | 196 | 1,678 |
| a division or a remainder by an integer constant that C leaves to the tasks | 63 | 23 | 114 | 305 |
| a call C refuses | 17 | 0 | 76 | 1,373 |
| a subscript whose element is a variable-length array | 0 | 0 | 5 | 0 |
| a divide- or a remainder-assignment of an `int` by an integer constant that C refuses | 0 | 1 | 1 | 0 |

Each of those four is a term of C's rule that the lines don't hold: whether the divisor is a power of two
(`node_machine_power`; 204, 36, 250 and 392 divisions and remainders have an integer constant for a divisor), whether
the callee's parameters and the arguments' conversions are plain scalars, a pointer's stride, and an update's signed
power of two. Every other template is the restated rule's: an operator's case on the record's own line, its context, its first two
operands' lines and its conversions' types' words. What the rules read that is no byte of a record's line or of an
operand's:

| templates whose rule reads | `sqlite3.c` | Lua | musl | own source |
| --- | ---: | ---: | ---: | ---: |
| an object's storage (a name's read, a store or an update by name) | 74,276 (29.2%) | 16,340 (28.2%) | 64,889 (34.3%) | 74,635 (28.5%) |
| of them a name's read; whose flags' static bit says local or global | 62,554; all | 14,468; all | 54,462; all | 64,428; all but 15 |
| a pointer's type's stride | 7,340 (2.9%) | 1,432 (2.5%) | 4,600 (2.4%) | 10,324 (3.9%) |
| a call's callee's parameters | 12,920 (5.1%) | 4,115 (7.1%) | 8,350 (4.4%) | 12,359 (4.7%) |
| a constant's value: a condition that is a constant; a division or a remainder by an integer constant | 213; 208 | 32; 37 | 224; 278 | 2,107; 401 |
| its conversions' types' words | 17.8% | 14.3% | 19.9% | 23.8% |
| an operand's line | 8.1% | 7.2% | 8.4% | 10.1% |

A member's offset decides nothing a flag doesn't: every member at an offset that is no byte's has its bit-field flag
(224 of them, all on `sqlite3.c` and musl).

## 3. The gates' tables (`scripts/tables.py`, `results/tables-*.txt`)

As the specification worded them. For each answer, by the rule's place (the consumer's template, its operator and the
operand's slot; a template's by the record's own operator), a greedy search over the four corpora of the fewest fields
that leave no record in conflict, at most six beside the place; then the table of those fields learned on three
corpora and read on the fourth, each way round. A record is the table's where its key was seen with its answer
alone, flagged where its key was seen with two answers or not at all, and wrong where its key was seen with another
answer alone. The fields a key may hold: the window's bytes (a record's line's, its operands', its consumer's, the
consumer's other operand's), with the bits a rule reads of them recoded (a plain scalar, an lvalue, a constant...),
and C's answers for the consumer.

| read on the fourth corpus: the tables', wrong | `sqlite3.c` | Lua | musl | own source | entries in all | fields beside the place |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| whether it is evaluated | 99.99%, 0 | 99.98%, 0 | 99.94%, 11 | 100.00%, 0 | 182 in 151 places | at most 2 |
| its context | 100.00%, 0 | 99.91%, 0 | 99.95%, 0 | 99.78%, 0 | 195 in 103 | at most 4 |
| its target's source (a root's is given) | 99.98%, 0 | 99.98%, 0 | 99.95%, 0 | 99.99%, 0 | 216 in 103 | at most 3 |
| its state | 99.13%, 0 | 99.41%, 0 | 99.06%, 0 | 98.20%, 0 | 650 in 103 | at most 4 |
| its target's class and facts, from the window's bytes | 95.45%, 248 | 95.03%, 44 | 92.16%, 586 | 90.34%, 570 | 4,944 in 103 | 6, with 5,300 records still in conflict |
| the same with the class of T's conversion among the fields | 99.83%, 0 | 99.93%, 0 | 98.26%, 0 | 94.70%, 0 | 863 in 103 | at most 4 |
| its template, its conversions' types' classes among the fields | 57.33%, 30 | 54.41%, 3 | 62.41%, 20 | 86.64%, 345 | 2,743 in 49 | 6, with 1,615 in conflict |
| the same with an object's storage and a constant's truth among the fields | 85.55%, 28 | 82.33%, 3 | 94.99%, 20 | 86.99%, 303 | 2,731 in 49 | 6, with 1,568 in conflict |

- **Whether it is evaluated: the 11 wrong** are a divide-assignment's second operand on musl, evaluated or not by
  whether its divisor is a power of two. With the consumer's plan among the fields no record is in conflict and none
  is wrong (99.94% to 100.00%).
- **The target's class is no table of the window's bytes.** A call's arguments (10.8% to 16.8% of the evaluated
  records) are in places whose table is over 128 entries with six fields, and 5,300 records stay in conflict: an
  argument's target is its parameter's type. With the class of T's conversion among the fields the table copies it,
  and what it flags on the fourth corpus is classes the other three don't have.
- **The state:** the roots' place takes 456 entries of the 650 (the record's and its operand's operators as they
  are): a root's state is whether a statement's condition is branches, which its rule reads down its operand's
  operators. 0.6% to 1.8% of the records are flagged.
- **The template as a learned table:** a key seen with one record of another answer is flagged whole, so a few
  records flag most of a place (2 of `->`'s 47,245 records flag its largest key). Section 2's rules are the
  templates' count.

**Against the gates:**

1. *The tables hold where they were not learned (99% the tables', every other record flagged):* **met** for an
   operand's context and its target's source; **met but for 11 records** for whether it is evaluated (a divisor's
   value); **missed by 0.8 on the own source** for the state (98.20%), met on the other three; **not met** for the
   target's class from bytes and for the template as a learned table.
2. *Refuted where an answer needs more than 8 key bytes or a table over 128 entries for more than 2% of the evaluated
   records:* **refuted for the target's class** (a call's arguments, 10.8% to 16.8%). By its letter the state is over
   the line too (the roots' place, a fifth of the records), for a key of raw operators.
3. *Counted:* section 2's tables and section 4.

## 4. Counted (`scripts/counts.py`, `results/counts.txt`)

| | `sqlite3.c` | Lua | musl | own source |
| --- | ---: | ---: | ---: | ---: |
| expressions with a segment (`&&`, `\|\|` or `?:` as a value) | 610 (1.2%) | 312 (2.9%) | 896 (2.1%) | 3,790 (7.2%) |
| with an operator evaluated as branches | 2,244 (4.4%) | 293 (2.7%) | 919 (2.1%) | 4,126 (7.8%) |
| with an update | 3,589 (7.0%) | 814 (7.5%) | 3,846 (8.8%) | 6,223 (11.8%) |
| with any of the three | 6,372 (12.4%) | 1,288 (11.9%) | 5,491 (12.6%) | 13,172 (25.0%) |
| with a call | 12,481 (24.4%) | 3,855 (35.5%) | 7,197 (16.6%) | 10,134 (19.3%) |
| evaluated records with a hook after their row | 6,441 (2.5%) | 1,341 (2.3%) | 3,403 (1.8%) | 17,762 (6.8%) |
| evaluated records below a call | 48,933 (19.3%) | 12,943 (22.3%) | 39,116 (20.7%) | 43,578 (16.6%) |
| records an expression: mean, 99th percentile, most | 5.7, 20, 136 | 7.0, 39, 132 | 5.2, 25, 149 | 7.1, 31, 221 |
| a record's depth below its root: mean, 99th percentile, most | 2.1, 7, 15 | 2.7, 10, 18 | 2.2, 8, 20 | 2.5, 8, 56 |
| a record's consumer is within 15 records ahead; those past 63; the farthest | 99.64%; 2; 95 | 98.86%; 5; 123 | 98.82%; 20; 141 | 98.91%; 34; 128 |
| rounds a block of 64 records where every record waits for its consumer: mean, 99th percentile, most | 6.2, 10, 16 | 7.4, 14, 19 | 6.1, 14, 21 | 6.6, 11, 22 |
| where only a rule that reads its consumer's answer waits: mean, 99th percentile, most | 2.0, 5, 15 | 1.6, 4, 7 | 1.5, 5, 7 | 2.3, 6, 11 |
| blocks of them with one round | 57.5% | 68.3% | 77.3% | 50.4% |
| records their consumer's rule doesn't evaluate | 30,682 | 10,464 | 25,751 | 25,762 |
| of them leaves (a direct callee, a named store's destination, a constant's operand) | 97.5% | 86.1% | 96.6% | 97.9% |
| with records below; those records, in the taken expressions | 773; 1,849 | 1,456; 5,182 | 882; 1,465 | 553; 1,665 |

The blocks are 64 records in the order the reader made them, a run's expressions one after another: a chunk's own
blocks would cut them elsewhere. The rounds are the longest chain of consumers in one block. The second count takes
a comma's and a selection's context and a branched operator's operands as the rules that wait.

What C refuses, by the record it stopped at: on `sqlite3.c` an assignment 241, `.` 163, `->` 140, a subtraction 101,
`?:` 83, a division 54; on Lua a comma 269, an assignment 94, a subtraction 78; on musl an assignment 732, a name 646,
a subtraction 184, a call 119; on the own source `&&` 2,725, a call 1,457, an assignment 1,168, `?:` 1,090, `||` 575,
a conversion 510. 4,390 of the own source's evaluated records are an `&&`, an `||` or a `?:` C refuses (86, 8 and 66 on
the other three): 4,385 of them have a target that is another type than their own, `_Bool` for 3,244.

## 5. What it says of C on the window

- **An operand's answers are its consumer's template's row.** The lowering's own pass has them as a table by operator
  already (`check_lower_template_rules`): evaluated, a value's or a place's or its parent's context, and the target's
  source. Five in six records need nothing else, and the rest one byte of their own.
- **The target is a source and a load, not a table:** the consumer's record holds T's conversion for its first two
  operands and its own type; nothing on the window holds a call's arguments' conversions.
- **A template is its operator's case** over a dozen bits of the record's line, its context and its operands'
  lines; three things in it are no byte today: an object's storage (a declaration's bit), a type's row (a stride,
  a callee's parameters) and a constant's value.
- **Only two things chain down a tree:** whether a record is evaluated (an AND down its consumers, 97% of whose breaks
  are a leaf's), and a branched condition's operands. A kernel that waits for each consumer's template takes six to
  seven rounds a block; one whose rules read the consumer's bytes takes one for half to three quarters of the blocks.

## Files

- `census-c.patch`: the experiment's code, on buster's `fd8df4371`.
- `columns/`: the four runs' lines as columns; `sample/`: their first 400 lines; `results/shadow-*.txt`: the runs'
  reports.
- `scripts/parse.py`, `features.py`: the lines' fields; `rules.py`: section 2; `tables.py`: section 3 (`--fields
  window+down`, `window+down+converted`, `window+down+converted+outside`); `counts.py`: section 4. Each runs from
  this directory (`python3 scripts/rules.py`).
- `results/`: their outputs.
