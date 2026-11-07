# Tier 1's remaining work: items 5 and 6 (buster#1450, buster#1559)

The 9700X's record for buster#1450's two measurement items, taken for buster#1559:
- item 5, where #1413's +0.44% Tier 1 compile instructions go;
- item 6, what `-fstack-clash-protection` costs Tier 0's `closures.lua`.

- **Host:** benchpress (AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1).
  - Every build and every run is one hold of `~/buster-fast-bench/exclusive.sh`, and every timed or counted run is pinned to CPU 2.
  - The compilers are built `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0`, the vector path.
- **Working directory there:** `~/buster-fast-bench/1450-claude`.

## Item 5: #1413's instructions, stage by stage

**Builds** (`out/item5/builds.txt`):
- main `9f416b206fa21cd16d8a7719992bcd8a74c47c26` (`a`) against #1413's head `db03f52acf5ac3c31de3307152561db95d6e4b1f` (`b`);
- the same commits again as `a2` and `b2`, for round 2.

Each is patched only for measurement, never committed:
- `item5/patch_stages.py` reads a per-thread `perf_event_open` user-mode instruction counter at each boundary of `check_tier1_compile`.
- `item5/patch_verify.py` also gives `ir_verify_path`, the noinline entry every verification goes through, a bucket of its own, nested in whichever stage calls it.

The reads add the same few user instructions to both builds. Each patched pair compiles byte-identical objects (`out/item5/objects.txt`, `verify-objects.txt`).

**Input:** `sqlite3.c`, SHA-256 `b1dd5d74…` (`out/item5/input.txt`), the file #1413's comment measured. The command is `compiler --tier1 -c sqlite3.c`.

**Scripts:**
- `item5/setup.sh` and `item5/run.sh`: round 1, 5 alternating rounds, with `perf stat -e instructions:u` totals in `out/item5/perf-*.txt`;
- `item5/verify.sh`: round 2, 3 rounds;
- `item5/symbols.sh`: a per-symbol profile, below.

### Round 1 (`out/item5/stages.tsv`)

Medians of 5 rounds. Each stage's spread across rounds is at most 330 instructions, and each total's at most 559.

| Stage | 9f416b20 | db03f52a | Δ |
| --- | ---: | ---: | ---: |
| lower | 265,099,086 | 269,577,616 | +4,478,530 (+1.69%) |
| inline | 10,333,411 | 10,405,606 | +72,195 |
| promote | 878,915,320 | 887,379,130 | +8,463,810 (+0.96%) |
| wide and truth | 945,447 | 945,447 | 0 |
| optimize | 930,327,863 | 941,867,136 | +11,539,273 (+1.24%) |
| analysis | 281,232 | 281,232 | 0 |
| select | 246,942,948 | 246,207,258 | −735,690 (−0.30%) |
| emit | 2,348,290,729 | 2,353,674,477 | +5,383,748 (+0.23%) |
| publish | 2,498,662 | 2,498,662 | 0 |
| whole process | 6,668,181,371 | 6,697,398,071 | +29,216,700 (+0.438%) |

The stages add up to the whole delta. Outside Tier 1's pipeline (front end, Tier 0, encoding, writing) nothing changes.

### Round 2, with the IR verifier apart (`out/item5/verify.tsv`)

Medians of 3 rounds. Stages exclude the verification they call.

| Bucket | 9f416b20 | db03f52a | Δ |
| --- | ---: | ---: | ---: |
| IR verifier (`ir_verify_path`, every caller) | 891,273,437 | 910,943,986 | **+19,670,549 (+2.21%)** |
| optimize | 677,664,509 | 683,813,997 | +6,149,488 (+0.91%) |
| emit | 2,238,619,533 | 2,241,311,412 | +2,691,879 (+0.12%) |
| lower | 135,240,310 | 136,644,502 | +1,404,192 (+1.04%) |
| promote | 484,128,887 | 484,128,883 | −4 |
| select | 246,945,546 | 246,209,859 | −735,687 (−0.30%) |
| others (inline, wide and truth, analysis, publish) | 11,960,497 | 11,981,968 | +21,471 |
| Tier 1 total | 4,685,832,719 | 4,715,034,607 | +29,201,888 |

Two thirds of the cost is the IR verifier: #1413's lane metadata rules, run on a file with no vectors. Promotion's whole +8.46M in round 1 was verification. The rest is the optimizer's own SCCP and dead code (+6.1M), Tier 1's emission (+2.7M) and the typed lowering (+1.4M). Selection got cheaper.

### What didn't work

`item5/symbols.sh` recorded an `instructions:u` profile of each build at a fixed period of 20,000 (`out/item5/symbols-*.txt`). It is not usable:
- The kernel throttled the sampling to about 35,000 samples per run where the period asks for 335,000.
- The profiles move front-end symbols by millions of instructions although the exact counts outside Tier 1 are equal: the inlining and skid confound #1413's own attempt reported.

