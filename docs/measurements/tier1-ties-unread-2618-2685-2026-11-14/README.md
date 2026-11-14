# Two-address ties, folded takes and unread recipes (#2685, #2618), 2026-11-14

This is the evidence for [buster14a/buster#2714](https://github.com/buster14a/buster/pull/2714), the rest of [buster#2618](https://github.com/buster14a/buster/issues/2618) after [buster#2688](https://github.com/buster14a/buster/pull/2688) (whose record is [`tier1-hoist-split-2618-2026-11-13`](../tier1-hoist-split-2618-2026-11-13/README.md)) and [buster#2685](https://github.com/buster14a/buster/issues/2685). By Claude, in David's directed session ([the session](https://claude.ai/code/session_01NNmNQsNkec1N4WJ65hh6VB)).

#2688 left these costs of the hoist, against no hoist, by callgrind: `speedtest1_run` +0.21 M (blocked by #2685: no two-address hint), `jsonLookupStep` +0.10 M and `hexFunc` +0.07 M. The pull request changes three things:

- **Tier 1: two-address ties (#2685).** `tier1_select_ties` names the operands whose register a node's result may take to leave out its records' copy into the destination. Both consumers hint the result to one whose interval ends at the definition: the CFG consumer's problem by `Tier1CfgInput.ties` (`tier1_cfg_ties`), the straight-line consumer's by the allocator's value hints. A value a return reads takes no tie (`tier1_select_returned`).
- **IR lowering: folded takes and the walks through `&&`.** A take whose access Tier 1 folds rip-relative (a load at a constant offset, a store of a constant or a local) stays its own (`ir_typed_folds`). The placement's iteration walks go from a `&&`'s or `||`'s alternative straight to its truth value's join's choice for it.
- **Tier 1 allocation: unread recipes.** A recipe evicted before any use read it, having held its register since its interval's start, is recomputed from that start, and its opening becomes the memory hint (`tier1_allocation_evict`; not at a call's clobber). An unused recipe whose hint names no register rests without one.

Buster's `docs/tier1-allocation.md` ("Two-address results", "Recipes evicted before a read") and `docs/ir.md` (the preheader's paragraphs) describe them.

The evidence has three parts:
- dynamic instruction counts by callgrind, in a cloud container, of the change, its parts and the variants measured on the way;
- the compile's extra work, by callgrind;
- run time and compile time on the Ryzen 7 9700X.

## Revisions

| Role | Commit | What |
| --- | --- | --- |
| base01 | `01a2d0b33e6a1726615703827c7190310ad45587` | #2688's head, the base of the experiment's compilers |
| main | `389d25b91a8bbc6faba040125be2ccad51b6815d` | buster's main when the change was rebased on it, the base of the final measurements |
| head | `282d115794e6940350f0d6d3eefa593a13ec0a89` | the pull request's head as measured: three commits and the documentation's |
| main2 | `98186d5e39d897ce2e4d11c0025f9f77beaee72e` | buster's main merged into the branch after the merge queue dropped it, with #2592 |
| head2 | `c69008906fbf87caddc8857769f9b6fe119c6af6` | the branch after that merge, the follow-up's commits and resting on openings alone; its code is the pull request's final head `ceef744e`'s, which changes only the guide |

## Inputs

These are #2688's record's, which are #2593's: the frozen `sqlite3.c` (`0a409f16…`), `speedtest1.c` at SQLite `ccc132c5`, Lua 5.4.8 with #1217's five scripts, and #1189's [`gap.c`](../tier1-gap-1189-2026-11-03/tools/gap.c) (`counts/inputs.sha256`). Lua's `lstate.c` is built with `-Dluai_makeseed(L)=0x2602u` for the instruction counts (`scripts/buildlua.sh`); the 9700X's runs keep the stock seed. Builds are `measure-tier1-programs`'s: `--tier1 -fno-asynchronous-unwind-tables` at the default target.

## 1. Dynamic instruction counts

