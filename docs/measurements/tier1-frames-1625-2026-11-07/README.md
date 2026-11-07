# Tier 1 frames: shared call-save rows and shrink-wrapping (buster#1625)

The 9700X's record for buster#1625, which split #1450's item 8 into two questions:
- Could Tier 1's call-save rows share slots, coloured as #1071 colours objects?
- Would shrink-wrapping callee-saved registers (Chow 1988) pay?

The issue asked for each to be measured on `sqlite3.c`/speedtest1 and Lua as not worth it, or implemented and measured. Both measure as not worth implementing now.

- **Host:** benchpress (AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1).
  - Every build, compile, run and profile is one hold of `~/buster-fast-bench/exclusive.sh`, pinned to CPU 2.
- **Compiler:** buster main `cf38957a`, built `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0`.
- **Working directory there:** `~/buster-fast-bench/1623-claude`.
- **Inputs** (`out/inputs.txt`, the hashes the 9700X job checks):
  - SQLite 3.53.2's `sqlite3.c` from the frozen corpus, and its `test/speedtest1.c`;
  - Lua 5.4.8's release;
  - the five scripts of `tier1-reciprocal-141-2026-11-01`.

## The programs

`scripts/1625-profile.sh` builds them with `measure-tier1-programs --runs 1 --keep` (`out/programs.log`): speedtest1 as one translation unit, and Lua's 33 sources, each by Tier 0, `--tier1 -fno-asynchronous-unwind-tables`, clang -O0 and clang -O2. Its one run, for scale:

| Program | `--tier1` | clang -O2 | `--tier1` / clang -O2 |
| --- | ---: | ---: | ---: |
| speedtest1, ms | 1898.5 | 1850.6 | 1.03 |
| speedtest1, instructions, M | 3561.5 | 2009.8 | 1.77 |
| Lua's five scripts, ms | 243.0 | 164.9 | 1.47 |
| Lua's five scripts, instructions, M | 6936.2 | 4281.5 | 1.62 |

## Shared call-save rows

### How the rows work today

A function that calls gets an 8-byte frame row for each caller-saved general register that some call (or fixed-register sequence) saves. Each row lives over the whole function: `Tier1EmitPrepared.call_save_mask`, the CFG consumer's `tier1_emit_cfg_saves`.

### What was measured

`scripts/patch_1625.py` is a measurement-only patch, never committed. With `BUSTER_MEASURE_1625` set, it prints one line per function Tier 1 compiles (`out/static-speedtest1.txt`, `out/static-lua.txt`):
- the frame (`maximum_stack_bytes`);
- its spill slots;
- its general call-save rows;
- their bound if shared among themselves: the most of those registers that any one call position saves, by the covering rule `tier1_emit_fragment_saved` uses.

The patch computes the bound in the CFG consumer only. For a straight-line function, `scripts/summarize_rows.py` takes the bound as 1, the least any function with rows needs, so every saving below remains an upper bound.

### Results (`out/rows.txt`)

| Program | Functions | Frames, bytes | Call-save rows, bytes | Saving if shared among themselves, at most | And with the spill slots, at most |
| --- | ---: | ---: | ---: | ---: | ---: |
| speedtest1 | 2,709 | 146,874 | 34,096 (23.2%) | 2,800 bytes (1.9%), in 303 functions | 8,512 bytes (5.8%) |
| Lua | 1,088 | 66,288 | 13,752 (20.7%) | 1,336 bytes (2.0%), in 135 functions | 1,520 bytes (2.3%) |

The rows take about a fifth of the frames. But in most functions with rows, some call saves every one of them at once, so colouring the rows can't shrink them. In the remaining functions, the bound leaves at most 2% of the frames' bytes to save among the rows, and 6% with the spill slots, about 3 bytes per function.

### Decision

Not worth it. #1450 measured Tier 1's frames at 0.89× clang -O2's on these programs, and the most this could remove is a few bytes per frame.

## Shrink-wrapping

### Why only some saves could move

Tier 1 gives callee-saved registers only to values live across a call, and its prologue pushes each one it uses. A register that is used in the function's entry run must be saved there, whatever path is taken. The entry run is the instructions after the pushes, up to and including the first branch, which every path executes.

Only a register first used after a branch could be saved later, on the paths that use it. So the saves and restores shrink-wrapping could remove are, at most, those registers' pushes and pops on paths that never use them.

### How it was measured

`scripts/analyze_wrap.py` reads each executable's code with objdump. It finds every function's pushed callee-saved registers, and which of them are first used past the entry run. It then counts a profile's samples on those pushes and pops.

