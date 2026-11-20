Part of #2850 (step 2). [The specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7030649938), [the piece before](https://github.com/buster14a/buster/pull/3137), [the record](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/x-update-rows-2850-2026-11-20).

## What it is

X's rows on the window listed every expression with an update. X writes an update two rows: the first after its destination's row (the old value's read, by name or through the address its destination's entries left, and its CONVERT to the class the operation is computed in), the last where its own record is (`++`'s and `--`'s CONST, the operation, the result's CONVERT back and the store). This makes the kinds and the classes of both on the window (`measure-node-machine --shadow --window-rows`). An entry's value is not made yet. **No compile takes any of it**: it runs in the shadow, and every tape it makes is compared with X's on T's columns entry by entry.

- **An update's rows are shapes of the rows' table**, in the slots its two records have free: its own row in its record's own part; its first row by name in its destination's record, which is not evaluated and has no entry (the read and a postfix update's DUP in the own part, the CONVERT in the conversion's); through an address in that record's conversion's part, which converts nothing; and a postfix update's six entries through an address after the destination's own entries, in both parts. No slot more and no column more: the write's compress joins them as it joins any row.
- **Two kinds are marks the write resolves**, each with one masked move, as it does a class's source: the operation's (by the operator's code) and the store's (a local's, a global's or through its address; a SET for a postfix update).
- **A sweep and a loop of their own** (`node_rows_window_updates`), after the shapes' sweep and before the write, in a chunk where C's loop took an update. A sweep of masks, 64 records a step, compresses the chunk's updates' numbers into a list; a loop over the list writes each update's two shapes over the shapes' sweep's, their lengths, its store's kind, the class its operation is computed in (one read of its line) and, where its rows are not made, the bit that lists its expression. Each choice is a bit and each shape a sum or a table's byte, with no branch on an update's bits. The reads' and the shapes' sweeps have no term of an update.
- **Listed still.** @@lists@@
- A row's entries' number is one byte now: no one read its two parts' lengths apart (a fault round's survivor).

## Measured

The 9700X, CPU 2, Release, each run its own hold of the lock, TSC ticks, seven readings; in each reading one executable with the update's rows on, off (an experiment's switch: an update's template lists its expression, as the piece before had it), the piece before's executable twice, then off and on again.

@@short_table@@

How it came to its cost, a build a line (ticks a record swept; three readings each, seven for the last):

@@builds_table@@

@@builds_notes@@

## Against its gates

@@gates@@

## What stays a record at a time, and why

@@stays@@

## Tests

`test-checker` part 5 of 8. The rows' fixture has an update's lines: each operator; by name, a local's and a global's, and through an address; prefix and postfix; a narrow, a floating and a pointer's destination; its value used, converted and not; a row of eight entries at an expression's last record; an update below another's, in an argument and in an index; the two kinds it lists; an update that is not evaluated; and five statements 64 times each, so that an update and its destination fall on either side of a block's end and a block's list takes its second turn. A unit of one chunk with one update. The tables' checks: each new shape's entries and length, the marks, each class's source and the slot the write resolves it in, a postfix update's rows by its destination's shape, and the places. The pins have the updates read for. The control counts every tape with one of the reference's answers changed.

## Checks

In the cloud container, on @@checks_revision@@:

- a native Release build; `test-checker`, all eight parts; the shadow with `--window-rows` and `--window-contexts` on `sqlite3.c`, Lua and musl and with `--window-rows` on the compiler's own source, with the default warnings and with `-Wall -Wextra` (@@shadow_runs@@ runs, no difference); the shadow's other modes on `sqlite3.c` and Lua (@@mode_runs@@ runs); the self-check, the self-parse, `test-call-graph` and `check-call-graph`; the ownership check;
- the complete driver's lists and parse: all pass but the preprocessor's comparison with clang, which fails in this container on main too (its system clang is 23.1.6);
- the rows a PR's checks skip: native memory, address and thread builds, `test-checker` part 5 under each, and under memory and address the shadow with `--window-rows` on `sqlite3.c`, Lua and the compiler's own source: no report. On the piece before the fixture's last line, the same with the shadow's `--window-contexts` and `--window-tests` too: no report.

The 9700X's readings are of the piece before the fixture's last line (a test's line and its pins): the sweeps' source is the same, and the rows' functions' instructions are the same in the two cloud builds (the record has the listings).

🤖 Generated with [Claude Code](https://claude.com/claude-code)

https://claude.ai/code/session_01TiDLnvTX4sXnEVEUdMWepR

---
Agent session: [private session](https://claude.ai/code/session_01TiDLnvTX4sXnEVEUdMWepR)
Model: Anthropic / claude-fable-5-2

---
_Generated by [Claude Code](https://claude.ai/code)_
