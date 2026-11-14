# The hoist's last losses, waiting recipes and joins (#2618, #2735), 2026-11-14

This is the evidence for [buster14a/buster#2777](https://github.com/buster14a/buster/pull/2777), which finishes [buster#2618](https://github.com/buster14a/buster/issues/2618) after [buster#2714](https://github.com/buster14a/buster/pull/2714) (whose record is [`tier1-ties-unread-2618-2685-2026-11-14`](../tier1-ties-unread-2618-2685-2026-11-14/README.md)), and covers [buster#2735](https://github.com/buster14a/buster/issues/2735) and [buster#2685](https://github.com/buster14a/buster/issues/2685)'s last case. By Claude, in David's directed session ([the session](https://claude.ai/code/session_01NNmNQsNkec1N4WJ65hh6VB)).

On main `56b5864`, the hoisted symbol addresses against the same compiler with no hoist at all still cost `jsonLookupStep` 295 K instructions and `speedtest1_run` 141 K by callgrind, among smaller losses. The pull request changes four things:

- **A closing a call's clobber emptied gives no hint** (`tier1_allocation_note_closing`, `BUSTER_TIER1_ALLOCATE_CLOBBERED`): the range named after it follows its value's last register rather than memory, which `luaV_execute`'s dispatch join needs for `disptab` (#2735).
- **A recipe whose hint is memory waits for its first read** before it takes a register.
- **An unused recipe entering a join rests there** (three or more predecessors; a hint that is no predecessor's closing, or a predecessor laid out later), unless it is read on every iteration of its loops (`resident_values`), in the preferred problem alone.
- **A take whose address is only a call's argument stays its own** (`ir_typed_argument`).

After main took #2734 (`45cd9ae`), the pull request merged it and left the joins' rule out (section 5): the head keeps the other three. Buster's `docs/tier1-allocation.md` ("Recipes that wait") and `docs/ir.md` describe them.

## Revisions

| Role | Commit | What |
| --- | --- | --- |
| main | `56b5864ba3c641ee6c22efea18f8e77a32f7bab2` | the base of the pull request and of the counts |
| first head | `5fb02a53f1df7fe4a94710fd700f37d7e39f61c4` | the four rules, the joins' in every problem |
| second head | `2b0c01c0bd1d13f2aa4ab4ca8ef20c9301831bdb` | the joins' rule where the resident recipes are known alone |
| third head | `fe9bcd7400b55f33cf8dc5f3e301811a22fc620e` | the joins' analyses once per block and per function, the same code out |
| main after #2734 | `45cd9aec77c4885f55da8f2ee9cace69fa394a85` | the base of section 5 |
| merge | `d7fc674` | main `45cd9ae` merged, both sides kept; section 5's experiment tree |
| head | `531c6b13408f4423e473fcab176d944a7c35b8bb` | the joins' rule left out: `tier1_cfg.c`, `tier1_emit_cfg.c` and `tier1_hot_recipes_test.c` main's again |

In sections 1 to 4, main is `56b5864` and "the head" is the third head, `fe9bcd7`; section 5 measures the head, `531c6b1`, against main `45cd9ae`.
| experiment base | `5f3c7d4` (`experiment/base.txt`) | the experiment's tree; the files the change touches are the same at `56b5864` |

## Inputs and tools

#2714's record's: the frozen `sqlite3.c` (`0a409f16…`), `speedtest1.c` at SQLite `ccc132c5`, Lua 5.4.8 with #1217's five scripts (`lstate.c` built with `-Dluai_makeseed(L)=0x2602u`), #1189's [`gap.c`](../tier1-gap-1189-2026-11-03/tools/gap.c), in a cloud container (an Intel Xeon with AVX-512, valgrind 3.22.0). `scripts/` has that record's `st.sh`, `buildlua.sh`, `luacount.sh`, `both.sh`, `fn.sh`, `fndiff.sh` and `kinds.sh`, and:
- `run.sh`: both programs' counts by the experiment's compiler for each value of `BUSTER_X2618` (into `xMODE`);
- `fnd.sh`: one function's executed instructions in two runs, normalized and diffed;
- `deadlea.py`: rip-relative `lea`s overwritten before any read, by function (none the change adds).

## 1. The experiment

`experiment/experiment-modes-2618.patch` (on `5f3c7d4`) is the experiment's tree in its last state: the rules behind `BUSTER_X2618`'s bits, and traces.
- 1: no hoist at all (`ir_typed_hoistable` refuses every take);
- 2: ties for `ADDRESS` and `LEA_ADD` results to their base (#2685's case), kept out: speedtest1 +0.19 M, Lua the same, and current main's `luaV_execute` has none of the case's `lea 0x4(%r14),…` left;
- 4: resting on closings as well as openings (#2735's first form);
- 8: the clobber's closing;
- 16: unused recipes with a register to follow claim it at their start (out: `sqlite3VdbeExec` +24 M);
- 32: the wait;
- 64: the joins' rule, its byte from the CFG consumer, #2574's hot recipes exempt; 2048 with it, no rest where the hint is a predecessor's closing, and 32768, unless a predecessor is laid out later; 4096 and 8192 thresholds of four and five predecessors;
- 128: a trace of the scan's and the coloring's choices for the function of `BUSTER_X2618_N` IR instructions (with `--lanes 1`), and `BUSTER_X2618_SIZES` each function's sizes;
- 256: the argument takes; 1024 the folds of constants converted before their `PTR_ADD`, kept out (`sqlite3_randomness` −2.3 K, `powerOfTen` +196 K); 512 a trace of the takes.

`counts/totals.tsv` has every run's speedtest1 and Lua totals with their checks (the verification hash, and each script's output against clang -O0's: all the same in every run), `counts/kinds.tar.zst` every run's per-function rows by kind, and `counts/deltas/` the functions' changes for main to the final bits and with and without the hoist. The experiment's runs had `BUSTER_X2618` in the measured programs' environment too, which moves libc's start-up by a few thousand instructions.

| Bits | speedtest1 | Lua's scripts |
| --- | ---: | ---: |
| 0 (main) | 2,657,734,155 | 4,875.0 M |
| 1 (no hoist) | 2,665,362,099 | 4,918.6 M |
| 4 | 2,657,184,486 | 4,835.0 M |
| 12 | 2,657,018,051 | 4,806.7 M |
| 32 | 2,653,989,741 | 4,857.5 M |
| 44 | 2,654,280,508 | 4,804.8 M |
| 108 | 2,644,200,470 | 4,789.5 M |
| 364 | 2,644,174,663 | 4,789.5 M |
| 35176 (the final rules) | 2,641,338,396 | 4,790.4 M |
| 35177 (and no hoist) | 2,649,473,275 | 4,833.9 M |
| 35168 (without 8) | 2,641,047,782 | 4,843.1 M |
| 35144 (without 32) | 2,654,911,843 | 4,858.0 M |
| 35112 (without 64) | 2,654,267,890 | 4,804.8 M |
| 34920 (without 256) | 2,641,364,206 | 4,790.4 M |
| 35180 (and 4) | 2,641,338,477 | 4,790.4 M |

The joins' rule was traced on `sqlite3VdbeExec` (its dispatch join's frame address in `r15`, recomputed by each handler's tail, 5.84 M), `lua_getmetatable` (a zero every predecessor held, which 2048 keeps) and `sqlite3Parser` (+1.23 M, a frame address read on 64% of the iterations, which rests at the loop's join); the wait on `jsonLookupStep` (its loop's frame address and `sqlite3CtypeMap` swapped through `r8` on each iteration).

## 2. The change

`counts/final/` has the second head's compiler (`c-prod2`, from `2b0c01c`, whose objects the head's give byte for byte) and the same code with the no-hoist switch alone (`c-fin2`, `c-fin2.patch` on `5f3c7d4`; with the switch off its objects of `sqlite3.c` and of Lua's `lvm.c`, `lstrlib.c` and `lapi.c` are byte-identical to `c-prod2`'s). The first head's compiler gave the experiment's 35176's objects byte for byte.

| Build | speedtest1 | Lua's scripts |
| --- | ---: | ---: |
| main | 2,657,734,155 | 4,875.0 M |
| head | 2,641,306,275 (−0.62%) | 4,790.3 M (−1.74%) |
| head, no hoist | 2,649,432,985 | 4,833.9 M |

- Main to head (`st-main-to-head.txt`, `lua-main-to-head.txt`): `sqlite3VdbeExec` −11.1 M, `sqlite3_str_vappendf` −1.5 M, `sqlite3BtreeInsert` −1.3 M; `luaV_execute` −76.2 M, `str_gsub` −3.7 M, `match` −3.3 M. Losses: `sqlite3Parser` +1.23 M, `lookupName` +0.18 M, `resolveP2Values` +0.16 M, `sqlite3Prepare` +0.14 M (the joins' rule); no Lua function more than 65 instructions.
- No hoist to hoist (`st-nohoist-to-hoist.txt`): speedtest1 −8.1 M, Lua −43.6 M, no Lua function more. speedtest1's: `jsonParseFree` +126 K (unit inlining keeps it a function and inlines `jsonParseReset` into it; with its callers, +2.4 K), `sqlite3GetInt32` +5.4 K, `sqlite3_randomness` +3.7 K, `sqlite3PcacheTruncate` +2.8 K, `sqlite3HashClear` +2.1 K, and every other function under 1.4 K.

The first head failed CI's `test-checker-driver` part 1 of 8 (`tier1_table_loop`'s single relocated table base, which rested at its loop's join in a function without calls); the second head's rule passes it.

## 3. The compile's extra work, by callgrind

`compile-callgrind/`: `sqlite3.c`'s `--tier1 --lanes 1 -c` under callgrind (`ulimit -v 67108864`), by x86-64 Release builds on the experiment's base: main's code (`c-exp1`, with the no-hoist switch off), the second head's (`c-fin2`) and the head's (`c-fin3`), the last two's objects byte-identical. The second head ran 131.9 M more instructions (+0.68%): `tier1_cfg_prepare` +60.8 M, which walked a join's predecessors for every range entering it, `dominators_analyze` +29.6 M and `tier1_emit_cfg_hot_recipes` +27.6 M, the resident test's own loop analysis and its walks of every recipe, and `tier1_allocate_hinted` +13.5 M. The head computes each block's byte once, analyzes the loops once for both hot tests and tests only the recipes with an unused range entering a join: +22.4 M (+0.12%), of which the scan +13.5 M, `tier1_cfg_prepare` +10.3 M and the resident test +9.8 M (`main-to-head.txt`, `main-to-2b0c01c.txt`, functions of 0.1 M or more).

## 4. Run time and compile time on the 9700X

`scripts/run2618g.sh` is #2714's record's `run2618d.sh` with its paths renamed, for main `56b5864` (base) and the head `fe9bcd7`, each build step and round one hold of the lock (`9700x/holds.txt`, sixteen holds from 19:09 to 19:50 UTC): Lua's 33 objects linked in #2618's six orders, speedtest1 at the driver's link and at six pads, 74 checks (`9700x/checks.txt`, all the same), a warm-up round and eleven rounds, each process one `perf stat` pinned to CPU 2; every round's compile outputs round 0's. `scripts/analyze.py`, `layouts.py` and `compile.py` make the analyses.

| Program | Metric | head / main | 95% interval |
| --- | --- | ---: | ---: |
| Lua's five scripts, six link orders | time | 0.9868 | 0.9818 to 0.9918 |
| | user cycles | 0.9866 | 0.9815 to 0.9918 |
| | user instructions | 0.9827 | 0.9825 to 0.9830 |
| speedtest1, six layouts | time | 0.9985 | 0.9907 to 1.0064 |
| | user cycles | 0.9967 | 0.9901 to 1.0033 |
| | user instructions | 0.9937 | 0.9937 to 0.9937 |

| Compile | Metric | head / main | paired rounds, median (range) |
| --- | --- | ---: | ---: |
| `sqlite3.c`, `--tier1 -c` | time | 1.0044 | 1.0048 (1.0028 to 1.0077) |
| | user cycles | 1.0049 | 1.0051 (1.0043 to 1.0084) |
| | user instructions | 1.0035 | 1.0035 |
| Lua's 33 sources, `--tier1` | time | 1.0115 | 1.0115 (0.9911 to 1.0159) |
| | user instructions | 1.0042 | 1.0042 (1.0002 to 1.0042) |

**Reading.** Lua is faster at every link order (0.980 to 0.994), its scripts `calls` 0.978, `closures` 0.987, `strings` 0.989, `arithmetic` 0.990, `tables` 1.001; speedtest1's 0.63% fewer instructions don't resolve in its time over the layouts. `9700x-2b0c01c/` is the same run for the second head, whose code is the head's: Lua 0.9921 (0.9836 to 1.0007), speedtest1 0.9955 (0.9909 to 1.0002), and its compile 1.16% more time for 1.65% more instructions, which the head's cheaper analyses bring to 0.48% and 0.35%.

## 5. After #2734: the joins' rule left out

Main's #2734 (`45cd9ae`: `tier1_cfg_carried_unread`, `alternate_intervals`) proves after the allocation that no block reads an unused recipe's register, and enters the value as its recipe, which takes most of the dispatch joins' recomputations the joins' rule took. The merge (`d7fc674`) kept both; `counts/merge/` measures it with `experiment-modes-merge.patch`'s switches (`c-m`; `BUSTER_X2618`: 1 no hoist, 8 no clobber mark, 32 no waiting, 512 waiting for used ranges alone, 64 no joins' rule, 256 no argument takes; 128 with `BUSTER_X2618_N` traces one function's scan, `c-mt`), main's compiler (`c-main3`) and the head's (`c-final`, which `531c6b1`'s Release build gives byte for byte, and whose objects `c-m` gives with 64). `totals.tsv` has every run; the variable's bytes in the environment move a few thousand instructions between `c-final` and `c-m` with 64. All runs verify speedtest1's hash and Lua's five outputs.

| Build | speedtest1 | Lua's scripts |
| --- | ---: | ---: |
| main `45cd9ae` | 2,626,659,235 | 4,773.9 M |
| head | 2,625,623,908 (−0.04%) | 4,768.9 M (−0.10%) |
| head, no hoist (65) | 2,633,837,253 | 4,812.5 M |
| head and the joins' rule (0) | 2,625,035,708 | 4,769.1 M |
| head without the clobber's closing (72) | 2,625,338,106 | 4,821.2 M |
| head without waiting (96) | 2,626,645,724 | 4,771.4 M |
| head, used ranges alone waiting (576) | 2,625,920,346 | 4,769.3 M |
| head without the argument takes (320) | 2,625,632,902 | 4,768.9 M |

- **Main to head** (`st-main-to-head.txt`, `lua-main-to-head.txt`, functions changing by 1,000 or more): `sqlite3BtreeInsert` −1.10 M, `sqlite3_str_vappendf` −0.57 M, `instrFunc` −0.35 M, `jsonLookupStep` −0.29 M; `str_gsub` −3.45 M, `str_format` −0.72 M, `match` −0.72 M, `luaV_execute` −0.12 M, and no Lua function more. Losses: `sqlite3VdbeExec` +2.44 M, `checkTreePage` +0.12 M, `sqlite3Select` +64 K, `whereLoopAddBtreeIndex` +51 K. Unused recipes waiting costs `sqlite3VdbeExec` its 2.44 M (`st-used-waits-to-all-waits.txt`): the registers they left take other values, and a handler's block swaps two loaded values through `r11` on its way to the join. With used ranges alone waiting, `sqlite3VdbeExec` runs as on main, but `speedtest1_run` keeps 70 K against no hoist and speedtest1 runs 0.30 M more in all.
- **No hoist to hoist** (`st-nohoist-to-hoist.txt`, `lua-nohoist-to-hoist.txt`, 65 to 64): speedtest1 −8.2 M, Lua −43.6 M, every Lua function the same or fewer, `jsonLookupStep` (−2.6 K) and `speedtest1_run` (−70 K) too. speedtest1's that run more: `jsonParseFree` +126 K (the inlining shift; +2.4 K with its callers), `sqlite3GetInt32` +5.4 K and `sqlite3HashClear` +2.1 K (addresses defined before a loop that mostly runs no iteration), `sqlite3_randomness` +3.7 K, `sqlite3PcacheTruncate` +2.8 K, `jsonInsertIntoBlob` +1.3 K, and every other function under 1 K.
- **The joins' rule** (`st-without-to-with-joins.txt`, `lua-without-to-with-joins.txt`, 64 to 0) gains speedtest1 0.58 M and costs Lua 0.2 M on this main, against 12.9 M and 14.4 M on `56b5864`; it needs #2574's hot test over every recipe with an unused range entering a join and a byte per range, and it costs `sqlite3Parser` its 1.2 M. The head leaves it out.

On the 9700X, `scripts/run2618h.sh` (`run2618g.sh` with its paths renamed) ran main `45cd9ae` against the head `531c6b1` (`9700x-531c6b1/`, seventeen holds of the lock from 20:15 to 20:41 UTC, 74 checks the same, every round's compile outputs round 0's):

| Program | Metric | head / main | 95% interval |
| --- | --- | ---: | ---: |
| Lua's five scripts, six link orders | time | 1.0002 | 0.9926 to 1.0079 |
| | user cycles | 1.0003 | 0.9922 to 1.0084 |
| | user instructions | 0.9990 | 0.9987 to 0.9993 |
| speedtest1, six layouts | time | 0.9974 | 0.9941 to 1.0008 |
| | user cycles | 0.9954 | 0.9922 to 0.9986 |
| | user instructions | 0.9996 | 0.9996 to 0.9996 |

| Compile | Metric | head / main | paired rounds, median (range) |
| --- | --- | ---: | ---: |
| `sqlite3.c`, `--tier1 -c` | time | 0.9966 | 0.9965 (0.9949 to 0.9991) |
| | user cycles | 0.9962 | 0.9969 (0.9952 to 0.9997) |
| | user instructions | 1.0005 | 1.0005 |
| Lua's 33 sources, `--tier1` | time | 1.0047 | 1.0064 (0.9884 to 1.0092) |
| | user instructions | 1.0026 | 1.0026 (0.9986 to 1.0026) |

**Reading.** Lua's 0.10% fewer instructions don't resolve in its time: by link order its scripts' cycles move with the layout for the same instructions (`closures` 0.981 to 1.035, `arithmetic` 0.973 to 1.012), the aliasing #2714's record found for `arithmetic`. speedtest1 takes 0.46% fewer cycles for 0.04% fewer instructions, fewer at five of its six layouts. Without the joins' analyses, `sqlite3.c`'s compile runs 0.05% more instructions, against the third head's 0.35%.

## Tests

The head's Release and AddressSanitizer builds pass the 23 commands (`tests-release.txt`, of the second head; `tests-asan.txt`, of the head) and `test-checker-driver`'s part 1 of 8 (`driver-part1-head.txt`, `driver-part1-head-asan.txt`); the first head's compiler fails that part's two checks (`driver-part1-first-head.txt`). The head `531c6b1`'s Release and AddressSanitizer builds pass the 23 commands (`tests-release-531c6b1.txt`, `tests-asan-531c6b1.txt`, whose extra line is a usage probe that exits 1 by design) and the driver's part 1 of 8, 34,931 checks (`driver-part1-531c6b1.txt`, `driver-part1-531c6b1-asan.txt`), with no sanitizer report.
