# clang's other x86 builtins by an immediate and a predicate (#148), 2026-10-30

buster14a/buster's branch `claude/148-x86-builtins-rest` makes the checker take 217 more of clang 23's x86 builtins,
past the frozen own-main inventory: the unsigned compares, rotates, shuffles, permutes, blends, elements and lanes,
ternary logic, concatenating shifts, products, AVX-512's operations of floats by an immediate and the compares of
floats by a predicate, each lowered as clang -O0's code computes it. This record compares the branch's build with
main's on the 9700X.

## Sources

- main: `b424fe30cd29bb6fb6791fc1aa85c37287173150`
- head: `7fa5820a1f3cc3d007f7e20e9678ad684a9ba660`, the pull request's head

Each tree is `git archive` of its commit, with a `COMMIT` file, built on the host with `BUSTER_DEBUG_INFO=0
./build.sh` under the host's lock (`scripts/build-tree.sh`, through `scripts/queue-d.sh`; `scripts/measure-ab.sh`
builds the head again before it measures, `logs/build-x86-7fa5820a.log`). The executables' SHA-256 are in
`logs/hostinfo-x86.out` (`main-b424fe30` `19866027...`, `x86-7fa5820a` `0f15cefd...`), and the input's (`sqlite3.c`,
`0a409f16...`).

## Host

`logs/hostinfo-x86.out`: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9, CPU 2 at the
`performance` governor and EPP. Every run took the host's lock alone (`~/buster-fast-bench/exclusive.sh`, through
`ab --lock` for the timed processes) and ran on CPU 2. The logs keep only the lines the scripts, `ab` and `time-runs`
print.

## Commands

`scripts/queue-d.sh` built both trees and ran `scripts/measure-ab.sh main-b424fe30 x86-7fa5820a x86 ...`: the frozen
`sqlite3.c` (the CI corpus's, with `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5
-DSQLITE_ENABLE_RTREE -I$S`) by `-c` from each tree, the objects compared; `ab --rounds 5 --cpu 2 --lock exclusive.sh
./main ./head -- time-runs --runs 21 --list -c ...`, five rounds whose trees' order rotates (`logs/ab-x86.log`); and
three `perf stat -e instructions:u` runs of each tree's `-c` (`logs/stat-x86-*.csv`, their statuses in
`logs/measure-x86.out`).

## Results

- **Output:** `sqlite3.c`'s object is the same bytes from both trees.
- **Instructions** (`perf stat`, three runs each, all exit status 0): 1,334,358,856 to 1,334,358,860 on main and
  1,334,390,294 to 1,334,390,303 at the head (+31,440, +0.0024%), which this record doesn't attribute.
- **`-c` time** (`logs/ab-x86.log`, one placement, medians of five rounds' medians of 21 processes): 128.928 ms on
  main and 128.685 ms at the head (−0.19%; round medians 128.842 to 129.089 and 128.529 to 128.861), user cycles
  606.84M and 605.17M (−0.28%).

## Limitations

- One input, `sqlite3.c`, which calls none of the added builtins.
- One placement: the code's placement moves a time this size (`docs/profiling.md`'s "Comparing two versions").
- The 7940HS ran the tests (the pull request's description); this host ran no test.
