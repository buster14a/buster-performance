**X's rows on the window, the entries' values: pull request buster14a/buster#3197.** [Its specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7043553775)'s gates, one by one ([the record](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/x-values-2850-2026-11-20)). The claim is kept. Four gates are met and the cost gate is refuted.

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

**Where it differs from the specification.**

- **A loop reads a column, not a line.** The specification's loops read each listed record's line, 64 bytes a record. A record's one value is a column now, stored by the tests' sweep as it loads the line, and a pointer's stride one that C's loop keeps: the specification's first alternative, built after the first build's readings.
- **The tested values' and the updates' lists are the loops' that visit them already.** An update's step and a postfix update's first pair of temporaries are written by a loop over the updates' list, and a member's offset is on the first list, in the record's value's place. The rest's list is what is left: a floating constant, a fold to bool, and an address constant's offset after its object's address.
- **An expression's later numbered records are found by one subtraction a block**, with no test an expression: the specification counted each expression's marked records in its part.
- **The by-slots build was not made.** The specification named it as the second thing to measure against the loops over their gate. The counters put a first run's cost in a cold start a chunk and not in the loops' work, and that is #3196's to measure, for every sweep of the window.
- **The cost gate was the wrong shape.** It priced work a record; the window's sweeps pay by the chunk too (526, 379 and 127 records a chunk). The next piece's gate will state cycles a chunk and work a record apart, and Lua's apart from `sqlite3.c`'s.
- **Terms the fault rounds took out:** a record's constant's kind beside its object, the expressions' ends in the subtraction, the numbering's test for two marked records, and three more that another term implied.

**What it means.**

- **X's tapes are whole on the window** for 99.83%, 99.79% and 99.45% of the expressions C takes on the three corpora: a kind,
  a class and a value an entry, compared with X's on T's columns.
- **What they cost against the reference.** The rows' sweeps and the part read 10.16, 16.45 and 42.59 ticks a record of the
  taken expressions; X on T's columns reads 25.61, 23.69 and 28.64 a record of theirs. **On musl the window's rows now read more than the reference does:** its
  chunks are a quarter of `sqlite3.c`'s, and its rows' sweeps read 21.26 ticks a record swept a chunk's first run and 8.04
  its second.
- **The cost gate was written from work a record, and the window's sweeps pay by the chunk too.** The values' part
  reads 3.20, 4.11 and 7.48 ticks a record swept a chunk's first run and 1.93, 2.05 and 2.91 its second; their chunks are
  526, 379 and 127 records. A gate for a pass over the window is two numbers: cycles a chunk and work a record.

**Next: `&&` and `||` as values, `?:` and a comma, in C and in X on the window together.** Its specification follows here before its code.

---
Agent session: [private session](https://claude.ai/code/session_01EgbxneipucKBYgjW4XLXVp)
Model: Anthropic / claude-fable-5-2

---
_Generated by [Claude Code](https://claude.ai/code)_
