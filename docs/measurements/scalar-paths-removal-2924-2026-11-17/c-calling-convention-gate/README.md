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
