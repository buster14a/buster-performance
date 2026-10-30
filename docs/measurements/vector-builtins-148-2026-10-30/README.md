# clang 23's other generic vector builtins (#148), 2026-10-30

buster14a/buster's branch `claude/148-vector-builtins-rest` makes the checker take clang 23's 52 generic vector
builtins past the 23 its catalog had, lowers 42 of them as clang -O0's code computes them, and gives a padded
vector's reductions the operation's identity in the lanes past its elements. This record compares the branch's build
with main's on the 9700X, twice: at `16d2c4ef`, and at the pushed head `ce0981f6`, whose last two commits refuse a
padded vector's floating maximum and minimum and let the program builder take a vector builtin's fourth argument.

## Sources

- main: `7f8577861b5836b62689aa61b28155815ca5ecb3`
- head, first run: `16d2c4ef` (`logs/COMMIT-vectors-16d2c4ef`)
- head, second run: `ce0981f6` (`logs/COMMIT-vectors-ce0981f6`), the pull request's head

Each tree is `git archive` of its commit, with a `COMMIT` file, built on the host with `BUSTER_DEBUG_INFO=0
./build.sh` under the host's lock (`scripts/build-tree.sh`; main's build is the one `musl-inline-asm-147-2026-10-30`
timed, the same executable). The executables' SHA-256 are in `logs/hostinfo-vectors.out` and
`logs/hostinfo-vectors2.out`, and the input's (`sqlite3.c`, `0a409f16...`).

## Host

`logs/hostinfo-vectors.out`: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9, CPU 2 at the
`performance` governor and EPP. Every run took the host's lock alone (`~/buster-fast-bench/exclusive.sh`, through
`ab --lock` for the timed processes) and ran on CPU 2. `logs/measure-vectors*.out` keep only the lines the script
prints.

## Commands

`scripts/measure-ab.sh main-7f857786 HEAD TAG ...` (the first run through `scripts/queue-c.sh`): the frozen
`sqlite3.c` (the CI corpus's, with `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5
-DSQLITE_ENABLE_RTREE -I$S`) by `-c` from each tree, the objects compared; `ab --rounds 5 --cpu 2 --lock exclusive.sh
./main ./head -- time-runs --runs 21 --list -c ...`, five rounds whose trees' order rotates (`logs/ab-vectors*.log`);
and three `perf stat -e instructions:u` runs of each tree's `-c` (`logs/stat-vectors*-*.csv`, their statuses in
`logs/measure-vectors*.out`).

## Results

- **Output:** `sqlite3.c`'s object is the same bytes from both trees, in both runs.
- **Instructions** (`perf stat`, three runs each, all exit status 0): at `16d2c4ef`, 1,334,385,087 to 1,334,385,093 on
  main and 1,334,431,652 to 1,334,431,802 at the head (+46,570, +0.0035%); at `ce0981f6`, 1,334,384,955 to
  1,334,385,113 on main and 1,334,433,747 to 1,334,433,753 at the head (+48,711, +0.0037%). This record doesn't
  attribute them.
- **`-c` time** (`logs/ab-vectors*.log`, one placement, medians of five rounds' medians of 21 processes):
  - at `16d2c4ef`: 128.921 ms on main and 128.569 ms at the head (−0.27%; round medians 128.817 to 129.056 and
    128.443 to 128.662), user cycles 606.62M and 602.41M (−0.69%);
  - at `ce0981f6`: 129.109 ms on main and 128.617 ms at the head (−0.38%; round medians 128.935 to 129.211 and
    128.527 to 128.844), user cycles 607.42M and 605.03M (−0.39%).

## Limitations

- One input, `sqlite3.c`, which calls none of the added builtins.
- One placement: the code's placement moves a time this size (`docs/profiling.md`'s "Comparing two versions").
- The 7940HS ran the tests (the pull request's description); this host ran no test.
