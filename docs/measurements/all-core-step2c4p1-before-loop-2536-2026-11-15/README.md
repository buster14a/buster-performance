# The provisional selection before the loop (buster#2536, step 2.2c.4, part 1, 2026-11-15)

Step 2.2c.4 moves `check_program`'s per-body loop into the windows on `-c`, so a window's lowering needs the provisional
selection before the loop has run. Part 1 makes it there, under `--provisional-selection`:

- **The split.** `check_program` is now three parts: `check_program_start` (the setup, the pass and the tail's part over
  the candidates' marks), `check_program_loop` and `check_program_finish`. The `-c` path runs them with the selection in
  between (`check_driver_provisional_select`).
- **The bounds.** Where the selection reads what the loop makes, it takes a bound:
  - a block-scope static is emitted unless the pass's left-out ranges hold it;
  - every statement expression's region counts as reached.

  The pass now keeps its left-out ranges (`CheckProgram.census_pass_ranges`). The selection and its lowering's locals
  take them in place of the writer's.
- **The records.** After the loop and the tail, `check_driver_provisional_refresh` fills in:
  - its bodies' places in the loop's columns;
  - its regions' bodies;
  - the totals and columns that a body's lowering reads.
- **The epilogue.** `check_driver_provisional_check` runs today's checks, plus one new one: the lowering's locals over the
  pass's ranges must be the writer's (`check_driver_provisional_locals`). A constant `switch`'s dead case that declares a
  local fails it, and that unit takes the exact selection.
- **The census.** `--selection-census` reports the ranges on a line of its own, `selection-census-ranges`: the writer's
  count and the pass's, whether they are the same, and whether the locals over them are.

The gate: every object the same bytes, and where the provisional selection no longer serves, why.

The executables are buster `12e0ad8251050f73e47cf00b1effbf14b0c51794` (part 1) and its base,
`8d25907e13b3328341da62868281420869d14623` (buster#2858's head: main's `8f223aee` and the plan's docs)
(`raw/9700x/COMMIT.*`). Both are Release builds made under the 9700X's lock (`raw/9700x/build.*.log`, each with its
SHA-256).

**In short.**

- **Objects:** every object, stderr and exit status by the head is the base's, on all 1,592 units of the corpora and the
  1,069 checker fixtures. Every provisional object is the plain one.
- **Where it serves:** the provisional selection serves on exactly the units it served at the base: every unit of the
  corpora, and 324 of the fixtures.
- **The ranges:** the pass's ranges are the writer's on every unit of the corpora. In the fixtures they differ on 2 units
  (a constant `switch`), whose locals are the same.
- **Time:** the plain `-c` is within the runs' spread. `--provisional-selection` runs the same instructions, with 3.3 M
  more cycles on `sqlite3.c` (0.5%) and within the spread on `main.c`.

## What was run

`scripts/run.sh` ran as a user unit on the host:

1. both builds;
2. one hold of the lock a corpus for `scripts/units.sh`. Each unit was compiled five ways: by the base's `-c`, the head's
   `-c`, both builds' `--provisional-selection -c` and the head's `--selection-census -c`;
3. one hold a file for `scripts/repeat.sh`: `sqlite3.c` and `main.c`, 7 rounds of each build's census, `-c` and
   `--provisional-selection -c`. The builds' order was swapped every round, and the compiles were counted by `perf stat`.

Every compile ran on CPU 2 with `--lanes 1`. The corpora are part 3's (`all-core-step2c3p3-statements-2536-2026-11-15`):
step 1's five, and the head's 1,069 `tests/checker` fixtures.

## The objects, the selection and the ranges

| corpus | units | head = base | provisional = plain | provisional serves (base) | census lines | ranges the same | locals the same |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 1 | 1 | 1 | 1 (1) | 1 | 1 | 1 |
| `main.c` | 1 | 1 | 1 | 1 (1) | 1 | 1 | 1 |
| Lua | 34 | 34 | 34 | 34 (34) | 34 | 34 | 34 |
| c-testsuite | 220 | 220 | 220 | 220 (220) | 220 | 220 | 220 |
| musl | 1,336 | 1,336 | 1,336 | 1,336 (1,336) | 1,336 | 1,336 | 1,336 |
| checker fixtures | 1,069 | 1,069 | 1,069 | 324 (324) | 338 | 336 | 338 |

- **"Head = base":** the object (or both refused without one), stderr and the exit status are the same.
- **"Provisional = plain":** the object is the same bytes, or neither compile makes one (744 fixtures are refused either
  way).
- **"Provisional serves":** the head's report, with the base's in brackets. They agree on every unit.
- **The two fixtures whose ranges differ:** `align/0044.c` and `classify/0001.c`. Each has a `switch (0)`, whose arms
  the writer leaves out and the pass keeps; neither arm declares a local.

Each unit's line is in `raw/9700x/NAME.txt`.

## The cloud container's checks (`raw/local/`)

- **The same comparisons**, plain and with `-g`, on c-testsuite, `main.c` and the fixtures, by the head and the base
  (`scripts/provisional.sh`; `prov1`, `prov-base`, `prov1g`, `prov-baseg`). The two builds' lines are the same on every
  unit, and every provisional object is the plain one.
- **Field by field** (`fields.txt`): a temporary check, `scripts/fields-check.c`, which isn't in the PR. On each of those
  units it made the provisional selection again as the base made it (after the loop) and compared every field of
  `CheckProgram` with the one made before the loop and filled in after it. The results:
  - every body record and region is the same;
  - every array the selection makes for itself has the same contents (its object symbols, symbol objects, eager
    bodies, references, builtins, targets, options, alias states, and target, cpu and clone symbols);
  - the fields that differ are those arrays' addresses, `output_bytes`, and the left-out ranges, as intended.
- **The tests:** the census and provisional tests' expectations, replayed from `c_checker_driver_test.c`
  (`scripts/replay.py`), pass on the vector and `--scalar` paths.
  - The census test gains the ranges line, and a constant `switch`'s local: `writer 3 pass 0 same 0 locals-same 0`.
  - The provisional test gains that local, which doesn't serve.
- **Why the locals' check is needed.** A build without it made the provisional object of that source with a 256-byte
  frame (`sub $0x108,%rsp`) that the writer's left-out arm doesn't take. The exact selection's object has none.

## The compile

| file | build | mode | task clock | user cycles | user instructions |
| --- | --- | --- | ---: | ---: | ---: |
| `sqlite3.c` | base | `-c` | 123.12 ms | 600.50 M | 1,364.586 M |
| `sqlite3.c` | head | `-c` | 122.76 ms | 597.07 M | 1,364.042 M |
| `sqlite3.c` | base | `--provisional-selection` | 125.04 ms | 610.13 M | 1,381.469 M |
| `sqlite3.c` | head | `--provisional-selection` | 126.08 ms | 612.65 M | 1,381.081 M |
| `main.c` | base | `-c` | 693.39 ms | 3,517.32 M | 10,698.935 M |
| `main.c` | head | `-c` | 693.36 ms | 3,517.70 M | 10,698.045 M |
| `main.c` | base | `--provisional-selection` | 712.49 ms | 3,622.01 M | 10,899.754 M |
| `main.c` | head | `--provisional-selection` | 712.10 ms | 3,605.78 M | 10,899.162 M |

These are medians of 7 runs each (`raw/9700x/NAME.SIDE.MODE.N.csv`).

**The head's cycles minus the base's, round by round** (millions):

| file | mode | rounds 1 to 7 |
| --- | --- | --- |
| `sqlite3.c` | `-c` | −0.9, +0.2, −6.0, +0.9, −3.4, −6.7, −0.9 |
| `sqlite3.c` | `--provisional-selection` | −0.4, +4.4, +0.3, +3.3, +6.4, +3.5, +1.5 |
| `main.c` | `-c` | −34.5, +30.4, −11.3, +4.8, +20.8, −2.2, +0.4 |
| `main.c` | `--provisional-selection` | +44.8, −17.2, −27.7, −9.5, +2.4, −44.0, −5.6 |

- **`sqlite3.c`'s provisional compile** is higher in 6 of 7 rounds, by 3.3 M at the median, with 0.4 M fewer
  instructions. The selection does the same work; it is made before the loop, so its arrays come before the loop's in the
  output arena. The refresh and the locals' check add little. The record doesn't place the cycles.
- **Objects:** the last rounds' objects are the same bytes, by both builds, plain and provisional
  (`raw/9700x/NAME.*.same.txt`).

**The candidates' pass against the references pass** (the census's TSC ticks at 3.7925 GHz, medians of 7,
`raw/9700x/NAME.repeat.txt`):

| file | build | references pass | candidates' pass | ratio |
| --- | --- | ---: | ---: | ---: |
| `sqlite3.c` | base | 3.429 ms | 1.522 ms | 0.446 |
| `sqlite3.c` | head | 3.319 ms | 1.460 ms | 0.447 |
| `main.c` | base | 7.383 ms | 3.633 ms | 0.494 |
| `main.c` | head | 7.206 ms | 3.640 ms | 0.501 |

Part 1 changes the pass only by keeping its ranges, and its ticks are the same. `main.c`'s ratio moves with the
references pass: the base's runs are 0.482 to 0.504, the head's 0.490 to 0.519.

## Files

- `raw/9700x/`: each unit's lines, the repeats' counts and ticks, the object comparisons, the holds' log and the builds'.
- `raw/local/`: the cloud container's comparisons, the ranges census (`ranges.txt`) and the field check's lines.
- `scripts/`: every script as run, and the field check's code.
- `SHA256SUMS`: every file's hash.
