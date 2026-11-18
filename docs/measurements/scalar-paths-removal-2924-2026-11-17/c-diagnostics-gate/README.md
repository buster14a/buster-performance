# Diagnostics' gate (#2924, C6): main `6eaf73cfd`

`benchmark-diagnostics` on main's Release build plus [`counts.patch`](counts.patch). The patch is for the experiment
only: it adds record counts between the insertion cutoff (256) and 4,096, which the 2026-10-22 measurements in
`docs/determinism.md` didn't cover. [`gate.sh`](gate.sh) runs three processes of each mode under the lock on CPU 2:
- `both`: the two paths interleaved;
- `scalar`: the insertion sort at every count, the twin;
- `selected`: `diagnostic_sort`, which is insertion through 256 records and the AVX-512 radix sort above;
- `selected-after`: the selected path after 100 ms of insertion sorts.

## The gate does not pass

ns/key, the range of the three processes' medians ([`logs/`](logs/)):

| Records | Insertion (interleaved) | Selected (interleaved) | Insertion (alone) | Selected (alone) | Selected after 100 ms |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 32 | 4.48–4.60 | 5.79–6.04 | 4.48–4.53 | 5.79–8.85 | 5.81–5.85 |
| 64 | 7.51–7.68 | 10.96–11.17 | 7.59–7.60 | 10.95–11.01 | 11.01–11.04 |
| 256 | 35.06–35.68 | 53.44–54.26 | 34.68–38.26 | 53.42–53.46 | 53.59–53.73 |
| 257 | 35.18–35.45 | 45.46–63.82 | 35.14–35.30 | 45.25–64.24 | 64.11–65.00 |
| 384 | 48.76–52.74 | 43.32–61.94 | 49.04–49.61 | 43.26–62.29 | 62.12–62.64 |
| 512 | 61.97–62.18 | 43.16–61.80 | 61.87–62.32 | 43.23–62.04 | 61.97–62.60 |
| 1,024 | 121.30–121.62 | 42.99–61.65 | 121.22–121.88 | 42.95–62.00 | 61.85–62.50 |
| 2,048 | 236.55–237.59 | 43.09–61.87 | 235.64–237.45 | 43.05–61.98 | 61.66–62.24 |
| 4,096 | 478.70–482.72 | 43.07–61.77 | 478.44–481.78 | 43.10–61.98 | 61.75–62.28 |

The selected path loses in three places:

1. **Through 256 records.** The selected path runs the same insertion sort there, yet it is 1.29–1.52× slower than the
   twin in every process, interleaved or alone. The algorithm is the same, so the code itself differs:
   `diagnostic_sort`'s copy of the insertion loop against the one inlined at the benchmark's call.
2. **257 to about 512 records.** Insertion beats the radix sort at 257 (35.2 against 45.3 or 64) and at 384 (49 against
   43 or 62), and ties it at 512 in the slower state. The 256 cutoff is below the crossover.
3. **The radix sort runs at one of two rates per process,** about 43 or about 62 ns/key at every count. The rate after
   100 ms of conditioning is always about 62.

## Which state, by placement ([`stack.sh`](stack.sh), [`logs/stack/`](logs/stack/))

The selected path alone, with ASLR off (`setarch -R`) and the stack shifted by an environment variable of 0 to 4,096
bytes:
- **The radix sort at 4,096 records:** 61.6–61.9 ns/key at every pad. With ASLR on, it gave 62.1 in one run and 43.2
  in the other. Its rate follows where the arenas are mapped, not the stack.
- **Insertion at 32 records:** 8.6 ns/key at pads 512 and 3,584, and 5.8 at the other pads. That rate follows the
  stack.

Both are placement states of one executable, not the algorithms. The slower radix state is the one a fixed layout
gives.
