# buster#2524: step 1's designs, measured (2026-11-15)

Claimed in [buster#2524](https://github.com/buster14a/buster/issues/2524#issuecomment-6893315910), at the owner's ask:
which design runs the node machine's sweeps in the fewest cycles a taken node, with 9700X timings for each candidate, and
whether full 512-bit lanes help. Step 1's gate asks for 120 cycles a taken node on `sqlite3.c`; main's three sweeps cost
174 to 175 there.

**The result, in order of what it is worth:**

1. **Where the machine runs is worth more than any design of its sweeps.** The gate is measured in the shadow's tight
   loop, one expression's sweeps right after another's. With other code run between two expressions, as the reader's is
   in a compile, `sqlite3.c`'s three sweeps and that code together cost 273 cycles a node more than the code alone, not
   175. Handing the machine 256 expressions a run brings that back to 187, and a body's expressions to 217.
2. **C and X as one sweep is exact and pays on `sqlite3.c` and Lua in every position:** against main's three sweeps in
   the tight loop, 173.8 to 164.2 cycles a node on `sqlite3.c` (−5.5%) and 146.0 to 141.1 on Lua (−3.4%); 6 to 8% and 3
   to 5% with other code between the runs. musl gains nothing in the tight loop (130.7 to 130.2), 3% with one
   expression a run and under 1% by bodies.
3. **An expression's shape as a memo doesn't pay.** 39% of `sqlite3.c`'s taken nodes are in expressions whose shape
   the unit has had, 31% of Lua's and 16% of musl's; every one of them got its first expression's entries, exactly. But
   the key reads all that T reads, 41 cycles a node, and the whole is 24% slower than the three sweeps.
4. **Lanes don't pay inside an expression.** An expression's records fill 9% of 16 lanes. T's per-record prologue by
   lanes over the expression's node range is exact and saves 17 instructions a node, and no cycle.
5. **The shadow's tight figures moved with the sets timed beside them,** on a corpus of many files: it took its sets
   in turn inside a pass, so a file's T ran after another set's code. Lua's T read 79 cycles a node after its own
   pass, 82 after the three sweeps' and 89 after the walk's. The pull request runs each set's passes one after
   another; `sqlite3.c`, one file, didn't move. Jobs 1 to 9's Lua and musl figures are not to be compared between
   builds or options (section 5).

None of the candidates reaches 120 in the tight loop: the best, T and the one sweep, is 164.

## Builds

The 9700X (`benchpress`), Release, each in a fresh worktree by `scripts/build-label.sh`, under the lock; every run
`taskset -c 2`, `--passes 11`, a round's runs in one or two holds, three rounds (two for musl), medians
(`scripts/tables.py` prints every table here from `results/9700x`).

| label | revision | what | jobs |
| --- | --- | --- | --- |
| `s1` | buster `6a02a97f` + `patches/s1.patch` | the shapes' first prototype (`--shapes`), and the fused sweep's census | 1 |
| `s2` | + `patches/s2.patch` | C and X as one sweep (`--fused`) | 2 |
| `s3` | + `patches/s3.patch` | the lanes' census (`--lanes`) and T's prologue by lanes (`--lanes-t`) | 3 |
| `s4` | + `patches/s4.patch` | the shapes' key by lanes, long shapes kept at their second expression | 4 |
| `s5`, `s6` | + `patches/s5.patch`, `s6.patch` | the census's walk between expressions (`--interleave`), then by chunks (`--interleave N`) | 5, 6 |
| `m5` | buster main `1b6461b7` | main | 7 to 11 |
| `p1`, `p2` | main + `patches/p1.patch`, `p2.patch` | the fused sweep's census, C and X as one sweep and the interleaved sets; `p2` leaves C and X as main has them | 7, 8, 10 |
| `p3`, `m6` | main + `patches/p3.patch`, `m6.patch` | `p2`, and main alone, with each sweep's function on a 64-byte line | 9 |
| `p4` | main + `patches/p4.patch` | **what buster's pull request holds:** `p2`, with each timed set's passes run one after another | 10, 11 |
| `m7` | main + `patches/m7.patch` | main, with that order alone | 11 |

Each patch is the whole difference from its base. `s1` to `s6` are the exploration as it went: their three sweeps run
595 to 619 instructions a node on `sqlite3.c` where main's run 595, as marks that kept a function inlined in two
callers changed its code elsewhere. Up to `p3` the shadow took its sets in turn inside a pass (section 5): there,
compare `sqlite3.c` within a build, and nothing else.

## 1. Where the machine runs (job 10; jobs 5, 6 and 8 before it)

`--interleave N` takes a file's taken expressions by chunks of N (a body's for 0): the census's own walk of each of a
chunk's expressions (`node_census_expression`: its tests over the same nodes, 904 to 909 instructions and 227 to 232
cycles a node on `sqlite3.c`), then the sweeps of each. Three sets: the walk alone, the walk and the three sweeps, the
walk with T and the one sweep. "Less the walk" is a set's cycles less the walk alone's: what the sweeps add, the walk's
own slowdown included. "Own" is the sweeps' TSC ticks inside the set (two `rdtsc` a chunk) at the tight set's cycles a
tick. The pair's instructions are the sum of the two alone (1,504.9 against 908.7 and 596.2).

