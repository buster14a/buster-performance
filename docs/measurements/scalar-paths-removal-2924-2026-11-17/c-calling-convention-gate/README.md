# The calling convention's gate (#2924, C5): main `295417ae7`

`benchmark-calling-convention` by main's Release build (`295417ae7`; `calling_convention.c` and the checker's
callers are the same through `bd197b2a6`), both paths interleaved, three processes, each under the lock on CPU 2
([`c5gate.sh`](c5gate.sh)). Seed 1: 32,756 types to classify, 32,768 calls to assign.

The vector paths win every row, in all three processes (`logs/bench-*.log`; process 1's medians):

| Row | Vector | Twin | Vector / twin |
| --- | --- | --- | --- |
| classify-all, 16-byte vectors | 40.5 ns/type | 69.3 | 0.58 |
| classify-all, 32-byte vectors | 44.8 | 70.0 | 0.64 |
| classify-all, 64-byte vectors | 48.2 | 70.7 | 0.68 |
| batches of 1 type | 35.2 ns/type | 54.2 | 0.65 |
| batches of up to 4 | 32.3 | 55.7 | 0.58 |
| batches of up to 16 | 29.7 | 54.8 | 0.54 |
| assign | 3.44 ns/argument | 9.51 | 0.36 |
| assign-simple | 2.88 | 8.90 | 0.32 |

`assign` left 5.17% of its arguments (567 calls, 1.73%) to the twin by design: 219 inexact, 364 padded, 18 empty.
Those calls, the vector paths' scratch exhaustion and the classification scheduler's fallback keep the twins as the
vector paths' fallbacks (phase D); the deletion removes the twins' own entries and every caller that selects them.

## Real compiles ([`real/`](real/))

One experiment build (main `bd197b2a6` plus [`real/c5knob.patch`](real/c5knob.patch), experiment only), whose
`BUSTER_ABI_PATH=scalar` sends the checker's three calling-convention calls to the twins:
- the classification of each part's types;
- the assignment of its calls;
- `va_start`'s single-signature assignment.

[`real/c5knob.sh`](real/c5knob.sh) ran it on the 9700X, every run under the lock.

- **Objects:** `-c` of sqlite3.c, Lua's 34 units and musl's 1,336 units under both settings: 1,371 compared, 0
  differ.
- **Batch sizes** (`BUSTER_ABI_COUNT`, per part):

  | Corpus | Types to classify | Calls to assign |
  | --- | --- | --- |
  | sqlite3.c | 4,740 | median 71, at most 448 |
  | Lua | median 231 | median 45 |
  | musl | median 86 | median 4, 90th percentile 16 |

- **Timings:** `time-runs` of the one executable, the settings alternating over six rounds, each round's median of
  9 runs (`real/logs/time-*.log`). User cycles, median of the six rounds:

  | List | Vector (default) | Twins | Vector / twins |
  | --- | --- | --- | --- |
  | `-c` sqlite3.c | 592.34 M | 592.86 M | 0.9991 |
  | `-c` Lua | 339.36 M | 341.48 M | 0.9938 |
  | `-c` musl | 2,765.33 M | 2,771.47 M | 0.9978 |

  For Lua and musl, every vector round reads below every twin round; sqlite3.c's rounds overlap. Wall time follows:
  0.9992, 0.9964, 0.9978.

The vector paths win on real compiles too, the small parts and the single-signature `va_start` assignment included.
