# `closures.lua` after Tier 1's call-save rows: op-cache placement, not the frames (buster#1435)

The measurements behind buster14a/buster#1435. They were taken on benchpress, the Ryzen 7 9700X, on 2026-11-05.
- **Lock:** every build, link, perf record (with its parsing) and timed run took its own hold of
  `~/buster-fast-bench/exclusive.sh` (owner `claude-1435`).
- **Pinning:** every timed or sampled run was pinned to CPU 2 by `taskset -c 2`.
- **IBS parsing:** the first IBS set (k = 0, 40 runs per build) parsed each record outside its hold; every later set
  (`ibs-rec.sh` as here, `fetch-rec.sh`) inside it.
- **Builds:** `BUSTER_HOST_ARCH=znver5`. The working directory is `~/buster-fast-bench/1435-claude/`.
- **Machine and tools:** Ryzen 7 9700X, Linux 6.18.50-2-lts, perf 7.2.9, glibc 2.44; executables linked by `cc` (GCC
  16.2.1, GNU ld 2.47). Lua 5.4.8's sources are `~/buster-fast-bench/claude-141-reciprocal/inputs/lua-5.4.8`
  (`lvm.c` `88b10a2f…`), compiled `--tier1 -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX
  -c`; `closures.lua` is the earlier record's (`b111c0dd…`).
- **Limitations:** one script; ASLR on except in the env sweep and the IBS op sets; IBS's kernel throttling leaves
  about 5,000 samples per run, so the IBS figures sum 30 to 40 runs per build.

**The question.** After buster#1433 (call-save rows only for the registers a call saves), `closures.lua` by Tier 1's
Lua ran +3.9% slower, slower at 7 of 8 code shifts, while store-to-load interlock failures
(`ls_bad_status2.stli_other`) rose (`../tier1-call-save-rows-177-2026-11-05/`). The hypotheses: (a) a slot at
`[rsp+0]`, next to the return address a call pushes, defeats forwarding or memory renaming; (b) the shallower stack
4 KiB-aliases heap stores; (c) something else.

**The answer: (c), code placement in the op cache.** In #1433's executable five hot functions' first lines land on the
same 4 KiB offsets (`0xc20`–`0xcc0`). Their 64-byte lines have the same address bits 11:6, and their op-cache misses
double the executable's: consistent with an op cache indexed by those bits, whose two sets thrash. Neither the
`[rsp+0]` slots nor the interlock failures cost time.

## Builds

**Revisions** of buster14a/buster:
- main: the coordinator's pre-#1433 objects (`../tier1-call-save-rows-177-2026-11-05/`, `out4/obj-main`, main
  `74720ed7`), copied unchanged into `base/`.
