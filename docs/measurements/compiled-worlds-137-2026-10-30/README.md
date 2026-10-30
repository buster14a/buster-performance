# The compiled ABI worlds' remaining types (#137), 2026-10-30

buster14a/buster's branch `claude/137-compiled-worlds-rest` makes the lowering pass `_Complex __bf16`, `_Atomic`
half-precision values and `_Atomic` vectors of 4 and 8 bytes, and makes `test-calling-convention --cross-check`'s
compiled runs draw `_Float16`, `__bf16`, their complex types, vectors of 4 and 8 bytes and `_Atomic`s. This record
compares the branch's build with main's on the 9700X, and keeps the laptop's sweep of the cross-check.

## Sources

- main: `7f8577861b5836b62689aa61b28155815ca5ecb3`
- head: `cda3a412dd0e33fe9cca8d2ad6171d2cbb7a076e` (the branch's four commits and its merge of main)

Each tree is `git archive` of its commit, with a `COMMIT` file (`logs/COMMIT-*`), built on the host with
`BUSTER_DEBUG_INFO=0 ./build.sh` under the host's lock (`scripts/build-tree.sh`; main's build is the one
`musl-inline-asm-147-2026-10-30` timed, the same executable). The executables' SHA-256 are in `logs/hostinfo-worlds.out`
(`main-7f857786` `6c6526f8...`, `worlds-cda3a412` `53c53bc6...`), and the input's (`sqlite3.c`, `0a409f16...`).

## Host

`logs/hostinfo-worlds.out`: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9, CPU 2 at the
`performance` governor and EPP. Every run took the host's lock alone (`~/buster-fast-bench/exclusive.sh`, through
`ab --lock` for the timed processes) and ran on CPU 2. `logs/measure-worlds.out` keeps only the lines the script
prints.

## Commands

- `scripts/queue-b.sh` ran `scripts/measure-ab.sh main-7f857786 worlds-cda3a412 worlds ...`: the frozen `sqlite3.c`
  (the CI corpus's, with `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5
  -DSQLITE_ENABLE_RTREE -I$S`) by `-c` from each tree, the objects compared; `ab --rounds 5 --cpu 2 --lock
  exclusive.sh ./main ./head -- time-runs --runs 21 --list -c ...`, five rounds whose trees' order rotates
  (`logs/ab-worlds.log`); and three `perf stat -e instructions:u` runs of each tree's `-c` (`logs/stat-worlds-*.csv`,
  their statuses in `logs/measure-worlds.out`).
- On the 7940HS (Zen 4, clang 23.1.4, GCC 16.2.1), not this host: `scripts/sweep.sh m1 1 36` ran the head's build's
  `test-calling-convention --cross-check --seed N` for seeds 1 to 36, each through the laptop's core queue
  (`logs/sweep/m1-sweep.txt`, a line per seed), and `scripts/totals.sh` summed its runs (`logs/sweep/totals.txt`).

## Results

- **Output:** `sqlite3.c`'s object is the same bytes from both trees.
- **Instructions** (`perf stat`, three runs each, all exit status 0): 1,334,385,095 to 1,334,385,110 on main and
  1,334,357,527 to 1,334,357,531 at the head (−27,567, −0.0021%), which this record doesn't attribute.
- **`-c` time** (`logs/ab-worlds.log`, one placement, medians of five rounds' medians of 21 processes): 129.085 ms on
  main and 128.865 ms at the head (−0.17%; round medians 128.926 to 129.090 and 128.598 to 129.145), user cycles
  607.94M and 606.12M (−0.30%): within the code's placement.
- **The sweep:** every seed's runs pass. Against clang, the compiled runs' 28,800 signatures of 173,491 arguments made
  544,954 checks; against GCC, 28,800 of 170,607 made 536,762; the record runs made 610,406 against clang and 609,530
  against GCC, and the extension runs 72,288 (`logs/sweep/totals.txt`). These are the counts the branch's
  `docs/calling-convention.md` gives, which the branch's build before its merge of main made too.

## Limitations

- One input for `-c`, `sqlite3.c`, which has none of the types the branch adds.
- One placement for the times.
- The sweep is the laptop's: it checks values against clang's and GCC's code there, and times nothing.
