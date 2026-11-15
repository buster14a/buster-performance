# check_program in parts (buster#2536, step 2.2c.1, 2026-11-15)

Step 2.2c moves `check_program`'s per-body loop into the windows. Its first sub-step is a restructuring that changes no
output. `check_program` becomes three parts, which keep their state in a `CheckProgramRun`:

- `check_program_begin`: the setup, with the candidates' pass;
- `check_program_bodies`: the loop over a range of bodies;
- `check_program_finish`: the tail.

`check_program` calls them in a row, with the loop a body at a time, as the windows will later call it a window's
bodies at a time. The gate: every object and diagnostic is the same bytes, and the compile is not slower.

The executables are buster `17b9fd73035729ba9b4d73740df85a1a6a68d40b` and its base, `a496d089` (buster#2816's head)
(`raw/commit.txt`). Both are Release builds made under the 9700X's lock (`raw/9700x/build.*.log`, each with its
SHA-256).

**In short.** On all 1,592 units of the corpora, the objects, stderr and exit statuses are the same as the base's. On
the 9700X the compile is within the runs' spread, and its user instructions drop by about 0.2 M on `sqlite3.c` and
1.1 M on `main.c`.

## What was run

`scripts/run.sh` ran as a user unit on the host:

1. both builds;
2. one hold of the lock a corpus for `scripts/objects.sh`: each unit by both builds' `-c`, the objects and stderr
   compared;
3. one hold a file for `scripts/repeat.sh`: `sqlite3.c` and `main.c`, 7 rounds, each build's census, `-c` and
   `--provisional-selection -c`, the builds' order swapped every round, `-c`'s counted by `perf stat`.

Every compile ran on CPU 2 with `--lanes 1`. The corpora are step 1's: `sqlite3.c`, Lua's 34 sources, c-testsuite's 220
programs, `main.c` (the head's) and musl's 1,336 units.

## The objects

| corpus | units | objects the same | stderr the same | exit statuses the same |
| --- | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 1 | 1 | 1 | 1 |
| `main.c` | 1 | 1 | 1 | 1 |
| Lua | 34 | 34 | 34 | 34 |
| c-testsuite | 220 | 220 | 220 | 220 |
| musl | 1,336 | 1,336 | 1,336 | 1,336 |

Each unit's line is in `raw/9700x/NAME.txt`. A cloud container's Develop builds compared the same way, against the
commit before the split (buster `080c44ab`'s code). Every unit was the same, plain, with `-Wall -Wextra` and with `-g`
(`raw/local/`, `scripts/local-compare.sh`).

## The compile

| file | build | task clock | user cycles | user instructions |
| --- | --- | ---: | ---: | ---: |
| `sqlite3.c` | base | 122.54 ms | 596.73 M | 1,362.974 M |
| `sqlite3.c` | 2.2c.1 | 122.78 ms | 597.45 M | 1,362.786 M |
| `main.c` | base | 695.22 ms | 3,518.81 M | 10,704.478 M |
| `main.c` | 2.2c.1 | 691.97 ms | 3,506.12 M | 10,703.370 M |

These are medians of 7 runs each (`raw/9700x/NAME.SIDE.plain.N.csv`). The loop uses the run's writer and options in
place. A copy of the writer in and out of each call, about 640 bytes twice a body, would have cost `main.c` 11 MB of
copies. The pass's ratio is unchanged: 0.404 on `sqlite3.c` and 0.426 on `main.c` (`raw/9700x/NAME.repeat.txt`). The
objects of the last rounds are the same bytes by both builds (`raw/9700x/NAME.sides.same.txt`).

## Files

- `raw/9700x/`: the objects' lines, the repeats' counts and ticks, the holds' log and the builds'.
- `raw/local/`: the cloud container's comparisons.
- `scripts/`: every script as run.
- `SHA256SUMS`: every file's hash.
