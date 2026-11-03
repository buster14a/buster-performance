# Tier 1's instruction gap to clang -O2 by cause, and the passes in `--tier1` (2026-11-03)

This is the evidence for [buster#1189](https://github.com/buster14a/buster/issues/1189)'s steps 1 to 3, and for [buster#1221](https://github.com/buster14a/buster/pull/1221). By Claude, at David's request ([the session](https://claude.ai/code/session_01Egbxndhj9W6e8zpPraPrYn)). The issue's comments [1](https://github.com/buster14a/buster/issues/1189#issuecomment-6601742145) and [2](https://github.com/buster14a/buster/issues/1189#issuecomment-6602000597) have the tables. This record holds what made them.

## Host and instrument

Most of these measurements ran in a cloud container, **not the 9700X**, all but `9700x/` (below): an Intel Xeon (model 173, AVX-512) under KVM, 4 CPUs, Ubuntu with clang 23.1.5, valgrind 3.22.0 and tcc 0.9.27. The VM exposes no hardware counters, so **nothing here is a cycle or time measurement**. The compile times in `passes/compile-times.txt` are one pinned CPU of this VM, and are ratios only.

Instruction counts come from callgrind (`valgrind --tool=callgrind --dump-instr=yes`). It counts every user-space instruction exactly, and gives each instruction address its own count. The counts don't depend on the host. Against the 9700X record [`tier1-reciprocal-141-2026-11-01`](../tier1-reciprocal-141-2026-11-01):
- c-testsuite 00040's instructions past startup are the record's `perf stat` figures exactly (`cts-00040/`);
- speedtest1's are within 1%.

## Revisions and inputs

| Role | Commit | What |
| --- | --- | --- |
| main | `96b6cbcd` | the breakdown's head; it includes #1117 |
| head | `3e411919`, `64423fa8` | buster#1221: the depth slot per (depth, IR type), and the guides, rebased on `f5a0932b` |

The inputs are those of the `cc3387f` record:
- the frozen `sqlite3.c` (SHA-256 `0a409f16…`), from `ci-corpora-preprocessor-391e729af658`, by `tools/ci/fetch-corpus.sh`;
- SQLite 3.53.2's `test/speedtest1.c` (`b5eaf4bb…`) and #136's `speedtest1-unity.c` (`eadb487f…`), with #136's flags and options;
- Lua 5.4.8 (`lua-5.4.8.tar.gz`, `4f18ddae…`) and the record's five scripts;
- c-testsuite `5c72756`.

Every build gives speedtest1's verification hash `1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739` (`main-96b6cbcd/verify.txt`). Every Lua script prints clang -O0's output (`*/check.txt`).

## Method

1. **Builds.** Tier 0 and `--tier1 -fno-asynchronous-unwind-tables` (`BUSTER_DEBUG_INFO=0`), clang -O0 and -O2, and tcc, as the record's `corpora.sh` builds them. `scripts/progs.sh` makes the `--tier1` builds, with `--tier1-report`.
2. **Counts.** One run of each program under callgrind: `scripts/run.sh` and `scripts/measure.sh`. `*/instructions.txt` holds each whole process's count.
3. **Origins.** `tools/kinds-experiment.diff` is main with each Tier 1 record tagged by where it came from. It isn't in any commit. The tags:
   - `S`/`L`: spill and reload at a fragment boundary;
   - `T`/`U`: spill and reload on a CFG edge;
   - `C`/`R`: call save and restore;
   - `e`: edge move;
   - `a`: a call's sequence (argument, callee and result moves, the call, the outgoing area's adjustment);
   - `p`: the entry's parameters;
   - `f`: prologue and epilogue;
   - `r`: recomputed value;
   - `j`: the CFG consumer's branches and jumps;
   - `n`: the node's selected code.

   With `BUSTER_TIER1_KINDS=FILE`, each function Tier 1 compiles gets a line of tags in FILE (`main-96b6cbcd/*.kinds`). That is 2,707 lines for speedtest1 and 1,088 for Lua, each build report's `compiled`. The tagged executables are main's byte for byte. Every line's tags match its function's instructions in `objdump`:
   - **exactly,** but for padding after the last record, for all but speedtest1's `main`;
   - **`main`, as a prefix:** its 5,476 tags are its first 5,476 instructions, which end in its `ret` (`#check kinds main prefix 5476 of 5568 instructions` in `st-t1.tsv`). The 92 after them are the unit's helpers without a symbol, which `objdump` counts as `main`'s. `gap` makes them a function of their own, `(unnamed code after main)`. They are `c_check_program_helpers.c`'s atomic loads and stores (`mov`, then `mfence` for a store, then `ret`), called 1,369,236 times; `main` itself runs 6,808 instructions.

   An instruction without a tag is **unattributed**: its own origin in the tables, never the node's. It is 24.0 M of speedtest1's 3,743.8 M of program code (0.6%), and 14.2 M of Lua's 7,228.2 M (0.2%). The tables list its functions:
   - **the PLT's stubs:** 7.3 M on speedtest1, and all of Lua's 14.2 M;
   - **`sqlite3Multiply128` and `sqlite3Multiply160`, 13.9 M:** the two functions Tier 1 refuses, each at selection on a 128-bit constant, so Tier 0 compiles them. `main-96b6cbcd/refusals-st.txt` is `--tier1-refusals` by the same compiler. Lua's build has no refusals;
   - **the unit's helpers after `main`:** 2.8 M;
   - **the C runtime's start-up code:** under 300 instructions. That is `_start`, which `objdump` names by an offset from the next symbol, plus `.init` and `.fini`.
