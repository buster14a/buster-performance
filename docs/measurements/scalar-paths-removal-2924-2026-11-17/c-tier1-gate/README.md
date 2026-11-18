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

## The debug metadata, and which bits reach different code

[`debug.sh`](debug.sh) added the debug metadata, bit 10 (`-g` runs it: `check_tier1_debug` and
`c_check_tier1_debug*.c`), in [`experiment-debug.patch`](experiment-debug.patch). Its first run on main `caa8f6a3e`
([`logs/debug/`](logs/debug/)) failed 9 units under `-g`, 8 of them with #2870's certificate refusal, and every
object differed by its directory. [`debug2.sh`](debug2.sh) takes #2913's fix (`38a848237`, cherry-picked), compiles
every mask in one directory and keeps each compile's standard error ([`logs/debug2/`](logs/debug2/)). One unit,
musl's `pthread_barrier_wait.c`, still fails under `-g` either way: a different certificate refusal, #2963.

**Debug metadata (bit 10):** 1,370 of 1,370 objects identical with `0x400` and with `0x200` under `-g`. Ticks, three
rounds ([`compare-0x400`](logs/debug2/compare-0x400.txt)): scalar/vector 1.010 in total (1,161 M ticks on vector),
1.024, 1.025, 1.019, 1.012 and 1.004 by IR size, each round 1.010 to 1.012. It passes.

**The knobs' control** (`debug2.sh`, step 2): user instructions retired by `--tier1 -c` of the three corpora with each
bit set alone. Without `-g` the schedule doesn't run, so `0x200` is the negative control. Mask `0`, run first, read
91 k above the cluster that `0x2`, `0x4` and `0x200` share within 3 k:

| Mask | User instructions | Against `0x200` |
| --- | ---: | ---: |
| `0` | 19,688,379,382 | +88,599 |
| `0x1` | 19,950,979,683 | +262,688,900 |
| `0x2` | 19,688,287,615 | -3,168 |
| `0x4` | 19,688,288,537 | -2,246 |
| `0x8` | 19,688,167,424 | -123,359 |
| `0x10` | 19,688,278,521 | -12,262 |
| `0x20` | 19,719,314,627 | +31,023,844 |
| `0x40` | 19,690,883,064 | +2,592,281 |
| `0x80` | 19,710,533,845 | +22,243,062 |
| `0x100` | 19,700,343,436 | +12,052,653 |
| `0x200` | 19,688,290,783 | +0 |
| `0` with `-g` | 35,705,150,776 | |
| `0x400` with `-g` | 35,727,492,448 | +22,341,672 against `0` with `-g` |

Selection, the CFG consumer's four areas, the chain consumer's rematerialization marks and the debug metadata change
the work. **The chain consumer's liveness (`0x2`) and allocation (`0x4`) don't, on these corpora:**
- the allocation's flag changes only fixed-range filtering (`tier1_allocation_filter_fixed`), which the chain
  consumer's functions here don't reach;
- the liveness's vector arms are the dense cross-block rows, which straight-line functions barely have.

Their 1.04 and 1.003 readings in the ticks above came from the other areas' scalar twins running in the same process,
not their own.

[`synth.sh`](synth.sh) takes them to synthetic functions ([`logs/synth/`](logs/synth/)):
- `benchmark-tier1-select --only vector`, each chain area's bit set alone, three rounds
  ([summary](logs/synth/select-summary.txt)); scalar/vector of the complete rows by shape (chain, wide, pressure):
  - liveness: 0.998, 1.003, 0.997. The scalar twin retires 595 k more instructions a process, but the time is even;
  - allocation: 0.995, 1.006, 1.003, with the same instructions to within 200. The arms don't diverge here either;
  - rematerialization marks: 1.001, 1.018, 1.003;
  - records: 1.004, 1.014, 1.001.
- `benchmark-tier1-allocation`, three processes: its `vector` and `scalar` rows call the same body with the flag set
  and clear, and none of its workloads has fixed ranges. So the two run the same code: they read 0.5% to 2% apart
  in both directions (the vector row faster at 16 intervals, slower at 128 and 2,048), which is this benchmark's noise
  between two rows, not the twin.

**So every area passes.** Where a twin's code diverges, the vector path is faster, or even within the rounds' spread
while retiring fewer instructions. These are the CFG allocation (+2.5 M instructions for scalar, ticks 0.998 to 1.002
by round) and the chain liveness on synthetic functions. Where it doesn't diverge (the chain allocation), deleting
the twin removes code that does the same work.
