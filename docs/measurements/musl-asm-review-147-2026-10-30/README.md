# musl's inline assembly after #929's review (#147), 2026-10-30

buster14a/buster's pull request #929 (`claude/147-musl-asm`) takes the inline assembly forms musl's units use. Its
review's two fixes (an x87 operand of a template of no instructions through the x87's stack, and the musl-derived test
fixtures rewritten as the test's own programs) moved its head to `a40d0817`. This record compares that head with the
main the pull request was measured against, on the 9700X, as `musl-inline-asm-147-2026-10-30` (buster-performance#152)
compared the head before the review.

## Sources

- main: `7f8577861b5836b62689aa61b28155815ca5ecb3`
- head: `a40d0817c08506708bc08d298089afae952121ae`, the pull request's head

Each tree is `git archive` of its commit, with a `COMMIT` file (`logs/COMMIT-*`), built on the host with
`BUSTER_DEBUG_INFO=0 ./build.sh` under the host's lock (`scripts/build-tree.sh`, which `scripts/measure-ab.sh` runs for
the head; main's build is the one the earlier records timed, the same executable). The executables' SHA-256 are in
`logs/hostinfo-asm3.out` (`main-7f857786` `6c6526f8...`, `asm-a40d0817` `a72c4631...`), and the input's (`sqlite3.c`,
`0a409f16...`).

## Host

`logs/hostinfo-asm3.out`: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9, CPU 2 at the
`performance` governor and EPP. Every run took the host's lock alone (`~/buster-fast-bench/exclusive.sh`, through
`ab --lock` for the timed processes) and ran on CPU 2. The logs keep only the lines the scripts, `ab` and `time-runs`
print.

## Commands

`scripts/queue-g.sh` ran `scripts/measure-ab.sh main-7f857786 asm-a40d0817 asm3 ...`: the frozen `sqlite3.c` (the CI
corpus's, with `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$S`)
by `-c` from each tree, the objects compared; `ab --rounds 5 --cpu 2 --lock exclusive.sh ./main ./head -- time-runs
--runs 21 --list -c ...`, five rounds whose trees' order rotates (`logs/ab-asm3.log`); and three `perf stat -e
instructions:u` runs of each tree's `-c` (`logs/stat-asm3-*.csv`, their statuses in `logs/measure-asm3.out`).

## Results

- **Output:** `sqlite3.c`'s object is the same bytes from both trees.
- **Instructions** (`perf stat`, three runs each, all exit status 0): 1,334,384,983 to 1,334,384,994 on main and
  1,334,379,442 to 1,334,379,478 at the head (−5,541, −0.0004%).
- **`-c` time** (`logs/ab-asm3.log`, one placement, medians of five rounds' medians of 21 processes): 129.042 ms on
  main and 129.054 ms at the head (+0.01%; round medians 128.923 to 129.100 and 128.969 to 129.126), user cycles
  607.53M and 607.39M (−0.02%).

## Limitations

- One input, `sqlite3.c`, which has no inline assembly the change concerns.
- One placement: the code's placement moves a time this size (`docs/profiling.md`'s "Comparing two versions").
- The 7940HS ran the tests (the pull request's review reply); this host ran no test.
