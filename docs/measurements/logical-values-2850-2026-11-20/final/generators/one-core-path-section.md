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
had six gates. It is exact and its faults are caught. It takes {{=d('sqlite3','short_of_asked')}} expressions
fewer than asked on `sqlite3.c` and {{=d('musl','short_of_asked')}} on musl; its work a record is within
its gate for the rows and at C's bound; and its cost is a chunk's first run of
C's loop, which no gate named.

### What it measured

The 9700X, CPU 2, under the lock, Release, TSC ticks, seven readings; in each
the build, the piece before's executable twice, and the build again:

{{file:table}}

### Against its gates

- **L1, exact: met.** No answer of C's and no entry of X's tape differs from the reference's on the three corpora and
  the compiler's own source; {{=d('probes','all')}} one-statement programs agree.
- **L2, how much: met on Lua alone.** {{=d('sqlite3','more_taken')}}, {{=d('lua','more_taken')}} and {{=d('musl','more_taken')}} expressions more are taken where 780, 355 and 950 were asked.
  The rule for a conversion the tasks put into an operator's arms lists {{=n(v['xl2']['sqlite3']['counts on']['taken'] - v['final']['sqlite3']['counts on']['taken'])}} and {{=n(v['xl2']['musl']['counts on']['taken'] - v['final']['musl']['counts on']['taken'])}} expressions that the build before
  took, since the first fault round: its terms no test separated are out.
- **L3, work a record: met for the rows; C's is at its bound on `sqlite3.c`.** A chunk's second run of the rows' sweeps
  reads {{=val('sqlite3','(a second run) a record of the taken')}} and {{=val('lua','(a second run) a record of the taken')}} ticks a record of the taken more than the piece before's on `sqlite3.c` and Lua (0.30 and
  0.40 asked); C's sweeps read {{=val('sqlite3','(a second run) C, a record of the decided')}} and {{=val('lua','(a second run) C, a record of the decided')}} a record of the decided (0.35 asked, 0.70 refutes).
- **L4, a chunk: met on `sqlite3.c` and musl by their medians, not on Lua.** The rows' sweeps' first run less their
  second rose by {{=val('sqlite3',"the rows' sweeps: a chunk's first run less its second, ticks a chunk")}}, {{=val('lua',"the rows' sweeps: a chunk's first run less its second, ticks a chunk")}} and {{=val('musl',"the rows' sweeps: a chunk's first run less its second, ticks a chunk")}} ticks a chunk (150 asked, 300 refutes), and each corpus's range
  reaches past 300. C's sweeps', which the gate did not name, rose by {{=val('sqlite3',"C's sweeps: a chunk's first run less its second, ticks a chunk")}}, {{=val('lua',"C's sweeps: a chunk's first run less its second, ticks a chunk")}} and {{=val('musl',"C's sweeps: a chunk's first run less its second, ticks a chunk")}}.
- **L5, nothing else moves: not as written.** The rows' reads are within 0.2 on `sqlite3.c` and Lua. The kernel in
  place, whose source the piece does not touch, reads {{=val('sqlite3','the kernel in place, a record')}} and {{=val('lua','the kernel in place, a record')}} (less in each of the three builds), and the
  tests' sweeps {{=val('sqlite3','the tests on the window, a record')}} and {{=val('lua','the tests on the window, a record')}}: two builds read a sweep with no change a third of a tick apart or more.
- **L6, faults: met, with five faults no test separates whose terms stay.** Two rounds. The first's {{=d('faults','round1')}} faults
  left {{=d('faults','round1_survived')}}: {{=d('faults','taken_out')}} terms that what makes the records implies, which are out of the code; {{=d('faults','sink')}} of the first rule for
  the tasks' conversions, which is three terms now; {{=d('faults','lined')}} that found a line of the fixture or a pin to add; and
  {{=d('faults','nothing')}} that change nothing a program reaches. The second's {{=d('faults','round2')}}, on the code as it is: {{=d('faults','round2_caught')}} caught, and {{=n(len(v['derived']['faults']['round2_survived']))}} that
  change nothing a program reaches.

### What stays a record at a time, and why

In C's loop, one record in {{=three('asking_one_in')}} of those swept, an operator's value or a comma: whether a comma's consumer
is of void's class, a discarded comma's context's byte, and the rule on an operator's value's target, which reads
its type's class. The first build had the vector's forms of the first two, a permute of the block's classes by the
consumer's lane in every block and a blend (and a second permute, for a `!`'s consumer's answer): its loop read {{=f(float(val('sqlite3',"(a second run) C's loop",'d','xl1')) - float(val('sqlite3',"(a second run) C's loop",'d','xl2')))}}
and {{=f(float(val('lua',"(a second run) C's loop",'d','xl1')) - float(val('lua',"(a second run) C's loop",'d','xl2')))}} ticks a record swept more a second run than the build without them. In X, an operator's value's turn, a byte or two at its operands' places; and the numbering,
for {{=three('numbered_share','%')}} of the tapes.

### What it means

- **X's tapes are whole on the window** for {{sqlite3|counts on|taken}}, {{lua|counts on|taken}} and {{musl|counts on|taken}} of the three corpora's {{sqlite3|counts on|expressions}}, {{lua|counts on|expressions}} and
  {{musl|counts on|expressions}} expressions: {{=d('sqlite3','more_taken')}}, {{=d('lua','more_taken')}} and {{=d('musl','more_taken')}} more, with {{=three('more_records_share','%')}} more records.
- **What they cost against the reference.** By its averages a record, the reference's C and X read {{=three('reference_ticks')}}
  ticks on the newly taken records. Over all the records swept the piece adds {{=three('first_share','%')}} of that
  a chunk's first run, and {{=three('second_share','%')}} its second. **On musl a first run costs more than the
  reference's work it replaces:** its chunks are {{=d('musl','records_a_chunk')}} records.
- **The cost is C's loop's, by the chunk.** Its step has the new masks in every block: {{=val('sqlite3',"C's loop")}}, {{=val('lua',"C's loop")}} and {{=val('musl',"C's loop")}}
  ticks a record swept more a first run, {{=val('sqlite3',"(a second run) C's loop")}}, {{=val('lua',"(a second run) C's loop")}} and {{=val('musl',"(a second run) C's loop")}} a second. The specification gated a chunk's cost for the
  rows' sweeps and not for C's: the loop's cold start a chunk
  ([#3196](https://github.com/buster14a/buster/issues/3196)) grew with the masks its step took on.
- **Next:** a taken expression's references and events, the flip's first piece, where the window's sweeps run in
  a compile and their cost by the chunk is settled.
