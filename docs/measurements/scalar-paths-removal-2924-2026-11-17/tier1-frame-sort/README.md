# #3450: the frame planner's radix fallback, a rejected vector radix

#3450's Tier 1 item "the frame planner's `tier1_frame_sort` (radix) past 8 class keys or 64 events". Session:
`session_01EgbxndFreFrJqAywiEGoue`. **Result: not replaced.** The vectorized radix below loses past about 96
objects, so the scalar radix stays under the owner's rule, until a vector sort that wins at every size exists.

## Census

These counts come from the tier1-frame record's dumps of every frame request of `--tier1 -c` of sqlite3.c, Lua and
musl. That is 4,505 frames, all of them indexed.

| corpus | frames | more than 64 events (radix) | a ninth class (radix) | indices sorted (no stamp room) |
| --- | ---: | ---: | ---: | ---: |
| sqlite3.c | 1,388 | 29 | 1 | 0 |
| Lua | 638 | 1 | 0 | 0 |
| musl | 2,479 | 58 | 6 | 0 |

## The attempt

`vector-radix.diff`, on main 4b0e65e7, made three changes:
- **The radix pass:** `tier1_frame_sort` stays a stable LSD radix over the bytes that differ, but takes 16 keys a
  step. The digits are in one register, and conflict masks rank the lanes within their bucket, so only a bucket's
  last lane moves its cursor. The stores use scalar addresses, and the 256 buckets' offsets are a 16-lane scan
  (the pattern of `c_bindings_sort` and the moves resolver's wide form).
- **The class assignment:** the assignment after the sort uses mask compares with the predecessors and popcount
  prefixes.
- **The uniqueness check:** adjacent equal indices are compared eight pairs a step.

The plans are identical. `test-tier1-frame`'s frozen digest is unchanged, and so are the digests at seeds 7, 11
and 1234 against main's code. Every replayed frame and every synthetic frame planned the same on both sides.

## Gate (cloud container, not the 9700X: enough to reject)

`gate.c` and `side.c` link main's `tier1_frame_plan` and the branch's into one executable. Each plan is timed by
rdtsc, and each result is the median of 21 alternating passes.

**Synthetic frames** (`synth-local.txt`), new over old. Lower is better:

| objects | ≤ 4 classes | ≤ 12 classes |
| ---: | ---: | ---: |
| 33 to 64 | 0.81 to 0.97 | 0.75 to 0.81 |
| 96 | 0.98 | 1.02 |
| 128 | 1.00 | 1.04 |
| 256 | 1.21 | 1.28 |
| 1,024 | 1.40 | 1.55 |
| 32,768 | 1.20 | 1.30 |

**Real frames** (`replay-local*.txt`): the vector radix wins on musl's frames past 32 objects (0.79 to 0.89). It
loses on sqlite3.c's (1.03 to 1.12 past 64 objects). Overall it reads 0.945 on musl, 1.003 on sqlite3.c and 0.997 on
Lua.

The reason: the conflict masks, the reduction and the per-lane store loop cost more per key than the scalar radix's
plain increment and store. The count phase pays the most, since it needs no ranks at all.

## What would have to win

A sort that beats the scalar radix at every size from 65 events to 2^31 objects, with the same stable order.
Candidates:
- the rank sort, the all-pairs compares of up to 64 events, extended further (quadratic, so only to a bound);
- an in-register bitonic network of 16 keys with vector merges past it;
- a count phase without conflicts: all digit histograms of a pass gathered in one read, digits extracted 16 at a
  time.

Each must keep the radix order, which ranks equal keys by input place.