4. **Joining.** `tools/gap.c` (`cc -O2 -o gap gap.c`):
   - `gap count DISASSEMBLY CALLGRIND OBJECT BASE [KINDS]` joins callgrind's per-address counts, `objdump -d --no-show-raw-insn` and the tags into a TSV of function, origin, instruction type and count. Only the program's own code counts; the C library and the loader are other objects. Buster's executables, whose symbols valgrind doesn't read, are object `???` at base `0x108000`; clang's and tcc's are their own path at base 0. `#check unmatched` gives the counts that landed on no instruction: at most 1.0 M of a run.
   - **Stack operands.** An operand based on `rsp` is the stack's. One based on `rbp` is the stack's only in a function that makes `rbp` its frame pointer (`mov %rsp,%rbp`); optimized code without a frame pointer uses `rbp` as any other register. Here no function of either side's makes `rbp` a frame pointer: Tier 1's code never addresses through `rbp`, and clang -O2's does in 205 of speedtest1's functions and 28 of Lua's, as a data pointer (33 instructions of Lua's `luaV_execute` among them).
   - `gap table T1.tsv... -- CLANG.tsv...` sums the TSVs and prints the tables (`main-96b6cbcd/st-table.md`, `lua-table.md`). A type belongs to one cause, so each program's causes partition its gap. The instructions without a tag are the `unattributed` origin. Their own table gives the PLT's stubs together, then each other function, as "no tag line" or "its tags didn't fit".
5. **Passes.** `tools/passes-experiment.diff` is the head with two passes added to `check_tier1_compile`:
   - `BUSTER_TIER1_SROA=1`: `ir_optimize_sroa` before promotion;
   - `BUSTER_TIER1_LICM=1`: `ir_optimize_licm` between promotion and `ir_optimize_verified`;
   - `BUSTER_LICM_MAX_BLOCKS=N`: skips loops of more than N blocks;
   - `BUSTER_TIER1_PASS_LOG=1`: prints each function's pass statistics.

   A refusal leaves the function as it was. `passes/*/` holds each variant's counts, checks and `--tier1-report`.

## Results

**Whole-process instructions:**

| Program | Tier 0 | `--tier1`, main | `--tier1`, head | clang -O0 | clang -O2 | tcc |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| speedtest1 | 5,744.4 M | 3,915.3 M | 3,869.8 M | 3,908.1 M | 2,028.9 M | 5,006.7 M |
| Lua, five scripts | 10,723.8 M | 7,709.5 M | 7,608.4 M | 8,253.1 M | 4,208.1 M | 9,881.3 M |
| c-testsuite 00040, past startup | 886.5 M | 704.6 M | 704.6 M | 873.4 M | 373.9 M | 1,048.8 M |

**Program code, `--tier1` against clang -O2, by cause** (`main-96b6cbcd/st-table.md` and `lua-table.md`, which also have each type, each origin and the hottest functions):

| Cause | speedtest1, gap 1,856.3 M | Lua, gap 3,460.2 M |
| --- | ---: | ---: |
| stack loads and stores | 433.6 M (23.4%) | 946.9 M (27.4%) |
| register moves | 348.3 M (18.8%) | 447.7 M (12.9%) |
| address arithmetic | 274.7 M (14.8%) | 630.8 M (18.2%) |
| compares and branches | 274.7 M (14.8%) | 616.9 M (17.8%) |
| other loads and stores | 207.7 M (11.2%) | 269.3 M (7.8%) |
| zero and sign extensions | 167.3 M (9.0%) | 432.6 M (12.5%) |
| calls, returns and frames | 137.5 M (7.4%) | 52.4 M (1.5%) |
| constants | 59.7 M (3.2%) | −24.3 M (−0.7%) |
| arithmetic and the rest | −47.2 M (−2.5%) | 87.9 M (2.5%) |

