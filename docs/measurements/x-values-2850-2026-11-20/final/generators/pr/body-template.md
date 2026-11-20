Part of #2850 (step 2). [The specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7043553775), [the piece before](https://github.com/buster14a/buster/pull/3191), [the record](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/x-values-2850-2026-11-20).

> **Four of the five gates are met, and the cost gate (V3) is @@v3@@.** The specification asked at most 1.5 TSC ticks a record swept over the piece before's and set 2.5 as what refutes it. The rows' sweeps read @@e_sqlite3@@ more on `sqlite3.c` and @@e_lua@@ on Lua. On musl, which the gate did not name and whose chunks are a quarter the size, they read @@e_musl@@ more, and the window's rows now cost more a record of the taken expressions than X on T's columns does (@@taken_musl@@ ticks for @@reference_musl@@; @@taken_sqlite3@@ for @@reference_sqlite3@@ on `sqlite3.c`). [Where the piece stood](https://github.com/buster14a/buster/issues/2850#issuecomment-7045799975) said so before the fault rounds. The counters put a chunk's first run's cost in a cold start a chunk more than in work a record, which every sweep of the window pays: #@@followup@@ has it, and the one build the specification named against the loops that this piece did not make. The values run in the shadow alone, so no compile reads a tick more.

## What it is

An entry of X's tape is a kind, a class and a value, and X's rows on the window made the first two. This makes the third (`measure-node-machine --shadow --window-rows`): a quadword an entry, a stream beside the kinds' and the classes'. A tape the rows make is then whole, and every one is compared with X's on T's columns entry by entry, its value too. **No compile takes any of it.**

- **The stream starts as zeros and its sums' ones** (`node_rows_window_values`): 64 entries a step, a compare of their kinds with PTR_ADD's and eight masked stores.
- **Two columns hold what a loop would read of a line.** A record's value (`window_x_values`: its object's number where it has one, else its payload) is stored by the tests' sweep, which loads every record's line already; the rows' reads leave a member's offset in bytes there. A pointer's stride (`window_c_strides`) is kept by C's loop as it asks for it.
- **One sweep of masks makes the lists**, 64 records a step: a byte of a new table by a record's own shape (`NodeRowsTables.value_owns`) has a bit a list, and a list is the block's records' numbers under its bit, compressed. A loop a list then writes its values, each a load or two and a store at its row's place. The tested values with the control's label are the branches' loop's list, and the chunk's updates the updates' loop's.
- **The numbers of an expression** (`node_rows_window_number`). A call's row, an operator's own label and a postfix update's two temporaries are numbers in their expression, and its first of each is what the loops wrote. The sweep lists every record with such a value that is no first one of its expression by one subtraction a block, from two masks (those records, and the expressions' operands' last records, which the reader marks); each one's expression is numbered once, a record at a time, by the reference's rules: @@numbered_share@@ of the tapes.
- **The shadow** compares each tape's values and counts the tapes that differ in a value alone; keeps a chunk's first run's values and lists' counts and compares its second run's with them; and times the values as a part of their own. Its control changes an entry's value in its turn, and one of a chunk's first run's answers in thirteen turns, so that both comparisons count everything they are given.

## Measured

The 9700X, CPU 2, Release, each run its own hold of the lock, TSC ticks, @@readings@@ readings; in each reading one executable with the values on, off (an experiment's switch), the piece before's executable twice, then off and on again.

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
@@short_table@@

How it came to its cost, a build a line (ticks a record swept, two or three readings each; the piece before's executable read @@builds_base_sqlite3@@ and @@builds_base_lua@@ beside the last of them):

@@builds_table@@

@@builds_notes@@

## Against its gates

@@gates@@

## What stays a record at a time, and why

@@scalar@@

## Tests

`test-checker` part 5 of 8. @@tests@@

## Checks

In the cloud container, on the code's commit `@@checks_revision@@`:

- a native Release build; `test-checker`, all eight parts; the shadow with `--window-rows` and `--window-contexts` on `sqlite3.c`, Lua and musl and with `--window-rows` on the compiler's own source, with the default warnings and with `-Wall -Wextra` (@@shadow_runs@@ runs, no difference); the shadow's other modes on `sqlite3.c` and Lua (@@mode_runs@@ runs); the self-check, the self-parse, `test-call-graph` and `check-call-graph`; the ownership check;
- @@complete@@
- @@sanitizers@@

🤖 Generated with [Claude Code](https://claude.com/claude-code)

https://claude.ai/code/session_01EgbxneipucKBYgjW4XLXVp

---
Agent session: [private session](https://claude.ai/code/session_01EgbxneipucKBYgjW4XLXVp)
Model: Anthropic / claude-fable-5-2

---
_Generated by [Claude Code](https://claude.ai/code)_
