# buster#2524's tests in the machine's own form, on today's main: the fixture lines owed and the conditions sorted (2026-11-16)

The third commit of [the hand-off series](../node-machine-own-tests-2524-2026-11-16/patches/handoff) (`0003`, the
census's tests in the machine's own form, `--front-own-tests`) on main `1c6cc8ab5` with pull request
[buster#2887](https://github.com/buster14a/buster/pull/2887)'s commits, under
[the claim on buster#2524](https://github.com/buster14a/buster/issues/2524#issuecomment-6919991971), with what the
hand-off said it owed before it could be a pull request: the fixture lines its fault campaign asked for, and its 11
unsorted faults sorted. It is all the node machine's shadow (`measure-node-machine --shadow`): no compile takes any
of it.

**State: the pull request is opened from buster's branch `claude/exciting-archimedes-agaary` on main `cc1c47d62`**
(buster#2887 merged at 20:19 UTC; that main has buster#2884, buster#2889, buster#2888 and buster#2885 too); its
number is added here when it has one. `patches/sorted.patch` is its second commit, on the hand-off's `0003` as
re-picked.

**Result.** With the lines owed in the fixtures and the 11 sorted, each of the 91 faults that can still be put into
the own form fails `test-checker`. On today's main the form reads what the hand-off read: 86.3, 115.9 and 152.4
ticks a record T typed on `sqlite3.c`, Lua and musl where the census's code is 178.2, 191.5 and 262.5 (section 8;
86.7, 114.6 and 161.1 against 165.3, 177.4 and 266.7 on the main before, section 6), and no expression's bits
differ from that code's, with the default warnings and with every warning. A compile is unchanged.

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
runs `test-checker --seed 133 --part 5/8` with each, on a copy of the final sources with the knobs put in.
`results/cloud/faults/campaign.txt`:

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

## 6. The 9700X, before main moved

Release builds, CPU 2, under the lock, a hold a run (`scripts/job3.sh`; `results/tables.txt` by `scripts/tables.py`).
`head2` is main `1c6cc8ab5` with buster#2887's `src`, `tools` and `tests` (that record's build); `own` is the same
main with `patches/own.patch`.

TSC ticks a record T typed at reader time (medians of seven readings in turn, musl's of three; the ranges are in
`results/tables.txt`):

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| T, C and X, by `head2` in the same turns | 134.2 | 159.1 | 258.5 |
| T, C and X (`--front-sweeps`) | 137.8 | 162.8 | 260.6 |
| with the census's code between T and C (`--front-tests`) | 303.1 | 340.3 | 527.4 |
| with the own form (`--front-own-tests`) | 224.5 | 277.5 | 421.7 |
| the census's code alone (the difference) | 165.3 | 177.4 | 266.7 |
| the own form alone | 86.7 | 114.6 | 161.1 |
| the own form after C and X (`--front-tests-last`), one reading, the whole | 220.3 | 279.3 | 421.1 |
| the hand-off's, at main `be6515fba`: the census's code alone; the own form alone | 173.5; 90.0 | 186.1; 118.8 | 248.0; 157.3 |

The own form beside the census's code (`--front-own-tests --verify`), one reading a corpus and a set of warnings:

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| expressions the tests ran on | 51,185 | 10,859 | 43,481 |
| records the loop lists: leaves | 45.56% | 44.51% | 48.65% |
| at a comparison's token, a `!` or an `=` | 9.60% | 6.35% | 7.98% |
| operators with tests of their own | 16.79% | 21.65% | 16.17% |
| records sent to the census's code | 913 (0.31%) | 906 (1.18%) | 1,817 (0.81%) |
| expressions walked for it | 2.09% | 4.13% | 3.01% |
| with `-Wall -Wextra`: records sent | 5.18% | 3.91% | 4.71% |
| expressions whose bits are not the census's code's; walks of another count (either set) | 0; 0 | 0; 0 | 0; 0 |
| taken at reader time and refused by the census; tests that differ (either set) | 0; 0 | 0; 0 | 0; 0 |

These are the hand-off's shares, to the last digit it gave: the conditions taken out sent or listed no record.

`head2` against `own`:

| | `head2` | `own` |
| --- | ---: | ---: |
| `-c sqlite3.c`, instructions | 1,364,582,339 | 1,364,580,484 |
| its wall time, 21 runs a build from three fresh copies, twice | 122.469 ms; 122.425 ms | +0.02%; -0.06% |
| `head2` against itself in the same runs | | -0.13%; -0.21% |
| its user cycles; `head2` against itself | | +0.12%; -0.02%; and -0.03%; -0.14% |
| the shadow's T, C and X after the pipeline, cycles an evaluated node: `sqlite3.c`; Lua; musl | 178.0; 150.9; 135.9 | 178.0; 152.5; 137.1 |
| their instructions | 594.3; 683.7; 645.6 | the same |
| buster#2850's fact words with the operators, the first pass's cycles a record: `sqlite3.c`; musl | 43.34; 39.13 | 43.02; 39.01 |
| their instructions a record | 149.38; 169.89 | the same |

- **A compile is unchanged.**
- **The census's own reports** are `head2`'s line for line on the three corpora, with both sets of warnings.
- **T, C and X read 2 to 4 ticks more in `own`** than in `head2` in the same turns: the reader-time loop has the
  tests' two places around C and X there (`--front-tests-last`). The hand-off's builds differed the same way.

## 7. The sanitizer rows

A pull request's checks don't run them. In the cloud container (4 CPUs), Release builds as CI's rows build them
(`-O3`), on the candidate tree (`scripts/sanitizers.sh`; `results/cloud/sanitizers`): the part of `test-checker`
with the census's tests, and for the memory and address rows the shadow with the own form beside the census's code
(`--verify --front-own-tests`) on `sqlite3.c`, Lua and the compiler's own source. The address row is CI's
`-fsanitize=address,undefined,bounds`.

| row | `test-checker --seed 133 --part 5/8` | the shadow's exit status: `sqlite3.c`; Lua; the compiler's own source | reports |
| --- | --- | --- | --- |
| native, memory | 210,307 checks, 0 failures | 0; 0; 0 | none |
| native, address | 210,307 checks, 0 failures | 0; 0; 0 | none |
| native, thread | 210,307 checks, 0 failures | not run | none |
| `x86-64`, memory | 210,271 checks, 0 failures | 0; 0; 0 | none |
| `x86-64`, address | 210,271 checks, 0 failures | 0; 0; 0 | none |
| `x86-64`, thread | 210,271 checks, 0 failures | not run | none |

The own form runs beside the reader's coded walk, the vector paths', so the native rows are the ones that reach it:
an `x86-64` row's shadow run reads no front.

## 8. The 9700X again, on the main the pull request opened on

Main moved while buster#2887 waited and merged: buster#2884 (Tier 0's fused compare), buster#2889 (a condition's `&&`
and `||` lowered as branches, which the machine leaves to the tasks), buster#2888 and buster#2885 (the executable's
start order and huge pages) came in. So everything was taken again on main `cc1c47d62` (`scripts/job6.sh`;
`results/tables-main-cc1c47d62.txt` by `scripts/tables6.py`). `base6` is that main; `own6` is it with
`patches/own6.patch`, the pull request's two commits' `src`, `tools` and `tests`.

