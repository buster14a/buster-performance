Part of #2524, under [the claim for the tests where they sit](https://github.com/buster14a/buster/issues/2524#issuecomment-6907583853).

## What this does

"T where it sits" and "C and X where they sit" ran the node machine's three sweeps at reader time, in the shadow. What decides which expressions the machine may take stayed after the pipeline: the census's set and its silence tests, which read the stream. This runs them at reader time.

- **`measure-node-machine --shadow --front-tests`**: after T takes an expression at reader time and before C and X, the census's own test code runs on T's records. Its bits are the machine's verdict before the pipeline.
- **One code, two views.** The tests read a node's value, its conversions and a member's offset through a view (`node_view_value` and its kin): the stream's after the pipeline, T's record at reader time.
- **The comparison is after the pipeline:** the census's own verdict for the same root, test by test. An expression reader time takes that the census refuses fails the command.
- **A declaration's discard is no root any more.** At a declaration's `;` the walk casts each initializer's value to void, and the front made that cast a root that nothing evaluates. Reader time leaves it alone, by the parser's tree.

| what the tests read | after the pipeline | at reader time |
| --- | --- | --- |
| a node's value, its operands' and arguments' conversions, a member's offset | the stream's | T's record of the node |
| an action's warnings at a node | the stream's, less an unevaluated operand's | T's own actions', for the whole expression |
| the root's kind | the control that pushed it | the front's root's operator; a root inside a statement expression is a nested control's |
| an initializer's object's type | its control's declaration's | the declaration's |
| the unit's enabled warnings | the options and the diagnostic pragmas | the same, whole before the coded walk |
| a body's diagnostic and floating-point pragmas | by the body's braces | by the outermost braces around each pragma |
| the warning events at the expression's tokens | the reader's, the graph run's and the later passes' | the reader's own so far |
| a packed member's address | the reader's witnesses, a later pass's | any address taken in a unit with a packed record or member |
| a body that tracks its stack, a node popped twice | the lowering's | nothing: a splice reads them where it pops the root |

It is the shadow only: no compile takes it.

## What it touches

- **`c_check_node_census.c`:** the tests read through the view; a byte a type and a byte a declaration keep what the tests ask of each; the constants', the tree's and the truth's tests are asked only where a node's operator can fail them; `-Wassign-enum` is read from the unit's policy, not from a flag set after the pipeline. Then the reader-time driver (`node_census_reader_expression`), the comparison (`node_shadow_tested`) and the report. The census's own reports are the same on the three corpora and the fixtures, with the default warnings and with `-Wall -Wextra`.
- **`c_check_node_machine_reader.c`:** the tests between T and C, C and X on the expressions none refuses, and a declaration's discard left alone.
- **`c_check_node_machine.c`, `_type.c`:** T keeps its actions' warnings an expression and a conditional's third operand's conversion. `--verify` counts the nodes a row or a rule typed whose action gives a warning.
- **`c_preprocessor.c`:** `PPOptions.node_reader`, a byte beside `node_front`, whose eight bits are taken.

## Results on the 9700X

Release builds, CPU 2, under the lock, a hold a run. `z3` is this change at main `be6515fba` and `w2` its parent there ("C and X where they sit"). `z3` was built before the last two fixture lines were added: the rest is the same sources.

Counts (the first run of each; every run has the same):

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| expressions the tests ran on at reader time (those T took) | 51,185 | 10,859 | 43,481 |
| compared with the census: popped by the lowering, never popped | 51,122, 63 | 10,846, 13 | 22,518, 20,963 |
| taken there and refused by the census; tests that differ; root kinds that differ | 0; 0; 0 | 0; 0; 0 | 0; 0; 0 |
| refused there by a test; of them, ones C and X take | 567; 4 | 302; 208 | 435; 298 |
| with `-Wall -Wextra`: refused there by a test; of them, ones C and X take | 3,821; 3,256 | 824; 728 | 2,408; 2,243 |
| with `-Wall -Wextra`: taken there and refused by the census; tests that differ | 0; 0 | 0; 0 | 0; 0 |
| `--verify` there: values not the action's; nodes whose action warns | 0; 0 | 0; 0 | 0; 0 |
| declarations' discards left alone | 5,355 | 2,275 | 13,991 |