`p4`, cycles a taken node:

| `sqlite3.c`: a run takes | three sweeps, less the walk | T and the one sweep, less the walk | three sweeps' own | the one sweep's own |
| --- | ---: | ---: | ---: | ---: |
| (the tight loop, no walk) | 174.9 | 163.3 | | |
| 1 expression | 273.4 | 255.9 | 207.1 | 190.9 |
| 16 | 243.5 | 225.3 | 196.1 | 182.9 |
| a body's (19 on average) | 216.5 | 199.3 | 189.6 | 176.7 |
| 256 | 186.7 | 172.9 | 181.7 | 170.9 |

| Lua: a run takes | three sweeps, less the walk | T and the one sweep, less the walk | three sweeps' own | the one sweep's own |
| --- | ---: | ---: | ---: | ---: |
| (the tight loop, no walk) | 145.9 | 141.0 | | |
| 1 expression | 206.5 | 197.8 | 169.9 | 162.0 |
| 16 | 167.5 | 161.0 | 154.9 | 149.7 |
| a body's | 168.6 | 163.2 | 155.4 | 150.6 |
| 256 | 150.7 | 145.9 | 149.0 | 144.7 |

| musl: a run takes | three sweeps, less the walk | T and the one sweep, less the walk | three sweeps' own | the one sweep's own |
| --- | ---: | ---: | ---: | ---: |
| (the tight loop, no walk) | 130.2 | 129.9 | | |
| 1 expression | 188.7 | 183.3 | 154.1 | 149.9 |
| a body's | 144.7 | 143.7 | 136.1 | 135.4 |

`s6` has 4 and 64 too, with the sets in turn, which one file's passes hardly feel: on `sqlite3.c` the three sweeps less
the walk are 280.3, 271.9, 246.7, 225.7 and 189.1 at 1, 4, 16, 64 and 256, and 223.4 by bodies; `p2`'s are 278.7,
243.6 and 189.1 at 1, 16 and 256, and 220.8 by bodies.

