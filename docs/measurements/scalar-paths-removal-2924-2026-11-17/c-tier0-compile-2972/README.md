# Tier 0 compile's fixed cost a function (#2972)

The vector compile (`tier0_compile`) lost to its twin (`tier0_compile_scalar`) on the smallest functions in the C8 gate
([`../c-tier0-gate/`](../c-tier0-gate/)). Measured each area alone, it was 0.874 at 0 and 1 entries and 1.008 at 2 and 3,
and warm on [`tiny.c`](../c-tier0-gate/tiny.c) it took 1.77 times the twin's cycles. This record locates the cost by
stage, cuts what is waste, gates again, and says what is left. All timings are from the 9700X, under the lock, on CPU 2.
The base is #2975's head `e91cd2582`, whose compile code is main's.

## Where the time goes ([`stages/`](stages/))

[`stages/finer.patch`](stages/finer.patch) and [`stages/finer-nofix.patch`](stages/finer-nofix.patch) are for the
experiment only. They read the TSC between Tier 0's compile stages and add each stage's ticks by path and by the
function's entries; `BUSTER_TIER0_STAGES` names the file they're printed to at exit. [`stages/run2.sh`](stages/run2.sh)
runs `benchmark-backend-source --only vector` and `--only scalar` on `tiny.c` (1,000 functions of 1 entry and 1,000 of
6), three rounds. [`stages/stages.py`](stages/stages.py) takes the median of the rounds, each path from its own run
([`stages/logs2/stages.txt`](stages/logs2/stages.txt)). Each mark costs about 26 ticks on both paths, so the last four
stages are only the marks' floor.

The vector path's ticks a call above the twin's:

