# Phase D, #3451: the reach of the x86 tables', disassembler's and branch sizing's scalar routes

A census, not a timing: [`census.patch`](census.patch) counts each route with relaxed atomic counters printed at exit
when `BUSTER_DCENSUS=FILE` is set. Built `BUSTER_BAKE=0 ./build.sh --config Release` in a cloud container (baking
rejects counters the initializers might touch; a `-fsyntax-only` of an empty file counts nothing, so the initializers
reach none of these routes).

- `main/`: main `d6daf644d` with the patch.
- `head-3499/`: #3499's head `7c23ed608` (the x86 semantics twins deleted) with the patch. On main the Tier 1
  verifiers and the `-g` checks still call the scalar effects twins, so the rare-record route is counted here.

Inputs, all `--lanes 1`, from one directory:
- buster's `main.c` (`-march=znver5 -Isrc -fwrapv -funsigned-char -fno-strict-aliasing`), at `d6daf644d`;
- Lua 5.4.8 (`github.com/lua/lua` tag `v5.4.8`), `l*.c`;
- c-testsuite `5c7275656d751de0e68b2d340a95b5681858ed07`, `tests/single-exec/*.c` (220 files);

each at `-c` (t0), `-c -g` (t0g), `-c --tier1` (t1), `-c --tier1 -g` (t1g) and `-c --tier1 --verify` (t1v). The
disassembler's routes are reached only by `disassemble` and the measures: `.text` of `main.c`'s `-c` and `--tier1`
objects and of the compiler executable itself, by `disassemble` and `disassemble --assembly`.

## Counts

| Route | Input | Reached | Out of |
| --- | --- | ---: | ---: |
| `x86_decode_one` (instructions) | compiler `.text` | 1,986,769 | 6,915,955 decoded (29%) |
| | `main.c` `-c` `.text` | 163,152 | 573,554 (28%) |
| | `main.c` `--tier1` `.text` | 67,088 | 356,040 (19%) |
| of which windows of fewer than 2 | compiler / `-c` / `--tier1` | 921,048 / 103,093 / 34,929 | |
| `x86_instruction_resolve` for rare records | `main.c` t1g / t1v | 9,838 / 10,697 | 2,076,005 / 1,968,953 records (0.47%, 0.54%) |
| | c-testsuite t1g / t1v | 332 / 551 | 35,722 / 50,371 (0.9%, 1.1%) |
| | Lua t1g / t1v | 0 / 0 | 373,885 / 235,117 |
| | every input at t0, t0g, t1 | 0 | (main.c: 18 records) |
| `x86_target_forms`' extended rows | every compile | 221 rows a call | 1 call (t0), 1 a unit at `--tier1` (2 for main.c, 32 for Lua, 221 for c-testsuite) |
| `branch_sizing_worklist` | Lua t1g | 1 run | 1,080 runs |
| | everything else | 0 | 380 to 1,540 runs |
| `x86_disassembly_format_scalar` | `disassemble` (both forms) | 0 | 6,915,955 formatted by plan |

The effects are called about once for every two records at t1g (main.c 1,019,811 calls for 2,076,005 records), so the
per-record callers in the `-g` checks (#3499's write column took the hottest ones) still dominate the call count.

## Order

1. `x86_decode_one`: about a quarter of every disassembled stream, half of it windows of one instruction.
2. The rare-record resolve: under 1% of the records, in `-g` and `--verify` only, never in Tier 0.
3. The target forms' extended rows: 221 rows on every call, a fixed cost a compile (a unit at `--tier1`).
4. `branch_sizing_worklist`: one run in the inputs (Lua at `--tier1 -g`); it is reached, so it stays covered by a fixture.
5. The bounded formatter: no reach from `disassemble`; tests and measuring calls (`output == 0`, small capacities) only.
