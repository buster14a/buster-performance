Part of #2524, under [the claim for the tests in the machine's own form](https://github.com/buster14a/buster/issues/2524#issuecomment-6909545335).

## What this does

"The tests where they sit" made the verdict of which expressions the node machine may take at reader time, with the census's own code on T's records, at more than the three sweeps' cost. This makes the same bits as the machine would.

- **`measure-node-machine --shadow --front-own-tests`**: one loop reads an expression's records once, in their order, without a branch on what a record is: its operator's bytes in five tables of the unit (by its enabled warnings), its type's byte, its standing, its flags, its token's role. It keeps a byte of what each record is as an operand, gathers the set's tests as bits over all records, and lists three kinds of record (the leaves; a comparison's token, a `!` and an `=`; the operators with tests of their own). Each test is then decided where what it reads is.
- **Exact in place where it can be:** a constant its conversion changes, a division by zero, a shift's count, a null dereferenced, a pointer cast to a narrow integer, a string plus an integer, a comma's discard, a call's aggregates and its callee. For the rest (a comparison's bound, a mix of enumerations, signs compared, a shift of a sum and nine more) the loop only says where none can fire, and the census's code decides on that record alone.
- **No walk of the graph** unless a record's parent is read (a shift of a sum, a product, a subscript) or two writes may be unsequenced.
- **With `--verify` the census's code runs beside it** on every expression: a bit, a span of tokens or a count of nodes that differs fails the command.
- **`--front-tests-last`** runs either form after C and X in the timed run.

It is the shadow only: no compile takes it.

## What it touches

- **`c_check_node_census.c`:** the own form (`node_tests_expression` and the functions it calls, `node_tests_tables`), a word a type for the integers' widths, the reader-time driver's choice of form and its comparison, the report's lines and the two options.
- **`c_check_node_machine_reader.c`:** the tests before or after C and X.
- **`c_check_node_machine_front.c`:** three more bits of `PPOptions.node_reader`, and the counts.
- **`c_check_node_census_test.c`:** the six fixtures in both forms.

## Results on the 9700X

Release builds, CPU 2, under the lock, a hold a run. Build `o8` is this change at main `be6515fba` but for one line of a usage comment; the measurements were not repeated on main `3d0d56ed7`, where the series now sits.

TSC ticks a record T typed at reader time (medians of seven readings in turn, musl's of three):

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| T, C and X | 135.1 | 158.1 | 265.3 |
| with the census's code between T and C | 308.6 | 344.2 | 513.3 |
| with the own form | 225.1 | 276.9 | 422.6 |
| the census's code alone (the difference) | 173.5 | 186.1 | 248.0 |
| the own form alone | 90.0 | 118.8 | 157.3 |

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| records the loop lists: leaves | 45.6% | 44.5% | 48.7% |
| at a comparison's token, a `!` or an `=` | 9.6% | 6.4% | 8.0% |
| operators with tests of their own | 16.8% | 21.7% | 16.2% |
| records sent to the census's code | 0.31% | 1.18% | 0.81% |
| expressions walked for it | 2.1% | 4.1% | 3.0% |
| with `-Wall -Wextra`: records sent | 5.2% | 3.9% | 4.7% |
| expressions whose bits are not the census's code's, either way | 0 | 0 | 0 |

- **Exact:** no bit, span or count differs, on the three corpora with the default warnings and with every warning, and on the six fixtures.
- **Half the cost, not a tenth:** about 62 cycles a body token on `sqlite3.c`. Step 2's sum is 1.19 with it, where 1.13 stood: under the gate of 1.2 still. The aim was 30 ticks.
- **No part dominates** (`sqlite3.c`): the loop 27.0, the operators' tests 27.1, the leaves' 14.7, the expression's own 6.2, the tree's 5.3, 8.9 around it.
- **The loop is not its lookups:** 23.6 of its 27.0 ticks are contiguous columns, five tables by operator and five stores a record, which 64 records a vector step would make. That form is not built.
- **Three things are not a pass's to do:** a leaf's declaration's bit belongs in the leaf's record (buster#2850's fact word), a constant operand's tests in the row that typed the operator, and the loop reads again what T just had in registers.

With buster#2871's head merged in (two hunks of `c_check_node_census.c`, both sides kept), both sides' tests pass and the operators' kernel retires the same instructions and reads within 2% (38.26 and 38.00 cycles an evaluated node on `sqlite3.c`).

## Tests

- **`test-checker --seed 133`,** the eight parts: 842,455 checks, 0 failures on the base it was measured on (main `be6515fba` with #2867's head); on main `3d0d56ed7` see the series' README.
- **New in `test-checker`:** the census's six fixtures run in both forms (`node_tests_test_fixture`), the own form with the census's code beside it, whose bits, spans and counts must be its.
- **The census's own reports** are the same before and after on twelve inputs.
- **Faults:** of 98 put into the own form one at a time, the tests show 63 and the three corpora 5 more. The other 30 show on no input: a line of C shows each of 19 of them at once (fixture lines the census's fixtures don't have yet), and 11 are not sorted into lines owed and conditions another repeats. **Owed before this merges.**
- **Part 5 on the `BUSTER_HOST_ARCH=x86-64` build** (with the flat front's commit on top): 210,274 checks, 0 failures. The compiler parses and checks itself; `check-call-graph` finds 0 cycles.

## Docs

`docs/node-machine.md` has a new section, "The tests in the machine's own form". `docs/commands/lowering.md` has the options, the comparison, the report and the tests.

## Record

[buster-performance, `docs/measurements/node-machine-own-tests-2524-2026-11-16`](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/node-machine-own-tests-2524-2026-11-16): the runs, scripts, patches of each build, the parts, the faults and the tables.

---
This description was written by the session that made the change and handed it off; whoever opens the pull request adds their own session's attribution below it.

Agent session: [private session](https://claude.ai/code/session_01NNmNQtUTU2NzKNtCgdUaJP)
Model: Anthropic / claude-fable-5-2
