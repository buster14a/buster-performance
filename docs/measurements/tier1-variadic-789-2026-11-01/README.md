# Tier 1's variadic definitions (buster#789), 2026-11-01

Evidence for the buster pull request "Tier 1: variadic definitions (#789)", the third of
[#789](https://github.com/buster14a/buster/issues/789)'s pieces in
[#141's claim](https://github.com/buster14a/buster/issues/141#issuecomment-6555203581). `tier1_select.c` refused every
variadic definition, the functions that read their unnamed arguments through `va_start`'s register save area and
overflow area. Now the selector takes the save area as a frame object and the overflow area's address as a `lea` of its
own, and the CFG consumer has the frame planner reserve the save area (`BUSTER_TIER1_FRAME_VARIADIC`). Its prologue
stores the six argument registers there and, after testing `al`, the eight vector ones.

## Revisions and setup

- base: buster `1b032be`, the head of buster#1016 (labels and indirect jumps) when the measurement ran.
- head: buster `d8b21f2`, the variadic commit on `1b032be`.
- The commit was then rebased onto buster#1016's review commits. At `9089500`, its copy on `66c4699`, the frozen
  `sqlite3.c` by both paths and Lua 5.4.8's 34 sources compile by `--tier1 -c` into the same bytes as at `d8b21f2`
  (`identity2.sh`: 35 objects identical, 0 differ; `9700x/identity-head-d8b21f2-base-9089500.txt`). `2adf700`, the
  review's last commit, changes only a test, so the copy on it (`9d46ddb`) has `9089500`'s code.
- The pull request's commit is `d0acf30`, the same change on main `26e452c` (buster#1016 merged). Main had taken
  buster#177's unwind tables for Tier 1's frames (`check_tier1_frame`) in the meantime, after this measurement. At
  `d0acf30` the change's suites pass again in the session's cloud container: Tier 1's, the frame's,
  `test-check-debug --cross-check`, c-testsuite's subset by `--tier1`, the call graph, and `test-checker-driver` but
  for 10 checks of library functions' implicit declarations, which the container's clang 23.1.5 diagnoses otherwise
  than the 9700X's (the variadic fixture passes). The pull request's 9700X job runs the whole suite.
- Each tree is `git archive` of its commit, built by `BUSTER_DEBUG_INFO=0 ./build.sh` (`9700x/logs-build/`).
- Host: the Ryzen 7 9700X (benchpress). Every build, test and measurement held `~/buster-fast-bench/exclusive.sh`
  once, with owner `claude-141-remaining`, and every timed run was pinned to CPU 2.
- Scripts are in `9700x/`, those of the labels record
  ([`tier1-labels-789-2026-11-01`](../tier1-labels-789-2026-11-01)) with `tests3.sh` for this piece's suites.
  `common.sh` has the paths, options and lock metadata. The queue ran
  `./build.sh base-1b032be head-d8b21f2 && ./tests3.sh head-d8b21f2 && ./programs.sh base-1b032be head-d8b21f2 &&
  ./campaign.sh head-d8b21f2 d8b21f2 4000 4039`, and its output is `9700x/queue-3.log` (lock-wait lines removed).
- Inputs:
  - the frozen `sqlite3.c` (`~/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite/sqlite3.c`), with
    `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`;
  - speedtest1 with that `sqlite3.c` (#136's unity harness), run as
    `--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1`;
  - Lua 5.4.8's 34 sources and the labels record's five scripts (`9700x/programs-head-d8b21f2/lua/*.lua`);
  - c-testsuite at `5c72756`.

## Correctness on the 9700X (head, `9700x/head-d8b21f2-tests/`)

| Check | Result |
| --- | --- |
| `test-tier1-select` | 582,297 checks, 0 failures |
| `test-tier1-emit` | 225,809 checks, 0 failures (the new native variadic fixtures among them) |
| `test-tier1-pipeline --cross-check` | 6,535 checks, 0 failures (1,920 native runs, 960 clang comparisons) |
| `test-tier1-cfg` | 30,876 checks, 0 failures |
| `test-tier1-liveness` | 20,433 checks, 0 failures |
| `test-tier1-frame` | 2,273,931 checks, 0 failures |
| `test-tier1-frame-execution` | 14,619 checks, 0 failures |
| `test-checker-driver --executable` | 48,048 checks, 0 failures (the new variadic fixture against clang -O0 and Tier 0) |
| `test-c-testsuite --tier1` on the subset | 220 of 220 pass; Tier 1 compiles 353 of 430 functions, as at base |
| `test-c-testsuite --cross-check` on the subset | 220 of 220 pass |
| `./build.sh check-call-graph` | exit 0 |

#142's campaign at head (`campaign.sh`, Csmith `0cdc710` and YARPGen `1adb290`, two programs per generator a hold,
Buster's Tier 0 and `--tier1 -fno-asynchronous-unwind-tables` against clang -O0 and -O2, seeds 4000 to 4039;
`tally.sh` wrote `9700x/diff-head-d8b21f2/campaign.tsv`, one line per program with every step's status): 80 programs, 66
pass. The 14 others fail in clang's own steps, none in Buster's:

- 10 YARPGen programs whose clang links fail, relocations truncated past the small code model. Buster refuses each
  too: 6 for an atom past 2 GB, 3 for an image past the executable's limits and 1 for a call of more than 239
  arguments.
- 4 Csmith programs whose runs pass 30 s under clang -O0 and under both of Buster's tiers. Under clang -O2, three of
  them pass 30 s too, and the fourth (seed 4037) exits with status 20 after 3 ms without output.

## Coverage

`--tier1 --tier1-report --tier1-refusals -c` (`programs.sh` step 1, `9700x/programs-head-d8b21f2/reports/`):

| Input | Functions | Tier 1 at base | Tier 1 at head | Refused by `function` at base | At head |
| --- | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 2,668 | 2,197 | 2,215 | 28 | 6 |
| Lua 5.4.8's 34 sources | 1,088 | 963 | 968 | 5 | 0 |

Variadic definitions were 22 of `sqlite3.c`'s 28 `function` refusals and all 5 of Lua's. The functions that move to
Tier 1:

- `sqlite3.c` (18): `checkAppendMsg`, `errorMPrintf`, `execSqlF`, `getDigits`, `jsonPrintf`, `rtreeCheckAppendMsg`,
  `rtreeCheckPrepare`, `sqlite3ErrorMsg`, `sqlite3MPrintf`, `sqlite3NestedParse`, `sqlite3VdbeError`, `sqlite3_config`,
  `sqlite3_db_config`, `sqlite3_log`, `sqlite3_mprintf`, `sqlite3_snprintf`, `sqlite3_str_appendf` and
  `sqlite3_vtab_config`;
- Lua (5): `luaG_runerror`, `luaL_error`, `luaO_pushfstring`, `lua_gc` and `lua_pushfstring`.

The other 4 of `sqlite3.c`'s (`sqlite3ErrorWithMsg`, `sqlite3VdbeMultiLoad`, `sqlite3VdbeExplain` and
`sqlite3_test_control`) now stop at a call Tier 1 doesn't take yet, and its `call` refusals go from 389 to 393. The 6
`function` refusals left (`sqlite3AddColumn`, `tokenExpr`, `yy_shift`, `yy_reduce`, `yy_syntax_error` and
`sqlite3Parser`) take a `Token` by value, so they have ABI records of their own: #789's second piece.

## Generated code: speedtest1

`programs.sh` step 3, `9700x/programs-head-d8b21f2/st/`. Three builds of speedtest1: base's `--tier1` (`t1base`), head's
`--tier1` (`t1`) and head's Tier 0 (`t0`). Each ran once with `--verify`, then 11 rounds of the three in a rotating
order, each from a fresh database on tmpfs, then once under `perf stat`.

| Build | Tier 1 functions | Median wall, 11 runs | Range | Instructions (user) | Cycles (user) |
| --- | ---: | ---: | --- | ---: | ---: |
| base `--tier1` | 2,226 of 2,709 | 220.13 ms | 219.59 to 220.94 ms | 4,289.3 M | 1,125.3 M |
| head `--tier1` | 2,249 of 2,709 | 218.93 ms | 218.33 to 219.98 ms | 4,286.1 M | 1,114.1 M |
| head Tier 0 | 0 | 257.00 ms | 256.19 to 257.83 ms | 5,694.2 M | 1,330.7 M |

Head's Tier 1 build has a 0.55% lower median, 0.07% fewer instructions and 0.99% fewer cycles, but the ranges overlap
(219.59 to 219.98 ms), so the record claims no change in speed. The variadic definitions are SQLite's formatters and
error paths, which speedtest1 runs little. All three `--verify` runs print the same verification hash
(`1248168 a7fa3957...`).

## Generated code: Lua

`programs.sh` step 4, `9700x/programs-head-d8b21f2/lua/`. The interpreter was built by base's `--tier1`, head's
`--tier1` and clang -O0. Every script's output from both Tier 1 builds is clang -O0's (`compare.txt`). Then 11 rounds
of both Tier 1 builds, in a rotating order (`times.txt`, microseconds from fork to wait), and one `perf stat` run each.

| Script | Base median | Range | Head median | Range | Change | Instructions, base to head |
| --- | ---: | --- | ---: | --- | ---: | --- |
| calls | 31,702 µs | 31,427 to 33,563 | 31,750 µs | 31,378 to 32,959 | +0.2% | 1,083.9 M to 1,083.9 M |
| tables | 56,870 µs | 56,543 to 57,324 | 56,954 µs | 56,649 to 57,580 | +0.1% | 1,709.4 M to 1,709.4 M |
| strings | 53,137 µs | 52,864 to 53,442 | 53,660 µs | 53,377 to 54,215 | +1.0% | 1,262.2 M to 1,261.5 M |
| arithmetic | 67,885 µs | 67,586 to 70,058 | 67,706 µs | 67,626 to 68,170 | −0.3% | 2,450.4 M to 2,450.5 M |
| closures | 75,093 µs | 74,166 to 77,689 | 75,093 µs | 74,109 to 77,127 | 0.0% | 2,058.3 M to 2,058.3 M |

Every script's ranges overlap. The strings script's median rises 1.0% with 0.06% fewer instructions. Its ranges
overlap by 65 µs, and the record doesn't separate this from a change in the code's placement.

## Compile time: `--tier1 -c sqlite3.c`

**`ab` of `time-runs`** (`programs.sh` step 2: 5 rounds of 21 runs per tree, the trees alternating,
`9700x/programs-head-d8b21f2/compile-tier1-ab.log`):

| Tree | Median wall per round | Instructions (user), round medians | User cycles, round medians |
| --- | --- | ---: | --- |
| base | 376.34, 376.35, 376.43, 376.44, 376.54 ms | 4,940,162,196 to 4,940,162,201 | 1,962.1 M to 1,964.3 M |
| head | 375.00, 375.13, 375.18, 375.24, 377.67 ms | 4,952,956,588 to 4,952,956,666 | 1,956.6 M to 1,958.2 M |

**`perf stat`** (11 runs per hold, 3 holds per tree, `compile-stat-*.csv`): base 4,940,165,593 to 4,940,165,597
instructions and 1,963.9 M to 1,965.3 M cycles; head 4,952,958,538 to 4,952,958,559 and 1,956.5 M to 1,957.3 M.

Head's median round is 0.33% shorter (375.18 ms against 376.43 ms), with 12.8 M more instructions (+0.26%) and 0.3%
fewer user cycles. The rounds' ranges overlap, so the record claims no change in compile time. Tier 1 compiles 18
more functions, 154,085 records of code against 151,575, and the variadic definitions that selection refused at its
start now go through its passes.

## Limitations

- One `perf stat` run per Lua script and speedtest1 build: the timings' 11 rounds carry the comparison.
- Compile time was measured on `sqlite3.c` alone.
- The measured head is `d8b21f2` on `1b032be`. The pull request's commit is the same change on #1016's merged head and
  main; the identity check above covers the rebase onto #1016's review.
- These programs' variadic definitions are cold: the record shows what Tier 1 now covers, not a speedup.

## At the merged head `512167d`

buster#1060's last head merged main into its review commits. `512167d` merges main `7c77948` into `6e5abdc`. Its
commits on top of the measured `d8b21f2` are:

- `3463e0f`, the overflow area past the pushes;
- `39ee814`, #178's recomputed definition that an edge reads;
- `6e5abdc`, the review's tests.

The 9700X measured `512167d` against `7c77948`, the main it merges. The setup is the one above, through
`9700x/merged-512167d/queue11.sh`, whose output is `queue-11.log` (lock-wait lines removed). The pull request's own
9700X job ran the suites on `512167d`, green.

**Coverage** (`programs-head-512167d/reports/`) is the same as at `d8b21f2`:

| Input | Functions | Tier 1 at base | At head |
| --- | ---: | ---: | ---: |
| `sqlite3.c` | 2,668 | 2,197 | 2,215 |
| Lua 5.4.8 | 1,088 | 963 | 968 |

Function-level refusals drop from 28 to 6 for `sqlite3.c` and from 5 to 0 for Lua.

**speedtest1** (`programs-head-512167d/st/`): 11 rotating rounds, all three `--verify` hashes `1248168 a7fa3957...`.

| Build | Median wall | Range | Instructions | Cycles |
| --- | ---: | --- | ---: | ---: |
| base `--tier1` | 217.30 ms | 216.78 to 223.27 ms | 4,289.3 M | 1,108.3 M |
| head `--tier1` | 219.07 ms | 217.82 to 223.84 ms | 4,286.1 M | 1,114.4 M |
| head Tier 0 | 258.90 ms | 257.82 to 264.62 ms | 5,694.2 M | 1,330.8 M |

The ranges overlap, so this shows no change in speed.

**Lua** (`programs-head-512167d/lua/`): every script prints clang -O0's output from both Tier 1 builds. Medians over 11
rotating rounds, base to head:

| Script | Base | Head |
| --- | ---: | ---: |
| calls | 31.77 ms | 31.77 ms |
| tables | 59.18 ms | 57.56 ms |
| strings | 54.78 ms | 53.30 ms |
| arithmetic | 67.86 ms | 67.85 ms |
| closures | 74.22 ms | 76.50 ms |

Every script's ranges overlap. Closures' are 73.20 to 76.16 against 75.58 to 77.38 ms, with equal instruction counts.

**Compile time, `--tier1 -c sqlite3.c`** (`compile-tier1-ab.log`, `compile-stat-*.csv`): `ab` of `time-runs`, 5 rounds of
21 runs per tree.

- The median round goes from 366.93 to 368.38 ms (+0.40%).
- The rounds' ranges, 366.47 to 367.03 ms against 368.26 to 369.01 ms, don't overlap, so the increase is real.
- Instructions go from 4,943.3 M to 4,959.8 M (+0.33%).
- Tier 1 compiles 18 more functions.

**#142's campaign** (`diff-head-512167d/campaign.tsv`, seeds 4900 to 4939) generated 80 programs, and 66 pass. The other
14 fail first in clang's own steps, none in Buster's:

- 7 Csmith runs take longer than 30 s, under clang -O0 and under both of Buster's tiers;
- 5 YARPGen compiles exit with status 1 under clang and both tiers;
- 2 Csmith compiles exceed the harness's output limit under clang -O0 and -O2. Both tiers compile and run them.