| Stage | 1 entry, before | 1 entry, after | 6 entries, before | 6 entries, after |
| --- | ---: | ---: | ---: | ---: |
| setup (the columns' pushes) | +123 | +17 | +124 | +12 |
| front (labels, values, fuse, depths) | +186 | +120 | +94 | +27 |
| select | +57 | +58 | +13 | +8 |
| references, homes, layout | +45 | +23 | +122 | +102 |
| measure, output | +37 | +34 | +17 | +22 |
| emit | +76 | +70 | +43 | +31 |
| forms (`x86_choose_forms`) | -22 | -22 | +58 | +61 |
| **total** | **+494** | **+297** | **+472** | **+258** |

"Before" is `e91cd2582`, and "after" has the first two fixes below.

## The fixes ([`gate/fixes.patch`](gate/fixes.patch), no twin)

1. **One push and one clear for the fourteen bit columns:** they had fourteen pushes and fourteen `memset` calls.
2. **The values pass (P0) stops at the function's entries.** It walked every lane of its blocks eight at a time, seven
   empty steps for a function of a few entries. Lanes past the entries stay zero from the clear, and `sib_log2` is read
   only under the entries' mask.
3. **The depths' prefix scan (P4) takes as many log steps as the block has entries.** The block's sum (lane 63) is read
   only for a block followed by another, which is full.
4. **The homes' free-register lists and ranks are skipped where no local can take a register.**

`test-tier0` (which still compares the two paths) passes on the fixes' build: 18,673,890 checks, 0 failed.
`test-tier0-inline` passes too, with the same digest.

## The gate again ([`gate/`](gate/))

[`gate/gate.sh`](gate/gate.sh) runs the C8 gate's compile knob ([`gate/knob.patch`](gate/knob.patch), experiment only)
on `e91cd2582` with the fixes. It takes compile's ticks with the twin (`0x1`) and with the vector path (`0`), five rounds
in turn. The inputs are `-c --verify` of sqlite3.c, Lua, musl's units and buster's `main.c`
([`gate/objects.sh`](gate/objects.sh)), plus `tiny.c` compiled the same way. [`gate/gate.py`](gate/gate.py) pairs the
k-th call across runs ([`gate/logs/gate.txt`](gate/logs/gate.txt)). Twin's ticks over the vector path's:

| Entries | Calls | Before (the C8 gate, alone) | After | Rounds after |
| --- | ---: | ---: | ---: | --- |
| 0 to 1 | 45 | 0.874 | **0.955** | 0.949 to 0.959 |
| 2 to 3 | 188 | 1.008 | 1.074 | 1.070 to 1.111 |
| 4 to 7 | 818 | 1.116 | 1.186 | 1.172 to 1.380 |
| 8 to 15 | 1,167 | 1.347 | 1.405 | 1.387 to 1.419 |
| 16 to 63 | 2,565 | 1.897 | 1.962 | 1.916 to 1.957 |
| 64 and up | 3,177 | 2.38 to 2.83 | 2.38 to 2.84 | |
| all of them | 7,960 | 2.238 | 2.281 | |
| `tiny.c`, 1 entry | 1,000 | | **0.743** | 0.727 to 0.762 |
| `tiny.c`, 6 entries | 1,000 | | 1.022 | 0.960 to 1.034 |

- **The corpora:** the vector path now loses only on the 45 calls of 0 and 1 entries, by 4.5% (3,438 ticks against
  3,282). It wins from 2 entries on.
- **`tiny.c`:** its 1-entry functions lose by 26% (1,355 against 1,007), and its 6-entry ones are even.
- **Warm** ([`gate/logs/`](gate/logs/)`bench-*.log`): the vector path takes 339 to 342 cycles a typed entry (1,256
  instructions), against 238 to 253 for the twin (1,159). Before the fixes it was 462.7 and 1,692.

## What is left

**Counters** ([`gate/pstat/`](gate/pstat/)): on the warm `tiny.c` run, the vector process retires *fewer* instructions
than the twin's (218 M against 230 M) yet takes 15 M more cycles: IPC 3.7 against 4.8. Its store-to-load interlocks
(`ls_bad_status2.stli_other`) are the twin's (1.34 M against 1.41 M).

**The profile** ([`gate/pstat/vector-annotate.txt`](gate/pstat/vector-annotate.txt)) has its samples on loads that
read back what the pass before just stored:
- `absorbed` at P3b's start, after P3a's store: 21% of `tier0_compile_entries`' samples;
- `variants` and `key_classes` at P2's start, after P1's stores: 15%;
- the `Tier0Code` copies: 26%. The twin makes these too.

**Store forwarding of 512-bit stores on Zen 5** ([`stlf/stlf.c`](stlf/stlf.c), [`stlf/result.txt`](stlf/result.txt)): a
chain of a store, its load and an add, in TSC ticks an iteration (one add in registers: 2.05):

| Store, then load of the same address | Ticks |
| --- | ---: |
| 64-byte, then 64-byte | 8.89 |
| 64-byte, then masked 64-byte | 9.57 |
| masked 64-byte, then 64-byte | 11.63 |
| masked 64-byte, then masked 64-byte | 12.30 |
| 64-byte, then 16-byte | 11.63 |
| masked 64-byte, then masked 16-byte | 15.73 |
| 8-byte, then 8-byte | 7.52 |
| 1-byte, then 8-byte | 13.00 |

A masked store forwards, at 3 to 4 ticks more than a plain one, with no stall past that. So the loads above are where
the chain waits, not a fault of their own. A function of one block runs its whole compile as one chain: about a dozen
passes, each a block's work ending in a store that the next pass reads. The twin's work on one entry is short and
independent. That is the IPC difference.

**What would close it:** shortening the chain helps a little:
- P1 and P2 fused into one loop, the variants in registers;
- P3a computed one block ahead inside P3b;
- the values pass and P1 sharing their bitsets in registers.

Each saves a round trip of about 9 to 16 ticks, out of about 350. Closing the 1-entry loss needs something structural,
such as several small functions in one block of the passes, which share the chain's latency. That isn't started here.
