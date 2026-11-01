# Tier 1's labels and indirect jumps (buster#789), 2026-11-01

Evidence for the buster pull request "Tier 1: labels and indirect jumps (#789)", the first of
[#789](https://github.com/buster14a/buster/issues/789)'s pieces in
[#141's claim](https://github.com/buster14a/buster/issues/141#issuecomment-6555203581). `tier1_select.c` refused every
function with labels: GNU C's computed gotos and the C driver's jump tables, which the lowering sends through one
dispatch block's `br_indirect`. Now the selector takes `br_indirect` (`jmp` through the address's register), the CFG
consumer moves each label's edge values at its block's start or in a stub after the indirect jump, and the driver
defines each label's symbol at the record where that jump enters it.

## Revisions and setup

- main: buster `f152e63` (main after buster#1004).
- head: buster `ef4f746`, the labels commit on `8b789ef` (buster#1006's head). `8b789ef` changes only comments and
  docs from `f152e63`, so head's code is main's plus the labels commit.
- The pull request's commit is `69ef08f`, `ef4f746` again on main `05e6737`. Its tree differs from `ef4f746`'s only
  by main's later changes: `AGENTS.md`, `CONTRIBUTING.md` and one line of `ir_optimize_benchmark.c` (buster#1005).
- Each tree is `git archive` of its commit, built by `BUSTER_DEBUG_INFO=0 ./build.sh` (`9700x/logs-build/`).
- Host: the Ryzen 7 9700X (benchpress). Every build, test and measurement held `~/buster-fast-bench/exclusive.sh`
  once, with owner `claude-141-remaining`, and every timed run was pinned to CPU 2.
- Scripts are in `9700x/`. `common.sh` has the paths, options and lock metadata. The queue ran
  `./build.sh main-f152e63 head-ef4f746 && ./tests2.sh head-ef4f746 && ./programs.sh main-f152e63 head-ef4f746 &&
  ./campaign.sh head-ef4f746 ef4f746 3800 3839`, and its output is `9700x/queue-2.log` (other sessions' lock-wait
  lines removed).
- Inputs:
  - the frozen `sqlite3.c` (`~/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite/sqlite3.c`), with
    `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`;
  - speedtest1 with that `sqlite3.c` (#136's unity harness), run as
    `--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1`;
  - Lua 5.4.8's 34 sources, and five scripts (`9700x/programs-head-ef4f746/lua/*.lua`), the reciprocal record's
    ([`tier1-reciprocal-141-2026-11-01`](../tier1-reciprocal-141-2026-11-01));
  - c-testsuite at `5c72756`.

## Correctness on the 9700X (head, `9700x/head-ef4f746-tests/`)

| Check | Result |
| --- | --- |
| `test-tier1-select` | 582,269 checks, 0 failures |
| `test-tier1-emit` | 223,839 checks, 0 failures (the new native labels fixture among them) |
| `test-tier1-pipeline --cross-check` | 6,535 checks, 0 failures (1,920 native runs, 960 clang comparisons) |
| `test-tier1-cfg` | 30,876 checks, 0 failures |
| `test-tier1-liveness` | 20,433 checks, 0 failures |
| `test-checker-driver --executable` | 48,030 checks, 0 failures (the new labels fixture against clang -O0 and Tier 0) |
| `test-c-testsuite --tier1` on the subset | 220 of 220 pass; Tier 1 compiles 353 of 430 functions (350 at `adc1499` in [the plan-verification record](../tier1-plan-verification-141-2026-11-01), whose outputs `f152e63` keeps) |
| `test-c-testsuite --cross-check` on the subset | 220 of 220 pass |
| `./build.sh check-call-graph` | exit 0 |

#142's campaign at head (`campaign.sh`, Csmith `0cdc710` and YARPGen `1adb290`, two programs per generator a hold,
Buster's Tier 0 and `--tier1 -fno-asynchronous-unwind-tables` against clang -O0 and -O2, seeds 3800 to 3839;
`tally.sh` wrote `9700x/diff-head-ef4f746/campaign.tsv`, one line per program with every step's status): 80 programs, 67
pass. The 13 others fail in clang's own steps, none in Buster's:

- 10 YARPGen programs whose clang links fail, relocations truncated past the small code model. Buster refuses each
  too: an atom past 2 GB, an image past the executable's limits, or a call of more than 239 arguments.
- 1 Csmith program whose clang compile writes past the output limit (its warnings). Both of Buster's tiers compile and
  run it, but there is no reference to compare them with.
- 2 Csmith programs whose runs pass 30 s under clang -O0 and -O2, and under both of Buster's tiers.

## Coverage

`--tier1 --tier1-report --tier1-refusals -c` (`programs.sh` step 1, `9700x/programs-head-ef4f746/reports/`):

| Input | Functions | Tier 1 at main | Tier 1 at head | Refused by `function` at main | At head |
| --- | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 2,668 | 2,181 | 2,197 | 73 | 28 |
| Lua 5.4.8's 34 sources | 1,088 | 940 | 963 | 46 | 5 |

Labels were most of the `function` refusals. Most of the functions they held now stop at a later instruction, mostly a
call that Tier 1 doesn't take yet: `sqlite3.c`'s `call` refusals go from 365 to 389, and its `const` and `phi` ones
from 21 and 1 to 24 and 3. The functions that move to Tier 1:

- `sqlite3.c` (16): `actionName`, `exprCodeInlineFunction`, `exprImpliesNotNull`, `freeP4`, `impliesNotNullRow`,
  `jsonBlobOverwrite`, `jsonbValidityCheck`, `resolveP2Values`, `sqlite3ExprDataType`, `sqlite3GetToken`,
  `sqlite3VdbeSerialGet`, `sqlite3_complete`, `sqlite3_db_status64`, `vdbeRecordCompareInt`, `vdbeRecordDecodeInt` and
  `yy_destructor`;
- Lua (23): `auxgetinfo`, `basicgetobjname`, `codenot`, `freeobj`, `funcnamefromcode`, `g_read`, `getgclist`,
  `getobjname`, `getoption`, `intarith`, `llex`, `luaK_dischargevars`, `luaK_exp2const`, `luaK_infix`, `luaK_storevar`,
  `luaV_finishOp`, `lua_rawlen`, `match`, `match_class`, `propagatemark`, `read_string`, `reallymarkobject` and
  `singlestep`.

`sqlite3VdbeExec` and `luaV_execute`, whose labels Tier 1 now takes, stop at calls it doesn't take yet: narrow
arguments, arguments past the sixth and floating values are the claim's later pieces.

## Generated code: speedtest1

`programs.sh` step 3, `9700x/programs-head-ef4f746/st/`. Three builds of speedtest1: main's `--tier1` (`t1base`), head's
`--tier1` (`t1`) and head's Tier 0 (`t0`). Each ran once with `--verify`, then 11 rounds of the three in a rotating
order, each from a fresh database on tmpfs, then once under `perf stat`.

| Build | Tier 1 functions | Median wall, 11 runs | Range | Instructions (user) | Cycles (user) |
| --- | ---: | ---: | --- | ---: | ---: |
| main `--tier1` | 2,210 of 2,709 | 222.57 ms | 222.24 to 223.93 ms | 4,407.6 M | 1,136.0 M |
| head `--tier1` | 2,226 of 2,709 | 220.27 ms | 219.51 to 220.84 ms | 4,289.3 M | 1,119.6 M |
| head Tier 0 | 0 | 256.03 ms | 255.46 to 256.69 ms | 5,694.2 M | 1,322.9 M |

Head's Tier 1 build runs 1.03% faster than main's by the median, with 2.68% fewer instructions and 1.44% fewer cycles.
The ranges don't overlap. Both `--verify` runs print Tier 0's verification hash (`1248168 a7fa3957...`).

## Generated code: Lua

`programs.sh` step 4, `9700x/programs-head-ef4f746/lua/`. The interpreter was built by main's `--tier1`, head's
`--tier1` and clang -O0. Every script's output from both Tier 1 builds is clang -O0's (`compare.txt`). Then 11 rounds
of both Tier 1 builds, in a rotating order (`times.txt`, microseconds from fork to wait), and one `perf stat` run each.

| Script | Main median | Range | Head median | Range | Change | Instructions, main to head |
| --- | ---: | --- | ---: | --- | ---: | --- |
| calls | 31,895 µs | 31,461 to 33,505 | 31,651 µs | 31,469 to 32,685 | −0.8% | 1,083.9 M to 1,083.9 M |
| tables | 56,568 µs | 56,372 to 56,895 | 56,612 µs | 56,253 to 57,129 | +0.1% | 1,709.3 M to 1,709.5 M |
| strings | 55,682 µs | 55,370 to 56,242 | 53,051 µs | 52,823 to 53,489 | −4.7% | 1,428.8 M to 1,261.4 M |
| arithmetic | 68,598 µs | 68,456 to 76,611 | 67,676 µs | 67,506 to 70,707 | −1.3% | 2,450.5 M to 2,450.4 M |
| closures | 74,925 µs | 74,399 to 78,731 | 75,155 µs | 74,625 to 76,714 | +0.3% | 2,071.3 M to 2,068.5 M |

The strings script's ranges don't overlap: Lua's pattern matcher, `match` and `match_class`, moved to Tier 1 (11.7%
fewer instructions). The other scripts' ranges overlap.

## Compile time: `--tier1 -c sqlite3.c`

**`ab` of `time-runs`** (`programs.sh` step 2: 5 rounds of 21 runs per tree, the trees alternating,
`9700x/programs-head-ef4f746/compile-tier1-ab.log`):

| Tree | Median wall per round | Instructions (user) | User cycles |
| --- | --- | ---: | --- |
| main | 371.22, 371.39, 371.47, 371.53, 371.76 ms | 4,901,042,862 to 4,901,042,867 | 1,933.6 M to 1,937.0 M |
| head | 376.29, 376.34, 376.67, 376.67, 376.83 ms | 4,940,162,234 to 4,940,162,310 | 1,961.8 M to 1,964.8 M |

**`perf stat`** (11 runs per hold, 3 holds per tree, `compile-stat-*.csv`): main 4,901,045,076 to 4,901,045,078
instructions and 1,933.2 M to 1,935.2 M cycles; head 4,940,165,629 to 4,940,165,701 and 1,962.8 M to 1,963.8 M.

Head compiles `sqlite3.c` 1.40% slower by the median round (+39.1 M instructions, +0.80%). Tier 1, the more expensive
tier, compiles 16 more functions: its code is 151,575 records against 147,452. And the functions whose labels selection
refused at its start now go through its first pass to a later refusal before Tier 0 takes them.

## Limitations

- One `perf stat` run per Lua script and speedtest1 build: the timings' 11 rounds carry the comparison.
- Compile time was measured on `sqlite3.c` alone. It rises with the functions that move from Tier 0 to Tier 1, which
  differ by input.
- The CFG consumer jumps through the one dispatch block, as the lowering writes it. Copying the indirect jump into each
  of the dispatch block's predecessors (threaded dispatch) would give each its own branch history; it isn't measured
  here.
