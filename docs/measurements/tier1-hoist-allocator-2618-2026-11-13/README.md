# Hoisted addresses and the allocator (#2618), 2026-11-13

This is the evidence for [buster#2618](https://github.com/buster14a/buster/issues/2618) and [buster#2636](https://github.com/buster14a/buster/pull/2636). By Claude, in David's directed session ([the session](https://claude.ai/code/session_01EgbxneDBC6Qmku7tSEGvVW)).

#2593 (buster#2617) placed each hoisted symbol address by its takes' dominators. A definition before a loop still took a callee-saved register, or crowded the loop's values, where the loop read it on few iterations or called on every one. #2636 changes two things:

- **Allocator.** A recipe that no use requires gives its register to a value without a recipe whose hint names it (`tier1_allocation_yields`).
- **Placement.** A definition is lifted out of a loop only where every iteration of the loop takes it, and where some loop of the nest that holds a take takes it on every iteration and has an iteration that calls nothing (`ir_typed_loop_resident`).

Buster's `docs/tier1-allocation.md` ("Recipes give way to hinted values") and `docs/ir.md` (the preheader's paragraphs) describe both.

The evidence has three parts:
- dynamic instruction counts by callgrind, in a cloud container, of the change and the variants measured on the way;
- the compile's extra work, by callgrind;
- run time and compile time on the Ryzen 7 9700X.

## Revisions

#2636's later commits change documentation alone: `b9b68dfe` and the one that adds this record's numbers to buster's docs.

| Role | Commit | What |
| --- | --- | --- |
| main | `26f0bb0e1ab0ae8fc0a7c119064796dfd4b0d5fa` | buster's main when the work began, and the base of every measurement |
| allocator | `fc97979f` | #2636's first commit, the allocator's rule |
| head | `c68fa771426f8eca326f30291874d96a80281fe7` | #2636's second commit, the placement's test, on the first |
| docs | `b9b68dfe` | #2636's third commit, documentation alone |

## Inputs

These are #2593's record's ([`tier1-hoist-places-2593-2026-11-13`](../tier1-hoist-places-2593-2026-11-13/README.md)), checked by their hashes (`counts/identities.txt`):
- the frozen `sqlite3.c` (`0a409f16…`), from `tools/ci/fetch-corpus.sh`;
- `speedtest1.c` at SQLite `ccc132c5` (`b5eaf4bb…`);
- Lua 5.4.8 (`4f18ddae…`) and #1217's five scripts (those of [`tier1-burs-lifetimes-141-2026-11-02`](../tier1-burs-lifetimes-141-2026-11-02/9700x/lua));
- #1189's [`gap.c`](../tier1-gap-1189-2026-11-03/tools/gap.c) (`81856ce1…`).

Builds are `measure-tier1-programs`'s: `--tier1 -fno-asynchronous-unwind-tables` at the default target.

## 1. Dynamic instruction counts

**Host.** A cloud container (`counts/identities.txt`): an Intel Xeon with AVX-512, clang 23.1.6, valgrind 3.22.0, GNU objdump 2.42. The compilers were built there natively, by `./build.sh` (Release).

**Tools** (`scripts/`; #2593's record's, with their scratch directory under `~/.cache/claude-2618`):
- `st.sh` builds speedtest1, checks its verification hash and runs it under callgrind.
- `buildlua.sh` builds Lua. `luacount.sh` checks each script's output against clang -O0's and runs it under callgrind. `both.sh` runs both programs, and `modes.sh` runs `both.sh` for each value of `BUSTER_X2618`.
- `fn.sh` prints a function's instructions with their counts. `fndiff.sh` prints the functions' totals' changes between two runs, and `kinds.sh` one function's change by instruction kind, from gap's rows.
- `experiment-modes.patch` (on `26f0bb0e`) is the experiment's switch, `BUSTER_X2618`, a bit per variant, in its last state. The compilers `x1` to `x14` were its successive states: each added variants or, for `x6`, fixed the every-iteration walk's test of a header that takes the address, which `x4`'s runs of bit 512 lacked. `x3`'s build raced with an edit and lacked its allocator variants, so those were measured again by `x3b`; `x3`'s runs kept are of bit 2 alone, which it had.
- `final1` is #2636's head's code, built from it.

**Retained.**
- `counts/totals.txt` has every run's whole speedtest1 process, Lua's five scripts and `luaV_execute`, with the checks. `counts/*/` keeps each run's checks and totals.
- `counts/kinds.tar.zst` keeps gap's per-function rows by instruction kind (no instructions' text) for `main`, `x1-m1`, `x3b-m32`, `x6-m512`, `x12-m16896` and `final1`.
- `counts/deltas/` has the functions' changes between runs (`fndiff.sh`).
- `counts/executables.sha256` has every executable's hash: `final1`'s are `x14-m541216`'s byte for byte, so #2636's code is the experiment's bits 16384, 512 and 32.

