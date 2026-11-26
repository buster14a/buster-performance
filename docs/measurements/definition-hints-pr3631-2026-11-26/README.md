# Tier 1 late-definition register hints on the Ryzen 7 9700X

[PR 3631](https://github.com/buster14a/buster/pull/3631) head `171b5cdd` compared with merge base `8e4d3287`. Both Release compilers target `znver5` and use official Clang 23.1.4. They compiled the frozen SQLite speedtest1 mix1 input and Lua 5.4.8 with Tier 1. Each binary was linked with four padding lengths, and each pair ran seven times alternately on CPU 2 under the shared Benchpress lock. SQLite's verification hash and the five Lua script outputs matched across all placements.

| Text padding | SQLite user cycles, M, base → head | Lua user cycles, M, base → head | Lua user instructions, M, base → head |
| --- | ---: | ---: | ---: |
| 0 B | 672.69 → 672.11 | 987.38 → 978.87 | 4,518.92 → 4,504.26 |
| 16 B | 678.95 → 682.70 | 964.07 → 974.71 | 4,519.63 → 4,505.29 |
| 32 B | 671.55 → 677.45 | 977.56 → 985.29 | 4,519.63 → 4,505.95 |
| 48 B | 680.80 → 671.76 | 974.22 → 969.61 | 4,519.77 → 4,502.36 |

SQLite retired about 0.043% fewer instructions at every padding. Lua retired 0.30–0.39% fewer instructions. Cycle changes went in both directions across settings, from −1.33% to +0.88% for SQLite and −0.86% to +1.10% for Lua. Both dispatch symbols sweep four offsets within a 64-byte line for each revision. The two revisions' initial addresses differ, and the table compares equal linker padding. Lua totals sum the five script medians.

The raw archive contains all 336 timed observations with outputs, perf counters and verification hashes. The per-side placement files record the dispatch symbol addresses.

Agent session: 6b0809fc-8d10-83eb-983d-ee9cae652072 (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6
