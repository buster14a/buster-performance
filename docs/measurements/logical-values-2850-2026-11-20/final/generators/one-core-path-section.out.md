## An operator's value and a comma on the window

[The record](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/logical-values-2850-2026-11-20).
`measure-node-machine --shadow --window-rows`
([the guide](commands/lowering.md#an-operators-value-and-a-comma-on-the-window-2850)).

`&&` and `||` as values, `?:` and a comma were what C on the window listed
most: it decided no expression with one, and X made no row of theirs. They
are made now in the sweeps that exist. In C's loop a comma and an operator's
value are masks, each record says of itself whether it is evaluated as
branches or is a value, and a record that has its consumer's answer reads it
from the next record, down a run of such records by two doubling steps. In
X's rows the branches' loop takes these operators' turns too: the
condition's test and branch, a conditional's first arm's jump, a logical
operator's own four entries; and the numbering counts labels, two an
operator's value. No compile takes any of it. [The node machine's
page](node-machine.md#an-operators-value-and-a-comma-on-the-window) has it
whole: the census before it, the rules, the three builds and the faults. [Its
specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7049301495)
had six gates. It is exact and its faults are caught. It takes 11 expressions
fewer than asked on `sqlite3.c` and 1 on musl; its work a record is within
its gate for the rows and at C's bound; and its cost is a chunk's first run of
C's loop, which no gate named.

### What it measured

The 9700X, CPU 2, under the lock, Release, TSC ticks, seven readings; in each
the build, the piece before's executable twice, and the build again:

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| expressions C decides on the window; the piece before's | 50,109; 49,310 | 10,715; 10,079 | 42,776; 41,759 |
| **expressions whose tape X makes, whole; the piece before's** | **49,842**; 49,073 | **10,248**; 9,888 | **40,444**; 39,495 |
| more of them | +769 (1.51% of the expressions) | +360 (3.32% of the expressions) | +949 (2.19% of the expressions) |
| their records; the piece before's | 278,867; 268,942 | 70,873; 61,509 | 204,846; 188,250 |
| answers of C's; tapes of X's that differ from the reference's | 0; 0 | 0; 0 | 0; 0 |
| operators' values C takes; of them listed for their target; commas | 715; 98; 330 | 414; 7; 283 | 940; 49; 184 |
| listed for a logical operator or a conditional; the piece before's | 135; 674 | 22; 290 | 115; 964 |
| listed for a comma; the piece before's (a selection among them) | 0; 264 | 5; 376 | 0; 169 |
| listed for X by a turn (an arm with no room, a narrow second operand) | 3 | 0 | 0 |
| expressions numbered; the piece before's | 428; 474 | 318; 163 | 1,071; 635 |
| **C's sweeps, a record of the decided, a chunk's second run; the piece before's; more** | 6.79; 6.40; **+0.36 (+0.34 to +0.44)** | 7.25; 7.61; **-0.35 (-0.38 to -0.30)** | 12.31; 10.95; **+1.53 (+1.09 to +2.51)** |
| **the rows' sweeps, a record of the taken, a second run; the piece before's; more** | 7.30; 7.32; **-0.04 (-0.52 to +0.31)** | 8.83; 9.14; **-0.29 (-0.44 to +0.09)** | 15.74; 16.05; **-0.20 (-0.96 to +5.21)** |
| C's sweeps, a record of the decided, a first run; the piece before's; more | 9.02; 7.67; +1.22 (+1.12 to +1.83) | 13.09; 12.01; +1.02 (-0.14 to +2.36) | 34.48; 29.55; +4.93 (-0.79 to +17.16) |
| the rows' sweeps, a record of the taken, a first run; the piece before's; more | 10.15; 10.00; +0.15 (-0.33 to +1.44) | 16.00; 16.36; -0.46 (-0.99 to +5.09) | 43.61; 44.22; -2.18 (-7.98 to +21.59) |
| C's sweeps, a record swept: a first run, more; a second, more | +1.32 (+1.24 to +1.84); +0.52 (+0.50 to +0.59) | +2.41 (+1.59 to +3.50); +0.71 (+0.68 to +0.75) | +4.12 (+1.06 to +11.21); +1.38 (+1.15 to +2.04) |
| the rows' sweeps, a record swept: a first run, more; a second, more | +0.44 (+0.03 to +1.55); +0.19 (-0.21 to +0.50) | +1.34 (+0.95 to +5.60); +0.71 (+0.65 to +1.01) | +0.81 (-2.07 to +13.62); +0.59 (+0.18 to +3.54) |
| **the rows' sweeps, a first run less a second, ticks a chunk; the piece before's; more** | 1299; 1171; **+116 (-63 to +558)** | 2065; 1859; **+237 (+74 to +1876)** | 1884; 1778; **+63 (-505 to +1653)** |
| C's sweeps, a first run less a second, ticks a chunk; the piece before's; more | 1021; 552; +410 (+379 to +668) | 1800; 1159; +630 (+324 to +1051) | 1635; 1246; +373 (-42 to +1162) |
| the kernel in place, more; the tests on the window, more | -0.33 (-0.80 to -0.24); +0.21 (-0.17 to +0.39) | -0.36 (-2.67 to -0.12); -0.59 (-2.58 to +1.80) | -0.17 (-3.27 to +3.05); -4.12 (-5.91 to +5.21) |
| the reference's C, a record of the decided; its X, a record of the taken | 40.50; 25.80 | 36.84; 23.50 | 43.70; 28.97 |
| records a chunk; chunks | 526; 611 | 379; 241 | 127; 2,975 |

### Against its gates

- **L1, exact: met.** No answer of C's and no entry of X's tape differs from the reference's on the three corpora and
  the compiler's own source; 6,414 one-statement programs agree.
- **L2, how much: met on Lua alone.** 769, 360 and 949 expressions more are taken where 780, 355 and 950 were asked.
  The rule for a conversion the tasks put into an operator's arms lists 16 and 6 expressions that the build before
  took, since the first fault round: its terms no test separated are out.
- **L3, work a record: met for the rows; C's is at its bound on `sqlite3.c`.** A chunk's second run of the rows' sweeps
  reads -0.04 and -0.29 ticks a record of the taken more than the piece before's on `sqlite3.c` and Lua (0.30 and
  0.40 asked); C's sweeps read +0.36 and -0.35 a record of the decided (0.35 asked, 0.70 refutes).
- **L4, a chunk: met on `sqlite3.c` and musl by their medians, not on Lua.** The rows' sweeps' first run less their
  second rose by +116, +237 and +63 ticks a chunk (150 asked, 300 refutes), and each corpus's range
  reaches past 300. C's sweeps', which the gate did not name, rose by +410, +630 and +373.
- **L5, nothing else moves: not as written.** The rows' reads are within 0.2 on `sqlite3.c` and Lua. The kernel in
  place, whose source the piece does not touch, reads -0.33 and -0.36 (less in each of the three builds), and the
  tests' sweeps +0.21 and -0.59: two builds read a sweep with no change a third of a tick apart or more.
- **L6, faults: met, with five faults no test separates whose terms stay.** Two rounds. The first's 308 faults
  left 46: 15 terms that what makes the records implies, which are out of the code; 18 of the first rule for
  the tasks' conversions, which is three terms now; 10 that found a line of the fixture or a pin to add; and
  3 that change nothing a program reaches. The second's 55, on the code as it is: 50 caught, and 5 that
  change nothing a program reaches.

### What stays a record at a time, and why

In C's loop, one record in 308, 131 and 336 of those swept, an operator's value or a comma: whether a comma's consumer
is of void's class, a discarded comma's context's byte, and the rule on an operator's value's target, which reads
its type's class. The first build had the vector's forms of the first two, a permute of the block's classes by the
consumer's lane in every block and a blend (and a second permute, for a `!`'s consumer's answer): its loop read 0.09
and 0.11 ticks a record swept more a second run than the build without them. In X, an operator's value's turn, a byte or two at its operands' places; and the numbering,
for 0.86%, 3.10% and 2.65% of the tapes.

### What it means

- **X's tapes are whole on the window** for 49,842, 10,248 and 40,444 of the three corpora's 50,993, 10,839 and
  43,415 expressions: 769, 360 and 949 more, with 3.7%, 15.2% and 8.8% more records.
- **What they cost against the reference.** By its averages a record, the reference's C and X read 658,028, 565,024 and 1,206,031
  ticks on the newly taken records. Over all the records swept the piece adds 86%, 61% and 154% of that
  a chunk's first run, and 35%, 23% and 62% its second. **On musl a first run costs more than the
  reference's work it replaces:** its chunks are 127 records.
- **The cost is C's loop's, by the chunk.** Its step has the new masks in every block: +1.02, +1.94 and +3.49
  ticks a record swept more a first run, +0.44, +0.53 and +1.24 a second. The specification gated a chunk's cost for the
  rows' sweeps and not for C's: the loop's cold start a chunk
  ([#3196](https://github.com/buster14a/buster/issues/3196)) grew with the masks its step took on.
- **Next:** a taken expression's references and events, the flip's first piece, where the window's sweeps run in
  a compile and their cost by the chunk is settled.