The profiles are IBS op samples in user mode, pinned to CPU 2, of the `--tier1` and clang -O2 builds of speedtest1 and of each Lua script:
- `scripts/1625-profile.sh` samples by cycles (one op tagged every 20,011 cycles, `out/wrap-cycles.txt`);
- `scripts/1625-ops.sh` samples by ops (one op in 20,011 dispatched, `out/wrap-ops.txt`), a uniform sample of the executed ops.

The profiles themselves (perf data) stay on the host; their analyses are in `out/`.

### Results

Shares of each program's samples in its own code:

Op-count profiles (`out/wrap-ops.txt`). Each sample is one op in 20,011, so the counts are proportional to the ops executed:

| Program, build | Samples in its code | Callee-saved pushes and pops | Of registers first used past the entry run (movable) |
| --- | ---: | ---: | ---: |
| speedtest1, `--tier1` | 22,208 | 813 (3.66%) | 283 (1.27%) |
| speedtest1, clang -O2 | 13,942 | 1,046 (7.50%) | 587 (4.21%) |
| `calls.lua`, `--tier1` | 1,888 | 55 (2.91%) | 52 (2.75%) |
| `tables.lua`, `--tier1` | 3,029 | 92 (3.04%) | 40 (1.32%) |
| `strings.lua`, `--tier1` | 2,695 | 149 (5.53%) | 98 (3.64%) |
| `arithmetic.lua`, `--tier1` | 3,533 | 2 (0.06%) | 0 |
| `closures.lua`, `--tier1` | 4,137 | 181 (4.38%) | 74 (1.79%) |

The cycle-sampled profiles (`out/wrap-cycles.txt`) agree for Tier 1: speedtest1's are 3.49% and 1.31%, and the scripts' 0.12% to 4.85% and 0.03% to 3.32%. They also cover clang -O2's Lua builds. On four of the five scripts, clang -O2 spends more samples on its saves than Tier 1 does (on `closures.lua`, 292 against 205; on `strings.lua`, 271 against 124).

- **The ceiling.** The movable column is shrink-wrapping's ceiling: it assumes no path through those functions ever uses the registers. The ceiling is 1.3% of speedtest1's ops and 0% to 3.6% of a Lua script's. The largest are `luaD_precall` (all five of its registers move), Lua's `match`, and speedtest1's JSON translators and B-tree seeks.
- **Each op is cheap.** A push or a pop is a single op: a store or a load through the stack engine.
- **clang -O2 does no better.** clang -O2 shrink-wraps, yet its speedtest1 executes more callee-saved pushes and pops than Tier 1's: 1,046 sampled against 813. The cycle samples show the same on four of the five scripts.

### Decision

Not worth it now. The saving is bounded by 1.3% of speedtest1's ops and 3.6% of one Lua script's, and by less of their time, since each of these ops is a single store or load. That bound also assumes no path ever uses the registers. Tier 1's distance from clang -O2 (1.77× the instructions on speedtest1) lies elsewhere.

Implementing it would also be a large change. Saves would have to be placed per path, through Tier 0's frame protocol (`unwind_tier0_frame_tails`), the unwind tables and the code certificate.

If it is reconsidered, `luaD_precall`, whose Lua-function path calls nothing, is the place to start.

## What didn't go as planned

- **Program paths.** The first profiling pass looked for the programs in `programs/`. `measure-tier1-programs` builds into a subdirectory of `--directory`, so the pass found no executables and recorded nothing. The scripts now take the subdirectory.
- **The patch applied twice.** The static measurement was chained after profiling, and an earlier copy of it had already run. So its first build applied `patch_1625.py` twice and failed (`out/static.log`'s first lines, and `speedtest1 exit 127`). `scripts/1625-static.sh` now resets the worktree before patching. Its second run built the patched compiler once and compiled both programs (`exit 0`). Its outputs are the ones recorded.
- **Sampling modes.** The cycle-sampled profiles tag the op dispatched when the count expires, which over-weights the first ops after a call: the pushes. The op-count profiles are the unbiased share, and the two agree within a few tenths of a percent on speedtest1.
- **Op profiles of clang's Lua builds were stopped.** The lock was heavily contended (about five minutes per run), so `1625-ops.sh` was stopped after the Tier 1 builds and clang -O2's speedtest1. clang's Lua builds have only the cycle-sampled profiles. `out/ops-errors.txt` holds the runs' lock waits.