**Host.** A cloud container: an Intel Xeon with AVX-512, valgrind 3.22.0, GNU objdump 2.42 (`counts/host.txt`). The experiment's compilers were built from `01a2d0b3` and the working tree by `./build.sh` (Release) with the container's clang 23.1.6; `main` and `head` by main's `./build.sh --config Release`, which stages CI's LLVM 23.1.4.

**Tools** (`scripts/`): #2688's record's `st.sh`, `buildlua.sh`, `luacount.sh`, `both.sh`, `fn.sh` and `fndiff.sh`, with their scratch directory under `~/.cache/claude-2618b`. `experiment-modes-2685.patch` (on `01a2d0b3`) is the experiment in its last state: the change behind a switch, `BUSTER_X2685`, a bit per variant, and two traces (bit 4096) of the typed CFG's blocks and of the scan's choices.

**The compilers and their bits** (`counts/compilers.sha256`):
- `c-base`: `01a2d0b3`.
- `c-a`: the CFG consumer's ties alone, no switch.
- `c-x`: the CFG consumer's and the straight-line consumer's ties; bit 1 drops the CFG's, bit 2 the straight line's; bit 4 leaves the folded takes out of the hoist.
- `c-x2`: `c-x`, and bit 8 no hoist at all; bit 16 keeps the folded takes in the placement but leaves them their own, and doesn't count them towards the two takes.
- `c-x5`: `c-x2`, and bit 32 the walks through `&&`'s alternatives. (`c-x3` had the walks without the join's comparison with zero, which matched no stream; `c-x4` added the trace.)
- `c-x6`: `c-x5`, and bit 64 no tie for a value a return reads (a scan per value in the experiment, one pass in the change).
- `c-x7`: `c-x6`, and bit 128 the eviction before a read at every eviction site.
- `c-x8`: bit 128 the eviction before a read by a required value's victim choice, 256 by a hinted value (#2618's yields), 512 at a call's clobber.
- `c-x10`: `c-x8`, and bit 2048 the opening's memory hint and the resting rule together (`c-x9` added the scan's trace).
- `c-x11`: bit 2048 the opening's memory hint alone, 8192 the resting rule: the patch's state.
- `c-main` and `c-head`: `389d25b9` and `282d1157`.

**Retained.**
- `counts/totals.txt` has every run's whole speedtest1 process and Lua's five scripts' sum, with the checks: each script's output against clang -O0's (all five the same in every run) and speedtest1's verification hash (`1248168 a7fa3957…` in every run).
- `counts/kinds.tar.zst` keeps gap's per-function rows by instruction kind (no instructions' text) for every run.
- `counts/deltas/` has the functions' changes between runs (`fndiff.sh`, the 40 largest each way).
- `counts/executables.sha256` has every run's executables' hashes.

| Run | Compiler, bits | speedtest1 | Lua's scripts |
| --- | --- | ---: | ---: |
| `base` | `c-base` | 2,991,506,844 | 5,300,873,241 |
| `a` | `c-a` | 2,984,619,873 | 5,279,097,774 |
| `x0` | `c-x`, 0 | 2,984,191,934 | 5,279,022,324 |
| `x4` | `c-x`, 4 | 2,984,214,391 | 5,279,022,324 |
| `y8` | `c-x2`, 8 | 2,991,894,623 | 5,315,182,802 |
| `y16` | `c-x2`, 16 | 2,984,190,724 | 5,279,022,352 |
| `z32` | `c-x5`, 32 | 2,984,292,217 | 5,279,022,352 |
| `z36` | `c-x5`, 4 + 32 | 2,983,995,352 | 5,279,022,352 |
| `w64` | `c-x6`, 64 | 2,983,710,933 | 5,279,022,352 |
| `w100` | `c-x6`, 4 + 32 + 64 | 2,983,487,647 | 5,279,022,310 |
| `v192` | `c-x7`, 64 + 128 | 2,982,184,236 | 5,371,967,471 |
| `v228` | `c-x7`, 4 + 32 + 64 + 128 | 2,981,898,750 | 5,371,967,471 |
| `u192` | `c-x8`, 64 + 128 | 2,981,717,818 | 5,278,782,310 |
| `u448` | `c-x8`, 64 + 128 + 256 | 2,981,437,379 | 5,278,716,309 |
| `t2496` | `c-x10`, 64 + 128 + 256 + 2048 | 2,969,600,360 | 5,151,740,368 |
| `t2240` | `c-x10`, 64 + 128 + 2048 | 2,969,623,651 | 5,151,740,368 |
| `s8256` | `c-x11`, 64 + 8192 | 2,971,171,139 | 5,151,740,368 |
| `s10724` | `c-x11`, 4 + 32 + 64 + 128 + 256 + 2048 + 8192 | 2,969,344,164 | 5,151,736,636 |
| `n10732` | `c-x11`, the same and 8 | 2,977,341,095 | 5,170,611,921 |
| `main` | `c-main` | 2,871,099,427 | 5,235,799,863 |
| `head` | `c-head` | 2,851,421,919 | 5,090,403,527 |

