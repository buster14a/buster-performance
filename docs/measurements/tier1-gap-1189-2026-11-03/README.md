# Tier 1's instruction gap to clang -O2 by cause, and the passes in `--tier1` (2026-11-03)

This is the evidence for [buster#1189](https://github.com/buster14a/buster/issues/1189)'s steps 1 to 3, and for [buster#1221](https://github.com/buster14a/buster/pull/1221). By Claude, at David's request ([the session](https://claude.ai/code/session_01Egbxndhj9W6e8zpPraPrYn)). The issue's comments [1](https://github.com/buster14a/buster/issues/1189#issuecomment-6601742145) and [2](https://github.com/buster14a/buster/issues/1189#issuecomment-6602000597) have the tables. This record holds what made them.

## Host and instrument

The measurements ran in a cloud container, **not the 9700X**: an Intel Xeon (model 173, AVX-512) under KVM, 4 CPUs, Ubuntu with clang 23.1.5, valgrind 3.22.0 and tcc 0.9.27. The VM exposes no hardware counters, so **nothing here is a cycle or time measurement**. The compile times in `passes/compile-times.txt` are one pinned CPU of this VM, and are ratios only.

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

   With `BUSTER_TIER1_KINDS=FILE`, each function's tags go to a line of FILE (`main-96b6cbcd/*.kinds`). The tagged executables are main's byte for byte. Each function's tags match its instructions in `objdump`, but for speedtest1's `main`, which runs once.
4. **Joining.** `tools/gap.c` (`cc -O2 -o gap gap.c`):
   - `gap count DISASSEMBLY CALLGRIND OBJECT BASE [KINDS]` joins callgrind's per-address counts, `objdump -d --no-show-raw-insn` and the tags into a TSV of function, origin, instruction type and count. Only the program's own code counts; the C library and the loader are other objects. Buster's executables, whose symbols valgrind doesn't read, are object `???` at base `0x108000`; clang's and tcc's are their own path at base 0. `#check unmatched` gives the counts that landed on no instruction: at most 1.0 M of a run.
   - `gap table T1.tsv... -- CLANG.tsv...` sums the TSVs and prints the tables (`main-96b6cbcd/st-table.md`, `lua-table.md`). A type belongs to one cause, so each program's causes partition its gap.
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
| stack loads and stores | 416.9 M (22.5%) | 892.8 M (25.8%) |
| register moves | 348.3 M (18.8%) | 447.7 M (12.9%) |
| address arithmetic | 274.7 M (14.8%) | 630.8 M (18.2%) |
| compares and branches | 274.7 M (14.8%) | 616.9 M (17.8%) |
| other loads and stores | 224.5 M (12.1%) | 323.4 M (9.3%) |
| zero and sign extensions | 167.3 M (9.0%) | 432.6 M (12.5%) |
| calls, returns and frames | 137.5 M (7.4%) | 52.4 M (1.5%) |
| constants | 59.7 M (3.2%) | −24.3 M (−0.7%) |
| arithmetic and the rest | −47.2 M (−2.5%) | 87.9 M (2.5%) |

**Passes, at the head before its rebase, `--tier1`'s whole-process instructions:**

| Variant | speedtest1 | Lua |
| --- | ---: | ---: |
| none | 3,869.8 M | 7,610.3 M |
| LICM | 5,067.0 M (+30.9%) | 12,130.9 M (+59.4%) |
| LICM, loops of at most 8 blocks | 4,253.9 M (+9.9%) | 7,928.9 M (+4.2%) |
| LICM, loops of at most 4 blocks | 3,994.6 M (+3.2%) | 7,771.5 M (+2.1%) |
| LICM, loops of at most 2 blocks | 3,930.2 M (+1.6%) | 7,744.8 M (+1.8%) |
| SROA | 3,868.5 M (−0.03%) | 7,613.9 M (+0.05%) |

## Not done here

- The 9700X's cycles and times, for the same builds, and #1189's step 4.
- `scripts/*.sh` name this session's scratch directory. Running them elsewhere means changing `S=` and the inputs' paths.
