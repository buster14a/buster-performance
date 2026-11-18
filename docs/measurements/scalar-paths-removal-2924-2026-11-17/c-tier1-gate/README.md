# Tier 1's gate (#2924, C7): main `caa8f6a3e`

This gate measures Tier 1's twins area by area, in one Release executable built from main plus
[`experiment.patch`](experiment.patch), which is for the experiment only.
- `BUSTER_TIER1_SCALAR_AREAS` is a bitmask of the areas whose scalar twin runs:
  - bit 0, selection;
  - bits 1 to 4, the chain consumer's liveness, allocation, rematerialization marks and records;
  - bits 5 to 8, the CFG consumer's problem, allocation, preference and records;
  - bit 9, the schedule.

  The frame colorer has no bit, so it never flips (#2699).
- `BUSTER_TIER1_AREA_TICKS` names a file that gets one line per compiled function: its stage, its IR instructions and
  its TSC ticks in each region.

[`run.sh`](run.sh) runs on the 9700X, under the lock on CPU 2, using [`objects.sh`](objects.sh): `--tier1 -c` of
sqlite3.c, Lua 5.4.8 and musl's units on one lane. It does two things:
1. **Objects:** builds them with each area's bit set alone and with all ten set, and compares each against the
   objects with no bit set.
2. **Ticks:** takes every area on vector (`0`), every area on scalar (`0x3ff`), and the CFG allocation's bit alone
   (`0x40`), three rounds in turn.

[`analyze.py`](analyze.py) sums each region's ticks by the function's IR size, from each function's median over the
rounds.

The run is in progress; the logs and the verdict follow in this directory.
