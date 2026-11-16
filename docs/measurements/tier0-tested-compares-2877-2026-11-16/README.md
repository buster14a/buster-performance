# Tier 0: a compare behind its tests leaves the flags, and its branch is the jump (buster#2877), 2026-11-16

[buster#2877](https://github.com/buster14a/buster/issues/2877), under
[its claim](https://github.com/buster14a/buster/issues/2877#issuecomment-6918317922)
and [the claim's update](https://github.com/buster14a/buster/issues/2877#issuecomment-6920569304).
The lowering writes a condition as its value tested against zero, so
`if (a < b)` reached Tier 0 as a compare, `CONST 0`, `NE` and a branch, and
its code was `cmp; setl; movzx; test; je`: 53% of `sqlite3.c`'s conditional
branches, 7.5% of its instructions
([the census's record](../tier0-census-2874-2026-11-16), `a465b001`). This is
the fusion that makes it `cmp; jge`, on Tier 0's side: the stream is the same.

**Result.** The shape is left at **2 of 8,915 sites in `sqlite3.c`, 18 of
1,549 in Lua and 76 of 4,768 in musl** (0.02%, 1.2%, 1.6%), each named by
its reason. The objects have **7.8%, 5.5% and 7.1% fewer instructions** and
6.1%, 4.3% and 5.2% less code. A compile of `sqlite3.c` is **within main's
own repeat** (wall -0.32% where main again reads -0.16%; 345,066 fewer
instructions of 1.36 billion). The compiler built by Tier 0 with the fusion
compiles `sqlite3.c` in **4.6% fewer instructions and about 1.5% less
time** than the one built without it.

Against the claim's gate: the shape at 5% or fewer of today's sites in each
corpus, the rest by reason: **met**. Correct: **met** ("Correctness"
below). Measured on the 9700X, main against head: **done**. A compile of
`sqlite3.c` no slower than main beyond main's repeat: **met**.

The change is buster's pull request for #2877, from the branch
`claude/amazing-davinci-yehx28`; the result against the gate is on the
issue.

## What was built

- **The fusion** (`src/buster/compiler/tier0.c`). A compare whose value only
  a branch reads, behind one or two tests of it against zero, takes a `FLAGS`
  variant: its `cmp` alone, no `setcc`. The branch, with the tests between,
  takes a `JUMP` variant keyed by the compare's kind and class: the `jcc`
  alone, its condition turned by each `EQ` among the tests. No entry between
  the two makes a record, so the flags reach the jump. Both paths make the
  same groups: the scalar fusion changes the compare's variant when it
  reaches the branch, and the vector path sets it from the branch's lane,
  three or five lanes on, in the same 64-entry block or in the one before.
- **240 templates** for it (192 flags, 48 jumps); 2,220 in all, from 1,980.
- **Its tests** in `test-tier0`: every compare, class, operand form, test or
  two tests and branch (1,440 conditions), 190 more at every place across a
  block's end, the streams it must leave alone, and an eighth shape of
  generated programs whose conditions are written this way, run natively
  against the interpreter and, with `--cross-check`, against clang -O0.
- **Two lines of `measure-tier0-entries`**: the conditional branches by what
  their group takes, and the sites where a compare's value is still made and
  tested again, by why. They are the count "by reason" below.
- No change to the lowering, the encoder, branch sizing or the object writer.

## How it was measured

- The 9700X (`benchpress`), CPU 2, every build and run under the host's
  lock, one hold a run (`scripts/lock.sh`; `scripts/queue.sh` runs a list of
  them with 20 s between two holds). Another session's runs shared the
  machine through the same lock.
- `main` is buster main `56c2c294`, `./build.sh --config Release`
  (`scripts/build-label.sh`). `head` is main with the pull request's patch
  to `src` and `tests` (`scripts/head.patch`), built the same way. The
  counts and the timings were run at buster `877c29f1`; the tests' times and
  a fourth compile comparison (`results/head/final-1.txt`) at the last
  commit, `f0ad5995`, which changes one count in `test-tier0`'s cross-check
  and is the build `results/head/` now names (`head.patch`,
  `compiler.sha256`).
- The inputs are the census's record's: the frozen `sqlite3.c`
  (`/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite`, with
  `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0
  -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`), Lua 5.4.8's 34 files and
  the frozen musl's 1,336 units (`scripts/corpora.sh`).
- **The shape** is counted twice. In the objects' code, as the census's
  record counted it (`scripts/shapes.sh`: `setCC %al; movzbl %al,%eax; test
  %eax,%eax; je` or `jne`, by `objdump`). And in the records as Tier 0 made
  them, by `measure-tier0-entries` (`scripts/census.sh`), which gives each
  site to the entry that holds the test and reads the reason from the stream
  there. The two counts are the same on every corpus.
- **The compile**: `-c sqlite3.c` as whole processes by `time-runs` under
  `ab` (`scripts/compare.sh`): 7 runs of each of 3 fresh copies of base, head
  and base again in a Williams order, each run its own hold, three times
  over; and `benchmark-backend-source` on each corpus, three runs a build
  (`scripts/backend.sh`, `scripts/backend-table.sh`).
- **The run time** of the code Tier 0 writes: the compiler itself, built by
  each build from head's sources as the self-host qualification's bootstrap
  does it (`scripts/selfbuild.sh`), and timed compiling `sqlite3.c`.

## The shape

`setCC %al; movzbl %al,%eax; test %eax,%eax; je` or `jne`, in the objects
each build wrote (`results/LABEL/shapes.txt`, every site in
`results/LABEL/sites-CORPUS.txt`), and head's sites again by
`measure-tier0-entries`, by why (`results/head/census-CORPUS.txt`):

| | main | head | left | a jump's target on the test | a class with no branch's template | a third test |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 8,915 | 2 | 0.02% | 1 | 0 | 1 |
| Lua 5.4.8 | 1,549 | 18 | 1.16% | 17 | 0 | 1 |
| musl | 4,768 | 76 | 1.59% | 1 | 75 | 0 |

- **A jump's target on the branch, its test or the test's constant** (19):
  a `?:` or another join whose arms bring the tested value, such as Lua's
  `luaV_fastget` (nine of Lua's are in `luaV_execute`). Another value can
  arrive there, so no window crosses it.
- **A compare of a class with no branch's template** (75, all musl's): a
  long double compare, in `powl`, `tgammal` and the other `l` functions. Its
  value is made by the x87 code (`seta` or `setae`, then `movzbl`) and the
  branch has the test of it.
- **A third test in a row** (2): `!!x` under a condition. The branch takes
  its compare from behind two tests, so the first of three is its compare,
  of the value the compare before it made.

What head's conditional branches take (the census's other line):

| | conditional branches | the compare right before | a compare behind one test | behind two tests | no entry |
| --- | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 16,876 | 7,755 | 8,952 | 112 | 57 |
| Lua 5.4.8 | 3,057 | 1,457 | 1,532 | 68 | 0 |
| musl | 8,734 | 3,699 | 4,744 | 37 | 254 |

"The compare right before" is mostly a value tested against zero (`if (x)`,
`if (p)`): its `CONST 0` and `NE` are the compare.

## The objects

`results/LABEL/objects.txt` and `shapes.txt` (`scripts/objects.sh`,
`scripts/tables.sh`):

| | | instructions | `.text` bytes | object bytes |
| --- | --- | ---: | ---: | ---: |
| `sqlite3.c` | main | 354,742 | 1,221,112 | 2,197,000 |
| | head | 327,214 (-7.76%) | 1,146,328 (-6.12%) | 2,122,168 |
| Lua 5.4.8 | main | 91,332 | 311,960 | 785,160 |
| | head | 86,328 (-5.48%) | 298,477 (-4.32%) | 771,640 |
| musl | main | 204,187 | 759,604 | 2,584,568 |
| | head | 189,730 (-7.08%) | 720,292 (-5.18%) | 2,545,232 |

The conditional branches are the same 16,876, 3,057 and 8,734: no jump is
added or removed. More goes than three instructions a counted site, since
the count is of the shape in `al` and `eax` alone (a condition deeper in an
expression made its value in another register), and a site behind two tests
loses six.

## The compile

**`-c sqlite3.c`, whole processes** (`results/head/compile-*.txt`,
`scripts/summary.sh`): three comparisons, each 21 runs of base, head and
base again; medians over the 63 runs a build:

| | wall | user cycles | instructions |
| --- | ---: | ---: | ---: |
| main | 123.073 ms | 596,768,391 | 1,363,596,489 |
| head | 122.685 ms (-0.32%) | 595,248,452 (-0.25%) | 1,363,251,423 (-0.025%) |
| main again | 122.878 ms (-0.16%) | 596,010,815 (-0.13%) | 1,363,596,490 |

Head's wall median is below main's in each of the three (-0.18%, -0.33%,
-0.40%), where main's own repeat reads +0.02%, -0.26% and -0.21%. A fourth
comparison with the last commit's build reads +0.03% wall and -0.15% cycles
for head, -0.20% and -0.09% for main again. The compile retires 345,066
fewer instructions.

**`benchmark-backend-source`** (`results/LABEL/backend-*.txt`,
`scripts/backend-table.sh`): the corpus's functions from their typed
streams, medians of three runs, cycles and instructions a typed entry:

| | | typed entries | records | code bytes | Tier 0 (vector path) | branch sizing | encoder | form choice |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | main | 395,061 | 354,742 | 1,200,885 | 65.23 cycles, 174.35 instr. | 5.48 | 3.86 | 1.42 |
| | head | 395,061 | 327,214 | 1,126,438 | 64.90, 175.13 | 5.19 | 3.59 | 1.28 |
| Lua 5.4.8 | main | 89,543 | 91,332 | 303,857 | 86.15, 221.82 | 6.71 | 4.68 | 1.79 |
| | head | 89,543 | 86,328 | 290,280 | 86.17, 223.28 | 6.47 | 4.42 | 1.71 |
| musl | main | 199,891 | 204,155 | 746,962 | 99.32, 269.91 | 6.76 | 4.80 | 1.78 |
| | head | 199,891 | 189,698 | 707,800 | 99.64, 269.76 | 6.47 | 4.53 | 1.67 |

- **The entries are the same and the records fewer**: 7.8%, 5.5% and 7.1%.
- **Tier 0's own cycles an entry don't move** (-0.5%, 0.0%, +0.3%): the
  fusion's masks and the compare's variant set from the branch's lane cost
  about what the records it no longer writes saved. Its instructions an
  entry are +0.4%, +0.7% and -0.1%.
- **What comes after it is cheaper by the records**: branch sizing, the
  encoder and the form choice are 4% to 10% fewer cycles an entry.

**Many small compiles** (`results/LABEL/stat-CORPUS-ROUND.txt`,
`scripts/stat.sh`): the corpus's `-c` compiles, a process a file, counted
by `perf stat` in holds that alternate between main and head, three rounds:

| | | user cycles | instructions | kernel cycles | minor faults |
| --- | --- | ---: | ---: | ---: | ---: |
| musl, 1,336 compiles | main | 5,324.2, 5,327.6, 5,328.0 M | 11,649,400,907 | 4,688, 4,704, 4,701 M | 918,625 to 919,453 |
| | head | 5,297.3, 5,299.2, 5,301.9 M (-0.50%) | 11,649,038,832 (-0.003%) | 4,617, 4,622, 4,618 M (-1.7%) | 895,238 to 897,481 (-2.5%) |
| Lua, 34 compiles | main | 546.1, 544.4, 545.2 M | 1,285,728,430 | 271.1, 270.9, 271.1 M | 38,461 to 38,476 |
| | head | 543.4, 543.9, 544.5 M (-0.2%) | 1,285,743,579 (+0.001%) | 267.6, 268.3, 267.9 M (-1.2%) | 37,759 to 38,163 |

- **A process's fixed costs are the executable file's, not the fusion's.**
  The templates' tables grew by 96 KB, so a 1 ms compile was checked alone
  (`scripts/compare-small.sh`, musl's `strlen.c`, fresh copies of each
  executable in `/dev/shm`): the same instructions (-0.012%), 4 more minor
  faults a process and about 2% more user cycles on head's copies
  (`results/head/small-*.txt`). `scripts/faults.sh` named every fault
  (`results/LABEL/faults.txt`): none is in Tier 0's tables, which that
  compile doesn't touch; they are where the pages' boundaries fall in the
  driver's and libc's own data once the sections have moved. From the
  builds' own files, in the rounds above, head takes 17 fewer faults a
  process than main and 0.5% fewer user cycles. The two disagree in sign
  at the same instructions, so neither is the fusion's work: a process of
  1 ms reads each executable file's pages and placement as 1% to 2%.
- The first `stat-*.txt` of each build (a hold a build, minutes apart) are
  kept; main's `sqlite3.c` hold there was disturbed (its cycles ±1.8%).

## At run time

The code Tier 0 writes, timed where it is the whole program: the compiler
itself, built from head's sources by main's compiler and by head's
(`scripts/selfbuild.sh`: 43 units, a unit at a time, as the self-host
qualification's bootstrap compiles them, without debug information), and
each self-built compiler compiling `sqlite3.c` (`scripts/compare.sh`'s
runs, `results/head/selfbuilt-*.txt`): three comparisons, medians over the
63 runs a build:

| the compiler built by | its `.text` | wall | user cycles | instructions |
| --- | ---: | ---: | ---: | ---: |
| main | 88,812,837 | 1,022.3 ms | 5,571,880,663 | 10,641,896,074 |
| head | 86,806,853 (-2.26%) | 1,006.9 ms (-1.51%) | 5,489,492,790 (-1.48%) | 10,154,803,522 (-4.58%) |
| main again | | 1,019.0 ms (-0.33%) | 5,554,958,017 (-0.30%) | 10,641,895,666 |

The same program retires **4.58% fewer instructions** and takes about 1.5%
less time (-0.5%, -1.4% and -2.1% in the three comparisons, where main's
repeat reads +0.4%, -0.5% and -0.7%). The saved instructions are cheap ones
(a `setcc`, a `movzx` and a `test` in front of a branch that was predicted
either way), which is likely why the time moves by a third of what the
count does.

## The census's own line

`measure-tier0-entries` is the census of
[buster#2874](https://github.com/buster14a/buster/issues/2874), whose gate
asked that a key of eight bytes or fewer decide 95% of the entries with no
conflict. With this fusion a compare's records depend on what comes after it
(whether a branch behind its tests reads its value), which a producer knows:
the census has one input for it, and a branch behind a test has the kinds
and classes of the entries four to six back. On head the line reads
(`results/head/census-*.txt`, keys of the raw inputs):

| | main (the census's record) | head |
| --- | ---: | ---: |
| `sqlite3.c` | 99.99% | 99.95% |
| Lua 5.4.8 | 100.00% | 99.98% |
| musl | 99.68% | 99.51% |
| the three as one | 99.83% | 99.68% |

Each corpus has fewer patterns (682 from 700 on `sqlite3.c`, 432 from 456 on
Lua, 806 from 827 on musl; 1,042 from 1,041 on the three as one) and larger
tables (27,260 rows from 24,650 on the three): a branch's jump is keyed by a
compare three or five entries back.

## The first design, and why it was replaced

The claim said the branch would take the compare, the `CONST 0` and the
`NE` as one group. That was built first (buster `fc611d5` to `632ec33` on
the pull request's branch): templates whose operands' holes are two entries
further back than a compare right before its branch has them. Its counts on
the same corpora:

| | main | first design | left |
| --- | ---: | ---: | ---: |
| `sqlite3.c` | 8,915 | 107 | 1.20% |
| Lua 5.4.8 | 1,549 | 86 | 5.55% |
| musl | 4,768 | 112 | 2.35% |

Lua was over the gate. 106, 69 and 36 of those sites were a test of a test:
`!(a < b)`, or a macro's `(x) != 0` around a condition, as Lua's `l_likely`
is, where the lowering writes two tests before the branch. A template
cannot take a compare's operands from behind two tests: a hole is at most
six entries back, and two fused operands start seven back. So the compare
keeps its record and leaves the flags, which has no reach to run out of,
needs 240 templates where the first design had 384, and shortens the
absorber's reach from five entries to four. The first design also took
#2874's line down to 88.99% on the three corpora (a group of six entries
needs more than eight bytes of key); the second keeps a condition two
groups, as main has it.

## Beside it

The issue named two smaller shapes and asked whoever took it to say whether
they deserve issues of their own (`results/LABEL/shapes.txt`,
`results/LABEL/joins.txt`).

- **A local updated as a statement** (`mov HOME,%eax; OP …,%eax; mov
  %eax,HOME`): 356 sites in `sqlite3.c`, 64 in Lua, 498 in musl, the same on
  main and head: 0.22%, 0.15% and 0.52% of head's instructions. The lowering
  writes `STORE_LOCAL` and `DISCARD` where the fusion's `x = x op v` ends in
  `SET_LOCAL`. Not filed: it is the stream's, and small.
- **A constant made and tested** (`xor %eax,%eax` or `mov $K,%eax`, then
  `test %eax,%eax; je` or `jne`): 3,074 sites in `sqlite3.c`, 378 in Lua,
  1,573 in musl on head. 3,024, 378 and 1,357 of them come right after a
  `jmp`: they are not the source's constants but the arm of a `&&` or a `||`
  that knows the answer.
- **That is the larger shape, filed as
  [buster#2883](https://github.com/buster14a/buster/issues/2883):** `&&` and
  `||` used as a condition are made a value, joined with a constant at a
  label and tested again (`scripts/joins.sh`).

| | joins | of them of a compare | instructions more than the jumps |
| --- | ---: | ---: | ---: |
| `sqlite3.c` | 2,822 | 2,194 | 20,692 (6.3% of head's) |
| Lua 5.4.8 | 354 | 228 | 2,454 (2.8%) |
| musl | 1,253 | 912 | 9,001 (4.7%) |

It has a jump's target in the middle, so no fusion's window crosses it: it
is the lowering's to write as branches.

## Correctness

- **`test-tier0`** on the 9700X (`results/LABEL/tests-time.txt`): head
  18,673,890 checks, 0 failed, in 2.8 s (main: 14,570,741 in 2.3 s), and
  with `--cross-check` 21,550,477, 0 failed, in 22.3 s (main: 17,211,491 in
  20.2 s). With as many cross-check programs of the new shape as of the
  others it took 25.4 s; the last commit runs a third as many.
- **The self-host qualification** on the 9700X (`scripts/qualify.sh`,
  `results/head/qualify/`): head compiles itself, its 43 units; the
  self-built compiler passes the 14 smoke commands, and the 5 probes
  compiled by both are the same bytes and run alike. PASS in 80.6 s.
- **Sixteen mutants** of the fusion and of the census's inputs each fail a
  test (a label forgotten on one path or both, either test's `EQ` taken as
  `NE`, any constant taken as zero, the fold's reach, the branch's key kind
  and class, the jump's sense, the flags' variant in the block before or in
  the wrong lane, the order of two tests against one, the first test not
  absorbed, a compare of two fused operands not taken). Two conditions a
  mutant could remove without a failing test were removed from the code:
  validation implies one, and the lines after it the other.
- **In the cloud session** (4 cores; not timings): `test-tier0
  --cross-check`, the c-testsuite's 220 programs by Tier 0 and by `--tier1`,
  and CI's correctness inventory of 150 commands, on the native build and on
  `BUSTER_HOST_ARCH=x86-64` (the scalar path), with the frozen corpus and
  SQLite's tree fetched and the build's own clang as the oracle.
  - Native: 141 pass, SQLite's shell built by Tier 0 against clang's among
    them, 2 are skipped for a tool the container lacks, 7 fail. Two of the 7
    fail only because an earlier run in the same tree left their report
    files, and pass in a fresh tree. The other 5 fail on main the same way
    in that container (GNU as's, GDB's and perf's versions, the
    preprocessor's line markers against the staged clang, the assembler's
    front ends).
  - `x86-64`: the same, and 2 more that are the run's own (a report file
    left again, and the ownership check asking for the build's own path).
  - Under the sanitizers (`x86-64` with MemorySanitizer, AddressSanitizer
    and ThreadSanitizer, and the native build with AddressSanitizer for the
    vector path), `test-tier0`, the checker's parts 1 and 4 of 8 (the
    census's test is in 4) and the lanes' test: no failure and no report.
    ThreadSanitizer's `test-tier0` prints some of its lines 141 times, main's
    sections' among them: a child's exit writes the parent's unflushed
    output again. The run's status and counts are right.

## Files

- `scripts/`: `lock.sh`, `queue.sh` and the queues as they ran
  (`queue-*.txt`, `queue.log`); `setup.sh`, `build-label.sh`, `corpora.sh`;
  `compile-all.sh`, `stat.sh`, `objects.sh`, `shapes.sh`, `joins.sh`,
  `census.sh`; `compare.sh`, `compare-small.sh`, `summary.sh`, `backend.sh`,
  `backend-table.sh`, `faults.sh`; `selfbuild.sh`, `qualify.sh`,
  `tests-time.sh`; `tables.sh`; `head.patch`, the pull request's change to
  main's `src` and `tests`, and `first.patch`, the first design's.
- `results/main`, `results/head`: each build's log and executable's hash,
  the compiles' counters (`stat-*.txt`), the objects' totals, shapes, sites
  and joins, a small compile's faults, the backend benchmark's runs, and for
  head the census, the compile comparisons (`compile-*.txt`, `final-1.txt`,
  `small-*.txt`), the self-built ones (`selfbuilt-*.txt`), the self-builds'
  logs, the qualification and the tests' times.
