# Tier 1 threading's SSA repair of truth values read past the test (buster#2608)

[buster#2608](https://github.com/buster14a/buster/issues/2608): `ir_thread.c` threads a truth-value block whose phi
is also read past its test, as Lua's `tonumberns` leaves one: the successor that reads it merges it again, and its
readers there read the new phi. This record measures the pull request's head against main. It also has the first
form's measurements, which led to the final form.

- **Final form** (run 2): main `4acd0645ec6084bffe75b26c59ad1c1b5046a0e0` against head
  `4ce6f2e206e9b0eff5fc482c561747f20b55db52`. The repair runs only where the block's test is decided on an edge and
  reads none of the phis read past it. Its dominance checks are bounded walks, with no dominator tree built.
- **First form** (run 1): main `875980f247e1ff0f8cf33537ab32efc3d82fca49` against `ddd7ae7f229a688cd19da8d1f2f82ef45436017c`.
  It repaired any join with a phi read past the test, and built a dominator tree for each round with a block to repair.

## The 9700X (two runs, `scripts/record.sh`)

Each run built both trees' Release compilers (`BUSTER_DEBUG_INFO=0 ./build.sh --config Release`). Then each tree's
`--tier1` built Lua 5.4.8 as #2554's record does: its 33 sources, `-fno-asynchronous-unwind-tables -std=gnu99
-DLUA_COMPAT_5_3 -DLUA_USE_LINUX`, and `-lm -ldl`.

The steps, each in a hold of its own on the lock (`holds.txt`), with the machine's busiest processes logged in `busy.txt`:

- Each of #138's five scripts ran once per build, and the outputs were compared (`outputs.txt`).
- Five alternating rounds: each a `perf stat -r 3` of each script per build, on CPU 2.
- The compile cost: 11 alternating runs per tree, each of Lua's build command and of `--tier1 -O2 --lanes 1 -c
  sqlite3.c`, on CPU 2.

Every script's output is the same in both runs (`9700x/run*/outputs.txt`). Tables: `9700x/run*/tables.md`
(`scripts/tables.py`).

**Lua's scripts, run 2** (medians of 5 rounds, each a mean of 3 runs):

| Script | cycles head/base | instructions head/base |
| --- | ---: | ---: |
| arithmetic | 0.9976 | 0.9550 |
| calls | 1.0022 | 1.0000 |
| closures | 0.9850 | 1.0018 |
| strings | 0.9822 | 0.9998 |
| tables | 1.0028 | 1.0001 |
| geometric mean | 0.9939 | 0.9912 |

- `arithmetic` loses 41.0 M instructions (911.8 M to 870.8 M). Its cycles go from 155.1 M to 154.7 M; the rounds'
  spread is 154.9 to 156.2 M (base) and 154.1 to 158.0 M (head).
- `closures` and `strings` read 1.5% and 1.8% fewer cycles with the same instructions, every round
  (`closures` 284.3 to 290.1 M against 279.0 to 281.5 M). That is the code's placement, not its work. In run 1 the
  same two scripts read +0.31% and -0.11%.
- Lua's `.text` goes from 400,160 to 399,680 bytes (`size-lua-*.txt`).
- `luaV_execute`'s own cycles over several placements were not measured. The 9700X was used twice for this pull request.

**Compile cost** (medians of 11 alternating runs; `cost.tsv`):

| | run 1 (first form) | run 2 (final form) |
| --- | ---: | ---: |
| Lua's build, cycles | +0.65% | +0.09% |
| Lua's build, instructions | +0.30% | +0.02% |
| `sqlite3.c -O2`, cycles | +2.84% | -0.01% |
| `sqlite3.c -O2`, instructions | +1.55% | +0.13% |

In run 2, sqlite3.c's cycles overlap: base reads 3,288.5 to 3,302.3 M and head 3,292.2 to 3,304.1 M.

## The issue's patterns (callgrind, `scripts/count.sh`)

These are exact counts of the 9700X's own Lua executables, the ones timed above (their digests are in each run's
`receipts.txt` and in `callgrind/inputs.sha256`):

- Run under `valgrind --tool=callgrind --dump-instr=yes` in a cloud VM, through the 9700X's own loader and C library,
  as #2554's record's `cg9.sh` does.
- Joined to the disassembly by #1189's `gap.c` (`GAP_INSTRUCTIONS=1`) and counted by #138's record's `patterns.py`,
  summed over the five scripts.
- There are no origin tags, so these are the untagged counts of #2554's record.
- `callgrind/run*/{base,head}/` has each run's `lua.patterns`, `totals.txt`, `luaV_execute.txt` and the counts by
  function (`by-function.txt`, `scripts/patterns_by_function.py`, which is `patterns.py` with a tally by function
  added).

| | run 2 base | run 2 head | run 1 base | run 1 head |
| --- | ---: | ---: | ---: | ---: |
| a constant made, then tested and branched on | 32,752,050 | 1,128,798 | 32,751,423 | 1,007,415 |
| `setcc` in one block, `test` and branch on it in the next | 7,778,426 | 7,778,426 | 7,778,426 | 7,778,426 |
| `luaV_execute`'s instructions | 2,092,625,950 | 2,050,993,134 | 2,092,625,950 | 2,050,833,134 |
| the program's own instructions | 4,061,421,818 | 4,005,416,683 | 4,053,542,361 | 4,003,092,973 |

- **The constant pattern falls by 96.6%.** In `luaV_execute` it goes from 31,951,650 to 328,398. What is left is
  mostly `lua_checkstack`'s 795,243, unchanged.
- **The `setcc` pattern is unchanged.** Its sites:
  - `luaV_execute`'s 4,359,590 are comparisons with an immediate operand. At `0x44f6d` it is `setl` and a jump to
    the join, `op_orderI`'s `cond`, which `docondjump` compares with the instruction's `k` bit. No edge decides that
    test, so it is not a join this issue repairs.
  - `lua_geti`'s 2,397,060 and `lua_seti`'s 1,021,548.
- **The final form keeps the first form's gain.** `luaV_execute` reads 2,050,993,134 against 2,050,833,134.
- `callgrind/run*/outputs.txt`: every script's output is the same for base and head.

## Compile work (cloud VM, `proxies/`)

The threading pass's work, from a temporary counter print. It is never committed: `proxies/instrument.py` applies
`ir_thread_counters.inc` to a tree, and `measure.sh` runs it. The runs are `--tier1 -O2 --lanes 1` over:

- `sqlite3.c`: the 3.54.1 amalgamation, SHA-256 `0c657666d819f261cc4007526ad57e1669de9949df7a8ea847aa284a2bf0ee52`.
  The 9700X's harness used a different `sqlite3.c`, `b1dd5d74ec7f29055a6684fa06fb3c2f6821c87dd38f9a458dfd2e8a1db28189`.
- Lua's 33 sources.

The columns:

- `off`: the repair and its extra rounds turned off, which reads as main.
- `first`: `ddd7ae7f2`.
- `second`: the final rule with an extra round asked for after a copy into a block of phis. That is the commit before
  the review's fix.
- `final`: the head's code.

The full tables are in `proxies/tables.md`. sqlite3.c:

| | off | first | second | final |
| --- | ---: | ---: | ---: | ---: |
| rounds | 2,695 | 3,033 | 2,787 | 2,705 |
| CFGs built | 1,169 | 1,498 | 1,261 | 1,179 |
| instructions in those CFGs | 1,089,853 | 1,751,724 | 1,298,370 | 1,114,662 |
| dominator trees (blocks) | 0 | 1,153 (160,053) | 0 | 0 |
| second escape scans (instructions) | 0 | 1,153 (1,641,400) | 29 (58,840) | 29 (58,840) |
| walks (blocks visited) | 0 | 0 | 82 (1,294) | 82 (1,294) |
| merges | 0 | 538 | 15 | 15 |
| instructions of the rewritten functions | 642,187 | 1,046,356 | 800,574 | 653,917 |

On Lua the final form makes 33 merges, as the first form's `tonumberns`-shaped ones are. Its CFGs hold 204,691
instructions against `off`'s 204,448.

The first form's 538 merges on sqlite3.c and 100 on Lua included data selects that if-conversion had turned into
cmovs. The driver's `if_clamp` (`long y = x < lo ? lo : x; return y > hi ? hi : y;`) became three conditional
branches. In the final form it is two cmovs again, as on main.
