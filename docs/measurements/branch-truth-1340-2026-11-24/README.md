# A bit before a branch condition's fold (#1340, part 2)

buster14a/buster#1340's plan gave the default warnings' cost on `sqlite3.c` three parts. This is the second:
`check_program_branch_truth` (`c_check_program_cfg.c`), clang's CFG builder's `tryEvaluateBool` and its heuristics,
asked for about 17,000 conditions a compile and deciding about a hundred. The change gives every node a bit, "a rule
may decide it", and answers unknown where a condition's bit is clear. The fold stays the one implementation of a
verdict.

- Base: main `188cef80`. Head: `27073b5e` on `claude/branch-truth-1340` (`9700x/head-27073b5e.patch` is its diff).
- Host: the Ryzen 7 9700X, under its lock, CPU 2. Both trees built there as the job builds them
  (`BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --config Release`, `scripts/build-one.sh`).
- The compile: the frozen `sqlite3.c` as `compile-count-2850-2026-11-24`'s `scripts/warn-facts.sh` runs it
  (`--lanes 1 -c`, the four `SQLITE_*` defines).

## The result

Two holds of the final commit (`9700x/ab8`, `9700x/ab9`), each three rounds (forward, reverse, forward) of
`perf stat -r 11` of base, head and base with `-w` (`scripts/ab.sh`). Every run exited 0 and every object is base's.

| | base | head | saved |
| --- | ---: | ---: | ---: |
| task-clock, mean of 6 rounds | 111.98 ms | 111.00 ms | **0.98 ms** |
| user cycles | 546.80 M | 541.31 M | 5.49 M |
| user instructions | 1,266.39 M | 1,253.82 M | 12.57 M |
| mispredicted branches | 3.288 M | 3.243 M | 0.045 M |

By round, head saved 1.15, 0.02, 1.41, 1.06, 1.25 and 0.98 ms (6.7, 1.5, 7.2, 5.7, 7.0 and 4.8 M cycles). In the
two low ones (the second of `ab8`, the third of `ab9`) the head run's spread was 0.26% and 0.24%, where the others'
are 0.05 to 0.10%. The host's load average was 1.1 to 1.8 through both holds, with nothing listed busy on CPU 2
(`before.txt`, `after.txt`).

`-w` is 100.34 ms, so the warnings' cost goes from 11.64 to 10.66 ms.

**The spread between holds is as large as half the effect.** `ab6` and `ab7` are the same code (`head-6.patch`:
only a local variable's name and a comment differ from the commit), 45 minutes earlier, and saved 0.22, 0.49, 0.42,
1.00, 0.77 and 0.40 ms, 0.55 on average; `ab5` (`head-5.patch`: the same pass, fewer fixtures in the test) saved
1.00, 1.27 and 1.06. The instructions saved are the same in all of them, 12.57 M. Over the five holds' 15 rounds the
mean is 0.83 ms and 4.7 M cycles. So the honest reading is 0.5 to 1.1 ms: about 0.8, and 1.0 for the commit's own two
holds.

## What the profile showed

`9700x/prof8/report-base.txt` and `report-head.txt`: cycles of 20 compiles, percent of the compile.

| | base | head |
| --- | ---: | ---: |
| the fold (`check_cfg_try`, `check_program_branch_truth`, `check_program_runtime_truth`, `check_cfg_integer_value`, `check_cfg_fold`, `check_cfg_literal_value`, `type_usual_arithmetic`, `check_cfg_normalize`, `check_cfg_literal_constant`, the rest) | 2.12% (11.6 M cycles) | 0.41% (2.2 M) |
| the pass: `check_program_begin`'s growth (the columns and the masks) | | 0.22% (1.2 M) |
| the pass: `check_cfg_decidable_operators` | | 0.20% (1.1 M) |
| `check_common_body_reached` | 0.45% | 0.38% |

Where a condition's cycles went in base: not in one place. `if (x)` pays `check_cfg_do_condition`'s and
`check_cfg_parenthesized`'s parse-tree lookups (the node's token, its parent, the parent's role), then
`check_program_fold_truth`'s frames; `if (p->n == 0)` also pays `check_cfg_equality`: the two operands' types, the
usual arithmetic conversions, and the literal's value out of a payload row. Each is a few loads from columns that
nothing else has in the cache at that point. The callers ask again (the `-Wreturn-type` walk, the reach, the
uninitialized flow), but by then those lines are warm. A cheaper fold would have had to take each of these out one by
one; the bit takes all of them at once for the conditions it rejects.

## How the pass got to its cost

The first three versions cost more than half of what they saved. Each step below is one build and one hold; the
patches are in `9700x/`.

| version | hold | pass's cycles (profile) | what changed |
| --- | --- | ---: | --- |
| a loop over every operator, asking the constant's value of every `x & C` (its patch wasn't kept) | `ab1`, `prof1` | 2.3 M | |
| the facts from the columns 64 at a time, a table-driven loop for the operators (`head-2.patch`) | `ab2`, `prof2` | 3.3 M | |
| a whole-block store in place of a masked one (`head-3.patch`) | `ab3`, `prof3`, `ann3` | 3.2 M | no change: the loop, not the store |
| the operators' loop a function of its own (`head-4.patch`) | `ab4`, `prof4`, `ann4` | 2.7 M | `ann4/annotate.txt`: about 110 instructions and 37 cycles an operator, 58,607 operators |
| the masks' rounds for an operator whose operands are the one or two nodes before it; a constant with no payload row is 0 (`head-5.patch`) | `ab5`, `prof5`, `ann5` | 2.0 M | the loop falls from 2.2 M to 0.9 M cycles |

