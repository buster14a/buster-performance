# The typed stream's validation (`lower.validate`), measured and made faster, 2026-11-23

[buster#3394](https://github.com/buster14a/buster/issues/3394) is step 4's piece 7 of
[buster#2874](https://github.com/buster14a/buster/issues/2874): `lower.validate` on `-c sqlite3.c` from 1.15 ms to
0.5 ms or less, with every refusal kept and every object byte-identical. It is refuted above 0.8 ms. This record has
the lap split, the ablations, the profiles, the series of builds, the final hold against main, the fault round and the
object comparisons. The change is [buster PR #3410](https://github.com/buster14a/buster/pull/3410).

## Setup

- **The 9700X:** CPU 2, under the lock, one hold a set (`scripts/queue.sh`). Builds are Release, `BUSTER_HOST_ARCH=znver5`,
  built in a cloud container with CI's staged toolchain (LLVM 23.1.4) and copied over stripped (`binaries.sha256`).
- **Input:** the frozen corpus of `tools/ci/fetch-corpus.sh` (archive `ceb39bf9…`). `sqlite3.c` is compiled with
  `--predefines provenance/gnu17-pinned-predefines.txt -march=znver5 -std=gnu17 -nostdinc` and the corpus's three
  `-isystem` directories: 2,602 bodies and 371,237 typed entries.
- **The stage clock:** `--time-stages`, medians of 7 (`scripts/stages.sh`, `scripts/table.sh`). The warm numbers come from
  `benchmark-backend-source --only validate`, which runs `tier0_validate` over every lowered function 21 times and
  reports cycles and instructions an entry (`scripts/bench.sh`). Cycles are TSC ticks × 5.45 / 3.7928.

## Where main's 1.15 ms goes

Main `c7809112`, with the experiment patch's TSC laps (`patches/laps-experiment.patch`, results `exp2`, `exp2b`; the
laps add about 0.05 ms):

| part of the lap | ms | |
| --- | ---: | --- |
| `abi_assign` (the part's signatures' locations) | 0.17 | `calling_convention.c`, #3375's area |
| the parameters' setup | 0.02 | |
| the convention check of every type in a call, and the pushes | 0.07 | a scalar loop over 55 k types |
| `tier0_validate` | 0.99 | |
| — the vector path's 6,687 blocks | 0.59 | about 480 cycles a block |
| — its tables and setup | 0.19 | |
| — the ≤16-entry scalar route (516 functions, 4,597 entries) | 0.09 | about 950 cycles a function |
| — functions with vectors (9, the scalar validator's) | 0.03 | |

Counts (`exp-counts` in the README's history, from the experiment patch): 23,452 arrivals, 22,425 of them bringing depth 0
alone; 12,954 calls, 7,694 of two operands or fewer; 2,055 of 2,078 vector-path functions "plain" (no aggregates'
metadata); every function's calls' arguments in the calls' order.

**Warm is not the explanation.** The blocks take about 345 TSC ticks each in the benchmark too (`e5`, `em`:
`BUSTER_3394_LOG`). The whole validator is 1.15× slower in the compile than warm.

**Ablation of main** (`abl1`, `benchmark-backend-source`, cycles an entry, skipping one part at a time where that keeps
the verdict): everything 13.05; without the per-call operand loops 12.40 and 12.40; without the empty arrivals' loop
12.10; without the tables (`tier0_scan_tables`) 11.40 (7.4 instructions an entry less). Skipping the class store-forward
read changed nothing, though the profile put 22% of the function's samples on it (skid).

**Ablation of the first rewrite** (`abl5`, with refusals ignored so that every function stays on the vector path):
everything 12.17; the block's core alone (loads, the values' bounds, depths, the two producer searches, the operand
rules) 8.54; that without the tables 6.70. So the block's core is about 600 instructions a block; the rest of the block
(locals, calls, arrivals, the carried stack) 3.6 cycles an entry; the tables 1.85.

**The profile** (`pb-*`, `prof-main`; sample addresses in `results/*/ips.txt`) puts the dynamic instructions where the
code is tight: the prefix sums, windows and the two producer searches run about 290 instructions a block at about 0.4
cycles an instruction. IPC over the whole function is 1.9. The block loop is bound by its chain of dependent searches
and checks, not by its instruction count, and one block's ~700 instructions don't leave the reorder buffer room for the
next block's.

## What changed (the PR)

- **Calls of one or two operands** from the top's and the one below's classes and per-call tables (`tier0_scan_calls`:
  operands, result classes, indirect, base), in vector; **calls of more operands** by the consumer search ahead
  (`tier0_scan_next`), in blocks that have one; the scalar per-call loop stays only for a long call that pops values of
  earlier blocks. A call's own class from its table (`tier0_scan_results`).
- **Arrivals that bring depth 0 alone** (96% of them): their targets compressed in order, checked at the end by a gather
  of the stored depths.
- **Two passes over groups of 16 blocks** (`Tier0ScanBlock`): the first does each block's carry-free work, every block of
  the group in turn, so that the processor overlaps them; the second does the carried stack's operands, the rules on
  them, the arrivals and the carried stack.
- **Tables:** the calls' own rules 16 at a time with the blocks' call tables from the same loads
  (`tier0_scan_call_pass`); each call's arguments' distinct registers by `vpconflictq` in place of two reductions; one
  scratch push; no store-forward reads; whole loads for a full block.
- **No small scalar route:** every stream takes the vector path first; the scalar validator only gives a refused
  stream's rule (and takes vector functions, as before).
- **The convention check** in the lap 16 types at a time by gathers (`c_check_program_lower.c`).

## The series (9700X, same input; `lower.validate` medians of 7; benchmark cycles and instructions an entry)

| build | `lower.validate` ms | main in the same hold | bench cycles | bench instructions |
| --- | ---: | ---: | ---: | ---: |
| v1 (calls by consumer search everywhere, gathered empty arrivals) | 1.202 | 1.150 | 13.25 | 33.34 |
| v2 (short calls from top/second) | 1.196 | 1.152 | 13.40 | 32.00 |
| v4 (tables by an arguments pass with gathers) | 1.201 | 1.157 | 13.22 | 31.14 |
| v5 (tables a call at a time with `vpconflictq`, long calls in their blocks) | 1.155 | 1.155 | 12.58 | 31.60 |
| v6 (guards on parts a block lacks) | 1.177 | — | 12.72 | 30.80 |
| v7 (two passes over groups of 16 blocks) | 1.139 | 1.173 | 11.85 | 32.15 |
| v8 (no small scalar route) | 1.087 | 1.156 | 11.46 | 31.81 |
| v9 (the convention check by gathers) | 1.069 | 1.153 | | |

Main's benchmark is 12.7 to 12.8 cycles and 32.96 instructions an entry in every hold.

## The gate

| | main `061effd6` (binary `362f8bc9…`) | this PR (binary `47b9ad51…`) | |
| --- | ---: | ---: | ---: |
| `lower.validate` | 1.159 ms | 1.078 ms | −7.0% |
| runs | 1.172 1.168 1.167 1.158 1.153 1.149 1.159 | 1.088 1.091 1.076 1.076 1.079 1.078 1.074 | |
| `benchmark-backend-source --only validate`, cycles an entry | 12.67 | 11.48 | −9.4% |
| the same, instructions an entry | 32.96 | 31.81 | −3.5% |
| the object's SHA-256 | `758b3305…` | `758b3305…` | identical |

The gate is 0.5 ms or less: **not met**. It is refuted above 0.8 ms, and 1.078 ms is above it.

## Exactness

- `test-tier0` passes (18,768,331 checks), with a new check of streams across the two passes' groups (values carried,
  calls and `?:` across entry 1,024). The validation section takes 6,525 streams by the vector path and 7,481 by the
  scalar validator.
- The correctness inventory's blocks for Tier 0, the lowering, the checker (all eight parts), lanes, the calling
  convention, the driver's commands and the emission passed (`inventory.log`, on the final tree; `inventory-before-rebase.log` before the rebase), and the call-graph check (0 cycles).
- **Objects:** `scripts/objects.sh` compiles `sqlite3.c`, Lua 5.4.8's 34 files, musl's 1,365 units, the compiler's
  `main.c`, c-testsuite's subset (220) and `tests/**/*.c` (1,567; 993 of them refused alike, mostly the checker's
  diagnostic fixtures) with main and with the head. Every object's SHA-256, and every refusal's exit status and stderr,
  is identical (`objects-main.txt`, `objects-head.txt`).
- **The fault round** (`scripts/mutants.py`, `scripts/mutate.py`, `mutants.log`): 18 mutants of the new rules' terms (`mutants.py`): call bounds, alignment and memory results, the x87 bytes, the arguments' conflicts and taken registers, short calls' top and second, long calls' fed values and callees, the zero arrivals' gather and compress, the carried update, the lowest place against the base, the call results' class, the previous class, the calls' qwords and the group's reach. **All 18 killed**. Two survived the first round, `argument-taken` and `lowest-base`; the tests aimed at them (a 64-argument call's ninth argument in a register the first takes; an operand below the stack's bottom over the carried stack's old places) kill them.

## What would reach the gate

Main's 1.15 ms is about 0.17 ms of `abi_assign` (#3375's area, `calling_convention.c`, not touched here), 0.09 ms of the setup and the convention check, and 0.99 ms of `tier0_validate`. Of that, 0.59 ms is the blocks and 0.19 ms the tables and setup. This PR's two passes and table work bring `tier0_validate` to about 0.9 ms. The rest would need:

- **`abi_assign`'s per-call loops in vector** (#3375): up to about 0.15 ms.
- **A cheaper producer formulation:** the block's core (loads, bounds, depths, two doubling searches, the operand rules) is about 600 instructions a block on its own (8.5 of the 11.5 cycles an entry). The doubling searches are a chain of dependent permutes; interleaving two blocks' searches by hand, or a stack-depth formulation that finds producers by one sort or compress a block, would be needed.
- **Coldness:** the validator is 1.15× slower inside the compile than warm, about 0.13 ms, from the lap running once a part between other stages.

Even with all three, the projection is about 0.55 to 0.7 ms. 0.5 ms looks out of reach while the validation stays a separate pass. Folding the checks into Tier 0's own analysis, which reads the same columns, is the other way #3394 names. It touches `tier0_compile_entries` and `tier0_generate` and is left to their owner.

## Files

- `scripts/`: the 9700X scripts (`queue.sh`, `stages.sh`, `table.sh`, `bench.sh`, `benchlog.sh`, `ablate.sh`,
  `smallknob.sh`, `profile.sh`, `profile-post.sh`, `profbench.sh`, `profbench-post.sh`), the object comparison
  (`objects.sh`), the fault round (`mutants.py`, `mutate.py`) and the laps' builder (`make-exp.sh`).
- `patches/`: the laps' experiment patch on main, the ablation knobs on v5, and the PR's diff.
- `results.tar.zst`: every result directory (stage clocks, benchmark lines, the laps' logs, profiles' sample addresses).
