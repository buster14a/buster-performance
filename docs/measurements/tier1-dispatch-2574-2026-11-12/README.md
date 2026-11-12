# Lua's dispatch table in a register (#2574), 2026-11-12

This is the evidence for [buster#2574](https://github.com/buster14a/buster/issues/2574) and [buster#2591](https://github.com/buster14a/buster/pull/2591). By Claude, in David's directed session ([the session](https://claude.ai/code/session_01EgbxneuveDwuoP3JBUP2Fa)).

The change makes Tier 1 keep Lua's `disptab`, read by every handler's `goto *disptab[...]`, in a register through `luaV_execute`'s dispatch loop. It recomputes the address only after calls, as clang -O2 does with `r10`. It has three parts:
- IR lowering's hoist of repeated direct symbol addresses;
- the allocator's clobbers;
- the CFG consumer's preference for values read on every iteration of their loops.

The pull request describes them, and so does buster's `docs/tier1-allocation.md`, "Recomputable values read on every iteration".

The evidence has four parts:
- dynamic instruction counts by callgrind, in a cloud container, before and after main's #2573 merged;
- run time on the Ryzen 7 9700X, including speedtest1 at six layouts;
- compile time on the 9700X;
- a callgrind profile of the compile's extra work.

## Revisions

| Role | Commit | What |
| --- | --- | --- |
| base A | `5f75ea52846e96d717ffcbf3d3e05c276d197783` | buster's main when the work began |
| head A | `245e99693f839b998e5059d1aaf5823236dd251d` | #2591's code on base A |
| base B | `9750b3f03067f113533a8ae0cf847e9cf41412ea` | main after #2573 (rip-relative symbols) |
| merged | `f8aeb1454eefb45ac72cee9d1fc627585ee748d1` | #2591 merged with base B |
| head B | `e121f4ce850420954807703027411f03d3bfa871` | merged, with cheaper hoist planning and loop analysis; same objects as `f8aeb145` |

## Inputs

The inputs are #1189's and #1217's (`scripts/` of [`tier1-address-1217-2026-11-12`](../tier1-address-1217-2026-11-12/README.md)). `counts/identities.txt` has their hashes:
- the frozen `sqlite3.c` (`0a409f16…`);
- `speedtest1.c` at SQLite `ccc132c5` (`b5eaf4bb…`);
- Lua 5.4.8 (`4f18ddae…`) and the five scripts.

Builds are `measure-tier1-programs`'s: `--tier1 -fno-asynchronous-unwind-tables` at the default target, and clang -O2 23.1.6 for the reference.

## 1. Dynamic instruction counts

**Host.** A cloud container (`counts/identities.txt`): an Intel Xeon with AVX-512, clang 23.1.6, valgrind 3.22.0, GNU objdump 2.42. The compilers were built there natively.

**Tools.**
- `scripts/buildlua.sh` builds Lua; `scripts/luacount.sh` checks each script's output against clang -O0's and runs it under callgrind (`--dump-instr=yes`).
- `scripts/st.sh` builds speedtest1, checks its verification hash, and runs it under callgrind.
- #1189's [`gap.c`](../tier1-gap-1189-2026-11-03/tools/gap.c) (`81856ce1…`) joins the counts with the disassembly.
- `scripts/rip.sh` sums `rip`-relative `lea`s by function and target; `scripts/acc.sh` and `scripts/self.sh` (#1217's) classify the `lea`s.

**Retained.** `counts.tar.zst` keeps gap's rows for `lea`, `lea_stack` and `imul` only, not the programs' code; `counts/*/` keeps the checks and totals.

| | main A | head A | main B | merged | clang -O2 |
| --- | ---: | ---: | ---: | ---: | ---: |
| Lua, `luaV_execute`'s `disptab` `lea`s | 55.1 M | 18.6 M | 55.1 M | 18.6 M | 7.6 M |
| Lua, `rip`-relative `lea`s | 68.8 M | 32.3 M | 68.8 M | 32.3 M | 16.6 M |
| Lua, non-frame `lea`s | 216.7 M | 180.2 M | 216.7 M | 180.2 M | 148.8 M |
| Lua's five scripts | 5,963.7 M | 5,927.1 M | 5,954.3 M | 5,912.9 M | 4,207.3 M |
| speedtest1, `rip`-relative `lea`s | 59.1 M | 50.7 M | 46.5 M | 47.1 M | 34.3 M |
| speedtest1, whole process | 3,249.8 M | 3,246.0 M | 3,233.3 M | 3,235.7 M | 2,028.9 M |

Every build gave speedtest1's verification hash (`1248168 a7fa3957…`), and every script printed clang -O0's output.

**What changed.**
- In Lua, only `luaV_execute`'s count changes, apart from the string hash's seed noise #1217's record describes. Each remaining `disptab` recomputation follows a call (`luaV_mod`, `luaV_idiv`, `luaH_getshortstr`, `luaH_new`, the calls that reach `startfunc`) or the function's entry.
- In speedtest1 on base A, memsys5's functions gain from the hoist (−8.5 M), and a few lose: `sqlite3_str_vappendf` +1.6 M, `sqlite3VdbeMemSetText` +1.4 M, `jsonTranslateTextToBlob` +1.2 M, `yy_find_shift_action` +1.0 M.
- On base B, #2573 already reads `mem5` through `rip`-relative operands, so those gains are #2573's, and the losses remain: +2.4 M. They are [buster#2593](https://github.com/buster14a/buster/issues/2593)'s.

**Variants measured on the way** (Lua's scripts, M; `scripts/experiments.patch` holds the experimental switches, on base A):

| Variant | Lua | `disptab` | speedtest1 |
| --- | ---: | ---: | ---: |
| base A | 5,963.7 | 55.1 | 3,249.8 |
| hoist alone (the issue's experiment) | 6,028.8 | 56.4 | |
| every recipe caller-saved, calls as clobbers (no hoist) | 6,341.8 | 55.1 | |
| hoist, symbol recipes caller-saved, a memory hint after a clobber | 5,941.8 | 35.9 | |
| the same in `r8`–`r10`, no memory hint | 5,910.1 | 18.6 | 3,277.0 |
| hot = read on every turn of any loop | 5,927.2 | 18.6 | 3,288.2 |
| head A: hot = the outermost loops, callee-saved or `r8`–`r10` | 5,927.1 | 18.6 | 3,246.0 |
| head A's hot values in `r8`–`r10` alone | 5,922.1 | 18.6 | 3,252.3 |

On base B, a hoist limited to takes inside the typed stream's loops (backward jumps' ranges) gave Lua 5,920.4 M and speedtest1 3,235.9 M, and isn't in the pull request.

## 2. Run time on the 9700X

`scripts/run2574.sh` is #1217's `run1217.sh` and `compile2.sh` adapted. It ran on benchpress, each step and each run one hold of the lock, every run pinned to CPU 2:
- each compiler built at its commit (`BUSTER_DEBUG_INFO=0`, native target znver5);
- Lua's 33 objects linked in six recorded orders (`9700x/orders.txt`), the same for both builds;
- speedtest1 as one unity unit, so one layout;
- before any timing, every Lua executable printed clang -O0's output for every script, and both speedtest1 builds gave the hash;
- eleven rounds with the builds rotating, each run one `perf stat` of task-clock, user cycles and user instructions (`9700x/runs.txt`).

`scripts/analyze.py` (#1217's) makes `9700x/analysis.md`. `9700x/run.log` is the script's own log; the lock's messages, which name other sessions, aren't kept.

### Run A: base A against head A

| | head / base | 95% interval over the six layouts |
| --- | ---: | ---: |
| Lua's five scripts, time | 0.9992 | 0.9875 to 1.0110 |
| Lua's five scripts, user cycles | 0.9993 | 0.9879 to 1.0108 |
| Lua's five scripts, user instructions | 0.9938 | 0.9937 to 0.9940 |

- **Lua's time.** The ratio by layout: 1.0005, 1.0008, 1.0033, 1.0048, 0.9774, 1.0087. By script: `calls` 0.987, `tables` 0.992, `strings` 0.998, `arithmetic` 0.990, `closures` 1.015.
- **speedtest1,** one layout:

  | Metric | head / base | paired rounds' range |
  | --- | ---: | ---: |
  | time | 1.0036 | 0.9823 to 1.0099 |
  | user cycles | 1.0046 | 0.9973 to 1.0075 |
  | user instructions | 0.9988 | |

**Reading.** The instructions fall as callgrind counts them, at every layout. The time doesn't move: Lua's mean is within 0.1% of the base, with a 95% interval of ±1.2%. The `lea` taken out of each dispatch is a one-cycle operation that the dispatch's load and indirect jump don't wait on once it has issued, which is the likely reason; this run doesn't measure it.

### Run B: base B against head B

The same script on base B and head B, in `9700x-b/`. It ran in its own directory (`2574-claude-b`, compile outputs in `/tmp/claude-2574-compile-b`), which are the script's only two differences. Every check passed, and the log has no lock messages.

| | head / base | 95% interval over the six layouts |
| --- | ---: | ---: |
| Lua's five scripts, time | 1.0061 | 0.9926 to 1.0198 |
| Lua's five scripts, user cycles | 1.0064 | 0.9923 to 1.0208 |
| Lua's five scripts, user instructions | 0.9943 | 0.9939 to 0.9946 |

- **Lua's time.** The ratio by layout: 0.9908, 1.0197, 1.0050, 0.9990, 1.0239, 0.9987. By script: `calls` 0.987, `tables` 0.992, `strings` 0.993, `arithmetic` 0.991, `closures` 1.030.
- **speedtest1** at the layout the driver's link gives:

  | Metric | head / base | paired rounds' range |
  | --- | ---: | ---: |
  | time | 1.0175 | 0.9992 to 1.0282 |
  | user cycles | 1.0177 | 1.0007 to 1.0257 |
  | user instructions | 1.0008 | |

### speedtest1's layouts

Run B's speedtest1 result reproduces. Twenty-one more rounds of the same two executables (`9700x-b/speedtest1-repeat.txt`, `scripts/strep.sh`) give user cycles 1.0168, and every paired round falls between 1.0133 and 1.0241. The same repeat of run A's two executables (`9700x/speedtest1-repeat.txt`, the script with run A's directory) gives 1.0022, with paired rounds from 0.9923 to 1.0192.

Two checks of whether the cost is in the change's code or in its layout:
- **Profile.** `perf record` of five runs of each executable (`9700x-b/profile-*.tsv`, `scripts/stprof.sh`, user cycles sampled every 200,003). The head's samples total 1.8% more, but no function accounts for it: the differences are spread over dozens of functions, none above 2 M, and each is within its functions' spread between runs. The functions whose code the hoist changes aren't among the largest.
- **Six layouts** (`9700x-b/layouts/`, `scripts/stobj.sh` and `scripts/stlay.sh`). Each compiler compiled the unity unit once to an object. `cc` linked each object after a pad of 0, 16, 32, 48, 1,072 and 3,088 bytes, the same for both builds. Every executable's hash was checked (`layouts/verify.txt`), then eleven rounds ran as run B's did (`layouts/analysis.md`):

  | Pad, bytes | 0 | 16 | 32 | 48 | 1,072 | 3,088 | mean (95% interval) |
  | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
  | time, head / base | 0.9988 | 0.9883 | 1.0148 | 1.0017 | 1.0016 | 1.0049 | 1.0017 (0.9926 to 1.0107) |
  | user cycles, head / base | 1.0017 | 0.9881 | 1.0169 | 1.0021 | 1.0066 | 0.9965 | 1.0020 (0.9918 to 1.0121) |

  User instructions are 1.0008 at every layout.

**Reading.**
- **speedtest1.** Run B's +1.8% comes from the layout the driver's link gave head B. Shifting the same code by 32 bytes costs the head 1.7%, and shifting it by 16 bytes gains it 1.2%. Over the six layouts, speedtest1's time doesn't move measurably, as in run A.
- **Lua.** In both runs, Lua's instructions fall 0.6% at every layout, but its time doesn't move measurably: the mean is within 0.6% of the base, inside a 95% interval of about ±1.3%. `closures` is slower at most layouts in both runs, although its instructions don't change (0.9997). This record doesn't explain why.

## 3. Compile time on the 9700X

The same script, after the run-time rounds: the frozen `sqlite3.c` by `--tier1 -c` and Lua's 33 sources by `--tier1` into an executable. Eleven rounds after one warm-up of each, the builds alternating, one hold per run, CPU 2, outputs in `/tmp` and stable across rounds (`9700x/compile-runs.txt`, `9700x/compile-*.sha256`).

Run A:

| Input | Metric | base | head | head / base | paired ratios, median (range) |
| --- | --- | ---: | ---: | ---: | ---: |
| sqlite3.c | time, ms | 389.43 | 392.94 | 1.0090 | 1.0100 (1.0058 to 1.0137) |
| sqlite3.c | cycles, M | 2,063.88 | 2,083.26 | 1.0094 | 1.0101 (1.0059 to 1.0147) |
| sqlite3.c | instructions, M | 4,768.47 | 4,822.74 | 1.0114 | 1.0114 |
| Lua | time, ms | 164.38 | 163.60 | 0.9953 | 0.9935 (0.9885 to 1.0199) |
| Lua | cycles, M | 805.17 | 810.24 | 1.0063 | 1.0044 (0.9993 to 1.0099) |
| Lua | instructions, M | 1,939.79 | 1,945.88 | 1.0031 | 1.0031 |

Run B (`9700x-b/compile-runs.txt`):

| Input | Metric | base | head | head / base | paired ratios, median (range) |
| --- | --- | ---: | ---: | ---: | ---: |
| sqlite3.c | time, ms | 389.81 | 393.61 | 1.0097 | 1.0093 (1.0072 to 1.0117) |
| sqlite3.c | cycles, M | 2,066.42 | 2,087.26 | 1.0101 | 1.0099 (1.0087 to 1.0129) |
| sqlite3.c | instructions, M | 4,765.22 | 4,815.01 | 1.0104 | 1.0104 |
| Lua | time, ms | 167.19 | 163.22 | 0.9763 | 0.9745 (0.9720 to 0.9989) |
| Lua | cycles, M | 821.59 | 809.25 | 0.9850 | 0.9837 (0.9803 to 0.9887) |
| Lua | instructions, M | 1,938.21 | 1,943.20 | 1.0026 | 1.0026 (1.0026 to 1.0075) |

**Reading.**
- **sqlite3.c.** Compiling it costs 1.0% more time in both runs, in step with its instructions. Head B's extra 49.8 M instructions match callgrind's 43.4 M on the baseline build (section 4). The native build runs about a third of the baseline's instructions, but the extra work is scalar in both, so the same work is 1.0% of the native compile and 0.3% of the baseline's.
- **Lua.** Its compile is 33 short processes of the two compilers, whose own layouts differ. Their cycles move one way in run A (+0.6%) and the other in run B (−1.5%) against +0.3% instructions, so this measurement doesn't resolve Lua's compile cost.

## 4. The compile's extra work, by callgrind

valgrind can't run the native compiler, so main B, the merged head and head B were built at `BUSTER_HOST_ARCH=x86-64`. Each ran `sqlite3.c`'s `--tier1 -c` under callgrind with `ulimit -v 67108864` (`compile-callgrind/totals.txt`):
- main B: 15,147.2 M;
- merged: 15,196.9 M;
- head B: 15,190.6 M.

Head B's objects are byte-identical to the merged head's. Head B's extra 43.4 M by function (`compile-callgrind/delta-main-e121f4ce.tsv`):

| Function | Extra, M |
| --- | ---: |
| `dominators_analyze` (the hot-recipe test's loops) | 12.5 |
| `tier1_allocate_hinted` (the hoisted values' intervals, the clobbered scans) | 12.5 |
| `tier1_emit_cfg_preference` (the hot-recipe test's walks) | 8.6 |
| `ir_lower_typed_target_path` (the hoist's plan) | 3.3 |
| `__memset_avx2_unaligned_erms` | 2.0 |
| `tier1_cfg_prepare`, `tier1_cfg_finish`, `tier1_emit_cfg_records` | 4.8 |

Head B's planning lists the takes once instead of making three passes and a per-entry column (−4.4 M against the merged head). The loop analysis skips CFGs with no backward edge in layout (−1.7 M).

## Limitations

- The counts come from one container's runs of deterministic programs. Lua's string hash is seeded per run, which moves `luaH_getshortstr`'s count by a few million.
- speedtest1's rows in runs A and B come from one layout each, the one the driver's link gives. Its six layouts were measured for run B's builds only.
- The 9700X runs come from one host, in one evening, between other sessions' runs.
- The compile profile is the baseline build's, not the native one's. The extra work is the same code, but the totals differ.