**The bits.**
- 1: no hoist.
- 2: a hoisted address's constant-offset accesses folded rip-relative.
- 4: a required recipe's victim chosen by its next use.
- 8: every recipe crossing a call treated as hot (callee-saved registers, `r8` to `r10`, calls evicting it). 16: the same for symbol addresses alone. 64: symbol addresses in `r8` to `r10` alone.
- 32: **the allocator's rule**, with its claims; 524288 takes the claims out.
- 256: where the loop's test fails, the definition at P (with 512).
- 512: **lift only where every iteration of the outermost loop takes it.**
- 1024: an unrequired recipe kept out of callee-saved registers no range has held yet.
- 2048: recipes crossing a call allowed the caller-saved registers, callee-saved ones first, calls evicting them.
- 4096: callee-saved registers only on the intervals of symbol addresses that cross a call. 8192: the same for every recipe.
- 16384: **and some loop of the nest that holds a take takes it on every iteration and has an iteration that calls nothing.** In `x10` and `x11` this tested the outermost loop alone.
- 65536: outside loops, a definition only where every path from P takes it.
- 262144: outside loops, where not every path from P takes it, the loops' test instead of "some take is in a loop".

| Run | Bits | speedtest1 | against main | `luaV_execute` |
| --- | --- | ---: | ---: | ---: |
| `main` | | 2,997,696,371 | | 2,414,984,478 |
| `x1-m1` | no hoist | 3,001,577,016 | +3.88 M | 2,451,144,956 |
| `x3-m2` | 2 | 2,997,671,682 | −0.02 M | 2,414,984,478 |
| `x3b-m4` | 4 | 2,997,696,836 | +0.00 M | 2,414,984,478 |
| `x3b-m32` | 32 | 2,996,699,875 | −1.00 M | 2,365,752,548 |
| `x3b-m16` | 16 | 3,029,835,676 | +32.14 M | 2,414,984,478 |
| `x3b-m64` | 64 | 3,028,263,789 | +30.57 M | 2,414,984,478 |
| `x3b-m8` | 8 | 3,042,196,882 | +44.50 M | 2,702,048,831 |
| `x5-m4096` | 4096 | 3,106,459,920 | +108.76 M | 2,414,984,478 |
| `x7-m1024`, `x9-m1024` | 1024 | 2,997,707,905 | +0.01 M | 2,414,984,478 |
| `x8-m2048` | 2048 | 3,157,179,417 | +159.48 M | 3,357,776,709 |
| `x6-m512` | 512 | 2,995,397,656 | −2.30 M | 2,414,984,478 |
| `x6-m544` | 512, 32 | 2,994,611,224 | −3.09 M | 2,365,752,548 |
| `x12-m16896` | 16384, 512 | 2,994,772,020 | −2.92 M | 2,414,984,478 |
| `x12-m16928` | 16384, 512, 32 | 2,993,970,984 | −3.73 M | 2,365,752,548 |
| `x14-m541216` | the same, no claims | 2,993,970,910 | −3.73 M | 2,365,752,548 |
| `final1` | #2636's head | 2,993,970,960 | −3.73 M | 2,365,752,548 |
| `x13-m16930` | 16928 and 2 | 2,993,946,514 | −3.75 M | 2,365,752,548 |
| `x13-m16672` | 16384, 256, 32 | 2,997,453,099 | −0.24 M | 2,365,752,548 |
| `x10-m16928` | 16928, the outermost loop alone | 2,994,000,428 | −3.70 M | 2,401,913,026 |
| `x11-m66080` | 65536, 512, 32 | 2,994,777,519 | −2.92 M | 2,365,752,548 |
| `x13-m279328` | 262144, 16928 | 2,997,417,934 | −0.28 M | 2,365,752,548 |

