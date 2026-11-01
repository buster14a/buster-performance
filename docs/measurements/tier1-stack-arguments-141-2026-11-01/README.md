# Tier 1: arguments and parameters past the registers (buster#141), 2026-11-01

Evidence for the buster pull request "Tier 1: arguments and parameters past the registers (#141)", the piece of
[#141's claim](https://github.com/buster14a/buster/issues/141#issuecomment-6555203581) after buster#1086's narrow call
boundary. Tier 1 refused every call of more than six arguments and every function of more than six parameters. Now a
call takes up to sixteen integer or pointer arguments and a function up to sixteen such parameters, those past the
sixth in the stack's 8-byte slots:

- A call stores each argument past the registers into its slot of the outgoing area before its own moves, from its
  register, its spill slot through r11, or recomputed into r11. The frame planner reserves the area for the calls'
  most stack bytes.
- The entry loads each parameter past the registers from its incoming slot into its first fragment's register, or
  through r11 into its own slot, a narrow one zero-extended as it loads.
- A variadic call's unnamed argument has its value's type.

## Revisions and setup

- base: buster `9b9e43a`, buster#1086's head (the narrow call boundary on main `6135b68`).
- head: buster `3146ff1`, the change's commit on `9b9e43a`.
- The pull request's commit is the same change on main after buster#1086 merged.
- Each tree is `git archive` of its commit, built by `BUSTER_DEBUG_INFO=0 ./build.sh` (`9700x/logs-build/`).
- Host: the Ryzen 7 9700X (benchpress). Every build, test and measurement held `~/buster-fast-bench/exclusive.sh`
  once, with owner `claude-141-remaining`, and every timed run was pinned to CPU 2.
- Scripts are in `9700x/`: those of the narrow boundary's record
  ([buster-performance#213](https://github.com/buster14a/buster-performance/pull/213)), with `tests6.sh` for this
  piece's suites and `tests7.sh` for the later commits'. `common.sh` has the paths, options and lock metadata. The
  queue ran `9700x/queue14.sh`: `./build.sh base-9b9e43a head-3146ff1 && ./tests6.sh head-3146ff1 && ./programs.sh
  base-9b9e43a head-3146ff1 && ./campaign.sh head-3146ff1 3146ff1 5100 5139`, then built `8ef99de` and ran
  `tests7.sh` on it. Its output is `9700x/queue-14.log`, with lock-wait lines removed; its first lines are the
  narrow boundary campaign's tally.
- Inputs:
  - the frozen `sqlite3.c` (`~/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite/sqlite3.c`), with
    `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`;
  - speedtest1 with that `sqlite3.c` (#136's unity harness), run as
    `--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1`;
  - Lua 5.4.8's 34 sources and the labels record's five scripts (`9700x/programs-head-3146ff1/lua/*.lua`);
  - c-testsuite at `5c72756`.

## Correctness on the 9700X (head, `9700x/head-3146ff1-tests/`)

| Check | Result |
| --- | --- |
| `test-tier1-select` | 582,331 checks, 0 failures |
| `test-tier1-emit` | 231,139 checks, 0 failures (the new native stack-argument functions among them) |
| `test-tier1-pipeline --cross-check` | 6,535 checks, 0 failures (1,920 native runs, 960 clang comparisons) |
| `test-tier1-cfg` | 30,876 checks, 0 failures |
| `test-tier1-liveness` | 20,433 checks, 0 failures |
| `test-tier1-frame` | 2,277,543 checks, 0 failures |
| `test-tier1-frame-execution` | 14,619 checks, 0 failures |
| `test-check-debug --cross-check` | 2,615 checks, 0 failures |
| `test-checker-driver --executable` | 48,107 checks, 0 failures (the new stack-argument fixture against clang -O0) |
| `test-c-testsuite --tier1` on the subset | 220 of 220 pass; Tier 1 compiles 354 of 430 functions |
| `test-c-testsuite --cross-check` on the subset | 220 of 220 pass |
| `./build.sh check-call-graph` | exit 0 |

The later commits (floating values, by-value aggregates' ABI records, unsigned 64-bit conversions and the dynamic
stack) at `8ef99de` pass every suite of `tests7.sh` (`9700x/head-8ef99de-tests/`): the IR's, SSA's and the
interpreters', on c-testsuite and `sqlite3.c` too, Tier 1's with the masks', the frame's, `test-check-debug`,
`test-checker-driver` (48,135 checks), c-testsuite's subset by `--tier1` (220 of 220; Tier 1 compiles 421 of 430
functions) and by `--cross-check`, and the call graph check.

#142's campaign at head (`campaign.sh`, Csmith `0cdc710` and YARPGen `1adb290`, two programs per generator a hold,
Buster's Tier 0 and `--tier1 -fno-asynchronous-unwind-tables` against clang -O0 and -O2, seeds 5100 to 5139;
`tally.sh` wrote `9700x/diff-head-3146ff1/campaign.tsv`, one line per program with every step's status): 80 programs, 65
pass. The 15 others fail in clang's own steps, none in Buster's:

- 9 YARPGen programs whose clang links fail, relocations truncated past the small code model. Buster refuses each
  too, for an atom past 2 GB.
- 3 Csmith programs whose clang -O0 and -O2 compiles pass the harness's output limit. Both of Buster's tiers compile
  them.
- 3 Csmith programs whose runs pass 30 s under clang -O0, clang -O2 and both of Buster's tiers.

## Coverage

`--tier1 --tier1-report --tier1-refusals -c` (`programs.sh` step 1, `9700x/programs-head-3146ff1/reports/`):

| Input | Functions | Tier 1 at base | Tier 1 at head | First refused at a call, base | At head | At a parameter, base | At head |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 2,668 | 2,409 | 2,558 | 189 | 62 | 30 | 7 |
| Lua 5.4.8's 34 sources | 1,088 | 975 | 991 | 89 | 75 | 4 | 2 |

- 149 of `sqlite3.c`'s functions move to Tier 1, and none leave it. Among them are some of its largest:
  `sqlite3Select`, `sqlite3WhereBegin`, `sqlite3Pragma`, `sqlite3BtreeOpen` and `sqlite3BtreeIntegrityCheck`.
- One more gets past its call and stops at a load (6 to 7).
- Tier 1's code for `sqlite3.c` grows from 204,528 records to 299,318. The functions that move average 636 records
  each. Spill stores go from 4,781 to 10,574 and edge moves from 16,849 to 32,627.
- Lua: 16 functions move.

## Generated code: speedtest1

`programs.sh` step 3, `9700x/programs-head-3146ff1/st/`. Three builds of speedtest1: base's `--tier1` (`t1base`), head's
`--tier1` (`t1`) and head's Tier 0 (`t0`). Each ran once with `--verify`, then 11 rounds of the three in a rotating
order, each from a fresh database on tmpfs, then once under `perf stat`.

| Build | Tier 1 functions | Median wall, 11 runs | Range | Instructions (user) | Cycles (user) |
| --- | ---: | ---: | --- | ---: | ---: |
| base `--tier1` | 2,444 of 2,709 | 213.91 ms | 213.30 to 215.69 ms | 4,049.8 M | 1,087.0 M |
| head `--tier1` | 2,595 of 2,709 | 213.21 ms | 212.23 to 213.72 ms | 4,050.2 M | 1,083.1 M |
| head Tier 0 | 0 | 256.00 ms | 254.32 to 257.51 ms | 5,694.2 M | 1,326.2 M |

The instruction counts are within 0.01% and the ranges overlap, so the record claims no change in speed. All three
`--verify` runs print the same verification hash (`1248168 a7fa3957...`).

## Generated code: Lua

`programs.sh` step 4, `9700x/programs-head-3146ff1/lua/`. The interpreter was built by base's `--tier1`, head's
`--tier1` and clang -O0. Every script's output from both Tier 1 builds is clang -O0's (`compare.txt`). Then 11 rounds
of both Tier 1 builds, in a rotating order (`times.txt`, microseconds from fork to wait), and one `perf stat` run each.

| Script | Base median | Range | Head median | Range | Change | Instructions, base to head |
| --- | ---: | --- | ---: | --- | ---: | --- |
| calls | 31,392 µs | 31,304 to 32,759 | 31,610 µs | 31,408 to 34,811 | +0.7% | 1,083.9 M to 1,083.9 M |
| tables | 55,716 µs | 55,468 to 56,357 | 57,348 µs | 57,066 to 57,603 | +2.9% | 1,709.2 M to 1,709.1 M |
| strings | 53,222 µs | 53,097 to 53,837 | 52,018 µs | 51,866 to 52,586 | −2.3% | 1,262.2 M to 1,261.5 M |
| arithmetic | 67,618 µs | 67,547 to 69,949 | 67,540 µs | 67,390 to 71,565 | −0.1% | 2,450.4 M to 2,450.4 M |
| closures | 74,608 µs | 73,303 to 75,179 | 74,099 µs | 73,012 to 74,565 | −0.7% | 2,066.8 M to 2,063.4 M |

The tables script's ranges separate 2.9% upward and the strings script's 2.3% downward, each with equal instruction
counts (within 0.06%). The record takes both for changes in the code's placement, as in the earlier records.

## Compile time: `--tier1 -c sqlite3.c`

**`ab` of `time-runs`** (`programs.sh` step 2: 5 rounds of 21 runs per tree, the trees alternating,
`9700x/programs-head-3146ff1/compile-tier1-ab.log`):

| Tree | Median wall per round | Instructions (user), round medians | User cycles, round medians |
| --- | --- | ---: | --- |
| base | 390.95, 391.10, 391.11, 391.15, 391.20 ms | 5,211,519,654 to 5,211,519,733 | 2,049.8 M to 2,051.9 M |
| head | 438.26, 438.27, 438.63, 438.74, 444.36 ms | 5,806,457,702 to 5,806,457,773 | 2,311.7 M to 2,321.2 M |

**`perf stat`** (11 runs per hold, 3 holds per tree, `compile-stat-*.csv`): base 5,211,521,492 to 5,211,521,495
instructions and 2,051.2 M to 2,060.1 M cycles; head 5,806,461,126 to 5,806,461,154 and 2,313.2 M to 2,323.4 M.

Head's median round is 47.52 ms longer (438.63 against 391.11 ms, +12.15%), with 594.9 M more instructions
(+11.4%). The rounds' ranges don't overlap. Tier 1 now compiles 149 more functions, 94,790 more records of code.
Those functions went through Tier 0 before. The cost is 0.50 µs per record that moves to Tier 1, as for the narrow
boundary's functions (0.53 µs).

## Limitations

- One `perf stat` run per Lua script and speedtest1 build: the timings' 11 rounds carry the comparison.
- Compile time was measured on `sqlite3.c` alone. The record doesn't split it by Tier 1 pass.
- The measured head is `3146ff1` on `9b9e43a`, buster#1086's head before it merged.