What the tests cost in place (TSC ticks a record T typed at reader time; medians of seven readings in turn, musl's of three):

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| T, C and X at reader time | 134.3 | 158.5 | 254.1 |
| with the tests between T and C | 299.8 | 338.4 | 528.0 |
| the tests (the difference) | 165.5 | 179.9 | 274.0 |
| the tests as the census had them, before the bytes and the gates | 206.1 | 221.7 | 292.8 |

- **The verdict can be made at reader time, and it is exact there:** in 105 readings of four builds no expression is taken there that the census refuses, and no test's bit differs.
- **The sweeps' own refusals are not enough:** with every warning on, C and X would take 3,256 expressions of `sqlite3.c` that the census refuses (a for statement's clauses under `-Wfor-loop-analysis` most of all).
- **As the census writes them the tests cost more than the three sweeps:** about 115 cycles a body token on `sqlite3.c`, where ten move step 2's sum by a hundredth. In the machine as they are they would take the sum from 1.25 to about 1.13, under its gate of 1.2. The profile has no one hot spot. The machine needs the same tests in its own form (over T's records in order, a case an operator, a byte a declaration), with this code as their oracle: the next piece.

Against the parent:

| | `w2` | this change |
| --- | ---: | ---: |
| `-c sqlite3.c`, wall ms, 21 runs a build from three fresh copies, twice | 122.571; 122.509 | 122.440 (-0.11%); 122.782 (+0.22%) |
| its instructions, M | 1,363.464 | 1,363.464 |
| the shadow's T, C and X after the pipeline, cycles a taken node: `sqlite3.c`; Lua; musl | 174.4; 146.9; 193.3 | 176.3; 148.2; 195.5 |
| their instructions | 597.76; 687.10; 648.63 | 597.61; 687.12; 648.58 |
| buster#2850's fact words, both passes' cycles a record, a body a window: `sqlite3.c`; Lua; musl | 24.09; 19.09; 19.89 | 23.90; 19.07; 19.93 |
| the same, lean | 19.86; 16.68; 17.81 | 19.82; 16.68; 17.80 |
| the same, the loads | 17.04; 14.21; 15.46 | 17.37; 14.34; 15.47 |

- **A compile is unchanged.** The shadow's own sweeps retire the same instructions a node and read 1% more cycles as built, inside what the stack's place moves them (#2869).
- **buster#2850's kernels are not moved.** Their harness's own figure (a pass less a second pass that only puts the given records in place) is 13% to 30% lower on musl in this build (15.71 to 13.64 cycles a taken leaf or lookup with a body a window). That is the second pass, which reads 12.57 cycles a record alone where the parent's reads 11.41, with the same instructions, at each of eight places of the stack. The two passes' sum is the same, and the second pass's difference is inside its own ticks, a constant a unit (#2872).

## Tests

- **`test-checker --seed 133`,** the eight parts: 842,455 checks, 0 failures. Part 5, where the census's tests are, on the `BUSTER_HOST_ARCH=x86-64` build too: 210,262 checks, 0 failures (no front there, and the fixtures check that the tests ran on nothing).
- **New in `test-checker`:** the six census fixtures run with the tests at reader time (`node_tests_test_fixture`): the exact count of expressions a test refuses there and of discards left alone, no expression taken there that the census refuses, no test's bit that differs, and at each silence test's line a record with that test's bit. New fixture lines: a conditional whose third operand's conversion changes a constant, a call's argument whose conversion does, two members of one record assigned in one expression, and a body with a diagnostic pragma.
- **The census's own reports** are the same before and after on `sqlite3.c`, Lua and musl, with the default warnings and with `-Wall -Wextra`, and on the fixtures that gained no line.
- **The compiler parses and checks itself;** `check-call-graph` finds 0 cycles.
- **Faults:** of 26 put into the reader-time path one at a time, the tests show 25 (two needed a fixture line first). The one that shows on no input reads a conditional's third conversion as its second's: both arms convert to the conditional's common type.

## Docs

`docs/node-machine.md` has a new section, "The tests where they sit". `docs/commands/lowering.md` has the option, its comparison, its report and its tests.

## Record

[buster-performance, `docs/measurements/node-machine-reader-tests-2524-2026-11-16`](https://github.com/buster14a/buster-performance/tree/main/docs/measurements/node-machine-reader-tests-2524-2026-11-16): the runs, scripts, patches of each build, the faults and the tables.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

https://claude.ai/code/session_01NNmNQtUTU2NzKNtCgdUaJP

---
Agent session: [private session](https://claude.ai/code/session_01NNmNQtUTU2NzKNtCgdUaJP)
Model: Anthropic / claude-fable-5-2
