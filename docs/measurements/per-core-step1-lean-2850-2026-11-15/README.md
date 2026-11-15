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
conversion's entry, no discard) costs 21.0, 15.9 and 14.0 cycles a taken leaf
or lookup with a body a window and 16.5, 13.4 and 13.0 with the windows
packed to 384 records, where the whole kernel costs 23.3, 17.9 and 16.0, and
19.3, 15.5 and 15.0. A lookup's load alone costs 15.3, 10.8 and 8.9, and
10.8, 8.2 and 7.7: by operator 12 to 16 cycles on `sqlite3.c`, where a lean
lookup is 22 to 42. The gate's 10 cycles, a body's expressions a run, are met
by the load alone on musl and missed by 1 on Lua and by 5 on `sqlite3.c`. On
the way, the short paths' choices that clang had compiled as branches became
selects between registers: main's whole kernel on `sqlite3.c` went from 26.4
and 22.6 cycles to 23.3 and 19.3.

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
- `base` is buster `228787fe`: main `76721316` with step 1's pull request
  (buster#2863) merged, as the merge queue made it. `head` is it with
  `results/head/follow-1.patch`, the follow-up's sources (not its docs). Both
  are `./build.sh --config Release` (`scripts/build-label.sh`).
- The inputs, a run's passes and what a figure is are step 1's
  (`scripts/facts.sh`; that record's "How it was measured").
- Each setting ran three times; the tables have the medians.
  `scripts/follow.sh` ran everything; `scripts/page.py`, `scripts/summary.py`
  and `scripts/tables.py` make the tables.

## The result

`python3 scripts/page.py results head 160 l2`. Cycles a taken leaf or lookup,
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
| **a body a window:** whole | 23.3 (14.6) | 17.9 (10.0) | 16.0 (8.6) |
| lean | 21.0 (10.5) | 15.9 (7.6) | 14.0 (6.4) |
| loads | 15.3 (7.7) | 10.8 (5.1) | 8.9 (4.1) |
| mispredicted branches: whole, lean, loads | 0.25, 0.21, 0.21 | 0.01, 0.01, 0.01 | 0.01, 0.01, 0.01 |
| **windows packed to 384 records:** whole | 19.3 (12.1) | 15.5 (8.7) | 15.0 (8.1) |
| lean | 16.5 (8.2) | 13.4 (6.4) | 13.0 (5.9) |
| loads | 10.8 (5.4) | 8.2 (3.9) | 7.7 (3.5) |
| mispredicted branches: whole, lean, loads | 0.12, 0.09, 0.09 | 0.01, 0.01, 0.01 | 0.01, 0.01, 0.01 |

- The discards a lean kernel's rule doesn't derive (200, 50 and 12) are the
  ones the whole kernel leaves to T.
- `python3 scripts/tables.py results head` has each setting's instructions, a
  leaf's and a lookup's cycles by their ticks, and each window's second run.
  On `sqlite3.c` a lookup with its part of the lists and classes is 45.0
  cycles (lean) and 28.3 (loads) with a body a window, 37.6 and 20.9 packed.
- Lua's and musl's mispredicted branches read as none, as in step 1: their
  passes repeat.

By part on `sqlite3.c`, windows packed to 384 records, from
`scripts/profiles.sh`'s profiles of each kernel's functions (160 passes a
run, 481 runs of the unit): cycles each (instructions; mispredicted
branches).

| part | of them | whole | lean | loads |
| --- | ---: | ---: | ---: | ---: |
| the lists, the classes' mask and the batches, a record of the window | 291,021 | 2.5 (9; 0.01) | 1.6 (6; 0.01) | 1.3 (5; 0.01) |
| a leaf | 93,682 | 3.7 (17; 0.00) | 2.5 (12; 0.00) | 2.3 (11; 0.00) |
| a discard | 36,724 | 13.0 (54; 0.06) | given | given |
| `->` | 23,433 | 23.6 (89; 0.14) | 22.4 (80; 0.11) | 15.5 (52; 0.12) |
| `.` | 7,257 | 33.3 (117; 0.19) | 30.8 (117; 0.11) | 12.9 (58; 0.08) |
| `*` | 1,188 | 34.7 (124; 0.20) | | |
| a subscript | 6,812 | 53.3 (218; 0.25) | 42.2 (194; 0.17) | 13.4 (54; 0.08) |
| a call | 13,323 | 36.5 (146; 0.18) | 31.8 (131; 0.12) | 12.1 (44; 0.08) |

A lean or loads dereference's loop has too few samples to be among a
profile's kept symbols. A part has 200 to 1,700 samples (the whole kernel's
dereferences 99): its cycles read to 3 to 7 percent.

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
| `->` | 23.5 | 22.4 | 0.15 | 0.11 |
| `.` | 37.6 | 30.8 | 0.29 | 0.11 |
| a subscript | 52.2 | 42.2 | 0.46 | 0.17 |
| a call | 43.4 | 31.8 | 0.54 | 0.12 |
| the lean kernel, a taken leaf or lookup | 18.9 | 16.5 | 0.20 | 0.09 |
| the whole kernel, a taken leaf or lookup | 20.9 | 19.3 | 0.21 | 0.12 |

Lua and musl read 0.3 to 0.8 cycles a taken leaf or lookup more in `head`:
their repeated passes had those branches right, and the selects'
instructions are all they see of the change.

## Main against the branch

The whole kernel, main's (`base`, step 1's) against the branch's (`head`),
cycles a taken leaf or lookup (`python3 scripts/tables.py results base head`):

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| a body a window: main | 26.4 | 17.4 | 16.0 |
| the branch | 23.3 | 17.9 | 16.0 |
| mispredicted branches: main, the branch | 0.38, 0.25 | 0.01, 0.01 | 0.01, 0.01 |
| windows packed to 384 records: main | 22.6 | 15.0 | 15.1 |
| the branch | 19.3 | 15.5 | 15.0 |
| mispredicted branches: main, the branch | 0.24, 0.12 | 0.01, 0.01 | 0.01, 0.01 |

