# The tail's symbols before the loop (buster#2536, step 2.2c.2, 2026-11-15)

Step 2.2c moves `check_program`'s per-body loop into the windows. The windows lower before every body's references are
known, so they need the tail's part over the needed marks first: the static objects, roots, groups, aliases and asm
labels, the symbols' numbering, the late weak declarations, the targets, and the attributes' and patchable entries'
keys. Step 2.2c.2 makes that part (`check_program_symbols`) able to run before the loop.

- **The setup writes each body's own fields** (declaration, opening, object, whether it is `main`), the only ones that
  part reads; the loop writes the rest, at each body's index.
- **Under `--provisional-selection`** the part runs before the loop, over the candidates' references.

The gate: the provisional objects are the exact selection's bytes on every corpus, and every other object is the same
as before.

The executables are buster `4cbe09f5bf923fb4a5a3d3d14e23248e36810a7b` and its base, step 2.2c.1's `17b9fd73`
(`raw/commit.txt`; on buster's main they are `118516c2` and `d3114b87`). Both are Release builds made under the 9700X's
lock (`raw/9700x/build.*.log`, each with its SHA-256).

**In short.** No second run over the exact marks is needed, because the selection numbers its own symbols and makes the
weakrefs' states again from its own references. On all 1,592 units of the corpora:

- the provisional objects are the exact selection's bytes;
- the census is the same;
- every object, stderr and exit status is the same as before, plain, with `-Wall -Wextra` and with `-g`.

On the 9700X the compile is within the runs' spread.

## Why one run of the tail is enough

The tail takes the needed marks of the bodies' references, and the candidates' references are a superset of them. A
cloud container's build of step 2.2c.1 tested it (`scripts/tail-experiment.patch`, never committed). Under an
environment variable, the build ORs the candidates' references into the tail's marks; every unit of every corpus was
then compiled by `--selection-census -c` with and without the variable (`raw/local/tail`, `raw/local/tail-g`):

- every object was the same bytes, with `-g` too;
- the census lines were the same; only the census's TSC ticks differ, as they differ between any two runs.

The tail's marks decide only the program's own numbering and states, which the selection makes again from its own
references (`check_program_select_mode`'s `check_program_alias_number`).

## What was run

`scripts/run.sh` ran as a user unit on the host:

1. both builds;
2. one hold of the lock a corpus for `scripts/census.sh`: each unit by both builds' `--selection-census -c`, then by the
   head's `-c` and `--provisional-selection -c`, with the objects compared;
3. one hold a file for `scripts/repeat.sh`: `sqlite3.c` and `main.c`, 7 rounds, each build's census, `-c` and
   `--provisional-selection -c`, the builds' order swapped every round, `-c`'s counted by `perf stat`.

Every compile ran on CPU 2 with `--lanes 1`. The corpora are step 1's: `sqlite3.c`, Lua's 34 sources, c-testsuite's 220
programs, `main.c` (the head's) and musl's 1,336 units.

## The objects

| corpus | units | census the same as the base's | provisional: serves, extra symbols, objects the same |
| --- | ---: | ---: | --- |
| `sqlite3.c` | 1 | 1 | 1, 5, 1 |
| `main.c` | 1 | 1 | 1, 78, 1 |
| Lua | 34 | 34 | 34, 0, 34 |
| c-testsuite | 220 | 220 | 220, 17, 220 |
| musl | 1,336 | 1,336 | 1,336, 27, 1,336 |

Each unit's line is in `raw/9700x/NAME.txt`. A cloud container's Develop build compared the plain path against the
commit before the split (buster `080c44ab`'s code): every object, stderr and exit status was the same, plain, with
`-Wall -Wextra` and with `-g` (`raw/local/c-*`). It also checked `--provisional-selection` against `-c`, with and without
`-g` (`raw/local/provisional*`).

That comparison found one difference on the way. A statement expression's region recorded its body as the program's
body count so far, which the setup now sets to every body's, and c-testsuite's `00213.c` gained a `-Wuninitialized`
warning with `-Wall -Wextra`. The writer now keeps the index of the body it builds (`CheckControlWriter.body`).

## The compile

| file | build | task clock | user cycles | user instructions |
| --- | --- | ---: | ---: | ---: |
| `sqlite3.c` | 2.2c.1 | 122.18 ms | 594.29 M | 1,362.786 M |
| `sqlite3.c` | 2.2c.2 | 122.46 ms | 595.90 M | 1,363.339 M |
| `main.c` | 2.2c.1 | 692.01 ms | 3,505.40 M | 10,703.367 M |
| `main.c` | 2.2c.2 | 692.77 ms | 3,510.58 M | 10,704.448 M |

These are medians of 7 runs each (`raw/9700x/NAME.SIDE.plain.N.csv`).

- **Instructions:** 0.55 M more on `sqlite3.c` and 1.08 M more on `main.c`, from writing the bodies' own fields in the
  setup.
- **Time:** within the runs' spread.
- **The objects** of the last rounds are the same bytes by both builds, and by `-c` and `--provisional-selection -c`
  (`raw/9700x/NAME.*.same.txt`).

## Files

- `raw/9700x/`: the census lines and ticks, the repeats' counts, the object comparisons, the holds' log and the builds'.
- `raw/local/`: the cloud container's comparisons and the tail experiment.
- `scripts/`: every script as run, and the experiment's patch.
- `SHA256SUMS`: every file's hash.
