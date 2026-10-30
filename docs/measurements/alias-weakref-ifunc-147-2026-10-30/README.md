# GNU's alias, ifunc, weakref and retain attributes (#147), 2026-10-30

buster14a/buster's branch `claude/147-alias-weakref-ifunc` makes `-c`'s objects and the direct path's executables
have the symbols GNU's alias, ifunc and weakref attributes name, and keeps a retained definition's section. This
record compares the branch's build with main's on the 9700X, on a unit without those attributes.

## Sources

- main: `7f8577861b5836b62689aa61b28155815ca5ecb3`
- head: `2402c9d22afc280bc279e07a1dd534e8edd02e2a` (the branch's three commits and its merge of main)

Each tree is `git archive` of its commit, with a `COMMIT` file (`logs/COMMIT-*`), built on the host with
`BUSTER_DEBUG_INFO=0 ./build.sh` under the host's lock (`scripts/build-tree.sh`; main's build is the one
`musl-inline-asm-147-2026-10-30` timed, the same executable). The executables' SHA-256 are in `logs/hostinfo-alias.out`
(`main-7f857786` `6c6526f8...`, `alias-2402c9d2` `4d673915...`), and the input's (`sqlite3.c`, `0a409f16...`).

## Host

`logs/hostinfo-alias.out`: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9, CPU 2 at the
`performance` governor and EPP. Every run took the host's lock alone (`~/buster-fast-bench/exclusive.sh`, through
`ab --lock` for the timed processes) and ran on CPU 2. `logs/measure-alias.out` keeps only the lines the script
prints.

## Commands

`scripts/queue-b.sh` ran `scripts/measure-ab.sh main-7f857786 alias-2402c9d2 alias ...`: the frozen `sqlite3.c` (the
CI corpus's, with `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE
-I$S`) by `-c` from each tree, the objects compared; `ab --rounds 5 --cpu 2 --lock exclusive.sh ./main ./head --
time-runs --runs 21 --list -c ...`, five rounds whose trees' order rotates (`logs/ab-alias.log`); and three `perf stat
-e instructions:u` runs of each tree's `-c` (`logs/stat-alias-*.csv`, their statuses in `logs/measure-alias.out`).

## Results

- **Output:** `sqlite3.c`'s object is the same bytes from both trees.
- **Instructions** (`perf stat`, three runs each, all exit status 0): 1,334,385,092 to 1,334,385,099 on main and
  1,334,511,583 to 1,334,511,592 at the head: +126,500 (+0.0095%), which this record doesn't attribute.
- **`-c` time** (`logs/ab-alias.log`, one placement, medians of five rounds' medians of 21 processes): 129.050 ms on
  main and 128.006 ms at the head (−0.81%; the head's round medians 127.867 to 128.101, main's 128.996 to 129.169),
  user cycles 607.09M and 600.66M (−1.06%). The cause of this one-placement timing difference
  remains unresolved, with placement a possible contributor. This record claims no gain.

## Limitations

- One input, `sqlite3.c`, which has none of these attributes: the passes that only a unit with them makes aren't
  timed.
- One placement: the code's placement moves a time this size (`docs/profiling.md`'s "Comparing two versions").
- The 7940HS ran the tests (the pull request's description); this host ran no test.
