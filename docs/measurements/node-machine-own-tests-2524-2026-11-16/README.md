# The tests in the machine's own form: the census's tests from T's records (buster#2524), 2026-11-16

[buster#2524](https://github.com/buster14a/buster/issues/2524)'s step 2 puts the node machine in the reader.
[The tests where they sit](../node-machine-reader-tests-2524-2026-11-16) made the verdict of which expressions it may
take at reader time with the census's own code, at more than the three sweeps' cost, and ended on "the machine needs
the same tests in its own form, with this code as their oracle". This record is that form:
`measure-node-machine --shadow --front-own-tests` makes the same bits from T's records in their order, with no walk of
the graph and no step from a node to its record, and with `--verify` the census's code runs beside it on every
expression. The design's section is "The tests in the machine's own form" in `docs/node-machine.md`;
[the claim](https://github.com/buster14a/buster/issues/2524#issuecomment-6909545335) is on the issue.

**This record is also the hand-off of the session's unmerged work on buster#2524** (section 9 and
[`patches/handoff`](patches/handoff)): four commits that exist in no branch of buster, as a series that applies in
order on main `3d0d56ed7`.

Host: the Ryzen 7 9700X (`benchpress`), under its lock, a hold a run; Release builds; `taskset -c 2`; TSC ticks at
3,792.9 MHz. A build `oN` is main `be6515fba` with `patches/oN.patch` (the working tree's `src` and `tools` at that
step). Build `o8` is the commit's sources but for one line of a usage comment.

## Findings

1. **Exact.** No expression's bits, span of tokens or count of nodes differ from the census's code's: on `sqlite3.c`,
   Lua and musl, with the default warnings and with `-Wall -Wextra`, in every build's runs here, and on the census's
   six fixtures. The census's code on the view is itself checked against the census after the pipeline in the same
   runs (no expression taken there that the census refuses, no bit that differs).
2. **Half the census's code's cost, not a tenth.** The own form is 90.0 TSC ticks a typed record on `sqlite3.c`,
   118.8 on Lua and 157.3 on musl, where the census's code is 173.5, 186.1 and 248.0 in the same build, and T, C and X
   together 135.1, 158.1 and 265.3. That is about 62 cycles a body token on `sqlite3.c`: step 2's sum is 1.19 with it
   (1.13 with the census's code, 1.25 with no tests), a hair under the step's gate of 1.2. The aim was 30 ticks.
3. **The cost is instructions, not misses.** The first build sent 1.8% of the records to the census's code and still
   cost two thirds of it: the whole process retires 470 instructions a record's visit for it where the census's code
   retires 776, and 345 in the last build. Eight builds took 114.3 ticks to 90.0 by cutting what each part reads; no
   part is a tenth of the rest.
4. **No part dominates.** Of the 90 ticks on `sqlite3.c`: the loop over the records 27.0, the operators' tests 27.1
   (the calls 6.6, a constant operand's 9.5, the census's code and its walks 4.5, the rest 1.8), the leaves' 14.7,
   the expression's own 6.2, the tree's 5.3, and 8.9 around it (the root's kind, the pragmas' bodies, the events).
5. **The loop is not its lookups.** Of its 27.0 ticks, the three lookups by an index (a record's type's byte, its
   token's role, its operands' bytes) are 3.4 together. The other 23.6 are contiguous columns read once, five tables by
   operator and five stores a record: the part that 64 records a vector step would make (a table is one byte permute
   of two registers, a list a compressed store). That form is not built.
6. **Three things are not a pass's to do.** A leaf's two bytes are its declaration's and its object's (14.7 ticks):
   buster#2850's fact word has the declaration in hand when it makes the leaf, and a bit there is free. A constant
   operand's tests read its conversion's type, which the row that typed the operator chose (9.5 ticks). And the loop
   reads again what T had in registers a moment before. The machine's form of these is in the leaf's maker and in T's
   rows, not in a pass after them.
7. **The order doesn't matter.** With the tests after C and X (`--front-tests-last`), on what those take, the whole
   reads 3 to 4 ticks less: the tests refuse 1% of what T takes.
8. **buster#2871's operators' kernel is not moved** by this series: merged with that pull request's head it builds and
   passes both sides' tests, and the kernel retires the same instructions and reads within 2% in cycles an evaluated
   node (section 7).
9. **The fixtures owe lines.** Of 98 faults put into the own form one at a time, the tests show 63 and the three
   corpora 5 more. The other 30 show on no input here, and a line of C shows each of 19 of them at once: fixture
   lines not yet written (section 6).

`scripts/tables.py` prints every table below from the result files (`results/tables.txt` is its output).

## 1. The form

`node_tests_expression` (`c_check_node_census.c`) reads an expression's records once, in their order, in one loop
without a branch on what a record is: its operator's bytes in five tables of the unit (made once a unit from its
enabled warnings, `node_tests_tables`), its type's byte (a cache of a byte a type), its standing, its flags and its
token's role in the parser's tree. The loop keeps a byte of what each record is as an operand (a constant, an
enumeration's, a pointer, a pointer to void, an array, a sum, a comparison, a truth), gathers the set's tests as bits
over all records, and writes three lists: the leaves, the records at a comparison's token, a `!` or an `=`, and the
operators with tests of their own. Each test is then decided where what it reads is:

| the tests | decided | by |
| --- | --- | --- |
| an operator outside the set, a special type, a bit-field, an aggregate copied, a packed member's address, a floating-point pragma's region | in the loop, over all records | the operator's class, the type's byte, the flags |
| a compound literal, a declaration the tables don't model | at each leaf | the object's bits and the name's declaration's byte |
| a comparison under a bitwise operator or as a statement, a `!` under a comparison, an assignment as a condition | at a comparison's token, a `!` and an `=` | the parser's tree |
| a call's aggregates and its callee's own semantics | at each call | the arguments' bytes, the callee's type's word, its declaration's byte |
| a constant its conversion changes, a division by zero, a shift's count, a null dereferenced, a zero that is no literal made a pointer | at an operator with a constant operand, exact in place | the constant's value in T's columns, the types' widths |
| a pointer cast to a narrow integer, a string plus an integer, a comma's discard | at the operator, exact in place | its operands' bytes |
| a comparison's bound, a mix of enumerations, signs compared, a void dereferenced, a sizeof's operand, a shift of a sum, a chained comparison, a shift or a product read as a truth, a name assigned to itself, an atomic record's member, a subscript at its array's end or past it, a constant the columns don't hold whole | by the census's code, on that record alone | a condition each of them needs, from the operator's bytes and its operands' |
| a statement's discard, a for statement's clause, an initializer's constant, a returned local's address, T's actions' warnings | once an expression | the root, and the loop's bits |
| two writes not apart from a sequence point | by the census's code after its walk | two writes in the expression, or one below its top |

The loop's own conditions are never a silence test's verdict but where the test is exact in place: elsewhere they only
say where none can fire, and the census's code decides. The census's walk of the graph is made only for an expression
that needs a record's parent (a shift of a sum, a product, a subscript) or the unsequenced test.

The oracle is a chain: the census after the pipeline; the census's code on T's records at reader time
(`--front-tests`, the previous record), compared with it root by root; and the own form (`--front-own-tests`), compared
with the census's code on every expression where `--verify` is given (`BUSTER_NODE_READER_BOTH`).

## 2. Exact

Section 4 of `results/tables.txt` has one run a corpus of build `o8` with the default warnings, the same with
`--verify`, and with `--verify -Wall -Wextra`: differences 0, walks of another count 0, status 0, in all nine. Every
earlier build's two `--verify` runs a corpus are in its directory, with the same zeros
(`types-verifyown-*`, `types-wallown-*`). A run's status is 0 only if, besides, no expression reader time takes is one
the census refuses after the pipeline and no bit of the census's code on the view differs from the census's.

In the cloud, on the commit: `test-checker --seed 133`, 842,455 checks in eight parts, 0 failures, where the census's
six fixtures run in both forms (`node_tests_test_fixture`), the own form with the census's code beside it; the census's
own report on twelve inputs is the same as before the change (`scripts/census-run.sh` of the previous record).

## 3. Ticks a typed record, by build

Medians of seven readings in turn (musl's of three), TSC ticks a record T typed at reader time; "sweeps" is T, C and X,
"tests" the same with the census's code between T and C, "own" with the own form there.

| build | what changed | `sqlite3.c`: sweeps | tests | own | own less sweeps | Lua: own less sweeps | musl: own less sweeps |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `o1` | one pass with a branch a test, the census's code where a condition asks | 136.0 | 308.0 | 250.3 | 114.3 | 143.6 | 210.0 |
| `o2` | the loop by tables, without a branch, and three lists | 133.5 | 308.6 | 271.2 | 137.7 | 167.1 | 214.4 |
| `o3` | the operators' and the leaves' tests leaner | 136.7 | 311.3 | 257.2 | 120.5 | 155.5 | 199.4 |
| `o4` | the expression's own tests leaner | 135.4 | 309.6 | 250.3 | 114.9 | 145.9 | 195.5 |
| `o5` | a constant operand is a number or a null address; a constant alone goes straight to its tests; a callee by a bit of its type's word; a leaf by its object's last answer | 134.8 | 312.6 | 244.7 | 109.9 | 135.3 | 172.7 |
| `o6` | the leaf's two bytes again, without the object's answer | 137.2 | 312.2 | 239.3 | 102.1 | 136.6 | 180.4 |
| `o7` | the constants' tests exact in place; the walk only where a parent is read | 134.8 | 329.9 | 229.4 | 94.6 | 127.7 | 183.7 |
| `o8` | a declaration's three facts each made when first asked | 135.1 | 308.6 | 225.1 | 90.0 | 118.8 | 157.3 |

- `o2` is slower than `o1`: the loop's tables took the branches away and listed a third of the records as operators
  with tests of their own, an address constant counting as a constant operand until `o5` (counted in the cloud; the
  report's line for the lists is from `o5` on). The lists paid once few records were on them.
- `o5`'s answer kept by object (eight bytes an object) made the leaves slower, not faster (27.3 ticks against 18.0
  and 20.3 in the builds beside it, by the parts' knob: section 4); `o6` took it out.
- `o3` has the two orders: the tests after C and X read 307.3 and 254.5 on `sqlite3.c` against 311.3 and 257.2
  between T and C (`testslast`, `ownlast`).
- `o7`'s "tests" row read 20 ticks more than every other build's with the same census code: its code's place in that
  build, not a change (the census's functions are the same text).

## 4. The parts

Build `o8x` is `o8` with a knob (`BUSTER_NODE_TESTS_SKIP`, `scripts/skip-knobs.py`) that switches parts of the own
form off; a run with a part off refuses other expressions, so its status is not 0 and only its ticks are read. The
knob's own tests cost 2 ticks (227.2 with nothing off against `o8`'s 225.1), and the parts overlap by a few.

| | `sqlite3.c` | Lua |
| --- | ---: | ---: |
| the loop over the records | 27.0 | 33.8 |
| the operators' tests | 27.1 | 43.1 |
| of them the calls | 6.6 | 11.3 |
| a constant operand alone | 9.5 | 12.3 |
| the other operators | 1.8 | 7.5 |
| the census's code on a record, and its walks | 4.5 | 14.0 |
| the leaves' tests | 14.7 | 15.5 |
| the expression's own tests | 6.2 | 9.4 |
| the tree's tests | 5.3 | 3.7 |
| around it (everything off, less the sweeps) | 8.9 | 13.2 |

The same knob in four builds, `sqlite3.c`:

| build | the leaves' tests | the operators' | the tree's | the expression's own | the loop |
| --- | ---: | ---: | ---: | ---: | ---: |
| `o4x` | 18.0 | 48.5 | 5.2 | 5.0 | 27.7 |
| `o5x` | 27.3 | 33.9 | 4.1 | 4.8 | 28.3 |
| `o6x` | 20.3 | 35.4 | 5.1 | 6.4 | 28.9 |
| `o8x` | 14.7 | 27.1 | 5.3 | 6.2 | 27.0 |

Lua's operators cost more for its enumerations' mixes and its shifts of sums, which go to the census's code (1.18% of
its records against 0.31% of `sqlite3.c`'s).

## 5. The loop's lookups

Build `o8y` adds three bits to the knob: the type's byte not looked up, the token's role not looked up, the operands'
bytes not looked up. With the four lists off, the loop alone remains.

| | `sqlite3.c` | Lua |
| --- | ---: | ---: |
| the loop | 27.0 | 33.9 |
| less a record's type's byte | 2.1 | 3.6 |
| less its token's role | 0.9 | 0.1 |
| less its operands' bytes | 1.5 | 1.5 |
| less all three | 3.4 | 4.0 |
| the loop without them | 23.6 | 29.9 |

What the loop lists and sends (build `o8`, the default warnings; `-Wall -Wextra` in the last rows):

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| records the loop lists: leaves | 45.6% | 44.5% | 48.7% |
| at a comparison's token, a `!` or an `=` | 9.6% | 6.4% | 8.0% |
| operators with tests of their own | 16.8% | 21.7% | 16.2% |
| records sent to the census's code | 0.31% | 1.18% | 0.81% |
| expressions walked for it | 2.1% | 4.1% | 3.0% |
| with `-Wall -Wextra`: operators with tests of their own | 21.6% | 25.1% | 20.5% |
| with `-Wall -Wextra`: records sent (signs compared and a name assigned most) | 5.2% | 3.9% | 4.7% |

`results/9700x/o1` and `o7` have the profiles by symbol and by line and the instructions of the function that holds
the pass with their samples (`op-*`, `oa-*`, `oi-*`), and `os-*` the whole process's counters: for `sqlite3.c`, 3,137 M
instructions with the sweeps alone, 3,590 M with the census's code and 3,411 M with the own form in `o1`, 3,339 M in
`o8`, over 584,114 visits of a typed record (the reader runs its two passes).

## 6. Faults

`scripts/faults/knobs.py` puts 98 single faults into the own form (its tables, its loop, each list's tests, the
constants' and the conversions' tests, the expression's own), each chosen at run time by `BUSTER_NODE_TESTS_FAULT=N` in
one build. A fault makes the own form miss or misplace one condition; the fixtures and the census's code beside it
should show it.

| | faults |
| --- | ---: |
| shown by `test-checker --seed 133 --part 5/8` (the six fixtures in both forms) | 63 |
| not by the tests, but on `sqlite3.c` or Lua with `-Wall -Wextra` | 3 |
| not there, but on musl | 2 |
| on no input here | 30 |

The first round (`faults/run.sh`, `results/cloud/faults/mutations.txt`) ran the tests and the two corpora with every
warning. The second (`faults/run2.sh`, `mutations2.txt`) ran the 32 it showed nowhere on `sqlite3.c` and Lua with the
default warnings (with every warning each comparison goes to the census's code whatever its other conditions say) and
on musl with both sets.

The 30 are not dead conditions. A line of C written for each shows 19 of them at once (`faults/probe.sh`,
`faults/probe/*.c`, `results/cloud/faults/probes.txt`): a comparison under a bitwise operator, an assignment as a
condition, a chained comparison, a mix of enumerations, a shift by too large a count or of a negative constant, a
floating constant made an integer, a constant outside its operand's type (an unsigned one, one of 8 bits, a narrower
one), a returned local array, a write and a read not apart from a sequence point. The corpora are clean of these, so
only a fixture can hold them, and the census's six fixtures don't: **these are fixture lines owed.** The lines tried
for the other 11 (faults 1, 10, 11, 34, 36, 38, 39, 43, 49, 56 and 97) show nothing. Some of those conditions repeat
another's (T refuses an operator outside the set before the tests run; a conditional with a constant arm is listed for
its constant already); they are not sorted into lines owed and conditions to take out.

That is the first thing owed before the own form's pull request: the 19 lines in a fixture, with their counts, and the
11 sorted.

## 7. With buster#2871's kernel

The session for [buster#2850](https://github.com/buster14a/buster/issues/2850) had the operators' kernel open as
buster#2871 (head `ce247c7db`, on main `be6515fba`; merged since). Build `p1` is that head; `p2` is `p1` merged with this series
as it stood at build `o7` (two hunks of `c_check_node_census.c` resolved, both sides kept: section 9). The fact words'
harness by both, six runs each in turn (`scripts/job54.sh`; `p1` is `git diff be6515fba ce247c7db -- src tools`,
not copied here, and `patches/p2.patch` the merged tree), cycles an evaluated node:

| | `p1`: whole records | `p2` | `p1`: lean records | `p2` |
| --- | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 38.26 | 38.00 | 31.91 | 32.17 |
| Lua | 41.12 | 41.43 | 36.46 | 37.16 |
| musl | 33.37 | 32.88 | 28.97 | 29.01 |

The same instructions a node (117.75, 178.97 and 145.98 whole; 98.02, 159.54 and 128.31 lean) and the same taken
shares (97.97%, 91.82% and 95.34%). Lua's lean rows are 1.9% apart and their runs don't overlap; the others are within
0.8%, on both sides of zero. In the merged build in the cloud, `test-checker --seed 133 --part 5/8` passes (210,303
checks), `--facts --facts-operators` has no difference on `sqlite3.c` and Lua, and neither has
`--front-own-tests --verify`.

## 8. Checks

All in the cloud container (Develop builds; `results/cloud`), on two bases:

- **On the commit as measured** (main `be6515fba` with buster#2867's head, before buster#2871 was merged):
  `test-checker --seed 133`, eight parts, 842,455 checks, 0 failures.
- **On main `3d0d56ed7`** (with buster#2867, buster#2871 and buster#2865), after the series' third commit:
  `test-checker --seed 133`, eight parts, 842,465 checks, 0 failures; the own form beside the census's code on the
  three corpora with both sets of warnings, 0 differences in the six runs; buster#2871's `--facts --facts-operators`
  on the three, 0 differences and that pull request's taken shares.
- **On main `3d0d56ed7`, after the fourth** (the series' last tree): `test-checker --seed 133`, eight parts, 842,472
  checks, 0 failures; part 5 on the `BUSTER_HOST_ARCH=x86-64` build (CI's baseline row), 210,274 checks, 0 failures;
  the flat front against the lean front, the own form beside the census's code with every warning, both in one run,
  and `--facts --facts-operators`, on `sqlite3.c` and Lua, 0 differences in each; the compiler checks and parses its
  own source; `./build.sh check-call-graph --config Release` finds 0 cycles.
- **Part 7 needs a quiet machine here.** Run beside other builds it lost one check, twice
  (`after-0003-tests-7.log`, `-7b.log`): the harness gives a command 60 seconds, and clang's own build of the wide
  vectors' oracle takes 54 on this container's four cores. By hand that program agrees with its oracle; alone the
  part passes on both trees and on main itself.
- Not run: CI, the sanitizer rows and the 9700X's qualification jobs, which a pull request runs. The 9700X's
  measurements are of the first base and were not repeated on the second, where the series' changes are the same but
  for the hunks that meet buster#2871's (section 9).

## 9. The hand-off: what is in no branch

Pull request buster#2867 ("T where it sits") was merged on 2026-11-16 at 08:35 UTC, after buster#2871 (the operators'
kernel, buster#2850's session). Four commits made after it are in no branch of buster: the session's one branch was
that pull request's, and the owner asked for a hand-off with nothing more opened. They are in
[`patches/handoff`](patches/handoff) as a series from `git format-patch` on main `3d0d56ed7`, each with its message
and the sign-off it was made with:

| patch | what | its record |
| --- | --- | --- |
| `0001` | C and X where they sit (`--front-sweeps`) | [reader-sweeps](../node-machine-reader-sweeps-2524-2026-11-16) |
| `0002` | the tests where they sit (`--front-tests`) | [reader-tests](../node-machine-reader-tests-2524-2026-11-16) |
| `0003` | the tests in the machine's own form (`--front-own-tests`) | this one |
| `0004` | the front by passes, without a stack (`--front-flat`) | [flat-front](../node-machine-flat-front-2524-2026-11-15) |

`patches/handoff/README.md` has the commands and what was run on each tree. Each of the first three is a pull
request's worth on its own, in that order; the fourth is independent of them in what it does and was re-picked last
(`scripts/resolve-flat-front.py` is how its ten hunks were resolved, both sides kept in each). The series was made on
buster#2867's head and re-picked on main after buster#2871 came in: the two commits that change
`c_check_node_census.c` each met a hunk or two of that pull request's there (the usage comment's options, and the line
where the command checks its options), resolved with both sides kept (`scripts/resolve-on-main.py`).

## Files

- `scripts/`: the 9700X jobs (`job43.sh` to `job57.sh`; the header comments of `job53.sh` and `job56.sh` repeat
  `job52.sh`'s and name the wrong build: they ran `o6` and `o8`), the runners they call (`types-o2.sh`,
  `types-musl-o.sh`, `skips.sh`, `skips-p.sh`, `facts.sh`, `own-*.sh`, `build-label.sh`, `lock.sh`), the knobs
  (`skip-knobs.py`, `faults/knobs.py`), the fault campaign (`faults/run.sh`), the cloud's corpus runner
  (`shapes-local.sh`), `tables.py`, `resolve-flat-front.py` and `resolve-on-main.py`.
- `results/9700x/LABEL/`: every run's output, the build's log, its compiler's checksum and its symbols.
  `results/cloud/`: the fault campaign's lines and the series' last tree's runs.
- `patches/`: each build's patch against main `be6515fba`; `handoff/`, the series.
