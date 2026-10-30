# clang's musttail, lowered to Tier 0's tail calls (#147), 2026-10-30

buster14a/buster's branch `claude/147-musttail` makes the checker take clang's `musttail` on a return statement and
compiles it to a tail call: a `TAIL_CALL` kind in Tier 0's typed stream, its teardown in the unwind tables, and the
front end's checks of clang 23's rules. This record compares the branch's build with main's on the 9700X.

## Sources

- main: `b424fe30cd29bb6fb6791fc1aa85c37287173150`
- head: `d6e7dc2b0120b222377c6e5febf78f02ee7a393f`, the pull request's head

Each tree is `git archive` of its commit, with a `COMMIT` file (`logs/COMMIT-*`), built on the host with
`BUSTER_DEBUG_INFO=0 ./build.sh` under the host's lock (`scripts/build-tree.sh`; main's build is the one
`x86-builtins-148-2026-10-30` timed, the same executable, and `scripts/measure-ab.sh` builds the head). The
executables' SHA-256 are in `logs/hostinfo-musttail.out` (`main-b424fe30` `19866027...`, `musttail-d6e7dc2b`
`2c10bae5...`), and the input's (`sqlite3.c`, `0a409f16...`).

## Host

`logs/hostinfo-musttail.out`: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9, CPU 2 at the
`performance` governor and EPP. Every run took the host's lock alone (`~/buster-fast-bench/exclusive.sh`, through
`ab --lock` for the timed processes) and ran on CPU 2. The logs keep only the lines the scripts, `ab` and `time-runs`
print.

## Commands

`scripts/queue-e.sh` ran `scripts/measure-ab.sh main-b424fe30 musttail-d6e7dc2b musttail ...`: the frozen `sqlite3.c`
(the CI corpus's, with `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5
-DSQLITE_ENABLE_RTREE -I$S`) by `-c` from each tree, the objects compared; `ab --rounds 5 --cpu 2 --lock exclusive.sh
./main ./head -- time-runs --runs 21 --list -c ...`, five rounds whose trees' order rotates (`logs/ab-musttail.log`);
and three `perf stat -e instructions:u` runs of each tree's `-c` (`logs/stat-musttail-*.csv`, their statuses in
`logs/measure-musttail.out`).

## Results

- **Output:** `sqlite3.c`'s object is the same bytes from both trees.
- **Instructions** (`perf stat`, three runs each, all exit status 0): 1,334,358,853 to 1,334,358,866 on main and
  1,337,362,036 to 1,337,362,041 at the head (+3,003,183, +0.225%). `sqlite3.c` has no musttail return; the pull
  request's description has the 7940HS's bisection of the increase by commit.
- **`-c` time** (`logs/ab-musttail.log`, one placement, medians of five rounds' medians of 21 processes): 128.790 ms on
  main and 128.966 ms at the head (+0.14%; round medians 128.675 to 128.923 and 128.815 to 129.113), user cycles
  606.73M and 606.44M (−0.05%).

## Limitations

- One input, `sqlite3.c`, which has no musttail return.
- One placement: the code's placement moves a time this size (`docs/profiling.md`'s "Comparing two versions").
- The 7940HS ran the tests (the pull request's description); this host ran no test.
