# Diagnostics: the vector paths win at every count (#2959)

The fix for #2924 module 6's gate ([`../c-diagnostics-gate/`](../c-diagnostics-gate/)). Every run here is on the
9700X under the lock on CPU 2, from main `6eaf73cfd`'s Release build plus the patches named, all of them for the
experiment only.

## Why the radix sort ran at two rates

**The cause:** the radix sort's `ranks` array is filled by one 64-byte store and read back four bytes at a time. Where
the stack fell, that store split across two cache lines in some processes and not others.

The evidence is in [`../c-diagnostics-gate/logs/counters/`](../c-diagnostics-gate/logs/counters/),
[`stack/`](../c-diagnostics-gate/logs/stack/) and [`align/`](../c-diagnostics-gate/logs/align/):
- **Counters:** eight processes with ASLR on. The fast and slow ones retire the same instructions, 3.48–3.56 G, but the
  slow ones take 1,570 M cycles against 1,120 M. Neither has DTLB misses or extra mispredictions.
- **Stack pads:** with ASLR off, every process ran slow, whatever the environment pad from 0 to 4,096 bytes. The pads
  were multiples of 64, so they never moved the stack's alignment within a cache line.
- **Aligned:** with `digits` and `ranks` aligned to 64 bytes ([`../c-diagnostics-gate/align.patch`](../c-diagnostics-gate/align.patch)),
  all ten processes ran at 43.1–43.4 ns/key at 4,096 records, ASLR on or off. Loads crossing a 64-byte line fell to a
  fixed 33 M.

## The small path

In [`../c-diagnostics-gate/variants/`](../c-diagnostics-gate/variants/) the twin's insertion loop and
`diagnostic_sort`'s copy of it are the same instructions placed differently. The copy took 1.07–1.5 times as long.

[`logs/`](logs/) is `cutoff.sh` with [`fix.patch`](fix.patch): a 128-bit-key insertion in a 64-byte-aligned function
of its own. It beat the twin in a standalone harness, but in the Release build it lost at every count, for example
47.0 against 34.8–40.8 ns/key at 256 records.

The fix counts each record's place instead (`diagnostic_sort_small`). The count is the number of records before it in
the order: those with a smaller (source, sequence), and those with equal keys and a smaller index. The work is
O(n²/8) and branch-free, 8 keys at a time.

[`logs2/`](logs2/) is `cutoff2.sh` with [`fix2.patch`](fix2.patch) and [`knob2.patch`](knob2.patch), the cutoff set at
run time. Against the radix sort's 43.6 ns/key, the count sort took:

| Records | Count sort (ns/key) |
| ---: | ---: |
| 384 | 28.7 |
| 512 | 36.4 |
| 768 | 51.7 |
| 1,024 | 67.2 |

The crossover is near 640, so the cutoff is 512. At 32 records the count sort was even with the twin; taking the key
columns with permutes ([`fix3.patch`](fix3.patch)) made it at least as fast.

## The final form ([`logs3/`](logs3/), `final.sh`, `fix3.patch` + `counts3.patch`)

The twin's insertion interleaved with `diagnostic_sort`, three processes, ns/key:

| Records | Insertion | Selected | Insertion / selected (medians) | Selected after 100 ms |
| ---: | ---: | ---: | ---: | ---: |
| 32 | 4.47–4.50 | 4.45–4.52 | 1.00 | 4.46–4.50 |
| 64 | 7.51–7.52 | 7.21–7.22 | 1.04 | 7.22–7.25 |
| 128 | 16.96–17.45 | 13.41–13.42 | 1.27 | 13.45–13.47 |
| 256 | 29.28–30.70 | 21.21–21.22 | 1.38 | 21.26–21.28 |
| 384 | 50.76–50.85 | 28.87–29.20 | 1.76 | 28.96–28.98 |
| 512 | 60.18–60.28 | 36.51–36.87 | 1.65 | 36.56–36.65 |
| 513 | 62.44–62.53 | 43.74–43.86 | 1.43 | 43.69–43.92 |
| 640 | 77.35–77.56 | 43.04–43.12 | 1.80 | 43.20–43.99 |
| 768 | 89.94–90.16 | 42.98–43.12 | 2.09 | 43.09–43.78 |
| 1,024 | 124.06–124.20 | 43.06–43.16 | 2.88 | 43.17–43.73 |
| 2,048 | 235.25–235.28 | 43.01–43.09 | 5.47 | 43.06–43.35 |
| 4,096 | 473.01–473.77 | 43.10–43.19 | 10.96 | 43.24–43.40 |

The selected path is at least as fast as the twin at every count, and the radix sort runs in one state in every
process. buster's commit for this is "Diagnostics: the vector paths win at every count (#2959)".
