# Hoisted addresses split by their groups, and recipes without a register (#2618), 2026-11-13

This is the evidence for the second part of [buster#2618](https://github.com/buster14a/buster/issues/2618), after [buster#2636](https://github.com/buster14a/buster/pull/2636) and its record ([`tier1-hoist-allocator-2618-2026-11-13`](../tier1-hoist-allocator-2618-2026-11-13/README.md)). By Claude, in David's directed session ([the session](https://claude.ai/code/session_01EgbxneDBC6Qmku7tSEGvVW)).

#2636 left these costs of the hoist, by callgrind against no hoist:
- `jsonTranslateBlobToText` +0.89 M;
- `speedtest1_run` +0.27 M;
- `sqlite3FindFunction` +0.12 M;
- `jsonLookupStep` +0.10 M;
- `hexFunc` +0.07 M.

It also left Lua's `arithmetic` script running slower on the 9700X at five of six link orders with no counter explaining it. The pull request changes two things:

- **Allocator.** A recomputed value's definition needs no register (`b14580be`). Its own use is no longer required, so where values read sooner hold every register the allocator gives it none, and the emitter leaves it out. While the use was required, the assignment failed there, and its second try, with every definition freed, spilled.
- **Placement.** A symbol kept at its takes' nearest common dominator P outside loops, for a take in a loop, where some path from P takes it nowhere, splits its takes into groups by the child of P in the dominator tree that dominates each (`01a2d0b3`). Each group is placed by the same rules, where no path takes two groups' (each child entered from P alone, or from inside itself) or where P is a value join of the typed stream. Where a group would be defined at P or above, P keeps the one definition.

Buster's `docs/tier1-allocation.md` (rematerialization's dropped definitions) and `docs/ir.md` (the preheader's paragraphs) describe both.

The evidence has three parts:
- dynamic instruction counts by callgrind, in a cloud container, of the change and the variants measured on the way;
- the compile's extra work, by callgrind;
- run time and compile time on the Ryzen 7 9700X, and the `arithmetic` script's counters by pipeline slot.

## Revisions

| Role | Commit | What |
| --- | --- | --- |
| main | `b7a95eedbe16fbd8434654f192f8f7aab76c56e5` | buster's main after #2636, and the base of every measurement |
| allocator | `b14580be` | the pull request's first commit |
| head | `01a2d0b33e6a1726615703827c7190310ad45587` | the pull request's second commit, the placement, on the first |

## Inputs

These are the first part's record's, which are #2593's record's: the frozen `sqlite3.c` (`0a409f16…`), `speedtest1.c` at SQLite `ccc132c5`, Lua 5.4.8 with #1217's five scripts, and #1189's [`gap.c`](../tier1-gap-1189-2026-11-03/tools/gap.c). Lua's `lstate.c` is built with `-Dluai_makeseed(L)=0x2602u` for the instruction counts (`scripts/buildlua.sh`), so that its string hash's seed doesn't move them; the 9700X's runs keep the stock seed. Builds are `measure-tier1-programs`'s: `--tier1 -fno-asynchronous-unwind-tables` at the default target.

## 1. Dynamic instruction counts

**Host.** The first part's cloud container: an Intel Xeon with AVX-512, clang 23.1.6, valgrind 3.22.0, GNU objdump 2.42. Each compiler was built there natively by `./build.sh` (Release).

**Tools** (`scripts/`, the first part's, with their scratch directory under `~/.cache/claude-2618`): `st.sh`, `buildlua.sh`, `luacount.sh`, `both.sh`, `modes.sh`, `fn.sh`, `fndiff.sh` and `kinds.sh` as there. `experiment-modes.patch` (on `b7a95eed`) is the experiment's switch, `BUSTER_X2618`, a bit per variant, in its last state, with two traces (bits 2048 and 4096) that print the allocator's choices and the splits. The compilers `y1`, `y3`, `z1`, `z3`, `z5` and `z7` were its successive states, each adding bits. `y1`'s bit 1 was incomplete (its emitter refused the definitions it left out), so only its other bits' runs are kept. `c1` is the pull request's head, built from it.

**Retained.**
- `counts/totals.txt` has every run's whole speedtest1 process and Lua's five scripts' sum, with the checks: speedtest1's verification hash, and each script's output against clang -O0's. `counts/*/` keeps each run's.
- `counts/kinds.tar.zst` keeps gap's per-function rows by instruction kind (no instructions' text) for every run.
- `counts/deltas/` has the functions' changes from main to each run (`fndiff.sh`), and from `z7-m8721` to `c1`.
- `counts/executables.sha256` has every run's executables' hashes.

**The bits.**
- 1: **a recomputed value's definition needs no register** (the emitter accepts and leaves out a definition whose first fragment is its recipe's).
- 2: a recipe without a required use kept, at its start, out of callee-saved registers no range has held yet.
- 4: at a recipe's required use, no callee-saved register that no range has held yet, where another is free.
- 8: a hoisted address's constant-offset accesses folded rip-relative in Tier 1's selection.
- 16: **split a symbol kept at P for its takes in loops where some path from P takes it nowhere, by P's children.**
- 32: with 16, a group's one take inside a loop defined before that loop.
- 64: with 16, a group that would be defined at P keeping P's definition for its takes.
- 128: no hoist of a take that a load reads at a constant offset, or a store of a one-entry value writes.
- 256: a recipe gives its register (#2636's rule) only to a value whose hint is its own or an opening's.
- 512: **with 16, only where no path takes two groups' takes.**
- 8192: **with 512, or where P is a value join.**

| Run | Bits | speedtest1 | against main | Lua's scripts |
| --- | --- | ---: | ---: | ---: |
| `m2` | main | 2,993,979,550 | | 5,300,898,173 |
| `y3-m1` | 1 | 2,992,476,547 | −1.50 M | 5,300,816,293 |
| `y1-m2` | 2 | 2,993,989,756 | +0.01 M | 5,305,694,921 |
| `y3-m3` | 1, 2 | 2,990,291,965 | −3.69 M | 5,292,850,114 |
| `y1-m4` | 4 | 3,004,518,774 | +10.54 M | 5,301,128,404 |
| `y1-m6` | 2, 4 | 3,005,192,647 | +11.21 M | 5,306,007,007 |
| `y1-m8` | 8 | 2,993,946,613 | −0.03 M | 5,300,816,311 |
| `y1-m10` | 2, 8 | 2,993,965,398 | −0.01 M | 5,305,694,791 |
| `y1-m12` | 4, 8 | 3,004,494,439 | +10.51 M | 5,301,128,274 |
| `z1-m16` | 16 | 2,994,149,536 | +0.17 M | 5,300,816,181 |
| `z1-m48` | 16, 32 | 2,994,294,905 | +0.32 M | 5,300,816,181 |
| `z1-m80` | 16, 64 | 2,994,149,455 | +0.17 M | 5,300,816,181 |
| `z1-m112` | 16, 32, 64 | 2,993,741,595 | −0.24 M | 5,300,813,649 |
| `z3-m128` | 128 | 2,994,313,275 | +0.33 M | 5,300,813,649 |
| `z3-m144` | 16, 128 | 2,994,491,577 | +0.51 M | 5,300,813,649 |
| `z3-m400` | 16, 128, 256 | 2,994,491,499 | +0.51 M | 5,300,813,649 |
| `z3-m256` | 256 | 2,993,971,330 | −0.01 M | 5,300,813,649 |
| `z3-m272` | 16, 256 | 2,994,149,520 | +0.17 M | 5,300,813,649 |
| `z3-m368` | 16, 32, 64, 256 | 2,993,741,544 | −0.24 M | 5,300,813,649 |
| `z5-m1` | 1 | 2,992,476,575 | −1.50 M | 5,300,816,293 |
| `z5-m528` | 16, 512 | 2,993,079,879 | −0.90 M | 5,300,813,649 |
| `z5-m560` | 16, 32, 512 | 2,993,079,822 | −0.90 M | 5,300,813,649 |
| `z5-m561` | 1, 16, 32, 512 | 2,991,585,134 | −2.39 M | 5,300,813,631 |
| `z7-m8720` | 16, 512, 8192 | 2,992,955,588 | −1.02 M | 5,300,815,177 |
| `z7-m8721` | 1, 16, 512, 8192 | 2,991,460,958 | −2.52 M | 5,300,815,159 |
| `c1` | the head | 2,991,469,332 | −2.51 M | 5,300,898,155 |

Every run gave speedtest1's verification hash (`1248168 a7fa3957…`), and every Lua build printed clang -O0's output for every script.

**Reading.**
- Lua's functions run the same instructions in every run within 18 a function, but those with bit 2: `match` +4.9 M, and with bit 1 as well −8.0 M over the scripts (`counts/deltas/lua-main-to-y1-m2.txt`, `lua-main-to-y3-m3.txt`). The experiment's builds' totals differ from main's by up to 0.08 M outside the programs' functions; `c1`'s by 18 instructions.
- `c1` and `z7-m8721` run the same instructions in every function (`counts/deltas/st-z7-m8721-to-c1.txt`): the head's code is bits 1, 16, 512 and 8192. Its rule that a group defined at P or above leaves P's definition to them all changes no function here.
- Bit 1 (`counts/deltas/st-main-to-z5-m1.txt`): `sqlite3VdbeExec` −0.71 M, 0.29 M fewer frame addresses' `lea`s and 0.39 M fewer moves. A handler run 288,561 times no longer takes registers for two frame objects' addresses, and no longer spills and reloads a value in `r14` around them. `sqlite3Atoi64` −0.23 M, `sqlite3_str_vappendf` −0.21 M, `pageFreeArray` −0.13 M; `instrFunc` +0.17 M, its call-free loop's spills moved from one value to another.
- Bit 16 alone (`st-main-to-z1-m16.txt`): `jsonTranslateBlobToText` −0.89 M (the push and pop of a callee-saved register, and `sqlite3CtypeMap`'s `lea` at its switch, on each of 297,094 calls) and `sqlite3FindFunction` −0.12 M, but `sqlite3GetToken` +1.20 M. There, a keyword's case reads `sqlite3CtypeMap` once and then breaks to the identifier loop after the switch. The loop's group has one take, which stays its own and is recomputed on every character, 1.45 M times. With 32 the loop's group would be defined before the loop, at its header's immediate dominator, which is P; with 64 it keeps P's definition (`z1-m112`). The keyword's take is its own all the same: two `lea`s where P's one ran, +0.79 M.
- Bit 512 keeps P where the identifier loop's child is entered from the cases, and only `jsonTranslateBlobToText` changes by more than 30 instructions (`st-main-to-z5-m528.txt`). Bit 8192 adds `sqlite3FindFunction` (`st-main-to-z7-m8720.txt`): its P is a truth value's join, with incoming stack depth 1, which #2554's threading copies into its predecessors unless a definition is at its start.
- Bit 128 (`st-main-to-z3-m128.txt`): `speedtest1_run` −0.27 M, its hot `g` read at constant offsets and no longer recomputed after calls, but `memsys5Unlink` +0.30 M and `memsys5MallocUnsafe` +0.32 M. Without the hoisted address in `rax`, the second `imul`'s result in `memsys5Unlink` takes `rdx`, the lowest free register, rather than its dying operand's `edi`, and a copy runs on every call. No hint ties a two-address result to its operand: [buster#2685](https://github.com/buster14a/buster/issues/2685).
- Bit 256 changes no function in speedtest1: every value a recipe gave its register to had its own or an opening's hint.
- Bits 2 and 4 reshuffle registers widely. Bit 2 with bit 1 gains 3.69 M on speedtest1 and 8.0 M in Lua's scripts, but moves several functions by a million either way (`sqlite3Parser` +4.21 M, `yy_reduce` −3.67 M; `st-main-to-y3-m3.txt`), and alone it costs Lua 4.8 M. It isn't taken.

**What the hoist still costs**, by callgrind against no hoist: `speedtest1_run` +0.21 M (bit 128, blocked by #2685), `jsonLookupStep` +0.10 M (frame addresses giving way to hinted values under #2636's rule, then recomputed), and `hexFunc` +0.07 M, whose call-free loop needs ten values in nine caller-saved registers, so `hexdigits` is evicted inside it and moved back on its backedge.

## 2. The compile's extra work, by callgrind

valgrind can't run the native compiler, so main and the head were built at `BUSTER_HOST_ARCH=x86-64` (`scripts/cgcompile.sh`), and each ran the frozen `sqlite3.c`'s `--tier1 -c` with speedtest1's flags under callgrind (`compile-callgrind/totals.txt`): 15,102.57 M and 15,104.31 M instructions, +1.74 M (+0.012%). By function (`compile-callgrind/delta-main-head.tsv`): `tier1_emit_cfg_records` +3.62 M, `ir_typed_place` (the placement, now a function of its own) +0.17 M, `tier1_emit_cfg_problem` +0.15 M, and `tier1_allocate_hinted` −1.39 M; the rows without symbols are the same code at moved addresses.

## 3. Run time and compile time on the 9700X

`scripts/run2618c.sh` ran on benchpress the first part's `run2618b.sh` measurements after `run2618.sh`'s builds, for main `b7a95eed` (base) and the head `01a2d0b3`, each build step and each round one hold of the lock (`9700x/holds.txt`, seventeen holds from 21:17 to 22:03 UTC):
- each compiler built at its commit (`BUSTER_DEBUG_INFO=0`, native target znver5; `9700x/compilers.sha256`);
- Lua's 33 objects by each compiler's `--tier1`, linked by cc in the first part's six orders (`9700x/orders.txt`); speedtest1 by the driver's link, and as one object linked by cc after a pad of 0, 16, 32, 48, 1,072 and 3,088 bytes (`9700x/objects.sh`, `9700x/build-layouts.sh`; every executable's hash in `9700x/executables.sha256` and `9700x/layouts/executables.sha256`);
- before any timing, every Lua executable printed clang -O0's output for every script, and every speedtest1 executable gave the verification hash (`9700x/checks.txt`: 74 checks, all the same);
- a warm-up round and eleven rounds (`9700x/round.sh`), each one hold: every order's two Lua builds on all five scripts, speedtest1's two builds at the driver's link and at each layout, and each compiler's `--tier1 -c` of `sqlite3.c` and `--tier1` of Lua's 33 sources, the builds' order rotating by round and by order or layout, each process one `perf stat` of task-clock, user cycles and user instructions, pinned to CPU 2 (`9700x/runs.txt`, `9700x/layouts/runs.txt`, `9700x/compile-runs.txt`; the warm-up's apart). Every round's compile outputs were round 0's (`9700x/compile-0.sha256`, `compile-11.sha256`).

`scripts/analyze.py` makes `9700x/analysis.md`, `scripts/layouts.py` `9700x/layouts/analysis.md` and `scripts/compile.py` `9700x/compile-analysis.md`. `9700x/run.log` is the script's own log; the lock's messages, which name other sessions, aren't kept.

| Program | Metric | head / base | 95% interval over the layouts |
| --- | --- | ---: | ---: |
| Lua's five scripts, six link orders | time | 0.9990 | 0.9916 to 1.0065 |
| | user cycles | 0.9994 | 0.9924 to 1.0065 |
| | user instructions | 1.0000 | 0.9998 to 1.0001 |
| speedtest1, six layouts | time | 0.9991 | 0.9909 to 1.0074 |
| | user cycles | 0.9976 | 0.9895 to 1.0058 |
| | user instructions | 0.9991 | 0.9991 to 0.9991 |

**Reading.**
- speedtest1 runs 2.51 M fewer user instructions at every layout (2,941.00 M against 2,943.51 M), callgrind's count. Its cycles fall at four of the six layouts and rise at two (`9700x/layouts/analysis.md`), inside the layouts' spread; at the driver's link, one layout, they are 1.0043 (`9700x/analysis.md`).
- Lua's objects are byte-identical but `lcode.o`, Lua's code generator (`9700x/executables.sha256`). Its scripts run the same instructions, and their times move with the layout that `lcode.o` shifts: `arithmetic` 1.0123, `closures` 0.9965. This is section 4's finding with the hot code unchanged.
- The compile (`9700x/compile-analysis.md`): `sqlite3.c`'s `--tier1 -c` takes the same time (0.9999, paired range 0.9739 to 1.0029) and 0.06% more instructions (4,726.78 M against 4,724.01 M). Lua's 33 sources' `--tier1` take 0.29% more instructions (1,737.60 M against 1,732.50 M), their time inside the rounds' noise (1.0058, paired range 0.9853 to 1.1729).

## 4. The `arithmetic` script's slowdown

`9700x/arithmetic/arith2.sh` ran, in one hold of the lock, the first part's base and head Lua executables (`26f0bb0e` against `c68fa771`, the first part's record) at link orders 0 and 1 on `arithmetic.lua`, each `perf stat -r 11` pinned to CPU 2:
- `-M PipelineL1,PipelineL2`, Zen 5's slot accounting (`arith2-*.txt`);
- user cycles, instructions, store-to-load forwards (`ls_stlf`), loads unable to complete for a conflict with an older store (`ls_bad_status2.stli_other`) and retired ops (`arith3-*.txt`).

| Order | Build | Cycles | Front end bound, slots | Backend bound | Store-to-load conflicts |
| --- | --- | ---: | ---: | ---: | ---: |
| 0 | base | 177.0 M | 293.9 M (20.6%) | 167.5 M (11.7%) | 3.79 M |
| 0 | head | 172.6 M | 145.4 M (10.4%) | 246.2 M (17.6%) | 2.36 M |
| 1 | base | 170.8 M | 76.1 M (5.5%) | 271.9 M (19.8%) | 2.78 M |
| 1 | head | 176.4 M | 189.0 M (13.4%) | 281.7 M (19.9%) | 3.20 M |

The head ran 0.83% fewer instructions at both orders. Where a build is slower, it has the more front-end-bound slots, mostly bandwidth (no ops delivered while not waiting on a fetch), and the more store-to-load conflicts. Which build that is flips with the link order: at order 0 the base, at order 1 the head. The slots are multiplexed (each group measured about a fifth of the time), so their counts are estimates, but their sign follows the cycles at both orders. The script's time moves with code and data layout, not with the instructions the change removed.