`x5-m8192` (8192) ran 3,161,149,733 (+163.45 M) and Lua's scripts 6,447.3 M; its directory wasn't kept. Every run's speedtest1 gave the verification hash (`1248168 a7fa3957…`), and every Lua build printed clang -O0's output for every script (`counts/*/st-check.txt`, `counts/*/check.txt`). `main`'s Lua outputs were compared after clang -O0's were made, by running its executable again: its first `check.txt` had been written before the reference existed.

**Reading.**
- **The allocator's rule** (`counts/deltas/st-main-to-x3b-m32.txt`, `lua-main-to-x3b-m32.txt`): `luaV_execute` −49.23 M, of which moves −45.63 M and frame objects' `lea`s −3.60 M; speedtest1 −1.00 M, `sqlite3VdbeRecordUnpack` −0.82 M. `jsonLookupStep` +0.10 M and `sqlite3VdbeExec` +0.01 M lose. Lua's other functions differ by the string hash's seed (#2574's record).
- **The placement's test** with the rule (`st-x3b-m32-to-final1.txt`): −2.73 M. Against no hoist (`st-x1-m1-to-final1.txt`), `sqlite3_str_vappendf`, `patternCompare`, `sqlite3GenerateColumnNames`, `sqlite3StrICmp` and `sqlite3Atoi64` now run as without the hoist, `sqlite3_str_vappendf` 0.01 M fewer. These still lose: `jsonTranslateBlobToText` +0.89 M, `speedtest1_run` +0.27 M, `sqlite3FindFunction` +0.12 M, `jsonLookupStep` +0.10 M, `hexFunc` +0.07 M.
- **The test on the outermost loop alone** (`x10`, `lua-final1-to-x10-m16928.txt`) keeps `luaV_execute`'s `disptab` in each handler: +36.16 M. Every iteration of its outermost loop calls, through `luaD_precall`, while the dispatch loop inside it has handlers that call nothing.
- **Outside loops, a definition only where every path takes it** (`st-x6-m544-to-x11-m66080.txt`): `jsonTranslateBlobToText` −0.89 M, `sqlite3FindFunction` −0.12 M, `sqlite3GetToken` +1.22 M.
- **The variants that let recipes take caller-saved registers** lose in `sqlite3VdbeExec` (`counts/deltas/st-main-to-*.txt`, `kinds.sh`):
  - 16: +32.6 M `lea`s;
  - 2048: +92.3 M frame objects' `lea`s;
  - 4096: +77.2 M `lea`s and +26.0 M moves, where its symbol addresses moved between the two sets at its blocks' edges.

## 2. The compile's extra work, by callgrind

valgrind can't run the native compiler, so `scripts/cgcompile.sh` built main and the head at `BUSTER_HOST_ARCH=x86-64`, each in a worktree at its commit. Each then ran the frozen `sqlite3.c`'s `--tier1 -c` with speedtest1's flags under callgrind (`compile-callgrind/totals.txt`, with the compilers' hashes): 15,093.43 M and 15,094.87 M instructions, +1.44 M (+0.01%).

By function (`compile-callgrind/delta-main-head.tsv`, self cost):
- `tier1_allocate_hinted`, the scan with hints, +3.63 M: the new test at each start and reload;
- `ir_lower_typed_target_path` +1.29 M: the placement's loop walks, inlined into it;
- `tier1_cfg_prepare` −1.24 M, `tier1_cfg_finish` −1.05 M and `tier1_emit_cfg_records` −0.74 M: fewer edge moves to resolve and emit.

