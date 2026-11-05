# 112 more x86 builtins on the 9700X (buster #148, buster#1010)

Four consecutive batches of `__builtin_ia32_` builtins. Each was measured against the commit before it:

| batch | base | head | names |
| --- | --- | --- | ---: |
| `rounded`: AVX-512's arithmetic by a rounding control | `447e1bdc` | `002332f3` | 41 |
| `gathers`: the remaining gathers and scatters, AVX2's vector-mask gathers among them | `002332f3` | `f6dc142c` | 58 |
| `sse`: SSE4.1's roundings and dot products, `aeskeygenassist128`, `sha1rnds4`, `vcvtps2ph` | `f6dc142c` | `d800d103` | 13 |
| `leaves`: the system builtins as leaves (fences, `clflush`, MXCSR, `rdtsc`, `xsetbv`, `lzcnt_u16`) | `d800d103` | `d079be85` | 9 |

## Method

`scripts/measure.sh base head` is buster-performance#186's harness, run once per batch. Each run is one hold of the
host's lock.

1. A drive of each tree, which compares the objects (`runs/BATCH/measure.log`).
2. 8 rounds. In each, every tree compiles each unit 3 times under `perf stat -e instructions:u,cycles:u,task-clock`,
   pinned to CPU 2, with the order of the trees alternated by round.

The units are the frozen `sqlite3.c` with the 9700X job's options and stb_image with `-march=native`, both with `-c`.
`scripts/analyze.py runs/BATCH/measure-UNIT.log base head` gives medians of the rounds' means. In every batch, all 48
runs per unit exited with status 0, and both trees wrote identical objects for both units.

Neither unit calls these builtins, so these numbers measure what the larger row, scope and constraint tables cost code
that doesn't use them.

## Results

| batch | `sqlite3.c` instructions | `sqlite3.c` cycles | stb_image instructions | stb_image cycles |
| --- | ---: | ---: | ---: | ---: |
| rounded | +2,899 (+0.0002%) | +0.05% | +6,228 (+0.0031%) | +0.23% |
| gathers | +10,525 (+0.0007%) | +0.07% | +14,064 (+0.0071%) | −0.74% |
| sse | −211 (−0.0000%) | +0.12% | +3,596 (+0.0018%) | −0.01% |
| leaves | +3,506 (+0.0002%) | +0.26% | +2,217 (+0.0011%) | −0.31% |

The instruction differences are a few thousand per unit, against round-to-round spreads of tens of instructions in
`sqlite3.c` and a few thousand in stb_image. The cycle differences go both ways across batches and units, and stay
within the rounds' own ranges (`analyze.py` prints them). They are consistent with code-placement noise, not a cost
of the changes.

## Tests

`tests/HEAD.status` holds each head's tests on the 9700X, each in a hold of its own (`scripts/BATCH.sh`). Every one
passed at every head:
- `test-checker --program-vectors`, `--seed 133`;
- `test-check-builtins-x86`, `test-check-builtins`;
- `test-builtin-intrinsic-catalog`;
- `test-x86-semantics --cross-check`, `test-tier0 --cross-check`, `test-x86-intrinsics`;
- `test-preprocessor --clang`, `test-checker-driver`;
- the call graph check.

On `002332f3` and `f6dc142c`, hosted CI failed to compile the compiler's own `main.c`. The cause was a test oracle
from the NaN slice, which buster's `45b54d0` fixes. That change touches only a test; the measured compile paths are
the same.
