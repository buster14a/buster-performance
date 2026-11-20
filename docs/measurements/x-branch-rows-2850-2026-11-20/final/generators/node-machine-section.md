### The branches' rows on the window

[The record](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/x-branch-rows-2850-2026-11-20).
Its [specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7037879405)
had five gates: exact (B1), how much (B2), cost (B3), that nothing else moves
(B4) and faults (B5).

The piece before listed every expression with an operator evaluated as
branches: @@before_branches_sqlite3@@ of the @@expressions_sqlite3@@ `sqlite3.c` has that C takes on
the window, @@before_branches_lua@@ of Lua's @@expressions_lua@@ and @@before_branches_musl@@ of musl's @@expressions_musl@@. X
writes such an operator no entry (`node_machine_classify_branches`: a
statement's CONDITION over `&&` or `||`, and the `!`, `&&` and `||` below
it). Each of its operands that is no such operator is a value it tests
(`node_machine_branch_operand`): after the value's row, converted to the type
the operator converts it to, come its test (`node_machine_put_truth`: a
narrow class's CONVERT to I32, a CONST 0 of the class tested and NE) and a
branch to a label where its truth is its sense, BRANCH_TRUE or BRANCH_FALSE
(`node_machine_branch_hook`). The sense comes from the root down. A
CONDITION's is its statement's: a `do`'s branches back where the condition
holds, an `if`'s, a `while`'s and a `for`'s away where it doesn't
(`node_machine_reader_root`). An `&&`'s first operand's is false and an
`||`'s true, whatever the operator's own (an `&&` taken where true and an
`||` where false branch on their first operand the other way, to a label of
their own past their second); a second operand's is its operator's; and a
`!`'s operand's is the other. This piece makes the kinds and the classes of a
tested value's test and branch on the window. The label is the branch's
entry's value, which is not made yet. No compile takes any of it.

**The test is the tested value's conversion's part.** A record's row is two
parts of four slots, its own entries' and its conversion's (the first piece).
The checker converts a logical operator's operand to its own type without its
qualifiers (`check_action_logic`'s operands), and of the values the count
before the specification found tested (@@tested_sqlite3@@ of `sqlite3.c`'s, @@tested_lua@@ of
Lua's, @@tested_musl@@ of musl's and @@tested_main@@ of the compiler's own source's), none of
the three corpora's has a conversion that writes an entry. So the part is
free, and the test and the branch are its row, four rows of the table:

| row | the tested value's class | entries |
| --- | --- | --- |
| 112 and 113 | not narrow; branching where it doesn't hold, and where it holds | a CONST of the record's class, NE, BRANCH_FALSE or BRANCH_TRUE |
| 114 and 115 | narrow (a bool's, a char's or a short's) | a CONVERT to I32, a CONST of I32, NE, the branch |

The class tested is the record's own, where it converts nothing. An operator
evaluated as branches has no shape: its template's row in
`NodeRowsTables.templates` is no entry, where the piece before had the mark
that lists its expression.

**What it lists.** A tested value with a conversion of its own, whose part
has no room for the test. One conversion does that: a qualified `_Bool`'s
read, which the lowering converts to bool again by four entries
([#3185](https://github.com/buster14a/buster/issues/3185)): nine with its own
entry and the test's four, and a record has eight slots. Its row stays as it
was and its expression is listed: none of the three corpora's, and @@main_branches@@ of
the compiler's own source's @@main_expressions@@ (@@main_tested_converted@@ such values in the count
before the specification), which declares its flags `const bool`.

**One sweep makes two lists, and a loop goes down the second.** The update's
sweep of masks, 64 records a step, compresses a chunk's updates' numbers into
a list. In a chunk where C's loop evaluated a record as branches it
compresses the chunk's `!`, `&&` and `||` of that template into a second list
in the same pass: a compare with the template's number, one with a
CONDITION's code and a compress more a block. A statement's CONDITION takes
no turn: its one operand's sense is its own, which the reader writes at the
operand's record when it registers the expression
(`node_facts_reader_expression`). A loop then goes down the second list from
its end (`node_rows_window_branch`). A record's consumer is a later record,
so an operator's turn finds its sense in the senses' column (a byte a record,
`window_x_senses`), where its consumer's turn or the reader left it. Its turn
gives each of its one or two operands its sense (`node_rows_window_tested`):
a byte for an operand that is such an operator in its turn; and for a value
the test's shape in its conversion's part (112, two more for a narrow class
and one more for the sense), three or four entries more in its row's length
and, where the part is not free, the bit that lists its expression. A `!`'s
one operand is given twice with the same sense, and the second time changes
nothing, so the turn has no branch on its operator. Each choice is a bit and
each shape a sum. The one branch is the listing's, which none of the three
corpora's values takes. An update that is a tested value (`if (n-- && p)`)
has its own row from the updates' loop and its test from this one: the one
writes its record's own part and the other its conversion's, and each adds
its entries to the row's length, so the two loops' order is no one's to say
(the specification had the updates' first; a fault ran them the other way,
and nothing changed).

**How it came to its cost.** Builds on the 9700X, TSC ticks a record swept,
three readings each and seven for the last: the rows' sweeps with the
branches' rows on, and what they read more than the piece before's
executable in the same readings.

@@builds_table@@

@@builds_notes@@

**Measured.** The 9700X, CPU 2, Release, each run its own hold of the lock,
TSC ticks, @@readings@@ readings; in each reading one executable with the branches'
rows on, off (an experiment's switch: the branches' template lists its
expression and the sweep makes no second list, as the piece before had it),
the piece before's executable twice, then off and on again.

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
@@measured_table@@

**Against its gates.**

@@gates@@

**What stays a record at a time, and why.** The branches' loop: a turn for
each `!`, `&&` and `||` evaluated as branches, @@turns_share_sqlite3@@ of `sqlite3.c`'s
records swept, @@turns_share_lua@@ of Lua's and @@turns_share_musl@@ of musl's. An operator's first
operand is at a distance only its own record has, and an operand's sense is
its consumer's, which the `!`s above it change: down a nest of operators, a
turn after its consumer's. The specification named what to measure against
the loop if the loop read over its gate: the senses as a segmented scan of
bits a block, and the shapes by a permute of the consumers' templates. @@vector_note@@

**What is next:** the entries' values.
