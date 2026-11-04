# The reader's sparse output columns (buster#628), 2026-11-02

Buster's branch `claude/problem-628-529-d9ae9c` makes twelve of the checker's reader's output columns sparse
(`src/buster/compiler/c_check_sparse.c`), and fills the reader's own six `NONE` columns a column at a time. This
record holds the 9700X measurements of `-c` of the frozen `sqlite3.c`, main against the branch, and the column counts
the change was designed from.

## Sources

| tree | Buster commit | what |
| --- | --- | --- |
| `main-3ce71ec3` | [`3ce71ec312efb45fbcab4d66775e069e30d7e513`](https://github.com/buster14a/buster/tree/3ce71ec312efb45fbcab4d66775e069e30d7e513) | main when the work started |
| `head-93f2085f` | [`93f2085f6229d98375434de84721116509a7479e`](https://github.com/buster14a/buster/tree/93f2085f6229d98375434de84721116509a7479e) | the change on `3ce71ec3` |
| `main-dac5b770` | [`dac5b770b00a5fad3bbf69d655718f3ad7cdfa67`](https://github.com/buster14a/buster/tree/dac5b770b00a5fad3bbf69d655718f3ad7cdfa67) | main when the branch was merged with it |
| `head-67f7bf51` | [`67f7bf51a830898adbc6e47ae8d122211283f9c5`](https://github.com/buster14a/buster/tree/67f7bf51a830898adbc6e47ae8d122211283f9c5) | the change merged with `dac5b770` |
| `head-3950f15b` | [`3950f15b04c9d6a4782c52866a6a4b541d424bfa`](https://github.com/buster14a/buster/tree/3950f15b04c9d6a4782c52866a6a4b541d424bfa) | the review's fixes on `67f7bf51` (the shared pool's region claims, the merge's masked loads) |
| `head-647ff951` | [`647ff9510556f15f56300d19e47e69a921a62640`](https://github.com/buster14a/buster/tree/647ff9510556f15f56300d19e47e69a921a62640) | a test's fix and docs on `3950f15b`: the tests' tree |

Each tree is `git archive` of its commit, with a `COMMIT` file. `3950f15b`'s production code is the branch's last; the
commits after it change only a test and docs.

`receipts.txt` (and `round3/executables.sha256` for the last two trees) has the host (`uname`), the CPU, CPU 2's governor and EPP, clang's and perf's versions, the four
executables' SHA-256 and the input's. The input is the frozen corpus's `sqlite3.c`, SHA-256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`, with the `compile_time` step's options:

```sh
-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c
```

Each tree was built by its own `./build.sh` (Clang 23.1.1, `-march=native`, which is znver5 there, with debug info).

## Method

Everything ran on the Ryzen 7 9700X (`benchpress`), pinned to CPU 2, under the host's lock (`exclusive.sh`), one hold
per script. The scripts are in `scripts/`:

- `objects.sh BASE HEAD OUT`: `-c` by each tree, by default, `--scalar`, `--lanes 8` (unpinned) and `-g`, each
  object compared with `cmp`, and the default's `--time-stages` (`*.stages`).
- `ab.sh A B OUT`: 8 rounds, the order alternating by round, of a warm-up and `perf stat -r 3` of each, events
  `task-clock,cycles:u,instructions:u,cycles:k,instructions:k,page-faults` (`stat-A-N.csv`, `stat-B-N.csv`), every object
  compared with A's first; then `measure-compile --runs 11` by each with the other as its reference
  (`measure-A.txt`, `measure-B.txt`). The times are taken inside the hold.
- `prof.sh TREE`: main's profile, `perf record -F 20000` of 5 compiles (`profile-main/`).
- `count.sh`: an instrumented copy of `3ce71ec3`'s `c_check_input.c`, with `count-columns.c` inserted at
  `check_input_run`'s end, and a count of `attributes`' entries beside it: each column's entries and the 16-token
  lines, 4 KB pages and 2 MB pages that hold one (`columns/counts.txt`).

`summary.txt` in each round keeps the scripts' own output lines. The host lock's messages, which name other
sessions' commands, are left out, by keeping only the lines these scripts print.

## Results

Round 2, `main-dac5b770` (A) against `head-67f7bf51` (B), medians of the 8 rounds:

| measure | main | sparse columns |
| --- | ---: | ---: |
| task clock | 117.070 ms | 116.070 ms |
| user cycles | 555.80 M | 555.53 M |
| user instructions | 1,274.18 M | 1,272.10 M |
| kernel cycles | 93.62 M | 88.03 M |
| page faults | 4,948 | 4,929 |
| peak RSS (`measure-compile`'s `wait4`) | 323,720 KiB | 296,856 KiB |
| `check-input` (`measure-compile`'s stages) | 49.070 ms | 47.349 ms |
| `check-input`'s peak added | 171,256 KiB | 144,504 KiB |

Every round has B 0.77 to 1.54 ms faster. `measure-compile`'s wall medians are 117.990 → 117.299 ms in one order and
118.123 → 117.158 ms in the other.

Round 1, `main-3ce71ec3` against `head-93f2085f`: task clock 117.430 → 115.425 ms, user cycles 557.68 → 551.59 M,
user instructions 1,274.16 → 1,272.08 M, kernel cycles 93.38 → 88.70 M, peak RSS 323,508 → 298,808 KiB,
`check-input` 49.053 → 47.701 ms. Every round has B 1.68 to 2.74 ms faster.

Every object is the same bytes as its main's, in both rounds, by all four variants.

Round 3, `main-dac5b770` (A) against `head-3950f15b` (B), the review's fixes: task clock 117.065 → 115.895 ms, user
cycles 554.74 → 553.54 M, user instructions 1,274.18 → 1,272.85 M (0.75 M more than `67f7bf51`'s: the directory's acquire
loads and the exhaustion test), kernel cycles 93.78 → 89.27 M, peak RSS 323,608 → 296,856 KiB, `check-input` 48.999 →
47.511 ms. Every round has B 0.66 to 1.56 ms faster; every object is the same bytes, by all four variants.

## Tests

`tests/summary.txt`: the checker's tests of `head-647ff951` on the 9700X, by `./build/compiler parallel --jobs 8`
under one hold (`scripts/tests4.sh`, its list `scripts/tests.list`): `test-checker --seed 133`'s 4 parts (735,821
checks), `test-checker-deferred`, `test-check-lanes`, `test-checker-corpus --deferred 8 --id-order 153` and
`test-c-testsuite --cross-check` on c-testsuite (`5c727565`), `test-check-units --corpus`, and
`./build.sh check-call-graph`: all passed.

## Limitations

- Each round is one build of each tree: one code placement. Round 1's 1.1% fewer user cycles is not repeated in
  round 2, where user cycles are flat; the kernel cycles' 5% to 6% and the peak are repeated. No `time-runs`
  placement sweep was made.
- `measure-compile`'s user and system split comes from `getrusage` deltas, which it marks as low-confidence.
- The column counts come from an instrumented build of `3ce71ec3`, not from the measured executables.
