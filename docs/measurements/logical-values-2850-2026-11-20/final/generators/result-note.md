**An operator's value and a comma on the window: pull request buster14a/buster#3199.** [Its specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7049301495)'s gates, one by one ([the record](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/logical-values-2850-2026-11-20)). The claim is kept. The piece before's pull request, buster14a/buster#3197, merged on 2026-11-20. **This piece is exact and its faults are caught; of its other four gates none is met in full, none is refuted by its median, and its largest cost is one no gate named.**

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

Beside the gates, as the specification asked: what the reference's C and X read on the newly taken records against what the piece adds over all the records swept.

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| records newly taken; of those taken before | 9,925; 3.7% | 9,364; 15.2% | 16,596; 8.8% |
| the reference's C and X, ticks a record of theirs | 66.30 | 60.34 | 72.67 |
| **the reference on the newly taken records, ticks** | **658,028** | **565,024** | **1,206,031** |
| the piece, C's sweeps and the rows', more a record swept: a chunk's first run; its second | +1.76; +0.71 | +3.75; +1.42 | +4.93; +1.97 |
| records swept | 321,434 | 91,252 | 377,187 |
| **the piece over all the records swept, a first run: ticks; of the reference's** | **565,724; 86%** | **342,195; 61%** | **1,859,532; 154%** |
| the same, a second run | 228,218; 35% | 129,578; 23% | 743,058; 62% |

**Where it differs from the specification.**

- **The gate for a chunk named the rows' sweeps alone.** The note before this one said the next gate would state cycles a chunk and work a record apart, and this one did, for the rows' sweeps; the piece's work is in C's loop, whose step takes the new masks in every block. C's sweeps' first run over a chunk, less their second, rose by 410, 630 and 373 ticks a chunk, the rows' by +116, +237 and +63.
- **The rule for a conversion the tasks put into an operator's arms is three of the reference's terms.** The specification said the reference's terms, a record at a time, and the first two builds had them all. 18 faults of those terms survived the first round, and the rule is now a target of another type, of an integer's class, with an arm that is a constant. It lists 16 expressions of `sqlite3.c` and 6 of musl that the reference takes, which is L2's shortfall: two gates pulled against each other, and the faults' gate was kept.
- **How a record learns whether it is evaluated as branches.** The specification had the loop's rule by the consumer's class with these operators' values added. A record under a value's `&&` has to know whether that `&&` is itself branches, so a record now has its consumer's answer where it is chained to it, down a run by two doubling steps. The first build asked a `!`'s consumer's answer through a permute; the second lists a value whose first operand is a `!`, and reads less: it takes 4 expressions fewer than the first on `sqlite3.c` and 3 on musl.
- **A `!` over these operators is taken:** the specification left a `!` over or under them listed. Under one it is listed still (a value's first operand), and a run of more than three chained records.
- **Terms the fault rounds took out:** 15 that what makes the records implies (the address's bit in three masks, a logical value's class, the made commas' mask in the discard's among them). Five faults that no test separates are terms kept as the reference has them; the pull request names each.
- **Nothing else moves, as a gate, did not hold:** two builds read the kernel, which has no change, a third of a tick apart. A margin of a third of a tick a record, as L3's are, is at the edge of what a build against another can tell here.

**What it means.**

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
- **On the compiler's own source,** which no gate named, 2,417 expressions more have their tape whole (41,890 for 39,473, of 52,163). 2,712 of its 9,606 operators' values are listed for their target and X lists 1,448 expressions at a turn for 560: an arm converted to bool and a second operand of a narrow class are what the piece lists there, and this source has `bool` where the corpora have `int`.

**Next: a taken expression's references and events, the flip's first piece (#2524's step 2).** Its specification follows here before its code. It is where the window's sweeps run in a compile, so its gates state a chunk's first run for every sweep it touches, C's among them, and [#3196](https://github.com/buster14a/buster/issues/3196)'s cold start is measured there.

---
Agent session: [private session](https://claude.ai/code/session_01EgbxneipucKBYgjW4XLXVp)
Model: Anthropic / claude-fable-5-2

---
_Generated by [Claude Code](https://claude.ai/code)_
