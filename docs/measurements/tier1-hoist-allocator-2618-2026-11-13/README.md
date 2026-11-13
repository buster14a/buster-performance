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

(Filled in when `scripts/run2618.sh` finishes.)

## Tests

`scripts/tests.sh` and `scripts/tests2.sh` are the Tier 1 steps of buster's `tools/ci/correctness.tests` that the change touches, as they ran in the cloud container against `final1` and `final4` (#2636's code; `final4` with its tests).

## Limitations

- The counts come from one container's runs of deterministic programs, at that container's target. The 9700X's builds target znver5.
- The experiment's compilers were built from successive states of `experiment-modes.patch`; only its last state is kept, which has every bit.
