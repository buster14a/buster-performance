# Physical replay of the Tier 1 accumulator fold for PR 3628

The [PR](https://github.com/buster14a/buster/pull/3628) is the regression guard for the already-merged [two-arm fold](https://github.com/buster14a/buster/pull/3174). This run compares its head `a22e53593` with merge base `8e4d32879` on Benchpress. Both Release compilers used official Clang 23.1.4 and compiled the historical #2922 kernel with Tier 1 strict, `-march=znver5` and vectorization disabled. The driver tests 1,048,576 elements in 80 passes.

Across four address paddings (0, 16, 32, 48 bytes), five base/head pairs per kernel were interleaved on CPU 2 under the shared lock. All 120 timed runs matched the independent Clang output. The current base and head emit identical disassembled instructions. The control kernels are `best` and `sum`.

| Padding | Equality loop, median user cycles (millions), base → head |
| --- | ---: |
| 0 | 140.42 → 140.44 |
| 16 | 140.40 → 140.43 |
| 32 | 140.40 → 144.35 |
| 48 | 140.64 → 140.60 |

The median across the four placements was about 140.4 million user cycles for each revision. The 32-byte placement's cycle variation occurred with identical instruction counts and disassembly. See `results.txt`, the per-side disassemblies, and the raw perf archive for details.

The driver and kernels are from the pinned [measurement record](https://github.com/buster14a/buster-performance/tree/cc38ca9708f522fd26eacab3b5234dbfa71c131b/docs/measurements/tier1-float-equality-select-2922-2026-11-17/9700x/kernels2).

Agent session: 6b0809fc-8d10-83eb-983d-ee9cae652072 (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6