Exact counts per stage are the attribution.

### Decision

Accepted. Cycles were flat in #1413's own 11 rounds: +0.08% paired median, range −0.18% to +0.96%. The cost is the verifier checking lane metadata it must check.

## Item 6: `-fstack-clash-protection` and Tier 0's `closures.lua`

#177's record (`stack-clash-probes-177-2026-11-05`) timed Tier 0's `closures.lua` +4.59% slower with the option, in one
layout per build. Its Lua executables were linked by the buster driver from head `903c464e`.

### Where Tier 0's Lua touches the stack

Lua 5.4.8 is built by the item's compiler (`out/item6/fix/`), from the branch before (`f619a215`) and after (`fcbc25d1`) its change to which frames under a page touch rsp.
- The executables are byte-identical before and after, at Tier 0 and at `--tier1` (`executables-and-touches.txt`), so that change does not touch Lua.
- With the option, Tier 0's executable has four `orb $0x0,(%rsp)` probes, two in each of two functions: `luaV_execute`, whose Tier 0 frame is 5,064 bytes, and `luaL_loadfilex`.
- Every call of `luaV_execute` runs the one-page probe loop and the remainder's touch.
- Tier 0 keeps no frame pointer by default, so no other function touches.

### #177's own builds (`item6/profile.sh`, `out/item6/profile-*`)

`closures.lua`, 5 alternating rounds, pinned to CPU 2:

| Build | Cycles, median (range) | Instructions, median |
| --- | ---: | ---: |
| Tier 0 | 546.6M (527.9M to 560.5M) | 2,805.8M |
| Tier 0, the option | 557.7M (552.9M to 562.1M) | 2,807.1M |
| `--tier1` | 390.9M | 1,804.7M |
| `--tier1`, the option | 393.0M | 1,813.0M |

Instructions vary by ±1% from run to run: Lua 5.4 seeds its string hashes from addresses and time.

One cycles profile of each Tier 0 build (period 200,000, `profile-t0-full.txt` and `profile-t0p-full.txt`) does not place the difference at the probe.
- `luaV_execute`'s share falls from 26.6% to 23.5% with the option.
- Other functions' shares rise, `luaD_precall`'s from 3.7% to 5.5%: a pattern of placement, not of the probe's work.

### Over relative code layouts (`item6/layouts.sh`, `out/item6/layouts/`)

This is `docs/commands/profiling.md`'s protocol.
- **Objects:** Lua's 33 units are compiled once per build by `fcbc25d1`: Tier 0, Tier 0 with the option, `--tier1 -fno-asynchronous-unwind-tables`, and the same with the option.
- **Layouts:** each build's fixed objects are linked by clang in the same 16 recorded orders (`orders.txt`). Order 0 is the normal order; orders 1 to 15 were shuffled with seed 1450 before any timing.
- **Checks:** all 64 executables print clang -O0's `closures.lua` output (`compare.txt`). Object and executable hashes are in `objects.txt` and `executables.txt`.
- **Timing:** one `time-runs`, 9 runs after a warm-up per executable, placements rotated, pinned to CPU 2 (`time-runs.txt`).

Paired ratios by layout, with the option against without it, and a 95% interval over the 16 layouts (t, 15 degrees of freedom):

| Tier | Wall time | 95% interval | Per layout | Layouts slower |
| --- | ---: | ---: | ---: | ---: |
| 0 | −1.02% | −2.37% to +0.35% | −6.2% to +3.4% | 6 of 16 |
| 1 | −1.37% | −3.75% to +1.07% | −15.0% to +5.7% | 6 of 16 |

User cycles agree: Tier 0 −1.00% (−2.34% to +0.37%), Tier 1 −1.48% (−3.97% to +1.07%).

Layout alone spreads Tier 0's `closures.lua` over 14% across the 16 orders. In the normal order the option is 6.2% *faster* at Tier 0, the opposite sign of #177's +4.59%. Instructions per layout rise by a median of +0.075% at Tier 0 (range −0.40% to +0.55%, Lua's seeding) and not at all at Tier 1.

### Decision

Measured as placement, the issue's second accepted outcome. The option's work at Tier 0 is two touches per `luaV_execute` call. Its effect on `closures.lua` over 16 layouts is indistinguishable from zero.

A single layout's +4.59% was #177's measurement, and the issue's item 9 describes the same effect at Tier 1.

`item6/fix.sh` was stopped after its builds, its output check (30 of 30 scripts as clang -O0's) and 19 of its 30 counter runs (`out/item6/fix/`). The layouts above answer what it was for.

## Limitations

- Instruction counts are user-mode only.
- The per-stage patches add a `read` system call at each boundary. Its user instructions are the same in both builds.
- Round 2 nests verification in its callers, so its stage figures exclude verification while round 1's include it.