**Corrections.** The record's first versions (`caa66550`, `02f5d050`) had three errors and an unsupported claim, which buster-performance#236's and buster#1230's reviews found:
- **`rbp`'s operands were all the stack's.** That put clang -O2's loads and stores through `rbp` among the stack's: 16.7 M of speedtest1's and 54.1 M of Lua's. The stack's share of the gap was 22.5% and 25.8%, other loads' and stores' 12.1% and 9.3%. No other cause changes, and none crosses 5%.
- **The untagged instructions were the node's.** Only the origin columns change.
- **The calls counted Tier 1's PLT stubs as the program's.** Buster's executables call the C library through PLT stubs, clang's without them, so 7.33 M of speedtest1's calls and 14.21 M of Lua's were the C library's calls on Tier 1's side alone. The tables now give them apart. Without them, `--tier1` makes 70.29 M calls into speedtest1's own code against clang's 25.62 M, and 91.79 M into Lua's against 54.20 M (were 77.62 M and 106.00 M). Of speedtest1's, 1.37 M go to the unit's atomic helpers and 68.92 M to its functions. The calls clang doesn't make are 44.67 M and 37.60 M (were 52.00 M and 51.81 M). Their callees' instructions in Tier 1 are estimated at 1,121.4 M and 960.3 M: each callee's instructions times the share of its calls that clang doesn't make, from its average per call.

**Calls clang doesn't make, and inlining.** A callee's calls by Tier 1 less its calls by clang are a count difference. Clang may have inlined them, or removed them otherwise. The first versions called that difference inlining without evidence. The evidence now comes from clang's own inlining remarks (`-Rpass=inline`):
- **The rebuild.** `scripts/inlining.sh` builds clang -O2's speedtest1 and Lua with those remarks. Both executables are the measured ones byte for byte, by `inputs.sha256`, so the remarks describe the code that ran.
- **The remarks.** `main-96b6cbcd/inlined-st.tsv` and `inlined-lua.tsv` keep each remark's callee and caller: 8,239 and 1,320 of them.
- **What they cover.** On speedtest1, 43.29 M of the 44.67 M calls go to callees clang inlined at one call site or more. 1.37 M go to the unit's atomic helpers, which are no function for clang to inline, and 0.01 M to other callees. On Lua, all 37.60 M go to callees clang inlined.
- **The tables.** The callee tables give each callee's remarks. Most of their callees have no symbol left in clang's executables: all their calls were inlined or removed.
- **What this doesn't show.** The match is by callee, not by call site: it doesn't show which call sites' dynamic calls were the inlined ones.

All twelve TSVs and both tables are regenerated from the original inputs (`scripts/gap.sh`, below); Tier 1's TSVs differ only by `main`'s helpers.

**Passes, at the head before its rebase, `--tier1`'s whole-process instructions:**

| Variant | speedtest1 | Lua |
| --- | ---: | ---: |
| none | 3,869.8 M | 7,610.3 M |
| LICM | 5,067.0 M (+30.9%) | 12,130.9 M (+59.4%) |
| LICM, loops of at most 8 blocks | 4,253.9 M (+9.9%) | 7,928.9 M (+4.2%) |
| LICM, loops of at most 4 blocks | 3,994.6 M (+3.2%) | 7,771.5 M (+2.1%) |
| LICM, loops of at most 2 blocks | 3,930.2 M (+1.6%) | 7,744.8 M (+1.8%) |
| SROA | 3,868.5 M (−0.03%) | 7,613.9 M (+0.05%) |

## On the 9700X: #1189's step 4

