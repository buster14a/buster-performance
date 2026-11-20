Part of #2850. Found by its step 2's fourth piece, the entries' values on the window (@@pr_ref@@; [the design's section](https://github.com/buster14a/buster/blob/main/docs/node-machine.md#the-entries-values-on-the-window), [the record](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/x-values-2850-2026-11-20)). Not claimed.

### What was found

The values missed their cost gate: the rows' sweeps read @@e_sqlite3@@ TSC ticks a record swept more than the piece before's on `sqlite3.c` and @@e_lua@@ on Lua, where 1.5 was asked. The gate was written from work a record. The readings say a pass over the window costs by the chunk too: the front hands the sweeps a chunk of some hundreds of records, the rest of the reader runs between two chunks, and each sweep's first run over a chunk reads more than a second run of the same code over the same records.

The 9700X, CPU 2, Release, @@readings@@ readings, the pull request's code, `measure-node-machine --shadow --passes 0 --window-rows`; ticks a chunk, a first run; a second:

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| records a chunk; chunks | @@chunk_sqlite3@@; @@chunks_sqlite3@@ | @@chunk_lua@@; @@chunks_lua@@ | @@chunk_musl@@; @@chunks_musl@@ |
| the rows' sweeps, ticks a record swept: a first run; a second | @@sum_first_sqlite3@@; @@sum_second_sqlite3@@ | @@sum_first_lua@@; @@sum_second_lua@@ | @@sum_first_musl@@; @@sum_second_musl@@ |
| the same, ticks a chunk | @@sum_chunk_first_sqlite3@@; @@sum_chunk_second_sqlite3@@ | @@sum_chunk_first_lua@@; @@sum_chunk_second_lua@@ | @@sum_chunk_first_musl@@; @@sum_chunk_second_musl@@ |
| **a first run less a second, ticks a chunk** | **@@sum_cold_sqlite3@@** | **@@sum_cold_lua@@** | **@@sum_cold_musl@@** |
| the reads | @@reads_chunk_first_sqlite3@@; @@reads_chunk_second_sqlite3@@ | @@reads_chunk_first_lua@@; @@reads_chunk_second_lua@@ | @@reads_chunk_first_musl@@; @@reads_chunk_second_musl@@ |
| the shapes | @@shapes_chunk_first_sqlite3@@; @@shapes_chunk_second_sqlite3@@ | @@shapes_chunk_first_lua@@; @@shapes_chunk_second_lua@@ | @@shapes_chunk_first_musl@@; @@shapes_chunk_second_musl@@ |
| the updates' and the branches' lists and loops | @@lists_chunk_first_sqlite3@@; @@lists_chunk_second_sqlite3@@ | @@lists_chunk_first_lua@@; @@lists_chunk_second_lua@@ | @@lists_chunk_first_musl@@; @@lists_chunk_second_musl@@ |
| the rows' write | @@write_chunk_first_sqlite3@@; @@write_chunk_second_sqlite3@@ | @@write_chunk_first_lua@@; @@write_chunk_second_lua@@ | @@write_chunk_first_musl@@; @@write_chunk_second_musl@@ |
| the values | @@values_chunk_first_sqlite3@@; @@values_chunk_second_sqlite3@@ | @@values_chunk_first_lua@@; @@values_chunk_second_lua@@ | @@values_chunk_first_musl@@; @@values_chunk_second_musl@@ |
| an expression's part | @@part_chunk_first_sqlite3@@; @@part_chunk_second_sqlite3@@ | @@part_chunk_first_lua@@; @@part_chunk_second_lua@@ | @@part_chunk_first_musl@@; @@part_chunk_second_musl@@ |

A chunk of musl's is a quarter of `sqlite3.c`'s, and what its first run pays over its second is of the same order: a record of musl's pays several times as much.

And what the processor's counters say of one sweep, the values' (an experiment's build of the piece's fourth build that reads them around the sweep; `builds/counters.txt` in the record):

@@cold_note@@

Two builds went after it and changed nothing: asking for the sweep's columns' and stream's lines from the sweep before it, and compiling the sweep for size.

### What it asks

1. **Price each of the window's sweeps as cycles a chunk and work a record**, with the counters: the tests' bytes and their loop, C's loop and its targets, X's reads, shapes, lists, write and values. As a mode of `measure-node-machine --shadow`, where today it is an experiment's patch for one sweep. A gate for a pass over the window is then two numbers, and Lua's and musl's are stated apart from `sqlite3.c`'s.
2. **A longer window.** Sweeping several chunks' records at once pays each sweep's cold start once for all of them. Against it: the window's footprint (a record's line is 64 bytes, so the @@chunk_sqlite3@@ records of `sqlite3.c`'s chunk are @@lines_kb@@ KB of lines beside its columns), and the small units, which a longer window does not help: musl's @@chunks_musl@@ chunks are @@musl_units@@ units'.
3. **The values with no pass of their own.** The values' specification named two builds to measure against its loops if they read over their gate. The first is in the piece: a column of each record's one value. The second was not made: the values written by slots in the rows' write, as the kinds and the classes are, eight quadwords a register through a compress. Between the two is one loop for every list, a source's code a record, where the piece has a loop a list and so eight loops' ends a chunk.

### What would refute each

- (1) A sweep whose first run reads within a tenth of its second on all three corpora has no cold start to price.
- (2) Two chunks a window that read the rows' sweeps' first run no lower a record than one, on `sqlite3.c` and on Lua.
- (3) The rows' write with the values in it reading no lower than the write and the values' sweep read apart (@@write_first_sqlite3@@ and @@values_first_sqlite3@@ a record swept on `sqlite3.c`, @@write_first_lua@@ and @@values_first_lua@@ on Lua).

---
Agent session: [private session](https://claude.ai/code/session_01EgbxneipucKBYgjW4XLXVp)
Model: Anthropic / claude-fable-5-2

---
_Generated by [Claude Code](https://claude.ai/code)_
