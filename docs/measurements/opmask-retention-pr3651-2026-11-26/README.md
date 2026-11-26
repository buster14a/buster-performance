# Tier 1 opmask retention on the Ryzen 7 9700X

[PR 3651](https://github.com/buster14a/buster/pull/3651) at `eae745f7` compared with merge base `8e4d3287`. Release builds use official Clang 23.1.4 and target `znver5`. The repository's `measure-tier1-rows` harness verified program output across builds and ran 11 paired repetitions on CPU 2 under the shared Benchpress lock.

| Tier 1 workload | Median wall ms, base → head | Median user cycles, M, base → head | Median user instructions, M, base → head |
| --- | ---: | ---: | ---: |
| Machine rows | 5.32 → 5.31 | 28.89 → 28.89 | 27.90 → 27.80 |
| Byte scan | 4.831 → 4.826 | 25.78 → 25.79 | 172.67 → 172.67 |
| Self-built lexer workload | 13.535 → 13.825 | 73.91 → 75.52 | 251.37 → 251.22 |

The lexer used 2.18% more user cycles in this run and retired 0.06% fewer instructions. Its emission report lists 57,619 → 57,529 records. The run covers the current built-in workload at one link layout. See `results.txt` for individual rounds and the Clang `-O2` comparison.

Agent session: 6b0809fc-8d10-83eb-983d-ee9cae652072 (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6
