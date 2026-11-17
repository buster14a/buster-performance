# Tier 1 code size: a call's arguments in their registers; SQLite's and c-testsuite's bounds (buster#2646)

Evidence for [buster14a/buster#2918](https://github.com/buster14a/buster/pull/2918), which does
[#2646](https://github.com/buster14a/buster/issues/2646). The design is in buster's `docs/tier1-allocation.md`,
"Call arguments in their registers (#2646)", and the measurement change in `docs/c-testsuite.md`.

- **base:** main `d876a5e0` (buster's merge of #2895).
- **head:** `6320f42b` (the pull request's fourth commit). The 9700X's first run measured `7a485bd2`, the CFG
  consumer's hints alone (`9700x/run-7a485bd2/`); `cb0b7511` adds the straight-line consumer's, `6320f42b` makes the
  allocator compute each start's hints once. `cb0b7511` and `6320f42b` give the same objects.
- **Inputs:** the frozen corpus's SQLite 3.53.2 amalgamation (`tools/ci/fetch-corpus.sh`), Lua 5.4.8 (`hosted-offline.sh
  lua`), c-testsuite at `5c727565`, SQLite's `speedtest1.c` at `ccc132c5`, the five Lua scripts of
  `tier1-reciprocal-141-2026-11-01`.

## 1. What was above the bound (cloud container, AVX-512 Xeon)

`census/` holds each object's bytes by instruction category (`scripts/census/cats.py`: objdump's instructions inside each
ELF function symbol's size, matched by name with clang -O0's) and its register-to-register moves by context
(`moves.py`: a move into an argument register with a call in the next 11 instructions, from rax after a call, before a
jump, and so on).

- **c-testsuite's measurement.** `test-c-testsuite --tier1 --code-size` read the cross-check's object, which inlines since
  #2541 step 2: 62,350 Tier 1 bytes against clang's 45,748, its callers holding their callees' bodies, 50 dead callees
  with no code. With `--tier1-no-inline` (`scripts/census/noinline.sh`), as `measure-tier1-programs` measures SQLite
  and Lua: 48,365 against 47,293, +2.27%. One test, 00204 (aggregates passed, returned and read by `va_arg`), was
  +6,404 bytes of it, the other 219 −5,332.
- **SQLite already passed on main**: 904,862 against 913,339 (#2646's 971,788 at `12750420`).
- **The moves into argument registers.** SQLite's Tier 1 object had 40,142 register-to-register moves (117,980 bytes)
  against clang -O0's 6,813 (17,936 bytes); 27,479 of them (82,048 bytes) put a value into an argument register just
  before a call (`census/sqlite-moves-main.txt`). c-testsuite had 1,482 of them, 4,373 bytes, more than its whole
  excess; Lua 7,200, 21,476 bytes.
- **Not done here, measured for later** (`scripts/census/frame_bias.py`, `disp_census.py`): Tier 1 addresses its frame
  from rsp, a SIB byte on each of SQLite's 53,970 frame accesses, and 8,768 of them need a 32-bit displacement; ordering
  each frame's slots by their accesses would leave 2,139 (about 20 KB). 00204's excess is aggregate copies, 8 bytes a
  move (570 pairs, 5,199 bytes).

## 2. Sizes (Tier 1 function bytes, `--tier1-no-inline`, against clang -O0's matched functions)

`sizes/cloud.txt`: every build's `measure-tier1-programs --sizes-only --check-code-size` and `test-c-testsuite --tier1
--code-size` (through a wrapper adding `--tier1-no-inline` to every compile, main's harness compiling its size object
with inlining). The AVX-512 build (`native`) and the `BUSTER_HOST_ARCH=x86-64` build give the same bytes, on main and
on head. Clang 23.1.6; its -O0 bytes equal #2646's (23.1.4).

| | main | head | clang -O0 | head / clang |
| --- | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 904,862 | 884,975 | 913,339 | 0.969 |
| Lua, 34 sources | 205,026 | 196,906 | 248,990 | 0.791 |
| c-testsuite, 220 programs | 48,365 | 45,227 | 47,293 | 0.956 |

`sizes/c-testsuite-head-6320f42b.txt` is the head's own harness (its size objects compiled with `--tier1-no-inline`,
linked and run): 45,227 against 47,293, `gate=pass`, all 220 programs passing. On the 9700X
(`9700x/sizes/`, its Zen 5 builds, the host's clang 23.1.1 as the reference, whose -O0 objects are larger): SQLite
904,862 → 884,975 against 973,695, Lua 205,026 → 196,906 against 265,264, the same Tier 1 bytes as the cloud's.

| Moves (census) | main | head | clang -O0 |
| --- | ---: | ---: | ---: |
| SQLite, all register-to-register | 40,142 | 33,335 | 6,813 |
| SQLite, into an argument register before a call | 27,479 | 21,323 | 1,851 |
| Lua, all | 9,772 | 7,121 | |
| Lua, into an argument register before a call | 7,200 | 4,742 | |
| c-testsuite, register-to-register bytes | 5,551 | 2,430 | 2,384 |

## 3. Callgrind (cloud container, x86-64 builds)

Method: the #2782 record's (`tier1-dispatch-entry-2782-2026-11-15`): `scripts/callgrind/buildlua.sh`, `luacount.sh`,
`st.sh`, `conv.sh` and `funcs.sh` with #1189's `gap.c` (`tier1-gap-1189-2026-11-03/tools/gap.c`). Lua's string-hash
seed is fixed; each script's output equals clang -O0's Lua's, speedtest1's `--verify` hash is the expected one
(`callgrind/programs-detail.txt`).

| | main | head `7a485bd2` | head `6320f42b` |
| --- | ---: | ---: | ---: |
| speedtest1 (`--size 5` mix1) | 2,529,773,629 | 2,516,165,646 | 2,516,121,000 (−0.54%) |
| Lua's five scripts | 4,592.2 M | 4,559.8 M | 4,558.0 M (−0.74%) |

By function (`callgrind/functions-*.txt`, changes over 10 K): speedtest1's `sqlite3VdbeExec` −3.24 M, `sqlite3RunParser`
−1.60 M, `sqlite3BtreeIndexMoveto` −1.05 M (#2823's swap); Lua's `auxsort` −15.57 M, `luaM_free_` −3.85 M (#2823's
two hottest sites), `str_gsub` −2.99 M. Three functions run more: `sqlite3OpenTableAndIndices` +36 K,
`sqlite3GenerateIndexKey` +18 K, Lua's `ccall` +66 K.

**Compile** (`callgrind/compile-sqlite3-*.txt`, `--tier1 --lanes 1 -c sqlite3.c`, run with `ulimit -v 64 GiB`):
16,962.34 M → 16,984.88 M at `7a485bd2`, 16,981.63 M at `6320f42b` (+0.11%). By stage, inclusive: the allocator
`tier1_allocate_hinted` +19.47 M (+4.0%), `tier1_emit_cfg_problem` +6.17 M, `tier1_cfg_prepare` +5.71 M; emission and
encoding of the smaller code −16.3 M (`tier1_emit_cfg_records`, `encode_one`, `instruction_is_valid`,
`size_branches_scalar`). At `7a485bd2` the allocator's own lines showed 3.85 M in recomputing a start's value hint to
tell a register hint from it, which `6320f42b` removes.

## 4. Run time on the 9700X

Method: the #2782 record's, `scripts/9700x/` (`chain.sh` runs `compilers.sh`, `sizes.sh`, `objects.sh`, `link.sh`,
`time2.sh`, `analyze.c` and `compile.sh`; `prof.sh` separately), each step's holds of the lock taken per program's round.

- **Compilers.** `BUSTER_HOST_ARCH=znver5` Release builds of base and head (`9700x/build.log`).
- **Objects and links.** Each compiler builds Lua's 33 objects (`-Dluai_makeseed(L)=0x2592u`) and speedtest1's unit once;
  Lua is linked in 33 orders (`9700x/orders.txt`), speedtest1 after pads of 0 to 3,696 bytes.
- **Checks.** All 82 executables passed first, in both runs: each Lua script's output against clang -O0's, speedtest1's
  verification hash (`9700x/checks.txt`).
- **Timing.** One untimed round of each program, then 5 timed rounds of Lua and 7 of speedtest1, each run `perf stat`
  pinned to CPU 2 in #2553's order: 1,762 runs a time, none failed (`9700x/runs/runs.txt`, `busy.txt`).

| head / base, mean over layouts | head `7a485bd2` | head `6320f42b` |
| --- | --- | --- |
| Lua, 33 orders, user cycles | −0.13% (−0.40% to +0.15%), slower at 12 of 33 | −0.18% (−0.46% to +0.10%), slower at 18 of 33 |
| Lua, task-clock | −0.12% (−0.38% to +0.14%) | −0.16% (−0.43% to +0.11%) |
| Lua, user instructions | −0.70% | −0.74% |
| speedtest1, 8 shifts, user cycles | −0.35% (−0.65% to −0.05%), slower at 2 of 8 | −0.40% (−0.78% to −0.02%), slower at 2 of 8 |
| speedtest1, task-clock | −0.29% (−0.52% to −0.07%) | −0.35% (−0.68% to −0.03%) |
| speedtest1, user instructions | −0.55% | −0.55% |

(95% t intervals over the independent layouts; `9700x/analysis.txt` and `9700x/run-7a485bd2/analysis.txt` have each
layout, each script and the run-to-run spread.) The static reports (`9700x/reports-*.txt`, `--tier1-report`) barely
move: Lua's and speedtest1's spill stores 10,678 → 10,689, loads 11,566 → 11,578, edge moves 26,867 → 26,903.

## 5. Compile time on the 9700X

`scripts/9700x/compile.sh`: head's `measure-compile` with base as `--reference`, interleaved, pinned to CPU 2
(`9700x/compile-summary.txt`, from `9700x/compile/` and `9700x/run-7a485bd2/compile/`):

| `--tier1 --lanes 1 -c`, medians, head `6320f42b` | base | head | head / base |
| --- | ---: | ---: | ---: |
| `sqlite3.c`, 21 runs: wall | 604.203 ms | 604.178 ms | −0.004% |
| user cycles | 3,246.4 M | 3,246.1 M | −0.007% |
| user instructions | 8,046.5 M | 8,086.7 M | +0.50% |
| `lvm.c`, 41 runs: wall | 28.396 ms | 28.414 ms | +0.06% |
| user cycles | 126.37 M | 126.50 M | +0.10% |
| user instructions | 364.6 M | 365.7 M | +0.30% |

At `7a485bd2`: `sqlite3.c` +0.08% wall, +0.09% cycles, +0.47% instructions. The Zen 5 build's instructions rise more
than the x86-64 build's by callgrind (+0.11%). `scripts/9700x/prof.sh` sampled both compiles' instructions by symbol
(`9700x/prof/`, a period of 400,009): most of the per-symbol changes are in functions this change doesn't touch, code
the unity build inlines differently once the backend's unit grows (`tier1_emit_cfg_records` −37 M against
`tier1_emit_phase` +21 M and `tier1_emit_cfg_function` +17 M, now out of line; `ssa_ir_promote_path` −16 M,
`tier1_select_burs_pattern` −14 M, `tier1_select_expand` +13 M), each symbol's count good to a few percent at that
period. Cycles and wall time don't move.

## 6. Tests

- `scripts/tests/suite1.sh` ran, on the AVX-512 and the x86-64 builds: `test-tier1-cfg-source` (c-testsuite subset,
  `--simd`, SQLite, musl), `test-calling-convention --cross-check`, `test-check-debug --cross-check`, `test-ssa-source
  --tier1` (typed generate 48, lifetimes, the c-testsuite subset, the interpreter's source), `test-check-lanes`,
  `test-emitted-code`, `test-emission-metadata` and `test-tier1-{allocation,cfg,emit,frame,frame-execution,liveness,
  masks,pipeline,select,wide,schedule}`: all passed.
- Mutation checks (`scripts/tests/mutants.py`, `mutants2.py`, on a copy of the tree, Debug builds), each mutant killed
  by its own check: the register hint ignored, allowed to evict, ranked above value hints, given to a value that lives
  past its call; the CFG consumer's use registers left out; the straight-line consumer's hints dropped, or given to
  an interval that goes past its call; c-testsuite's size object compiled without `--tier1-no-inline`.
- `scripts/tests/sanitizers.sh`: the x86-64 MemorySanitizer, AddressSanitizer (with UBSan) and ThreadSanitizer builds
  of `6320f42b`, CI's sanitizer options, then `test-tier1-{allocation,cfg,emit,pipeline}`, `test-c-testsuite
  --self-test` and `--tier1 --check-code-size`, `measure-tier1-programs --sizes-only --check-code-size`,
  `test-tier1-cfg-source` on the c-testsuite subset, `test-calling-convention --cross-check` and `test-check-debug
  --cross-check`: every command exited 0 with no report in any of the three (`sanitizers.txt`).
