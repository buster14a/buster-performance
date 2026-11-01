# Tier 1: narrow integers across calls (buster#141), 2026-11-01

Evidence for the buster pull request
["IR lowering: narrow integers cross calls as i32 (#141)"](https://github.com/buster14a/buster/pull/1086), the piece of
[#141's claim](https://github.com/buster14a/buster/issues/141#issuecomment-6555203581) after buster#1060's variadic
definitions. Tier 1 refused every call that passes a `char`, a `short` or a `_Bool`. The IR's call types are signless,
and clang's convention has the caller extend such an argument to 32 bits by its parameter's type, which callees rely
on. Now the typed-stream lowering widens them at the call boundary, in the emission both paths share:

- a narrow argument becomes a `sext` or `zext` to `i32`, by its class's signedness;
- a narrow parameter arrives as an `i32` and is truncated to its type before its slot's store.

## Revisions and setup

- base: buster `13b7d81`, main when the measurement was queued.
- head: buster `d5156c7`, the change's two commits on `13b7d81`: `b068dcc`, the lowering, and `d5156c7`, a sentence of
  `docs/tier1-selection.md` from buster#1060's review.
- The pull request's later commits merge main and add tests and a guide sentence from its review (`8315f48`,
  `9b9e43a`). They don't change the lowering, so `d5156c7` against `13b7d81` isolates this change. The pull request's
  own 9700X job ran the whole suite at each of its heads.
- Each tree is `git archive` of its commit, built by `BUSTER_DEBUG_INFO=0 ./build.sh` (`9700x/logs-build/`).
- Host: the Ryzen 7 9700X (benchpress). Every build, test and measurement held `~/buster-fast-bench/exclusive.sh`
  once, with owner `claude-141-remaining`, and every timed run was pinned to CPU 2.
- Scripts are in `9700x/`: those of the variadic record
  ([buster-performance#201](https://github.com/buster14a/buster-performance/pull/201)), with `tests5.sh` for this
  piece's suites. `common.sh` has the paths, options and lock metadata. The queue ran `9700x/queue13.sh`:
  `./build.sh base-13b7d81 head-d5156c7 && ./tests5.sh head-d5156c7 && ./programs.sh base-13b7d81 head-d5156c7 &&
  ./campaign.sh head-d5156c7 d5156c7 5000 5039`. The queue's next step tests another head, which isn't part of this record.
- Inputs:
  - the frozen `sqlite3.c` (`~/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite/sqlite3.c`), with
    `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`;
  - speedtest1 with that `sqlite3.c` (#136's unity harness), run as
    `--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1`;
  - Lua 5.4.8's 34 sources and the labels record's five scripts (`9700x/programs-head-d5156c7/lua/*.lua`);
  - c-testsuite at `5c72756`.

## Correctness on the 9700X (head, `9700x/head-d5156c7-tests/`)

| Check | Result |
| --- | --- |
| `test-ir` | 7,721 checks, 0 failures |
| `test-ir-lowering` | 758,472 checks, 0 failed (the new narrow-boundary case among them) |
| `test-ir-interpreter` | 903 checks, 0 failed |
| `test-interpreter` | 752 checks, 0 failed |
| `test-ir-inline` | 92,942 checks, 0 failures |
| `test-ir-optimize` | 190,299 checks, 0 failures |
| `test-ssa-ir` | 3,771 checks, 0 failed |
| `test-ir-source`, c-testsuite's subset | 220 files, 430 functions; none refused, disagreeing or unpromoted |
| `test-ir-source`, `sqlite3.c` | 2,668 functions; none refused, disagreeing or unpromoted |
| `test-ssa-source`, c-testsuite's subset | 220 of 220 programs |
| `test-ssa-source --generate 48` | 48 of 48 programs |
| `test-tier1-select` | 582,327 checks, 0 failures |
| `test-tier1-emit` | 228,145 checks, 0 failures |
| `test-tier1-pipeline --cross-check` | 6,535 checks, 0 failures (1,920 native runs, 960 clang comparisons) |
| `test-checker-driver --executable` | 48,071 checks, 0 failures (the new narrow-argument fixture against clang) |
| `test-c-testsuite --tier1` on the subset | 220 of 220 pass; Tier 1 compiles 353 of 430 functions |
| `test-c-testsuite --cross-check` on the subset | 220 of 220 pass |
| `./build.sh check-call-graph` | exit 0 |

#142's campaign at head (seeds 5000 to 5039, `9700x/diff-head-d5156c7/`) is still running. This record gets its results
when it ends.

## Coverage

`--tier1 --tier1-report --tier1-refusals -c` (`programs.sh` step 1, `9700x/programs-head-d5156c7/reports/`):

| Input | Functions | Tier 1 at base | Tier 1 at head | First refused at a call, base | At head |
| --- | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 2,668 | 2,215 | 2,409 | 393 | 189 |
| Lua 5.4.8's 34 sources | 1,088 | 968 | 975 | 96 | 89 |

`sqlite3.c`:

- 194 functions move to Tier 1, and none leave it. Among them are:
  - `sqlite3VdbeIdxKeyCompare`, `sqlite3ValueText`, `sqlite3VdbeMemCast`, `sqlite3BtreeInsert`,
    `balance_nonroot` and `whereLoopAddBtreeIndex`;
  - the `sqlite3_bind_*`, `sqlite3_result_*` and `sqlite3_value_*` families;
  - many of the JSON functions.
- 10 more get past their calls and stop later: 9 at a parameter and 1 at a constant. The parameter refusals (21 to 30)
  are parameters past the sixth and floating ones, the pieces after this one.
- Tier 1's code grows from 154,121 records to 204,482. The functions that move are large: 260 records each on average,
  against 70 for the functions Tier 1 compiled before.

Lua: `block`, `forbody`, `forstat`, `open_func`, `repeatstat`, `test_then_block` and `whilestat`, all in its parser,
move to Tier 1.

## Generated code: speedtest1

`programs.sh` step 3, `9700x/programs-head-d5156c7/st/`. Three builds of speedtest1: base's `--tier1` (`t1base`), head's
`--tier1` (`t1`) and head's Tier 0 (`t0`). Each ran once with `--verify`, then 11 rounds of the three in a rotating
order, each from a fresh database on tmpfs, then once under `perf stat`.

| Build | Tier 1 functions | Median wall, 11 runs | Range | Instructions (user) | Cycles (user) |
| --- | ---: | ---: | --- | ---: | ---: |
| base `--tier1` | 2,249 of 2,709 | 218.50 ms | 217.31 to 227.95 ms | 4,286.1 M | 1,109.5 M |
| head `--tier1` | 2,444 of 2,709 | 213.34 ms | 212.79 to 217.45 ms | 4,049.8 M | 1,089.9 M |
| head Tier 0 | 0 | 257.07 ms | 256.16 to 258.51 ms | 5,694.2 M | 1,323.8 M |

Head's Tier 1 build runs 236.3 M fewer instructions (−5.5%) and 19.6 M fewer cycles (−1.8%), and its median is 2.4%
lower. The ranges overlap only between base's fastest run (217.31 ms) and head's slowest (217.45 ms). All three
`--verify` runs print the same verification hash (`1248168 a7fa3957...`).

## Generated code: Lua

`programs.sh` step 4, `9700x/programs-head-d5156c7/lua/`. The interpreter was built by base's `--tier1`, head's
`--tier1` and clang -O0. Every script's output from both Tier 1 builds is clang -O0's (`compare.txt`). Then 11 rounds
of both Tier 1 builds, in a rotating order (`times.txt`, microseconds from fork to wait), and one `perf stat` run each.

| Script | Base median | Range | Head median | Range | Change | Instructions, base to head |
| --- | ---: | --- | ---: | --- | ---: | --- |
| calls | 31,899 µs | 31,554 to 32,217 | 31,557 µs | 31,415 to 33,603 | −1.1% | 1,083.9 M to 1,083.9 M |
| tables | 57,070 µs | 56,815 to 57,617 | 57,006 µs | 56,507 to 57,375 | −0.1% | 1,709.4 M to 1,709.1 M |
| strings | 53,440 µs | 53,003 to 54,884 | 53,738 µs | 53,453 to 54,926 | +0.6% | 1,261.3 M to 1,261.8 M |
| arithmetic | 68,038 µs | 67,764 to 71,436 | 67,690 µs | 67,536 to 68,719 | −0.5% | 2,450.4 M to 2,450.4 M |
| closures | 75,838 µs | 75,590 to 77,283 | 74,307 µs | 72,633 to 75,021 | −2.0% | 2,071.9 M to 2,060.0 M |

Only the closures script's ranges don't overlap: it runs 11.9 M fewer instructions (−0.57%). The variadic record's
second run moved this script's median 3% the other way with equal instruction counts, so code placement alone moves it
that much. The functions Lua moves are its parser's, which these scripts run little.

## Compile time: `--tier1 -c sqlite3.c`

**`ab` of `time-runs`** (`programs.sh` step 2: 5 rounds of 21 runs per tree, the trees alternating,
`9700x/programs-head-d5156c7/compile-tier1-ab.log`):

| Tree | Median wall per round | Instructions (user), round medians | User cycles, round medians |
| --- | --- | ---: | --- |
| base | 367.74, 368.18, 368.29, 368.30, 368.50 ms | 4,961,782,257 to 4,961,782,290 | 1,922.8 M to 1,926.2 M |
| head | 394.72, 394.81, 394.99, 395.17, 395.19 ms | 5,305,355,078 to 5,305,355,231 | 2,070.9 M to 2,073.6 M |

**`perf stat`** (11 runs per hold, 3 holds per tree, `compile-stat-*.csv`): base 4,961,785,108 to 4,961,785,186
instructions and 1,920.3 M to 1,922.1 M cycles; head 5,305,358,899 to 5,305,358,980 and 2,070.8 M to 2,075.8 M.

Head's median round is 26.70 ms longer (394.99 against 368.29 ms, +7.25%), with 343.6 M more instructions (+6.92%).
The rounds' ranges don't overlap. Tier 1 now compiles 194 more functions, 50,361 more records of code. Those functions
went through Tier 0 before, which costs less per function than Tier 1's lowering, SSA, optimization, selection and
allocation. The cost is 0.53 µs per record that moves to Tier 1.

## Limitations

- One `perf stat` run per Lua script and speedtest1 build: the timings' 11 rounds carry the comparison.
- Compile time was measured on `sqlite3.c` alone.
- The measured head is `d5156c7` on `13b7d81`. The pull request's head also has later main and the review's tests.
- The record doesn't split the compile-time increase by Tier 1 pass. `--time-stages` has no Tier 1 stage of its own.