`-c sqlite3.c` as whole processes (`scripts/compile.sh`: `time-runs` under
`ab`, 21 runs a build from three fresh copies of each executable, the base
twice; `results/head/compile-N.txt`):

| comparison | wall ms, main | the branch | difference (over copies) | main again against main |
| --- | ---: | ---: | --- | --- |
| 1 | 122.973 | 123.280 | +0.25% (-0.09% to +0.38%) | +0.20% |
| 2 | 123.040 | 123.119 | +0.06% (-0.27% to +0.27%) | -0.08% |

User cycles differ by +0.20% and -0.13%, where main again differs from main
by +0.31% and -0.05%. No compile runs any of the change.

## The versions

Cycles a taken leaf or lookup on `sqlite3.c`, whole, lean and loads, medians
of three runs:

| label | the kernels | a body a window | windows packed |
| --- | --- | ---: | ---: |
| `l1` | the lean and the loads' kernels as first written: a short path calls its rule and fills a member's slot from inside its loop | 27.1, 23.2, 15.1 | 22.1, 19.3, 11.2 |
| `l2` | no call in a loop: the lookups a short path doesn't take are listed and made after it; the members' slots are filled by a first pass, and a short path only probes | 25.5, 23.4, 14.9 | 20.9, 18.9, 10.8 |
| `l3` | `l2`'s loads, and the loads in the list's order by one body for every operator, with no class and no dispatch (`--facts-ordered`, in its patch only) | loads 15.0, in order 20.2 | loads 10.7, in order 18.8 |
| `head` | the choices as selects between registers | 23.3, 21.0, 15.3 | 19.3, 16.5, 10.8 |

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
- A run of `head`'s kernels on main `8c2045d4` (`l4`) read the same as `head`
  within 0.5 cycles and isn't kept.

## Traps met

- **A choice with a load behind it is a branch** (above). Reading the
  disassembly found it; the source said otherwise for a day.
- **A place that waits for a test** (`i += taken`) makes a loop's iterations
  one chain: each waits for the one before it, its loads and all. The
  in-order loop's first form did, and read 53 ticks a lookup in the session's
  container against 40 once its place moved on whatever the test said.
- **A profile's part has a few hundred samples** at 40 passes of the unit: a
  dot read 24.6 cycles in `l4`'s profile and 31.4 in `head`'s first one,
  while the two kernels' counters agreed to 0.2. The tables are from 160
  passes.
- **`follow.sh` as first run** had the whole kernel's profile files
  overwritten by the lean one's (`profiles.sh` names every variant's now).
- **The lock's waiting line** prints its holder's whole command, 100 KB for
  another session's job: `scripts/trim.sh` cut those lines to 200 characters
  in the results.

## Files

- `scripts/`: `lock.sh`, `build-label.sh`, `facts.sh`, `profile.sh`,
  `compile.sh` (step 1's, with this record's lock title); `lean.sh` (what
  `l1` and `l2` ran), `ordered.sh` (`l3`), `follow.sh` and `profiles.sh`
  (`base` and `head`); `tables.py`, `parts.py`, `summary.py`, `page.py`;
  `trim.sh`.
- `results/`: `l1`, `l2`, `l3`, `base`, `head`: each label's patch, revision,
  build log, executable's hash, runs and profiles.