The rows without symbols are the same code at other addresses.

## 3. Run time and compile time on the 9700X

**Method.** This is #2593's record's (#2574's method), with one change to how the lock was held. Base is main `26f0bb0e`, head #2636's `c68fa771`, every run pinned to CPU 2.

- **`scripts/run2618.sh`** is #2593's `run2593.sh` with its paths renamed. It built:
  - both compilers, each at its commit in a tree of its own (`BUSTER_DEBUG_INFO=0`, native target znver5; `9700x/compilers.sha256`);
  - Lua's 33 objects by each compiler's `--tier1`, linked by cc in six recorded orders (`9700x/orders.txt`), the same for both builds;
  - speedtest1 as one unity unit, by the driver's link;
  - clang -O0's Lua.

  Each step was one hold of the lock. It was then stopped, before its checks: that afternoon each hold waited three to nine minutes behind the other sessions' runs, and its 900 holds would have taken days. It was stopped by PID, its `exclusive.sh` waiter before that waiter's `flock`, so nothing ran outside the lock.
- **`scripts/run2618b.sh`** reused those files (`9700x/executables.sha256`) and took the lock fourteen times:
  - once to build speedtest1's six layouts, each compiler's unity unit as one object linked after a pad of 0, 16, 32, 48, 1,072 or 3,088 bytes (`scripts/build-layouts.sh`, `9700x/layouts/executables.sha256`);
  - once for every check (`scripts/checks.sh`, `9700x/checks.txt`): each Lua executable's five scripts against clang -O0's outputs, and every speedtest1 executable's verification hash. All 74 matched.
  - once per round, twelve rounds, round 0 a warm-up kept apart (`scripts/round.sh`). Each round ran every order's two Lua builds on all five scripts, speedtest1's two builds at the driver's link and at each of the six layouts, and the two compilers' `--tier1 -c` of `sqlite3.c` and `--tier1` of Lua's 33 sources into an executable. The builds' order rotated by round and by order or layout as in `run2593.sh`. Each process was one `perf stat` of task-clock, user cycles and user instructions, its exit status recorded beside it; all 862 exited 0.

  A round's processes take about 9 s, so a hold stays far inside the ten minutes a CI job waits for the lock. Each hold first wrote the lock's owner line, its own, to `9700x/holds.txt`. The compile outputs were the same in every round (`9700x/compile-outputs.sha256`: one object and one executable per compiler).
- **Logs and analysis.** `9700x/run.log` has both scripts' own lines; the lock's waiting messages, which name other sessions, aren't kept. #2574's record's `analyze.py` makes `9700x/analysis.md`, and #2593's `layouts.py` and `compile.py` make `9700x/layouts/analysis.md` and `9700x/compile-analysis.md`.

**Lua** (`9700x/analysis.md`):

| | head / base | 95% interval over the six orders |
| --- | ---: | ---: |
| time | 0.9979 | 0.9902 to 1.0057 |
| user cycles | 0.9975 | 0.9892 to 1.0058 |
| user instructions | 0.9909 | 0.9906 to 0.9912 |

By script, as the median of the orders' medians: `calls` 1.0000 in time (−3.8% instructions), `tables` 0.9913, `strings` 1.0006, `closures` 0.9920, and `arithmetic` 1.0385.

**speedtest1 at six layouts** (`9700x/layouts/analysis.md`):

| Pad, bytes | 0 | 16 | 32 | 48 | 1,072 | 3,088 | mean (95% interval) |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| time, head / base | 0.9995 | 0.9871 | 0.9968 | 1.0056 | 0.9882 | 0.9879 | 0.9942 (0.9862 to 1.0022) |
| user cycles, head / base | 0.9990 | 0.9749 | 0.9974 | 1.0030 | 0.9941 | 0.9879 | 0.9927 (0.9821 to 1.0034) |

