# The program's loop in the emission's windows (buster#2536, step 2.2c.4, part 2, 2026-11-15)

Step 2.2c.4 moves `check_program`'s per-body loop into the windows on `-c`. Part 1 made the provisional selection before
the loop. Part 2 lowers it as the loop runs, under a new test option, `--windowed-loop`, which implies
`--provisional-selection` and `--deferred-lowering`:

- **The emission takes a caller's loop** (`CheckEmitLoop`, in `CheckProgramLanes`).
  - Each part's lowering runs it up to the part's last body before it lowers (`check_program_emit_lower_half`). That
    covers the windows, Tier 0's inline callees (lowered first) and the alone retry.
  - The lanes, and a lowering that reads the controls' totals, run it whole first.
- **The driver's loop** (`check_driver_loop_run`) runs `check_program_bodies` to the body that a window's last one comes
  from. It then fills in the provisional program's records of the bodies run since, its regions, and the loop's totals
  and columns. Its controls are the writer's entries until the tail copies them.
- **`check_driver_object` is split** into its code half and its finish half. Between them, the `-c` path runs:
  - the rest of the loop;
  - the tail, which now leaves the setup's columns on the scratch (`CheckProgramRun.keep_scratch`);
  - the diagnostics, in today's order;
  - the exact selection and the provisional selection's checks.
- **Where the windowed code goes:**
  - It serves where the provisional selection serves and its emission went.
  - Otherwise it is released, and the exact selection's emission runs after the loop, as today, with today's
    refusals.
- **Two places 2.2c.3 missed, which `main.c` and one fixture found:**
  - A naked body's asm plan reads its controls. With the program's list, it now takes the body's asm statements from
    the list (`check_program_asm_plan_naked`). The epilogue checks that each selected naked body holds asm statements
    alone (`check_driver_naked_asm_only`). Before this fix, `main.c`'s windowed object lacked
    `x86_semantics_test_enter`.
  - A unit whose windowed code didn't serve must take the exact selection's emission. Otherwise a refused body
    (`sources/0210.c`) is reported as the provisional selection's refusal, at another builtin.

The gate: every object, stderr and exit status the same at W of 1, 2,048 and ∞, with the units that don't take the
windowed code counted.

The executables are buster `924cf1b3f7a5932a11e96557dd1d8640c8253aed` (part 2) and its base,
`63617479d7a8cbc755d933d37bdae2d4c4c82760` (part 1's head, buster#2859's) (`raw/9700x/COMMIT.*`). Both are Release
builds made under the 9700X's lock (`raw/9700x/build.*.log`, each with its SHA-256).

**In short.**

- **Objects:** with `--windowed-loop` at W of 1, 2,048 and ∞, every object, stderr and exit status is the plain `-c`'s.
  That holds on all 1,592 units of the corpora and the 1,069 checker fixtures. The head's plain `-c` is the base's on
  every unit.
- **Where the windowed code serves:** every unit of the corpora. Of the fixtures, it serves 313; 23 take the exact
  selection's emission after the loop, and 733 stop before the selection, as they do without the option.
- **Time:** the windowed compile costs what `--provisional-selection` does: 1.9% more cycles than the plain compile on
  `sqlite3.c`, and 2.4% on `main.c`. The plain `-c` is within the runs' spread. Part 3 measures 2.2c's gate.

## What was run

`scripts/run.sh` ran as a user unit on the host:

1. both builds;
2. one hold of the lock a corpus for `scripts/units.sh`. Each unit was compiled five ways: by the base's `-c`, the head's
   `-c`, and the head's `--windowed-loop -c` at `--emit-window=1`, `2048` and `0` (W = ∞);
3. one hold a file for `scripts/repeat.sh`: `sqlite3.c` and `main.c`, 7 rounds of the base's `-c` and the head's `-c`,
   `--provisional-selection -c` and `--windowed-loop -c`. The builds' order was swapped every round, and the compiles
   were counted by `perf stat`.

Every compile ran on CPU 2 with `--lanes 1`. The corpora are part 1's.

The first launch's bundle was made from a branch name and had no `HEAD`, so its builds failed. It was made again from
`HEAD`, and every result here is the second launch's (`raw/9700x/holds.log`).

## The objects

| corpus | units | head = base | W = 1 | W = 2,048 | W = ∞ | windowed code serves |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 1 | 1 | 1 | 1 | 1 | 1 |
| `main.c` | 1 | 1 | 1 | 1 | 1 | 1 |
| Lua | 34 | 34 | 34 | 34 | 34 | 34 |
| c-testsuite | 220 | 220 | 220 | 220 | 220 | 220 |
| musl | 1,336 | 1,336 | 1,336 | 1,336 | 1,336 | 1,336 |
| checker fixtures | 1,069 | 1,069 | 1,069 | 1,069 | 1,069 | 313 |

