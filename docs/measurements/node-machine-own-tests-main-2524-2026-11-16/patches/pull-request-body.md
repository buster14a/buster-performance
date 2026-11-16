Part of #2524, under [the claim](https://github.com/buster14a/buster/issues/2524#issuecomment-6919991971): the third commit of [the hand-off series](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/node-machine-own-tests-2524-2026-11-16/patches/handoff), on today's main, with what the hand-off said it owed before it could be a pull request. #2887 had the first two.

It is all the node machine's shadow: no compile takes any of it.

## The two commits

1. **The tests in the machine's own form (`--front-own-tests`)**, the hand-off's `0003`, re-picked with its author, message and sign-off.
   - **What it is:** "the tests where they sit" (#2887) made the verdict of which expressions the machine may take at reader time with the census's own code, at more than T, C and X cost together. This makes the same bits from one loop over T's records, with the census's code only on the records a silence test may refuse.
   - **Its oracle:** with `--verify` the census's code runs beside it on every expression, and a bit, a span of tokens or a count of nodes that differs fails the command.
   - **Its own description,** written for the older base, is [in the record](https://github.com/buster14a/buster-performance/blob/main/docs/measurements/node-machine-own-tests-2524-2026-11-16/patches/handoff/0003-pull-request-body.md).
2. **The fixture lines it owed, and its conditions sorted.**
   - **What was owed:** of 98 faults put into the own form one at a time, the tests showed 63 and the three corpora 5 more. 30 showed on no input: a line of C showed 19 of them, and 11 were not sorted into lines owed and conditions another repeats.
   - **What this commit does:** the lines are in the fixtures, the 11 are sorted, and **each of the 91 faults that can still be put into the form fails `test-checker`.**

## The 11, sorted

The own form runs where it sits: on an expression the front made whole and T took. So each fault was read against what decides before it, and tried on a line of C.

| fault's condition | sorted as | why |
| --- | --- | --- |
| an operator outside the set has no class | **a line owed** | the front makes `__extension__` a selection, which T takes and the census's set doesn't have |
| a conditional's third operand is not read | **a line owed** | `fl = a ? fl : 16777217;`: the third operand alone is a constant its conversion changes |
| a comparison as a statement passes | **a line owed** | `a == i++;`: the operand writes, so the statement's own discard test says nothing |
| a sizeof and an `_Alignof` have no tests of their own; a sizeof's operand is not sent | taken out (2) | the front leaves both to the walk, so no record is one |
| a floating-point pragma's region is not read | taken out | T refuses a record with the same bits first |
| a leaf's object's bits are not read | taken out | a register object's leaf has its flag from the same declaration, and the front leaves a compound literal to the walk |
| a wide leaf is not the census's code's | taken out | that code adds an overload set's test, and T refuses such a leaf first |
| a callee without a prototype passes | taken out | T's callee refusal asks the same first |
| a condition's root that is a shift or a product is not sent | taken out | a condition's root is its wrapper, whose own send takes its operand |
| a leaf's register flag is not read | now the leaf's first branch | it could not fire where it stood: the census's code never asks a register object's declaration's attributes, so such a leaf always went to that code |

- **3 lines owed, 7 conditions taken out, 1 moved to where it can fire.**
- **Each condition taken out is the census's code's still,** and that code runs beside the form with `--verify`. The fixtures have a line for each that could come back (a pragma's region, a callee without a prototype, a compound literal, `sizeof(x++)`), so the day T takes one or the front makes one, `test-checker` shows what the form lacks.
- **The 5 faults that only the corpora showed** had no fixture line either. They have one now.

## The fixtures

- **A seventh, read with the default warnings alone** (`node_census_test_defaults`): 33 expressions, 28 refused at reader time. With `-Wall -Wextra` a comparison and a constant's shift go to the census's code whatever their operands are, which hid the form's other conditions on them. That is why six fixtures read with every warning could not show these faults.
- **A `for` statement in the first fixture** (its clauses under `-Wfor-loop-analysis`).
- **A callee without a prototype in the set's.**

| the campaign, after | faults |
| --- | ---: |
| put into the own form | 91 |
| that fail `test-checker --seed 133 --part 5/8` | **91** |
| of them, shown by the seventh fixture alone | 26 |

## Results on the 9700X

Release, CPU 2, under the lock, a hold a run. The base is main `1c6cc8ab5` with #2887's sources; the branch adds these two commits' `src`.

TSC ticks a record T typed at reader time (medians of seven readings in turn, musl's of three):

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| T, C and X | 137.8 | 162.8 | 260.6 |
| with the census's code between T and C | 303.1 | 340.3 | 527.4 |
| with the own form | 224.5 | 277.5 | 421.7 |
| the census's code alone (the difference) | 165.3 | 177.4 | 266.7 |
| **the own form alone** | **86.7** | **114.6** | **161.1** |

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| expressions the tests ran on | 51,185 | 10,859 | 43,481 |
| records the loop lists: leaves | 45.6% | 44.5% | 48.7% |
| at a comparison's token, a `!` or an `=` | 9.6% | 6.4% | 8.0% |
| operators with tests of their own | 16.8% | 21.7% | 16.2% |
| records sent to the census's code | 0.31% | 1.18% | 0.81% |
| expressions walked for it | 2.1% | 4.1% | 3.0% |
| with `-Wall -Wextra`: records sent | 5.2% | 3.9% | 4.7% |
| **expressions whose bits are not the census's code's, either set of warnings** | **0** | **0** | **0** |
| taken at reader time and refused by the census, either set | 0 | 0 | 0 |

- **Half the census's code's cost, as the hand-off found:** it read 90.0, 118.8 and 157.3 ticks for the own form alone at its older base. The aim was 30, and its record says where the rest is.
- **Taking the seven conditions out changed no count** of the second table and a few ticks.
- **T, C and X read 2 to 4 ticks more in this build** than in #2887's (134.2, 159.1 and 258.5 there, in the same turns): the reader-time loop now has the tests' two places around C and X. The hand-off saw the same between its builds.

The base against the branch:

| | #2887's head | the branch |
| --- | ---: | ---: |
| `-c sqlite3.c`, instructions, M | 1,364.582 | 1,364.580 |
| its wall time, 21 runs a build from three fresh copies, twice | 122.469 ms; 122.425 ms | +0.02%; -0.06% |
| the base against itself in the same runs | | -0.13%; -0.21% |
| the shadow's T, C and X after the pipeline, cycles an evaluated node: `sqlite3.c`; Lua; musl | 178.0; 150.9; 135.9 | 178.0; 152.5; 137.1 |
| their instructions | 594.3; 683.7; 645.6 | the same |
| #2850's fact words with the operators, the first pass's cycles a record: `sqlite3.c`; musl | 43.34; 39.13 | 43.02; 39.01 |
| their instructions | 149.38; 169.89 | the same |

- **A compile is unchanged.**
- **The census's own reports are the same** on the three corpora, with both sets of warnings.

## Tests

- **`test-checker --seed 133`** in its eight parts, on a native Release build: 842,489 checks, 0 failures.
- **The seven fixtures run in both forms** (`node_tests_test_fixture`), the own form with the census's code beside it.
- **The own form beside the census's code on the compiler's own source too,** with both sets of warnings: no difference, exit status 0.
- **The sanitizer rows,** which a pull request's checks don't run, on Release builds as CI builds them (`-O3`), in the cloud container:
  - native memory, address and thread, the rows that reach the own form: `test-checker`'s part with the census's tests (5 of 8), 210,307 checks, 0 failures in each;
  - `x86-64` memory, address and thread: the same part, 210,271 checks, 0 failures in each;
  - the memory and address rows, on both hosts: the shadow with the own form beside the census's code (`--verify --front-own-tests`) on `sqlite3.c`, Lua and the compiler's own source, exit status 0;
  - no sanitizer reported anything.
- The compiler checks its own source; `check-call-graph` and `test-call-graph` pass; `build/dco audit` finds the commits signed.

## Docs

- `docs/node-machine.md`, "The tests in the machine's own form": the hand-off's section, with a table of what is decided before the form runs, today's ticks, and the faults' result in place of "the fixtures owe lines".
- `docs/commands/lowering.md`: the options, the comparison, the report, the seven fixtures and what the own form doesn't ask.

## Record

[buster-performance `docs/measurements/node-machine-own-tests-main-2524-2026-11-16`](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/node-machine-own-tests-main-2524-2026-11-16) (`63bb17237`): the 11 faults sorted with their probes, the knobs and the campaign, the 9700X's runs and tables, the patches, and the sanitizer rows' outputs.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

https://claude.ai/code/session_01NNmNQw6v1QGm8K1vKsuJgc

---
Agent session: [private session](https://claude.ai/code/session_01NNmNQw6v1QGm8K1vKsuJgc)
Model: Anthropic / claude-fable-5-2

---
_Generated by [Claude Code](https://claude.ai/code)_