[buster#1230](https://github.com/buster14a/buster/pull/1230)'s `measure-tier1-programs` ran in its own Benchpress job, the 9700X job of
[run 41637938160](https://github.com/buster14a/buster/actions/runs/41637938160) (job 125928093203), at its head `eeeafb6d`. That head
is main `730eea0a` (this record's per-type depth slots, buster#1221, included) with the command added.

Setup:
- the job's `znver5` Release executable;
- clang 23.1.4 (`7a941dfb`) and the host's tcc, pinned by hash;
- the frozen `sqlite3.c`, speedtest1.c and Lua 5.4.8's release, by their hashes;
- the cc3387f record's five scripts, from buster-performance `818cfbbc`;
- the job's one CPU, under the shared lock the runner's hooks hold.

Before any timing, every build gave speedtest1's hash `1248168 a7fa3957…`, and every script printed clang -O0's output. Then came one warm-up and 11 rounds of every build of every program in a rotating order. All 330 measured runs exited 0, with their counters counted.

- `9700x/measure-tier1-programs.log`: the step's output, timestamps included.
- `9700x/runs.tsv`: the runs, one line each, warm-ups included: phase, round, position, program, build, wall time in ns, user cycles, instructions, status and whether it was counted.

The medians, Lua's being the sum of its five scripts' medians:

| Program | Tier 0 | `--tier1` | clang -O0 | clang -O2 | tcc | `--tier1` / clang -O2 | `--tier1` / clang -O0 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| speedtest1, ms | 258.2 | 207.0 | 271.0 | 129.3 | 269.7 | 1.60 | 0.76 |
| speedtest1, user cycles, M | 1,336.1 | 1,051.1 | 1,396.5 | 625.7 | 1,397.5 | 1.68 | 0.75 |
| speedtest1, instructions, M | 5,694.0 | 3,819.4 | 3,855.8 | 1,979.0 | 4,832.2 | 1.93 | 0.99 |
| Lua's five scripts, ms | 335.2 | 260.8 | 358.7 | 167.4 | 393.6 | 1.56 | 0.73 |
| Lua's five scripts, user cycles, M | 1,838.9 | 1,424.3 | 1,957.0 | 909.6 | 2,157.0 | 1.57 | 0.73 |
| Lua's five scripts, instructions, M | 10,795.0 | 7,652.1 | 8,288.1 | 4,250.4 | 9,394.0 | 1.80 | 0.92 |

Against the cc3387f record's corpora table (clang 23.1.1 there), `--tier1` gained:
- speedtest1: 223.5 to 207.0 ms, 1,138 M to 1,051 M cycles and 4,413 M to 3,819 M instructions. Its ratio to -O2 fell from 1.70 to 1.60 in time and from 1.80 to 1.68 in cycles.
- Lua: 286.1 to 260.8 ms, 1,559 M to 1,424 M cycles and 8,749 M to 7,652 M instructions. Its ratio fell from 1.71 to 1.56 in time and from 1.74 to 1.57 in cycles.

What changed between the two: buster#1117 put `sqlite3VdbeExec` and `luaV_execute` into Tier 1, then came buster#1221's depth slots, and the clang release moved from 23.1.1 to 23.1.4.

clang -O0's numbers also differ from that record's: speedtest1's -O0 build there ran 291.0 ms and 3,922 M instructions, against 271.0 ms and 3,856 M here. Ratios to -O0 are not comparable across the two records.

The method's two differences from that record are in buster's `docs/commands/tier1.md`:
- clang's objects link with clang rather than `cc`;
- each run's counters are its own, from `perf_event_open`, rather than `perf stat` of one more run per build.

Callgrind's counts above (`*/instructions.txt`) are a little higher than the 9700X's counters on the same code: speedtest1's `--tier1` gives 3,869.8 M under callgrind and 3,819.4 M here. They count whole processes in another environment (the loader and the C library's ifunc choices); the cause breakdown uses callgrind's counts alone.

## Reproducing

- **The tables, from the original inputs.** `main-96b6cbcd/callgrind.tar.zst` holds the twelve callgrind runs that made `main-96b6cbcd/`'s TSVs: speedtest1 and the five Lua scripts, by `--tier1` and clang -O2. `main-96b6cbcd/inputs.sha256` gives the SHA-256 of the four executables they ran, and of their GNU objdump 2.42 disassemblies. `scripts/gap.sh BUILDS OUT`, with those executables in BUILDS, regenerates every TSV and table and compares each with the record's; here all fourteen are the record's. The executables aren't retained, since they would carry Lua's and SQLite's code; a rebuild by step 1 is checked against their hashes.
- **Clang's inlining remarks.** `scripts/inlining.sh SQLITE SPEEDTEST LUA OUT` rebuilds clang -O2's executables with `-Rpass=inline`, checks their hashes and compares the remarks' pairs with `main-96b6cbcd/inlined-*.tsv`; here both are the record's.
- **The builds and runs.** `scripts/progs.sh`, `run.sh` and `measure.sh` take a scratch directory as `S`, which holds them and:
  - `corpus/sqlite/sqlite3.c`;
  - `inputs/st/` with `speedtest1.c` and `speedtest1-unity.c`;
  - `inputs/lua/` with `lua-5.4.8/` and the five scripts;
  - `ref/SCRIPT-clang0.out`, clang -O0's output of each script.
