# `__has_builtin` by clang's language modes and target features (#148), 2026-10-30

buster14a/buster#921 makes buster's `__has_builtin` answer as clang's does: an implemented builtin answers 1 only
where its row of clang 23.1.1's table allows the unit's language modes and its required target features hold for the
unit's target. This record compares that change's build with main's on the 9700X.

## Sources

- main: `d12fd5831f9c73bb7b30505da2ce9616e915143e`
- head: `4c2b9fad2af9cf788993fd80f0c2a0754f1cee62` (#921's branch `claude/148-has-builtin-features`)

Each tree is `git archive` of its commit, with a `COMMIT` file, built on the host with `BUSTER_DEBUG_INFO=0
./build.sh` under the host's lock (`scripts/build-tree.sh`). The executables' SHA-256 are in `logs/hostinfo-hb.out`
(`main-d12fd583/build/compiler` `7bd71b6b...`, `hb-4c2b9fad/build/compiler` `d376f2db...`), and the input's
(`sqlite3.c`, `0a409f16...`).

## Host

`logs/hostinfo-hb.out`: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9, CPU 2 at the
`performance` governor and EPP. Every run took the host's lock alone (`~/buster-fast-bench/exclusive.sh`, through
`ab --lock` for the timed processes) and ran on CPU 2. The logs keep only the lines the scripts and `ab`/`time-runs`
print: the lock's waiting messages, which name other sessions' commands, are left out.

## Commands

The frozen `sqlite3.c` (the CI corpus's) with `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0
-DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$S`, as `-E` (list 1) and `-c` (list 2):

1. `scripts/measure-hb.sh`: each tree's `-c` object and `-E` text compared; `ab --rounds 5 --cpu 2 --lock
   exclusive.sh ./main ./head -- time-runs --runs 21 --list -E ... --list -c ...`, five rounds whose trees' order
   rotates (`logs/ab-hb.log`); three `perf stat -e instructions:u` runs of each tree's `-c` and `-E`
   (`logs/stat-*.csv`, with their exit statuses in `logs/measure-hb.out`).
2. `scripts/shifts-hb.sh`, docs/profiling.md's placements (#509): each tree linked with its front end unit
   (`main_unit_frontend.c`, the preprocessor's home) shifted by 0, 704, 1408, 2112, 2816 and 3520 bytes
   (`./build.sh shifts`, `logs/shifts-*.log`; SHA-256 in `logs/shifts-sha256.txt`), then `ab --rounds 3 ...
   time-runs --runs 3 --copies 3` over main's six placements, the head's and main's again (the floor), each run from
   three fresh copies (`logs/ab-shifts-hb.log`).

## Results

- The objects and the `-E` text are byte for byte the same from both trees (`logs/measure-hb.out`).
- Instructions (`perf stat`, three runs each, all exit status 0): `-c` 1,347,062,818 to 1,347,062,822 on main and
  1,347,064,620 to 1,347,064,621 at the head (+1,800, +0.0001%); `-E` 312,143,963 to 312,143,968 and 312,146,398 to
  312,146,400 (+2,433, +0.0008%): the gates of the `__has_builtin` queries that glibc's headers make.
- One placement each (`logs/ab-hb.log`, the medians of five rounds' medians of 21 processes): `-c` 130.727 ms on main
  and 130.933 ms at the head (+0.16%; round medians 130.687 to 130.829 and 130.854 to 131.021), user cycles −0.05%;
  `-E` 19.188 and 19.351 ms (+0.85%; 19.100 to 19.320 and 19.181 to 19.471), user cycles +0.40%.
- Over six placements and three copies (`logs/ab-shifts-hb.log`, three rounds), the head against main and main
  against itself (the floor):

| | round 1 | round 2 | round 3 |
| --- | ---: | ---: | ---: |
| `-E` user cycles, head | −0.05% | −0.20% | +0.07% |
| `-E` user cycles, main again | −0.29% | −0.32% | −0.06% |
| `-E` wall, head | −0.08% | −0.31% | +0.02% |
| `-E` wall, main again | −0.28% | −0.27% | −0.15% |
| `-c` user cycles, head | −0.02% | −0.05% | +0.02% |
| `-c` user cycles, main again | −0.04% | −0.14% | +0.04% |
| `-c` wall, head | +0.03% | +0.05% | +0.13% |
| `-c` wall, main again | −0.01% | −0.10% | +0.01% |

The single placement's `-E` difference is consistent with placement sensitivity: over placements and copies the head is within
main's own floor in every round for both commands. These empirical A/A controls do not resolve a smaller changed-code cost.

## Limitations

- One input, `sqlite3.c`, whose headers query `__has_builtin` of generic builtins only; the change's per-query cost
  for an x86 builtin (the features resolved and the table evaluated for each query) isn't timed, since no header
  makes such a query.
- The 7940HS ran the tests (#921's description); this host ran no test.
