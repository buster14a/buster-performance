# Emitted-code certificate cost on the Ryzen 7 9700X

[PR 3642](https://github.com/buster14a/buster/pull/3642) at `319918e1` compared with merge base `8e4d3287`. Both Release binaries target `znver5` and use official Clang 23.1.4. The repository's `benchmark-tier1-code-certificate` processed the frozen SQLite amalgamation on CPU 2 under one shared lock hold. Both completed successfully and certified the same 2,109 functions over 352,601 IR instructions.

| Phase | ns/IR instruction, base → head | Retired instructions/IR instruction, base → head |
| --- | ---: | ---: |
| Emit | 225.81 → 225.83 | 3,138.45 → 3,138.37 |
| Decode | 104.61 → 96.08 | 1,342.63 → 1,218.36 |
| Check | 75.67 → 76.00 | 1,967.68 → 1,967.68 |
| Certify | 178.12 → 172.86 | 3,310.89 → 3,186.62 |

Decode took 8.15% less time per IR instruction and retired 9.25% fewer instructions. Full certification took 2.95% less time. These values are from the benchmark's internal samples. The separate `--only decode` runs use `perf record -e cycles:u -F 999`. The profiles include preparation and have symbol-level samples for the certificate kernel and records loop. See the raw profiles, text reports and benchmark logs for full coverage and timing.

Agent session: 6b0809fc-8d10-83eb-983d-ee9cae652072 (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6
