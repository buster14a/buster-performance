# What plain char's signedness costs checking (#475's review), 2026-10-26

[buster14a/buster#475](https://github.com/buster14a/buster/pull/475) makes plain `char`'s signedness the type
table's (`TypeTable.char_unsigned`, from `-funsigned-char`). `type_integer_properties`, which the checker's
conversions, comparisons and folding call on hot paths, now asks the table whether `char` is signed:

```c
*is_signed = index == BUSTER_TYPE_CODE_CHAR ? !table->char_unsigned : type_integer_info[index].is_signed;
```

The review asked for a before/after measurement of compile time and peak resident set on the 9700X. In short, the
branch costs nothing that these runs can see. On the frozen `sqlite3.c`, with plain char signed (the base can't
check with `-funsigned-char`), median of five rounds:

| Measure | base (main `d1f9dad3`) | head (#475 `6f35f52e`) | change |
| --- | --- | --- | --- |
| typed checking of the bodies, scalar path | 51.430 ns/node (284.1 cycles) | 50.813 ns/node (280.2 cycles) | -1.20% |
| typed checking of the bodies, vector path | 55.747 ns/node (308.7 cycles) | 54.876 ns/node (303.8 cycles) | -1.56% |
| whole `-fsyntax-only` driver, wall | 148.378 ms | 148.470 ms | +0.06% |
| whole driver, peak resident set | 598,184 to 599,160 KB | 599,440 to 599,464 KB | at most +1.3 MB of 599 MB |
| whole driver, minor faults | 1,429 to 1,446 | 1,435 to 1,436 | none |

The rounds overlap on every measure: base's scalar rounds took 50.32 to 52.98 ns/node and head's 50.28 to 52.18,
and the drivers' round medians 148.35 to 148.67 ms against 148.30 to 148.56 ms. The head is not slower. Its executable
is larger (#475's tests, and its review's calling-convention cross-check, are in it), which is the likeliest source
of the resident set's difference; nothing in the type table grew but a `bool`.

## Trees

| Name | Commit | What it is |
| --- | --- | --- |
| `base` | [`d1f9dad3`](https://github.com/buster14a/buster/tree/d1f9dad3b61f90150ad713f11d35604a777fbe5d) | main, the merge-base of #475's head |
| `head` | [`6f35f52e`](https://github.com/buster14a/buster/tree/6f35f52eb2b00f031ed8be3b0a04cfcd44c607bd) | #475's head: the change, its review's cross-check, and main merged |

Each tree was `git archive` of its commit, sent by tar into an empty directory; `source-base.sha256` and
`source-head.sha256` hold the SHA-256 of each of its files. Each was built with `BUSTER_DEBUG_INFO=0 LC_NUMERIC=C
./build.sh` (`build_base.log`, `build_head.log`); `inputs.sha256` has the executables' and the inputs' digests.

Host: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, CPU 2 at the performance governor. Each build and each
run took the shared lock on its own (`EXCLUSIVE_OWNER=claude-126`); the lock's waiting messages, which name other
sessions' runs, are removed from the logs.

## Method

`ab475.sh` ran it all; `ab475.log` is its output. Both inputs are the preprocessor oracle's frozen ones
(`/var/lib/buster-9700x/corpora/preprocessor-391e729af658`): `sqlite/sqlite3.c` with the pinned gnu17 predefines,
`--clang-features`, `-march=znver5 -std=gnu17 -nostdinc` and the corpus's three system directories, with
`SOURCE_DATE_EPOCH=1792454400` and `CPATH`/`C_INCLUDE_PATH` unset, as the 9700X job's checker benchmarks run them.

- First, each tree's `-fsyntax-only` on the input once: status 0 on both (`drive base status 0`, `drive head status 0`),
  so the driver's runs time a whole check, not a refusal.
- `ab_source.log`: `build/compiler ab --rounds 5 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh base head --
  benchmark-checker-source ...`: each round runs both trees, in an order that rotates by round, each run a process
  under the lock, pinned to CPU 2. `benchmark-checker-source` reports the medians of 21 interleaved passes of typed
  checking over the 2,608 bodies' 311,601 nodes, by each path, after checking that both give identical results
  (`comparison=identical`).
- `ab_driver.log`: `ab` the same way of `time-runs --runs 21 --list -fsyntax-only ...`: each round, 21 fresh
  processes of the whole driver after a warm-up, with each process's wall time (fork to `wait4`), user and system
  time, peak resident set and page faults, and their medians.

The summary's medians are of the five rounds' medians. The scalar and vector body rows are `body_graph`'s lines.

## Limits

Plain char signed only: the base refuses `-funsigned-char`, so the unsigned setting has no before to compare with;
both settings take the same branch. One input, `sqlite3.c`, whose bodies are a checker workload of 311,601 nodes;
the conversion paths other units take more often weren't measured apart.
