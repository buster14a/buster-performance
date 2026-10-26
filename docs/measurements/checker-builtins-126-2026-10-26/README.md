# What the builtins of this compiler's own main.c cost checking, 2026-10-26

buster14a/buster's branch `claude/checker-main-c-builtins` checks the builtins this compiler's own `main.c` calls
(#126, #148, #133). Two of its changes are on the checker's default path: `check_graph_builtin_op` asks the atomic
read/modify/write module for a builtin's rule, and the reader counts the graph's builtin call records 32 tokens at a time
(`check_input_builtin_capacity`). This measures them on the frozen `sqlite3.c`, which calls none of the new builtins.
Median of five rounds, and of three rounds of `perf stat -r 11`:

| Measure | base (main `de480c1d`) | head (`e7c3b6a2`) | change |
| --- | --- | --- | --- |
| typed checking of the bodies, scalar path | 50.573 ns/node (279.1 cycles) | 49.790 ns/node (275.0 cycles) | -1.55% |
| typed checking of the bodies, vector path | 54.760 ns/node (303.0 cycles) | 54.018 ns/node (298.9 cycles) | -1.36% |
| whole `-fsyntax-only` driver, wall | 147.651 ms | 145.434 ms | -1.50% |
| whole driver, user instructions | 1,690,102,770 | 1,662,987,739 | -1.60% |
| whole driver, user cycles | 680.8 M | 669.1 M | -1.72% |
| whole driver, peak resident set | 598,412 to 599,384 KB | 599,304 to 599,324 KB | within the base's range |

The driver's rounds don't overlap (base 147.57 to 147.69 ms, head 145.35 to 145.57), and the head runs 27.1 million
fewer instructions. The reader used to size the builtin call records by asking every token's builtin for its op,
though nearly every token has none; the head tests 32 tokens' builtins at once and asks only for the tokens that have
one.

## The first commit's run

`first/` is the same measurement of the branch's first commit, before that change: main `d1f9dad3` against
`b8cfc237` (`abB.sh`, whose log also has the initializers' first run). There the head ran 11.4 million more
instructions than main (1,719,576,618 against 1,730,975,924, +0.66%), and the driver took 0.49% longer (148.202 ms
against 148.922), almost none of it in the bodies' typed checking (+0.18% scalar). On the laptop (7940HS), sampling
instructions (`perf record -e instructions:u -c 20011`) put the new cost in `check_builtin_atomic_rmw_rule`, a call
per token from that loop (2.9 million instructions, a function main doesn't have), and in the loop's caller. On the
laptop, main `d1f9dad3` with that count of records alone (`45e0def3`'s change to `c_check_input.c`) runs 1,686,949,641
instructions on SQLite 3.53's `sqlite3.c` against main's 1,714,581,245: the loop cost 27.6 million on main, and
about 38.5 million with the first commit's lookup in it. The branch's other changes cost 0.5 million (its head before
main's merge, `45e0def3`, runs 1,687,442,006).

## Trees

| Name | Commit | What it is |
| --- | --- | --- |
| `base` | [`de480c1d`](https://github.com/buster14a/buster/tree/de480c1d) | main, the merge-base of the head |
| `head` | [`e7c3b6a2`](https://github.com/buster14a/buster/tree/e7c3b6a2) | the branch: the builtins (`b8cfc237`), the count of records (`45e0def3`) and main merged |
| first run's base | [`d1f9dad3`](https://github.com/buster14a/buster/tree/d1f9dad3) | main then |
| first run's head | [`b8cfc237`](https://github.com/buster14a/buster/tree/b8cfc237) | the branch's first commit |

Each tree was `git archive` of its commit, sent by tar into an empty directory; `source-base.sha256` and
`source-head.sha256` hold the SHA-256 of each of its files. Each was built with `BUSTER_DEBUG_INFO=0 LC_NUMERIC=C
./build.sh` (`build_base.log`, `build_head.log`); `inputs.sha256` has the executables' and the inputs' digests.

Host: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, CPU 2 at the performance governor. Each build and each
run took the shared lock on its own (`EXCLUSIVE_OWNER=claude-126`); the lock's waiting messages, which name other
sessions' runs, are removed from the logs.

## Method

The inputs and options are those of [#475's record](../char-signedness-475-2026-10-26/README.md): the preprocessor
oracle's frozen `sqlite/sqlite3.c` with the pinned gnu17 predefines, `--clang-features`, `-march=znver5 -std=gnu17
-nostdinc` and the corpus's system directories, `SOURCE_DATE_EPOCH=1792454400`, `CPATH`/`C_INCLUDE_PATH` unset.
`abC.sh` ran both of this day's A/Bs (this one is `abc3`; `abC.log` is its output):

- each tree's `-fsyntax-only` once (status 0 on both: `drive_base.log` and `drive_head.log` are empty);
- `build/compiler ab --rounds 5 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh base head` of
  `benchmark-checker-source` (`ab_source.log`: 21 interleaved passes of typed checking over the 2,608 bodies' 311,601
  nodes, each path, after checking that both give identical results) and of `time-runs --runs 21 --list -fsyntax-only`
  (`ab_driver.log`: 21 fresh processes of the whole driver per round, with each one's wall time, rusage, peak resident
  set and page faults);
- three rounds, each tree in turn, of `perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2` of the
  whole driver (`perf.log`).

## Limits

One input. The laptop's attribution of the first run's cost is by sampling, whose shares move by about 0.1 points
between runs of one build; inlining moves some instructions between functions (`check_input_add` and
`check_input_expressions` traded about 16 million).