- pad0 (#1433): `76ad7ebe`, #1433's merge, built here with `pad.patch` and `disp8.patch` and neither variable set.
  Its 33 Lua objects are the coordinator's head objects (`f9779980`) byte for byte, and they stay so after
  `disp8.patch` (`build-exp.log`, `build-w.log`).
- **pad8, pad16, pad32:** `BUSTER_EXPERIMENT_FRAME_PAD=8/16/32` (`pad.patch`). Every frame of a function that calls
  starts its objects that many bytes above the outgoing area: no object sits at `[rsp+0]`. Frames keep #1433's rows;
  pad8 can cost nothing (`setnodevector` stays `sub $0x18`, its slots move from 0 and 8 to 8 and 16).
- **pad0w:** `BUSTER_EXPERIMENT_RSP_DISP8=1` (`disp8.patch`, both encoder paths). pad0's frames exactly, `[rsp+0]` slots
  included, but an rsp base's zero displacement is encoded as an 8-bit zero, so every such access is one byte longer,
  as in pad8. pad0w's code is laid out as pad8's to within 0x20 bytes at the functions checked: `setnodevector` at
  `0x1e740` against `0x1e760`, `luaV_execute` at `0x23160` against `0x23180`; pad0 has them at `0x1e0d0` and
  `0x229b0`.

Neither patch is for merging. The shift-0 executables of pad0, pad8, pad16, pad32 and pad0w print clang -O0's
`closures.lua` output (`pad/outputs*.txt`, which also hold the lock's waiting lines; the reference is
`../tier1-call-save-rows-177-2026-11-05/`'s `closures-clang0.out`). Executables are
each build's objects linked by `cc` after a padding object of N bytes (shift N, as in the earlier record), or in another
order of the 33 objects (`orders.sh`).

## 1. The interlock failures don't cost time (env sweep, `envsweep.sh`)

ASLR off (`setarch -R`), the environment one variable of 16 k bytes for k = 0 to 255, which moves the whole stack down
over a full 4 KiB in 16-byte steps; main and pad0 at shift 0, alternating, one run each (`envsweep/runs.txt`).

| | main | pad0 (#1433) |
| --- | ---: | ---: |
| cycles, median | 377.0M | 387.8M |
| cycles, range | 371.0M–393.5M | 378.0M–402.2M |
| STLI, median | 1.63M | 2.05M |
| STLI, range | 0.97M–8.76M | 1.46M–8.25M |
| correlation of cycles with STLI | 0.01 | 0.12 |
| least-squares cycles per STLI event | 0.0 | 0.5 |

- pad0 is slower at **246 of the 256** stack positions, by a median **+2.87%**. Where the stack sits doesn't matter.
- STLI depends on the stack's offset within 4 KiB: from about 1.5M it rises to 3M–8.8M at 53 of pad0's positions and
  39 of main's, in runs of up to 8 consecutive positions (pad0: k = 57–61, 66–69, 82–87, 89–95, 122–129, 134–140, …;
  main: 0–1, 40–43, 54–56, 59–62, 109–112, …). That is a 4 KiB alias between stack accesses and other addresses, and the
  two builds' runs differ because their frames do. With ASLR on, each run draws a sub-page stack offset, which is why
  the earlier STLI counts scattered 1M–5M per run.
- **IBS at a high- and a low-STLI position** of the same build (`ibs-rec.sh`, 30 runs each, about 145,000 op samples):
  the mean tag-to-completion latency of sampled loads is 16.20 against 16.18 cycles for main (k = 0, 5.1M STLI, against
  k = 2, 1.4M) and 15.85 against 16.10 for pad0 (k = 68, 6.9M, against k = 64, 1.7M)
  (`summary/load-latency-by-stack-position.txt`). No symbolized load instruction's slow samples (L1 hits of at least
  12 cycles) grow by more than 44, `index2value+0x8`'s 113 → 157 in main (`summary/stli-attribution.txt`). Zen 5's IBS
  has no store-forwarding status (`IbsOpData3` bits 9–12, family 10h's `DcStToLdFwd` and `DcStToLdCan`, are
  reserved), so a failure can't be tied to one load exactly; what the samples rule out is a costly site.
- At the default stack (k = 0, 40 runs each, `summary/ibs-k0-main-head.txt`), pad0 has fewer slow L1-hit loads than
  main (8,153 against 8,524 sampled loads of at least 20 cycles). In both builds the slowest loads are the hash and
  string loads of `luaH_getshortstr` and the VM's, not reloads around calls.

## 2. The `[rsp+0]` slots don't matter; the code bytes do (`padtime.sh`)

Cycles, medians over 11 rounds, the builds rotating by round, each run one hold.

**Three shifts, the frame pads** (`padtime/runs.txt`):

| Shift | main | pad0 (#1433) | pad8 | pad16 | pad32 |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 0 | 375.8M | 395.4M | 376.5M | 375.8M | 367.7M |
| 32 | 381.8M | 385.2M | 372.4M | 366.5M | 381.1M |
| 96 | 390.5M | 383.9M | 373.1M | 370.3M | 374.4M |

**Eight shifts, pad0w** (`padtime2/runs.txt`):

| Shift | 0 | 16 | 32 | 48 | 64 | 80 | 96 | 112 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| main | 375.7M | 386.7M | 383.9M | 378.8M | 385.3M | 385.4M | 391.1M | 383.4M |
| pad0 / main | +4.20% | −0.02% | +0.17% | +3.06% | +0.62% | +0.04% | −1.13% | +3.54% |
| pad8 / main | +0.67% | −3.76% | −2.84% | +0.62% | −0.07% | −1.94% | −4.65% | −1.33% |
| pad0w / main | −1.09% | −2.23% | −2.27% | −1.97% | −3.22% | +0.77% | −3.14% | −2.50% |

- Against pad0, over the eight shifts: pad8 **−3.19%** median, pad0w **−3.12%**. pad0w keeps every `[rsp+0]` slot and
  frame of pad0 and is as fast as pad8, which has none. Hypothesis (a) is out: the pads help only by moving code.
- pad0w is faster than pad0 at 7 of the 8 shifts. Every build's instruction medians are 1,861M–1,868M.

## 3. The op cache: two index values thrash in #1433's layout

**Counters** (`fecount.sh`, `fecount/runs.txt`): six builds × shifts 0, 32, 96 × 5 rounds, two groups of six events.
Over those 90 runs, cycles follow the front end:

| Event | Correlation with cycles | Cycles per event |
| --- | ---: | ---: |
| `de_no_dispatch_per_slot.no_ops_from_frontend` | 0.95 | 0.07 |
| `de_src_op_disp.x86_decoder` (ops not from the op cache) | 0.89 | 0.35 |
| `op_cache_hit_miss.op_cache_miss` | 0.77 | 1.07 |
| `ic_tag_hit_miss.instruction_cache_miss` | 0.25 | 0.54 |
| `ex_ret_brn_misp` | −0.24 | |
| `de_no_dispatch_per_slot.backend_stalls` | −0.45 | |

At shift 0, decoder ops are 61.2M for pad0, 35.9M for main, 28.7M for pad0w and 15.2M for pad32, with cycles 391.6M,
377.5M, 372.6M and 368.6M. Branch mispredictions are 1.21M–1.29M in every build.

**IBS fetch** (`fetch-rec.sh`, shift 0, 30 runs per build, about 145,000 fetch samples each,
`summary/fetch-op-cache-by-function.txt` and `summary/fetch-op-cache-by-line.txt`):
- pad0 has **10,025** op-cache-miss samples; pad0w 5,274, pad8 5,464 and main 5,492.
- **5,644 of pad0's** are fetches whose 64-byte line has address bits 11:6 equal to 49 or 50 (2,757 and 2,887); every
  other index value has at most 233. The same two values have 196 in pad0w, 173 in pad8 and 231 in main.
- The lines are the first ones of the hot functions, which in pad0 share their offset within 4 KiB
  (`summary/hot-function-addresses.txt`):

| Function | pad0 address | Misses: pad0 | pad0w | main |
| --- | --- | ---: | ---: | ---: |
| `luaH_getshortstr` | `0x1ec30` | 1,311 | 43 | 12 |
| `.Lbuster_label_40144` | | 1,088 | 68 | 74 |
| `lua_type` | `0x5c40` | 1,004 | 31 | 39 |
| `lua_getmetatable` | `0x6c40` | 856 | 16 | 35 |
| `.Lbuster_label_68575` | | 513 | 61 | 125 |
| `luaC_checkfinalizer` | `0x12c20` | 444 | 17 | 11 |
| `precallC` (`+0xd0`, line `0xec80`) | `0xebb0` | 353 | 26 | 17 |

  In main, pad0w and pad8 `luaH_getshortstr` starts at `0x…2a0`–`0x…2d0` and `luaC_checkfinalizer` at
  `0x…f30`–`0x…f60`. #1433's smaller frames shortened the code before them by 0x670 and 0x340 bytes, which happened to
  bring them onto `lapi.o`'s `lua_type` and `lua_getmetatable`, at `0x…c40`.
- **Why 7 of 8 shifts:** a shift moves every function by the same amount, so functions that collide modulo 4 KiB keep
  colliding; only the line boundaries move. The earlier shift experiment therefore sampled one relative layout eight
  times.

## 4. Placement over link orders (`orders.sh`)

Lua's 33 objects linked in other orders, the same order for every build (`shuf` seeded by the order's number; order 0
is the usual one), no shift. Cycles are medians per order of the rounds, the builds rotating by round.

**8 orders, 7 rounds** (`orders/runs.txt`): pad0 / main per order is +4.0%, −0.7%, +8.9%, +12.2%, −8.6%, +0.2%, −4.2%
and +6.0%. Each build has its own bad orders: pad0 423M at order 2, pad8 431M at order 6 (+11.7% over main), main 406M
at order 4.

**33 orders, 3 rounds** (`orders2/runs.txt`, `analysis/orders-analyze.py`):

| | main | pad0 (#1433) | pad0w |
| --- | ---: | ---: | ---: |
| median over orders | 384.3M | 382.4M | 379.3M |
| range over orders | 367.7M–416.6M | 371.2M–414.0M | 367.5M–406.4M |
| sd over orders | 11.6M | 11.3M | 9.8M |
| the usual order | 375.7M | 389.2M | 369.6M |

- **pad0 / main:** mean of the per-order log ratios **+0.02%** (95% interval −1.44% to +1.49%), median +0.05%, slower
  at 17 of 33 orders, from −9.8% to +9.6%.
- **pad0w / main:** −1.01% (−2.17% to +0.14%).
- Layout spreads a build's cycles by about 3% (sd); runs of one layout by 0.70% (median sd within an order).
- In the usual order pad0 is +3.6% over main, as in the earlier record: one draw from that spread.

## Conclusion

- **The cause** of `closures.lua`'s slowdown after #1433 is code placement: in #1433's layout the first lines of
  `luaH_getshortstr`, `lua_type`, `lua_getmetatable`, `luaC_checkfinalizer` and `precallC`'s hot block share op-cache
  index values 49 and 50 and evict one another. Fetches from those lines miss the op cache, ops come from the decoder,
  and cycles follow.
- **Not the frames:** with every `[rsp+0]` slot kept, a one-byte change to their encodings removes the slowdown
  (pad0w). **Not the interlock failures:** they track the stack's offset within 4 KiB and cost at most 0.5 cycles each.
- **Over placements #1433 costs `closures.lua` nothing:** +0.02% over 33 link orders (95% interval −1.44% to +1.49%).
- **No frame-layout rule** fixes it: padding frames only moves code, and over link orders each layout has its own
  collisions (pad8's worst is +11.7% over main).
- **Method:** a pad before all of a program's code moves every function together, so collisions modulo 4 KiB survive
  every shift; spread placements over link orders, or shift a unit in the middle, as `./build.sh shifts` does.

## Files

**Patches** (not for merging): `pad.patch` (`BUSTER_EXPERIMENT_FRAME_PAD`, `tier1_frame.c`), `disp8.patch`
(`BUSTER_EXPERIMENT_RSP_DISP8`, `x86_64_encoder.c`'s scalar and vector paths).

**Scripts:** `build-exp.sh`, `build-w.sh` (builds); `envsweep.sh`; `padtime.sh`; `orders.sh`; `fecount.sh`;
`ibs-rec.sh`, `ibs-parse.sh`, `ibs-sum.sh`, `stli-attr.sh` (IBS ops); `fetch-rec.sh`, `fetch-sum.sh`, `oc-sets.sh` (IBS
fetch); `driver1.sh`–`driver3.sh` (the order they ran in); `summaries.sh`; `analysis/*.py` (the tables' statistics, run
on the copied `runs.txt` files).

**Data:** `envsweep/`, `padtime/`, `padtime2/`, `orders/`, `orders2/` (with `orders.txt`, each order's objects),
`fecount/` (`runs.txt` as written), `build-exp.log`, `build-w.log`, `pad/outputs*.txt` and `summary/`. The raw IBS
samples (`ibs/*.tsv`, `fetch/*.tsv`, 6–9 MB each) and the executables stay on benchpress in
`~/buster-fast-bench/1435-claude/`, with their SHA-256s in `summary/raw.sha256`.
