# LICM walks each loop's own blocks (#2979)

#2924's C9 gate ([`../c-ir-gate/`](../c-ir-gate/)) found the unrestricted LICM (`--tier1-passes=+licm`) losing
to its scalar twin on the largest functions: 0.62 at 1,024 Tier 0 entries and more. All timings here are from the
9700X, under the lock on CPU 2, with `--tier1 --tier1-passes=+all -c` of sqlite3.c, Lua 5.4.8 and musl's units on one
lane.

## Why ([`stats/`](stats/))

[`stats/knob-licm.patch`](stats/knob-licm.patch) is the gate's knob (experiment only) plus each function's LICM
statistics: its sweeps, visits, eligible loops and fallbacks, appended to its tick line. [`stats/licm-stats.sh`](stats/licm-stats.sh)
took one run with the vector path (`0`) and one with the twin (`0x80`) ([`stats/ticks-licm.tar.xz`](stats/ticks-licm.tar.xz)).

| Tier 0 entries | Eligible loops | Vector: sweeps | Vector: visits | Twin: visits | Ticks, vector | Ticks, twin |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 18,144 | 250 | 275 | 3,576,053 | 34,534 | 95.6 M | 49.9 M |
| 6,864 | 151 | 157 | 2,802,095 | 18,113 | 66.9 M | 28.1 M |
| 8,471 | 110 | 119 | 1,252,148 | 4,477 | 36.3 M | 21.4 M |
| 4,244 | 102 | 117 | 889,676 | 10,513 | 27.3 M | 16.8 M |

For every eligible loop, the unrestricted motion went over the whole function:
- the vector path swept it to the availability fixed point, so its visits are about loops times the function's
  instructions;
- the twin visited only the queued values, but its initialization of the whole function for each loop costs about as
  much again.

## The change ([`fix-2979.patch`](fix-2979.patch), buster `bf98659ff`)

The vectors policy (#2781) already walked each loop's own blocks once. In reverse postorder a value comes after its
operands (a phi's aside, and a phi doesn't move), so one forward pass finds the movable values. That walk is now
`ir_licm_loop_walk`. The unrestricted motion takes it (`ir_licm_loop_all`) and sends every movable value to the
preheader. `IrLicmOptions.whole` keeps the whole-function algorithm, the sweeps or the worklist, as the exact oracle
of both policies' walks.

## The walk against what it replaced ([`run.sh`](run.sh), [`logs/`](logs/))

One executable: the change plus the gate's knob ([`knob-2979.patch`](knob-2979.patch), experiment only), whose bit 12
sets `whole`. Mask `0` is the walk, `0x1000` the old vector sweeps, and `0x1080` the old twin's worklist.

- **Tests:**
  - `test-ir-licm` passes: 3,578 checks, 0 failures.
  - `test-ir-metamorphic` passes.
  - `test-ir-source --passes` compares the walk with the worklist on every function: 2,668 of sqlite3.c's (777
    changed, 51,897 values moved, 0 failed) and 1,096 of Lua's (229 changed, 0 failed).
- **Objects:** 1,371 of 1,371 byte-identical across the three.
- **Ticks**, three rounds, each function's median, the old algorithm's ticks over the walk's
  ([`logs/compare-0x1000.txt`](logs/compare-0x1000.txt), [`logs/compare-0x1080.txt`](logs/compare-0x1080.txt)):

  | Entries | Functions | Walk, M ticks | Sweeps over walk | Worklist over walk |
  | --- | ---: | ---: | ---: | ---: |
  | 0 to 15 | 1,996 | 39.9 | 1.070 | 1.353 |
  | 16 to 63 | 2,222 | 86.1 | 1.106 | 1.403 |
  | 64 to 255 | 1,790 | 175.4 | 1.157 | 1.427 |
  | 256 to 1,023 | 456 | 173.7 | 1.322 | 1.430 |
  | 1,024 and up | 54 | 123.0 | 3.003 | 1.851 |
  | all | 6,518 | 598.1 | 1.571 | 1.507 |

  Each round's total read 1.568 to 1.575 for the sweeps and 1.505 to 1.508 for the worklist. The other areas read
  0.996 to 1.001 under bit 12. The exception is the inliner's region (1.058), which holds the summaries' own LICM.