TSC ticks a record T typed at reader time (medians of seven readings in turn, musl's of three):

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| T, C and X, by `base6` in the same turns | 127.0 | 152.6 | 258.5 |
| T, C and X (`--front-sweeps`) | 129.8 | 154.8 | 259.2 |
| with the census's code between T and C (`--front-tests`) | 308.0 | 346.4 | 521.6 |
| with the own form (`--front-own-tests`) | 216.1 | 270.8 | 411.6 |
| the census's code alone (the difference) | 178.2 | 191.5 | 262.5 |
| the own form alone | 86.3 | 115.9 | 152.4 |
| the own form after C and X (`--front-tests-last`), one reading, the whole | 206.3 | 259.2 | 395.0 |

The own form beside the census's code (`--front-own-tests --verify`): every count of section 6's second table is the
same (51,185, 10,859 and 43,481 expressions; 913, 906 and 1,817 records sent; 0 differences with either set of
warnings). What C and X take after the tests is fewer, as buster#2889 says: 48,218, 9,893 and 39,976 expressions
taken there.

`base6` against `own6`:

| | `base6` | `own6` |
| --- | ---: | ---: |
| `-c sqlite3.c`, instructions | 1,361,787,984 | 1,361,787,865 |
| its wall time, 21 runs a build from three fresh copies, twice | 122.188 ms; 121.537 ms | -0.08%; +0.03% |
| `base6` against itself in the same runs | | -0.10%; +0.02% |
| its user cycles; `base6` against itself | | -0.11%; +0.05%; and -0.10%; +0.13% |
| the shadow's T, C and X after the pipeline, cycles an evaluated node: `sqlite3.c`; Lua; musl | 172.2; 147.1; 134.0 | 174.8; 148.9; 135.4 |
| their instructions | 603.6; 688.2; 655.9 | the same |
| buster#2850's fact words with the operators, the first pass's cycles a record: `sqlite3.c`; musl | 43.41; 39.83 | 43.84; 39.33 |
| their instructions a record | 148.53; 170.69 | the same |

- **A compile is unchanged.** The census's own reports are `base6`'s line for line, with both sets of warnings.
- **The shadow's own sweeps retire the same instructions and read 1.0% to 1.5% more cycles in `own6`.** Nothing of
  theirs changed; not traced. Section 6's builds read 0.0%, 1.1% and 0.9% apart the same way.

In the cloud container on the pull request's head (`scripts/local-checks-main-cc1c47d62.sh`,
`results/cloud/local-checks-main-cc1c47d62.txt`): `test-checker --seed 133`, the eight parts, 842,722 checks, 0
failures; the own form beside the census's code on `sqlite3.c`, Lua and the compiler's own source with both sets of
warnings, 0 differences, exit status 0; `check-call-graph` 0 cycles. The sanitizer rows on that head were running
when this was pushed (section 7's are of the tree before main moved).

## Files

- `results/base6`, `results/own6`: section 8's runs, with the same names.
- `results/own`, `results/head2`: section 6's, the 9700X's runs (`sweeps`, `tests`, `own`, `own-last`, `own-verify`,
  `own-verify-wall`: the shadow at reader time; `shadow`: the shadow alone; `facts-operators`: buster#2850's kernel;
  `census`, `census-wall`: the census alone; `compile`: the whole compile's comparison; `head2`'s files of this job
  end in `3`). `results/tables.txt` is their summary, `results/job3.log` the job's.

- `patches`: `sorted.patch` (the pull request's second commit, on the hand-off's `0003` as re-picked on main
  `cc1c47d62`), `own6.patch` and `own.patch` (the 9700X's builds of sections 8 and 6), and the pull request's
  description and its second commit's message (`pull-request-body.md`, `commit-message.txt`).
- `scripts/faults`: the knobs, the campaign, the probes and their lines.
- `scripts`: `job3.sh` and `lock.sh` (the 9700X's; the other scripts are
  [the first pull request's record](../node-machine-handoff-main-2524-2026-11-16/scripts)'s), `local-checks.sh` and
  `sanitizers.sh` (the cloud container's, with its paths as they were).
- `results/cloud`: the campaign's lines, the local checks' results, and `sanitizers`: the rows' progress, each row's
  build log, `test-checker` output and shadow outputs. No row wrote a report.
