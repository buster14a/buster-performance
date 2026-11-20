## The entries' values on the window

[The record](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/x-values-2850-2026-11-20).
`measure-node-machine --shadow --window-rows`
([the guide](commands/lowering.md#xs-rows-on-the-window-2850)).

An entry of X's tape is a kind, a class and a value, and X's rows on the
window made the first two. This piece makes the third, a quadword an entry.
The stream starts as zeros and its sums' ones; one sweep of masks puts each
record on the lists a table's byte by its shape says; and a loop a list
writes its values from two columns, a record's value (the tests' sweep makes
it as it loads each line) and a pointer's stride (C's loop keeps it). The few
expressions with two calls, two operators with a label or two postfix updates
through an address are numbered a record at a time. A tape the rows make is
then whole. No compile takes any of it. [The node machine's
page](node-machine.md#the-entries-values-on-the-window) has it whole: the
count before it, the builds, the counters, the probes and the faults. [Its
specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7043553775)
had five gates, and its cost gate is refuted as it was specified.

### What it measured

The 9700X, CPU 2, under the lock, Release, TSC ticks, seven readings; in each
one executable with the values on and off (an experiment's switch), and the
piece before's executable between them:

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| expressions C takes on the window | 49,155 | 9,909 | 39,712 |
| their tapes made here, whole | 49,073 (99.83%) | 9,888 (99.79%) | 39,495 (99.45%) |
| tapes that differ from X's on T's columns, in a value too | 0 | 0 | 0 |
| listed for a value | 0 | 0 | 0 |
| expressions numbered | 474 (0.97% of the tapes) | 163 (1.65% of the tapes) | 635 (1.61% of the tapes) |
| **the rows' sweeps and the part, a record swept** | **8.50 (8.27 to 8.66)** | **11.09 (10.98 to 11.58)** | **21.26 (19.89 to 22.95)** |
| the piece before's executable, in the same readings | 5.05 | 6.41 | 11.29 |
| **more than the piece before's** | **+3.48 (+3.13 to +3.69)** | **+4.78 (+4.28 to +4.91)** | **+10.16 (+8.10 to +12.23)** |
| with the values off; on less off | 5.15; +3.38 | 6.94; +4.19 | 13.81; +7.63 |
| with the values off, more than the piece before's | +0.12 (-0.04 to +0.21) | +0.49 (+0.20 to +0.75) | +2.53 (+0.98 to +3.72) |
| the values' part | 3.20 | 4.11 | 7.48 |
| a second run over the same chunk; the piece before's | 6.17; 4.05 | 6.17; 3.72 | 8.04; 4.83 |
| the values' part in it | 1.93 | 2.05 | 2.91 |
| the records' bytes, which make a record's value; on less off | 9.33; +0.30 | 11.88; +0.26 | 23.36; +0.42 |
| X on T's columns, a record of theirs | 25.61 | 23.69 | 28.64 |

### Against its gates

- **V1, exact: met.** No tape made differs from X's on T's columns in its number of entries, a kind, a class or a
  value, on the three corpora and the compiler's own source; 5,447 one-statement programs agree.
- **V2, how much: met.** None is listed for a value.
- **V3, cost: refuted.** +3.48 ticks a record swept more than the piece before's on `sqlite3.c` (1.5 asked, 2.5 refutes) and +4.78
  on Lua; +2.14 and +2.46 on a chunk's second run.
- **V4, nothing else moves: met.** The kernel, the tests' other parts and C's other sweeps read within 0.18 with the
  values on; the records' bytes and C's loop, which the piece gives work to, within 0.30 (0.3 asked).
- **V5, faults: met.** Two rounds. The first's 352 faults left 41: 8 terms no program separates, which are out of the
  code; 5 that change nothing; and 28 that found a control, a count or a fixture's line to add. The second's 89, on the
  code as it is, are all caught.

### What stays a record at a time, and why

The lists' loops, 0.48, 0.36 and 0.29 listed records a record swept: a value is a load from a column and a store at its
row's place, and the places are no register's eight in a row. And the numbering, for 0.97%, 1.65% and 1.61% of the
tapes: a call's row and a label are preorder numbers in the expression's tree. The by-slots build the specification
named against the loops was not made: the counters put a first run's cost in a cold start a chunk, not in the loops'
work ([#@@followup@@](https://github.com/buster14a/buster/issues/@@followup@@)).

### What it means

- **X's tapes are whole on the window** for 99.83%, 99.79% and 99.45% of the expressions C takes on the three corpora: a kind,
  a class and a value an entry, compared with X's on T's columns.
- **What they cost against the reference.** The rows' sweeps and the part read 10.16, 16.45 and 42.59 ticks a record of the
  taken expressions; X on T's columns reads 25.61, 23.69 and 28.64 a record of theirs. **On musl the window's rows now read more than the reference does:** its
  chunks are a quarter of `sqlite3.c`'s, and its rows' sweeps read 21.26 ticks a record swept a chunk's first run and 8.04
  its second.
- **The cost gate was written from work a record, and the window's sweeps pay by the chunk too.** The values' part
  reads 3.20, 4.11 and 7.48 ticks a record swept a chunk's first run and 1.93, 2.05 and 2.91 its second; their chunks are
  526, 379 and 127 records. A gate for a pass over the window is two numbers: cycles a chunk and work a record.
- **Next:** `&&` and `||` as values, `?:` and a comma, in C and in X on the window together.
