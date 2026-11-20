Part of #2850 (step 2). [The specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7037879405), [the piece before](https://github.com/buster14a/buster/pull/3184), [the record](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/x-branch-rows-2850-2026-11-20).

> **This takes the place of buster14a/buster#3190.** Its first commit is that pull request's one commit (`49acc5cf9`), cherry-picked unchanged onto main `875980f24`; the second is the design's two sections, written from the seven final readings that pull request was waiting for. The session that wrote the code handed the work off before its last gate ([the hand-off](https://github.com/buster14a/buster/issues/2850#issuecomment-7042274752)), and this session pushes to its own branch alone. All five gates are met.

## What it is

X's rows on the window listed every expression with an operator evaluated as branches (a statement's condition over `&&` or `||`, and the `!`, `&&` and `||` below it). X writes such an operator no entry, and each value it tests its test (a narrow class's CONVERT to I32, a CONST 0, NE) and a branch by its sense, BRANCH_TRUE or BRANCH_FALSE, after the value's row. This makes the kinds and the classes of those on the window (`measure-node-machine --shadow --window-rows`). The branch's label is an entry's value, which is not made yet. **No compile takes any of it**: it runs in the shadow, and every tape it makes is compared with X's on T's columns entry by entry.

- **The test is the tested value's conversion's part.** A logical operator converts its operand to its own type without its qualifiers, so that part of the value's row is free: four new rows of the rows' table (a narrow class's or not, by the sense) are its shape there. An operator evaluated as branches has no shape and lists nothing.
- **One sweep makes two lists, and a loop goes down the second** (`node_rows_window_updates`, `node_rows_window_branch`). In a chunk where a condition branches, the update's sweep of masks compresses the chunk's `!`, `&&` and `||` evaluated as branches into a second list in the same pass. A loop down that list from its end, consumers before their operands, reads each operator's sense from a byte column and gives each of its operands its own: a byte for an operand that is such an operator in its turn, and for a value the test's shape and its entries' number. A statement's CONDITION takes no turn: the reader writes its sense at its operand's record. A `!`'s one operand is given twice with the same sense, so a turn has no branch on its operator.
- **Listed still.** A tested value with a conversion of its own, whose part has no room: a qualified `_Bool`'s read, which the lowering converts to bool again by four entries (#3185). None of the three corpora's expressions; @@main_branches@@ of the compiler's own source's @@main_expressions@@.
- **The shadow compares a chunk's two runs byte for byte.** The first run's streams are kept, and the second's must be the same: a loop that read what an earlier run left in a column (a sense, a shape) would pass a count and fail this.
- **The listed expression's reason is by its record's own shape**, with no read of its consumer (a fault round's finding, below).

## Measured

The 9700X, CPU 2, Release, each run its own hold of the lock, TSC ticks, @@readings@@ readings; in each reading one executable with the branches' rows on, off (an experiment's switch: the branches' template lists its expression and the sweep makes no second list, as the piece before had it), the piece before's executable twice, then off and on again.

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
@@short_table@@

How it came to its cost, a build a line (ticks a record swept; three readings each, @@readings@@ for the last):

@@builds_table@@

@@builds_notes@@

## Against its gates

@@gates@@

## What stays a record at a time, and why

The branches' loop: a turn for each `!`, `&&` and `||` evaluated as branches, @@turns_share_sqlite3@@ of `sqlite3.c`'s records swept, @@turns_share_lua@@ of Lua's and @@turns_share_musl@@ of musl's. An operator's first operand is at a distance only its own record has, and an operand's sense is its consumer's, a turn after it. The specification named what to measure against the loop if it read over its gate: the senses as a segmented scan of bits a block, and the shapes by a permute of the consumers' templates. @@vector_note@@

## Tests

`test-checker` part 5 of 8. @@tests@@

## Checks

In the cloud container, on @@checks_revision@@ (this session's own run of each, on the cherry-picked commit; the session before ran the same on its own base):

- a native Release build; `test-checker`, all eight parts; the shadow with `--window-rows` and `--window-contexts` on `sqlite3.c`, Lua and musl and with `--window-rows` on the compiler's own source, with the default warnings and with `-Wall -Wextra` (@@shadow_runs@@ runs, no difference); the shadow's other modes on `sqlite3.c` and Lua (@@mode_runs@@ runs); the self-check, the self-parse, `test-call-graph` and `check-call-graph`; the ownership check;
- the complete driver's lists and parse: all pass but the preprocessor's comparison with clang, whose 45 differing units of 66 differ by where their line markers place a token and by no token (each one's count is clang's): this container's clang names its resource directory otherwise, as the session before read of main in its own container;
- @@sanitizers@@

🤖 Generated with [Claude Code](https://claude.com/claude-code)

https://claude.ai/code/session_01EgbxneipucKBYgjW4XLXVp

---
Agent session: [private session](https://claude.ai/code/session_01EgbxneipucKBYgjW4XLXVp) (the final readings, the design's sections, the checks on this branch, this description)
Model: Anthropic / claude-fable-5-2
Agent session: [private session](https://claude.ai/code/session_01TiDLnvTX4sXnEVEUdMWepR) (the code's commit, its builds, probes and fault rounds, and this description's first form in buster14a/buster#3190)
Model: Anthropic / claude-fable-5-2 (claude-opus-5-5 after 14:33 UTC on 2026-11-20)

---
_Generated by [Claude Code](https://claude.ai/code)_
