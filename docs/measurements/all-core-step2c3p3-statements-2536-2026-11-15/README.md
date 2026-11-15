# The pools and the asm plan over the candidates' statements (buster#2536, step 2.2c.3, part 3, 2026-11-15)

Step 2.2c moves `check_program`'s per-body loop into the windows. A window lowers its bodies before the loop has
written the others' controls. The last two readers of controls in the lowering's preparation are these:

- **The initializers' pools** (`check_lower_init_pools`) take two sets: the plans the INITIALIZE controls name, and the
  compound literals the references reach (`CheckProgram.compound_initializers`).
- **The asm plan** (`check_program_asm_plan`) takes each body's ASM controls, in their order.

Part 3 of step 2.2c.3 gives them lists that need no control:

- **The candidates' statements:** the candidates' pass lists the initializers' plans and the asm statements it reaches
  (`check_program_census_statements`).
  - A local declaration's plan and a body's asm statement count where a body holds the token, outside its dropped arms.
  - A compound literal's plan counts where a live leaf names it. The leaf scan keeps such leaves by the declaration bits
    it already gathers, and marks their plans after its loop (`check_program_census_compound`).
- **The pools:** they take a list of plans in the controls' place (`CheckProgram.initialize_list`).
- **The asm plan:** it takes a list of statements (`asm_list`), each body's in token order. Its three loops now read one
  per-body sequence (`check_program_asm_sequence`), from the controls or from the list.
- **`--provisional-selection`:** it takes the lists, with the compound literals' plans as its `compound_initializers`,
  and serves only where they are the controls' (`check_driver_statement_lists`).
- **`--selection-census`:** it reports the comparison on a line of its own, `selection-census-statements`.

The gate:

- every object the same bytes, plain and provisional;
- the pass at most half the references pass.

The final round's executables are buster `2e611e220fe4bb2fc7b0fc855740b96e0f2421d2` and its base,
`c4a5231660cd4dc143a91beed12eff156b740293` (part 2's head, buster#2851's) (`raw/9700x/COMMIT.*`). On buster's main, the
same tree is `5153d7b8`, part 2's merge `b458d500`'s child. All are Release builds made under the 9700X's lock
(`raw/9700x/build.*.log`, each with its SHA-256).

**In short.**

- **The statements:** on every unit of `sqlite3.c`, `main.c`, Lua, c-testsuite and musl, the candidates' plans,
  compound literals and asm statements are the controls', in the same order. The provisional selection serves on every
  unit.
- **The one fixture that differs:** `sources/0368.c`. Its compound literals sit in a static local's initializer, which
  the references take as data. It takes the exact selection.
- **Objects:** every object is the base's, and every provisional object is the plain one.
- **The pass:** after four rounds it takes 0.441 of the references pass on `sqlite3.c` and 0.493 on `main.c` (0.428 and
  0.469 at the base), under half in every run.

## What was run

`scripts/run.sh` ran as a user unit on the host, once for each round's head:

1. both builds;
2. one hold of the lock a corpus for `scripts/units.sh`. Each unit was compiled four ways: by the base's `-c`, the
   head's `-c`, the head's `--provisional-selection -c` and the head's `--selection-census -c`;
3. one hold a file for `scripts/repeat.sh`: `sqlite3.c` and `main.c`, 7 rounds of each build's census, `-c` and
   `--provisional-selection -c`. The builds' order was swapped every round, and the compiles were counted by `perf stat`.

Every compile ran on CPU 2 with `--lanes 1`. The corpora are part 1's: step 1's five, and the head's 1,069
`tests/checker` fixtures.

## The objects and the statements (the final round)

