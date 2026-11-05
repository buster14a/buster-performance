# The coded walk's graph by passes and initializers by class (#1038), 9700X qualification

This record is the evidence for [Buster #1038](https://github.com/buster14a/buster/issues/1038)'s stages 2 and 4 and
Buster commit `ab52e5cc29b12336a1493ed605c64fe032352881` on branch `claude/stoic-knuth-2zs8d2`. That commit is applied to
main `0eca996a6` (`base` here). `patches/final.patch` is the commit's diff, and `manifests/final-sources.sha256`
lists the five sources the measured `head` tree was built from, which match the commit.

The host was benchpress, an AMD Ryzen 7 9700X, with Clang 23.1.1 and Linux 6.18.50-2-lts. Both trees were ordinary
optimized `BUSTER_DEBUG_INFO=0 ./build.sh` builds. Every step ran under the host's `exclusive.sh`, and timed work was
pinned to CPU 2. The workload is the frozen corpus's `sqlite3.c` (SHA-256 `0a409f16...5e23d`, path in
`manifests/binaries-objects.txt`), compiled with
`-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I<its directory>`.

## Runs

| directory | what it measures | build |
| --- | --- | --- |
| `runs/r-base` | main's walk: `measure-compile`, `perf record` by symbol, memory-event profiles (`ls_dmnd_fills_from_sys.*`, `ex_no_retire.load_not_complete`) and their annotation of `check_input_expression_coded` | base |
| `runs/r-dbg` | main with `patches/visit-breakdown-instrumentation.patch`: the walk's own visits' TSC ticks and nodes by role and kind (`dbg-visit` lines; role and kind are `ParseRole` and `ParseKind` numbers) | base + instrumentation |
| `runs/ab1` | the batch before the INITIALIZE class, whose flush before a visit was still on the visit's clock: `measure-compile` twice per tree, 5 rotated rounds of `ab` + `time-runs --runs 11`, `perf stat -r 11` | an intermediate head, whose patch isn't retained |
| `runs/ab2` | the same, with the INITIALIZE class | `patches/initialize-before-fold.patch` |
| `runs/r-head` | that build's `measure-compile` and `perf record` by symbol | `patches/initialize-before-fold.patch` |
| `runs/s1` | #509's comparison: `build.sh shifts` at 0, 640, 1344, 2048, 2752 and 3456 bytes of the checker's unit, `time-runs --runs 3 --copies 3` over 3 rounds of `ab`, with main a second time as the floor | final |
| `runs/b-base`, `b-head`, `b-head3` | `benchmark-checker-bindings --passes 5`: the warm per-class table and the numbering probe | base, the INITIALIZE patch, final |
| `runs/t-head3` | objects of `sqlite3.c` and `main.c` by base, head and head's `--scalar` (`objects.txt`), `test-checker --seed 133` parts 1 to 4, `test-checker-deferred` | final |
| `runs/c-head3` | `test-checker-corpus` of `main.c` and of `sqlite3.c` (`--deferred 8 --symbols`), `sqlite3.c`'s 8 semantic mutants, c-testsuite's `--cross-check` subset and its corpus with `--deferred 8 --id-order 153` | final |
| `runs/full-test-checker.log` | a whole `test-checker --seed 133` run, with the classes' coverage line | final |

`scripts/` holds the scripts that made them, each a step under the lock.

## Results

The walk's interval is `measure-compile`'s median of 11 runs, twice per build:

| | main | the batch | with INITIALIZE |
| --- | --- | --- | --- |
| `check-input.expressions`, ms | 14.00 to 14.22 | 14.09 | 13.17 to 13.55 |
| its actions, ms | 8.90 to 9.01 | 7.08 | 10.20 to 10.39 |
| its visits, ms | 2.37 to 2.41 | 4.11 | 0.21 to 0.22 |
| user cycles, rotated rounds (millions) | 846.7 to 850.3 | 844.9 to 845.9 | 842.2 to 843.8 |
| instructions (millions) | 2,151.6 | 2,150.8 | 2,147.1 |

Notes on the rows:

- **Visits.** The batch's visits row still held its flushes, which were then on the visit's clock.
- **Cycles.** These are the medians of 5 rotated rounds of 11 processes each. Main's rounds and the INITIALIZE build's
  don't overlap. Their medians, 849.0 and 843.3 million, are 0.67% apart.
- **`perf stat -r 11`.** It agrees: 848.2 against 843.9 million cycles, and 169.48 against 168.71 ms of task clock.

Over the placements and copies (`runs/s1/shifts.txt`), the final build against main:

| round | user cycles | wall time |
| --- | --- | --- |
| 1 | −0.81% | −0.69% |
| 2 | −0.71% | −0.58% |
| 3 | −0.89% | −0.76% |

Every placement's range is below main in every round. Main's second set of executables, the floor, is within 0.06%
to 0.14% of the first.

Warm, `benchmark-checker-bindings`' class actions take 3.31 to 3.37 ms against main's 3.92 ms. The walk's own visits
fall from 6,639 tokens to 2,627, and 4,012 initializers are acted at by their class. The numbering probe numbers all
316,441 nodes with no mismatch in the final build.

The visit breakdown in `runs/r-dbg` is what led to the INITIALIZE class. On main, declarations' initializer `=`
tokens were 4,163 of the walk's 7,800 visits, about 1.8 ms of its 2.4 ms. Each took about 430 ns, with the record of
the coded walk's nodes before it.

## Correctness

These are checks, distinct from the measurements:

- `sqlite3.c`'s and `main.c`'s objects are byte-identical by base, head and head's `--scalar`
  (`manifests/binaries-objects.txt`).
- `test-checker`'s four parts and its whole run report 0 failures. Its coverage line has `initialize 767/7`.
- `test-checker-deferred`, the corpus comparisons, the mutants and c-testsuite's 220 programs pass, with 0 differences.

No generated object or external source is copied here. The corpus inputs and system headers keep their own terms,
and the scripts refer to the host's frozen corpus.
