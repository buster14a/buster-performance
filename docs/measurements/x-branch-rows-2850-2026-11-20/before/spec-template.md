**X's rows on the window, third: the branches' rows. The specification.** The claim is kept. No code of the piece is written yet. The entries' values are the piece after it, specified when this one holds.

### What the counts say

After an update's rows (PRLINK), of the expressions C takes on the window (the 9700X's final readings' lines; [the record](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/x-update-rows-2850-2026-11-20)):

@@before_counts@@

And one count on that piece's code, of the expressions listed first for such a record (a Develop build on the 9700X with a line of counts at exit, and in the cloud container for the compiler's own source; [the lines](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/x-branch-rows-2850-2026-11-20)). The rows after the second are of the expressions no other record lists:

@@count_table@@

### What X writes for them (`node_machine_classify_branches`, `node_machine_branch_hook`)

- **An operator evaluated as branches** (a statement's CONDITION over `&&` or `||`, and the `!`, `&&` and `||` below it) writes no entry of its own.
- **Each of its operands that is no such operator is a value it tests.** After the value's row, converted to the type the operator converts it to: its test (a narrow class's CONVERT to I32, a CONST 0 of the class, NE) and a branch, BRANCH_TRUE or BRANCH_FALSE by its sense, to a label.
- **The sense comes from the root down.** A CONDITION's is its statement's: a `do`'s branches back where the condition holds, an `if`'s, a `while`'s and a `for`'s away where it doesn't. An `&&`'s first operand's is false and an `||`'s true, whatever their operator's own; a second operand's is its operator's; a `!`'s operand's is the other.
- The label is the entry's value, which this piece does not make.

### The piece

- **The test and the branch are the tested value's conversion's part.** In the three corpora no tested value has a conversion before its test (the count's fifth row). Its conversion's four slots are free, and the test's three or four entries are that part's row: four new rows of the table (a narrow class's or not, by the sense), their CONST of the class tested, which is the record's own where it converts nothing. A tested value with a conversion of its own lists its expression: a `const` bool's read, converted to bool by four entries, has nine with its test, which a record's eight slots don't hold (@@own_over@@ values in @@own_full@@ of the compiler's own source's @@own_first@@ expressions). An operator evaluated as branches has no shape and lists nothing.
- **One sweep makes two lists.** The update's sweep of masks, which compresses a chunk's updates into a list, compresses its records evaluated as branches into a second one in the same pass (a compare and a compress more a block), in a chunk where C's loop made either.
- **A loop down the second list, from its end**: consumers before their operands. Each branched record has its sense in a byte: a root's is its statement's, which the reader keeps of the root's record when it reads the root; another's was written at its consumer's turn. Its turn gives each of its one or two operands its own sense: a byte for an operand that is branched in its turn, and for a value the test's shape, its row's entries' number and, where its conversion's part is not free, the bit that lists its expression. No branch on a record's bits. The updates' loop runs first: an update that is a tested value has its own row by then.
- **Why a loop, and what would replace it.** The update's piece measured both ways (its fourth and fifth builds): as masks in the shapes' sweep an update's terms were every block's, for one record in ninety, and read more than a loop over a list. A record evaluated as branches is one in @@one_in_sqlite3@@ of `sqlite3.c`'s records swept, one in @@one_in_lua@@ of Lua's and one in @@one_in_musl@@ of musl's. A first operand's sense crosses records by a distance only its consumer has; along a run of adjacent branched records a sense is the XOR of the `!`s above it, a segmented scan of bits (one carry-less multiply a block, run backward). If the loop reads over its gate, that scan with the shapes by a permute of the consumers' templates is the build to measure against it, and the result says which stays.
- **Compared** as the tapes are today: entry by entry, a kind and a class, with X's tape on T's columns; the control counts every tape with one of the reference's answers changed.

| gate | |
| --- | --- |
| B1. exact | no tape differs in its number of entries, a kind or a class: the three corpora and the compiler's own source, with the default warnings and with `-Wall -Wextra`; a fixture with a line a pattern; and conditions one statement at a time (`&&`, `\|\|` and `!` under an `if`, a `while`, a `do` and a `for`; each nested in either operand of each, three deep; a tested value of each class, a pointer's, a floating one's, a bool's, a member's, a call's, a comparison's and an update's; a condition whose operator C lists) |
| B2. how much | tapes for @@alone_sqlite3@@ more expressions on `sqlite3.c`, @@alone_lua@@ on Lua and @@alone_musl@@ on musl: every one the count has with no other record that lists it. Refuted under 2,000, 190 and 770 |
| B3. cost | the rows' sweeps and the part at most 0.6 ticks a record swept over the update's piece's on `sqlite3.c` and 0.4 on Lua (@@sum_sqlite3@@ and @@sum_lua@@), refuted at 1.0 and 0.8 over. By the update's loop's readings (@@per_update_sqlite3@@ ticks an update on `sqlite3.c` and @@per_update_lua@@ on Lua, its sweep's with none to make taken off) the list's @@branched_sqlite3@@ and @@branched_lua@@ records would read @@estimate_sqlite3@@ and @@estimate_lua@@ |
| B4. nothing else moves | the kernel in place, the tests' parts and C's three sweeps within 0.3, by one executable with a switch |
| B5. faults | each term of the loop, each new row of the table and each mark changed alone fails a test; a survivor is removed as dead code or gets its test, and its test is run against its fault's build before the next round |

The order is the pieces' before: exact on the corpora and one statement at a time, the fault rounds to their end, then the checks, the sanitizers and the 9700X once.

---
Agent session: [private session](https://claude.ai/code/session_01TiDLnvTX4sXnEVEUdMWepR)
Model: Anthropic / claude-fable-5-2

---
_Generated by [Claude Code](https://claude.ai/code)_
