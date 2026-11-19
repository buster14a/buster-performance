# X's rows on the window (buster#2850's step 2), 2026-11-19

The evidence for the piece that makes X's rows (the node machine's X sweep, `node_machine_expand`) on the front's
window, from C's answers there. The census before it is
[x-rows-census-2850-2026-11-19](../x-rows-census-2850-2026-11-19/).

The 9700X, CPU 2, Release, each run its own hold of the lock.

## 1. Before the specification (`before/`)

Two counts, on main `3741c264f` and on the census's build.

**The reference's time** (`before/job-xr0.sh`, `before/x-reference-time.patch`: two clock reads around
`node_machine_expand` at reader time, on the expressions it takes; `before/9700x/xr0/`, five readings a corpus of
`measure-node-machine --shadow --passes 0 --window-contexts`):

| X on T's columns, TSC ticks a record | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| median (range) | 24.82 (24.62 to 25.06) | 22.75 (22.66 to 23.05) | 27.32 (27.22 to 28.20) |
| expressions, records, entries | 50,159, 281,956, 319,525 | 10,366, 72,167, 66,089 | 41,068, 210,497, 209,223 |

A record here is any of an expression's, evaluated or not, and the pair of clock reads an expression is in the figure.

**Which expressions a first piece takes** (`before/job-first-piece.sh`, `before/first-piece.py`: the X census's lines,
`census-x2.patch`'s build on main `b84780116`, an expression at a time; `before/9700x/first-piece/`). An expression is
the first piece's where every one of its records is evaluated with nothing after its row, and none has the template of
an update, of a logical operator's or a conditional's value, or of an operator evaluated as branches:

| | `sqlite3.c` | Lua | musl | the compiler's own source |
| --- | ---: | ---: | ---: | ---: |
| expressions X takes | 50,159 | 10,366 | 41,068 | 43,775 |
| the first piece's | 44,008 (87.74%) | 9,097 (87.76%) | 35,732 (87.01%) | 31,736 (72.50%) |
| their records (evaluated) | 202,565 (80.35%) | 44,267 (77.44%) | 145,879 (78.01%) | 136,799 (56.25%) |
| their entries | 234,753 (73.47%) | 45,580 (68.97%) | 149,110 (71.27%) | 172,368 (49.58%) |
| with an update | 3,526 | 789 | 3,693 | 5,586 |
| with branches | 2,079 | 244 | 849 | 3,661 |
| with a logical operator's or a conditional's value | 546 | 236 | 794 | 2,792 |

In the first piece's expressions (`before/shares.txt`, by `before/shares.py`):

| | `sqlite3.c` | Lua | musl | the compiler's own source |
| --- | ---: | ---: | ---: | ---: |
| lists of kinds of a record's own entries, by template | 43 | 43 | 44 | 43 |
| lists of kinds of its conversion's | 3 | 3 | 3 | 5 |
| the most entries a record, own and conversion | 4 | 4 | 4 | 7 |
| records with two own entries or more | 15.07% | 10.62% | 7.78% | 14.99% |
| a target that is not the record's type, in a value's context | 23.0% | 19.1% | 24.6% | 36.0% |
| a member's record | 11.6% | 12.5% | 3.2% | 9.5% |
| a truth's | 5.0% | 3.1% | 4.7% | 4.4% |
| an address constant of an object | 2.5% | 3.0% | 3.1% | 6.4% |

An integer constant whose conversion folds into a floating class: 6, 10, 252 and 31 records; none that converts to
one and does not fold.