User instructions are 0.9987 at every layout (2,947.24 M and 2,943.51 M). At the driver's own link, one layout, speedtest1 ran 1.0007 in time and 1.0024 in user cycles (paired rounds 0.9964 to 1.0097), with the same 0.9987 in instructions.

**Compile time** (`9700x/compile-analysis.md`, eleven rounds after the warm-up):

| Input | Metric | base | head | head / base | paired ratios, median (range) |
| --- | --- | ---: | ---: | ---: | ---: |
| sqlite3.c | time, ms | 400.07 | 400.94 | 1.0022 | 1.0025 (0.9416 to 1.0351) |
| sqlite3.c | cycles, M | 2,120.61 | 2,125.69 | 1.0024 | 1.0018 (0.9697 to 1.0154) |
| sqlite3.c | instructions, M | 4,720.50 | 4,722.14 | 1.0003 | 1.0003 (1.0003 to 1.0003) |
| Lua | time, ms | 155.72 | 155.89 | 1.0011 | 0.9994 (0.9552 to 1.0055) |
| Lua | cycles, M | 755.28 | 756.75 | 1.0019 | 1.0020 (0.9634 to 1.0112) |
| Lua | instructions, M | 1,741.02 | 1,742.13 | 1.0006 | 1.0006 (1.0006 to 1.0006) |

**The arithmetic script.** It ran slower at five of the six orders (+3.2% to +6.2% in time) and faster at order 0 (−2.9%), with 0.83% fewer instructions at each.
- **Its code.** In callgrind's counts (`counts/kinds.tar.zst`, `arithmetic.tsv`), the only change in its `luaV_execute` is 8.27 M fewer moves and 1.24 M fewer frame addresses' `lea`s. In its hottest handler tails, the same values are rotated through one move fewer.
- **Its counters.** `9700x/arithmetic/` has one hold's `perf stat -r 11` of each build at orders 0, 1 and 5 (`arith.sh`, `counters.txt`), measuring user cycles, instructions, mispredicted indirect and all branches, ops from the x86 decoder, and cycles retiring nothing while a load is incomplete. At order 1 the head takes 12.1 M more cycles (182.98 M against 170.84 M). Yet its branch mispredictions differ by 4 K, its decoder's ops by 0.05 M, and its load-incomplete cycles fall by 0.2 M. At order 0 it takes 4.0 M fewer.
- **Reading.** The same build's cycles on this script vary by 4% (base, 170.1 M to 177.0 M) to 6% (head) between link orders, as much as the two builds differ. The code gives no reason for it, and placement does, as speedtest1's layouts' spread shows.

**Reading.**
- **Lua.** Its instructions fall 0.91% at each of six link orders, mostly `luaV_execute`'s edge moves, as callgrind counts them. Its time doesn't move measurably: the mean ratio is 0.9979, an interval that includes no change.
- **speedtest1.** Its instructions fall 0.13% at every layout. Its cycles fall 0.73% on the mean of the six layouts, an interval that includes no change. The driver's own link is one layout, at which they rose 0.24%.
- **Compile time.** `sqlite3.c`'s `--tier1 -c` runs 1.6 M more instructions (0.03%), as callgrind counts them (section 2). Its time and cycles are 1.0022 and 1.0024, inside rounds whose paired ratios range over ±3%: wider than #2593's record's, whose holds each held one process. Lua's 33 compiles run 0.06% more instructions.

## Tests

`scripts/tests.sh` and `scripts/tests2.sh` are the Tier 1 steps of buster's `tools/ci/correctness.tests` that the change touches, as they ran in the cloud container against `final1` and `final4` (#2636's code; `final4` with its tests).

## Limitations

- The counts come from one container's runs of deterministic programs, at that container's target. The 9700X's builds target znver5.
- On the 9700X, each round ran under one hold of the lock, not each process under its own, as #2593's record did. A round's 78 processes then ran back to back, each still measured by its own `perf stat`.
- The 9700X's rounds ran while other sessions and CI took the lock between them.
- The experiment's compilers were built from successive states of `experiment-modes.patch`; only its last state is kept, which has every bit.
