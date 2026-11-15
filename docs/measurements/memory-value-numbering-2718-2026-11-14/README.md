# #2718's value numbering with memory: policy, phases, loads removed, twins and campaigns (2026-11-14)

This is the evidence for [buster#2718](https://github.com/buster14a/buster/issues/2718) (Tier 1: value numbering with memory, repeated loads and store-to-load forwarding) and the pull request from `claude/loving-goodall-lj1n26`. By Claude, in David's directed session ([the session](https://claude.ai/code/session_01NNmNQub8akmWiSMaWbaw8L)), from the claim of 14 November ([comment 6885272067](https://github.com/buster14a/buster/issues/2718#issuecomment-6885272067)).

The pull request adds `ir_optimize_memory.c`, the optimizer's `BUSTER_IR_OPTIMIZE_MEMORY` pass. It runs after SCCP and the identities and before dead-code removal, and forwards a load's value from an earlier access of the same bytes along the dominator tree. `--tier1` runs it by default, and `--tier1-passes=-memory` turns it off. It also marks volatile and `_Atomic` locals' slots volatile (`BUSTER_TYPED_LOCAL_VOLATILE`, then `BUSTER_IR_SLOT_VOLATILE`), which the pass's first version forwarded through. The design and its rules are in buster's `docs/ir-memory-value-numbering.md`.

**Status:** the final head's 9700X queue (`scripts/9700x/final.sh`: identity, compile time per pass and per compile, run time, loads dispatched) and the final head's differential campaigns are still running. Their results will go in `9700x/final/` and `differential/final-*`, and this file will be updated with them.

## Revisions

| Role | Commit | Tree | What |
| --- | --- | --- | --- |
| main | `750f6a0405a8bb855f4745a4f10e90682d155b17` | `c2f75d03d5e206f75d4c26c41269bfd1ef83c50c` | the branch's base after its last merge |
| prototype | `42a7c1e2c3d167bc53a24ce0dad944251a8a1ab7` | | environment switches choose the rules: `local/survey/`, `9700x/prototype/` |
| phases | `5a4e56beb74987e025dc15a39143ad54c5960cae` | `44a36f65708d1b50a06ab5223e8abf18b4d609f9` | `scripts/9700x/phases.patch` over it: `9700x/phases/`; the first differential campaigns, `differential/memory` and `differential/all` |
| before the volatile fix | `894d9716c96c8efd2500b3f188c907755cedbe2f` | | `local/894d971/` |
| measured head | `566770be50aa74295a60687c381eb9876597a568` | `a7f9a21e77efe3624fec7c70adecb7baafbd10e1` | the 9700X's final queue and the final campaigns |
| final code | `a694d362b29bad11401698fc899d5d0f0745e78e` | `71990abefccea4697e0caae97850297af5c0c710` | the measured head with a comment and a usage line changed: `local/final/` |

## Which rules pay (`9700x/prototype/`)

The prototype's three policies by `measure-tier1-programs --runs 11 --variant` on the 9700X (`scripts/9700x/prototype-*.sh`), each beside `--tier1` without the pass, Tier 0, and clang -O0 and -O2. Ratios are the variant's over `--tier1`'s:

| Policy (file) | speedtest1 cycles | speedtest1 instructions | Lua cycles | Lua instructions |
| --- | ---: | ---: | ---: | ---: |
| Every rule (`full.txt`, shipped) | 0.9968 | 1.0108 | 0.9745 | 1.0168 |
| No forwarding from a load a user could fold (`fold.txt`) | 0.9957 | 0.9998 | 0.9961 | 1.0009 |
| One block, one key's own stores (`block.txt`) | 1.0104 | 0.9968 | 0.9918 | 1.0006 |

`--tier1`'s own row across the three runs: speedtest1 736.6 to 742.6 M user cycles (0.8%), Lua 985.1 to 994.8 M (1.0%). speedtest1's differences are within that, and every rule's Lua gain is not. Every rule ships.

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

#142's campaigns, Csmith `0cdc710315cfee9035e22ef4363ca479270d1934` and YARPGen `1adb290f453505838f3aa33dc571f292b0c1810f`, seeds 5000 to 5039 of each (80 programs), Tier 0 and `--tier1` (`scripts/local/differential-run.sh`; ledgers by `ledger.py`). At `5a4e56b`, where the pass was still off by default, `memory` (`--tier1-passes=+memory`) and `all` (`+all`) both passed 66 of 80. The 14 failures are the references' own, the same seeds as #139's campaigns: Csmith 5002, 5006, 5016, 5035, 5036 and 5039 time out under clang -O0, and clang -O0 fails to compile YARPGen 5001, 5002, 5006, 5008, 5010, 5013, 5029 and 5035. The final head's campaigns (default, `+all`, `--scalar` and `-memory`) are running.

## Tests (buster)

On the final code: `test-ir-optimize` (the six `tests/ir/optimize/memory-*.ir` pairs and 400 generated programs, both twins exact, with an independent interpreter), `test-checker --seed 133`, `test-ir-lowering`, `test-ir`, `test-interpreter`, `test-ir-interpreter`, `test-tier0 --cross-check`, `test-snapshot`, `test-check-lanes`, `test-check-units`, `test-emission-metadata`, `test-ir-sroa`, `test-ir-inline`, `test-ssa` and `test-check-debug` passed. `test-checker-driver`'s eight parts are running.