- **One expression a run costs the sweeps 18% of their own time** on `sqlite3.c` (207.1 against 174.9), **and the
  code between them twice as many cycles** (273.4 less 207.1 is 66 a node, on the walk's 229): each puts the other's
  code and branches out of the caches and the predictor. The pair's extra is 56% over the tight loop there, 42% on Lua
  and 45% on musl.
- **By 256 expressions a run little is left of it:** 186.7 against 174.9 on `sqlite3.c` (7%), 150.7 against 145.9 on
  Lua (3%).
- **A body's expressions are worth chunks of 64** on `sqlite3.c`, whose bodies hold 19 taken expressions on average,
  the long ones most of them (`s6`: 223.4 by bodies, 225.7 at 64); on Lua, chunks of 16.

So the gate's figure is the machine's best position, which a compile gives it only where a run takes many expressions:
a body's at least. Step 3 has that by what it is. Step 2 takes "a range" after the reader's walk: the range should be a
body's or a statement list's expressions, never one.

## 2. C and X as one sweep (jobs 10 and 11; jobs 2 to 9 before them)

`node_machine_lower` (`c_check_node_machine_lower.c` in the patches): down from the root as C goes, each evaluated
record classified by C's own functions and its row written at once, the tape from its end, since the records come in
reverse postorder. Labels, the calls' rows and temporaries, which X numbers by the order it writes in, are numbered
after the loop.

The tight loop, cycles and instructions a taken node, a set's passes in a row (job 11, one hold a round):

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| main's three sweeps (`m7`) | 173.8, 594.8 | 146.0, 683.9 | 130.7, 645.1 |
| `p4`'s three sweeps | 175.4, 596.2 | 146.2, 685.0 | 130.3, 646.5 |
| `p4`'s T and the one sweep | 164.2, 600.5 | 141.1, 689.5 | 130.2, 651.0 |
| the one sweep against main's three | −5.5% | −3.4% | −0.4% |
| against `p4`'s own three | −6.4% | −3.5% | −0.1% |

With other code between the runs (`p4`, job 10; the pair less the walk, then the sweeps' own time):

| a run takes | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| 1 expression | −6.4%, −7.8% | −4.2%, −4.6% | −2.9%, −2.7% |
| 16 | −7.5%, −6.7% | −3.9%, −3.3% | |
| a body's | −7.9%, −6.8% | −3.2%, −3.1% | −0.7%, −0.5% |
| 256 | −7.4%, −5.9% | −3.2%, −2.9% | |

`sqlite3.c` in each earlier build, the three sweeps and T with the one sweep in the tight loop: `s2` 176.4, 165.8
(−6.0%); `s3` 179.2, 172.1 (−4.0%); `s4` 179.8, 171.9 (−4.4%); `s5` 181.3, 172.2 (−5.0%); `s6` 180.6, 170.1 (−5.8%);
`p1` 177.5, 166.4 (−6.3%); `p2` 176.1, 162.6 (−7.6%); `p3` 176.7, 162.1 (−8.3%).

- **It runs C's and X's instructions, not fewer:** 600.5 a node against the three sweeps' 596.2. After T's 89.2
  cycles, C and X take 85.7 for 259.4 instructions, the one sweep 74.1 for 263.7 (`p4`, job 10). What it saves is the
  second walk of the records: X's 88.1 instructions took 38.8 cycles.
- **`p4`'s own three sweeps are main's within 1%** (175.4 against 173.8 on `sqlite3.c`, 1.4 instructions a node more:
  the marks that keep C's classification inlined in both its callers changed C's code).
- **musl's units are short** (16 taken expressions a unit, 5 nodes each): the one sweep's loop setup and its numbering
  after the loop are a larger share there.

## 3. An expression's shape as a memo (jobs 1, 2, 4)

A taken expression's entries are a function of its shape: each record's operator and operands' places, its cast's type
or its member's name, and a leaf's type, flags, category, constant and object's kind; the leaves' objects only up to
renaming (which leaves name the same object, which the same symbol); and the root's context, target and initialized
object. The sweeps read an object only for whether it is none, for its kind and for its symbol, and copy it. A unit's
later expression of the same key takes the first one's tape with its own objects and symbols in place
(`c_check_node_machine_shape.c` in `patches/s1.patch` and `s4.patch`). Not kept: an expression T typed a node of by the
action, one with a wide value, one whose rule found a type incomplete at a node.

**Every hit is exact:** each was instantiated and then compared with the sweeps' tape, labels and calls on the same
expression, with no difference on the three corpora (`results/9700x/s1/time-sh-*-r1.txt`, `s4/time-fs-*-r1.txt`).

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| taken expressions, evaluated nodes (buster `6a02a97f`) | 51,135, 257,263 | 10,444, 57,779 | 21,604, 110,119 |
| hits, every shape kept at its first expression: expressions, nodes | 55.4%, 38.8% | 39.3%, 30.7% | 22.7%, 15.8% |
| hits, a shape of over 5 records kept at its second: expressions, nodes | 50.7%, 32.4% | 34.0%, 23.6% | 19.0%, 10.6% |
| the units' stores: every shape; long shapes at their second | 7.9 MB; 2.4 MB | 1.9 MB; 0.7 MB | 4.6 MB; 1.8 MB |
| nodes in expressions seen before, the key without the leaves' integers | 44.3% | 36.6% | 21.2% |
| without casts' types and members' names too | 49.0% | 40.1% | 23.5% |
| without the leaves' types too | 67.8% | 49.7% | 29.3% |

By size on `sqlite3.c`: 86 to 90% of the expressions of 1 to 3 records hit, 75% of 4, 49% of 5, 32% of 6 to 8, 14% of 9
to 16 (`results/cloud/sqlite-1.txt`; the looser keys, `results/cloud/*-f1*.txt`).

Cycles and instructions a taken node (the sets in turn: `sqlite3.c`'s rows compare, Lua's and musl's only roughly):

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| `s1`: the three sweeps | 174.4, 595.1 | 152.2, 684.2 | 133.8, 644.9 |
| `s1`: the shapes, the sweeps for a miss | 237.4, 606.6 | 171.0, 723.1 | 171.4, 796.2 |
| `s4`: the three sweeps | 179.8, 615.2 | 162.1, 705.0 | 143.3, 665.7 |
| `s4`: the shapes (key by lanes, long shapes at their second) | 222.1, 601.4 | 180.8, 714.4 | 182.9, 778.5 |
| `s4`: the shapes, T and the one sweep for a miss | 207.4, 604.9 | 175.2, 717.7 | 180.9, 781.8 |
| `s4`: every expression's key alone | 40.6, 133.6 | 29.0, 129.6 | 28.9, 133.4 |
| `s4`: its key and the lookup | 47.8, 145.8 | 32.5, 140.5 | 30.6, 144.0 |

- **The key is a quarter of the sweeps:** it reads what T reads of every record, so a miss pays it on top.
- **A hit isn't free either:** with each expression run twice in a row (`--repeat 2`, `s1`, `sqlite3.c`), the second,
  a hit with its inputs in the caches, costs 55 cycles a node where the sweeps' second run costs 118.
- **The misses are what's left,** and they are the long expressions: `sqlite3.c`'s 222.1 less the key and lookup's
  47.8 is 174 a node of the whole, for the sweeps of the two thirds that missed and the hits' copies.
- **No looser key helps enough:** without the constants' values, which an exact memo could parametrize, 44% of
  `sqlite3.c`'s nodes; the types, which decide the entries' classes, are the rest.

## 4. Lanes (job 3; `results/9700x/s6/lanes`, `results/cloud/lanes-census.txt`)

**How full 16 lanes would be** (`--lanes`): the taken expressions as batches, each batch's records grouped by level (a
leaf's 0, any other's one past its operands' greatest) and class (leaf, discard, cast, member, call, truth, store,
additive, other row operators, address or dereference, logical, other): a group is what one vector step could take.

| batch of | `sqlite3.c`: records a group, lanes filled | Lua | musl (the cloud's copy) |
| --- | ---: | ---: | ---: |
| 1 expression | 1.46, 9.1% | 1.58, 9.9% | 1.53, 9.5% |
| 8 | 3.14, 18.6% | 3.28, 19.3% | 3.11, 18.5% |
| 64 | 9.77, 45.4% | 10.08, 46.3% | 6.20, 32.9% |
| 512 | 45.9, 82.5% | 30.8, 74.7% | 7.37, 36.7% |
| a body's | 6.62, 33.9% | 4.61, 25.6% | 5.13, 28.2% |

On `sqlite3.c` leaves are 46% of the records and fill 96% of their lanes at 64 expressions; members 59%, discards 44%,
the rest 10 to 34%. Records by level: 46%, 21%, 16%, 9%, 4% and 3% past it. musl's units are too small for batches: 107
records a unit.

**T's prologue by lanes** (`--lanes-t`, `c_check_node_machine_lanes.c` in `patches/s3.patch`): an expression's nodes
are one range of the reader's columns, so one 16-lane step reads every record's operator (the leaves' mask), its first
two operands' records (stored to their columns) and what refuses the expression before a record is typed (a node in a
constant context or a floating-point environment, an operand outside the range, arguments on anything but a call);
then the leaves and the other records are two loops over the masks' bits. Exact: every record's columns compared with
T's on every expression of the three corpora, with `-g` too, no difference; all of `sqlite3.c`'s expressions go by the
lanes, all but one of Lua's and all but 39 of musl's.

| T alone, cycles and instructions a taken node (`s3`, the sets in turn) | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| T | 92.2, 349.5 | 91.8, 441.4 | 79.6, 395.1 |
| T, its prologue by lanes | 92.9, 332.2 | 92.8, 415.6 | 81.3, 375.5 |

It saves 17 instructions a node on `sqlite3.c` (26 on Lua, 20 on musl) and no cycle, in the tight loop and with one
expression a run alike (T by lanes with the one sweep, less the walk, on `sqlite3.c`: `s5` 253.5 against 256.4, `s6`
257.3 against 256.3). T isn't held
by the instructions of its bookkeeping.

**Lanes over batches sorted by level and class** weren't built. They would fill half their lanes at 64 expressions, but
a record's operands are records elsewhere in the batch: a 16-lane gather costs the 9700X what 16 loads cost. And they
need the sweeps by batches, which lose the predictor's handoff between an expression's sweeps
([the batching record](../node-machine-batches-2524-2026-11-14)).

## 5. The shadow's order of sets (jobs 7 to 11, the probe)

Main's shadow times a file's sets in turn inside each of its passes (T, then T and C, then all three) and keeps each
set's least. The sets this round added ran in the same turn, so a file's T came after the walk with T and the one
sweep, not after the three sweeps. One file of 51,042 expressions doesn't feel what ran before it; a Lua file's 300 and
a musl unit's 16 do.

| T alone; the three sweeps: cycles a taken node (main's rows job 11, the others job 10) | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| main, the sets in turn (`m5`) | 89.5; 173.9 | 82.3; 147.6 | 73.4; 132.2 |
| main, a set's passes in a row (`m7`) | 88.7; 173.8 | 80.2; 146.0 | 70.8; 130.7 |
| `p2`, the sets in turn, no option | 90.3; 176.0 | 82.4; 150.5 | 73.9; 134.9 |
| `p2`, `--fused --interleave 1` (three more sets in the turn) | 92.1; 176.3 | 89.4; 163.7 | 75.4; 138.2 |
| `p4`, a set's passes in a row, no option | 89.3; 174.9 | 79.3; 145.8 | 69.8; 130.3 |
| `p4`, `--fused` | 89.3; 174.7 | 79.3; 145.9 | 70.3; 130.1 |
| `p4`, `--fused --interleave 1` | 89.8; 175.2 | 79.7; 146.2 | 70.1; 130.3 |

- **The same code read 163.7 or 150.5 on Lua by the options alone** (`p2`), and T, whose bytes are main's, 89.4 or
  82.4. With `--fused` alone (the probe, `results/9700x/p2/probe-p11f-*`): T 83.5, the three sweeps 152.9.
- **With a set's passes in a row the options change nothing** (`p4`: T 79.3 to 80.0 on Lua over six option sets), and
  main's own figures drop 1.1% on Lua and musl (`m7`), none on `sqlite3.c`.
- **What jobs 1 to 9 hold:** `sqlite3.c`'s figures. Their Lua and musl tight figures were each taken after another
  set's pass: `p2`'s one sweep read −5.8% and −2.8% against its three sweeps there, `p4`'s reads −3.5% and −0.2%.
- **It first read as the code's place:** T, byte for byte, 7 cycles a node slower on Lua at another address. A 64-byte
  line for each sweep's function didn't change it (`p3`: T 88.6 on Lua), and costs main 0.6%, 1.6% and 1.9% on the
  three corpora with the same sets (`m6` 174.8, 149.8 and 134.6 against `m5`'s 173.7, 147.4 and 132.1, job 9): not
  kept. The counters of the two builds with no option settled it (`scripts/counters.sh`, 101 passes: Lua's cycles
  within 1%).

It is section 1's effect on the harness itself: a few hundred expressions after other code are not a tight loop.

## Checks

- **C and X as one sweep** (`--fused`, the cloud's copies, `results/cloud/*-p1*.txt`): no difference in refusal, tape,
  labels' entries or calls' records on `sqlite3.c` (51,338 expressions), Lua (10,828) and musl (22,998), with `-g`
  too; and on the 9700X's copies in every timing run. `test-checker` passes with it on the shadow's fixture. Four
  deliberate breaks each show: the calls' rows left in the sweep's order (291 of `sqlite3.c`'s expressions differ),
  the labels' numbers (73), a member's load written before its offset (11,343), and the temporaries' order (2 of 3
  expressions of a fixture with several postfix updates through addresses; `sqlite3.c` has none with two).
- **The shapes:** every hit compared with the sweeps (above).
- **T's prologue by lanes:** every record's columns compared (above; `results/cloud/*-l1.txt`).

## Files

- `scripts/`: the 9700X's (`build-label.sh`; `time-o.sh` and `time-musl-o.sh`, a round's runs in one hold; `job1.sh`
  to `job11.sh`; `probe1.sh` and `counters.sh`, section 5's; `tables.py`, every table here; `medians.py` and
  `chunks.py`, one run set's), the cloud's (`shadow-local.sh`) and the callgrind readers (`cg-lines.py`, `cg-top.py`:
  instructions by source function and by line).
- `patches/`: each build's difference from its base.
- `results/9700x/LABEL/`: each run's report (`time-TAG-CORPUS-rN.txt`), the build's log, its compiler's checksum and its
  node machine symbols; `s6/lanes/`, the lanes' census; `m5` and `p2`, the probe's and the counters' runs.
  `results/cloud/`: the cloud container's runs.

## Traps

- **A set timed after another set's pass isn't tight** (section 5): time each set's passes in a row, and check a
  figure against the same build with fewer options.
- **A Develop build splits the unit in parts** (`.buster_split` symbols), so its inlining isn't Release's: count
  instructions on `BUSTER_HOST_ARCH=x86-64 ./build.sh --config Release` under callgrind (3 minutes to build).
- **A second caller of a static function takes it out of line in the first,** or with `always_inline` changes that
  one's code: `s2` to `s6`'s three sweeps run up to 24 instructions a node more than main's for it.
- **The census's walk is foreign code only by its size:** it reads the same nodes, so it warms the sweeps' inputs. A
  set less the walk can come near the tight loop's (Lua at 256: 150.7 against 145.9).
- **The walk alone moves between runs once its passes are in a row** (221 to 240 cycles a node on `sqlite3.c` over
  twelve runs, 252 to 254 with the sets in turn): a set less the walk is good to 3% there, the sweeps' own time closer.
- **One round can read apart:** `p3`'s three sweeps read 182.8 on `sqlite3.c` in every run of one round and 175.7 in
  the other two's, its T and one sweep steady. Three rounds' median hides it; one round wouldn't.
