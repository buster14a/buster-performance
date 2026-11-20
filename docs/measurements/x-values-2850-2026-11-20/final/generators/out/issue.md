Part of #2850. Found by its step 2's fourth piece, the entries' values on the window (buster14a/buster#3197; [the design's section](https://github.com/buster14a/buster/blob/main/docs/node-machine.md#the-entries-values-on-the-window), [the record](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/x-values-2850-2026-11-20)). Not claimed.

### What was found

The values missed their cost gate: the rows' sweeps read +3.48 (+3.13 to +3.69) TSC ticks a record swept more than the piece before's on `sqlite3.c` and +4.78 (+4.28 to +4.91) on Lua, where 1.5 was asked. The gate was written from work a record. The readings say a pass over the window costs by the chunk too: the front hands the sweeps a chunk of some hundreds of records, the rest of the reader runs between two chunks, and each sweep's first run over a chunk reads more than a second run of the same code over the same records.

The 9700X, CPU 2, Release, seven readings, the pull request's code, `measure-node-machine --shadow --passes 0 --window-rows`; ticks a chunk, a first run; a second:

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| records a chunk; chunks | 526; 611 | 379; 241 | 127; 2,975 |
| the rows' sweeps, ticks a record swept: a first run; a second | 8.50; 6.17 | 11.09; 6.17 | 21.26; 8.04 |
| the same, ticks a chunk | 4,472; 3,246 | 4,199; 2,336 | 2,695; 1,019 |
| **a first run less a second, ticks a chunk** | **1,226** | **1,863** | **1,676** |
| the reads | 963; 789 | 856; 545 | 605; 195 |
| the shapes | 316; 253 | 398; 189 | 302; 87 |
| the updates' and the branches' lists and loops | 510; 326 | 424; 186 | 251; 85 |
| the rows' write | 500; 395 | 576; 326 | 396; 146 |
| the values | 1,683; 1,015 | 1,556; 776 | 948; 369 |
| an expression's part | 505; 452 | 401; 318 | 185; 138 |

A chunk of musl's is a quarter of `sqlite3.c`'s, and what its first run pays over its second is of the same order: a record of musl's pays several times as much.

And what the processor's counters say of one sweep, the values' (an experiment's build of the piece's fourth build that reads them around the sweep; `builds/counters.txt` in the record):

- **A chunk's first run pays a cold start, more than work a record.** A build that reads the processor's counters
  around the sweep (user mode, a chunk's average; `sqlite3.c` has 526 records a chunk and Lua 379): the sweep
  executes 4,313 to 4,429 instructions a chunk on `sqlite3.c` and 1,974 to 2,075 on Lua, the same in a chunk's two runs,
  in 1,898 to 2,284 cycles the first run and 1,262 to 1,323 the second (Lua: 1,795 to 2,316 and 931 to 961). The first run has
  18.9 to 22.7 mispredicted branches a chunk for the second's 10.6 to 12.0, 18.4 to 73.9 instruction-cache misses for
  2.7 to 27.4, and 631 to 1,594 cycles with the front end stalled for 231 to 364. No run of either corpus has more than
  0.1 TLB misses a chunk, data or instructions. The fourth build's ticks a chunk are nearly the same on the two
  (1,652 and 1,602) though `sqlite3.c`'s chunk has 39% more records. The rows' write, measured the same way,
  takes 835 to 843 cycles a chunk its first run and 683 to 686 its second on `sqlite3.c`.

Two builds went after it and changed nothing: asking for the sweep's columns' and stream's lines from the sweep before it, and compiling the sweep for size.

### What it asks

1. **Price each of the window's sweeps as cycles a chunk and work a record**, with the counters: the tests' bytes and their loop, C's loop and its targets, X's reads, shapes, lists, write and values. As a mode of `measure-node-machine --shadow`, where today it is an experiment's patch for one sweep. A gate for a pass over the window is then two numbers, and Lua's and musl's are stated apart from `sqlite3.c`'s.
2. **A longer window.** Sweeping several chunks' records at once pays each sweep's cold start once for all of them. Against it: the window's footprint (a record's line is 64 bytes, so the 526 records of `sqlite3.c`'s chunk are 33 KB of lines beside its columns), and the small units, which a longer window does not help: musl's 2,975 chunks are 1,336 units'.
3. **The values with no pass of their own.** The values' specification named two builds to measure against its loops if they read over their gate. The first is in the piece: a column of each record's one value. The second was not made: the values written by slots in the rows' write, as the kinds and the classes are, eight quadwords a register through a compress. Between the two is one loop for every list, a source's code a record, where the piece has a loop a list and so eight loops' ends a chunk.

### What would refute each

- (1) A sweep whose first run reads within a tenth of its second on all three corpora has no cold start to price.
- (2) Two chunks a window that read the rows' sweeps' first run no lower a record than one, on `sqlite3.c` and on Lua.
- (3) The rows' write with the values in it reading no lower than the write and the values' sweep read apart (0.95 and 3.20 a record swept on `sqlite3.c`, 1.52 and 4.11 on Lua).

---
Agent session: [private session](https://claude.ai/code/session_01EgbxneipucKBYgjW4XLXVp)
Model: Anthropic / claude-fable-5-2

---
_Generated by [Claude Code](https://claude.ai/code)_
