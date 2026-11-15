# The one-core path's step 1, followed up: a lean record, and a lookup's load alone (buster#2850), 2026-11-15

The follow-up to step 1 of
[buster#2850](https://github.com/buster14a/buster/issues/2850), under
[its claim](https://github.com/buster14a/buster/issues/2850#issuecomment-6900715849).
[Step 1](../per-core-step1-2850-2026-11-15) made T's whole record of every
identifier leaf and lookup from fact words and found a lookup's rule, not its
loads, the cost. It left two things unmeasured: a lookup that makes only what
later rules decide on, and what of a lookup is its load.

**Result.** Every record is T's in what each variant makes, on `sqlite3.c`,
Lua and musl, and what a lean kernel leaves out is its rule's on the kernel's
own records. A lean kernel (a leaf half a line, a lookup's first half, no
conversion's entry, no discard) costs 20.8, 16.0 and 14.1 cycles a taken leaf
or lookup with a body a window and 17.4, 13.5 and 13.0 with the windows
packed to 384 records, where the whole kernel costs 22.7, 17.6 and 15.9, and
18.9, 14.9 and 14.7. A lookup's load alone costs 15.2, 10.8 and 8.8, and
11.8, 8.3 and 7.8: by operator 12 to 16 cycles on `sqlite3.c`, where a lean
lookup is 21 to 45. The gate's 10 cycles, a body's expressions a run, are met
by the load alone on musl and missed by 1 on Lua and by 5 on `sqlite3.c`. On
the way, the short paths' choices that clang had compiled as branches became
selects between registers: main's whole kernel on `sqlite3.c` went from 26.5
and 22.4 cycles to 22.7 and 18.9.

The code is buster's `c_check_node_machine_facts.c`
(`measure-node-machine --shadow --facts-lean`, `--facts-loads`); the design's
page is buster's `docs/one-core-path.md`.

## The variants

- **Whole** (`--facts`): step 1's kernel. A leaf's and a lookup's record with
  every field T writes.
- **Lean** (`--facts-lean`): a leaf is its declaration's line alone (32
  bytes); a lookup writes its record's first half (type and word, flags and
  object, payload, standing) and a member's offset, and no conversion's entry;
  a discard is not made (its record is given).
- **Loads** (`--facts-loads`): of a lookup only its type, that type's word and
  a member's offset, with only the tests the load makes. Its standing, flags,
  object and payload are given, and so is whether its operand is fit for the
  short path (the lean kernel's own answer, a byte a record). No compile could
  run it alone: it says what the load costs.

What a variant leaves out is checked: each taken lookup's conversions' entries
are made by its rule from the kernel's own records and must be T's (the
command fails otherwise), and each discard's record is made by the discard's
rule from its operand's record and counted. The loads' kernel is checked after
the lean one, over records whose given fields are T's and whose loaded fields
are poisoned.

## How it was measured

- The 9700X (`benchpress`), CPU 2, every build and run under the host's lock,
  one hold a run (`scripts/lock.sh`).
- `base` is buster main `fdf0de74`, which has step 1 (buster#2863). `head`
  is it with `results/head/follow-2.patch`, the follow-up's sources (not its
  docs). Both are `./build.sh --config Release` (`scripts/build-label.sh`).
- `queue-base` and `queue-head` are an earlier run of the same: on
  `228787fe`, the merge queue's candidate for buster#2863 (main with
  buster#2865, which the queue then left out), with
  `results/queue-head/follow-1.patch`: the same sources but for a line the
  tests' fixture gained since, with its counts. Its first profiles were 40
  passes; the kept ones are 160. "Two builds" below compares them.
- The inputs, a run's passes and what a figure is are step 1's
  (`scripts/facts.sh`; that record's "How it was measured").
- Each setting ran three times; the tables have the medians.
  `scripts/follow.sh` ran everything; `scripts/page.py`, `scripts/summary.py`
  and `scripts/tables.py` make the tables.

## The result

`python3 scripts/page.py results head 160 l2 40`. Cycles a taken leaf or lookup,
and in parentheses the same a record of the window: the figure the variants
share a denominator of, since a lean kernel makes no discard and its taken
lookups are fewer and dearer than the whole kernel's.

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| records of the windows | 291,021 | 73,998 | 130,291 |
| identifiers' leaves, all taken | 93,682 | 21,795 | 42,850 |
| lookups a lean kernel makes, and those it takes | 52,013, 51,973 | 13,289, 13,283 | 17,046, 16,875 |
| of them by a short path (and by their load alone), by their rule | 51,842, 131 | 13,266, 17 | 16,691, 184 |
| conversions' entries left out, and those their rule derives | 51,973, 51,973 | 13,283, 13,283 | 16,875, 16,875 |
| discards left out, and those their rule derives | 36,724, 36,524 | 6,503, 6,453 | 10,520, 10,508 |
| records that differ from T's, every run | 0 | 0 | 0 |
| **a body a window:** whole | 22.7 (14.2) | 17.6 (9.9) | 15.9 (8.6) |
| lean | 20.8 (10.4) | 16.0 (7.6) | 14.1 (6.4) |
| loads | 15.2 (7.6) | 10.8 (5.1) | 8.8 (4.1) |
| mispredicted branches: whole, lean, loads | 0.25, 0.21, 0.20 | 0.01, 0.01, 0.01 | 0.01, 0.01, 0.01 |
| **windows packed to 384 records:** whole | 18.9 (11.9) | 14.9 (8.4) | 14.7 (7.9) |
| lean | 17.4 (8.7) | 13.5 (6.4) | 13.0 (5.9) |
| loads | 11.8 (5.9) | 8.3 (3.9) | 7.8 (3.6) |
| mispredicted branches: whole, lean, loads | 0.12, 0.09, 0.09 | 0.01, 0.02, 0.01 | 0.01, 0.01, 0.01 |

- The discards a lean kernel's rule doesn't derive (200, 50 and 12) are the
  ones the whole kernel leaves to T.
- `python3 scripts/tables.py results head` has each setting's instructions, a
  leaf's and a lookup's cycles by their ticks, and each window's second run.
  On `sqlite3.c` a lookup with its part of the lists and classes is 43.9
  cycles (lean) and 28.5 (loads) with a body a window, 37.2 and 20.9 packed.
- Lua's and musl's mispredicted branches read as none, as in step 1: their
  passes repeat.

By part on `sqlite3.c`, windows packed to 384 records, from
`scripts/profiles.sh`'s profiles of each kernel's functions (160 passes a
run, 481 runs of the unit): cycles each (instructions; mispredicted
branches).

| part | of them | whole | lean | loads |
| --- | ---: | ---: | ---: | ---: |
| the lists, the classes' mask and the batches, a record of the window | 291,021 | 2.4 (10; 0.01) | 1.8 (6; 0.01) | 1.5 (5; 0.01) |
| a leaf | 93,682 | 3.1 (15; 0.00) | 2.4 (12; 0.00) | 2.4 (11; 0.00) |
| a discard | 36,724 | 13.4 (53; 0.06) | given | given |
| `->` | 23,433 | 23.6 (92; 0.13) | 20.9 (79; 0.11) | 15.8 (49; 0.12) |
| `.` | 7,257 | 31.2 (122; 0.19) | 27.6 (118; 0.12) | 14.4 (56; 0.08) |
| `*` | 1,188 | 30.1 (105; 0.19) | 25.9 (94; 0.16) | |
| a subscript | 6,812 | 53.6 (228; 0.24) | 44.6 (189; 0.15) | 14.0 (52; 0.09) |
| a call | 13,323 | 35.5 (147; 0.20) | 28.0 (130; 0.10) | 11.7 (46; 0.09) |

The loads' dereferences have too few samples to be among their profile's
kept symbols. A part has 200 to 1,700 samples (a dereference under 100): its
cycles read to 3 to 7 percent, and by build as below.

## A short path's choices

Step 1's kernel was meant to read a call's first four arguments with no
branch. Its source did; its compiled code didn't. Clang 23 compiles a choice
with a load behind one side as a branch (a conditional move with a memory
operand is unfolded into one), so `i < count ? record of argument i : the
callee's` became a tree of branches on the call's argument count; a
subscript's "an array or a pointer", "a constant or not" and "an lvalue or
not" a branch each; a dot's "an address constant or not" another. On
`sqlite3.c` the predictor learns none of them. `head` loads what a choice may
need whichever way it goes and chooses between registers, by masks; `l2` is
the same kernels before that. On `sqlite3.c`, windows packed (`l2`'s profile
is 40 passes):

| the lean kernel's | cycles, `l2` | `head` | mispredicted branches, `l2` | `head` |
| --- | ---: | ---: | ---: | ---: |
| `->` | 23.5 | 20.9 | 0.15 | 0.11 |
| `.` | 37.6 | 27.6 | 0.29 | 0.12 |
| a subscript | 52.2 | 44.6 | 0.46 | 0.15 |
| a call | 43.4 | 28.0 | 0.54 | 0.10 |
| the lean kernel, a taken leaf or lookup | 18.9 | 17.4 | 0.20 | 0.09 |
| the whole kernel, a taken leaf or lookup | 20.9 | 18.9 | 0.21 | 0.12 |

Lua and musl read 0.2 to 0.7 cycles a taken leaf or lookup more in `head`:
their repeated passes had those branches right, and the selects'
instructions are all they see of the change.

## Main against the branch

The whole kernel, main's (`base`, step 1's) against the branch's (`head`),
cycles a taken leaf or lookup (`python3 scripts/tables.py results base head`):

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| a body a window: main | 26.5 | 17.3 | 16.0 |
| the branch | 22.7 | 17.6 | 15.9 |
| mispredicted branches: main, the branch | 0.38, 0.25 | 0.01, 0.01 | 0.00, 0.01 |
| windows packed to 384 records: main | 22.4 | 15.1 | 15.1 |
| the branch | 18.9 | 14.9 | 14.7 |
| mispredicted branches: main, the branch | 0.24, 0.12 | 0.01, 0.01 | 0.01, 0.01 |

`-c sqlite3.c` as whole processes (`scripts/compile.sh`: `time-runs` under
`ab`, 21 runs a build from three fresh copies of each executable, the base
twice; `results/head/compile-N.txt`):

| comparison | wall ms, main | the branch | difference (over copies) | main again against main |
| --- | ---: | ---: | --- | --- |
| 1 | 123.621 | 123.200 | -0.34% (-0.54% to -0.02%) | -0.09% (-0.32% to +0.52%) |
| 2 | 123.531 | 122.955 | -0.47% (-0.76% to -0.31%) | -0.07% (-0.34% to +0.10%) |
| `queue-head` against `queue-base`, 1 | 122.973 | 123.280 | +0.25% (-0.09% to +0.38%) | +0.20% |
| `queue-head` against `queue-base`, 2 | 123.040 | 123.119 | +0.06% (-0.27% to +0.27%) | -0.08% |

User cycles differ by -0.45% and -0.54% (main again by -0.12% and -0.03%),
and in the queue's builds by +0.20% and -0.13%. No compile runs any of the
change: the two builds' -0.4% and +0.2% are what a different layout of the
checker's unit is worth to a compile, either way.

## Two builds

`head` and `queue-head` are the same kernels built on two bases. Cycles a
taken leaf or lookup on `sqlite3.c`, whole, lean and loads:

| | a body a window | windows packed |
| --- | ---: | ---: |
| `queue-head` | 23.3, 21.0, 15.3 | 19.3, 16.5, 10.8 |
| `head` | 22.7, 20.8, 15.2 | 18.9, 17.4, 11.8 |

Lua and musl agree to 0.6. On `sqlite3.c` with the windows packed the lean
and the loads' kernels read a cycle apart: a kernel's place in the executable
is worth that much, and the pages' figures are `head`'s.

## The versions

Cycles a taken leaf or lookup on `sqlite3.c`, whole, lean and loads, medians
of three runs:

| label | the kernels | a body a window | windows packed |
| --- | --- | ---: | ---: |
| `l1` | the lean and the loads' kernels as first written: a short path calls its rule and fills a member's slot from inside its loop | 27.1, 23.2, 15.1 | 22.1, 19.3, 11.2 |
| `l2` | no call in a loop: the lookups a short path doesn't take are listed and made after it; the members' slots are filled by a first pass, and a short path only probes | 25.5, 23.4, 14.9 | 20.9, 18.9, 10.8 |
| `l3` | `l2`'s loads, and the loads in the list's order by one body for every operator, with no class and no dispatch (`--facts-ordered`, in its patch only) | loads 15.0, in order 20.2 | loads 10.7, in order 18.8 |
| `queue-head`, `head` | the choices as selects between registers | 23.3, 21.0, 15.3 and 22.7, 20.8, 15.2 | 19.3, 16.5, 10.8 and 18.9, 17.4, 11.8 |

- `l1` is on main `639e730e`, `l2` and `l3` on main `8c2045d4`, each with the
  session's tree as a patch (`results/lN/lean-N.patch`; `l2`'s and `l3`'s
  patches also undo buster#2862, which that tree didn't have).
- **In order** (`l3`): the one body is about 150 instructions where a class's
  loop is 44 to 58, with the loop's seventeen values on the stack and a
  branch clang kept on arrow against dot (its `type ^ ((type ^ element) &
  mask)` compiled as one); and a chain such as `a->b->c` waits in it for each
  link's store, where the classes make a level's lookups independent. Lua
  and musl read the same: 17.3 and 13.9 against 10.8 and 8.8 with a body a
  window.
- A run of `head`'s kernels on main `8c2045d4` (`l4`) read as `queue-head`
  within 0.5 cycles and isn't kept.

## Traps met

- **A choice with a load behind it is a branch** (above). Reading the
  disassembly found it; the source said otherwise for a day.
- **A place that waits for a test** (`i += taken`) makes a loop's iterations
  one chain: each waits for the one before it, its loads and all. The
  in-order loop's first form did, and read 53 ticks a lookup in the session's
  container against 40 once its place moved on whatever the test said.
- **A profile's part has a few hundred samples** at 40 passes of the unit: a
  dot read 24.6 cycles in `l4`'s profile and 31.4 in `queue-head`'s first
  one, while the two kernels' counters agreed to 0.2. The tables are from
  160 passes.
- **A final run on the merge queue's candidate** isn't a run on main: the
  queue left buster#2865 out and merged step 1 on another base. The run was
  made again on main.
- **`follow.sh` as first run** had the whole kernel's profile files
  overwritten by the lean one's (`profiles.sh` names every variant's now).
- **The lock's waiting line** prints its holder's whole command, 100 KB for
  another session's job: `scripts/trim.sh` cut those lines to 200 characters
  in the results.

## Files

- `scripts/`: `lock.sh`, `build-label.sh`, `facts.sh`, `profile.sh`,
  `compile.sh` (step 1's, with this record's lock title); `lean.sh` (what
  `l1` and `l2` ran), `ordered.sh` (`l3`), `follow.sh` and `profiles.sh`
  (`base` and `head`, `queue-base` and `queue-head`); `tables.py`,
  `parts.py`, `summary.py`, `page.py`; `trim.sh`.
- `results/`: `l1`, `l2`, `l3`, `queue-base`, `queue-head`, `base`, `head`:
  each label's patch, revision, build log, executable's hash, runs and
  profiles.