| corpus | units | head = base | provisional = plain | provisional serves | plans (controls = candidates') | compound literals | asm statements |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 1 | 1 | 1 | 1 | 3,972 | 0 | 0 |
| `main.c` | 1 | 1 | 1 | 1 | 21,414 | 1,083 | 11 |
| Lua | 34 | 34 | 34 | 34 | 1,763 | 0 | 0 |
| c-testsuite | 220 | 220 | 220 | 220 | 141 | 2 | 0 |
| musl | 1,336 | 1,336 | 1,336 | 1,336 | 5,970 | 508 | 510 |
| checker fixtures | 1,069 | 1,069 | 1,069 | 324 | 197 | 11 against 15 | 3 |

- **"Head = base":** the object (or both refused without one), stderr and the exit status are the same.
- **"Provisional = plain":** the object is the same bytes, or neither compile makes one.
- **Which plans are counted:** the INITIALIZE controls' over every control. A selected program copies the checked
  program's controls, so `main.c`'s count includes the plans of bodies the selection leaves out. Their pools are
  emitted, which buster#2852 reports. The lists reproduce that, so the objects stay the same.
- **The asm statements:** each selected body's, in the controls' order.
- **The fixtures:** 313 served and 12 not, of 325 with objects; 744 are refused with or without the option.

Each unit's line is in `raw/9700x/NAME.txt`.

**The cloud container's checks** (`raw/local/`):

- the same counts;
- the vector path's and the `--scalar` path's lists, the same line on every unit (`scripts/twin.sh`);
- the census and provisional tests' expectations, replayed from `c_checker_driver_test.c` (`scripts/replay.py`).

## The pass's cost, by round

| round | head | change | `sqlite3.c` ratio (base) | `main.c` ratio (base) |
| --- | --- | --- | --- | --- |
| 1 | `3e2da3e8` | the lists | 0.460 (0.431) | **0.501** (0.466) |
| 2 | `757c3269` | the plans 16 at a time | 0.460 (0.429) | **0.510** (0.465) |
| 3 | `08a76664` | no call in the leaf scan's loop | 0.434 (0.431) | 0.495 (0.471) |
| 4 | `2e611e22` | the plans as a merge | 0.441 (0.428) | 0.493 (0.469) |

The ratio is the candidates' pass's TSC ticks over the references pass's, the median of 7 runs.
`raw/9700x-roundN/` has the first three rounds and `raw/9700x/` the fourth.

- **Round 1 missed the gate on `main.c`.**
- **Round 2: taking the plans 16 at a time didn't help.**
  - `main.c` averages 2.5 plans a body and `sqlite3.c` 1.5, so a block of 16 met several bodies nearly every time.
  - Those blocks fell back to a plan at a time, with a binary search of the dropped arms for each.
- **The profile behind round 3.** A profile of `main.c`'s census by source line (`scripts/prof3.sh`,
  `raw/9700x-round2/prof-*.txt`):
  - it put head's growth in `check_program_census_scan`'s own leaf loop, its gathers and masks: about 545 samples of 50K
    cycles against 470;
  - it put none in `check_program_census_compound`;
  - the loop called that function for a compound literal's leaf. A call there leaves every vector register to be
    saved, which the code around it pays for.
- **Round 3: the call moved out.** The leaf scan compresses those leaves' nodes into a buffer and marks their plans
  after the loop. `sqlite3.c`'s cost went back to its base's.
- **Round 4: the plans' list is a merge.** The plans, the bodies and the arms all ascend in token order, so one cursor
  over each, moving only on, replaced the binary search. `main.c`'s pass is 0.16 ms over its base: its runs are 0.488
  to 0.500 of the references pass, against 0.467 to 0.489.

## The compile (the final round)

| file | build | mode | task clock | user cycles | user instructions |
| --- | --- | --- | ---: | ---: | ---: |
| `sqlite3.c` | base | `-c` | 122.75 ms | 597.00 M | 1,364.590 M |
| `sqlite3.c` | head | `-c` | 122.66 ms | 596.31 M | 1,364.586 M |
| `sqlite3.c` | base | `--provisional-selection` | 125.02 ms | 607.92 M | 1,380.678 M |
| `sqlite3.c` | head | `--provisional-selection` | 124.94 ms | 607.42 M | 1,381.469 M |
| `main.c` | base | `-c` | 692.39 ms | 3,510.51 M | 10,698.410 M |
| `main.c` | head | `-c` | 697.48 ms | 3,538.15 M | 10,699.022 M |
| `main.c` | base | `--provisional-selection` | 707.52 ms | 3,590.74 M | 10,895.007 M |
| `main.c` | head | `--provisional-selection` | 711.62 ms | 3,617.03 M | 10,899.856 M |

These are medians of 7 runs each (`raw/9700x/NAME.SIDE.MODE.N.csv`).

**`main.c`'s plain `-c` is 0.8% more cycles than its base's in this round, for 0.6 M more instructions.**

- A plain `-c` doesn't run the pass; part 3 changes only the pools' and the asm plan's code on its path.
- The head was higher in 6 of 7 runs, with the runs differing by +8 to +45 M cycles. In rounds 1 to 3 the differences
  were mixed: +8 to +44 M in round 1, +23 to −22 M in round 2, +27 to −17 M in round 3.
- Rounds 3 and 4 run the same plain-path code. Their builds differ only in the pass's code, which a plain compile never
  runs.
- With the instructions the same, the likely cause is the layout, not computation; this record doesn't test that.

`--provisional-selection` adds 0.8 M instructions on `sqlite3.c` and 4.8 M on `main.c`, the lists' comparison. The
objects of the last rounds are the same bytes by both builds, plain and provisional (`raw/9700x/NAME.*.same.txt`).

## Files

- `raw/9700x/`: the final round's unit lines, the repeats' counts and ticks, the object comparisons, the holds' log and
  the builds'.
- `raw/9700x-round1/` to `round3/`: the earlier rounds, the same way; round 2's with the profile's per-symbol and
  per-line samples.
- `raw/local/`: the cloud container's census, provisional and twin comparisons.
- `scripts/`: every script as run.
- `SHA256SUMS`: every file's hash.
