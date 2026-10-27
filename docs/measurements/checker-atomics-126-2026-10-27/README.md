# Atomics lowered with clang's alignment: what it costs checking and lowering, 2026-10-27

Branch `claude/checker-main-c-atomics` (buster14a/buster) lowers the atomic read/modify/write builtins through
`c_builtin_atomic_rmw_helpers.c`'s leaves, works out an atomic object's alignment as clang's code generation does
(`check_graph_atomic_alignment`), and passes floating atomics as bits (#126, #148). It was stacked on #496's branch,
whose head is the base here, so the trees differ by the branch's own commits. The frozen `sqlite3.c` has atomics only
where clang's feature answers turn them on (`--clang-features`), so this measures checking with them, the whole
`-fsyntax-only` driver with them, and `-c` without them, which both trees write:

| Measure (`sqlite3.c`) | base (`c558ef52`) | head (`2665c26c`) | change |
| --- | --- | --- | --- |
| `-fsyntax-only`, user instructions (`perf stat`) | 1,597,020,820 | 1,597,018,261 | -2,559 (-0.000%) |
| `-fsyntax-only`, user cycles | 657.3 M | 655.2 M | -0.32% |
| `-fsyntax-only`, wall (`time-runs`) | 142.988 ms | 143.509 ms | +0.36% |
| `-c`, user instructions | 2,194,799,022 | 2,194,734,154 | -64,868 (-0.003%) |
| `-c`, user cycles | 868.9 M | 869.0 M | +0.02% |
| `-c`, wall (`time-runs`) | 186.567 ms | 185.609 ms | -0.51% |
| checking in the process (`benchmark-checker-source`), scalar path | 49.601 ns/node | 51.780 ns/node | +4.39% |
| checking in the process, vector path | 54.075 ns/node | 55.746 ns/node | +3.09% |

The `perf stat` rows are three rounds of `-r 11` each (`perf.log`); the `time-runs` rows are the medians of five rounds
of 21 (`-fsyntax-only`, `ab_driver.log`) and 11 (`-c`, `ab_lower.log`) processes. `benchmark-checker-source`'s rows
are the medians of five rounds of its 21 passes (`ab_source.log`). Its head rounds spread from 49.89 to 56.83 ns/node
on the scalar path (49.89, 52.14, 56.83, 50.18, 51.78) where the base's spread from 49.30 to 50.52, and from 54.24 to
59.41 on the vector path against 53.95 to 54.74: the head's fastest rounds are within 1% of the base's, while the whole
driver runs the same instructions within 2,559 and fewer cycles. A slower check would show in the driver's cycles.

Each tree's `-c` wrote the same object (`inputs.sha256`: `lower_base.o` and `lower_head.o`), and the head's `-c` with
clang's feature answers, its atomics among them, succeeded once (`atomic_head.o`). On the 9700X the head passes
`test-builtin-atomic-rmw-helpers` (66,944 checks), `test-check-builtins-atomic-rmw` (6,547),
`test-check-builtins-atomic` (2,300), `test-builtin-atomic-helpers` (920) and `test-checker` (255,179 checks, seed
133), with 0 failures against clang 23.1.1 (`test_*.log`).

## Trees

| Name | Commit | What it is |
| --- | --- | --- |
| `base` | [`c558ef52`](https://github.com/buster14a/buster/tree/c558ef52) | #496's head, the branch's base when measured |
| `head` | [`2665c26c`](https://github.com/buster14a/buster/tree/2665c26c) | the branch: the alignment walk, the read/modify/write leaves and `check_action_find_member` inlined again |

Each tree was `git archive` of its commit, sent by tar into an empty directory; `source-base.sha256` and
`source-head.sha256` hold the SHA-256 of each of its files, and `inputs.sha256` the executables', the objects', the
inputs' and the host's kernel and clang. Each was built with `BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh`
(`build_base.log`, `build_head.log`).

Host: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, CPU 2 at the performance governor. Each build and each run
took the shared lock on its own (`EXCLUSIVE_OWNER=claude-126`); the lock's waiting messages, which name other sessions'
runs, are removed from the logs, which leaves the logs of runs that printed nothing (`drive_*.log`, `lower_*.log`,
`atomic_head.log`) empty.

## Method

`abE.sh` ran it, and `abE2.sh` its last steps again (`abE.log` is both scripts' output): the first run stopped while
its `ab` of `-c` waited for the lock, whose partial log is `ab_lower_interrupted.log`, and `abE2.sh` ran that `ab` and
the `perf stat` rounds from the start. The inputs and options are those of
[#475's record](../char-signedness-475-2026-10-26/README.md): the preprocessor oracle's frozen `sqlite/sqlite3.c` with
the pinned gnu17 predefines, `-march=znver5 -std=gnu17 -nostdinc` and the corpus's system directories,
`SOURCE_DATE_EPOCH=1792454400`, `CPATH`/`C_INCLUDE_PATH` unset; with `--clang-features` for checking and
`-fsyntax-only`, without it for `-c`:

- the head's four atomic suites and `test-checker --seed 133`;
- each tree's `-fsyntax-only` and `-c` once (status 0 on all), whose objects compare equal, and the head's `-c` with
  `--clang-features`;
- `build/compiler ab --rounds 5 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh base head` of
  `benchmark-checker-source` (with `--no-default-config`), of `time-runs --runs 21 --list -fsyntax-only` and of
  `time-runs --runs 11 --list -c -o /dev/null`;
- three rounds, each tree in turn, of `perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2` of the
  whole `-fsyntax-only` and of `-c -o /dev/null`.

## Limits

One input. The in-process benchmark's spread on the head isn't explained here: code placement moves this benchmark by
about 2% between builds of the same source (#502), and the head's change to `check_action_find_member`'s inlining moves
the checker's code. The branch has merged main since (`fe9f9f63`), which brings main's commits alone.
