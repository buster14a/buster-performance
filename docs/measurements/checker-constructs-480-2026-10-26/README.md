# What main.c's constructs cost checking (#480), 2026-10-26

[buster14a/buster#480](https://github.com/buster14a/buster/pull/480) checks the constructs this compiler's own `main.c`
uses: the loop and `FP_CONTRACT` pragmas, `no_builtin`, a `_BitInt`'s width alone, and the types of an inferred
array's struct elements. Its changes are on the checker's default path, the reader's (`c_check_input.c`) and the
initializer's. This measures them on the frozen `sqlite3.c`, which has none of those constructs. Median of five rounds,
and of three rounds of `perf stat -r 11`:

| Measure | base (main `22e32590`) | head (#480 `77bd4aa8`) | change |
| --- | --- | --- | --- |
| typed checking of the bodies, scalar path | 49.444 ns/node (272.8 cycles) | 49.760 ns/node (274.0 cycles) | +0.64% |
| typed checking of the bodies, vector path | 53.825 ns/node (297.2 cycles) | 54.423 ns/node (300.6 cycles) | +1.11% |
| whole `-fsyntax-only` driver, wall | 147.627 ms | 148.798 ms | +0.79% |
| whole driver, user instructions | 1,719,568,840 | 1,720,362,504 | +0.05% |
| whole driver, user cycles | 681.3 M | 687.3 M | +0.85% |
| whole driver, peak resident set | 599,272 to 599,284 KB | 599,416 to 599,428 KB | +0.14 MB |

The scalar path's rounds overlap (base 49.39 to 50.45 ns/node, head 49.37 to 51.48). The driver's don't: base
147.59 to 147.80 ms, head 148.56 to 148.96. That time is not work. The head runs 0.8 million more instructions of
1.72 billion, which the new pragma pass and attribute checks account for, but 6 million more cycles. A profile of ten
processes each (`base.perf.txt`, `head.perf.txt`) spreads the difference over functions #480 changed and functions it
didn't touch: `check_input_expressions` +0.34 points, `check_input_literal` +0.22, `check_input_specifiers` +0.15, and
the preprocessor's `pp_remove_splices` +0.12 and the literal reader's `check_literal_number_plain` -0.22, whose code is
the same in both trees. That is code placement: the reader's unit moved, as builds in separate processes differ by
about 1% to 2% elsewhere in this repository's measurements.

## Trees

| Name | Commit | What it is |
| --- | --- | --- |
| `base` | [`22e32590`](https://github.com/buster14a/buster/tree/22e32590b7e9c82f5af68acdd97c5814c52692b6) | main, the merge-base of #480's head |
| `head` | [`77bd4aa8`](https://github.com/buster14a/buster/tree/77bd4aa82fd9ce5497c9141a8235a94bf8e09df0) | #480's head, its review's fixes included |

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

- `ab480.sh` (output `ab480.log`): each tree's `-fsyntax-only` once (status 0 on both), then `build/compiler ab
  --rounds 5 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh base head` of `benchmark-checker-source`
  (`ab_source.log`) and of `time-runs --runs 21 --list -fsyntax-only` (`ab_driver.log`).
- `perf480.sh` (`perf480.log`): three rounds, each tree in turn, of `perf stat -x, -e instructions:u,cycles:u,task-clock
  -r 11 taskset -c 2` of the whole driver.
- `prof480.sh`: `perf record -e cycles:u -c 200003` of ten processes per tree, and `perf report --sort symbol`'s 45
  first rows.

## Limits

One input. The profiles have about 34,000 samples each, so a function's share moves by about 0.1 points between runs
of one build.

#480's head moved on after these runs, to `37b594a4` (its second review's fixes). That commit changes the loop pragma
reader alone, which runs only on loop pragmas, and `sqlite3.c` has none: the measured path is the same code, though its
place in the build may differ.
