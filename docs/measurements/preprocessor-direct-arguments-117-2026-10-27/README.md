# Arguments of direct objects expanded in place (buster#117)

On the Ryzen 7 9700X (`benchpress`), 2026-10-27. Main is buster `530304fc` and the branch is
`claude/117-expanded-arguments` at `0a855133`. Every build and timed process took the host's lock alone
(`scripts/locked.sh`), pinned to CPU 2. The inputs are the frozen `sqlite3.c` and `main.c` command lines of
`scripts/args.sh` (`preprocessor-corpora-astra-01a158dd`, from `preprocessor-paste-templates-117-2026-10-26`). The
lock's messages about other holders are cut from the logs.

`scripts/queue1.sh` builds each tree with #509's `build.sh shifts`, with the preprocessor's unit
(`main_unit_frontend.c`) at six placements: 0, 704, 1,408, 2,112, 2,816 and 3,520 bytes. Its `.text` is aligned to
64, so shifts must be multiples of 64. Executables and builds are in `build-*.txt` and `sha.txt`. It then runs:

- `benchmark-preprocessor --history-cost --only scalar`, the run with the history deferred (as compiles run it), on
  `sqlite3.c` (`sqlite-BUILD-SHIFT-ROUND.txt`) and `main.c` (`mainc-*`). Each build runs at every placement, in two
  rounds with the order rotating. `again` is main's executables a second time, the floor.
- `-E`, `parse -fsyntax-only` and `-fsyntax-only` of `sqlite3.c` as whole processes, by `time-runs --runs 3 --copies 3`
  under `ab --rounds 3` (`drivers.txt`).

## The deferred run

The median of each build's 12 runs (six placements, two rounds), with their range:

| | main | branch | main again |
| --- | ---: | ---: | ---: |
| `sqlite3.c`, directive tables and main loop | 4.757 ms (4.730-4.805) | 4.623 ms (4.573-4.678) | 4.749 ms (4.718-4.799) |
| `sqlite3.c`, main loop | 4.445 ms (4.419-4.495) | 4.311 ms (4.258-4.364) | 4.436 ms (4.406-4.483) |
| `sqlite3.c`, instructions/input token | 105.56 | 102.57 | 105.56 |
| `main.c`, directive tables and main loop | 21.029 ms (20.940-21.447) | 20.848 ms (20.757-21.345) | 21.034 ms (20.937-21.155) |
| `main.c`, main loop | 20.721 ms (20.629-21.141) | 20.541 ms (20.449-21.034) | 20.723 ms (20.629-20.847) |
| `main.c`, instructions/input token | 278.23 | 276.59 | 278.23 |

The branch's placements' medians for `sqlite3.c`'s main loop are 4.283 to 4.345 ms, against main's 4.425 to 4.470 ms
and main again's 4.413 to 4.478 ms. A run's statistics (`per pass`) give its invocations' arguments expanded first.

## Whole processes

User cycles against main, per round (`drivers.txt`):

| | `-E` | `parse` | `-fsyntax-only` |
| --- | --- | --- | --- |
| branch | −0.96%, −0.83%, −1.08% | −0.90%, −0.82%, −1.04% | +0.04%, +0.08%, −0.20% |
| main again | −0.13%, +0.11%, −0.14% | −0.04%, −0.04%, −0.22% | +0.18%, −0.13%, −0.08% |

For `-E` and `parse`, the branch's ranges over placements exclude 0 in every round (`-E` −1.62% to −0.36%, `parse`
−1.79% to −0.44%). In wall time: `-E` 18.45 to 18.47 ms on main, and −0.80%, −0.65% and −0.89%; `parse` 18.27 to
18.28 ms, and −0.46%, −0.43% and −0.67%. `-fsyntax-only` (128.2 to 128.4 ms) doesn't change measurably.
