# buster#2524's tests in the machine's own form, on today's main: the fixture lines owed and the conditions sorted (2026-11-16)

The third commit of [the hand-off series](../node-machine-own-tests-2524-2026-11-16/patches/handoff) (`0003`, the
census's tests in the machine's own form, `--front-own-tests`) on main `1c6cc8ab5` with pull request
[buster#2887](https://github.com/buster14a/buster/pull/2887)'s commits, under
[the claim on buster#2524](https://github.com/buster14a/buster/issues/2524#issuecomment-6919991971), with what the
hand-off said it owed before it could be a pull request: the fixture lines its fault campaign asked for, and its 11
unsorted faults sorted. It is all the node machine's shadow (`measure-node-machine --shadow`): no compile takes any
of it.

**State: this record is being filled.** The sorting, the fixtures and the campaign are here. The 9700X's runs
(`scripts/job3.sh`) and the sanitizer rows (`scripts/sanitizers.sh`) were running when this was first pushed; the
pull request waits for buster#2887 to merge, since the session has one branch.

## 1. What the hand-off owed

[Its record](../node-machine-own-tests-2524-2026-11-16), section 6: of 98 faults put into the own form one at a
time, the tests showed 63 and the three corpora 5 more; 30 showed on no input. A line of C showed 19 of those 30;
the other 11 (faults 1, 10, 11, 34, 36, 38, 39, 43, 49, 56 and 97) were not sorted into lines owed and conditions
another repeats.

## 2. The 11, sorted

Each by reading what decides before the own form runs (it runs on an expression the front made whole and T took) and
by a line of C (`scripts/faults/probe`, run by `scripts/faults/probe.sh` on a build with the hand-off's knobs).

| fault | its condition | sorted as | why |
| ---: | --- | --- | --- |
| 1 | an operator outside the set has no class | **a line owed** | the front makes `__extension__` a selection (`CHECK_OP_SELECT`), which T takes and the census's set doesn't have: `g1b.c` shows it. The hand-off's line had a builtin beside it, which T refuses first |
| 10 | a conditional's third operand is not read | **a line owed** | `float x = a ? f : 16777217;` (`g10.c`): the third operand alone is a constant. The hand-off's line had a constant second operand, which lists the conditional already |
| 43 | a comparison as a statement passes | **a line owed** | `a == i++;` (`g43.c`): the operand writes, so the statement's own discard test says nothing and the comparison's does. In `a == b;` the two say the same |
| 11, 56 | a sizeof and an `_Alignof` have no tests of their own; a sizeof's operand is not sent | taken out | the front leaves both to the walk (their tokens' class has no case in it), so no record is one (`g11.c`: the tests run on none of its sizeof expressions) |
| 34 | a floating-point pragma's region is not read | taken out | T refuses a record with the same bits first (its context refusal) |
| 36 | a leaf's object's bits are not read | taken out | the bits said two things. A register object: the leaf's flags say it, from the same declaration (`g38.c`: 36 and 38 hid each other). A compound literal: the front leaves it to the walk (`g36.c`) |
| 39 | a wide leaf is not the census's code's | taken out | that code adds an overload set's test, and T refuses an overload set's leaf first; a wide leaf's flags are in its columns as any leaf's |
| 49 | a callee without a prototype passes | taken out | T's callee refusal asks the same of the same type first |
| 97 | a condition's root that is a shift or a product is not sent | taken out | at reader time a root is a condition's only where it is the `CHECK_OP_CONDITION` wrapper, whose own send takes its operand (`g97.c`) |
| 38 | a leaf's register flag is not read | made the leaf's first branch | it could not fire where it stood: the census's code's own register test comes before it asks a declaration's attributes, so those are never known for a register object and its leaf always went to that code (`g38b.c`: a second use too). The fault is now "a register object's leaf passes" |

So 3 lines owed, 7 conditions taken out, and 1 moved to where it can fire.

**The 5 faults that only the corpora showed** (47 a call's aggregate argument, 73 a shift's count up to 64, 79 a
subscript at its array's end, 80 a comparison with a constant never asked, 88 a for statement's clause) had no
fixture line either. They have one now.

## 3. The fixtures

- **A seventh fixture, `node_census_test_defaults`** (`scripts/faults/probe/defaults.c` is its text): what warns
  without an option, read with the default warnings alone. 33 expressions, 28 refused at reader time, 5
  declarations' discards. With `-Wall -Wextra` a comparison and a constant's shift go to the census's code whatever
  their operands are, which hid the own form's other conditions on them: that is why six fixtures read with every
  warning could not show these faults.
- **A `for` statement in the first fixture** (its clauses and its body under `-Wfor-loop-analysis`): 40 expressions
  refused there at reader time, where 36 were.
- **A callee without a prototype in the set's fixture**, so that the fixtures have a line for each condition taken
  out that could come back.

## 4. The campaign after it

`scripts/faults/knobs.py` (the hand-off's, with the 7 taken out kept as numbered placeholders and 37 and 38 written
for the new leaf loop) puts the faults behind `BUSTER_NODE_TESTS_FAULT=N` in one build; `scripts/faults/campaign.sh`
runs `test-checker --seed 133 --part 5/8` with each. `results/cloud/faults/campaign.txt`:

| | faults |
| --- | ---: |
| put into the own form | 91 |
| that fail `test-checker` | **91** |
| of them, shown by the seventh fixture alone | 26 |
| taken out (placeholders) | 7 |

## 5. Exact, in the cloud container

`scripts/local-checks.sh`, `results/cloud/local-checks.txt`, on the candidate tree (buster#2887's head, `0003`, and
`patches/sorted.patch`; `patches/own.patch` is the whole of it against main `1c6cc8ab5`'s `src`, `tools` and
`tests`):

- **`test-checker --seed 133`**, the eight parts: 842,489 checks, 0 failures.
- **The own form beside the census's code** (`--front-own-tests --verify`), `sqlite3.c`, Lua and the compiler's own
  source, with the default warnings and with `-Wall -Wextra`: 0 expressions whose bits, spans or counts differ, exit
  status 0 in the six runs. Records sent to the census's code: 0.31% and 1.18% (`sqlite3.c`, Lua), as before the
  conditions were taken out.
- **The tests after C and X** (`--front-tests-last`) and the census's code alone (`--front-tests`): the same.

## Files

- `patches`: `sorted.patch` (this work on top of the hand-off's `0003` as re-picked on buster#2887's head) and
  `own.patch` (the 9700X's build).
- `scripts/faults`: the knobs, the campaign, the probes and their lines.
- `scripts`: `job3.sh` and `lock.sh` (the 9700X's; the other scripts are
  [the first pull request's record](../node-machine-handoff-main-2524-2026-11-16/scripts)'s), `local-checks.sh` and
  `sanitizers.sh` (the cloud container's, with its paths as they were).
- `results/cloud`: the campaign's lines and the local checks' results.
