# musl's inline assembly: prefix statements, register variables and x87 operands (#147), 2026-10-30

buster14a/buster's branch `claude/147-musl-asm` makes buster compile musl's x86_64 inline assembly: a lock or rep
prefix written as a statement of its own, the instructions musl's templates use, explicit register variables as
operands, and the x87's `t` and `u` constraints. This record compares the branch's builds with main's on the 9700X:
first the branch as it was (`1398de7b`), which showed an AT&T parsing regression, then the branch with its fix
(`c169c6ee`, whose tree is the pushed `07a5ae89`'s).

## Sources

- main: `7f8577861b5836b62689aa61b28155815ca5ecb3`
- head, first run: `1398de7bc7776b112633579d2414ca7f34934a68` (the branch's three commits and its merge of main)
- head, second run: `c169c6ee4d71bf4537719bbcd1cbdc2f3cbe576b` (with the CI floor's commit and the fix), the tree
  `dbf7d9d97fef29710edbdf85833ed3f24a90434d` of the pushed `07a5ae890c3e78d1a8ed4c4f75fd65fdf33b3b2b`, whose commit
  message alone differs

Each tree is `git archive` of its commit, with a `COMMIT` file (`logs/COMMIT-*`), built on the host with
`BUSTER_DEBUG_INFO=0 ./build.sh` under the host's lock (`scripts/build-tree.sh`; the last line of each build's log is
in `logs/build-*.log`). The executables' SHA-256 are in `logs/hostinfo-asm.out` and `logs/hostinfo-asm2.out`
(`main-7f857786` `6c6526f8...`, `asm-1398de7b` `02fc1f39...`, `asm-c169c6ee` `bc02aa7e...`), and the input's
(`sqlite3.c`, `0a409f16...`).

## Host

`logs/hostinfo-asm.out`: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9, CPU 2 at the
`performance` governor and EPP. Every run took the host's lock alone (`~/buster-fast-bench/exclusive.sh`, through
`ab --lock` for the timed processes) and ran on CPU 2. `logs/measure-asm*.out` keep only the lines the scripts print:
the lock's waiting messages, which name other sessions' commands, are left out (4 lines of `measure-asm2.out`).

## Commands

1. `scripts/measure-asm.sh` (main against `1398de7b`): the frozen `sqlite3.c` (the CI corpus's, with
   `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$S`) by `-c`
   from each tree, the objects compared; `ab --rounds 5 --cpu 2 --lock exclusive.sh ./main ./head -- time-runs
   --runs 21 --list -c ...`, five rounds whose trees' order rotates (`logs/ab-asm.log`); three `perf stat -e
   instructions:u` runs of each tree's `-c` (`logs/stat-*.csv`, their statuses in `logs/measure-asm.out`); then
   `benchmark-assembler` with each of its four workloads (the default mixed Intel one, `--workload registers`,
   `simd` and `att`), a process each, five rounds alternating the trees (`logs/asmbench/TREE-WORKLOAD-ROUND.txt`).
2. `scripts/measure-asm2.sh` (main against `c169c6ee`): the objects compared, three `perf stat` runs of each tree's
   `-c` (`logs/stat2-*.csv`), and `benchmark-assembler` as above (`logs/asmbench2/`).

## Results

- **Output:** `sqlite3.c`'s object is the same bytes from main and both heads (`logs/measure-asm*.out`).
- **Instructions** (`perf stat`, three runs each, all exit status 0): `-c` 1,334,385,091 to 1,334,385,123 on main,
  1,334,359,690 to 1,334,359,696 at `1398de7b` and 1,334,359,722 to 1,334,359,875 at `c169c6ee` (−25,300,
  −0.0019%), which this record doesn't attribute.
- **`-c` time** (`logs/ab-asm.log`, one placement, medians of five rounds' medians of 21 processes): 128.974 ms on
  main and 128.546 ms at `1398de7b` (−0.33%; the head's round medians 128.450 to 128.665 were below main's 128.838
  to 129.137 in every round), user cycles 606.88M and 604.47M (−0.40%). The default path's code doesn't change, so
  this is the code's placement, not a gain this record claims.
- **`benchmark-assembler`**, medians of five processes of each tree's total milliseconds (each process a 21-pass
  median):

| Workload, path | main | `1398de7b` | | main | `c169c6ee` | |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| mixed, scalar | 3.645 | 3.739 | +2.6% | 3.658 | 3.711 | +1.4% |
| mixed, vector | 1.467 | 1.475 | +0.5% | 1.475 | 1.475 | 0.0% |
| registers, scalar | 3.428 | 3.445 | +0.5% | 3.327 | 3.403 | +2.3% |
| registers, vector | 1.165 | 1.159 | −0.5% | 1.160 | 1.162 | +0.2% |
| simd, scalar | 3.943 | 3.762 | −4.6% | 3.859 | 3.881 | +0.6% |
| simd, vector | 1.724 | 1.754 | +1.7% | 1.754 | 1.732 | −1.3% |
| att, scalar | 3.503 | 4.049 | +15.6% | 3.479 | 3.488 | +0.3% |
| att, vector | 1.638 | 2.207 | +34.7% | 1.657 | 1.666 | +0.5% |

  The scalar path's processes vary by up to 0.4 ms between rounds (`logs/asmbench*/`), the vector path's by about
  0.03 ms. At `1398de7b` the AT&T workload's parse phase took 1.283 ms on the vector path against main's 0.725 (and
  2.205 against 1.668 on the scalar one): every AT&T mnemonic was compared with each row of `asm_att_extension`'s
  table, which the branch's x87 integer suffixes took from 17 rows to 31, about 55 ns more for each of its 9,984
  instructions. The fix (`c169c6ee`) scans only the rows a mnemonic's first letter can match; its AT&T parse phase
  takes 0.736 ms on the vector path against main's 0.733, and 1.645 against 1.613 on the scalar one.

## Limitations

- One input for `-c`, `sqlite3.c`, which has no inline assembly: what the branch adds (the asm statements' operands
  and the assembler's new forms) isn't timed on musl's units, whose templates are a few instructions each.
- `benchmark-assembler`'s workloads are generated, not musl's templates, and use none of the new forms; they time
  the parser and matcher every assembly goes through.
- The 7940HS ran the tests (the pull request's description); this host ran no test.
