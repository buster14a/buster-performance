# clang's other atomic builtins (#148), 2026-10-30

buster14a/buster's branch `claude/148-atomics-rest` implements the 160 atomic builtins clang 23.1.1 has in C on x86-64
that buster lacked: the sized legacy forms, the legacy minimum and maximum, the wrapping increment and decrement, the
byte flag, the lock-free queries, GNU's generic forms, the scoped families and the IEEE maximum and minimum. This
record compares the branch's build with main's on the 9700X.

## Sources

- main: `7f8577861b5836b62689aa61b28155815ca5ecb3`
- head: `fa9c006d6b8f5b1be701eea01aa8267dc335c62d` (the branch's commit `9f56516d` and its merge of main)

Each tree is `git archive` of its commit, with a `COMMIT` file, built on the host with `BUSTER_DEBUG_INFO=0
./build.sh` under the host's lock (`scripts/build-tree.sh`; main's build is the one `musl-inline-asm-147-2026-10-30`
timed, the same executable). The executables' SHA-256 are in `logs/hostinfo-atomics.out` (`main-7f857786`
`6c6526f8...`, `atomics-fa9c006d` `539a6267...`), and the input's (`sqlite3.c`, `0a409f16...`).

## Host

`logs/hostinfo-atomics.out`: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9, CPU 2 at the
`performance` governor and EPP. Every run took the host's lock alone (`~/buster-fast-bench/exclusive.sh`, through
`ab --lock` for the timed processes) and ran on CPU 2. `logs/measure-atomics.out` keeps only the lines the script
prints.

## Commands

`scripts/queue-c.sh` ran `scripts/measure-ab.sh main-7f857786 atomics-fa9c006d atomics ...`: the frozen `sqlite3.c`
(the CI corpus's, with `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5
-DSQLITE_ENABLE_RTREE -I$S`) by `-c` from each tree, the objects compared; `ab --rounds 5 --cpu 2 --lock exclusive.sh
./main ./head -- time-runs --runs 21 --list -c ...`, five rounds whose trees' order rotates (`logs/ab-atomics.log`);
and three `perf stat -e instructions:u` runs of each tree's `-c` (`logs/stat-atomics-*.csv`, their statuses in
`logs/measure-atomics.out`).

## Results

- **Output:** `sqlite3.c`'s object is the same bytes from both trees.
- **Instructions** (`perf stat`, three runs each, all exit status 0): 1,334,385,127 to 1,334,385,130 on main and
  1,334,014,189 to 1,334,014,198 at the head (−370,940, −0.028%), which this record doesn't attribute.
- **`-c` time** (`logs/ab-atomics.log`, one placement, medians of five rounds' medians of 21 processes): 128.956 ms on
  main and 128.670 ms at the head (−0.22%; round medians 128.836 to 129.093 and 128.494 to 128.737), user cycles
  608.24M and 604.21M (−0.66%).

## Limitations

- One input, `sqlite3.c`, which calls none of the added builtins.
- One placement: the code's placement moves a time this size (`docs/profiling.md`'s "Comparing two versions").
- The 7940HS ran the tests (the pull request's description); this host ran no test.
