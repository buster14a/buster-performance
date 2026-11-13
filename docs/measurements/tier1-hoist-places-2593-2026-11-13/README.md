# Hoisted symbol addresses placed by their takes' dominators (#2593), 2026-11-13

This is the evidence for [buster#2593](https://github.com/buster14a/buster/issues/2593) and [buster#2617](https://github.com/buster14a/buster/pull/2617). By Claude, in David's directed session ([the session](https://claude.ai/code/session_01EgbxngHnoqyjAaMkbju1T9)).

#2574 (buster#2591) defined every direct symbol address a function takes at least twice once, in the IR's preheader. #2617's `ir_typed_plan_places` defines it instead at the start of its reachable takes' nearest common dominator P, lifted before P's outermost loop where a take is inside that loop. Outside loops it stays at P only where a take is in a loop or every path from P takes it; otherwise the takes stay their own. Buster's `docs/ir.md` (the preheader's paragraphs) describes the rule.

The evidence has three parts:
- dynamic instruction counts by callgrind, in a cloud container, of the rule and seven others;
- the compile's extra work, by callgrind;
- run time and compile time on the Ryzen 7 9700X.

## Revisions

| Role | Commit | What |
| --- | --- | --- |
| main | `df85213e8f52e71f9b24a402891bdd37b1df500b` | buster's main when the work began |
| rule | `a61712244179ebe81ffc583ecef590906c8a847a` | #2617's commit, on `df85213e` |
| main, run | `e22f84ea021829bbb621dff6e8f34a78c8bd5836` | buster's main when the 9700X runs began: `df85213e` and a test file (`c_check_lanes_test.c`) |
| head, run | `971fe320fc6d343cbde2a433f596c472f662cf22` | #2617's head: the commit merged with `e22f84ea` |

## Inputs

As #2574's record ([`tier1-dispatch-2574-2026-11-12`](../tier1-dispatch-2574-2026-11-12/README.md)): the frozen `sqlite3.c` (`0a409f16…`), `speedtest1.c` at SQLite `ccc132c5` (`b5eaf4bb…`), Lua 5.4.8 (`4f18ddae…`) and #1217's five scripts, #1189's [`gap.c`](../tier1-gap-1189-2026-11-03/tools/gap.c) (`81856ce1…`). `counts/identities.txt` has their hashes. Builds are `measure-tier1-programs`'s: `--tier1 -fno-asynchronous-unwind-tables` at the default target.

## 1. Dynamic instruction counts

**Host.** A cloud container (`counts/identities.txt`): an Intel Xeon with AVX-512, clang 23.1.6, valgrind 3.22.0, GNU objdump 2.42. The compilers were built there natively, at the container's target.

**Tools** (`scripts/`, #2574's record's, with its scratch directory `S` under `~/.cache/claude-2593`):
- `st.sh` builds speedtest1, checks its verification hash and runs it under callgrind; `buildlua.sh` builds Lua; `luacount.sh` checks each script's output against clang -O0's and runs it under callgrind; `both.sh` runs both; `modes.sh` runs `both.sh` for each value of `BUSTER_X2593`.
- `fn.sh` prints a function's instructions with their counts, and `fndiff.sh` the functions' totals' changes between two runs, from gap's rows.
- `experiment-modes.patch` (on `df85213e`) is the experiment's switch, `BUSTER_X2593`, in its last state: every mode below. Compilers `x1` (modes 0 to 4), `x2` (5 to 7) and `x3` (8) were its successive states, each adding its modes without changing the earlier ones.
- `end-placement.patch` (on `a6171224`) is the rule with the definition at its block's end rather than its start, as compiler `p1` was built. Rebuilt from the patch, it gives `p1`'s speedtest1 executable byte for byte.

**Retained.** `counts/*/` keeps each run's checks and totals; `counts/kinds.tar.zst` keeps gap's per-function rows by instruction kind (no instructions' text); `counts/deltas/` the functions' changes between runs (`fndiff.sh`).

| Run | Compiler | Rule | speedtest1 | against main | `luaV_execute` |
| --- | --- | --- | ---: | ---: | ---: |
| `main` | `df85213e` | every definition in the preheader (#2574) | 3,010,676,646 | | 2,420,286,807 |
| `x1-m0` | experiment, mode 0 | the same | 3,010,677,088 | +0.00 M | 2,420,286,807 |
| `x1-m1` | mode 1 | no hoist | 3,006,425,351 | −4.25 M | 2,456,447,285 |
| `x1-m2` | mode 2 | the nearest common dominator P alone | 3,016,101,283 | +5.42 M | 2,521,766,798 |
| `x1-m3` | mode 3 | P lifted out of its outermost loop | 3,006,368,050 | −4.31 M | 2,420,286,807 |
| `x1-m4` | mode 4 | a definition per outermost loop, none outside loops | 3,006,192,977 | −4.48 M | 2,420,286,807 |
| `x2-m5` | mode 5 | #2617's rule | 3,002,545,366 | −8.13 M | 2,420,286,807 |
| `x2-m6` | mode 6 | mode 5, and a symbol taken once in a loop | 3,008,537,836 | −2.14 M | 2,420,286,807 |
| `x2-m7` | mode 7 | mode 5 without the every-path test | 3,004,427,327 | −6.25 M | 2,420,286,807 |
| `x3-m8` | mode 8 | mode 5, a definition per outermost loop where P's paths don't all take it | 3,002,131,181 | −8.55 M | 2,420,286,807 |
| `p1` | `a6171224` and `end-placement.patch` | the rule, defined at P's end | 3,003,355,636 | −7.32 M | 2,420,286,807 |
| `p2` | `a6171224` | #2617's rule | 3,002,544,899 | −8.13 M | 2,420,286,807 |

Every build gave speedtest1's verification hash (`1248168 a7fa3957…`), and every Lua build printed clang -O0's output for every script (`counts/*/st-check.txt`, `counts/*/check.txt`).

**Reading.**
- `x1-m0`'s executables are byte-identical to `main`'s, and `p2`'s to `x2-m5`'s: #2617's code is the experiment's mode 5. speedtest1's count varies by a few hundred instructions between runs of one executable.
- Lua's whole runs differ by up to 9 M between builds whose `luaV_execute` is identical, in `luaH_getshortstr` and `internshrstr`: the string hash's seed, #2574's record's noise. Lua is compared by `luaV_execute`, and `counts/deltas/lua-*` show the rest. Mode 6 also cost Lua 22 M in `match`, `classend` and `luaV_finishset` (`counts/deltas/lua-main-to-x2-m6.txt`).
- Against `main` (`counts/deltas/st-main-to-p2.txt`): `jsonTranslateTextToBlob` −4.18 M, `yy_find_shift_action` −1.72 M, `sqlite3VdbeMemSetText` −1.08 M, `powerOfTen` −0.73 M, `patternCompare` −0.21 M, `sqlite3_str_vappendf` −0.13 M; `sqlite3FindFunction` +0.19 M, `hexFunc` +0.17 M.
- Against no hoist (`counts/deltas/st-x1-m1-to-p2.txt`): `jsonTranslateTextToBlob` −3.03 M, `sqlite3GetToken` −2.11 M, `yy_find_shift_action` −0.73 M, memsys5 and `sqlite3AtoF` gain; `sqlite3_str_vappendf` (+1.07 M) and `jsonTranslateBlobToText` (+0.89 M) lose, where a definition before a loop takes callee-saved registers: [buster#2618](https://github.com/buster14a/buster/issues/2618).
- `p1`'s definition at P's end ran 0.81 M more than at its start (`counts/deltas/st-p2-to-p1.txt`: `sqlite3_str_vappendf` +0.36 M, `patternCompare` +0.21 M, `sqlite3Atoi64` +0.15 M): Tier 1 keeps a definition whose register an outgoing edge seems to read, where `patternCompare`'s `lea` of `sqlite3UpperToLower` into `r12` is followed at once by the edge's `xor %r12d,%r12d`.
- Mode 8 gains `jsonTranslateBlobToText` 0.89 M and loses `sqlite3GetToken` 0.64 M against the rule (`counts/deltas/st-p2-to-x3-m8.txt`).

## 2. The compile's extra work, by callgrind

valgrind can't run the native compiler, so `e22f84ea` and `971fe320` were built at `BUSTER_HOST_ARCH=x86-64` (`scripts/cgcompile.sh`), and each ran the frozen `sqlite3.c`'s `--tier1 -c` with speedtest1's flags under callgrind (`compile-callgrind/totals.txt`): 15,078.03 M and 15,085.60 M instructions, +7.58 M (+0.05%). By function (`compile-callgrind/delta-main-head.tsv`): `dominators_analyze` +4.01 M, `ir_lower_typed_target_path` (the placement, inlined) +1.63 M, `ir_typed_successors` +1.23 M, `ir_typed_emit_function` +1.26 M, `memset` +0.35 M, the allocator and the CFG consumer −1.13 M; the addresses without symbols are the same code moved.

## 3. Run time and compile time on the 9700X

`scripts/run2593.sh` is #2574's record's `run2574.sh` with its speedtest1 layouts (`stobj.sh` and `stlay.sh`) appended, run on benchpress for `e22f84ea` (base) and `971fe320` (head), each step and each run one hold of the lock, every run pinned to CPU 2:
- each compiler built at its commit (`BUSTER_DEBUG_INFO=0`, native target znver5; `9700x/compilers.sha256`);
- Lua's 33 objects by each compiler's `--tier1`, linked by cc in six recorded orders (`9700x/orders.txt`), the same for both builds; speedtest1 as one unity unit by the driver's link;
- before any timing, every Lua executable printed clang -O0's output for every script, and both speedtest1 builds gave the verification hash (`9700x/run.log`: checks status 0; `9700x/verify-*.txt`);
- eleven rounds with the builds rotating, each run one `perf stat` of task-clock, user cycles and user instructions (`9700x/runs.txt`), then the compile times (`9700x/compile-runs.txt`), then speedtest1's unity unit compiled to an object by each compiler and linked by cc after a pad of 0, 16, 32, 48, 1,072 and 3,088 bytes, every executable's hash checked (`9700x/layouts/verify.txt`), in eleven rounds (`9700x/layouts/runs.txt`).

#2574's record's `scripts/analyze.py` makes `9700x/analysis.md`; `scripts/layouts.py` makes `9700x/layouts/analysis.md` and `scripts/compile.py` `9700x/compile-analysis.md`. `9700x/run.log` is the script's own log; the lock's messages, which name other sessions, aren't kept.

**Lua** (`9700x/analysis.md`):

| | head / base | 95% interval over the six orders |
| --- | ---: | ---: |
| time | 0.9996 | 0.9966 to 1.0026 |
| user cycles | 0.9998 | 0.9969 to 1.0027 |
| user instructions | 0.9999 | 0.9998 to 1.0001 |

**speedtest1 at six layouts** (`9700x/layouts/analysis.md`):

| Pad, bytes | 0 | 16 | 32 | 48 | 1,072 | 3,088 | mean (95% interval) |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| time, head / base | 0.9889 | 0.9953 | 1.0038 | 0.9979 | 0.9954 | 0.9991 | 0.9967 (0.9915 to 1.0019) |
| user cycles, head / base | 0.9824 | 0.9940 | 1.0013 | 0.9944 | 0.9896 | 0.9989 | 0.9934 (0.9863 to 1.0006) |

User instructions are 0.9973 at every layout (2,960.22 M and 2,952.09 M). At the driver's own link, one layout, speedtest1 ran 1.0071 in time and 1.0053 in user cycles (paired rounds 0.9953 to 1.0121), with the same 0.9973 in instructions.

**Compile time** (`9700x/compile-analysis.md`; eleven rounds after one warm-up of each, outputs stable):

| Input | Metric | base | head | head / base | paired ratios, median (range) |
| --- | --- | ---: | ---: | ---: | ---: |
| sqlite3.c | time, ms | 399.27 | 399.35 | 1.0002 | 1.0000 (0.9966 to 1.0031) |
| sqlite3.c | cycles, M | 2,118.93 | 2,118.95 | 1.0000 | 0.9999 (0.9957 to 1.0035) |
| sqlite3.c | instructions, M | 4,709.26 | 4,715.70 | 1.0014 | 1.0014 (1.0014 to 1.0014) |
| Lua | time, ms | 166.28 | 164.97 | 0.9921 | 0.9906 (0.9872 to 1.0168) |
| Lua | cycles, M | 817.91 | 819.50 | 1.0019 | 1.0020 (0.9983 to 1.0063) |
| Lua | instructions, M | 1,939.60 | 1,935.81 | 0.9980 | 0.9980 (0.9980 to 1.0029) |

**Reading.**
- **Lua.** `luaV_execute`'s code is unchanged, and so is Lua's time, within ±0.3%.
- **speedtest1.** Its instructions fall 0.27% at every layout, as callgrind counts them. Its cycles fall 0.66% on the mean of the six layouts, an interval that just includes no change; the driver's own link is one layout, at which they rose 0.5%, the spread #2574's record found between layouts of the same code.
- **Compile time.** `sqlite3.c`'s `--tier1 -c` runs 6.4 M more instructions (0.14%), the placement's dominators and walks (section 2), in no more time or cycles. Lua's 33 short compiles run fewer instructions and their times don't resolve a change.

## Limitations

- The counts come from one container's runs of deterministic programs, at that container's target; the 9700X's builds target znver5.
- The 9700X's rounds ran while other sessions and CI took the lock between runs, as every run there does.
- The experiment's compilers `x1`, `x2` and `x3` were built from successive states of `experiment-modes.patch`; only its last state is kept, which has every mode.
