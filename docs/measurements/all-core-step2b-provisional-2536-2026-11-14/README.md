# Code numbered by the candidates' selection (buster#2536, step 2.2b, 2026-11-14)

Step 2's windows will lower before every body's references are known, so they number symbols by the candidates'
selection, a superset of the exact one. buster's `--provisional-selection` does that today, with `check_program` still
whole: `-c`'s code is numbered by the selection over step 2.2a's pass (`check_driver_provisional`), each extra symbol is a
placeholder (a local `.L` symbol without an atom) that the object leaves out, and the data are the exact selection's. The
object writer's own numbering of the symbols it keeps then compacts the rest. This record checks that the objects are the
exact selection's bytes and measures what the option costs a compile.

The executable is buster `f32c8e3fd59cca354a7a6638c12c454461a07654` (`raw/commit.txt`), on main `45cd9aec`: a Release
build under the 9700X's lock (`raw/9700x/build.log`, with its SHA-256).

**In short.** On all 1,592 units of the corpora the provisional selection serves and every object is the same bytes as
without the option, leaving out 5 extra symbols on `sqlite3.c`, 78 on `main.c`, 17 in c-testsuite and 27 in musl. The
option costs `sqlite3.c`'s compile 2.4 ms (122.6 to 125.0 ms, 2.0%) and `main.c`'s 18.6 ms (691.0 to 709.5 ms, 2.7%): the
candidates' pass and a second selection, which step 2's windows will pay once the exact selection moves after them.

## What was run

`scripts/run.sh`, a user unit on the host: the build, then one hold of the lock a corpus for `scripts/check.sh` (each unit
by `-c` and by `--provisional-selection -c`, `--lanes 1` on CPU 2, the objects compared), then one hold a file for
`scripts/repeat.sh` (`sqlite3.c` and `main.c` the two ways, alternating, 7 runs each, counted by `perf stat`). The corpora
are step 1's: `sqlite3.c`, Lua's 34 sources, c-testsuite's 220 programs, `main.c` (the commit's) and musl's 1,336 units.

## The objects

| corpus | units | the provisional selection serves | extra symbols left out | objects the same bytes |
| --- | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 1 | 1 | 5 | 1 |
| `main.c` | 1 | 1 | 78 | 1 |
| Lua | 34 | 34 | 0 | 34 |
| c-testsuite | 220 | 220 | 17 | 220 |
| musl | 1,336 | 1,336 | 27 | 1,336 |

Each unit's line is in `raw/9700x/NAME.txt`: its name, the option's report (whether it served, its extra symbols) and
the verdict. A cloud container's Develop build gave the same verdicts by windows of 1, 2,048 and ∞, on 8 lanes, by the
scalar path and with `-g` (`raw/local/`, `scripts/local-provisional*.sh`; its `-march=native` gives `sqlite3.c` 4 extra
symbols, the 9700X's 5).

## The cost

| file | `-c` | `--provisional-selection -c` | difference |
| --- | ---: | ---: | ---: |
| `sqlite3.c`, task clock | 122.59 ms | 125.01 ms | +2.42 ms (+2.0%) |
| its user cycles | 597.2 M | 610.4 M | +2.2% |
| its user instructions | 1,362.9 M | 1,386.2 M | +1.7% |
| `main.c`, task clock | 690.95 ms | 709.50 ms | +18.55 ms (+2.7%) |
| its user cycles | 3,505.7 M | 3,600.4 M | +2.7% |
| its user instructions | 10,696.5 M | 10,923.5 M | +2.1% |

Medians of 7 runs each way (`raw/9700x/NAME.plain.N.csv`, `NAME.provisional.N.csv`). The option adds the candidates'
pass (step 2.2a's record: 1.92 ms on `sqlite3.c`, 4.53 ms on `main.c`) and the selection over its candidates; the exact
selection still runs too. The objects of the last runs are the same bytes (`raw/9700x/NAME.same.txt`).

## Files

`raw/9700x/`: the check's lines, the repeats' counts, the holds' log and the build's. `raw/local/`: the cloud container's
variants. `scripts/`: every script as run. `SHA256SUMS`: every file's hash.
