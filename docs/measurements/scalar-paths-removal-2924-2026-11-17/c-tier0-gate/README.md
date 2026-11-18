# Tier 0's and the unwind analyzer's gate (#2924, C8): #2971's head `c280bdca9`

This gate measures four twins area by area, in one Release executable built from `c280bdca9` plus
[`experiment.patch`](experiment.patch), which is for the experiment only.
- `BUSTER_TIER0_SCALAR_AREAS` is a bitmask of the areas whose scalar twin runs:
  - bit 0, Tier 0's compile (`tier0_compile_scalar` for `tier0_compile`);
  - bit 1, its validation (`tier0_validate_scalar`, the scalar validator alone, for `tier0_validate`, which takes a
    stream by its vector path and leaves the ones it doesn't take to the scalar validator);
  - bit 2, its inlining (`tier0_inline_scalar` for `tier0_inline`);
  - bit 3, `--verify`'s unwind analyzer (`unwind_tier0_scalar` for `unwind_tier0`).
- `BUSTER_TIER0_AREA_TICKS` names a file that each call appends one line to, in call order: its area, its Tier 0
  entries and its TSC ticks.

[`run.sh`](run.sh) runs on the 9700X, under the lock on CPU 2, using [`objects.sh`](objects.sh): `-c --verify` of
sqlite3.c, Lua 5.4.8, musl's units and buster's own `main.c` (whose intrinsics Tier 0's inlining splices) on one lane.
It does two things:
1. **Objects:** builds them with each area's bit set alone and with all four set, and compares each against the
   objects with no bit set.
2. **Ticks:** takes every area on vector (`0`) and every area on scalar (`0xf`), five rounds in turn.

[`analyze.py`](analyze.py) pairs the k-th call of an area across runs, takes its median over the rounds and sums the
ticks by the call's Tier 0 entries. [`small.py`](small.py) splits the smallest bins finer, and [`rounds.py`](rounds.py)
reads them round by round.

## Verdict: inlining and the unwind analyzer pass; compile and validation don't, below 16 entries

**Objects:** with each area's bit set alone and with all four, 1,372 of 1,372 objects are byte-identical to the
all-vector objects ([`logs/status.txt`](logs/status.txt)).

Ratios are the scalar twin's ticks over the vector path's ([`logs/analyze.txt`](logs/analyze.txt)):

| Area | Calls | Vector, M ticks | Scalar/vector | By entries (0-16, 16-64, 64-256, 256-1024, 1024+) | Rounds |
| --- | ---: | ---: | ---: | --- | --- |
| Compile | 7,960 | 76.5 | 2.24 | 1.23, 1.89, 2.44, 2.84, 2.37 | 2.23 to 2.28 |
| Validation | 7,961 | 18.9 | 2.31 | **0.91**, 1.93, 2.97, 3.28, 2.91 | 2.28 to 2.33 |
| Inlining | 137 | 7.7 | 1.12 | 1.16, 1.12, 1.15, 1.13, 1.11 | 1.12 to 1.13 |
| Unwind analyzer | 5,210 | 16.9 | 2.39 | 1.54, 2.03, 2.41, 2.52, 2.54 | 2.39 |

The smallest bins, finer ([`logs/small-bins.txt`](logs/small-bins.txt), [`logs/small-rounds.txt`](logs/small-rounds.txt)):

| Area | Entries | Calls | Scalar/vector, round by round |
| --- | --- | ---: | --- |
| Compile | 0 to 1 | 45 | 0.866, 0.888, 0.878, 0.926, 0.889 |
| Compile | 2 to 3 | 188 | 0.976, 1.007, 0.999, 1.008, 0.998 |
| Validation | 0 to 3 | 234 | 0.842, 0.881, 0.886, 0.878, 0.873 |
| Validation | 4 to 15 | 2,006 | 0.897, 0.914, 0.916, 1.042, 0.905 |
| Inlining | 4 to 7 | 5 | 1.199, 1.222, 1.229, 1.205, 1.210 |
| Inlining | 8 to 15 | 64 | 1.090, 1.087, 1.095, 1.088, 1.095 |
| Unwind analyzer | 0 to 3 | 84 | 1.156, 1.155, 1.208, 1.156, 1.134 |
| Unwind analyzer | 4 to 7 | 108 | 1.129, 1.109, 1.121, 1.106, 1.126 |
| Unwind analyzer | 8 to 15 | 434 | 1.681, 1.660, 1.659, 1.653, 1.648 |

- **Inlining and the unwind analyzer** win in every bin and every round: their twins can go (C8a).
- **Compile** loses on functions of 0 and 1 entries (45 calls, 7% to 13% in every round), is even at 2 and 3 entries,
  and wins from 4 on.
- **Validation** loses below 16 entries (2,240 calls): at 0 to 3 entries in every round (12% to 16%), at 4 to 15 in four rounds of five (8% to 10%). It wins from 16 on, 1.27
  times at 16 to 23 and 1.91 at 24 to 31 ([`logs/small-bins.txt`](logs/small-bins.txt)).

On both paths, the calls below 16 entries cost more ticks each than those of 16 to 31 entries (validation's vector
path: 2,758 ticks a call at 12 to 15 entries, 1,159 at 24 to 31). So what these calls pay is not their entries: it is
each call's fixed cost, which the vector paths pay more of. Their twins stay until the vector paths win there too.
