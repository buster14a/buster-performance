# #2718's value numbering with memory: run and compile time, policy, phases, loads removed, twins and campaigns (2026-11-14)

This is the evidence for [buster#2718](https://github.com/buster14a/buster/issues/2718) (Tier 1: value numbering with memory, repeated loads and store-to-load forwarding) and [buster#2821](https://github.com/buster14a/buster/pull/2821), from `claude/loving-goodall-lj1n26`. By Claude, in David's directed session ([the session](https://claude.ai/code/session_01NNmNQub8akmWiSMaWbaw8L)), from the claim of 14 November ([comment 6885272067](https://github.com/buster14a/buster/issues/2718#issuecomment-6885272067)).

The pull request adds `ir_optimize_memory.c`, the optimizer's `BUSTER_IR_OPTIMIZE_MEMORY` pass. It runs after SCCP and the identities and before dead-code removal, and forwards a load's value from an earlier access of the same bytes along the dominator tree. `--tier1-passes=+memory` (or `+all`) runs it. The final head's 9700X measurements below left it off by default. It also marks volatile and `_Atomic` locals' slots volatile (`BUSTER_TYPED_LOCAL_VOLATILE`, then `BUSTER_IR_SLOT_VOLATILE`), which the pass's first version forwarded through. The design and its rules are in buster's `docs/ir-memory-value-numbering.md`.

**Decision:** with the pass, speedtest1 took 1.0026 times the cycles it took without, and Lua's five scripts 0.9963, both within noise. sqlite3.c's `--tier1` compile took 1.030 times as long. So `--tier1` leaves the pass off by default (buster `c58e7e3`), as #139 left LICM, SROA and the solver off.

## Revisions

| Role | Commit | Tree | What |
| --- | --- | --- | --- |
| main | `750f6a0405a8bb855f4745a4f10e90682d155b17` | `c2f75d03d5e206f75d4c26c41269bfd1ef83c50c` | the branch's base after its last merge |
| prototype | `42a7c1e2c3d167bc53a24ce0dad944251a8a1ab7` | | environment switches choose the rules: `local/survey/`, `9700x/prototype/` |
| phases | `5a4e56beb74987e025dc15a39143ad54c5960cae` | `44a36f65708d1b50a06ab5223e8abf18b4d609f9` | `scripts/9700x/phases.patch` over it: `9700x/phases/`; the first differential campaigns, `differential/memory` and `differential/all` |
| before the volatile fix | `894d9716c96c8efd2500b3f188c907755cedbe2f` | | `local/894d971/` |
| measured head | `566770be50aa74295a60687c381eb9876597a568` | `a7f9a21e77efe3624fec7c70adecb7baafbd10e1` | the pass on by default: the 9700X's final queue (`9700x/final/`) and the final campaigns |
| final code | `a694d362b29bad11401698fc899d5d0f0745e78e` | `71990abefccea4697e0caae97850297af5c0c710` | the measured head with a comment and a usage line changed: `local/final/` |
| x86-64 host fix | `8c042b7c0eea7a00fed5db64e4eb6fbfd4732cee` | `ab2f9e28f3f1badeee34c8211fefdf6f3d453b91` | an unused variable under `BUSTER_HOST_ARCH=x86-64` |
| default off | `c58e7e3a6fae2a934b595173ec4dd4d5466bfc66` | `c5d35a31d9dea046d02648afeb56aeb1ae408e34` | the default without the pass: what the measured head's `--tier1-passes=-memory` runs |

The default's change only clears the pass's bit in `BUSTER_CHECK_TIER1_PASSES_DEFAULT`, so the measured head's `-memory` variant is the final default, and its `+memory` default the final `+memory`. Locally, the final build's `--tier1` and `--tier1-passes=-memory` give the same objects for speedtest1's unit and `lvm.c`.

## The final head on the 9700X (`9700x/final/`)

**Host** (`host.txt`): Ryzen 7 9700X, Linux 6.18.50, CPU 2 with governor and EPP `performance`, clang 23.1.1. Both compilers were built there by `BUSTER_DEBUG_INFO=0 ./build.sh --config Release` (`build-*.log`; hashes in `host.txt`). Every step ran in its own `exclusive.sh` hold pinned to CPU 2, and no step's receipt lists another process above 5% CPU. The inputs are the frozen corpus's `sqlite3.c`, SQLite 3.53.2's `speedtest1.c`, Lua 5.4.8 and the `tier1-reciprocal-141-2026-11-01` record's five scripts, as in #139's record.

**Identity** (`identity.txt`, `scripts/9700x/identity.sh`): the head's `--tier1 --tier1-passes=-memory` against main's `--tier1`, on speedtest1's unit and Lua's 33 units: every object byte for byte (`identity status 0`), and the head's default (the pass on) differs.

**Run time** (`programs.txt`, `measure-tier1-programs --runs 11 --variant --tier1-passes=-memory`), user cycles with the pass (the measured head's default) and without:

| Program | With | Without | With / without |
| --- | ---: | ---: | ---: |
| speedtest1 | 738.1 M | 736.2 M | 1.0026 |
| Lua's five scripts | 981.3 M | 984.9 M | 0.9963 |
| calls.lua | 108.4 M | 113.5 M | 0.955 |
| tables.lua | 195.8 M | 197.4 M | 0.991 |
| strings.lua | 235.2 M | 233.2 M | 1.009 |
| arithmetic.lua | 156.9 M | 154.9 M | 1.013 |
| closures.lua | 285.0 M | 286.0 M | 0.996 |

Instructions: speedtest1 2,562.8 M with against 2,537.7 M without, Lua 4,855.1 M against 4,773.4 M. Every speedtest1 build gave the verification hash `1248168 a7fa3957…`. Against clang -O2 the measured head's `--tier1` (with the pass) took 1.16 times the cycles on speedtest1 and 1.09 times on Lua.

The prototype's Lua gain (0.9745, below) is gone: the program without the pass got faster (arithmetic.lua 166.4 M to 154.9 M cycles), while callgrind counts nearly the same code with it (arithmetic.lua +5.8% instructions in both). main's only Tier 1 change in between is #2773 (#2768, allocation ranges that wait in their value's slot).

**Loads dispatched** (`loads.txt`, `scripts/9700x/loads.sh`: speedtest1 and Lua built by the head with the pass and with `-memory`, then `perf stat` of user cycles, instructions and Zen 5's `ls_dispatch` events, ten runs of each in two rounds; medians, Lua's summed over its five scripts):

| | Cycles | Instructions | Loads dispatched | Stores dispatched |
| --- | ---: | ---: | ---: | ---: |
| speedtest1, with / without | 1.0074 | 1.0099 | 0.9332 | 1.0082 |
| Lua, with / without | 0.9832 | 1.0166 | 0.9605 | 0.9990 |

Per Lua script, loads dispatched with over without: arithmetic 0.9551, calls 0.9592, closures 0.9739, strings 0.9646, tables 0.9422. The cycles again show a small loss on speedtest1 and a small gain on Lua, with calls.lua's 0.8825 the largest swing.

**Compile time, whole processes** (`stages.txt`, `scripts/9700x/stages.sh`, `measure-compile --runs 11 --variant --tier1-passes=-memory -- --tier1 --lanes 1 -c sqlite3.c`, the head's own executable): 653.6 ms with the pass against 634.6 ms without, 1.030 times, 18.9 ms; 3,516.4 M against 3,410.8 M user cycles, 8,447.5 M against 8,371.0 M instructions. `compile.txt` (`time-runs`, head against main and main again): sqlite3.c 653.2 ms against 634.8 and 635.1 ms; `lvm.c` 29.50 ms against 29.18 and 29.20 ms (1.011).

**Compile time per pass** (`passes-*.txt`, `benchmark-ir-source --passes --only ROW` on sqlite3.c: 2,602 functions, 599,619 lowered IR instructions; medians of 21 rounds):

| Row | Vector, ms | Scalar, ms | Scalar / vector |
| --- | ---: | ---: | ---: |
| `tier1` (Tier 1's optimizer set) | 49.8 | 47.7 | 0.96 |
| `tier1-memory` (with the pass) | 56.3 | 56.6 | 1.01 |
| `memory` (the pass and dead-code removal) | 31.2 | 40.3 | 1.29 |

The driver's cost is about twice the `tier1-memory` row's 6.5 ms: it runs the pass after the inlining, on larger functions. On the scalar host (`local/final/compile-callgrind.txt`), callgrind of the compile counts 203 M more instructions in `check_tier1_passes`, which the pass is inlined into, and about 100 M fewer in selection, row checks and emission.

## Which rules pay (`9700x/prototype/`)

The prototype's three policies by `measure-tier1-programs --runs 11 --variant` on the 9700X (`scripts/9700x/prototype-*.sh`), each beside `--tier1` without the pass, Tier 0, and clang -O0 and -O2. Ratios are the variant's over `--tier1`'s:

| Policy (file) | speedtest1 cycles | speedtest1 instructions | Lua cycles | Lua instructions |
| --- | ---: | ---: | ---: | ---: |
| Every rule (`full.txt`, shipped) | 0.9968 | 1.0108 | 0.9745 | 1.0168 |
| No forwarding from a load a user could fold (`fold.txt`) | 0.9957 | 0.9998 | 0.9961 | 1.0009 |
| One block, one key's own stores (`block.txt`) | 1.0104 | 0.9968 | 0.9918 | 1.0006 |

`--tier1`'s own row across the three runs: speedtest1 736.6 to 742.6 M user cycles (0.8%), Lua 985.1 to 994.8 M (1.0%). speedtest1's differences are within that, and every rule's Lua gain was not. Every rule is the pass's (`+memory`); the final head's run time above no longer shows that gain.

## Exact counts (`local/`)

Callgrind (`--cache-sim=yes`, the 9700X's D1 and an LL of 1 MiB) of the programs' own functions, speedtest1's `mix1` at size 5 and Lua 5.4.8's five scripts (the `tier1-reciprocal-141-2026-11-01` record's), built by `--tier1` (`scripts/local/build.sh`, `measure.sh`). Columns are instructions, data reads and data writes.

**Final code (`local/final/`, a694d36's Develop build, pass on against `--tier1-passes=-memory`):**

| Program | Instructions | Data reads | Data writes |
| --- | ---: | ---: | ---: |
| speedtest1, off | 2,447,374,388 | 691,370,049 | 360,658,465 |
| speedtest1, on | 2,472,453,547 | 647,196,017 | 364,938,086 |
| on / off | 1.0102 | 0.9361 | 1.0119 |
| Lua, off | 4,285,974,591 | 1,022,543,360 | 534,687,817 |
| Lua, on | 4,366,612,648 | 974,053,487 | 532,279,872 |
| on / off | 1.0188 | 0.9526 | 0.9955 |

`report-and-sizes.txt`: speedtest1's unit forwards 3,367 loads (lvm.c 144); records 389,379 to 387,732, spill loads 11,712 to 12,110, call loads 23,265 to 22,986. The executables' text: speedtest1 2,001,691 to 1,990,059 bytes, Lua 443,960 to 442,792.

**Before the volatile fix (`local/894d971/`, against main `1935a91`'s pipeline):** speedtest1 2,467.9 M to 2,495.1 M instructions, 697.0 M to 652.3 M reads; Lua 4,302.6 M to 4,385.1 M, 1,029.2 M to 981.3 M.

**The survey (`local/survey/`, the prototype):** `base` off, `mem` every rule, `fold` with the fold rule, `blk` one block and one key, `f0` without the family rule, `p0` without private slots, `c0` without crossing blocks. `c0`'s speedtest1 row is not valid: two runs shared one database directory and that one failed early.

## Twins on the corpora (`local/final/test-ir-source-passes-*.txt`)

`test-ir-source --passes` by the final code, every row by both versions. The `memory` row (the pass with dead-code removal) and the `tier1-memory` row (Tier 1's optimizer set with it) forward:

| Corpus | Functions | `memory` | `tier1-memory` |
| --- | ---: | ---: | ---: |
| c-testsuite's subset | 430 | 47 | 76 |
| frozen `sqlite3.c` | 2,602 | 3,136 | 3,480 |
| musl | 2,775 | 2,973 | 3,085 |

All three passed with no failures. The inliner's refusals, also in the earlier records, are left out of the files (15, 219 and 131 lines).

## The pass's phases (`9700x/phases/`)

`scripts/9700x/phases.patch` reads the TSC between the pass's phases over `5a4e56b`. `test-ir-source --passes` on `sqlite3.c` ran three times under the lock pinned to CPU 2. `phases-vector.log` and `phases-vector-again.log` are the vector version with vector gathers for the addresses' chains, and `phases-scalar-addresses.log` the vector version with the scalar chains, which ships. Each file has both versions' lines, 5,204 calls each (the `memory` and `tier1-memory` rows), in millions of ticks:

| Phase | Vector (scalar chains) | Scalar |
| --- | ---: | ---: |
| 1 classification | 4.38 | 13.59 |
| 2 derivation | 6.32 | 6.73 |
| 3 escapes | 1.22 | 2.50 |
| 4 events | 0.77 | 5.56 |
| 6 addresses (shared) | 3.42 | 2.46 |
| 7 hashes and grouping | 4.13 | 3.68 |
| 8 overlaps (shared) | 1.89 | 1.17 |
| 9 clear entries (shared) | 3.91 | 2.65 |
| 10 walk (shared) | 6.81 | 4.22 |
| 0, 5, 11 the rest | 5.80 | 4.15 |
| total | 38.65 | 46.71 |

The test runs each function's vector version first. The scalar one finds the function in the caches, and the shared phases took 1.4 to 1.6 times longer in the vector column. The vector gathers' address phase took 12.08 M (12.10 M in the repeat) against the scalar chains' 3.42 M in the same position, 3.5 times longer, so the chains are scalar.

## Differential campaigns (`differential/`)

#142's campaigns, Csmith `0cdc710315cfee9035e22ef4363ca479270d1934` and YARPGen `1adb290f453505838f3aa33dc571f292b0c1810f`, seeds 5000 to 5039 of each (80 programs), Tier 0 and `--tier1` (`scripts/local/differential-run.sh`; ledgers by `ledger.py`). At `5a4e56b`, where the pass was still off by default, `memory` (`--tier1-passes=+memory`) and `all` (`+all`) both passed 66 of 80. The 14 failures are the references' own, the same seeds as #139's campaigns: Csmith 5002, 5006, 5016, 5035, 5036 and 5039 time out under clang -O0, and clang -O0 fails to compile YARPGen 5001, 5002, 5006, 5008, 5010, 5013, 5029 and 5035. On the measured head `566770b` (`compiler.sha256`), `final-default` (`--tier1`, the pass on by default) and `final-all` (`+all`) passed 66 of 80, with the same cases, statuses and first failures as `all`'s ledger. One step differs: YARPGen 5029's Tier 0 executable was killed by signal 9 in both, which the earlier campaigns ran. Its Tier 1 run passed, and the case's first failure is clang -O0's compile, as before. That executable needs 7.1 GB, and two campaigns and two callgrind runs then shared the 15 GB machine. Rerun alone, it exits 0 with Tier 1's output (`final-default/yarpgen-5029-rerun.txt`). `final-scalar` (`--tier1 --scalar`, every twin scalar, the pass's among them) and `final-nomemory` (`--tier1-passes=-memory`) passed 66 of 80 as well, with the same cases, statuses and first failures. YARPGen 5029's Tier 0 run passed in `final-scalar` and was killed again in `final-nomemory`, which ran beside it.

## Tests (buster)

On the final code: `test-ir-optimize` (the six `tests/ir/optimize/memory-*.ir` pairs and 400 generated programs, both twins exact, with an independent interpreter), `test-checker --seed 133`, `test-ir-lowering`, `test-ir`, `test-interpreter`, `test-ir-interpreter`, `test-tier0 --cross-check`, `test-snapshot`, `test-check-lanes`, `test-check-units`, `test-emission-metadata`, `test-ir-sroa`, `test-ir-inline`, `test-ssa` and `test-check-debug` passed. `test-checker-driver --executable ./build/compiler`'s eight parts passed (196,099 checks, 0 failures).
