# The helpers over the candidates' builtins (buster#2536, step 2.2c.3, part 2, 2026-11-15)

Step 2.2c moves `check_program`'s per-body loop into the windows. A window lowers its bodies before the other bodies'
references are known.

The builtins' helpers (`check_program_helpers`) and the runtime functions' preparation (`check_lower_runtime_symbols`,
which checks the builtins' queries and decides the errno function) read the builtin nodes the bodies' references reach.
The loop writes those (`CheckProgram.builtin_nodes`).

Part 2 of step 2.2c.3 gives them a list that the pass before the loop makes:

- **The candidates' builtins:** the candidates' pass lists the builtin nodes it reaches
  (`check_program_census_builtins`). Those are the builtin nodes in a body's tokens, but not in its dropped arms or in
  the operands the references' walk leaves out (`CheckProgram.census_pass_builtins`).
- **The provisional selection:** `--provisional-selection` takes them for its program. It serves only where the helpers
  and the runtime preparation over them are the exact selection's (`check_driver_same_builtin_plans`), as the epilogue
  will check them. Otherwise the unit takes the exact selection, as it does for an extra body.
- **The census:** `--selection-census` reports the comparison on a line of its own, `selection-census-builtins`.

The plan proposed extending 2.2b's placeholders to the symbols numbered after the helpers. That turned out not to be
needed:

- the shift that extra symbols make in everything numbered after the objects is already the placeholders' (step 2.2b);
- an extra helper is new, and no unit of the corpora has one.

The change also fixes a gap in step 2.2c.2, which the checker's fixtures, first compiled in part 1's record, found:

- **The gap:** the tail's symbols, which `--provisional-selection` runs before the loop, decide the target groups'
  states (`CheckProgramTargetGroup.resolved`) from the bodies' references. Only the loop writes those references.
- **Its effect:** the emission refused a unit with a `target("default")` function.
- **The fix:** before the loop, the groups read the candidates' references. After it, `check_program_target_states`
  makes their states again from the bodies' own references. The provisional selection doesn't serve where one differs.

The gate: every object the same bytes, plain and provisional, and the pass at most half the references pass.

The executables are buster `4d46824d4eca8b3844f98cb7fa3a0069e7648137` (buster#2851's head) and its base, main's
`6c59018e4df9dc4b3a77adac524fedba90a83048` (`raw/9700x/COMMIT.*`). Both are Release builds made under the 9700X's lock
(`raw/9700x/build.*.log`, each with its SHA-256).

**In short.**

- **Builtins:** on every unit of `sqlite3.c`, `main.c`, Lua, c-testsuite and musl, the candidates' builtins are the
  bodies' own, so the provisional selection serves on every unit.
- **The checker's fixtures:** 16 units list builtins that only an unevaluated operand reaches, and 4 of them plan other
  helpers. Those take the exact selection.
- **Objects:** every object is the base's, and every provisional object is the plain one.
- **Time:** on the 9700X the pass takes 0.430 of the references pass on `sqlite3.c` and 0.471 on `main.c`, against 0.412
  and 0.449 before. The compile with and without the option is within the runs' spread.

## What was run

`scripts/run.sh` ran as a user unit on the host:

1. both builds;
2. one hold of the lock a corpus for `scripts/units.sh`: each unit by the base's `-c`, the head's `-c`, the head's
   `--provisional-selection -c` and the head's `--selection-census -c`. It compared the head's objects, stderr and exit
   statuses with the base's, and the provisional object with the plain one;
3. one hold a file for `scripts/repeat.sh`: `sqlite3.c` and `main.c`, 7 rounds, each build's census, `-c` and
   `--provisional-selection -c`. The builds' order was swapped every round, and the compiles were counted by
   `perf stat`.

Every compile ran on CPU 2 with `--lanes 1`. The corpora are part 1's: step 1's five and the head's 1,069
`tests/checker` fixtures.

## The objects and the builtins

| corpus | units | head = base | provisional = plain | provisional serves | exact builtins | candidates' | extra (units) | other helpers |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 1 | 1 | 1 | 1 | 41 | 41 | 0 | 0 |
| `main.c` | 1 | 1 | 1 | 1 | 366 | 366 | 0 | 0 |
| Lua | 34 | 34 | 34 | 34 | 268 | 268 | 0 | 0 |
| c-testsuite | 220 | 220 | 220 | 220 | 1 | 1 | 0 | 0 |
| musl | 1,336 | 1,336 | 1,336 | 1,336 | 85 | 85 | 0 | 0 |
| checker fixtures | 1,069 | 1,069 | 1,069 | 325 | 227 | 290 | 63 (16) | 4 |

- **"Head = base":** the object (or both refused without one), stderr and the exit status are the same.
- **"Provisional = plain":** the object is the same bytes, or neither compile makes one.
- **The fixtures without objects:** 744 of them are refused, with or without the option. Of those, 731 are refused
  before the selection, 11 after the provisional selection served (the lowering refuses them, as it does without the
  option), and 2 before the provisional selection reports.
- **The fixtures' builtins columns:** they count the 338 that report a census. Of the 325 that make objects, 314 are
  served and 11 aren't.
- **The census:** no unit misses a builtin, and no unit's runtime preparation differs.

Each unit's line is in `raw/9700x/NAME.txt`. A cloud container's Develop build ran the same comparisons
(`raw/local/census`, `raw/local/provisional`, `scripts/census.sh`, `scripts/provisional.sh`) with the same counts. Its
first build, before the fix to the target groups, made two of the provisional compiles fail: `sources/0396.c` and
`0397.c`, a `target("default")` function each.

**Where the fixtures' extra builtins are.** All 63 are in operands that are never evaluated: a `_Static_assert` inside
a body, and a `_Generic`'s controlling expression. Examples are `generic-builtins/0004.c`'s
`T(__builtin_readcyclecounter(), unsigned long long)` and `sources/0221.c`'s
`_Generic(__atomic_fetch_uinc(c, 3, __ATOMIC_SEQ_CST), ...)`. The candidates' pass leaves out sizeof's and `_Alignof`'s
operands, a constant condition's other arm and a computed call's callee, but not these.

## The compile

| file | build | mode | task clock | user cycles | user instructions |
| --- | --- | --- | ---: | ---: | ---: |
| `sqlite3.c` | base | `-c` | 122.77 ms | 597.30 M | 1,364.608 M |
| `sqlite3.c` | head | `-c` | 122.51 ms | 597.83 M | 1,364.590 M |
| `sqlite3.c` | base | `--provisional-selection` | 124.99 ms | 610.02 M | 1,380.395 M |
| `sqlite3.c` | head | `--provisional-selection` | 125.09 ms | 609.42 M | 1,380.678 M |
| `main.c` | base | `-c` | 693.18 ms | 3,519.90 M | 10,703.742 M |
| `main.c` | head | `-c` | 691.95 ms | 3,508.41 M | 10,698.416 M |
| `main.c` | base | `--provisional-selection` | 708.06 ms | 3,600.48 M | 10,897.741 M |
| `main.c` | head | `--provisional-selection` | 709.10 ms | 3,603.63 M | 10,895.002 M |

These are medians of 7 runs each (`raw/9700x/NAME.SIDE.MODE.N.csv`).

- **Plain `-c`:** it doesn't run the pass, and is within the runs' spread.
- **`--provisional-selection`:** its pass now lists the builtins, and the driver plans the helpers and the runtime
  preparation twice to compare them. Its compile is within the runs' spread: 0.28 M more user instructions on
  `sqlite3.c`, 2.74 M fewer on `main.c`.
- **The objects of the last rounds** are the same bytes by both builds, plain and provisional
  (`raw/9700x/NAME.*.same.txt`).

**The pass against the references pass** (the census's TSC ticks at 3.7925 GHz, medians of 7, `raw/9700x/NAME.repeat.txt`):

| file | build | references pass | candidates' pass | ratio |
| --- | --- | ---: | ---: | ---: |
| `sqlite3.c` | base | 3.340 ms | 1.389 ms | 0.412 |
| `sqlite3.c` | head | 3.437 ms | 1.464 ms | 0.430 |
| `main.c` | base | 7.244 ms | 3.254 ms | 0.449 |
| `main.c` | head | 7.311 ms | 3.437 ms | 0.471 |

The builtins' listing costs 0.08 ms on `sqlite3.c` and 0.18 ms on `main.c`. The vector path scans the ops of the body
chunks 16 at a time, and only the builtins take the scalar test of their body. The pass stays under half the references
pass.

## Files

- `raw/9700x/`: each unit's lines, the repeats' counts and ticks, the object comparisons, the holds' log and the builds'.
- `raw/local/`: the cloud container's census and provisional comparisons.
- `scripts/`: every script as run.
- `SHA256SUMS`: every file's hash.
