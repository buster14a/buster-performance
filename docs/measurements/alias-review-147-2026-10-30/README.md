# GNU's alias attributes after #930's review (#147), 2026-10-30

buster14a/buster's pull request #930 (`claude/147-alias-weakref-ifunc`) emits GNU's `alias`, `ifunc`, `weakref` and
`retain` attributes. Its review's two fixes (alias targets by their emitted ABI names, and aliases defined before the
IR's test runs keep the source's link) moved its head to `3030eb24`. This record compares that head with the main the
pull request was measured against, on the 9700X, as `alias-weakref-ifunc-147-2026-10-30` (buster-performance#153)
compared the head before the review.

## Sources

- main: `7f8577861b5836b62689aa61b28155815ca5ecb3`
- head: `3030eb24caa581a73397eb339301b82d2f1b05b1`, the pull request's head

Each tree is `git archive` of its commit, with a `COMMIT` file (`logs/COMMIT-*`), built on the host with
`BUSTER_DEBUG_INFO=0 ./build.sh` under the host's lock (`scripts/build-tree.sh`, which `scripts/measure-ab.sh` runs
for the head; main's build is the one the earlier records timed, the same executable). The executables' SHA-256 are in
`logs/hostinfo-alias2.out` (`main-7f857786` `6c6526f8...`, `alias-3030eb24` `3ef4ae0b...`), and the input's
(`sqlite3.c`, `0a409f16...`).

## Host

`logs/hostinfo-alias2.out`: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9, CPU 2 at the
`performance` governor and EPP. Every run took the host's lock alone (`~/buster-fast-bench/exclusive.sh`, through
`ab --lock` for the timed processes) and ran on CPU 2. The logs keep only the lines the scripts, `ab` and `time-runs`
print.

## Commands

`scripts/queue-f.sh` ran `scripts/measure-ab.sh main-7f857786 alias-3030eb24 alias2 ...`: the frozen `sqlite3.c` (the
CI corpus's, with `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE
-I$S`) by `-c` from each tree, the objects compared; `ab --rounds 5 --cpu 2 --lock exclusive.sh ./main ./head --
time-runs --runs 21 --list -c ...`, five rounds whose trees' order rotates (`logs/ab-alias2.log`); and three `perf stat
-e instructions:u` runs of each tree's `-c` (`logs/stat-alias2-*.csv`, their statuses in `logs/measure-alias2.out`).

## Results

- **Output:** `sqlite3.c`'s object is the same bytes from both trees.
- **Instructions** (`perf stat`, three runs each, all exit status 0): 1,334,385,163 to 1,334,385,174 on main and
  1,334,478,280 to 1,334,478,291 at the head (+93,117, +0.0070%), which this record doesn't attribute.
- **`-c` time** (`logs/ab-alias2.log`, one placement, medians of five rounds' medians of 21 processes): 128.989 ms on
  main and 128.157 ms at the head (−0.65%; round medians 128.955 to 129.024 and 128.049 to 128.237), user cycles
  607.36M and 601.84M (−0.91%).

## Limitations

- One input, `sqlite3.c`, which has no alias, ifunc or weakref.
- One placement: the code's placement moves a time this size (`docs/profiling.md`'s "Comparing two versions").
- The 7940HS ran the tests (the pull request's review reply); this host ran no test.
