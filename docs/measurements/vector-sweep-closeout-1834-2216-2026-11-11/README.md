# #1834 and #2216 close-out sweep (2026-11-11)

This is a re-run of #1834's generic vector sweep on current main, to verify the close-out reported in buster14a/buster#1834 and buster14a/buster#2216 (package E1, round E). It compiles each case only. Run-time agreement with clang is checked in Buster itself, by `test-checker --program-vectors`.

## Harness

The harness is unchanged from [`vector-baseline-sweep-1834-2026-11-11`](../vector-baseline-sweep-1834-2026-11-11/): its `gen.py` and `run1.sh` at this repository's `main` `f15390136`. It adds two levels, `x86-64-v4` and `znver5`.

```sh
S=docs/measurements/vector-baseline-sweep-1834-2026-11-11
python3 -I $S/gen.py cases            # 3,389 cases
for m in x86-64 x86-64-v2 x86-64-v3 x86-64-v4 znver5; do
  ls cases/*.c | xargs -P4 -n1 $S/run1.sh BUSTER/build/compiler $m | sort > generic-$m.txt
done
```

## Build

- Buster main `b935fa30` (merge of buster14a/buster#2425).
- A Release build (`./build.sh`) with clang 23.1.6 (`Ubuntu clang version 23.1.6 (++20261108033755+c47d7823685a-1~exp1~20261108153854.96)`).
- It ran in a Claude Code cloud container. Compile-only results aren't timings, so they don't need the 9700X.

## Results

`results/generic-*.txt` have each case's status.

| level | ok | refused by Buster | refused by clang -O0 too |
| --- | ---: | ---: | ---: |
| x86-64 | 3198 | 0 | 191 |
| x86-64-v2 | 3198 | 0 | 191 |
| x86-64-v3 | 3198 | 0 | 191 |
| x86-64-v4 | 3198 | 0 | 191 |
| znver5 | 3198 | 0 | 191 |

So every generic case that clang 23 -O0 compiles also compiles with Buster at the five levels. That matches package D2's report on buster14a/buster#1834.

## Limitations

- The generator's scalar cases are C's integer types of 1 to 8 bytes. `__int128`, `_BitInt` and scalar `clmul`/`pdep`/`pext` aren't in it; they are buster14a/buster#2410.
- The intrinsic-wrapper half of the sweep (`genintrin.py`) wasn't re-run.
- Vectors of more than 1,024 elements aren't generated (buster14a/buster#2269 documents them).
