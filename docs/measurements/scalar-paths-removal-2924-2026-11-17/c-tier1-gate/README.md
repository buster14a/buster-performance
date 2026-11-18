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


[`sched.sh`](sched.sh) adds the schedule (bit 9), which a plain `-c` doesn't run: three processes of
`benchmark-tier1-schedule`, then `--tier1 --tier1-schedule=post -c` with the schedule on vector (`0`) and on scalar
(`0x200`): objects compared, then three rounds of ticks. [`alloc.sh`](alloc.sh) takes the two allocations that read
even again, five rounds of `0`, `0x4` (the chain consumer's allocation alone) and `0x40` (the CFG allocation alone).
[`compare.py`](compare.py) compares one mask against `0`, by size and round by round.

## Verdict: every area passes

The vector path is at least as fast as its twin in every area and every size bin, within the rounds' spread where
the two read even. Ratios are the scalar twin's ticks over the vector path's, summed from each function's median
(6,553 functions of sqlite3.c, Lua and musl, 4,506 with IR).

**Objects:** with each area's bit set alone and with all ten, 1,371 of 1,371 objects are byte-identical to the
all-vector objects ([`logs/status.txt`](logs/status.txt)). With `--tier1-schedule=post`, the schedule's bit leaves
1,371 of 1,371 identical too ([`logs/sched/status.txt`](logs/sched/status.txt)).

| Area | Bit | Vector, M ticks | Scalar/vector, total | By IR size (1-16, 16-64, 64-256, 256-1024, 1024+) | Log |
| --- | ---: | ---: | ---: | --- | --- |
| Selection | 0 | 372.0 | 1.12 | 1.04, 1.09, 1.13, 1.15, 1.12 | [analyze](logs/analyze.txt) |
| Chain: liveness | 1 | 2.3 | 1.04 | 1.04, 1.04, 1.04 | [analyze](logs/analyze.txt) |
| Chain: allocation | 2 | 2.1 | 1.0030 | 1.0033, 1.0021, 1.0009; rounds 0.986 to 1.010 | [alloc](logs/alloc/compare-0x4.txt) |
| Chain: rematerialization marks | 3 | 1.5 | 1.05 | 1.05, 1.06, 1.07 | [analyze](logs/analyze.txt) |
| Chain: records | 4 | 5.4 | 1.00 | 1.00, 1.01, 1.01 | [analyze](logs/analyze.txt) |
| CFG: problem | 5 | 198.8 | 1.04 | 1.03, 1.04, 1.04, 1.04, 1.03 | [analyze](logs/analyze.txt) |
| CFG: allocation alone | 6 | 588.2 | 1.0002 | 1.0004, 1.0003, 1.0004, 1.0004, 0.9999; rounds 0.998 to 1.002 | [alloc](logs/alloc/compare-0x40.txt) |
| CFG: allocation with preference | 6, 7 | 588.1 | 1.02 | 1.01, 1.01, 1.02, 1.02, 1.02 | [analyze](logs/analyze.txt) |
| CFG: records | 8 | 379.3 | 1.01 | 1.00, 1.01, 1.02, 1.01, 1.01 | [analyze](logs/analyze.txt) |
| Schedule (`post`) | 9 | 161.8 | 1.286 | 1.15, 1.29, 1.29, 1.30, 1.29; rounds 1.283 to 1.286 | [sched](logs/sched/compare-0x200.txt) |

The chain consumer runs only on functions without branches, so its bins stop at 256. The preference's ticks lie
inside the CFG allocation's region, so its bit is read with the allocation's: `0x3ff` flips both and `0x40` the
allocation alone.

`benchmark-tier1-schedule`, three processes ([`logs/sched/`](logs/sched/)): the scalar schedule with its copy and
encoding takes 193.0 to 193.6 ns a record, the vector one 153.4 to 153.6.

The two allocations read even: the chain consumer's twin is 0.3% slower in total and the CFG allocation's 0.02%, with
each round's total between 0.986 and 1.010. Neither is a loss for the vector path, and the gate's rule (the vector path
at least as fast) holds, so the twins go. The frame colorer's twin stays until #2699 is fixed; it never flipped here.