In `ab1` to `ab3` the head compiler's first round is slow (113.7 to 113.9 ms, spread 2.2 to 2.5%): the binary had
just been built and its first runs paid for the page cache. `scripts/ab.sh` runs every compiler once before the
rounds since `ab4`. Those three holds' first rounds are not evidence of anything else.

What is left of the pass: the columns it streams (the operators, the two operand columns, the constants, the
categories, the objects, the payload rows and the types: about 7 MB of `sqlite3.c`'s graph) and the operators the
rounds leave. The types' column is read for one fact, whether a value is a `_Bool`, and the objects' for the lvalues'
address constants: both could be read only where a comparison or a condition is near.

## What the bit keeps

`--branch-truth-census` (the PR's test option) asks the fold of every node of a unit every way a condition is, and
counts. `corpora/summary.txt` and `corpora/census.tsv` (a line a unit), by `scripts/corpora.sh`:

| corpus | units | conditions | the bit keeps | the fold decides | unsound |
| --- | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 1 | 16,621 | 522 | 103 | 0 |
| Lua 5.4.8 | 34 | 2,832 | 138 | 34 | 0 |
| c-testsuite's `single-exec` | 220 | 994 | 671 | 669 | 0 |
| musl's units | 1,355 | 39,574 | 19,992 | 19,795 | 0 |

"Conditions" are the CONDITION nodes and the logical operators' and conditionals' first operands; "unsound" is a node
with a clear bit that the fold decided or at which an observer heard an event, over every node of the unit, not only
the conditions (323,557 nodes of `sqlite3.c`, 797,364 of musl). musl's and the test suite's conditions are mostly
constants, which the bit keeps and the fold decides.

## Objects and diagnostics

`scripts/corpora.sh` also compiles every unit with base and with head, from one directory, with the default warnings
and with `-Wall -Wextra -Wunreachable-code -Wreturn-type -Wuninitialized -Wtautological-compare`, and compares the
objects and stderr: 1,610 units twice, no difference (`corpora/summary.txt`). Run in the session's container (the
compilers' Release builds for its host), not on the 9700X.

`corpora/ubsan.txt`: the same census and the checker's tests by a `BUSTER_SANITIZER=undefined` build, with no report.

## The fault round

`scripts/mutants.py` adds a switch to `c_check_program_cfg.c` (not for merge) that breaks one rule of the bit at a
time; `scripts/fault-round.sh` runs `test-checker-driver --branch-truth-only` under each. `fault-round/fault-round.txt`:
of 72 mutants, 67 fail a test. The five that pass:

- **17** (the rounds' logical operator ignores two compared operands) and **50** (`+`, `-`, `~` and `!` lose the
  literal fact): neither changes a bit. A logical operator whose operands are the two nodes before it has no
  comparison for an operand, since a comparison is three nodes; and a `+`, `-`, `~` or `!` of an integer literal is
  itself an integer constant, which has the fact already. Both tests stay, for a graph that isn't a tree and for a
  checker that folds less.
- **53**, **60** and **66** (a `*` or `&` of an integer constant that has a payload row is taken not to decide,
  without its value being asked): these need an integer constant 0 with a payload row, which a node written twice can
  be (`check_stream_set_value_flags` keeps a node's row) and which no source I wrote produces: an enumerator, a
  character, `0u`, `0ll`, `!1`, `-0`, `(0)`, `1 - 1`, `(0, 0)`, `sizeof(struct {})`, `__builtin_offsetof`, a
  conditional and a cast of 0 all have none. The exact test (`check_cfg_decidable_zero`) stays, untested by a
  fixture; the census over the corpora found no such node unsound.

## Files

- `9700x/abN/`: a hold's `perf stat` CSVs (`stat-NAME-ROUND.csv`), each run's stderr and status, the host's load
  before and after. `9700x/profN/`, `annN/`: the profiles and annotations. `9700x/queueN.log`: the lock's waits.
  `9700x/build-*.log`: the builds.
- `scripts/`: `build-one.sh`, `ab.sh`, `prof.sh`, `annotate.sh`, `reduce.sh` and the queues (one locked run at a
  time), as run on the 9700X; `corpora.sh`, `fault-round.sh` and `mutants.py`, as run in the container.