**Reading.**
- **Ties** (`st-base-to-x0.txt`, `st-base-to-w64.txt`): speedtest1 −7.31 M, the straight-line consumer's 0.43 M of it (`a` to `x0`), and Lua's scripts −21.85 M (`index2value` −9.14 M, `luaV_execute` −3.87 M). `memsys5Size` +0.48 M: its `imul`'s two operands both end there, and the first one's `rcx` took the product, which the return then copied into `eax`, where the lowest free register had put it. Bit 64 gives a returned value no tie and takes that back (`w64`); no function then loses more than 23 K (`sqlite3WhereCodeOneLoopStart`).
- **Folded takes** (`st-x0-to-x4.txt`): `speedtest1_run` −0.27 M and `memsys5Unlink` −0.02 M, where without the ties `memsys5Unlink` and `memsys5MallocUnsafe` had lost 0.30 M each (#2688's record's `z3-m128`). `memsys5MallocUnsafe` still loses 0.32 M: its folded take of `mem5.szAtom` at the function's entry had kept the other takes' nearest common dominator outside its loops; without it, that is the header of `for(iBin=iLogsize; iBin<=LOGMAX && mem5.aiFreelist[iBin]<0; iBin++)`, whose typed CFG has a path from the `&&`'s alternative (a block of `CONST 0`) through its truth value's join (`CONST 0; NE; BRANCH_FALSE`) into the body, which takes nothing (`c-x4`'s trace of the blocks). Bit 32 takes the alternative straight to the join's choice in the walks (`z36`: −0.20 M against `x0`, with `sqlite3Atoi64` +0.09 M and `sqlite3_strnicmp` +0.01 M, whose `sqlite3CtypeMap` the walks lift out of an `isspace` loop and whose registers then shift). The walks alone cost 0.10 M (`z32`); bit 16 instead of 4 gains nothing (`y16`).
- **Eviction before a read** (`st-w64-to-u192.txt`, `-u448`, `-v192`): by a required value's victim choice −1.99 M on speedtest1 and −0.24 M on Lua; with the hinted values' too −2.27 M and −0.31 M; at a call's clobber too, Lua +92.9 M, all of it `luaV_execute` (`lua-w64-to-v192.txt`): a handler that calls before its first read of `disptab` enters without it, and every handler takes the first one's entry convention (#1216).
- **Resting** (`st-w64-to-s8256.txt`, `lua-w64-to-s8256.txt`): speedtest1 −12.54 M (`sqlite3VdbeExec` −7.19 M), Lua −127.28 M (`luaV_execute` −125.8 M: 68.0 M fewer register moves and 48.2 M fewer frame `lea`s, by `kinds.tar.zst`'s rows). With the eviction before a read and the opening's memory hint, −14.11 M and −127.28 M (`t2496`); the memory hint is what makes `hexFunc`'s header rest (`c-x9`'s trace).
- **All of it** (`s10724`, the change's code on `01a2d0b3`): speedtest1 −22.16 M (−0.74%), Lua −149.14 M (−2.81%).
- **Against no hoist** (`st-n10732-to-s10724.txt`): with every rule, the hoist gains speedtest1 8.00 M and Lua 18.88 M. `speedtest1_run`, `memsys5Unlink`, `jsonTranslateBlobToText` and `sqlite3FindFunction` run the same instructions with and without it, `jsonLookupStep` 431 fewer and `memsys5MallocUnsafe` 0.32 M fewer. `hexFunc` runs 675 more: its back edge no longer moves `hexdigits`, but the definition before its loop, evicted before any read by the loop's first value, still runs on each of its 675 calls. No function loses more than 30 K to the hoist (`sqlite3Atoi64` +29.6 K, `sqlite3Select` +13.1 K, `sqlite3_strnicmp` +11.5 K, `sqlite3GetInt32` +10.7 K).
- **Main against the head** (`st-main-to-head.txt`, `lua-main-to-head.txt`): speedtest1 −19.68 M (−0.69%), Lua's scripts −145.40 M (−2.78%; `calls` −4.7%, `tables` −2.0%, `strings` −0.6%, `arithmetic` −6.6%, `closures` −1.2%). `luaV_execute` −129.75 M, and no Lua function runs more. speedtest1's largest losses are `sqlite3ExprCodeTarget` +0.17 M, `sqlite3BtreeIndexMoveto` +0.09 M and `sqlite3WhereBegin` +0.09 M, against `sqlite3VdbeExec` −4.83 M, `sqlite3_str_vappendf` −2.04 M and `sqlite3BtreeInsert` −1.55 M.

## 2. The compile's extra work, by callgrind

valgrind can't run the native compiler, so main and the head were built at `BUSTER_HOST_ARCH=x86-64` (Release, in worktrees of their own; `scripts/cgcompile2.sh`), and each ran the frozen `sqlite3.c`'s `--tier1 -c` with speedtest1's flags under callgrind (`compile-callgrind/totals.txt`): 16,618.97 M and 16,634.76 M instructions, +15.79 M (+0.095%). By function (`compile-callgrind/delta-main-head.tsv`):
- `tier1_emit_cfg_problem` +7.90 M and `tier1_select_ties` +3.45 M: each value's ties and the returned values' marks, one pass over the nodes each;
- `tier1_cfg_prepare` +3.93 M: `tier1_cfg_ties`, two binary searches per tied value;
- `tier1_allocate_hinted` +3.58 M and `tier1_allocate_impl` −1.58 M: the straight-line consumer's allocation now takes the hinted copy;
- `ir_lower_typed_target_path` +0.58 M: the walks' successors, in functions with hoisted symbols alone;
- `encode_one` −1.47 M and `instruction_is_valid` −1.47 M: fewer instructions to encode.

The rows without symbols are the same code at moved addresses.

## 3. Run time and compile time on the 9700X

`scripts/run2618d.sh` is #2688's record's `run2618c.sh` with its paths renamed and Release builds (main's `./build.sh` builds Develop by default), for main `389d25b9` (base) and the pull request's head `282d1157`, each build step and each round one hold of the lock (`9700x/holds.txt`, seventeen holds from 10:51 to 11:43 UTC):
- each compiler built at its commit (`BUSTER_DEBUG_INFO=0`; `9700x/compilers.sha256`);
- Lua's 33 objects by each compiler's `--tier1`, linked by cc in #2618's six orders (`9700x/orders.txt`); speedtest1 by the driver's link, and as one object linked by cc after a pad of 0, 16, 32, 48, 1,072 and 3,088 bytes (`9700x/objects.sh`, `9700x/build-layouts.sh`; every executable's hash in `9700x/executables.sha256` and `9700x/layouts/executables.sha256`);
- before any timing, every Lua executable printed clang -O0's output for every script, and every speedtest1 executable gave the verification hash (`9700x/checks.txt`: 74 checks, all the same);
- a warm-up round and eleven rounds (`9700x/round.sh`), each one hold: every order's two Lua builds on all five scripts, speedtest1's two builds at the driver's link and at each layout, and each compiler's `--tier1 -c` of `sqlite3.c` and `--tier1` of Lua's 33 sources, the builds' order rotating by round and by order or layout, each process one `perf stat` of task-clock, user cycles and user instructions, pinned to CPU 2 (`9700x/runs.txt`, `9700x/layouts/runs.txt`, `9700x/compile-runs.txt`; the warm-up's apart). Every round's compile outputs were round 0's (`9700x/compile-0.sha256`, `compile-11.sha256`), and every process exited 0.

`scripts/analyze.py` makes `9700x/analysis.md`, `scripts/layouts.py` `9700x/layouts/analysis.md` and `scripts/compile.py` `9700x/compile-analysis.md`. `9700x/run.log` is the script's own log.

| Program | Metric | head / base | 95% interval over the layouts |
| --- | --- | ---: | ---: |
| Lua's five scripts, six link orders | time | 0.9875 | 0.9599 to 1.0160 |
| | user cycles | 0.9875 | 0.9586 to 1.0173 |
| | user instructions | 0.9725 | 0.9723 to 0.9728 |
| speedtest1, six layouts | time | 0.9941 | 0.9907 to 0.9974 |
| | user cycles | 0.9910 | 0.9851 to 0.9970 |
| | user instructions | 0.9930 | 0.9930 to 0.9930 |

**Reading.**
- Lua runs 2.75% fewer user instructions at every link order and is faster at five of the six (0.951 to 0.999), 3.3% slower at order 0. By script, over the orders' medians: `arithmetic` 0.965, `strings` 0.972, `closures` 0.990, `calls` 0.991, `tables` 0.994.
- speedtest1 runs 0.70% fewer user instructions at every layout and its cycles fall at all six (0.9857 to 0.9984); at the driver's link, its time is 0.9884.
- The compile (`9700x/compile-analysis.md`): `sqlite3.c`'s `--tier1 -c` takes 1.27% more time (paired rounds 1.0070 to 1.0149) and 1.24% more user cycles, for 0.22% more instructions; Lua's 33 sources' `--tier1`, 1.08% more time and 1.31% more cycles, for 0.16% more instructions.

## 4. The compile's cycles

`scripts/prof.sh` recorded, in one hold, each compiler's `sqlite3.c` `--tier1 -c` three times with `perf record -e cycles:u` and three times with `perf stat` of cycles, instructions, branch misses, L1 instruction and data cache misses and dTLB misses, pinned to CPU 2 (`9700x/prof/`: the reports' 400 hottest symbols and the counters). The head ran 30 M more cycles, 1.0 M more L1 instruction-cache misses (+8.7%) and 0.55 M more branch misses. By symbol, about 21 M cycles are the change's own:
- `tier1_emit_cfg_problem` +10.2 M (the ties' and the returned values' passes, which read each node's selection pattern again after its first pass had);
- `tier1_allocate_hinted` +4.0 M (the straight-line consumer now took the hinted copy);
- `tier1_select_ties` +2.3 M, `tier1_cfg_prepare` +2.1 M, `memset` +2.1 M.

The rest moves in functions the change doesn't touch (`check_lower_operand` +3.1 M, `ir_optimize_rewrite` +4.6 M, `ir_check_rows` −3.8 M): the compiler's code placement.

The follow-up (`a5af8212`, in its own pull request after this one) computes the ties in the problem's first pass, which reads each pattern anyway, maps them to values in the values' pass, and gives the straight-line consumer's allocator hints only where some result has a tie. Its objects of `sqlite3.c` and of Lua 5.4.8 are byte-identical to the commit before it. `scripts/compile-ab.sh` built main, this pull request's head and the follow-up (the head with `scripts/patches/`, which also leave out the definitions no edge reads) at six placements of the backend unit (`./build.sh shifts`, 0 to 3,440 bytes), and timed `sqlite3.c`'s and `lvm.c`'s `--tier1 -c` with `time-runs` under `ab`: three rounds, three runs of every placement from two fresh copies each, main a second time as the floor (`9700x/placements/ab.txt`). `sqlite3.c`'s user cycles against main:

| Build | Round 1 | Round 2 | Round 3 |
| --- | ---: | ---: | ---: |
| this head | +1.07% | +0.99% | +0.98% |
| the follow-up | +0.73% | +0.60% | +0.66% |
| main again | +0.07% | −0.02% | +0.07% |

The ranges over placements and copies are in `ab.txt`; `lvm.c`'s compile is within main's floor in every round.

## 5. After #2592

The merge queue dropped buster#2714 for a conflict with main, which had taken #2592 (the operand sink, "Increments after their last reader" in buster's allocation guide) since. #2592 removes much of the same traffic in `luaV_execute`. With main `98186d5e` merged into the branch, the follow-up's commits included, by callgrind (`counts/after-2592/`):

| Run | Compiler | speedtest1 | Lua's scripts |
| --- | --- | ---: | ---: |
| `main2` | main `98186d5e` | 2,878,383,592 | 5,122,797,624 |
| `merged` | the merge, resting on openings and closings | 2,858,445,021 | 5,108,903,903 |
| `m1`, `st1` | the same without resting | 2,867,348,918 | 5,101,266,583 |
| `m128`, `st128` | resting on openings alone | 2,865,623,403 | 5,100,924,561 |

The ablation compiler (`c-abl`, a switch `BUSTER_X2714` on the merge, not kept) turned each rule off in turn on Lua's scripts. Bits:
- 2, the eviction before a read: +0.00 M;
- 4, the CFG's ties: +18.6 M;
- 8, the definitions no edge reads: +9.6 M;
- 16, the straight line's ties: +0.06 M;
- 32, the folded takes: +0.05 M;
- 64, the walks: +0.05 M.

Resting on closings, not only on openings, cost `luaV_execute` 8.0 M (`lua-norest-to-rest.txt`). By opcode: 52.9 M fewer frame `lea`s, but 14.3 M more `lea`s of `disptab`, 23.7 M more register moves and 21.8 M more other moves. A handler's call takes `disptab`'s register, the ranges hinted to that closing rested, and with them the dispatch join's convention, so every dispatch recomputed it. Resting on openings alone (`c-abl2`, bit 128; the head's code, whose `sqlite3.c` object is the same) keeps `hexFunc`'s header without a register and gains both programs. The closings' case is [buster#2735](https://github.com/buster14a/buster/issues/2735).

The head against main: speedtest1 −12.76 M (−0.44%), Lua −21.87 M (−0.43%; every script −0.14% to −0.88%, `luaV_execute` −7.04 M, no function more; `st-main2-to-final.txt`, `lua-main2-to-final.txt`).

## 6. The 9700X after #2592

`scripts/run2618e.sh` is `run2618d.sh` against main2 (base) and head2, in `~/buster-fast-bench/2618e-claude`; seventeen holds from 12:44 to 13:38 UTC (`9700x-after-2592/holds.txt`). The run's first attempt fetched a mistyped base commit and stopped (`run.log`'s first line). Every check gave clang -O0's output or the verification hash (`checks.txt`), and the compile's outputs were the same in round 0 and round 11. The same scripts made `analysis.md`, `layouts/analysis.md` and `compile-analysis.md`.

| Program | Metric | head2 / main2 | 95% interval over the layouts |
| --- | --- | ---: | ---: |
| Lua's five scripts, six link orders | time | 1.0022 | 0.9912 to 1.0133 |
| | user cycles | 1.0019 | 0.9914 to 1.0125 |
| | user instructions | 0.9956 | 0.9953 to 0.9960 |
| speedtest1, six layouts | time | 1.0003 | 0.9934 to 1.0073 |
| | user cycles | 0.9987 | 0.9928 to 1.0046 |
| | user instructions | 0.9955 | 0.9955 to 0.9955 |

| Compile | Metric | head2 / main2 | paired rounds, median (range) |
| --- | --- | ---: | ---: |
| `sqlite3.c`, `--tier1 -c` | time | 1.0072 | 1.0064 (0.9992 to 1.0096) |
| | user cycles | 1.0069 | 1.0072 (1.0004 to 1.0108) |
| | user instructions | 1.0042 | 1.0042 |
| Lua's 33 sources, `--tier1` | time | 1.0109 | 1.0144 (0.9903 to 1.0195) |
| | user cycles | 1.0043 | 1.0057 (0.9993 to 1.0091) |
| | user instructions | 1.0056 | 1.0056 (1.0002 to 1.0056) |

**Reading.**
- After #2592, the change's run-time gain is its instructions alone: 0.44% fewer for Lua and 0.45% fewer for speedtest1, at every order and layout, and no change in time or cycles that the orders or layouts resolve.
- Lua's `arithmetic` script depends on the link order: its cycles move by 0.973 to 1.079 over the six orders, for 0.14% fewer instructions (the other scripts 0.97 to 1.05). Before #2592 the same script was 0.945 to 0.981 at every order.
- The compile costs 0.69% more `sqlite3.c` cycles, for 0.42% more instructions: less than the first head's 1.24% against main.

**Lua's `arithmetic` script, by alignment** (`9700x-after-2592/arithmetic/`; `scripts/luaprof.sh`, `luamisp.sh`, `luapad.sh`, each one hold). At orders 1 and 4 (head 1.079 and 1.071), five runs of each build with the predictor's and the front end's counters give the head 13 M more cycles (183 M against 170 M) and 330 K more retired mispredictions (about 500 K against 167 K) in every run, for 1.44 M fewer instructions. At order 5 (0.973), the head mispredicts as often as main (167 K) and runs 5 M fewer cycles. Sampled every 211 mispredictions, the head's extra ones at order 1 fall in `luaV_mod` (31% of them, 7% at main), whose code is the same in both builds, and in `luaV_execute`'s dispatch near +6600.

Order 1 linked again after a pad of 64 to 960 bytes, every byte of code moved by a multiple of 64 (`arithmetic/pad/`, three runs each, the same output):

| Pad, bytes | `luaV_mod` mod 128, head | head: cycles, M | mispredictions, K | main: cycles, M | mispredictions, K |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 0 | 0x60 | 184.4 | 498 | 170.0 | 170 |
| 64 | 0x20 | 171.3 | 204 | 170.1 | 170 |
| 128 | 0x60 | 184.7 | 500 | 169.6 | 167 |
| 256 | 0x60 | 183.5 | 499 | 170.0 | 167 |
| 512 | 0x60 | 185.1 | 499 | 169.9 | 167 |
| 576 | 0x20 | 171.3 | 204 | 170.5 | 167 |
| 960 | 0x20 | 171.7 | 213 | 170.7 | 177 |

The cycles are each cell's median. A shift by whole 64-byte lines leaves every line's instructions as they were, so the extra mispredictions are the predictor's tables aliasing at the head's branch addresses: the head's script is 7.9% to 9.0% slower at one phase of address bit 6 and 0.5% to 0.7% slower at the other, where main's is the same at both. That is the placement's noise that the six orders average over, not instructions the change adds.

## Tests

`scripts/tests.sh` ran the Tier 1 and IR tests of `tools/ci/correctness.tests` that the change reaches on the head's compiler (`tests.txt`). A mutation build, each rule turned off at once (the CFG's and the straight line's ties, `ir_typed_folds`, the walks, the eviction before a read, the resting rule), failed `test-tier1-allocation`'s two traces of the eviction (on all three entry points), `test-tier1-emit`'s four tie checks, and `test-ir-lowering`'s two new checks.