- **"Head = base":** the head's plain object (or both refused without one), stderr and exit status are the base's.
- **"W = …":** the windowed compile's object, stderr (but the options' report lines) and exit status are the head's
  plain compile's.
- **The fixtures that don't take the windowed code:** 23 reach the selection.
  - 12 make the same object by the exact selection's emission.
  - 11 are refused as without the option: the provisional selection doesn't serve, or the emission refuses a body.
  - The other 733 stop before the selection, with or without the option.

Each unit's line is in `raw/9700x/NAME.txt`.

## The cloud container's checks (`raw/local/`)

- **The same comparisons** (`scripts/windowed.sh`) on c-testsuite, `main.c` and the fixtures, at the three windows:
  - plain (`w3`), with `-g` (`w3g`) and with `-Wall -Wextra` (`w3w`);
  - every object, stderr and exit status is the plain compile's.
- **Part 1's comparison** (`prov2`): with part 2's naked plan, its lines are the same as at part 1's base.
- **The tests' expectations,** replayed from `c_checker_driver_test.c` (`scripts/replay.py`, `replay.txt`): the census,
  the provisional selection, and the new `--windowed-loop` test. That test checks seven sources at the three windows:
  plain bodies, a naked function, a constant `switch`'s local, a statement expression's static, an inline callee, a
  body's error and a refused body.

## The compile

| file | build | mode | task clock | user cycles | user instructions |
| --- | --- | --- | ---: | ---: | ---: |
| `sqlite3.c` | base | `-c` | 122.96 ms | 597.96 M | 1,364.042 M |
| `sqlite3.c` | head | `-c` | 122.70 ms | 595.94 M | 1,364.202 M |
| `sqlite3.c` | head | `--provisional-selection` | 125.93 ms | 610.78 M | 1,381.261 M |
| `sqlite3.c` | head | `--windowed-loop` | 126.25 ms | 609.45 M | 1,381.459 M |
| `main.c` | base | `-c` | 693.25 ms | 3,515.04 M | 10,696.868 M |
| `main.c` | head | `-c` | 691.52 ms | 3,504.46 M | 10,701.781 M |
| `main.c` | head | `--provisional-selection` | 709.48 ms | 3,591.25 M | 10,903.019 M |
| `main.c` | head | `--windowed-loop` | 711.67 ms | 3,598.79 M | 10,903.732 M |

These are medians of 7 runs each (`raw/9700x/NAME.SIDE.MODE.N.csv`).

**Each mode's cycles minus the base's plain compile's, round by round** (millions):

| file | head's mode | rounds 1 to 7 |
| --- | --- | --- |
| `sqlite3.c` | `-c` | −1.1, +0.9, −1.3, −2.6, −4.5, −6.3, +1.1 |
| `sqlite3.c` | `--provisional-selection` | +11.2, +17.2, +12.8, +11.8, +13.7, +10.2, +16.1 |
| `sqlite3.c` | `--windowed-loop` | +12.7, +13.3, +11.5, +10.9, +11.3, +9.6, +13.3 |
| `main.c` | `-c` | +13.9, −6.6, +4.9, −11.0, −14.6, −16.8, −18.8 |
| `main.c` | `--provisional-selection` | +67.7, +70.2, +74.9, +77.5, +95.3, +74.8, +94.0 |
| `main.c` | `--windowed-loop` | +80.7, +73.9, +103.8, +74.6, +90.3, +89.8, +83.7 |

- **The windowed compile** runs the provisional selection's instructions (0.7 M more on `main.c`), and its cycles are
  within the provisional compile's spread. Its cost over the plain compile is the provisional selection's, the pass's
  and the selection's twice. Part 3 measures it against 2.2c's gate.
- **The head's plain `-c`** runs 4.9 M more instructions on `main.c` (0.05%) and 0.16 M more on `sqlite3.c`, and its
  cycles are within the spread: lower than the base's in 5 of 7 rounds on each file. The two builds differ in size in
  about 60 functions: those part 2 changes, and the option parser's, whose later option IDs move by one with the new
  option. The record doesn't place the instructions; sampling can't place a difference that small.
- **Objects:** the last rounds' provisional and windowed objects are the plain one, by the same bytes, and the head's
  plain object is the base's (`raw/9700x/NAME.*.same.txt`).

## Files

- `raw/9700x/`: each unit's lines, the repeats' counts, the object comparisons, the holds' log and the builds'.
- `raw/local/`: the cloud container's comparisons and the tests' replay.
- `scripts/`: every script as run.
- `SHA256SUMS`: every file's hash.
